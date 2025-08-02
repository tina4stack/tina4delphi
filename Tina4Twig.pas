unit Tina4Twig;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math, Variants;

type
  TStringDict = TDictionary<String, TValue>;
  TFilterFunc = reference to function(const Input: String; const Args: TArray<String>): String;
  TFunctionFunc = reference to function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String;
  TMacroFunc = reference to function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String;

  TTina4Twig = class(TObject)
  private
    FContext: TDictionary<String, TValue>;
    FFilters: TDictionary<String, TFilterFunc>;
    FFunctions: TDictionary<String, TFunctionFunc>;
    FMacros: TDictionary<String, TMacroFunc>;
    FMacroParams: TDictionary<String, TArray<String>>;
    FMacroDefaults: TDictionary<String, TDictionary<String, String>>;
    FTemplatePath: String;
    function LoadTemplate(const TemplateName: String): String;
    function ReplaceContextVariables(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateIfBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateIncludes(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateForBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateSetBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateWithBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateMacroBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function RemoveComments(const Template: String): String;
    function ParseVariableDict(const DictStr: String; OuterContext: TDictionary<String,TValue>): TDictionary<String,TValue>;
    function RenderInternal(const TemplateOrContent: String; Context: TStringDict): String;
    function ResolveVariablePath(const VariablePath: string; Context: TDictionary<String, TValue>): TValue;
    function Contains(const Left, Right: TValue): Boolean;
    function ValuesAreEqual(const A, B: TValue): Boolean;
    function ToBool(const Value: TValue): Boolean;
    procedure DumpValue(const Value: TValue; List: TStringList; const Indent: String);
    procedure RegisterDefaultFilters;
  public
    constructor Create(const TemplatePath: String = '');
    destructor Destroy; override;
    procedure SetVariable(AName: string; AValue: TValue);
    function Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;

  end;

implementation

{ TTwig }

/// <summary>
/// Encodes a string as a JSON string literal.
/// </summary>
/// <param name="S">The string to encode.</param>
/// <returns>
/// The JSON-encoded string.
/// </returns>
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

/// <summary>
/// Initializes a new instance of the TTina4Twig class.
/// </summary>
/// <param name="TemplatePath">Optional path to the templates directory. Defaults to the application directory if empty.</param>
/// <remarks>
/// Sets up context dictionaries, registers default filters and functions like 'dump' and 'range'.
/// </remarks>
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
  FMacros := TDictionary<String, TMacroFunc>.Create;
  FMacroParams := TDictionary<String, TArray<String>>.Create;
  FMacroDefaults := TDictionary<String, TDictionary<String, String>>.Create;

  FFunctions.Add('dump',
    function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    var
      I: Integer;
      DumpResult: TStringList;
      Value: TValue;
    begin
      DumpResult := TStringList.Create;
      try
        if Length(Args) = 0 then
          Exit('(no arguments)');

        for I := 0 to High(Args) do
        begin
          if Context.TryGetValue(Args[I], Value) then
          begin
            DumpResult.Add(Args[I] + ' =');
            DumpValue(Value, DumpResult, '  ');
          end
          else
          begin
            DumpResult.Add(Args[I] + ' = (not found)');
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

/// <summary>
/// Destroys the TTina4Twig instance.
/// </summary>
/// <remarks>
/// Frees owned dictionaries and clears context, handling nested dictionaries.
/// </remarks>
destructor TTina4Twig.Destroy;
var
  pair: TPair<String, TValue>;
  macroDefaultsPair: TPair<String, TDictionary<String, String>>;
begin
  for pair in FContext do
    if pair.Value.IsObject and (pair.Value.AsObject is TDictionary<String, TValue>) then
      pair.Value.AsObject.Free;
  for macroDefaultsPair in FMacroDefaults do
    macroDefaultsPair.Value.Free;
  FFilters.Free;
  FFunctions.Free;
  FMacros.Free;
  FMacroParams.Free;
  FMacroDefaults.Free;
  FContext.Free;
  inherited;
end;

/// <summary>
/// Dumps a TValue to a string list with indentation for debugging.
/// </summary>
/// <param name="Value">The value to dump.</param>
/// <param name="List">The TStringList to append the dump to.</param>
/// <param name="Indent">The indentation prefix for each line.</param>
/// <remarks>
/// Handles various types including integers, floats, strings, booleans, arrays, dictionaries, JSON arrays, and objects.
/// </remarks>
procedure TTina4Twig.DumpValue(const Value: TValue; List: TStringList; const Indent: String);
var
  Arr: TArray<TValue>;
  Dict: TDictionary<String, TValue>;
  JSONArray: TJSONArray;
  Pair: TPair<String, TValue>;
  JSONVal: TJSONValue;
  J: Integer;
begin
  if Value.IsEmpty then
  begin
    List.Add(Indent + 'NULL');
    Exit;
  end;

  case Value.Kind of
    tkInteger, tkInt64:
      List.Add(Indent + 'int(' + Value.ToString + ')');
    tkFloat:
      List.Add(Indent + 'float(' + FloatToStr(Value.AsExtended) + ')');
    tkString, tkLString, tkWString, tkUString:
      List.Add(Indent + 'string(' + IntToStr(Length(Value.AsString)) + ') "' + Value.AsString + '"');
    tkEnumeration:
      if Value.TypeInfo = TypeInfo(Boolean) then
        if Value.AsBoolean then
          List.Add(Indent + 'bool(true)')
        else
          List.Add(Indent + 'bool(false)')
      else
        List.Add(Indent + Value.ToString);
    tkDynArray, tkArray:
      begin
        Arr := Value.AsType<TArray<TValue>>;
        List.Add(Indent + 'array(' + IntToStr(Length(Arr)) + ') {');
        for J := 0 to High(Arr) do
        begin
          List.Add(Indent + '  [' + IntToStr(J) + ']=>');
          DumpValue(Arr[J], List, Indent + '    ');
        end;
        List.Add(Indent + '}');
      end;
    tkClass:
      if Value.AsObject is TDictionary<String, TValue> then
      begin
        Dict := Value.AsType<TDictionary<String, TValue>>;
        List.Add(Indent + 'array(' + IntToStr(Dict.Count) + ') {');
        for Pair in Dict do
        begin
          List.Add(Indent + '  ["' + Pair.Key + '"]=>');
          DumpValue(Pair.Value, List, Indent + '    ');
        end;
        List.Add(Indent + '}');
      end
      else if Value.AsObject is TJSONArray then
      begin
        JSONArray := Value.AsObject as TJSONArray;
        List.Add(Indent + 'array(' + IntToStr(JSONArray.Count) + ') {');
        for J := 0 to JSONArray.Count - 1 do
        begin
          JSONVal := JSONArray.Items[J];
          List.Add(Indent + '  [' + IntToStr(J) + ']=>');
          if JSONVal is TJSONNumber then
            DumpValue(TValue.From<Double>(TJSONNumber(JSONVal).AsDouble), List, Indent + '    ')
          else if JSONVal is TJSONString then
            DumpValue(TValue.From<String>(TJSONString(JSONVal).Value), List, Indent + '    ')
          else if JSONVal is TJSONBool then
            DumpValue(TValue.From<Boolean>(TJSONBool(JSONVal).AsBoolean), List, Indent + '    ')
          else if JSONVal is TJSONNull then
            DumpValue(TValue.Empty, List, Indent + '    ')
          else if JSONVal is TJSONObject then
          begin
            var ADict := TDictionary<String, TValue>.Create;
            try
              for var APair in TJSONObject(JSONVal) do
              begin
                if APair.JsonValue is TJSONNumber then
                  ADict.Add(APair.JsonString.Value, TValue.From<Double>(TJSONNumber(APair.JsonValue).AsDouble))
                else if APair.JsonValue is TJSONBool then
                  ADict.Add(APair.JsonString.Value, TValue.From<Boolean>(TJSONBool(APair.JsonValue).AsBoolean))
                else if APair.JsonValue is TJSONString then
                  ADict.Add(APair.JsonString.Value, TValue.From<String>(TJSONString(APair.JsonValue).Value))
                else if APair.JsonValue is TJSONNull then
                  ADict.Add(APair.JsonString.Value, TValue.Empty)
                else
                  ADict.Add(APair.JsonString.Value, TValue.From<String>(APair.JsonValue.ToString));
              end;
              DumpValue(TValue.From<TDictionary<String, TValue>>(ADict), List, Indent + '    ');
            finally
              ADict.Free;
            end;
          end
          else
            DumpValue(TValue.From<String>(JSONVal.ToString), List, Indent + '    ');
        end;
        List.Add(Indent + '}');
      end
      else
        List.Add(Indent + 'object(' + Value.AsObject.ClassName + ')#' + IntToStr(Integer(Pointer(Value.AsObject))) + ' {}');
    tkRecord:
      begin
        if Value.TypeInfo = TypeInfo(TDictionary<String, TValue>) then
        begin
          Dict := Value.AsType<TDictionary<String, TValue>>;
          List.Add(Indent + 'array(' + IntToStr(Dict.Count) + ') {');
          for Pair in Dict do
          begin
            List.Add(Indent + '  ["' + Pair.Key + '"]=>');
            DumpValue(Pair.Value, List, Indent + '    ');
          end;
          List.Add(Indent + '}');
        end
        else
          List.Add(Indent + 'record(' + Value.TypeInfo.Name + ')');
      end;
    else
      List.Add(Indent + Value.ToString);
  end;
end;

/// <summary>
/// Removes comments from the template string.
/// </summary>
/// <param name="Template">The template string containing comments.</param>
/// <returns>
/// The template without comments.
/// </returns>
/// <remarks>
/// Removes {# ... #} comments, including multiline.
/// </remarks>
function TTina4Twig.RemoveComments(const Template: String): String;
var
  Regex: TRegEx;
begin
  // This regex matches {# ... #} including multiline comments (non-greedy)
  Regex := TRegEx.Create('{#.*?#}', [roSingleLine, roMultiLine]);
  Result := Regex.Replace(Template, '');
end;

/// <summary>
/// Checks if two TValue instances are equal.
/// </summary>
/// <param name="A">First value.</param>
/// <param name="B">Second value.</param>
/// <returns>
/// True if values are equal, False otherwise.
/// </returns>
/// <remarks>
/// Handles empty values, ordinal types, strings, and objects.
/// </remarks>
function TTina4Twig.ValuesAreEqual(const A, B: TValue): Boolean;
begin
  if A.IsEmpty and B.IsEmpty then
    Exit(True);

  if A.IsEmpty <> B.IsEmpty then
    Exit(False);

  if A.IsOrdinal and B.IsOrdinal then
    Exit(Abs(A.AsExtended - B.AsExtended) < 1E-12);

  case A.Kind of
    tkString, tkLString, tkWString, tkUString:
      Result := A.AsString = B.AsString;
    tkClass:
      Result := A.AsObject = B.AsObject;
  else
    Result := False;
  end;
end;

/// <summary>
/// Checks if the left value is contained in the right value.
/// </summary>
/// <param name="Left">The value to check for containment.</param>
/// <param name="Right">The container value (string, array, or dictionary).</param>
/// <returns>
/// True if contained, False otherwise.
/// </returns>
/// <remarks>
/// Supports string substring, array membership, and dictionary key existence.
/// </remarks>
function TTina4Twig.Contains(const Left, Right: TValue): Boolean;
var
  Arr: TArray<TValue>;
  v: TValue;
  Dict: TDictionary<String, TValue>;
begin
  Result := False;
  if (Right.Kind in [tkString, tkUString]) and (Left.Kind in [tkString, tkUString]) then
    Result := Pos(Left.AsString, Right.AsString) > 0
  else if Right.IsArray then
  begin
    Arr := Right.AsType<TArray<TValue>>;
    for v in Arr do
      if ValuesAreEqual(Left, v) then
      begin
        Result := True;
        Exit;
      end;
  end
  else if Right.IsObject and (Right.AsObject is TDictionary<String, TValue>) then
  begin
    Dict := TDictionary<String, TValue>(Right.AsObject);
    if Left.Kind in [tkString, tkUString] then
      Result := Dict.ContainsKey(Left.AsString);
  end;
end;

/// <summary>
/// Converts a TValue to a Boolean.
/// </summary>
/// <param name="Value">The value to convert.</param>
/// <returns>
/// The Boolean representation.
/// </returns>
/// <remarks>
/// False for empty, zero, empty string/array/dict; True otherwise.
/// </remarks>
function TTina4Twig.ToBool(const Value: TValue): Boolean;
begin
  if Value.IsEmpty then
    Exit(False);

  case Value.Kind of
    tkInteger, tkInt64:
      Result := Value.AsInt64 <> 0;
    tkFloat:
      Result := Value.AsExtended <> 0.0;
    tkString, tkLString, tkWString, tkUString:
      Result := (Value.AsString <> '') and (Value.AsString <> '0');
    tkEnumeration:
      Result := Value.AsBoolean;
    tkDynArray, tkArray:
      Result := Value.GetArrayLength > 0;
    tkClass:
      Result := Value.AsObject <> nil;
    tkRecord: // Assuming dict as record or custom
      if Value.TypeInfo = TypeInfo(TDictionary<String, TValue>) then
        Result := TDictionary<String, TValue>(Value.AsObject).Count > 0
      else
        Result := True; // or handle other records
  else
    Result := False;
  end;
end;

/// <summary>
/// Evaluates and replaces if blocks in the template.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template with if blocks evaluated.
/// </returns>
/// <remarks>
/// Supports conditions like ==, !=, <, >, in, starts with, etc., and optional else.
/// </remarks>
function TTina4Twig.EvaluateIfBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, Op, ValueRaw, IfContent, ElseContent, Replacement: String;
  VarValue, CompareValue: TValue;
  HasCondition: Boolean;
  Condition: Boolean;

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

    if Context.TryGetValue(S, Result) then
      Exit;

    Exit(TValue.From<string>(S));
  end;

begin
  Result := Template;
  Regex := TRegEx.Create(
    '{%\s*if\s+([\w\.]+)(\s*(==|!=|<|>|<=|>=|in|not in|starts with|ends with|matches)\s*(".*?"|''.*?''|\d+(\.\d+)?|true|false|\w+))?\s*%}(.*?)({%\s*else\s*%}(.*?))?{%\s*endif\s*%}',
    [roSingleLine, roIgnoreCase]);

  Match := Regex.Match(Result);
  while Match.Success do
  begin
    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value;
    HasCondition := Match.Groups[2].Success;

    if HasCondition then
    begin
      Op := Match.Groups[3].Value.ToLower;
      ValueRaw := Trim(Match.Groups[4].Value);
      ValueRaw := TrimQuotes(ValueRaw);
      CompareValue := ParseValue(ValueRaw);
    end
    else
    begin
      Op := '';
      CompareValue := TValue.Empty;
    end;

    IfContent := Match.Groups[6].Value;
    ElseContent := '';
    if Match.Groups.Count > 7 then
    begin
      if Match.Groups[7].Success then
        ElseContent := Match.Groups[8].Value;
    end;

    VarValue := ResolveVariablePath(VarName, Context);

    if not HasCondition or (Op = '') then
      Condition := ToBool(VarValue)
    else
    begin
      if Op = '==' then
        Condition := ValuesAreEqual(VarValue, CompareValue)
      else if Op = '!=' then
        Condition := not ValuesAreEqual(VarValue, CompareValue)
      else if Op = '<' then
        Condition := (VarValue.IsOrdinal and CompareValue.IsOrdinal) and (VarValue.AsExtended < CompareValue.AsExtended)
      else if Op = '>' then
        Condition := (VarValue.IsOrdinal and CompareValue.IsOrdinal) and (VarValue.AsExtended > CompareValue.AsExtended)
      else if Op = '<=' then
        Condition := (VarValue.IsOrdinal and CompareValue.IsOrdinal) and (VarValue.AsExtended <= CompareValue.AsExtended)
      else if Op = '>=' then
        Condition := (VarValue.IsOrdinal and CompareValue.IsOrdinal) and (VarValue.AsExtended >= CompareValue.AsExtended)
      else if Op = 'in' then
        Condition := Contains(VarValue, CompareValue)
      else if Op = 'not in' then
        Condition := not Contains(VarValue, CompareValue)
      else if Op = 'starts with' then
        Condition := (VarValue.Kind in [tkString, tkUString]) and (CompareValue.Kind in [tkString, tkUString]) and VarValue.AsString.StartsWith(CompareValue.AsString)
      else if Op = 'ends with' then
        Condition := (VarValue.Kind in [tkString, tkUString]) and (CompareValue.Kind in [tkString, tkUString]) and VarValue.AsString.EndsWith(CompareValue.AsString)
      else if Op = 'matches' then
        Condition := (VarValue.Kind in [tkString, tkUString]) and (CompareValue.Kind in [tkString, tkUString]) and TRegEx.IsMatch(VarValue.AsString, CompareValue.AsString)
      else
        Condition := False;

    end;

    if Condition then
      Replacement := IfContent
    else
      Replacement := ElseContent;

    Result := StringReplace(Result, FullMatch, Replacement, [rfReplaceAll]);
    Match := Match.NextMatch;
  end;
end;

/// <summary>
/// Evaluates and registers macro blocks in the template.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template without macro definitions.
/// </returns>
/// <remarks>
/// Registers macros as functions that can be called later, supporting parameters and defaults.
/// Uses global FMacroParams and FMacroDefaults to store parameter lists and default values.
/// </remarks>
function TTina4Twig.EvaluateMacroBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  MacroName, ParamsStr, MacroBody, ParamName, DefaultValue: String;
  ParamList: TArray<String>;
  Defaults: TDictionary<String, String>;
  ValidParams: TList<String>;
  I: Integer;
  CapturedMacroBody: String;
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*macro\s+(\w+)\s*\(([^)]*)\)\s*%}(.*?){%\s*endmacro\s*%}', [roSingleLine, roIgnoreCase]);

  Match := Regex.Match(Result);
  while Match.Success do
  begin
    MacroName := Match.Groups[1].Value;
    ParamsStr := Match.Groups[2].Value;
    MacroBody := Match.Groups[3].Value;

    // Parse parameters and their defaults
    Defaults := TDictionary<String, String>.Create;
    ValidParams := TList<String>.Create;
    try
      ParamList := ParamsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
      for I := 0 to High(ParamList) do
      begin
        ParamList[I] := Trim(ParamList[I]);
        if ParamList[I] = '' then
          Continue; // Skip empty parameters
        if Pos('=', ParamList[I]) > 0 then
        begin
          var Parts := ParamList[I].Split(['='], 2);
          ParamName := Trim(Parts[0]);
          if ParamName = '' then
            Continue; // Skip invalid parameter names
          DefaultValue := Trim(Parts[1]).Replace('"', '').Replace('''', '');
          ValidParams.Add(ParamName);
          Defaults.AddOrSetValue(ParamName, DefaultValue);
        end
        else
        begin
          ParamName := Trim(ParamList[I]);
          if ParamName <> '' then
            ValidParams.Add(ParamName);
        end;
      end;

      // Convert ValidParams to array for macro execution
      ParamList := ValidParams.ToArray;

      // Capture MacroBody to avoid closure capturing the loop variable
      CapturedMacroBody := MacroBody;

      // Register macro
      FMacros.AddOrSetValue(MacroName,
        function(const Args: TArray<String>; const MacroContext: TDictionary<String, TValue>): String
        var
          LocalContext: TDictionary<String, TValue>;
          I: Integer;
          Rendered: String;
          ArgValue: String;
          params: TArray<String>;
          macroDefaults: TDictionary<String, String>;
          Val: TValue;
        begin
          LocalContext := TDictionary<String, TValue>.Create;
          try
            // Copy existing context
            for var Pair in MacroContext do
              LocalContext.AddOrSetValue(Pair.Key, Pair.Value);

            // Retrieve parameters and defaults from global storage
            if not FMacroParams.TryGetValue(MacroName, params) then
              params := ParamList; // Fallback to local ParamList if not found
            if not FMacroDefaults.TryGetValue(MacroName, macroDefaults) then
              macroDefaults := Defaults; // Fallback to local Defaults if not found

            // Assign arguments to parameters, use defaults if needed
            for I := 0 to High(params) do
            begin
              if (I < 0) or (I > High(params)) or (params[I] = '') then
                Continue; // Skip invalid or empty parameters
              if (I >= 0) and (I < Length(Args)) and (Args[I] <> '') then
              begin
                ArgValue := Trim(Args[I]);
                // Resolve argument if it's a variable in the context
                if MacroContext.TryGetValue(ArgValue, Val) then
                  LocalContext.AddOrSetValue(params[I], Val)
                else
                  LocalContext.AddOrSetValue(params[I], TValue.From<String>(ArgValue));
              end
              else if macroDefaults.ContainsKey(params[I]) then
                LocalContext.AddOrSetValue(params[I], TValue.From<String>(macroDefaults[params[I]]))
              else
                LocalContext.AddOrSetValue(params[I], TValue.Empty);
            end;

            // Render macro body
            Rendered := RenderInternal(CapturedMacroBody, LocalContext);
            Result := Rendered;
          finally
            LocalContext.Free;
          end;
        end);

      // Store parameters and defaults in global dictionaries
      FMacroParams.AddOrSetValue(MacroName, ParamList);
      FMacroDefaults.AddOrSetValue(MacroName, Defaults);

      // Remove macro definition from template
      Result := StringReplace(Result, Match.Value, '', [rfReplaceAll]);
    finally
      ValidParams.Free;
      // Do not free Defaults here; it is stored in FMacroDefaults
    end;
    Match := Match.NextMatch;
  end;
end;

/// <summary>
/// Replaces variable placeholders in the template with context values, applying filters and functions.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template with variables replaced.
/// </returns>
/// <remarks>
/// Handles {{ var | filter(arg) }}, function calls, and macro calls.
/// Prioritizes macro lookup to ensure correct macro execution.
/// </remarks>
function TTina4Twig.ReplaceContextVariables(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, Expr, VarName, FilterChain, FuncName, ArgsStr: String;
  Args: TArray<String>;
  TempVal: TValue;
  Func: TFunctionFunc;
  Macro: TMacroFunc;
  Filter: TFilterFunc;
  FilteredValue: String;
  I: Integer;
  DebugLog: TStringList;
begin
  Result := Template;
  DebugLog := TStringList.Create;
  try
    Regex := TRegEx.Create('{{\s*([^}]+)\s*}}', [roSingleLine, roIgnoreCase]);

    while True do
    begin
      Match := Regex.Match(Result);
      if not Match.Success then
        Break;

      FullMatch := Match.Value;
      Expr := Trim(Match.Groups[1].Value);

      // Split expression into variable/function/macro and filters
      VarName := Expr;
      FilterChain := '';
      if Expr.Contains('|') then
      begin
        var Parts := Expr.Split(['|'], TStringSplitOptions.ExcludeEmpty);
        VarName := Trim(Parts[0]);
        for I := 1 to High(Parts) do
          FilterChain := FilterChain + '|' + Trim(Parts[I]);
      end;

      // Check if it's a macro or function call like name(arg1, arg2)
      if (Pos('(', VarName) > 0) and VarName.EndsWith(')') then
      begin
        FuncName := Trim(Copy(VarName, 1, Pos('(', VarName) - 1));
        ArgsStr := Copy(VarName, Pos('(', VarName) + 1, Length(VarName) - Pos('(', VarName) - 1);
        Args := ArgsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
        for I := 0 to High(Args) do
        begin
          Args[I] := Trim(Args[I]);
          // Handle quoted strings and context variables
          if (Args[I].StartsWith('"') and Args[I].EndsWith('"')) or
             (Args[I].StartsWith('''') and Args[I].EndsWith('''')) then
            Args[I] := Args[I].Substring(1, Args[I].Length - 2)
          else
            Args[I] := Args[I]; // Keep literal value for functions like dump
        end;

        // Debug: Log macro/function call
        DebugLog.Add('Attempting to call: ' + FuncName + ' with args: ' + String.Join(', ', Args));
        DebugLog.Add('Available macros: ' + String.Join(', ', FMacros.Keys.ToArray));
        DebugLog.Add('Available functions: ' + String.Join(', ', FFunctions.Keys.ToArray));

        // Prioritize macro lookup
        if FMacros.ContainsKey(FuncName) then
        begin
          if FMacros.TryGetValue(FuncName, Macro) then
          begin
            FilteredValue := Macro(Args, Context);
            DebugLog.Add('Called macro: ' + FuncName);
          end
          else
          begin
            FilteredValue := '(macro ' + FuncName + ' lookup failed)';
            DebugLog.Add('Failed to lookup macro: ' + FuncName);
          end;
        end
        else if FFunctions.ContainsKey(FuncName) then
        begin
          if FFunctions.TryGetValue(FuncName, Func) then
          begin
            FilteredValue := Func(Args, Context);
            DebugLog.Add('Called function: ' + FuncName);
          end
          else
          begin
            FilteredValue := '(function ' + FuncName + ' lookup failed)';
            DebugLog.Add('Failed to lookup function: ' + FuncName);
          end;
        end
        else
        begin
          FilteredValue := '(function or macro ' + FuncName + ' not found)';
          DebugLog.Add('Macro/function not found: ' + FuncName);
        end;
      end
      else
      begin
        // Resolve variable
        TempVal := ResolveVariablePath(VarName, Context);
        if not TempVal.IsEmpty then
          FilteredValue := TempVal.ToString
        else
          FilteredValue := ''; // Return empty string for undefined variables
      end;

      // Apply filters if any
      if FilterChain <> '' then
      begin
        var Filters := FilterChain.TrimLeft(['|']).Split(['|'], TStringSplitOptions.ExcludeEmpty);
        for var FilterExp in Filters do
        begin
          var FilterExpr := Trim(FilterExp);
          if FilterExpr.Contains('(') and FilterExpr.EndsWith(')') then
          begin
            FuncName := Copy(FilterExpr, 1, Pos('(', FilterExpr) - 1);
            ArgsStr := Copy(FilterExpr, Pos('(', FilterExpr) + 1, Length(FilterExpr) - Pos('(', FilterExpr) - 1);
            Args := ArgsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
            for I := 0 to High(Args) do
              Args[I] := Trim(Args[I]);
          end
          else
          begin
            FuncName := FilterExpr;
            SetLength(Args, 0);
          end;

          if FFilters.TryGetValue(FuncName, Filter) then
            FilteredValue := Filter(FilteredValue, Args)
          else
            FilteredValue := '(filter ' + FuncName + ' not found)';
        end;
      end;

      Result := StringReplace(Result, FullMatch, FilteredValue, [rfReplaceAll]);
    end;

    // Save debug log to file for inspection
    DebugLog.SaveToFile('debug_log.txt');
  finally
    DebugLog.Free;
  end;
end;

/// <summary>
/// Resolves a dotted variable path from the context.
/// </summary>
/// <param name="VariablePath">The path like 'var.sub.key'.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The resolved TValue, or Empty if not found.
/// </returns>
/// <remarks>
/// Supports dictionary keys, array indices, object/record properties via RTTI.
/// </remarks>
function TTina4Twig.ResolveVariablePath(const VariablePath: string; Context: TDictionary<String, TValue>): TValue;
var
  Parts: TArray<string>;
  Current: TValue;
  i: Integer;
  Key: string;
  Dict: TDictionary<String, TValue>;
  Arr: TArray<TValue>;
  Index: Integer;
  RttiCtx: TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
begin
  Parts := VariablePath.Split(['.']);
  if Length(Parts) = 0 then
    Exit(TValue.Empty);

  if not Context.TryGetValue(Parts[0], Current) then
    Exit(TValue.Empty);

  for i := 1 to High(Parts) do
  begin
    Key := Parts[i];

    if Current.IsObject and (Current.AsObject is TDictionary<String, TValue>) then
    begin
      Dict := TDictionary<String, TValue>(Current.AsObject);
      if not Dict.TryGetValue(Key, Current) then
        Exit(TValue.Empty);
    end
    else if Current.IsArray then
    begin
      if TryStrToInt(Key, Index) then
      begin
        Arr := Current.AsType<TArray<TValue>>;
        if (Index >= 0) and (Index < Length(Arr)) then
          Current := Arr[Index]
        else
          Exit(TValue.Empty);
      end
      else
        Exit(TValue.Empty);
    end
    else if Current.IsObject then
    begin
      RttiCtx := TRttiContext.Create;
      try
        RttiType := RttiCtx.GetType(Current.TypeInfo);
        Prop := RttiType.GetProperty(Key);
        if Assigned(Prop) then
          Current := Prop.GetValue(Current.AsObject)
        else
          Exit(TValue.Empty);
      finally
        RttiCtx.Free;
      end;
    end
    else if Current.Kind = tkRecord then
    begin
      RttiCtx := TRttiContext.Create;
      try
        RttiType := RttiCtx.GetType(Current.TypeInfo);
        Prop := RttiType.GetProperty(Key);
        if Assigned(Prop) then
          Current := Prop.GetValue(Current.GetReferenceToRawData)
        else
          Exit(TValue.Empty);
      finally
        RttiCtx.Free;
      end;
    end
    else
      Exit(TValue.Empty);
  end;

  Result := Current;
end;

/// <summary>
/// Loads a template file from the template path.
/// </summary>
/// <param name="TemplateName">The name of the template file.</param>
/// <returns>
/// The content of the template.
/// </returns>
/// <remarks>
/// Removes comments after loading. Raises exception if file not found.
/// </remarks>
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

/// <summary>
/// Parses a string representation of a dictionary.
/// </summary>
/// <param name="DictStr">The string like '{key: value, ...}'.</param>
/// <param name="OuterContext">The outer context for resolving values.</param>
/// <returns>
/// A dictionary of key-value pairs.
/// </returns>
/// <remarks>
/// Attempts JSON parsing first, falls back to simple key:value splitting. Supports numbers, booleans, strings, variables from context.
/// </remarks>
function TTina4Twig.ParseVariableDict(const DictStr: String; OuterContext: TDictionary<String,TValue>): TDictionary<String,TValue>;
var
  Content: String;
  JSONValue: TJSONValue;
  JSONObject: TJSONObject;
  Pair: TJSONPair;
  Key, ValueStr: String;
  Value: TValue;
  Int64Val: Int64;
  FloatVal: Double;
begin
  Result := TDictionary<String, TValue>.Create;
  Content := Trim(DictStr);

  // Remove surrounding braces if present
  if Content.StartsWith('{') and Content.EndsWith('}') then
    Content := Content.Substring(1, Content.Length - 2).Trim;

  if Content = '' then
    Exit;

  // Try to parse as JSON object
  JSONValue := TJSONObject.ParseJSONValue('{' + Content + '}');
  try
    if (JSONValue <> nil) and (JSONValue is TJSONObject) then
    begin
      JSONObject := TJSONObject(JSONValue);
      for Pair in JSONObject do
      begin
        Key := Pair.JsonString.Value;
        ValueStr := Pair.JsonValue.ToString;

        // Handle different JSON value types
        if Pair.JsonValue is TJSONNumber then
        begin
          if TryStrToInt64(ValueStr, Int64Val) then
            Value := TValue.From<Int64>(Int64Val)
          else if TryStrToFloat(ValueStr, FloatVal) then
            Value := TValue.From<Double>(FloatVal)
          else
            Value := TValue.From<String>(ValueStr);
        end
        else if Pair.JsonValue is TJSONTrue then
          Value := TValue.From<Boolean>(True)
        else if Pair.JsonValue is TJSONFalse then
          Value := TValue.From<Boolean>(False)
        else
        begin
          // Remove quotes from string values
          if (ValueStr.StartsWith('"') and ValueStr.EndsWith('"')) or
             (ValueStr.StartsWith('''') and ValueStr.EndsWith('''')) then
            ValueStr := ValueStr.Substring(1, ValueStr.Length - 2);
          // Try to resolve from OuterContext if it's a variable name
          if (OuterContext <> nil) and OuterContext.TryGetValue(ValueStr, Value) then
            // Value already set from context
          else
            Value := TValue.From<String>(ValueStr);
        end;

        Result.AddOrSetValue(Key, Value);
      end;
    end
    else
    begin
      // Fallback for simple key-value pairs (e.g., "key: value, key2: value2")
      var Pairs := Content.Split([','], TStringSplitOptions.ExcludeEmpty);
      for var PairStr in Pairs do
      begin
        var KV := PairStr.Split([':'], 2);
        if Length(KV) = 2 then
        begin
          Key := Trim(KV[0]);
          ValueStr := Trim(KV[1]);

          // Remove quotes from key and value
          if (Key.StartsWith('"') and Key.EndsWith('"')) or
             (Key.StartsWith('''') and Key.EndsWith('''')) then
            Key := Key.Substring(1, Key.Length - 2);
          if (ValueStr.StartsWith('"') and ValueStr.EndsWith('"')) or
             (ValueStr.StartsWith('''') and ValueStr.EndsWith('''')) then
            ValueStr := ValueStr.Substring(1, ValueStr.Length - 2);

          // Try to parse value type
          if TryStrToInt64(ValueStr, Int64Val) then
            Value := TValue.From<Int64>(Int64Val)
          else if TryStrToFloat(ValueStr, FloatVal) then
            Value := TValue.From<Double>(FloatVal)
          else if ValueStr.ToLower = 'true' then
            Value := TValue.From<Boolean>(True)
          else if ValueStr.ToLower = 'false' then
            Value := TValue.From<Boolean>(False)
          else if (OuterContext <> nil) and OuterContext.TryGetValue(ValueStr, Value) then
            // Value resolved from context
          else
            Value := TValue.From<String>(ValueStr);

          Result.AddOrSetValue(Key, Value);
        end;
      end;
    end;
  finally
    JSONValue.Free;
  end;
end;

/// <summary>
/// Evaluates include statements in the template.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template with includes replaced.
/// </returns>
/// <remarks>
/// Supports {% include "file" with {vars} %}, merging contexts.
/// </remarks>
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

/// <summary>
/// Evaluates set statements to add variables to context.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template without set statements.
/// </returns>
/// <remarks>
/// Supports setting simple values, arrays, objects via JSON-like syntax.
/// </remarks>
function TTina4Twig.EvaluateSetBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  VarName, ValueStr: String;
  Value: TValue;
  JSONValue: TJSONValue;
  Dict: TDictionary<String, TValue>;
  Arr: TArray<TValue>;
  I: Integer;
  F: Double;
  IntVal: Int64;
  BoolVal: Boolean;
begin
  Result := Template;
  // Updated regex to handle simple values, arrays, or objects
  Regex := TRegEx.Create('{%\s*set\s+(\w+)\s*=\s*([^%]*?)\s*%}', [roSingleLine, roIgnoreCase]);

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
          if Item.StartsWith('{') and Item.EndsWith('}') then
          begin
            JSONValue := TJSONObject.ParseJSONValue(Item);
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
                Arr[I] := TValue.From<TDictionary<String, TValue>>(Dict);
              end
              else
                Arr[I] := TValue.Empty;
            finally
              JSONValue.Free;
            end;
          end
          else if (Item.StartsWith('"') and Item.EndsWith('"')) or
             (Item.StartsWith('''') and Item.EndsWith('''')) then
            Arr[I] := TValue.From<String>(Copy(Item, 2, Length(Item) - 2))
          else if Item.ToLower = 'true' then
            Arr[I] := TValue.From<Boolean>(True)
          else if Item.ToLower = 'false' then
            Arr[I] := TValue.From<Boolean>(False)
          else if TryStrToInt64(Item, IntVal) then
            Arr[I] := TValue.From<Int64>(IntVal)
          else if TryStrToFloat(Item, F) then
            Arr[I] := TValue.From<Double>(F)
          else
            Arr[I] := TValue.From<String>(Item);
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
    begin
      // Handle simple values (number, string, boolean)
      if TryStrToInt64(ValueStr, IntVal) then
        Value := TValue.From<Int64>(IntVal)
      else if TryStrToFloat(ValueStr, F) then
        Value := TValue.From<Double>(F)
      else if ValueStr.ToLower = 'true' then
        Value := TValue.From<Boolean>(True)
      else if ValueStr.ToLower = 'false' then
        Value := TValue.From<Boolean>(False)
      else if (ValueStr.StartsWith('"') and ValueStr.EndsWith('"')) or
              (ValueStr.StartsWith('''') and ValueStr.EndsWith('''')) then
        Value := TValue.From<String>(Copy(ValueStr, 2, Length(ValueStr) - 2))
      else
        Value := TValue.From<String>(ValueStr);
    end;

    Context.AddOrSetValue(VarName, Value);
    Result := StringReplace(Result, Match.Value, '', [rfReplaceAll]);
  end;
end;

/// <summary>
/// Evaluates with blocks to create scoped contexts.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template with with blocks evaluated.
/// </returns>
/// <remarks>
/// Supports {% with vars only %}, isolating or merging contexts.
/// </remarks>
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
      // Copy outer context only if not using "only"
      if not UseOnly then
      begin
        for Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      end;

      // Process initial variables from WithVarRaw if provided
      if WithVarRaw <> '' then
      begin
        if WithVarRaw.StartsWith('{') and WithVarRaw.EndsWith('}') then
        begin
          ParsedDict := ParseVariableDict(WithVarRaw, Context);
          try
            for Pair in ParsedDict do
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          finally
            ParsedDict.Free;
          end;
        end
        else if Context.TryGetValue(WithVarRaw, VarValue) then
        begin
          if VarValue.IsType<TDictionary<String, TValue>> then
          begin
            ParsedDict := VarValue.AsType<TDictionary<String, TValue>>;
            for Pair in ParsedDict do
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          end
          else
            MergedContext.AddOrSetValue(WithVarRaw, VarValue);
        end;
      end;

      // Render the inner block with the isolated MergedContext
      Evaluated := RenderInternal(InnerBlock, MergedContext);
      Result := StringReplace(Result, FullMatch, Evaluated, [rfReplaceAll]);
    finally
      MergedContext.Free;
    end;
  end;
end;

/// <summary>
/// Evaluates for loops in the template.
/// </summary>
/// <param name="Template">The template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The template with for blocks expanded.
/// </returns>
/// <remarks>
/// Supports {% for var in list %}, arrays, dictionaries, JSON arrays, with optional else.
/// </remarks>
function TTina4Twig.EvaluateForBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, VarName, ListExpr, BlockContent, ElseContent, Output, ArrayContent: String;
  Items: TArray<TDictionary<String, TValue>>;
  Item: TDictionary<String, TValue>;
  MergedContext: TDictionary<String, TValue>;
  Pair: TPair<String, TValue>;
  ArrayItems: TArray<String>;
  I: Integer;
  Value: TValue;
  ValueArray: TArray<TValue>;
  JSONArray: TJSONArray;
begin
  Result := Template;
  // Updated regex to capture optional {% else %} block
  Regex := TRegEx.Create(
    '{%\s*for\s+(\w+)\s+in\s+((?:\[[^\]]*\])|\w+)\s*%}(.*?)({%\s*else\s*%}(.*?))?{%\s*endfor\s*%}',
    [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value.Trim;
    ListExpr := Match.Groups[2].Value.Trim;
    BlockContent := Match.Groups[3].Value.Trim;
    ElseContent := '';
    if Match.Groups.Count > 5 then
      ElseContent := Match.Groups[5].Value.Trim;
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
      else if Value.IsType<TJSONArray> then
      begin
        JSONArray := Value.AsType<TJSONArray>;
        SetLength(Items, JSONArray.Count);
        for I := 0 to JSONArray.Count-1 do
        begin
          Item := TDictionary<String, TValue>.Create;
          Item.Add(VarName, JSONArray[I]);
          Items[I] := Item;
        end;
      end;
    end;

    if (Items = nil) or (Length(Items) = 0) then
    begin
      // If no items, render the else block if it exists
      if ElseContent <> '' then
        Output := RenderInternal(ElseContent, Context);
    end
    else
    begin
      for Item in Items do
      begin
        var subDict: TDictionary<String, TValue> := nil;
        MergedContext := TDictionary<String, TValue>.Create;
        try
          for Pair in Context do
            MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          for Pair in Item do
          begin
            if Pair.Key = VarName then
              if Pair.Value.IsType<TJSONObject> then
              begin
                var jsonObj := Pair.Value.AsType<TJSONObject>;
                subDict := TDictionary<String, TValue>.Create;
                for var jsonPair: TJSONPair in jsonObj do
                begin
                  var val: TValue;
                  if jsonPair.JsonValue is TJSONNumber then
                  begin
                    var numStr := jsonPair.JsonValue.Value;
                    if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                      val := TValue.From<Double>((jsonPair.JsonValue as TJSONNumber).AsDouble)
                    else
                      val := TValue.From<Int64>((jsonPair.JsonValue as TJSONNumber).AsInt64);
                  end
                  else if jsonPair.JsonValue is TJSONBool then
                    val := TValue.From<Boolean>((jsonPair.JsonValue as TJSONBool).AsBoolean)
                  else if jsonPair.JsonValue is TJSONString then
                    val := TValue.From<String>(jsonPair.JsonValue.Value)
                  else if jsonPair.JsonValue is TJSONNull then
                    val := TValue.Empty
                  else
                    val := TValue.From<String>(jsonPair.JsonValue.ToString);
                  subDict.AddOrSetValue(jsonPair.JsonString.Value, val);
                end;
                MergedContext.AddOrSetValue(VarName, TValue.From<TDictionary<String,TValue>>(subDict));
              end
              else
                MergedContext.AddOrSetValue(VarName, Pair.Value)
            else
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          end;
          Output := Output + Self.RenderInternal(BlockContent, MergedContext);
        finally
          if subDict <> nil then
            subDict.Free;
          MergedContext.Free;
        end;
      end;

      if ListExpr.StartsWith('[') or (Context.ContainsKey(ListExpr) and Value.IsArray) then
      begin
        for Item in Items do
          Item.Free;
      end;
    end;

    Result := StringReplace(Result, FullMatch, Output, [rfReplaceAll]);
  end;
end;

/// <summary>
/// Evaluates extends statements for template inheritance.
/// </summary>
/// <param name="Template">The child template string.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>
/// The rendered base template with child blocks overridden.
/// </returns>
/// <remarks>
/// Replaces blocks in parent with child content, falls back to parent defaults.
/// </remarks>
function TTina4Twig.EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
var
  ExtendRegex, BlockRegex: TRegEx;
  Match, BlockMatch: TMatch;
  ParentTemplateName, BaseTemplate, BlockName, BlockContent: String;
  ChildBlocks, BaseBlocks: TDictionary<String, String>;

  function ReplaceBlockInTemplate(const TemplateText, BlockName, NewContent: String): String;
  var
    Regex: TRegEx;
    MatchBlock: TMatch;
  begin
    // Replace {% block blockname %} ... {% endblock %} with NewContent, fall back to default if no match
    Regex := TRegEx.Create(
      '{%\s*block\s+' + TRegEx.Escape(BlockName) + '\s*%}(.*?){%\s*endblock\s*%}',
      [roSingleLine, roIgnoreCase]
    );
    MatchBlock := Regex.Match(TemplateText);
    if MatchBlock.Success then
      Result := Regex.Replace(TemplateText, NewContent)
    else
      Result := TemplateText; // Retain original template with default content
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
  ChildBlocks := TDictionary<String, String>.Create;
  try
    BlockRegex := TRegEx.Create('{%\s*block\s+(\w+)\s*%}(.*?){%\s*endblock\s*%}', [roSingleLine, roIgnoreCase]);
    BlockMatch := BlockRegex.Match(ChildTemplateWithoutExtends);
    while BlockMatch.Success do
    begin
      BlockName := BlockMatch.Groups[1].Value;
      BlockContent := BlockMatch.Groups[2].Value.Trim;
      ChildBlocks.AddOrSetValue(BlockName, BlockContent);
      BlockMatch := BlockMatch.NextMatch;
    end;

    // Collect blocks from base template
    BaseBlocks := TDictionary<String, String>.Create;
    BlockMatch := BlockRegex.Match(BaseTemplate);
    while BlockMatch.Success do
    begin
      BlockName := BlockMatch.Groups[1].Value;
      BlockContent := BlockMatch.Groups[2].Value.Trim;
      BaseBlocks.AddOrSetValue(BlockName, BlockContent);
      BlockMatch := BlockMatch.NextMatch;
    end;

    // Replace blocks in base template with child's block content if available, otherwise use base default
    for BlockName in BaseBlocks.Keys do
    begin
      if ChildBlocks.ContainsKey(BlockName) then
        BlockContent := ChildBlocks[BlockName]
      else
        BlockContent := BaseBlocks[BlockName];
      BaseTemplate := ReplaceBlockInTemplate(BaseTemplate, BlockName, BlockContent);
    end;

    Result := BaseTemplate;
  finally
    ChildBlocks.Free;
    BaseBlocks.Free;
  end;
end;

/// <summary>
/// Registers default Twig-like filters.
/// </summary>
/// <remarks>
/// Clears existing filters and adds implementations for abs, capitalize, date, escape, etc. Some are stubs.
/// </remarks>
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
    var
      Strategy: String;
    begin
      Strategy := 'html';
      if Length(Args) > 0 then
        Strategy := LowerCase(Args[0]);

      if Strategy =  'html' then
          begin
            Result := StringReplace(Input, '&', '&amp;', [rfReplaceAll]);
            Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
            Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
            Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
            Result := StringReplace(Result, '''', '&#39;', [rfReplaceAll]);
          end
      else
      if Strategy =  'js' then
      begin
            // Basic JS escaping
            Result := StringReplace(Input, '\', '\\', [rfReplaceAll]);
            Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
            Result := StringReplace(Result, '''', '\''', [rfReplaceAll]);
            Result := StringReplace(Result, sLineBreak, '\n', [rfReplaceAll]);
      end
        else
      if Strategy =  'css' then
      begin
            // Simple CSS escaping, can be improved
            Result := TNetEncoding.URL.Encode(Input);
      end
        else
     if Strategy =  'url' then
     begin
            Result := TNetEncoding.URL.Encode(Input);
     end
       else
     if Strategy =  'html_attr' then
     begin
        // HTML attribute escaping
        Result := StringReplace(Input, '&', '&amp;', [rfReplaceAll]);
        Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
        Result := StringReplace(Result, '''', '&#x27;', [rfReplaceAll]);
        Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
        Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
     end
        else
          Result := Input; // Unknown strategy, no escaping
    end);

  FFilters.Add('e', FFilters['escape']);

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

/// <summary>
/// Renders a template or content string with variables.
/// </summary>
/// <param name="TemplateOrContent">Template name or direct content.</param>
/// <param name="Variables">Optional additional variables.</param>
/// <returns>
/// The rendered string.
/// </returns>
/// <remarks>
/// Delegates to RenderInternal with global context.
/// </remarks>
function TTina4Twig.Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;
begin
  Result := RenderInternal(TemplateOrContent, FContext);
end;

/// <summary>
/// Internal rendering logic for templates.
/// </summary>
/// <param name="TemplateOrContent">Template name or content.</param>
/// <param name="Context">The rendering context.</param>
/// <returns>
/// The fully rendered template.
/// </returns>
/// <remarks>
/// Processes in order: comments, macros, sets, extends, fors, includes, withs, ifs, variables.
/// Loads file if name provided, else treats as content.
/// </remarks>
function TTina4Twig.RenderInternal(const TemplateOrContent: String; Context: TStringDict): String;
var
  TemplateText, FullPath: String;
  LocalContext: TDictionary<String, TValue>;
begin
  LocalContext := TDictionary<String, TValue>.Create;
  try
    // Copy the provided context to LocalContext
    for var Pair in Context do
      LocalContext.AddOrSetValue(Pair.Key, Pair.Value);

    FullPath := IncludeTrailingPathDelimiter(FTemplatePath) + TemplateOrContent;

    if FileExists(FullPath) then
      TemplateText := LoadTemplate(TemplateOrContent)
    else
      TemplateText := TemplateOrContent;

    TemplateText := RemoveComments(TemplateText);
    TemplateText := EvaluateMacroBlocks(TemplateText, LocalContext); // Process macros first
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

/// <summary>
/// Sets a variable in the global context.
/// </summary>
/// <param name="AName">The variable name.</param>
/// <param name="AValue">The value, supporting records and JSON objects converted to dictionaries.</param>
/// <remarks>
/// Uses RTTI for records, parses JSON objects.
/// </remarks>
procedure TTina4Twig.SetVariable(AName: string; AValue: TValue);
var
  recRtti: TRttiContext;
  recType: TRttiType;
  recProp: TRttiProperty;
  recDict: TDictionary<String, TValue>;
  jsonObj: TJSONObject;
  jsonPair: TJSONPair;
  val: TValue;
begin
  if AValue.Kind = tkRecord then
  begin
    recDict := TDictionary<String, TValue>.Create;
    try
      recType := recRtti.GetType(AValue.TypeInfo);
      for recProp in recType.GetProperties do
        recDict.AddOrSetValue(recProp.Name, recProp.GetValue(AValue.GetReferenceToRawData));
      FContext.AddOrSetValue(AName, TValue.From(recDict));
    except
      recDict.Free;
      raise;
    end;
  end
  else if AValue.IsObject and (AValue.AsObject is TJSONObject) then
  begin
    jsonObj := AValue.AsObject as TJSONObject;
    recDict := TDictionary<String, TValue>.Create;
    try
      for jsonPair in jsonObj do
      begin
        if jsonPair.JsonValue is TJSONNumber then
        begin
          if (Pos('.', jsonPair.JsonValue.Value) > 0) or (Pos('e', LowerCase(jsonPair.JsonValue.Value)) > 0) then
            val := TValue.From<Double>((jsonPair.JsonValue as TJSONNumber).AsDouble)
          else
            val := TValue.From<Int64>((jsonPair.JsonValue as TJSONNumber).AsInt64);
        end
        else if jsonPair.JsonValue is TJSONBool then
          val := TValue.From<Boolean>((jsonPair.JsonValue as TJSONBool).AsBoolean)
        else if jsonPair.JsonValue is TJSONString then
          val := TValue.From<String>(jsonPair.JsonValue.Value)
        else if jsonPair.JsonValue is TJSONNull then
          val := TValue.Empty
        else
          val := TValue.From<String>(jsonPair.JsonValue.ToString);
        recDict.AddOrSetValue(jsonPair.JsonString.Value, val);
      end;
      FContext.AddOrSetValue(AName, TValue.From(recDict));
    except
      recDict.Free;
      raise;
    end;
  end
  else
  begin
    FContext.AddOrSetValue(AName, AValue); // Store directly
  end;
end;

end.
