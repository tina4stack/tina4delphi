unit TwigParser;

interface

uses
  SysUtils, Classes, StrUtils, System.Rtti, Generics.Collections, System.JSON;

type
  TTwigTagType = (
    ttApply, ttAutoescape, ttBlock, ttCache, ttDeprecated, ttDo, ttEmbed,
    ttExtends, ttFlush, ttFor, ttFrom, ttIf, ttImport, ttInclude,
    ttMacro, ttSandbox, ttSet, ttUse, ttVerbatim, ttWith, ttUnknown
  );
  TTwigNode = record
    TagType: TTwigTagType;
    Content: string;
    Variables: TStringList;
    Filters: TStringList;
    Functions: TStringList;
    Children: TList;
  end;
  PTwigNode = ^TTwigNode;

  TFilterFunc = function(const Input: TValue; var Context: TDictionary<string, TValue>; const Param: string): TValue;
  TFunctionFunc = function(var Context: TDictionary<string, TValue>; const Param: string): TValue;

function ParseTwigTemplate(const Template: string): TTwigNode;
function RenderTwigTemplate(const Template: string; Context: TDictionary<string, TValue> = nil): string;
function RenderNode(const Node: TTwigNode; var Context: TDictionary<string, TValue>): string;
procedure FreeTwigNode(var Node: TTwigNode);

const
  TwigTagNames: array[ttApply .. ttWith] of string = (
    'apply', 'autoescape', 'block', 'cache', 'deprecated', 'do', 'embed',
    'extends', 'flush', 'for', 'from', 'if', 'import', 'include',
    'macro', 'sandbox', 'set', 'use', 'verbatim', 'with'
  );
  NestableTags: set of TTwigTagType = [
    ttApply, ttAutoescape, ttBlock, ttEmbed, ttFor, ttIf,
    ttMacro, ttSandbox, ttVerbatim, ttWith
  ];

implementation

var
  Filters: TDictionary<string, TFilterFunc>;
  Functions: TDictionary<string, TFunctionFunc>;

function UpperFilter(const Input: TValue; var Context: TDictionary<string, TValue>; const Param: string): TValue;
begin
  Result := TValue.From<string>(UpperCase(Input.ToString));
end;

function DefaultFilter(const Input: TValue; var Context: TDictionary<string, TValue>; const Param: string): TValue;
var
  DefaultValue: TValue;
begin
  if Input.ToString = '[undefined]' then
  begin
    if (Context <> nil) and Context.TryGetValue(Param, DefaultValue) then
      Result := DefaultValue
    else
      Result := TValue.From<string>(Param);
  end
  else
    Result := Input;
end;

function SliceFilter(const Input: TValue; var Context: TDictionary<string, TValue>; const Param: string): TValue;
var
  Parts: TArray<string>;
  StartIdx, Count, EndIdx, I: Integer;
  List: TList<TValue>;
  StringList: TStringList;
  NewList: TList<TValue>;
  Items: TArray<string>;
begin
  Parts := Param.Split([',']);
  if Length(Parts) = 2 then
  begin
    StartIdx := StrToIntDef(Trim(Parts[0]), 0);
    Count := StrToIntDef(Trim(Parts[1]), MaxInt);
    if Input.TryAsType<TList<TValue>>(List) then
    begin
      NewList := TList<TValue>.Create;
      try
        if StartIdx >= 0 then
        begin
          EndIdx := StartIdx + Count - 1;
          if EndIdx >= List.Count then
            EndIdx := List.Count - 1;
          for I := StartIdx to EndIdx do
            if I < List.Count then
              NewList.Add(List[I]);
          Result := TValue.From<TList<TValue>>(NewList);
        end
        else
          Result := TValue.From<TList<TValue>>(NewList);
      except
        NewList.Free;
        raise;
      end;
    end
    else if Input.TryAsType<TStringList>(StringList) then
    begin
      NewList := TList<TValue>.Create;
      try
        if StartIdx >= 0 then
        begin
          EndIdx := StartIdx + Count - 1;
          if EndIdx >= StringList.Count then
            EndIdx := StringList.Count - 1;
          for I := StartIdx to EndIdx do
            if I < StringList.Count then
              NewList.Add(TValue.From<string>(StringList[I]));
          Result := TValue.From<TList<TValue>>(NewList);
        end
        else
          Result := TValue.From<TList<TValue>>(NewList);
      except
        NewList.Free;
        raise;
      end;
    end
    else
    begin
      Items := Input.ToString.Split([','], TStringSplitOptions.ExcludeEmpty);
      if (StartIdx >= 0) and (StartIdx < Length(Items)) then
      begin
        if Count > Length(Items) - StartIdx then
          Count := Length(Items) - StartIdx;
        Result := TValue.From<string>(String.Join(',', Items, StartIdx, Count));
      end
      else
        Result := TValue.From<string>('');
    end;
  end
  else
    Result := Input;
