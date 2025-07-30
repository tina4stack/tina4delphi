unit Tina4Twig;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math;


type
  TStringDict = TDictionary<String, String>;
  TFilterFunc = reference to function(const Input: String; const Args: TArray<String>): String;
  TFunctionFunc = reference to function(const Args: TArray<String>): String;

  TTina4Twig = class(TObject)
  private
    FContext: TDictionary<String, String>;
    FArrayContext: TDictionary<String, TArray<TDictionary<String, String>>>;
    FFilters: TDictionary<String, TFilterFunc>;
    FFunctions: TDictionary<String, TFunctionFunc>;
    FTemplatePath: String;
    function LoadTemplate(const TemplateName: String): String;
    function ReplaceContextVariables(const TemplateSource: String): String;
    function EvaluateIfBlocks(const Template: String): String;
    function EvaluateIncludes(const Template: String): String;
    function EvaluateForBlocks(const Template: String): String;
    function EvaluateExtends(const Template: String): String;
    function EvaluateSetBlocks(const Template: String; Context: TDictionary<String, String>): String;
    function EvaluateWithBlocks(const Template: String; Context: TDictionary<String, String>): String;
    function RemoveComments(const Template: String): String;
    function ParseVariableDict(const DictStr: String; OuterContext: TDictionary<String,String>): TDictionary<String,String>;
  public
    constructor Create(const TemplatePath: String = '');
    destructor Destroy; override;
    procedure SetVariable(AName: string; AValue: TValue);
    procedure SetArray(AName: string; AValue: TValue);
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
  FContext := TDictionary<String, String>.Create;
  FArrayContext := TDictionary<String, TArray<TDictionary<String, String>>>.Create;
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
  function(const Args: TArray<String>): String
  var
    I: Integer;
    DumpResult: TStringList;
  begin
    DumpResult := TStringList.Create;
    try
      if Length(Args) = 0 then
      begin
        Result := '(no arguments)';
        Exit;
      end;
      DumpResult.Add('Dump output:');
      for I := 0 to High(Args) do
        DumpResult.Add('  [' + IntToStr(I) + '] = ' + Args[I]);
      Result := DumpResult.Text;
    finally
      DumpResult.Free;
    end;
  end);

  FFunctions.Add('range',
  function(const Args: TArray<String>): String
  var
    i, startNum, endNum: Integer;
    Output: TStringList;
  begin
    Output := TStringList.Create;
    try
      if Length(Args) < 2 then
      begin
        Result := '';
        Exit;
      end;
      startNum := StrToIntDef(Args[0], 0);
      endNum := StrToIntDef(Args[1], 0);
      for i := startNum to endNum do
        Output.Add(IntToStr(i));
      Result := Output.Text;
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
  FArrayContext.Free;
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

function TTina4Twig.EvaluateIfBlocks(const Template: String): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, ConditionVar, InnerBlock, IfContent, ElseContent, Replacement: String;
  IfPos, ElsePos: Integer;
begin
  Result := Template;
  Regex := TRegEx.Create('{% if\s+(\w+)\s*%}(.*?){% endif %}', [roSingleLine, roIgnoreCase]);

  repeat
    Match := Regex.Match(Result);
    if not Match.Success then Break;

    FullMatch := Match.Value;
    ConditionVar := Match.Groups[1].Value;
    InnerBlock := Match.Groups[2].Value;

    // Try splitting on {% else %}
    ElsePos := Pos('{% else %}', InnerBlock);
    if ElsePos > 0 then
    begin
      IfContent := Trim(Copy(InnerBlock, 1, ElsePos - 1));
      ElseContent := Trim(Copy(InnerBlock, ElsePos + Length('{% else %}'), MaxInt));
    end
    else
    begin
      IfContent := Trim(InnerBlock);
      ElseContent := '';
    end;

    if FContext.ContainsKey(ConditionVar) and SameText(FContext[ConditionVar], 'true') then
      Replacement := IfContent
    else
      Replacement := ElseContent;

    // Replace the whole {% if ... %} ... {% endif %} block
    Result := StringReplace(Result, FullMatch, Replacement, []);
  until False;
end;

function TTina4Twig.ReplaceContextVariables(const TemplateSource: String): String;
var
  Regex: TRegEx;
  Matches: TMatchCollection;
  Match: TMatch;
  Expr, VarName, FilterPart, FilterName: String;
  Replacement, InputValue: String;
  Filters: TArray<String>;
  FilterArgs: TArray<String>;
  FuncName: String;
  FuncArgs: TArray<String>;
  IsFunctionCall: Boolean;
  I: Integer;
  Func: TFunctionFunc;
  FilterFunc: TFilterFunc;
  Builder: TStringBuilder;
  LastPos, CurrPos: Integer;

  function ParseFunctionCall(const Expr: String; out FuncName: String; out Args: TArray<String>): Boolean;
  var
    OpenParenPos, CloseParenPos: Integer;
    ArgsStr: String;
  begin
    Result := False;
    FuncName := '';
    SetLength(Args, 0);

    OpenParenPos := Pos('(', Expr);
    if OpenParenPos = 0 then Exit;

    CloseParenPos := LastDelimiter(')', Expr);
    if CloseParenPos < OpenParenPos then Exit;

    FuncName := Trim(Copy(Expr, 1, OpenParenPos - 1));
    ArgsStr := Copy(Expr, OpenParenPos + 1, CloseParenPos - OpenParenPos - 1);

    Args := ArgsStr.Split([',']);
    for var i := Low(Args) to High(Args) do
      Args[i] := Trim(Args[i]);

    Result := True;
  end;

begin
  Regex := TRegEx.Create('{{\s*(.+?)\s*}}', [roSingleLine]);
  Matches := Regex.Matches(TemplateSource);

  Builder := TStringBuilder.Create;
  try
    LastPos := 0; // zero-based string indexing

    for Match in Matches do
    begin
      CurrPos := Match.Index-1; // zero-based start position of '{{ ... }}'

      // Append text from last position up to current match start
      Builder.Append(TemplateSource.Substring(LastPos, CurrPos - LastPos));

      Expr := Match.Groups[1].Value.Trim;

      IsFunctionCall := ParseFunctionCall(Expr, FuncName, FuncArgs);

      if IsFunctionCall then
      begin
        if FFunctions.TryGetValue(FuncName, Func) then
          Replacement := Func(FuncArgs)
        else
          Replacement := '';
      end
       else
      begin
        Filters := Expr.Split(['|']);
        VarName := Filters[0].Trim;

        if not FContext.TryGetValue(VarName, InputValue) then
          InputValue := '';

        for I := 1 to High(Filters) do
        begin
          FilterPart := Filters[I].Trim;
          FilterName := FilterPart;
          SetLength(FilterArgs, 0);

          if FFilters.TryGetValue(FilterName, FilterFunc) then
            InputValue := FilterFunc(InputValue, FilterArgs);
        end;

        Replacement := InputValue;
      end;

      Builder.Append(Replacement);

      // Move LastPos to after the current match (skip all of '{{ ... }}')
      LastPos := CurrPos + Match.Length;
    end;

    // Append the remaining tail after the last match
    Builder.Append(TemplateSource.Substring(LastPos, TemplateSource.Length - LastPos));

    Result := Builder.ToString;
  finally
    Builder.Free;
  end;
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
  OuterContext: TDictionary<String, String>): TDictionary<String, String>;
