unit Tina4Twig;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math, Variants;


type
  TStringDict = TDictionary<String, TValue>;
  TFilterFunc = reference to function(const Input: String; const Args: TArray<String>): String;
  TFunctionFunc = reference to function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String;


  TTina4Twig = class(TObject)
  private
    FContext: TDictionary<String, TValue>;
    FFilters: TDictionary<String, TFilterFunc>;
    FFunctions: TDictionary<String, TFunctionFunc>;
    FTemplatePath: String;
    function LoadTemplate(const TemplateName: String): String;
    function ReplaceContextVariables(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateIfBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateIncludes(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateForBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateSetBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateWithBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function RemoveComments(const Template: String): String;
    function ParseVariableDict(const DictStr: String; OuterContext: TDictionary<String,TValue>): TDictionary<String,TValue>;
    function RenderInternal(const TemplateOrContent: String; Context: TStringDict): String;
    function ResolveVariablePath(const VariablePath: string): TValue;
  public
    constructor Create(const TemplatePath: String = '');
    destructor Destroy; override;
    procedure SetVariable(AName: string; AValue: TValue);
    function Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;
    procedure RegisterDefaultFilters;
  end;


implementation

{ TTwig }

function JsonEncodeString(const S: string): string;
var
  JsonStr: TJSONString;
begin
  JsonStr := TJSONString.Create(S);
  try
    Result := JsonStr.ToString; // This outputs the string quoted and escaped as JSON string literal
  finally
    JsonStr.Free;
  end;
end;


constructor TTina4Twig.Create(const TemplatePath: String);
begin
  inherited Create;
  FContext := TDictionary<String, TValue>.Create;

  if TemplatePath = '' then
  begin
    FTemplatePath := ExtractFileDir(ParamStr(0));
  end
    else
  begin
    FTemplatePath := TemplatePath;
  end;
  FTemplatePath := IncludeTrailingPathDelimiter(FTemplatePath);


  FFilters := TDictionary<String, TFilterFunc>.Create;

  RegisterDefaultFilters;

  FFunctions := TDictionary<String, TFunctionFunc>.Create;

  FFunctions.Add('dump',
  function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
  var
    I, J: Integer;
    DumpResult: TStringList;
    Value: TValue;
    Arr: TArray<TValue>;
    Dict: TDictionary<String, TValue>;
    Pair: TPair<String, TValue>;
  begin
    DumpResult := TStringList.Create;
    try
      if Length(Args) = 0 then
        Exit('(no arguments)');

      for I := 0 to High(Args) do
      begin
        if not Context.TryGetValue(Args[I], Value) then
        begin
          DumpResult.Add(Args[I] + ' = (not found)');
          Continue;
        end;

        if Value.IsArray then
        begin
          DumpResult.Add(Args[I] + ' = [');
          Arr := Value.AsType<TArray<TValue>>;
          for J := 0 to High(Arr) do
            DumpResult.Add('  [' + IntToStr(J) + '] = ' + Arr[J].ToString);
          DumpResult.Add(']');
        end
        else if Value.IsObject and (Value.AsObject is TDictionary<String, TValue>) then
        begin
          Dict := TDictionary<String, TValue>(Value.AsObject);
          DumpResult.Add(Args[I] + ' = {');
          for Pair in Dict do
            DumpResult.Add('  ' + Pair.Key + ': ' + Pair.Value.ToString);
          DumpResult.Add('}');
        end
        else
        begin
          DumpResult.Add(Args[I] + ' = ' + Value.ToString);
        end;
      end;

      Result := '<pre>' + DumpResult.Text + '</pre>';
    finally
      DumpResult.Free;
    end;
  end);

  FFunctions.Add('range',
  function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
  var
    i, startNum, endNum: Integer;
    Output: TStringBuilder;
  begin
    if Length(Args) < 2 then
      Exit('[]');

    startNum := StrToIntDef(Args[0], 0);
    endNum := StrToIntDef(Args[1], 0);

    Output := TStringBuilder.Create;
    try
      Output.Append('[');
      for i := startNum to endNum do
      begin
        if i > startNum then
          Output.Append(',');
        Output.Append(IntToStr(i));
      end;
      Output.Append(']');
      Result := Output.ToString;
    finally
      Output.Free;
    end;
  end);
end;

destructor TTina4Twig.Destroy;
begin

  FFilters.Free;
  FFunctions.Free;
  FContext.Free;

  inherited;
end;


function TTina4Twig.RemoveComments(const Template: String): String;
var
  Regex: TRegEx;
begin
  // This regex matches {# ... #} including multiline comments (non-greedy)
  Regex := TRegEx.Create('{#.*?#}', [roSingleLine, roMultiLine]);

  // Replace all matches with empty string
  Result := Regex.Replace(Template, '');
end;

function TTina4Twig.EvaluateIfBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, Op, ValueRaw, IfContent, ElseContent, Replacement: String;
  VarValue, CompareValue: TValue;
  HasCondition: Boolean;
  IsEqual: Boolean;

  function TrimQuotes(const S: String): String;
  begin
    Result := S;
    if ((Result.StartsWith('"') and Result.EndsWith('"')) or
        (Result.StartsWith('''') and Result.EndsWith(''''))) and
       (Result.Length >= 2) then
      Result := Result.Substring(1, Result.Length - 2);
  end;

  function ParseValue(const S: String): TValue;
  var
    LowerVal: String;
    IntVal: Int64;
    FloatVal: Double;
    BoolVal: Boolean;
  begin
    LowerVal := S.ToLower;
    if LowerVal = 'true' then
      Exit(TValue.From<Boolean>(True))
    else if LowerVal = 'false' then
      Exit(TValue.From<Boolean>(False));

    if TryStrToInt64(S, IntVal) then
      Exit(TValue.From<Int64>(IntVal));

    if TryStrToFloat(S, FloatVal) then
      Exit(TValue.From<Double>(FloatVal));

    // Fallback as string
    Exit(TValue.From<string>(S));
  end;

  function ValuesAreEqual(const A, B: TValue): Boolean;
  begin
    if A.Kind <> B.Kind then
    begin
      // Optionally try to compare numeric types even if kind differs
      if (A.IsOrdinal) and (B.IsOrdinal) then
        Result := A.AsExtended = B.AsExtended
      else
        Result := False;
      Exit;
    end;

    case A.Kind of
      tkInteger, tkInt64, tkEnumeration:
        Result := A.AsInt64 = B.AsInt64;
      tkFloat:
        Result := Abs(A.AsExtended - B.AsExtended) < 1E-12;
      tkString, tkLString, tkWString, tkUString:
        Result := A.AsString = B.AsString;
      tkClass:
        Result := A.AsObject = B.AsObject;
    else
      Result := False;
    end;
  end;


begin
  Result := Template;
  Regex := TRegEx.Create(
    '{%\s*if\s+([\w\.]+)(\s*(==|!=)\s*(".*?"|''.*?''|\d+(\.\d+)?|true|false))?\s*%}(.*?)({%\s*else\s*%}(.*?))?{%\s*endif\s*%}',
    [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value;

    HasCondition := Match.Groups[2].Success;
    if HasCondition then
    begin
      Op := Match.Groups[3].Value;
      ValueRaw := Match.Groups[4].Value;
      ValueRaw := TrimQuotes(ValueRaw);
      CompareValue := ParseValue(ValueRaw);
    end
    else
    begin
      Op := '';
      CompareValue := TValue.Empty;
    end;

    if Op = '' then
    begin
      HasCondition := False;
    end;

    IfContent := Match.Groups[6].Value;
    ElseContent := '';
    if Match.Groups[7].Success then
      ElseContent := Match.Groups[8].Value;

    // Resolve VarValue from Context dictionary with nested properties if needed
    if not Context.TryGetValue(VarName, VarValue) then
    begin
      // or just consider it false
      VarValue := TValue.Empty;
    end;

    if not HasCondition then
    begin
      // Treat VarValue as boolean
      if VarValue.IsEmpty then
        IsEqual := False
      else if VarValue.Kind = tkString then
        IsEqual := (VarValue.AsString.ToLower = 'true')
      else if VarValue.Kind = tkInteger then
        IsEqual := VarValue.AsInteger <> 0
      else if VarValue.Kind = tkFloat then
        IsEqual := VarValue.AsExtended <> 0.0
      else if VarValue.Kind = tkEnumeration then
        IsEqual := VarValue.AsBoolean
      else if VarValue.IsObject then
        IsEqual := True // non-nil object considered true
      else
        IsEqual := False;
    end
    else
    begin
      if Op = '==' then
        IsEqual := ValuesAreEqual(VarValue, CompareValue)
      else if Op = '!=' then
        IsEqual := not ValuesAreEqual(VarValue, CompareValue);
    end;

    if IsEqual then
      Replacement := IfContent
    else
      Replacement := ElseContent;

    Result := Result.Replace(FullMatch, Replacement, [rfReplaceAll]);
  end;
end;


function TTina4Twig.ReplaceContextVariables(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, FuncName, ArgsStr: String;
  Args: TArray<String>;
  TempVal: TValue;
  Func: TFunctionFunc;
begin
  Result := Template;
  Regex := TRegEx.Create('{{\s*([\w\.]+|\w+\(([^)]*)\))\s*}}', [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    VarName := Trim(Match.Groups[1].Value);

    if VarName.Contains('(') and VarName.EndsWith(')') then
    begin
      FuncName := Copy(VarName, 1, Pos('(', VarName) - 1);
      ArgsStr := Copy(VarName, Pos('(', VarName) + 1, Length(VarName) - Pos('(', VarName) - 1);
      Args := ArgsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
      for var I := 0 to High(Args) do
        Args[I] := Trim(Args[I]);

      if FFunctions.TryGetValue(FuncName, Func) then
      begin
        Result := StringReplace(Result, FullMatch, Func(Args, Context), [rfReplaceAll]);
        Continue;
      end
      else
      begin
        Result := StringReplace(Result, FullMatch, '(function ' + FuncName + ' not found)', [rfReplaceAll]);
        Continue;
      end;
    end;

    // Try direct variable lookup
    if Context.TryGetValue(VarName, TempVal) then
    begin
      Result := StringReplace(Result, FullMatch, TempVal.ToString, [rfReplaceAll]);
      Continue;
    end;

    // Try dot notation
    TempVal := ResolveVariablePath(VarName);
    if not TempVal.IsEmpty then
    begin
      Result := StringReplace(Result, FullMatch, TempVal.ToString, [rfReplaceAll]);
      Continue;
    end;

    Result := StringReplace(Result, FullMatch, '(not found)', [rfReplaceAll]);
  end;
end;

function TTina4Twig.ResolveVariablePath(const VariablePath: string): TValue;
var
  Parts: TArray<string>;
  Current: TValue;
  i: Integer;
  Key: string;
  Dict: TDictionary<String, TValue>;
begin
  Parts := VariablePath.Split(['.']);

  if not FContext.TryGetValue(Parts[1], Current) then
    Exit(TValue.Empty);

  for i := 1 to High(Parts) do
  begin
    Key := Parts[i];

    var Avalue := Current.AsString;

    if (Current.Kind = tkClass) and (Current.AsObject <> nil) and
       (Current.AsObject is TDictionary<String, TValue>) then
    begin
      Dict := TDictionary<String, TValue>(Current.AsObject);
      if Dict.TryGetValue(Key, Current) then
        Continue
      else
        Exit(TValue.Empty);
    end
    else
      Exit(TValue.Empty);
  end;

  Result := Current;
end;



function TTina4Twig.LoadTemplate(const TemplateName: String): String;
var
  TemplateFile: TStringList;
  FullPath: String;
begin
  TemplateFile := TStringList.Create;
  try
    // Combine the base path with the template name
    FullPath := IncludeTrailingPathDelimiter(FTemplatePath) + TemplateName;

    // Check if the file exists
    if not FileExists(FullPath) then
      raise Exception.Create('Template not found: ' + FullPath);

    // Load the file content
    TemplateFile.LoadFromFile(FullPath);

    Result := RemoveComments(TemplateFile.Text);
  finally
    TemplateFile.Free;
  end;
end;

function TTina4Twig.ParseVariableDict(const DictStr: String;
  OuterContext: TDictionary<String, TValue>): TDictionary<String, TValue>;
var
  Content: String;
  Pairs: TArray<String>;
  Pair: String;
  KV: TArray<String>;
  Key, Value : String;
  V: TValue;
  Dict: TDictionary<String,TValue>;
  I: Integer;
begin
  Dict := TDictionary<String,TValue>.Create;

  Content := Trim(DictStr);  // Use global Trim function

  if (Content.StartsWith('{')) and (Content.EndsWith('}')) then
    Content := Content.Substring(1, Content.Length - 2).Trim;

  if Content = '' then
    Exit(Dict);

  Pairs := Content.Split([',']);
  for I := 0 to High(Pairs) do
  begin
    Pair := Pairs[I].Trim;
    KV := Pair.Split([':']);
    if Length(KV) = 2 then
    begin
      Key := KV[0].Trim;
      Value := KV[1].Trim;

      // Remove optional quotes around key and value (e.g., "key" : "value")
      if (Key.StartsWith('"') and Key.EndsWith('"')) or (Key.StartsWith('''') and Key.EndsWith('''')) then
        Key := Key.Substring(1, Key.Length - 2);

      if (Value.StartsWith('"') and Value.EndsWith('"')) or (Value.StartsWith('''') and Value.EndsWith('''')) then
        Value := Value.Substring(1, Value.Length - 2);

      // Try resolve Value from OuterContext if exists
      if OuterContext <> nil then
        if OuterContext.TryGetValue(Value, V) then
          Dict.AddOrSetValue(Key, V)
        else
          Dict.AddOrSetValue(Key, Value)
      else
        Dict.AddOrSetValue(Key, Value);
    end;
  end;

  Result := Dict;
end;

function TTina4Twig.EvaluateIncludes(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, IncludeName, WithRaw, IncludeContent: String;
  IncludeContext, ParsedDict: TDictionary<String, TValue>;
  Pair: TPair<String, TValue>;

  function ParseVariableDict(const DictStr: String; BaseContext: TDictionary<String, TValue>): TDictionary<String, TValue>;
  var
    CleanStr: String;
    Pairs, KeyVal: TArray<String>;
    I: Integer;
    Key, ValStr: String;
    Val: TValue;
    Int64Val: Int64;
    FloatVal: Double;
  begin
    Result := TDictionary<String, TValue>.Create;
    CleanStr := DictStr.Trim;
    if CleanStr.StartsWith('{') and CleanStr.EndsWith('}') then
      CleanStr := CleanStr.Substring(1, CleanStr.Length - 2).Trim
    else
      Exit;

    if CleanStr = '' then Exit;

    Pairs := CleanStr.Split([','], TStringSplitOptions.ExcludeEmpty);
    for I := 0 to High(Pairs) do
    begin
      KeyVal := Pairs[I].Split([':'], 2);
      if Length(KeyVal) = 2 then
      begin
        Key := KeyVal[0].Trim;
        ValStr := KeyVal[1].Trim;

        // Try resolve ValStr from BaseContext (e.g. variable name)
        if BaseContext.TryGetValue(ValStr, Val) then
          Result.Add(Key, Val)
        else if TryStrToInt64(ValStr, Int64Val) then
          Result.Add(Key, TValue.From<Int64>(Int64Val))
        else if TryStrToFloat(ValStr, FloatVal) then
          Result.Add(Key, TValue.From<Double>(FloatVal))
        else
        begin
          // Remove quotes if any
          if (ValStr.StartsWith('"') and ValStr.EndsWith('"')) or
             (ValStr.StartsWith('''') and ValStr.EndsWith('''')) then
            ValStr := ValStr.Substring(1, ValStr.Length - 2);
          Result.Add(Key, TValue.From<String>(ValStr));
        end;
      end;
    end;
  end;

begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*include\s+["'']([^"''}]+)["''](?:\s+with\s+(\{[^\}]*\}))?\s*%}', [roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    IncludeName := Match.Groups[1].Value;
    WithRaw := '';
    if Match.Groups.Count > 2 then
      WithRaw := Match.Groups[2].Value;

    IncludeContext := TDictionary<String, TValue>.Create;
    try
      // Copy current context
      for Pair in Context do
        IncludeContext.AddOrSetValue(Pair.Key, Pair.Value);

      // Merge variables from with { ... }
      if WithRaw <> '' then
      begin
        ParsedDict := ParseVariableDict(WithRaw, Context);
        try
          for Pair in ParsedDict do
            IncludeContext.AddOrSetValue(Pair.Key, Pair.Value);
        finally
          ParsedDict.Free;
        end;
      end;

      IncludeContent := LoadTemplate(IncludeName);
      IncludeContent := RenderInternal(IncludeContent, IncludeContext);
    except
      on E: Exception do
        IncludeContent := '';
    end;
    IncludeContext.Free;

    Result := StringReplace(Result, FullMatch, IncludeContent, [rfReplaceAll]);
  end;
end;




function TTina4Twig.EvaluateSetBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  VarName, ValueStr: String;
  Value: TValue;
  JSONValue: TJSONValue;
  Dict: TDictionary<String, TValue>;
  Arr: TArray<TValue>;
  I: Int64;
  F: Double;
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*set\s+(\w+)\s*=\s*(\{[^\}]*\}|\[[^\]]*\])\s*%}', [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    VarName := Match.Groups[1].Value.Trim;
    ValueStr := Match.Groups[2].Value.Trim;

    if ValueStr.StartsWith('[') and ValueStr.EndsWith(']') then
    begin
      ValueStr := Copy(ValueStr, 2, Length(ValueStr) - 2).Trim;
      if ValueStr = '' then
        Arr := []
      else
      begin
        var Items := ValueStr.Split([','], TStringSplitOptions.ExcludeEmpty);
        SetLength(Arr, Length(Items));
        for I := 0 to High(Items) do
        begin
          var Item := Items[I].Trim;
          if (Item.StartsWith('"') and Item.EndsWith('"')) or
             (Item.StartsWith('''') and Item.EndsWith('''')) then
            Item := Copy(Item, 2, Length(Item) - 2)
          else if Item.ToLower = 'true' then
            Item := 'True'
          else if Item.ToLower = 'false' then
            Item := 'False'
          
          else if TryStrToFloat(Item, F) then
            Item := Item;
          Arr[I] := TValue.From(Item);
        end;
      end;
      Value := TValue.From<TArray<TValue>>(Arr);
    end
    else if ValueStr.StartsWith('{') and ValueStr.EndsWith('}') then
    begin
      JSONValue := TJSONObject.ParseJSONValue(ValueStr);
      try
        if JSONValue is TJSONObject then
        begin
          Dict := TDictionary<String, TValue>.Create;
          for var Pair in TJSONObject(JSONValue) do
          begin
            if Pair.JsonValue is TJSONNumber then
              Dict.Add(Pair.JsonString.Value, TValue.From(Pair.JsonValue.AsType<Double>))
            else if Pair.JsonValue is TJSONTrue then
              Dict.Add(Pair.JsonString.Value, TValue.From(True))
            else if Pair.JsonValue is TJSONFalse then
              Dict.Add(Pair.JsonString.Value, TValue.From(False))
            else
              Dict.Add(Pair.JsonString.Value, TValue.From(Pair.JsonValue.Value));
          end;
          Value := TValue.From<TDictionary<String, TValue>>(Dict);
        end
        else
          Value := TValue.Empty;
      finally
        JSONValue.Free;
      end;
    end
    else
      Value := TValue.From(ValueStr);

    Context.AddOrSetValue(VarName, Value);
    Result := StringReplace(Result, Match.Value, '', [rfReplaceAll]);
  end;
end;






function TTina4Twig.EvaluateWithBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, WithVarRaw, InnerBlock: String;
  UseOnly: Boolean;
  ParsedDict, MergedContext: TDictionary<String, TValue>;
  VarValue: TValue;
  Evaluated: String;
  Pair: TPair<String, TValue>;
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*with\s*([^%]*?)(\s+only)?\s*%}(.*?){%\s*endwith\s*%}', [roIgnoreCase, roSingleLine]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    WithVarRaw := Trim(Match.Groups[1].Value);
    UseOnly := Trim(Match.Groups[2].Value).ToLower = 'only';
    InnerBlock := Match.Groups[3].Value;

    MergedContext := TDictionary<String, TValue>.Create;
    try
      // Start with empty or full copy depending on "only"
      if not UseOnly then
      begin
        for Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      end;

      if WithVarRaw <> '' then
      begin
        // Check if WithVarRaw exists in context
        if Context.TryGetValue(WithVarRaw, VarValue) then
        begin
          if VarValue.IsType<TDictionary<String, TValue>> then
          begin
            ParsedDict := VarValue.AsType<TDictionary<String, TValue>>;
            for Pair in ParsedDict do
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          end
          else if VarValue.IsType<string> then
          begin
            var s := VarValue.AsString;
            if (s.StartsWith('{')) and (s.EndsWith('}')) then
            begin
              ParsedDict := ParseVariableDict(s, Context);
              try
                for Pair in ParsedDict do
                  MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
              finally
                ParsedDict.Free;
              end;
            end
            else
              MergedContext.AddOrSetValue(WithVarRaw, VarValue);
          end
          else
          begin
            // If it's neither dict nor string, add as is
            MergedContext.AddOrSetValue(WithVarRaw, VarValue);
          end;
        end
        else
        begin
          // If WithVarRaw looks like a dictionary literal, parse it directly
          if (WithVarRaw.StartsWith('{')) and (WithVarRaw.EndsWith('}')) then
          begin
            ParsedDict := ParseVariableDict(WithVarRaw, Context);
            try
              for Pair in ParsedDict do
                MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
            finally
              ParsedDict.Free;
            end;
          end
          else
          begin
            // Unknown variable, just skip or consider adding empty context
          end;
        end;
      end;

      Evaluated := Self.RenderInternal(InnerBlock, MergedContext);
      Result := StringReplace(Result, FullMatch, Evaluated, [rfReplaceAll]);
    finally
      MergedContext.Free;
    end;
  end;
end;



function TTina4Twig.EvaluateForBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, ListExpr, BlockContent, Output, ArrayContent: String;
  Items: TArray<TDictionary<String, TValue>>;
  Item: TDictionary<String, TValue>;
  MergedContext: TDictionary<String, TValue>;
  Pair: TPair<String, TValue>;
  ArrayItems: TArray<String>;
  I: Integer;
  Value: TValue;
  ValueArray: TArray<TValue>;
  JSONArray : TJSONArray;

begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*for\s+(\w+)\s+in\s+((?:\[[^\]]*\])|\w+)\s*%}(.*?){%\s*endfor\s*%}', [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value.Trim;
    ListExpr := Match.Groups[2].Value.Trim;
    BlockContent := Match.Groups[3].Value;
    Output := '';
    Items := nil;

    if ListExpr.StartsWith('[') and ListExpr.EndsWith(']') then
    begin
      ArrayContent := Copy(ListExpr, 2, Length(ListExpr) - 2).Trim;
      if ArrayContent <> '' then
      begin
        ArrayItems := ArrayContent.Split([','], TStringSplitOptions.ExcludeEmpty);
        SetLength(Items, Length(ArrayItems));
        for I := 0 to High(ArrayItems) do
        begin
          var Element := ArrayItems[I].Trim;
          Element := StringReplace(Element, '''', '', [rfReplaceAll]);
          Element := StringReplace(Element, '"', '', [rfReplaceAll]);
          Item := TDictionary<String, TValue>.Create;
          Item.Add(VarName, TValue.From(Element));
          Items[I] := Item;
        end;
      end;
    end
    else if Context.TryGetValue(ListExpr, Value) then
    begin
      if Value.IsArray then
      begin
        ValueArray := Value.AsType<TArray<TValue>>;
        SetLength(Items, Length(ValueArray));
        for I := 0 to High(ValueArray) do
        begin
          Item := TDictionary<String, TValue>.Create;
          Item.Add(VarName, ValueArray[I]);
          Items[I] := Item;
        end;
      end
      else if Value.IsType<TDictionary<String, TValue>> then
      begin
        SetLength(Items, 1);
        Items[0] := Value.AsType<TDictionary<String, TValue>>;
      end
      else if Value.IsType<TJsonArray> then
      begin
        //Items[0] := Value.AsType<TJsonArray>;
        JSONArray := Value.AsType<TJsonArray>;
        SetLength(Items, JSONArray.Count);
        for I := 0 to JSONArray.Count-1 do
        begin
          Item := TDictionary<String, TValue>.Create;
          Item.Add(VarName, JSONArray[I]);
          Items[I] := Item;
        end;
      end;

    end
      else
    begin
      Result := StringReplace(Result, FullMatch, '', [rfReplaceAll]);
      Continue;
    end;

    for Item in Items do
    begin
      MergedContext := TDictionary<String, TValue>.Create;
      try
        for Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
        for Pair in Item do
        begin
          if Pair.Key = VarName then
            if Pair.Value.IsType<TJSONObject> then
            begin
              for var JSONValue in Pair.Value.AsType<TJSONObject> do
              begin
                var text := JSONValue.JsonString.Value+ ' = ' + JSONValue.JsonValue.Value;
                MergedContext.AddOrSetValue(VarName+'.'+JSONValue.JsonString.Value, JSONValue.JsonValue.Value);
              end;
            end
              else
            begin
              MergedContext.AddOrSetValue(VarName, Pair.Value)
            end
          else
            MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
        end;
        Output := Output + Self.RenderInternal(BlockContent, MergedContext);
      finally
        MergedContext.Free;
      end;
    end;

    if ListExpr.StartsWith('[') or (Context.ContainsKey(ListExpr) and Value.IsArray) then
    begin
      for Item in Items do
        Item.Free;
    end;

    Result := StringReplace(Result, FullMatch, Output, [rfReplaceAll]);
  end;
end;





function TTina4Twig.EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
var
  ExtendRegex, BlockRegex: TRegEx;
  Match, BlockMatch: TMatch;
  ParentTemplateName, BaseTemplate, BlockName, BlockContent: String;
  Blocks: TDictionary<String, String>;

  function ReplaceBlockInTemplate(const TemplateText, BlockName, NewContent: String): String;
  var
    Regex: TRegEx;
  begin
    // Replace {% block blockname %} ... {% endblock %} with NewContent
    Regex := TRegEx.Create(
      '{%\s*block\s+' + TRegEx.Escape(BlockName) + '\s*%}.*?{%\s*endblock\s*%}',
      [roSingleLine, roIgnoreCase]
    );
    Result := Regex.Replace(TemplateText, NewContent);
  end;

begin
  Result := Template;

  // Find {% extends "base.twig" %}
  ExtendRegex := TRegEx.Create('{%\s*extends\s+["'']([^"''}]+)["'']\s*%}', [roIgnoreCase]);
  Match := ExtendRegex.Match(Template);
  if not Match.Success then
    Exit(Template); // no extends, return as-is

  ParentTemplateName := Match.Groups[1].Value;

  // Remove extends tag from child's template content
  var ChildTemplateWithoutExtends := ExtendRegex.Replace(Template, '');

  // Load parent/base template
  BaseTemplate := LoadTemplate(ParentTemplateName);

  // Collect blocks from child template (without extends)
  Blocks := TDictionary<String, String>.Create;
  try
    BlockRegex := TRegEx.Create('{%\s*block\s+(\w+)\s*%}(.*?){%\s*endblock\s*%}', [roSingleLine, roIgnoreCase]);
    BlockMatch := BlockRegex.Match(ChildTemplateWithoutExtends);
    while BlockMatch.Success do
    begin
      BlockName := BlockMatch.Groups[1].Value;
      BlockContent := BlockMatch.Groups[2].Value.Trim;
      Blocks.AddOrSetValue(BlockName, BlockContent);
      BlockMatch := BlockMatch.NextMatch;
    end;

    // Replace blocks in base template with child's block content
    for BlockName in Blocks.Keys do
    begin
      BlockContent := Blocks[BlockName];
      BaseTemplate := ReplaceBlockInTemplate(BaseTemplate, BlockName, BlockContent);
    end;

    Result := BaseTemplate;
  finally
    Blocks.Free;
  end;
end;




procedure TTina4Twig.RegisterDefaultFilters;
begin
  FFilters.Clear;

  FFilters.Add('abs',
    function(const Input: String; const Args: TArray<String>): String
    var
      Val: Double;
    begin
      if TryStrToFloat(Input, Val) then
        Result := FloatToStr(Abs(Val))
      else
        Result := Input;
    end);

  FFilters.Add('batch',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: batching arrays not implemented; return Input for now
      Result := Input;
    end);

  FFilters.Add('capitalize',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if Input = '' then
        Result := ''
      else
        Result := UpperCase(Input[1]) + LowerCase(Copy(Input, 2, MaxInt));
    end);

  FFilters.Add('column',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: column extraction not implemented
      Result := Input;
    end);

  FFilters.Add('convert_encoding',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: encoding conversion not implemented
      Result := Input;
    end);

  FFilters.Add('country_name',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: return input or lookup country name if you implement a map
      Result := Input;
    end);

  FFilters.Add('currency_name',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input;
    end);

  FFilters.Add('currency_symbol',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input;
    end);

  FFilters.Add('data_uri',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: encode input as data URI
      Result := 'data:;base64,' + TNetEncoding.Base64.Encode(Input);
    end);

  FFilters.Add('date',
    function(const Input: String; const Args: TArray<String>): String
    var
      dt: TDateTime;
      fmt: String;
    begin
      if Length(Args) > 0 then
        fmt := Args[0]
      else
        fmt := 'yyyy-mm-dd';
      if TryStrToDateTime(Input, dt) then
        Result := FormatDateTime(fmt, dt)
      else
        Result := Input;
    end);

  FFilters.Add('date_modify',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: date arithmetic not implemented
      Result := Input;
    end);

  FFilters.Add('default',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if (Input = '') and (Length(Args) > 0) then
        Result := Args[0]
      else
        Result := Input;
    end);

  FFilters.Add('escape',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := StringReplace(Input, '&', '&amp;', [rfReplaceAll]);
      Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
      Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
      Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
      Result := StringReplace(Result, '''', '&#39;', [rfReplaceAll]);
    end);

  FFilters.Add('filter',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: generic filter - no op
      Result := Input;
    end);

  FFilters.Add('find',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if (Length(Args) > 0) then
      begin
        var idx := Pos(Args[0], Input);
        if idx > 0 then
          Result := IntToStr(idx)
        else
          Result := '-1';
      end
      else
        Result := '-1';
    end);

  FFilters.Add('first',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if Input <> '' then
        Result := Input[1]
      else
        Result := '';
    end);

  FFilters.Add('format',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if Length(Args) > 0 then
        Result := Format(Args[0], [Input])
      else
        Result := Input;
    end);

  FFilters.Add('format_currency',
    function(const Input: String; const Args: TArray<String>): String
    var
      Val: Double;
      Currency: String;
    begin
      Currency := '';
      if Length(Args) > 0 then
        Currency := Args[0];
      if TryStrToFloat(Input, Val) then
        Result := CurrToStrF(Val, ffCurrency, 2) + ' ' + Currency
      else
        Result := Input;
    end);

  FFilters.Add('format_date',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Alias for date filter
      Result := FFilters['date'](Input, Args);
    end);

  FFilters.Add('format_datetime',
  function(const Input: String; const Args: TArray<String>): String
  var
    FormatStr: string;
  begin
    if Length(Args) = 0 then
      FormatStr := 'yyyy-MM-dd HH:mm:ss'  // Correct Delphi datetime format
    else
      FormatStr := Args[0];

    Result := FFilters['date'](Input, [FormatStr]);
  end);

  FFilters.Add('format_number',
    function(const Input: String; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
    begin
      Decimals := 2;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 2);
      if TryStrToFloat(Input, Val) then
        Result := FormatFloat('0.' + StringOfChar('0', Decimals), Val)
      else
        Result := Input;
    end);

  FFilters.Add('format_time',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Alias for date filter, just format time portion
      Result := FFilters['date'](Input, ['hh:nn:ss']);
    end);

  FFilters.Add('html_to_markdown',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: no html-to-markdown lib, return input
      Result := Input;
    end);

  FFilters.Add('inky_to_html',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: inky (email templates) to html not implemented
      Result := Input;
    end);

  FFilters.Add('inline_css',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: inline css not implemented
      Result := Input;
    end);

  FFilters.Add('join',
  function(const Input: String; const Args: TArray<String>): String
  var
    Delim: String;
    Items: TArray<String>;
  begin
    Delim := ',';
    if Length(Args) > 0 then
      Delim := Args[0];

    // Suppose Input is a comma-separated string; convert to array:
    Items := Input.Split([',']);
    Result := string.Join(Delim, Items);
  end);


  FFilters.Add('json_encode',
  function(const Input: String; const Args: TArray<String>): String
  var
    JsonValue: TJSONValue;
  begin
    // Try parse as JSON - if success, output as is, else encode as string literal
    JsonValue := TJSONObject.ParseJSONValue(Input);
    try
      if Assigned(JsonValue) then
        Result := JsonValue.ToString
      else
        Result := JsonEncodeString(Input);
    finally
      JsonValue.Free;
    end;
  end);

  FFilters.Add('keys',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: keys extraction for objects not implemented
      Result := Input;
    end);

  FFilters.Add('language_name',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input;
    end);

  FFilters.Add('last',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if Input <> '' then
        Result := Input[Length(Input)]
      else
        Result := '';
    end);

  FFilters.Add('length',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := IntToStr(Length(Input));
    end);

  FFilters.Add('locale_name',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input;
    end);

  FFilters.Add('lower',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := LowerCase(Input);
    end);

  FFilters.Add('map',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: map/filter arrays not supported
      Result := Input;
    end);

  FFilters.Add('markdown_to_html',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: markdown to html - use a 3rd party lib if needed
      Result := Input;
    end);

  FFilters.Add('merge',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: merging collections not supported
      Result := Input;
    end);

  FFilters.Add('nl2br',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := StringReplace(Input, sLineBreak, '<br>', [rfReplaceAll]);
    end);

  FFilters.Add('number_format',
    function(const Input: String; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
    begin
      Decimals := 2;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 2);
      if TryStrToFloat(Input, Val) then
        Result := FormatFloat('0.' + StringOfChar('0', Decimals), Val)
      else
        Result := Input;
    end);

  FFilters.Add('plural',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: pluralization not implemented
      Result := Input;
    end);

  FFilters.Add('raw',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input; // no escaping
    end);

  FFilters.Add('reduce',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: reduce not supported
      Result := Input;
    end);

  FFilters.Add('replace',
    function(const Input: String; const Args: TArray<String>): String
    begin
      if Length(Args) < 2 then
        Result := Input
      else
        Result := StringReplace(Input, Args[0], Args[1], [rfReplaceAll]);
    end);

  FFilters.Add('reverse',
    function(const Input: String; const Args: TArray<String>): String
    var
      i: Integer;
    begin
      Result := '';
      for i := Length(Input) downto 1 do
        Result := Result + Input[i];
    end);

  FFilters.Add('round',
    function(const Input: String; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
      FormatStr: String;
    begin
      Decimals := 0;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 0);
      if TryStrToFloat(Input, Val) then
      begin
        FormatStr := '0.' + StringOfChar('0', Decimals);
        Result := FormatFloat(FormatStr, RoundTo(Val, -Decimals));
      end
      else
        Result := Input;
    end);

  FFilters.Add('shuffle',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: shuffle strings/arrays not supported
      Result := Input;
    end);

  FFilters.Add('singular',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: singularize not implemented
      Result := Input;
    end);

  FFilters.Add('slice',
    function(const Input: String; const Args: TArray<String>): String
    var
      StartIdx, Count, LenInput: Integer;
    begin
      StartIdx := 0;
      Count := MaxInt;
      LenInput := Length(Input);

      if Length(Args) > 0 then
        StartIdx := StrToIntDef(Args[0], 0);
      if Length(Args) > 1 then
        Count := StrToIntDef(Args[1], LenInput);

      if StartIdx < 0 then
        StartIdx := LenInput + StartIdx;
      if StartIdx < 1 then
        StartIdx := 1;

      Result := Copy(Input, StartIdx, Count);
    end);

  FFilters.Add('slug',
    function(const Input: String; const Args: TArray<String>): String
    var
      i: Integer;
      s: String;
    begin
      s := LowerCase(Input);
      for i := Length(s) downto 1 do
        if not (s[i] in ['a'..'z', '0'..'9']) then
          Delete(s, i, 1);
      Result := s;
    end);

  FFilters.Add('sort',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Stub: sorting strings/arrays not supported
      Result := Input;
    end);

  FFilters.Add('spaceless',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := StringReplace(Input, ' ', '', [rfReplaceAll]);
    end);

  FFilters.Add('split',
    function(const Input: String; const Args: TArray<String>): String
    var
      Delim: String;
      Parts: TArray<String>;
      i: Integer;
      ResultList: TStringList;
    begin
      if Length(Args) > 0 then
        Delim := Args[0]
      else
        Delim := ',';
      Parts := Input.Split([Delim]);

      ResultList := TStringList.Create;
      try
        for i := 0 to High(Parts) do
          ResultList.Add(Parts[i]);
        Result := ResultList.Text; // or join back? Your usage may vary
      finally
        ResultList.Free;
      end;
    end);

  FFilters.Add('striptags',
    function(const Input: String; const Args: TArray<String>): String
    var
      Regex: TRegEx;
    begin
      Regex := TRegEx.Create('<.*?>', [roIgnoreCase]);
      Result := Regex.Replace(Input, '');
    end);

  FFilters.Add('timezone_name',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Input;
    end);

  FFilters.Add('title',
    function(const Input: String; const Args: TArray<String>): String
    var
      i: Integer;
      Words: TArray<String>;
    begin
      Words := Input.Split([' ']);
      for i := 0 to High(Words) do
        if Words[i].Length > 0 then
          Words[i] := UpperCase(Words[i][1]) + LowerCase(Copy(Words[i], 2, MaxInt));
      Result := String.Join(' ', Words);
    end);

  FFilters.Add('trim',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := Trim(Input);
    end);

  FFilters.Add('u',
    function(const Input: String; const Args: TArray<String>): String
    begin
      // Twig u filter is Unicode string conversion, here just return input
      Result := Input;
    end);

  FFilters.Add('upper',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := UpperCase(Input);
    end);

  FFilters.Add('url_encode',
    function(const Input: String; const Args: TArray<String>): String
    begin
      Result := TNetEncoding.URL.Encode(Input);
    end);
end;

function TTina4Twig.Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;
begin
  Result := RenderInternal(TemplateOrContent, FContext);
end;

function TTina4Twig.RenderInternal(const TemplateOrContent: String; Context: TStringDict): String;
var
  TemplateText, FullPath: String;
  LocalContext: TDictionary<String, TValue>;
begin
  LocalContext := TDictionary<String, TValue>.Create;
  try
    for var Pair in Context do
      LocalContext.AddOrSetValue(Pair.Key, Pair.Value);

    FullPath := IncludeTrailingPathDelimiter(FTemplatePath) + TemplateOrContent;

    if FileExists(FullPath) then
      TemplateText := LoadTemplate(TemplateOrContent)
    else
      TemplateText := TemplateOrContent;

    TemplateText := RemoveComments(TemplateText);
    TemplateText := EvaluateSetBlocks(TemplateText, LocalContext);
    TemplateText := EvaluateExtends(TemplateText, LocalContext);
    TemplateText := EvaluateForBlocks(TemplateText, LocalContext);
    TemplateText := EvaluateIncludes(TemplateText, LocalContext);
    TemplateText := EvaluateWithBlocks(TemplateText, LocalContext);
    TemplateText := EvaluateIfBlocks(TemplateText, LocalContext);
    TemplateText := ReplaceContextVariables(TemplateText, LocalContext);

    Result := TemplateText;
  finally
    LocalContext.Free;
  end;
end;


procedure TTina4Twig.SetVariable(AName: string; AValue: TValue);
var
  ctx: TDictionary<string, string>;
  pair: TPair<string, string>;
  jsonObj: TJSONObject;
  recRtti: TRttiContext;
  recType: TRttiType;
  recProp: TRttiProperty;
  valStr: string;
begin
  if AValue.Kind = tkRecord then
  begin
    ctx := TDictionary<string, string>.Create;
    try
      recType := recRtti.GetType(AValue.TypeInfo);
      for recProp in recType.GetProperties do
      begin
        valStr := recProp.GetValue(AValue.GetReferenceToRawData).ToString;
        ctx.AddOrSetValue(recProp.Name, valStr);
      end;
      for pair in ctx do
        FContext.AddOrSetValue(AName + '.' + pair.Key, pair.Value);
    finally
      ctx.Free;
    end;
  end
  else if AValue.IsObject and (AValue.AsObject is TJSONObject) then
  begin
    jsonObj := TJSONObject(AValue.AsObject);
    for var i := 0 to jsonObj.Count - 1 do
      FContext.AddOrSetValue(AName + '.' + jsonObj.Pairs[i].JsonString.Value, jsonObj.Pairs[i].JsonValue.Value);
  end
  else
  begin
    FContext.AddOrSetValue(AName, AValue); // Store directly
  end;
end;


end.