end;

function JoinFilter(const Input: TValue; var Context: TDictionary<string, TValue>; const Param: string): TValue;
var
  Separator: TValue;
  List: TList<TValue>;
  StringList: TStringList;
  Items: TArray<string>;
  I: Integer;
begin
  if (Context <> nil) and Context.TryGetValue(Param, Separator) then
    Separator := Separator.ToString
  else
    Separator := Param;
  if Input.TryAsType<TList<TValue>>(List) then
  begin
    SetLength(Items, List.Count);
    for I := 0 to List.Count - 1 do
      Items[I] := List[I].ToString;
    Result := TValue.From<string>(String.Join(Separator.ToString, Items));
  end
  else if Input.TryAsType<TStringList>(StringList) then
    Result := TValue.From<string>(String.Join(Separator.ToString, StringList.ToStringArray))
  else
    Result := TValue.From<string>(StringReplace(Input.ToString, ',', Separator.ToString, [rfReplaceAll]));
end;

function RangeFunction(var Context: TDictionary<string, TValue>; const Param: string): TValue;
var
  Parts: TArray<string>;
  StartIdx, EndIdx, I: Integer;
  ResultList: TList<TValue>;
begin
  Parts := Param.Split([',']);
  if Length(Parts) >= 2 then
  begin
    StartIdx := StrToIntDef(Trim(Parts[0]), 1);
    EndIdx := StrToIntDef(Trim(Parts[1]), 1);
    ResultList := TList<TValue>.Create;
    try
      for I := StartIdx to EndIdx do
        ResultList.Add(TValue.From<string>(IntToStr(I)));
      Result := TValue.From<TList<TValue>>(ResultList);
    except
      ResultList.Free;
      raise;
    end;
  end
  else
    Result := TValue.From<string>('1');
end;

procedure ExtractElements(const Content: string; Variables, Filters, Functions: TStringList);
var
  I: Integer;
  Token, Current: string;
  InFunction, InString: Boolean;
  StringChar: Char;