var
  Content: String;
  Pairs: TArray<String>;
  Pair: String;
  KV: TArray<String>;
  Key, Value, V: String;
  Dict: TDictionary<String,String>;
  I: Integer;
begin
  Dict := TDictionary<String,String>.Create;

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

function TTina4Twig.EvaluateIncludes(const Template: String): String;
var
  Regex: TRegEx;
  Match: TMatch;
  IncludeName, IncludeContent, FullMatch: String;
begin
  Result := Template;
  Regex := TRegEx.Create('{% include\s+["'']([^"''}]+)["'']\s*%}', [roIgnoreCase]);

  repeat
    Match := Regex.Match(Result);
    if not Match.Success then Break;

    IncludeName := Match.Groups[1].Value;
    FullMatch := Match.Value;

    IncludeContent := LoadTemplate(IncludeName); // load and inject

    // Render includes recursively (optional: could isolate to avoid infinite includes)
    IncludeContent := Render(IncludeName);

    Result := StringReplace(Result, FullMatch, IncludeContent, []);
  until False;
end;


function TTina4Twig.EvaluateSetBlocks(const Template: String; Context: TDictionary<String, String>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, VarValue: String;

function ParseVariableDict(const DictStr: String;
  OuterContext: TDictionary<String, String>): TDictionary<String, String>;
var
  Content: String;
  Pairs: TArray<String>;
  Pair, Key, Value, ResolvedValue: String;
  KV: TArray<String>;
  Dict: TDictionary<String, String>;
  I: Integer;
begin
  Dict := TDictionary<String, String>.Create;

  Content := Trim(DictStr);
  if (Length(Content) > 1) and (Content[1] = '{') and (Content[Length(Content)] = '}') then
    Content := Trim(Copy(Content, 2, Length(Content) - 2));

  if Content = '' then
    Exit(Dict);

  Pairs := Content.Split([',']);
  for I := 0 to High(Pairs) do
  begin
    Pair := Trim(Pairs[I]);
    KV := Pair.Split([':']);
    if Length(KV) = 2 then
    begin
      Key := Trim(KV[0]);
      Value := Trim(KV[1]);

      // Remove quotes from value if present
      if ((Value.StartsWith('"') and Value.EndsWith('"')) or
          (Value.StartsWith('''') and Value.EndsWith(''''))) then
        Value := Value.Substring(1, Value.Length - 2);

      // Try resolve from context, else keep as is
      if OuterContext.TryGetValue(Value, ResolvedValue) then
        Dict.AddOrSetValue(Key, ResolvedValue)
      else
        Dict.AddOrSetValue(Key, Value);
    end;
  end;

  Result := Dict;
end;

var
  ParsedDict: TDictionary<String, String>;
  Pair: TPair<String, String>;
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*set\s+(\w+)\s*=\s*(.+?)\s*%}', [roIgnoreCase]);

  repeat
    Match := Regex.Match(Result);
    if not Match.Success then Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value;
    VarValue := Match.Groups[2].Value.Trim;

    if VarValue.StartsWith('{') and VarValue.EndsWith('}') then
    begin
      ParsedDict := ParseVariableDict(VarValue, Context);
      try
        for Pair in ParsedDict do
          Context.AddOrSetValue(VarName + '.' + Pair.Key, Pair.Value);
      finally
        ParsedDict.Free;
      end;
    end
    else
    begin
      // Trim quotes if present
      if ((VarValue.StartsWith('"')) and (VarValue.EndsWith('"'))) or
         ((VarValue.StartsWith('''')) and (VarValue.EndsWith(''''))) then
        VarValue := VarValue.Substring(1, VarValue.Length - 2);

      Context.AddOrSetValue(VarName, VarValue);
    end;

    Result := StringReplace(Result, FullMatch, '', []);
  until False;
end;


function TTina4Twig.EvaluateWithBlocks(const Template: String; Context: TDictionary<String, String>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, WithVarRaw, WithVarName, InnerBlock: String;
  WithContext, MergedContext: TDictionary<String, String>;
  VarValue: String;
  UseOnly: Boolean;
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*with\s+(.+?)\s*%}(.*?){%\s*endwith\s*%}', [roIgnoreCase, roSingleLine]);

  repeat
    Match := Regex.Match(Result);
    if not Match.Success then Break;

    FullMatch := Match.Value;
    WithVarRaw := Trim(Match.Groups[1].Value);
    InnerBlock := Match.Groups[2].Value;

    // Detect "only" at the end
    UseOnly := False;
    if WithVarRaw.ToLower.EndsWith(' only') then
    begin
      UseOnly := True;
      WithVarRaw := Trim(Copy(WithVarRaw, 1, Length(WithVarRaw) - 5));
    end;

    WithContext := nil;
    MergedContext := TDictionary<String, String>.Create;

    try
      if not UseOnly then
      begin
        // Merge outer context
        for var Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      end;

      if WithVarRaw.StartsWith('{') then
      begin
        // Inline object
        WithContext := ParseVariableDict(WithVarRaw, Context);
        for var Pair in WithContext do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      end
      else
      begin
        WithVarName := WithVarRaw;

        // Named variable from context
        if Context.TryGetValue(WithVarName, VarValue) then
          MergedContext.AddOrSetValue(WithVarName, VarValue);

        // Named variable from array context
        if FArrayContext.ContainsKey(WithVarName) then
        begin
          for var Item in FArrayContext[WithVarName] do
            for var SubPair in Item do
              MergedContext.AddOrSetValue(WithVarName + '.' + SubPair.Key, SubPair.Value);
        end;
      end;

      var Evaluated := Self.Render(InnerBlock, MergedContext);
      Result := StringReplace(Result, FullMatch, Evaluated, []);

    finally
      MergedContext.Free;
      if Assigned(WithContext) then
        WithContext.Free;
    end;
  until False;
end;


function TTina4Twig.EvaluateForBlocks(const Template: String): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, ListName, BlockContent, Output: String;
  Items: TArray<TDictionary<String, String>>;
  Item: TDictionary<String, String>;
  LoopContent: String;
  ctxBackup: TDictionary<String, String>;
  pair: TPair<String, String>;
begin
  Result := Template;
  Regex := TRegEx.Create('{% for (\w+)\s+in\s+(\w+)\s*%}(.*?){% endfor %}', [roSingleLine, roIgnoreCase]);

  repeat
    Match := Regex.Match(Result);
    if not Match.Success then Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value;  // e.g. "person"
    ListName := Match.Groups[2].Value; // e.g. "people"
    BlockContent := Match.Groups[3].Value;

    Output := '';

    if not FArrayContext.TryGetValue(ListName, Items) then
    begin
      // No array found for the list name, remove the block
      Result := StringReplace(Result, FullMatch, '', []);
      Continue;
    end;

    for Item in Items do
    begin
      // Backup existing context to restore later
      ctxBackup := TDictionary<String, String>.Create;
      try
        for pair in FContext do
          ctxBackup.Add(pair.Key, pair.Value);

        // Add current item fields to context prefixed by VarName
        for pair in Item do
          FContext.AddOrSetValue(VarName + '.' + pair.Key, pair.Value);

        // Render the block with the updated context
        LoopContent := ReplaceContextVariables(BlockContent);

        Output := Output + LoopContent;
      finally
        // Restore original context
        FContext.Clear;
        for pair in ctxBackup do
          FContext.AddOrSetValue(pair.Key, pair.Value);
        ctxBackup.Free;
      end;
    end;

    Result := StringReplace(Result, FullMatch, Output, []);
  until False;
end;


function TTina4Twig.EvaluateExtends(const Template: String): String;
var
  ExtendRegex, BlockRegex: TRegEx;
  Match, BlockMatch: TMatch;
  ParentTemplateName, BaseTemplate, BlockName, BlockContent: String;
  Blocks: TDictionary<String, String>;
begin
  Result := Template;

  // Find {% extends "base.twig" %}
  ExtendRegex := TRegEx.Create('{% extends\s+["'']([^"''}]+)["'']\s*%}', [roIgnoreCase]);
  Match := ExtendRegex.Match(Template);
  if not Match.Success then
    Exit(Template); // no extends, return as-is

  ParentTemplateName := Match.Groups[1].Value;

  // Remove extends tag from child's template content
  var ChildTemplateWithoutExtends := ExtendRegex.Replace(Template, '');

  BaseTemplate := LoadTemplate(ParentTemplateName);

  // Collect blocks from the child template (without extends)
  Blocks := TDictionary<String, String>.Create;
  try
    BlockRegex := TRegEx.Create('{% block\s+(\w+)\s*%}(.*?){% endblock %}', [roSingleLine, roIgnoreCase]);
    BlockMatch := BlockRegex.Match(ChildTemplateWithoutExtends);
    while BlockMatch.Success do
    begin
      BlockName := BlockMatch.Groups[1].Value;
      BlockContent := BlockMatch.Groups[2].Value;
      Blocks.AddOrSetValue(BlockName, BlockContent);
      BlockMatch := BlockMatch.NextMatch;
    end;

    // Replace blocks in base template with child's content
    BlockMatch := BlockRegex.Match(BaseTemplate);
    while BlockMatch.Success do
    begin
      BlockName := BlockMatch.Groups[1].Value;
      if Blocks.TryGetValue(BlockName, BlockContent) then
      begin
        BaseTemplate := StringReplace(BaseTemplate, BlockMatch.Value, BlockContent, []);
      end;
      BlockMatch := BlockMatch.NextMatch;
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
var
  TemplateText, FullPath: String;
  ContextToUse: TStringDict;
  OldContext: TStringDict;
begin
  if Assigned(Variables) then
    ContextToUse := Variables
  else
    ContextToUse := FContext;

  FullPath := IncludeTrailingPathDelimiter(FTemplatePath) + TemplateOrContent;

  // Auto-detect if input is a file
  if FileExists(FullPath) then
    TemplateText := LoadTemplate(TemplateOrContent)
  else
    TemplateText := TemplateOrContent;

  OldContext := FContext;
  try
    FContext := ContextToUse;

    TemplateText := RemoveComments(TemplateText);
    TemplateText := EvaluateSetBlocks(TemplateText, FContext);

    TemplateText := EvaluateExtends(TemplateText);
    TemplateText := EvaluateIncludes(TemplateText);
    TemplateText := EvaluateWithBlocks(TemplateText, FContext);
    TemplateText := EvaluateForBlocks(TemplateText);
    TemplateText := EvaluateIfBlocks(TemplateText);
    TemplateText := ReplaceContextVariables(TemplateText);
    Result := TemplateText;
  finally
    FContext := OldContext;
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
    recType := recRtti.GetType(AValue.TypeInfo);
    for recProp in recType.GetProperties do
    begin
      valStr := recProp.GetValue(AValue.GetReferenceToRawData).ToString;
      ctx.AddOrSetValue(recProp.Name, valStr);
    end;
    for pair in ctx do
      FContext.AddOrSetValue(AName + '.' + pair.Key, pair.Value);
    ctx.Free;
  end
  else if AValue.IsObject and (AValue.AsObject is TJSONObject) then
  begin
    jsonObj := TJSONObject(AValue.AsObject);
    for var i := 0 to jsonObj.Count - 1 do
      FContext.AddOrSetValue(AName + '.' + jsonObj.Pairs[i].JsonString.Value, jsonObj.Pairs[i].JsonValue.Value);
  end
  else
  begin
    // fallback to simple ToString
    FContext.AddOrSetValue(AName, AValue.ToString);
  end;
end;


procedure TTina4Twig.SetArray(AName: string; AValue: TValue);
var
  i, j: Integer;
  jsonArr: TJSONArray;
  jsonObj: TJSONObject;
  jsonPair: TJSONPair;
  dict: TDictionary<String, String>;
  arr: TArray<TDictionary<String, String>>;
begin
  if FArrayContext.ContainsKey(AName) then
    FArrayContext.Remove(AName);

  if AValue.IsObject and (AValue.AsObject is TJSONArray) then
  begin
    jsonArr := TJSONArray(AValue.AsObject);
    SetLength(arr, jsonArr.Count);

    for i := 0 to jsonArr.Count - 1 do
    begin
      dict := TDictionary<String, String>.Create;
      jsonObj := jsonArr.Items[i] as TJSONObject;
      for j := 0 to jsonObj.Count - 1 do
      begin
        jsonPair := jsonObj.Pairs[j];
        dict.AddOrSetValue(jsonPair.JsonString.Value, jsonPair.JsonValue.Value);
      end;
      arr[i] := dict;
    end;

    FArrayContext.Add(AName, arr);
  end
  else
    raise Exception.Create('Unsupported type for SetArray');
end;

end.