begin
  Variables.Clear;
  Filters.Clear;
  Functions.Clear;
  Current := Trim(Content);
  InFunction := False;
  InString := False;
  StringChar := #0;
  I := 1;
  Token := '';

  while I <= Length(Current) do
  begin
    if (Current[I] in ['''', '"']) then
    begin
      if InString and (Current[I] = StringChar) then
        InString := False
      else if not InString then
      begin
        InString := True;
        StringChar := Current[I];
      end;
    end
    else if not InString then
    begin
      if Current[I] = '(' then InFunction := True
      else if Current[I] = ')' then InFunction := False;
    end;

    if not InString and ((Current[I] in [' ', '|', '(', ')', ',']) or (I = Length(Current))) then
    begin
      if (I = Length(Current)) and not (Current[I] in [' ', '|', '(', ')', ',']) then
        Token := Token + Current[I];
      if Token <> '' then
      begin
        if InFunction then
        begin
          if Pos('(', Token) > 0 then
            Functions.Add(Trim(Token))
          else if Token[1] in ['a'..'z', 'A'..'Z'] then
            Functions.Add(Trim(Token));
        end
        else if (Token[1] = '|') then
          Filters.Add(Trim(Copy(Token, 2, Length(Token))))
        else if (Pos('(', Token) = 0) then
          Variables.Add(Trim(Token));
        Token := '';
      end;
      Inc(I);
    end
    else
    begin
      Token := Token + Current[I];
      Inc(I);
    end;
  end;
end;

function IdentifyTag(const Tag: string): TTwigTagType;
var
  LowerTag, TagName: string;
  t: TTwigTagType;
begin
  LowerTag := LowerCase(Trim(Tag));
  TagName := Copy(LowerTag, 1, Pos(' ', LowerTag + ' ') - 1);
  Result := ttUnknown;
  for t := Low(TwigTagNames) to High(TwigTagNames) do
    if TwigTagNames[t] = TagName then
    begin
      Result := t;
      Exit;
    end;
end;

function ParseTwigTemplate(const Template: string): TTwigNode;
var
  Root, CurrentNode: TTwigNode;
  NodeStack: TList;
  CurrentPos, StartPos, EndPos: Integer;
  TagContent, TextContent: string;
  TagType: TTwigTagType;
  NewNode: PTwigNode;
  IsClosing: Boolean;
begin
  Root.TagType := ttUnknown;
  Root.Content := '';
  Root.Variables := TStringList.Create;
  Root.Filters := TStringList.Create;
  Root.Functions := TStringList.Create;
  Root.Children := TList.Create;
  NodeStack := TList.Create;
  NodeStack.Add(@Root);
  CurrentNode := Root;
  CurrentPos := 1;

  while CurrentPos <= Length(Template) do
  begin
    StartPos := CurrentPos;
    while (StartPos <= Length(Template)) and (Copy(Template, StartPos, 2) <> '{%') do
      Inc(StartPos);

    if StartPos > CurrentPos then
    begin
      TextContent := Copy(Template, CurrentPos, StartPos - CurrentPos);
      New(NewNode);
      NewNode^.TagType := ttUnknown;
      NewNode^.Content := TextContent;
      NewNode^.Variables := TStringList.Create;
      NewNode^.Filters := TStringList.Create;
      NewNode^.Functions := TStringList.Create;
      NewNode^.Children := TList.Create;
      CurrentNode.Children.Add(NewNode);
    end;

    if StartPos <= Length(Template) then
    begin
      Inc(CurrentPos, 2); // Skip '{%'
      EndPos := CurrentPos;
      while (EndPos <= Length(Template)) and (Copy(Template, EndPos, 2) <> '%}') do
        Inc(EndPos);

      if EndPos <= Length(Template) then
      begin
        TagContent := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
        TagType := IdentifyTag(TagContent);
        IsClosing := (Pos('end', LowerCase(TagContent)) = 1);

        New(NewNode);
        NewNode^.TagType := TagType;
        NewNode^.Content := TagContent;
        NewNode^.Variables := TStringList.Create;
        NewNode^.Filters := TStringList.Create;
        NewNode^.Functions := TStringList.Create;
        ExtractElements(TagContent, NewNode^.Variables, NewNode^.Functions, NewNode^.Filters);

        if (TagType in NestableTags) and not IsClosing then
        begin
          CurrentNode.Children.Add(NewNode);
          CurrentNode := NewNode^;
          NodeStack.Add(@CurrentNode);
        end
        else if (TagType in NestableTags) and IsClosing then
        begin
          if NodeStack.Count > 1 then
          begin
            NodeStack.Delete(NodeStack.Count - 1);
            CurrentNode := PTwigNode(NodeStack.Last)^;
          end;
          Dispose(NewNode);
        end
        else
        begin
          CurrentNode.Children.Add(NewNode);
        end;

        CurrentPos := EndPos + 2; // Skip '%}'
      end
      else
        CurrentPos := Length(Template) + 1;
    end
    else
      CurrentPos := Length(Template) + 1;
  end;

  NodeStack.Free;
  Result := Root;
end;

function FromJSONValue(const JSON: TJSONValue): TValue;
var
  List: TList<TValue>;
  Dict: TDictionary<string, TValue>;
  Arr: TJSONArray;
  Obj: TJSONObject;
  Pair: TJSONPair;
  I: Integer;
begin
  if JSON = nil then
    Exit(TValue.Empty);

  if JSON is TJSONNull then
    Result := TValue.Empty
  else if JSON is TJSONTrue then
    Result := True
  else if JSON is TJSONFalse then
    Result := False
  else if JSON is TJSONNumber then
    Result := TJSONNumber(JSON).AsDouble
  else if JSON is TJSONString then
    Result := TJSONString(JSON).Value
  else if JSON is TJSONArray then
  begin
    Arr := TJSONArray(JSON);
    List := TList<TValue>.Create;
    try
      for I := 0 to Arr.Count - 1 do
        List.Add(FromJSONValue(Arr.Items[I]));
      Result := TValue.From<TList<TValue>>(List);
    except
      List.Free;
      raise;
    end;
  end
  else if JSON is TJSONObject then
  begin
    Obj := TJSONObject(JSON);
    Dict := TDictionary<string, TValue>.Create;
    try
      for I := 0 to Obj.Count - 1 do
      begin
        Pair := Obj.Pairs[I];
        if Pair.JsonString <> nil then
          Dict.AddOrSetValue(Pair.JsonString.Value, FromJSONValue(Pair.JsonValue));
      end;
      Result := TValue.From<TDictionary<string, TValue>>(Dict);
    except
      Dict.Free;
      raise;
    end;
  end
  else
    Result := TValue.Empty;
end;

procedure FreeTValue(const V: TValue);
var
  List: TList<TValue>;
  Dict: TDictionary<string, TValue>;
  StringList: TStringList;
  Item: TValue;
begin
  if V.IsObject then
  begin
    if V.TryAsType<TList<TValue>>(List) then
    begin
      for Item in List do
        FreeTValue(Item);
      List.Free;
    end
    else if V.TryAsType<TDictionary<string, TValue>>(Dict) then
    begin
      for Item in Dict.Values do
        FreeTValue(Item);
      Dict.Free;
    end
    else if V.TryAsType<TStringList>(StringList) then
      StringList.Free;
  end;
end;

function ResolvePath(const Path: string; const Context: TDictionary<string, TValue>): TValue;
var
  S, Key: string;
  P, IndexStart, IndexEnd, Index: Integer;
  Current: TValue;
  List: TList<TValue>;
  Dict: TDictionary<string, TValue>;
  StringList: TStringList;
begin
  S := Trim(Path);
  P := Pos('.', S);
  if P = 0 then P := Pos('[', S);
  if P = 0 then
  begin
    if Context.TryGetValue(S, Current) then
      Result := Current
    else
      Result := TValue.Empty;
    Exit;
  end;
  Key := Trim(Copy(S, 1, P - 1));
  if not Context.TryGetValue(Key, Current) then
    Exit(TValue.Empty);
  S := Copy(S, P, MaxInt);
  while S <> '' do
  begin
    if S[1] = '.' then
    begin
      Delete(S, 1, 1);
      P := Pos('.', S);
      if P = 0 then P := Pos('[', S);
      if P = 0 then P := Length(S) + 1;
      Key := Trim(Copy(S, 1, P - 1));
      if Current.TryAsType<TDictionary<string, TValue>>(Dict) then
      begin
        if not Dict.TryGetValue(Key, Current) then
          Exit(TValue.Empty);
      end
      else
        Exit(TValue.Empty);
      S := Copy(S, P, MaxInt);
    end
    else if S[1] = '[' then
    begin
      IndexStart := 1;
      IndexEnd := Pos(']', S);
      if IndexEnd = 0 then Exit(TValue.Empty);
      Key := Trim(Copy(S, 2, IndexEnd - 2));
      Index := StrToIntDef(Key, -1);
      if Index = -1 then Exit(TValue.Empty);
      if Current.TryAsType<TList<TValue>>(List) then
      begin
        if (Index >= 0) and (Index < List.Count) then
          Current := List[Index]
        else
          Exit(TValue.Empty);
      end
      else if Current.TryAsType<TStringList>(StringList) then
      begin
        if (Index >= 0) and (Index < StringList.Count) then
          Current := TValue.From<string>(StringList[Index])
        else
          Exit(TValue.Empty);
      end
      else
        Exit(TValue.Empty);
      S := Copy(S, IndexEnd + 1, MaxInt);
    end
    else
      Exit(TValue.Empty);
  end;
  Result := Current;
end;

function RenderChildren(const Node: TTwigNode; var Context: TDictionary<string, TValue>): string;
var
  I: Integer;
  ChildNode: PTwigNode;
begin
  Result := '';
  if Assigned(Node.Children) then
    for I := 0 to Node.Children.Count - 1 do
    begin
      ChildNode := PTwigNode(Node.Children[I]);
      Result := Result + RenderNode(ChildNode^, Context);
    end;
end;

function RenderNode(const Node: TTwigNode; var Context: TDictionary<string, TValue>): string;
var
  Rendered, Expression, VarName, FilterName, Param, ValueStr, ItemVar, ListVar: string;
  StartPos, EndPos, PipePos, I: Integer;
  VarValue, ItemValue: TValue;
  LocalContext: TDictionary<string, TValue>;
  Parts: TArray<string>;
  Func: TFilterFunc;
  FuncProc: TFunctionFunc;
  JSON: TJSONValue;
  ListValue: TList<TValue>;
  StringList: TStringList;
  Items: TArray<string>;
begin
  Rendered := '';

  if Context = nil then
    LocalContext := TDictionary<string, TValue>.Create
  else
    LocalContext := Context;
  try
    case Node.TagType of
      ttUnknown:
        begin
          Rendered := Node.Content;
          StartPos := Pos('{{', Rendered);
          while StartPos > 0 do
          begin
            EndPos := PosEx('}}', Rendered, StartPos + 2);
            if EndPos = 0 then Break;
            Expression := Trim(Copy(Rendered, StartPos + 2, EndPos - StartPos - 2));
            PipePos := Pos('|', Expression);
            if PipePos > 0 then
            begin
              VarName := Trim(Copy(Expression, 1, PipePos - 1));
              FilterName := Trim(Copy(Expression, PipePos + 1, MaxInt));
            end
            else
            begin
              VarName := Expression;
              FilterName := '';
            end;

            // Resolve variable or function once
            if Pos('(', VarName) > 0 then
            begin
              FilterName := Trim(Copy(VarName, 1, Pos('(', VarName) - 1));
              Param := Trim(Copy(VarName, Pos('(', VarName) + 1, Pos(')', VarName) - Pos('(', VarName) - 1));
              if Functions.TryGetValue(FilterName, FuncProc) then
                VarValue := FuncProc(LocalContext, Param)
              else
                VarValue := TValue.Empty;
            end
            else
              VarValue := ResolvePath(VarName, LocalContext);

            if VarValue.IsEmpty then
              ValueStr := '[undefined]'
            else
              ValueStr := VarValue.ToString;

            // Apply filter if present
            if FilterName <> '' then
            begin
              if Pos('(', FilterName) > 0 then
              begin
                Param := Trim(Copy(FilterName, Pos('(', FilterName) + 1, Pos(')', FilterName) - Pos('(', FilterName) - 1));
                FilterName := Trim(Copy(FilterName, 1, Pos('(', FilterName) - 1));
              end
              else
                Param := '';
              if Filters.TryGetValue(FilterName, Func) then
                VarValue := Func(VarValue, LocalContext, Param);
              ValueStr := VarValue.ToString;
            end;

            Delete(Rendered, StartPos, EndPos - StartPos + 2);
            Insert(ValueStr, Rendered, StartPos);
            StartPos := Pos('{{', Rendered);
          end;
          Rendered := Rendered + RenderChildren(Node, LocalContext);
        end;
      ttSet:
        begin
          if Pos(' = ', Node.Content) > 0 then
          begin
            Parts := Node.Content.Split([' = ']);
            if Length(Parts) = 2 then
            begin
              VarName := Trim(Parts[0].Substring(3));
              Expression := Trim(Parts[1]);
              PipePos := Pos('|', Expression);
              if PipePos > 0 then
              begin
                ValueStr := Trim(Copy(Expression, 1, PipePos - 1));
                FilterName := Trim(Copy(Expression, PipePos + 1, MaxInt));
              end
              else
              begin
                ValueStr := Expression;
                FilterName := '';
              end;

              if (Length(ValueStr) > 2) and (ValueStr[1] in ['[', '{']) then
              begin
                JSON := TJSONValue.ParseJSONValue(ValueStr);
                if JSON <> nil then
                try
                  VarValue := FromJSONValue(JSON);
                finally
                  JSON.Free;
                end;
              end
              else if Pos('(', ValueStr) > 0 then
              begin
                FilterName := Trim(Copy(ValueStr, 1, Pos('(', ValueStr) - 1));
                Param := Trim(Copy(ValueStr, Pos('(', ValueStr) + 1, Pos(')', ValueStr) - Pos('(', ValueStr) - 1));
                if Functions.TryGetValue(FilterName, FuncProc) then
                  VarValue := FuncProc(LocalContext, Param)
                else
                  VarValue := TValue.Empty;
              end
              else if (Length(ValueStr) > 2) and (ValueStr[1] in ['''', '"']) and
                      (ValueStr[Length(ValueStr)] = ValueStr[1]) then
                VarValue := TValue.From<string>(Copy(ValueStr, 2, Length(ValueStr) - 2))
              else if Pos('.', ValueStr) > 0 then
                VarValue := ResolvePath(ValueStr, LocalContext)
              else
                VarValue := TValue.From<string>(ValueStr);

              if VarValue.IsEmpty then
                ValueStr := '[undefined]'
              else
                ValueStr := VarValue.ToString;

              LocalContext.AddOrSetValue(VarName, VarValue);

              if FilterName <> '' then
              begin
                if Pos('(', FilterName) > 0 then
                begin
                  Param := Trim(Copy(FilterName, Pos('(', FilterName) + 1, Pos(')', FilterName) - Pos('(', FilterName) - 1));
                  FilterName := Trim(Copy(FilterName, 1, Pos('(', FilterName) - 1));
                end
                else
                  Param := '';
                if Filters.TryGetValue(FilterName, Func) then
                  LocalContext.AddOrSetValue(VarName, Func(VarValue, LocalContext, Param));
              end;
            end;
          end;
        end;
      ttIf:
        begin
          if Node.Variables.Count > 0 then
          begin
            VarName := Node.Variables[0];
            if Pos('(', VarName) > 0 then
            begin
              FilterName := Trim(Copy(VarName, 1, Pos('(', VarName) - 1));
              Param := Trim(Copy(VarName, Pos('(', VarName) + 1, Pos(')', VarName) - Pos('(', VarName) - 1));
              if Functions.TryGetValue(FilterName, FuncProc) then
                VarValue := FuncProc(LocalContext, Param)
              else
                VarValue := TValue.Empty;
            end
            else
              VarValue := ResolvePath(VarName, LocalContext);

            for I := 0 to Node.Filters.Count - 1 do
            begin
              FilterName := Node.Filters[I];
              Param := '';
              for Expression in Node.Functions do
              begin
                if Pos(FilterName + '(', Expression) = 1 then
                begin
                  Param := Copy(Expression, Length(FilterName) + 2, Length(Expression) - Length(FilterName) - 2);
                  Break;
                end;
              end;
              if Filters.TryGetValue(FilterName, Func) then
                VarValue := Func(VarValue, LocalContext, Param);
            end;

            if not VarValue.IsEmpty and (VarValue.ToString <> '') then
              Rendered := RenderChildren(Node, LocalContext);
          end;
        end;
      ttFor:
        begin
          if Pos(' in ', Node.Content) > 0 then
          begin
            Parts := Node.Content.Split([' in ']);
            if Length(Parts) = 2 then
            begin
              ItemVar := Trim(Parts[0].Substring(3));
              ListVar := Trim(Parts[1]);
              if Pos('(', ListVar) > 0 then
              begin
                FilterName := Trim(Copy(ListVar, 1, Pos('(', ListVar) - 1));
                Param := Trim(Copy(ListVar, Pos('(', ListVar) + 1, Pos(')', ListVar) - Pos('(', ListVar) - 1));
                if Functions.TryGetValue(FilterName, FuncProc) then
                  VarValue := FuncProc(LocalContext, Param)
                else
                  VarValue := TValue.Empty;
              end
              else
                VarValue := ResolvePath(ListVar, LocalContext);

              for I := 0 to Node.Filters.Count - 1 do
              begin
                FilterName := Node.Filters[I];
                Param := '';
                for Expression in Node.Functions do
                begin
                  if Pos(FilterName + '(', Expression) = 1 then
                  begin
                    Param := Copy(Expression, Length(FilterName) + 2, Length(Expression) - Length(FilterName) - 2);
                    Break;
                  end;
                end;
                if Filters.TryGetValue(FilterName, Func) then
                  VarValue := Func(VarValue, LocalContext, Param);
              end;

              ListValue := TList<TValue>.Create;
              try
                if VarValue.TryAsType<TList<TValue>>(ListValue) then
                  // ListValue is already set
                else if VarValue.TryAsType<TStringList>(StringList) then
                begin
                  ListValue.Clear;
                  for Param in StringList do
                    ListValue.Add(TValue.From<string>(Param));
                end
                else if VarValue.Kind in [tkString, tkLString, tkWString, tkUString ] then
                begin
                  ListValue.Clear;
                  Items := VarValue.ToString.Split([','], TStringSplitOptions.ExcludeEmpty);
                  for Param in Items do
                    ListValue.Add(TValue.From<string>(Param));
                end;

                for ItemValue in ListValue do
                begin
                  LocalContext := TDictionary<string, TValue>.Create(LocalContext);
                  try
                    LocalContext.AddOrSetValue(ItemVar, ItemValue);
                    Rendered := Rendered + RenderChildren(Node, LocalContext);
                  finally
                    LocalContext.Free;
                  end;
                end;
              finally
                ListValue.Free;
              end;
            end;
          end;
        end;
      ttWith:
        Rendered := RenderChildren(Node, LocalContext);
      ttApply:
        begin
          Rendered := RenderChildren(Node, LocalContext);
          for I := 0 to Node.Filters.Count - 1 do
          begin
            FilterName := Node.Filters[I];
            Param := '';
            for Expression in Node.Functions do
            begin
              if Pos(FilterName + '(', Expression) = 1 then
              begin
                Param := Copy(Expression, Length(FilterName) + 2, Length(Expression) - Length(FilterName) - 2);
                Break;
              end;
            end;
            if Filters.TryGetValue(FilterName, Func) then
              Rendered := Func(TValue.From<string>(Rendered), LocalContext, Param).ToString;
          end;
        end;
      ttBlock:
        Rendered := RenderChildren(Node, LocalContext);
      ttVerbatim:
        Rendered := RenderChildren(Node, LocalContext);
      ttExtends, ttInclude:
        Rendered := '[' + TwigTagNames[Node.TagType] + ': ' + Node.Content + ']';
      ttMacro:
        Rendered := '[macro: ' + Node.Content + ']';
      else
        Rendered := RenderChildren(Node, LocalContext);
    end;
  finally
    if Context = nil then
    begin
      for VarValue in LocalContext.Values do
        FreeTValue(VarValue);
      LocalContext.Free;
    end;
  end;

  Result := Rendered;
end;

function RenderTwigTemplate(const Template: string; Context: TDictionary<string, TValue> = nil): string;
var
  RootNode: TTwigNode;
begin
  RootNode := ParseTwigTemplate(Template);
  try
    Result := RenderNode(RootNode, Context);
  finally
    FreeTwigNode(RootNode);
  end;
end;

procedure FreeTwigNode(var Node: TTwigNode);
var
  I: Integer;
  ChildNode: PTwigNode;
begin
  if Assigned(Node.Children) then
  begin
    for I := 0 to Node.Children.Count - 1 do
    begin
      ChildNode := PTwigNode(Node.Children[I]);
      FreeTwigNode(ChildNode^);
      Dispose(ChildNode);
    end;
    Node.Children.Free;
  end;
  Node.Variables.Free;
  Node.Filters.Free;
  Node.Functions.Free;
end;

initialization
  Filters := TDictionary<string, TFilterFunc>.Create;
  Filters.Add('upper', UpperFilter);
  Filters.Add('default', DefaultFilter);
  Filters.Add('slice', SliceFilter);
  Filters.Add('join', JoinFilter);
  Functions := TDictionary<string, TFunctionFunc>.Create;
  Functions.Add('range', RangeFunction);

finalization
  Filters.Free;
  Functions.Free;

end.
