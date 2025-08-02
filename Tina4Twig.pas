unit Tina4Twig;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math, Variants;

type
  TStringDict = TDictionary<String, TValue>;
  TFilterFunc = reference to function(const Input: TValue; const Args: TArray<String>): String;
  TFunctionFunc = reference to function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String;
  TMacroFunc = reference to function(const MacroName: String; const Args: TArray<String>; const MacroContext: TDictionary<String, TValue>): String;

  TTina4Twig = class(TObject)
  private
    FContext: TDictionary<String, TValue>;
    FFilters: TDictionary<String, TFilterFunc>;
    FFunctions: TDictionary<String, TFunctionFunc>;
    FMacros: TDictionary<String, TMacroFunc>;
    FMacroParams: TDictionary<String, TArray<String>>;
    FMacroDefaults: TDictionary<String, TDictionary<String, String>>;
    FMacroBodies: TDictionary<String, String>;
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
  FMacroBodies := TDictionary<String, String>.Create;

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
  FMacroBodies.Free;
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
begin
  Result := Template;
  Regex := TRegEx.Create('{%\s*macro\s+(\w+)\s*\(([^)]*)\)\s*%}(.*?){%\s*endmacro\s*%}', [roSingleLine, roIgnoreCase]);

  Match := Regex.Match(Result);
  while Match.Success do
  begin
    MacroName := Match.Groups[1].Value;
    ParamsStr := Match.Groups[2].Value;
    MacroBody := Match.Groups[3].Value;

    // Parse parameters and defaults
    Defaults := TDictionary<String, String>.Create;
    ValidParams := TList<String>.Create;
    try
      ParamList := ParamsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
      for I := 0 to High(ParamList) do
      begin
        ParamList[I] := Trim(ParamList[I]);
        if ParamList[I] = '' then
          Continue;
        if Pos('=', ParamList[I]) > 0 then
        begin
          var Parts := ParamList[I].Split(['='], 2);
          ParamName := Trim(Parts[0]);
          if ParamName = '' then
            Continue;
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

      // Store macro body and parameters
      FMacroBodies.AddOrSetValue(MacroName, MacroBody);
      FMacroParams.AddOrSetValue(MacroName, ValidParams.ToArray);
      FMacroDefaults.AddOrSetValue(MacroName, Defaults);

      // Register macro with captured body and parameters
      FMacros.AddOrSetValue(MacroName,
        function(const AName: String; const Args: TArray<String>; const MacroContext: TDictionary<String, TValue>): String
        var
          LocalContext: TDictionary<String, TValue>;
          I: Integer;
          Rendered: String;
          ArgValue: String;
          CapturedParams: TArray<String>;
          CapturedDefaults: TDictionary<String, String>;
          CapturedBody: String;
          Val: TValue;
        begin
          // Retrieve captured macro data
          if not FMacroParams.TryGetValue(AName, CapturedParams) then
            Exit('(macro ' + AName + ' parameters not found)');
          if not FMacroDefaults.TryGetValue(AName, CapturedDefaults) then
            Exit('(macro ' + AName + ' defaults not found)');
          if not FMacroBodies.TryGetValue(AName, CapturedBody) then
            Exit('(macro ' + AName + ' body not found)');

          LocalContext := TDictionary<String, TValue>.Create;
          try
            // Copy existing context
            for var Pair in MacroContext do
              LocalContext.AddOrSetValue(Pair.Key, Pair.Value);

            // Assign arguments to parameters
            for I := 0 to High(CapturedParams) do
            begin
              if CapturedParams[I] = '' then
                Continue;
              if (I < Length(Args)) and (Args[I] <> '') then
              begin
                ArgValue := Trim(Args[I]);
                if MacroContext.TryGetValue(ArgValue, Val) then
                  LocalContext.AddOrSetValue(CapturedParams[I], Val)
                else
                  LocalContext.AddOrSetValue(CapturedParams[I], TValue.From<String>(ArgValue));
              end
              else if CapturedDefaults.TryGetValue(CapturedParams[I], ArgValue) then
                LocalContext.AddOrSetValue(CapturedParams[I], TValue.From<String>(ArgValue))
              else
                LocalContext.AddOrSetValue(CapturedParams[I], TValue.Empty);
            end;

            // Render macro body
            Rendered := RenderInternal(CapturedBody, LocalContext);
            Result := Rendered;
          finally
            LocalContext.Free;
          end;
        end);

      // Remove macro definition from template
      Result := StringReplace(Result, Match.Value, '', [rfReplaceAll]);
    finally
      ValidParams.Free;
      // Defaults is stored in FMacroDefaults, not freed here
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

      VarName := Expr;
      FilterChain := '';
      if Expr.Contains('|') then
      begin
        var Parts := Expr.Split(['|'], TStringSplitOptions.ExcludeEmpty);
        VarName := Trim(Parts[0]);
        for I := 1 to High(Parts) do
          FilterChain := FilterChain + '|' + Trim(Parts[I]);
      end;

      if (Pos('(', VarName) > 0) and VarName.EndsWith(')') then
      begin
        FuncName := Trim(Copy(VarName, 1, Pos('(', VarName) - 1));
        ArgsStr := Copy(VarName, Pos('(', VarName) + 1, Length(VarName) - Pos('(', VarName) - 1);
        Args := ArgsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
        for I := 0 to High(Args) do
        begin
          Args[I] := Trim(Args[I]);
          if (Args[I].StartsWith('"') and Args[I].EndsWith('"')) or
             (Args[I].StartsWith('''') and Args[I].EndsWith('''')) then
            Args[I] := Args[I].Substring(1, Args[I].Length - 2)
          else
            Args[I] := Args[I];
        end;

        DebugLog.Add('Attempting to call: ' + FuncName + ' with args: ' + String.Join(', ', Args));
        DebugLog.Add('Available macros: ' + String.Join(', ', FMacros.Keys.ToArray));
        DebugLog.Add('Available functions: ' + String.Join(', ', FFunctions.Keys.ToArray));

        if FMacros.ContainsKey(FuncName) then
        begin
          if FMacros.TryGetValue(FuncName, Macro) then
          begin
            FilteredValue := Macro(FuncName, Args, Context);
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
        TempVal := ResolveVariablePath(VarName, Context);
        if FilterChain <> '' then
        begin
          FilteredValue := TempVal.ToString; // Initialize for filter chain
          var Filters := FilterChain.TrimLeft(['|']).Split(['|'], TStringSplitOptions.ExcludeEmpty);
          var CurrentVal := TempVal; // Start with raw TValue
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
            begin
              FilteredValue := Filter(CurrentVal, Args);
              DebugLog.Add('Applied filter: ' + FuncName + ', result: ' + FilteredValue);
              CurrentVal := TValue.From<String>(FilteredValue);
            end
            else
            begin
              FilteredValue := '(filter ' + FuncName + ' not found)';
              DebugLog.Add('Failed to lookup filter: ' + FuncName);
              CurrentVal := TValue.From<String>(FilteredValue);
            end;
          end;
        end
        else if not TempVal.IsEmpty then
          FilteredValue := TempVal.ToString
        else
          FilteredValue := ''; // Return empty string for undefined variables
      end;

      Result := StringReplace(Result, FullMatch, FilteredValue, [rfReplaceAll]);
    end;

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
  Regex: TRegEx;
  Matches: TMatchCollection;
  Parts: TArray<string>;
  Current: TValue;
  i: Integer;
  Key: string;
  Dict: TDictionary<String, TValue>;
  Arr: TArray<TValue>;
  JSONArray: TJSONArray;
  Index: Integer;
  RttiCtx: TRttiContext;
  RttiType: TRttiType;
  Prop: TRttiProperty;
begin
  Result := TValue.Empty;

  // Regex to match identifiers, array indices, or quoted strings
  Regex := TRegEx.Create('(\w+|\[\d+\]|''[^'']*''|"[^"]*")', [roIgnoreCase]);
  Matches := Regex.Matches(VariablePath);
  SetLength(Parts, Matches.Count);
  for i := 0 to Matches.Count - 1 do
  begin
    Parts[i] := Matches[i].Value;
    // Remove quotes from quoted strings
    if (Parts[i].StartsWith('"') and Parts[i].EndsWith('"')) or
       (Parts[i].StartsWith('''') and Parts[i].EndsWith('''')) then
      Parts[i] := Parts[i].Substring(1, Parts[i].Length - 2);
  end;

  if Length(Parts) = 0 then
    Exit(TValue.Empty);

  // Initial lookup
  if not Context.TryGetValue(Parts[0], Current) then
    Exit(TValue.Empty);

  // Process each part of the path
  for i := 1 to High(Parts) do
  begin
    Key := Parts[i];

    // Handle array index (e.g., [0])
    if (Key.StartsWith('[') and Key.EndsWith(']')) then
    begin
      // Extract index from [0]
      if TryStrToInt(Copy(Key, 2, Length(Key) - 2), Index) then
      begin
        // Handle TArray<TValue>
        if Current.IsType<TArray<TValue>> then
        begin
          Arr := Current.AsType<TArray<TValue>>;
          if (Index >= 0) and (Index < Length(Arr)) then
            Current := Arr[Index]
          else
            Exit(TValue.Empty);
        end
        // Handle TJSONArray
        else if Current.IsObject and (Current.AsObject is TJSONArray) then
        begin
          JSONArray := TJSONArray(Current.AsObject);
          if (Index >= 0) and (Index < JSONArray.Count) then
          begin
            var JSONVal := JSONArray.Items[Index];
            if JSONVal is TJSONNumber then
              Current := TValue.From<Double>(TJSONNumber(JSONVal).AsDouble)
            else if JSONVal is TJSONString then
              Current := TValue.From<String>(TJSONString(JSONVal).Value)
            else if JSONVal is TJSONBool then
              Current := TValue.From<Boolean>(TJSONBool(JSONVal).AsBoolean)
            else if JSONVal is TJSONNull then
              Current := TValue.Empty
            else if JSONVal is TJSONObject then
            begin
              Dict := TDictionary<String, TValue>.Create;
              try
                for var Pair in TJSONObject(JSONVal) do
                begin
                  if Pair.JsonValue is TJSONNumber then
                  begin
                    var numStr := Pair.JsonValue.Value;
                    if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                      Dict.Add(Pair.JsonString.Value, TValue.From<Double>(TJSONNumber(Pair.JsonValue).AsDouble))
                    else
                      Dict.Add(Pair.JsonString.Value, TValue.From<Int64>(TJSONNumber(Pair.JsonValue).AsInt64));
                  end
                  else if Pair.JsonValue is TJSONBool then
                    Dict.Add(Pair.JsonString.Value, TValue.From<Boolean>(TJSONBool(Pair.JsonValue).AsBoolean))
                  else if Pair.JsonValue is TJSONString then
                    Dict.Add(Pair.JsonString.Value, TValue.From<String>(TJSONString(Pair.JsonValue).Value))
                  else if Pair.JsonValue is TJSONNull then
                    Dict.Add(Pair.JsonString.Value, TValue.Empty)
                  else
                    Dict.Add(Pair.JsonString.Value, TValue.From<String>(Pair.JsonValue.ToString));
                end;
                Current := TValue.From<TDictionary<String, TValue>>(Dict);
              except
                Dict.Free;
                raise;
              end;
            end
            else
              Current := TValue.From<String>(JSONVal.ToString);
          end
          else
            Exit(TValue.Empty);
        end
        else
          Exit(TValue.Empty);
      end
      else
        Exit(TValue.Empty);
    end
    // Handle dictionary or property access
    else
    begin
      if Current.IsObject and (Current.AsObject is TDictionary<String, TValue>) then
      begin
        Dict := TDictionary<String, TValue>(Current.AsObject);
        if Dict.TryGetValue(Key, Current) then
          // Successfully retrieved value
        else
          Exit(TValue.Empty);
      end
      // Handle object property access via RTTI
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
      // Handle record property access via RTTI
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
  BoolVal: Boolean;
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
        else if Pair.JsonValue is TJSONString then
          Value := TValue.From<String>(TJSONString(Pair.JsonValue).Value)
        else if Pair.JsonValue is TJSONNull then
          Value := TValue.Empty
        else
        begin
          // Try to resolve from OuterContext if it's a variable name
          ValueStr := TJSONString(Pair.JsonValue).Value;
          if (OuterContext <> nil) and OuterContext.TryGetValue(ValueStr, Value) then
            // Value resolved from context
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
  // Regex to capture 'with' block, ensuring 'only' is not part of WithVarRaw
  Regex := TRegEx.Create('{%\s*with\s+((?:(?!\s*only\s*%).)*?)(\s*only)?\s*%}(.*?){%\s*endwith\s*%}', [roIgnoreCase, roSingleLine]);

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
      // Copy parent context only if 'only' is not specified
      if not UseOnly then
      begin
        for Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      end;

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
        else
        begin
          VarValue := ResolveVariablePath(WithVarRaw, Context);
          if not VarValue.IsEmpty then
          begin
            if VarValue.IsType<TDictionary<String, TValue>> then
            begin
              ParsedDict := VarValue.AsType<TDictionary<String, TValue>>;
              for Pair in ParsedDict do
                MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
            end
            else if VarValue.IsObject and (VarValue.AsObject is TJSONObject) then
            begin
              ParsedDict := TDictionary<String, TValue>.Create;
              try
                for var JPair in TJSONObject(VarValue.AsObject) do
                begin
                  var PVal: TValue;
                  if JPair.JsonValue is TJSONNumber then
                  begin
                    var numStr := JPair.JsonValue.Value;
                    if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                      PVal := TValue.From<Double>(TJSONNumber(JPair.JsonValue).AsDouble)
                    else
                      PVal := TValue.From<Int64>(TJSONNumber(JPair.JsonValue).AsInt64);
                  end
                  else if JPair.JsonValue is TJSONBool then
                    PVal := TValue.From<Boolean>(TJSONBool(JPair.JsonValue).AsBoolean)
                  else if JPair.JsonValue is TJSONString then
                    PVal := TValue.From<String>(TJSONString(JPair.JsonValue).Value)
                  else if JPair.JsonValue is TJSONNull then
                    PVal := TValue.Empty
                  else
                    PVal := TValue.From<String>(JPair.JsonValue.ToString);
                  ParsedDict.AddOrSetValue(JPair.JsonString.Value, PVal);
                end;
                for Pair in ParsedDict do
                  MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
              finally
                ParsedDict.Free;
              end;
            end
            else
              MergedContext.AddOrSetValue(WithVarRaw, VarValue);
          end;
        end;
      end;

      // Recursively evaluate nested 'with' blocks before rendering other constructs
      Evaluated := EvaluateWithBlocks(InnerBlock, MergedContext);
      // Render the inner block with the merged context
      Evaluated := RenderInternal(Evaluated, MergedContext);
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
  FullMatch, VarName, ListExpr, BlockContent, ElseContent, Output: String;
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
  Regex := TRegEx.Create(
    '{%\s*for\s+(\w+)\s+in\s+((?:\[[^\]]*\])|\w+(?:\.\w+|\[\d+\])?)\s*%}(.*)({%\s*else\s*%}(.*))?{%\s*endfor\s*%}',
    [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    VarName := Match.Groups[1].Value.Trim;
    ListExpr := Match.Groups[2].Value.Trim;
    BlockContent := Match.Groups[3].Value;
    ElseContent := '';
    if Match.Groups.Count > 5 then
      ElseContent := Match.Groups[5].Value;
    Output := '';
    Items := nil;

    if ListExpr.StartsWith('[') and ListExpr.EndsWith(']') then
    begin
      var ArrayContent := Copy(ListExpr, 2, Length(ListExpr) - 2).Trim;
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
      end
      else
      begin
        SetLength(Items, 0); // Explicitly set empty array for inline empty array
      end;
    end
    else
    begin
      Value := ResolveVariablePath(ListExpr, Context);
      if Value.IsEmpty then
      begin
        Output := RenderInternal(ElseContent, Context); // Render else block for undefined variable
        Result := StringReplace(Result, FullMatch, Output, [rfReplaceAll]);
        Continue; // Skip further processing
      end
      else if Value.IsArray then
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
        var Dict := Value.AsType<TDictionary<String, TValue>>;
        SetLength(Items, Dict.Count);
        I := 0;
        for Pair in Dict do
        begin
          Item := TDictionary<String, TValue>.Create;
          Item.Add(VarName, Pair.Value);
          Items[I] := Item;
          Inc(I);
        end;
      end
      else if Value.IsType<TJSONArray> then
      begin
        JSONArray := Value.AsType<TJSONArray>;
        SetLength(Items, JSONArray.Count);
        for I := 0 to JSONArray.Count - 1 do
        begin
          Item := TDictionary<String, TValue>.Create;
          var JSONVal := JSONArray.Items[I];
          if JSONVal is TJSONString then
            Item.Add(VarName, TValue.From<String>(TJSONString(JSONVal).Value))
          else if JSONVal is TJSONNumber then
          begin
            var numStr := JSONVal.Value;
            if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
              Item.Add(VarName, TValue.From<Double>(TJSONNumber(JSONVal).AsDouble))
            else
              Item.Add(VarName, TValue.From<Int64>(TJSONNumber(JSONVal).AsInt64));
          end
          else if JSONVal is TJSONBool then
            Item.Add(VarName, TValue.From<Boolean>(TJSONBool(JSONVal).AsBoolean))
          else if JSONVal is TJSONNull then
            Item.Add(VarName, TValue.Empty)
          else
            Item.Add(VarName, TValue.From<String>(JSONVal.ToString));
          Items[I] := Item;
        end;
      end
      else
      begin
        SetLength(Items, 0); // Non-iterable value treated as empty
      end;
    end;

    if (Items = nil) or (Length(Items) = 0) then
    begin
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
                MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          end;
          Output := Output + RenderInternal(BlockContent, MergedContext);
        finally
          if subDict <> nil then
            subDict.Free;
          MergedContext.Free;
        end;
      end;

      if ListExpr.StartsWith('[') or Value.IsArray or Value.IsType<TJSONArray> then
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
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Val: Double;
    begin
      if Input.IsOrdinal and Input.IsType<Int64> then
        Result := IntToStr(Abs(Input.AsInt64))
      else if Input.IsType<Real> then
        Result := FloatToStr(Abs(Input.AsExtended))
      else if Input.Kind in [tkString, tkUString] then
        Result := FloatToStr(Abs(Val))
      else
        Result := Input.ToString;
    end);

  FFilters.Add('batch',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Size: Integer;
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      I, J: Integer;
      Batch: TStringBuilder;
    begin
      if Length(Args) = 0 then
        Exit(Input.ToString);
      Size := StrToIntDef(Args[0], 1);
      if Size < 1 then
        Size := 1;

      Batch := TStringBuilder.Create;
      try
        if Input.IsArray then
        begin
          Arr := Input.AsType<TArray<TValue>>;
          Batch.Append('[');
          for I := 0 to (Length(Arr) - 1) div Size do
          begin
            if I > 0 then
              Batch.Append(',');
            Batch.Append('[');
            for J := 0 to Size - 1 do
            begin
              if I * Size + J < Length(Arr) then
              begin
                if J > 0 then
                  Batch.Append(',');
                Batch.Append(Arr[I * Size + J].ToString);
              end;
            end;
            Batch.Append(']');
          end;
          Batch.Append(']');
          Result := Batch.ToString;
        end
        else if Input.IsObject and (Input.AsObject is TJSONArray) then
        begin
          JSONArray := TJSONArray(Input.AsObject);
          Batch.Append('[');
          for I := 0 to (JSONArray.Count - 1) div Size do
          begin
            if I > 0 then
              Batch.Append(',');
            Batch.Append('[');
            for J := 0 to Size - 1 do
            begin
              if I * Size + J < JSONArray.Count then
              begin
                if J > 0 then
                  Batch.Append(',');
                Batch.Append(JSONArray.Items[I * Size + J].ToString);
              end;
            end;
            Batch.Append(']');
          end;
          Batch.Append(']');
          Result := Batch.ToString;
        end
        else
          Result := Input.ToString;
      finally
        Batch.Free;
      end;
    end);

  FFilters.Add('capitalize',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if (Input.Kind in [tkString, tkUString]) and (Input.AsString <> '') then
        Result := UpperCase(Input.AsString[1]) + LowerCase(Copy(Input.AsString, 2, MaxInt))
      else
        Result := Input.ToString;
    end);

  FFilters.Add('column',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Key: String;
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      Dict: TDictionary<String, TValue>;
      I: Integer;
      Output: TStringBuilder;
    begin
      if Length(Args) = 0 then
        Exit(Input.ToString);
      Key := Args[0];

      Output := TStringBuilder.Create;
      try
        Output.Append('[');
        if Input.IsArray then
        begin
          Arr := Input.AsType<TArray<TValue>>;
          for I := 0 to High(Arr) do
          begin
            if Arr[I].IsObject and (Arr[I].AsObject is TDictionary<String, TValue>) then
            begin
              Dict := TDictionary<String, TValue>(Arr[I].AsObject);
              if Dict.ContainsKey(Key) then
              begin
                if I > 0 then
                  Output.Append(',');
                Output.Append(Dict[Key].ToString);
              end;
            end;
          end;
        end
        else if Input.IsObject and (Input.AsObject is TJSONArray) then
        begin
          JSONArray := TJSONArray(Input.AsObject);
          for I := 0 to JSONArray.Count - 1 do
          begin
            if JSONArray.Items[I] is TJSONObject then
            begin
              var Obj := TJSONObject(JSONArray.Items[I]);
              var Pair := Obj.Get(Key);
              if Assigned(Pair) then
              begin
                if I > 0 then
                  Output.Append(',');
                Output.Append(Pair.JsonValue.ToString);
              end;
            end;
          end;
        end;
        Output.Append(']');
        Result := Output.ToString;
      finally
        Output.Free;
      end;
    end);

  FFilters.Add('convert_encoding',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: encoding conversion not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('country_name',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: country name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_name',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: currency name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_symbol',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: currency symbol lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('data_uri',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := 'data:;base64,' + TNetEncoding.Base64.Encode(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('date',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      dt: TDateTime;
      fmt: String;
    begin
      if Length(Args) > 0 then
        fmt := Args[0]
      else
        fmt := 'yyyy-mm-dd';
      if (Input.Kind in [tkString, tkUString]) and TryStrToDateTime(Input.AsString, dt) then
        Result := FormatDateTime(fmt, dt)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('date_modify',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: date arithmetic not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('default',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if (Input.IsEmpty or (Input.Kind in [tkString, tkUString]) and (Input.AsString = '')) then
      begin
        if Length(Args) > 0 then
          Result := Args[0]
        else
          Result := '';
      end
      else
        Result := Input.ToString;
    end);

    FFilters.Add('escape',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Strategy: String;
      InputStr: String;
    begin
      if Input.IsEmpty then
        Exit(''); // Return empty string for TValue.Empty

      InputStr := Input.ToString;
      Strategy := 'html';
      if Length(Args) > 0 then
        Strategy := LowerCase(Args[0]);

      if Strategy = 'html' then
      begin
        Result := StringReplace(InputStr, '&', '&amp;', [rfReplaceAll]);
        Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
        Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
        Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
        Result := StringReplace(Result, '''', '&#39;', [rfReplaceAll]);
      end
      else if Strategy = 'js' then
      begin
        Result := StringReplace(InputStr, '\', '\\', [rfReplaceAll]);
        Result := StringReplace(Result, '"', '\"', [rfReplaceAll]);
        Result := StringReplace(Result, '''', '\''', [rfReplaceAll]);
        Result := StringReplace(Result, sLineBreak, '\n', [rfReplaceAll]);
      end
      else if Strategy = 'css' then
        Result := TNetEncoding.URL.Encode(InputStr)
      else if Strategy = 'url' then
        Result := TNetEncoding.URL.Encode(InputStr)
      else if Strategy = 'html_attr' then
      begin
        Result := StringReplace(InputStr, '&', '&amp;', [rfReplaceAll]);
        Result := StringReplace(Result, '"', '&quot;', [rfReplaceAll]);
        Result := StringReplace(Result, '''', '&#x27;', [rfReplaceAll]);
        Result := StringReplace(Result, '<', '&lt;', [rfReplaceAll]);
        Result := StringReplace(Result, '>', '&gt;', [rfReplaceAll]);
      end
      else
        Result := InputStr;
    end);

  FFilters.Add('e', FFilters['escape']);

  FFilters.Add('filter',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: generic filter not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('find',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if (Length(Args) > 0) and (Input.Kind in [tkString, tkUString]) then
      begin
        var idx := Pos(Args[0], Input.AsString);
        if idx > 0 then
          Result := IntToStr(idx)
        else
          Result := '-1';
      end
      else
        Result := '-1';
    end);

  FFilters.Add('first',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if (Input.Kind in [tkString, tkUString]) and (Input.AsString <> '') then
        Result := Input.AsString[1]
      else if Input.IsArray and (Input.GetArrayLength > 0) then
        Result := Input.AsType<TArray<TValue>>[0].ToString
      else if Input.IsObject and (Input.AsObject is TJSONArray) and (TJSONArray(Input.AsObject).Count > 0) then
        Result := TJSONArray(Input.AsObject).Items[0].ToString
      else
        Result := '';
    end);

  FFilters.Add('format',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Length(Args) > 0 then
        Result := Format(Args[0], [Input.ToString])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('format_currency',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Val: Double;
      Currency: String;
    begin
      Currency := '';
      if Length(Args) > 0 then
        Currency := Args[0];
      if (Input.IsOrdinal and (Input.AsInt64 <> 0)) or (Input.IsOrdinal and (Input.AsExtended <> 0)) then
        Result := CurrToStrF(Input.AsExtended, ffCurrency, 2) + ' ' + Currency
      else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
        Result := CurrToStrF(Val, ffCurrency, 2) + ' ' + Currency
      else
        Result := Input.ToString;
    end);

  FFilters.Add('format_date',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      Result := FFilters['date'](Input, Args);
    end);

  FFilters.Add('format_datetime',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      FormatStr: String;
    begin
      if Length(Args) = 0 then
        FormatStr := 'yyyy-MM-dd HH:mm:ss'
      else
        FormatStr := Args[0];
      Result := FFilters['date'](Input, [FormatStr]);
    end);

  FFilters.Add('format_number',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
    begin
      Decimals := 2;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 2);
      if Input.IsOrdinal then
        Val := Input.AsInt64
      else if Input.IsType<Real> then
        Val := Input.AsExtended
      else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
        // Val already set
      else
        Exit(Input.ToString);
      Result := FormatFloat('0.' + StringOfChar('0', Decimals), Val);
    end);

  FFilters.Add('format_time',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      Result := FFilters['date'](Input, ['hh:nn:ss']);
    end);

  FFilters.Add('html_to_markdown',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: html-to-markdown not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('inky_to_html',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: inky-to-html not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('inline_css',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: inline CSS not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('join',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Delim: String;
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      I: Integer;
      Output: TStringBuilder;
    begin
      Delim := ',';
      if Length(Args) > 0 then
        Delim := Args[0];

      Output := TStringBuilder.Create;
      try
        if Input.IsArray then
        begin
          Arr := Input.AsType<TArray<TValue>>;
          for I := 0 to High(Arr) do
          begin
            if I > 0 then
              Output.Append(Delim);
            Output.Append(Arr[I].ToString);
          end;
        end
        else if Input.IsObject and (Input.AsObject is TJSONArray) then
        begin
          JSONArray := TJSONArray(Input.AsObject);
          for I := 0 to JSONArray.Count - 1 do
          begin
            if I > 0 then
              Output.Append(Delim);
            Output.Append(JSONArray.Items[I].ToString);
          end;
        end
        else if Input.Kind in [tkString, tkUString] then
        begin
          var Items := Input.AsString.Split([',']);
          Result := String.Join(Delim, Items);
          Exit;
        end
        else
          Output.Append(Input.ToString);
        Result := Output.ToString;
      finally
        Output.Free;
      end;
    end);

  FFilters.Add('json_encode',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      JsonValue: TJSONValue;
    begin
      if Input.IsObject and (Input.AsObject is TJSONValue) then
        Result := TJSONValue(Input.AsObject).ToString
      else if Input.Kind in [tkString, tkUString] then
      begin
        JsonValue := TJSONObject.ParseJSONValue(Input.AsString);
        try
          if Assigned(JsonValue) then
            Result := JsonValue.ToString
          else
            Result := JsonEncodeString(Input.AsString);
        finally
          JsonValue.Free;
        end;
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('keys',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Dict: TDictionary<String, TValue>;
      JSONArray: TJSONArray;
      I: Integer;
      Output: TStringBuilder;
    begin
      Output := TStringBuilder.Create;
      try
        Output.Append('[');
        if Input.IsObject and (Input.AsObject is TDictionary<String, TValue>) then
        begin
          Dict := TDictionary<String, TValue>(Input.AsObject);
          var Keys := Dict.Keys.ToArray;
          for I := 0 to High(Keys) do
          begin
            if I > 0 then
              Output.Append(',');
            Output.Append('"' + Keys[I] + '"');
          end;
        end
        else if Input.IsObject and (Input.AsObject is TJSONObject) then
        begin
          var Obj := TJSONObject(Input.AsObject);
          for I := 0 to Obj.Count - 1 do
          begin
            if I > 0 then
              Output.Append(',');
            Output.Append('"' + Obj.Pairs[I].JsonString.Value + '"');
          end;
        end;
        Output.Append(']');
        Result := Output.ToString;
      finally
        Output.Free;
      end;
    end);

  FFilters.Add('language_name',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: language name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('last',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if (Input.Kind in [tkString, tkUString]) and (Input.AsString <> '') then
        Result := Input.AsString[Length(Input.AsString)]
      else if Input.IsArray and (Input.GetArrayLength > 0) then
        Result := Input.AsType<TArray<TValue>>[High(Input.AsType<TArray<TValue>>)].ToString
      else if Input.IsObject and (Input.AsObject is TJSONArray) and (TJSONArray(Input.AsObject).Count > 0) then
        Result := TJSONArray(Input.AsObject).Items[TJSONArray(Input.AsObject).Count - 1].ToString
      else
        Result := '';
    end);

  FFilters.Add('length',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.IsArray then
        Result := IntToStr(Input.GetArrayLength)
      else if Input.IsObject and (Input.AsObject is TDictionary<String, TValue>) then
        Result := IntToStr(TDictionary<String, TValue>(Input.AsObject).Count)
      else if Input.IsObject and (Input.AsObject is TJSONArray) then
        Result := IntToStr(TJSONArray(Input.AsObject).Count)
      else if Input.IsObject and (Input.AsObject is TJSONObject) then
        Result := IntToStr(TJSONObject(Input.AsObject).Count)
      else if Input.Kind in [tkString, tkUString] then
        Result := IntToStr(Length(Input.AsString))
      else
        Result := '0';
    end);

  FFilters.Add('locale_name',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: locale name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('lower',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := LowerCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('map',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: map not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('markdown_to_html',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: markdown-to-html not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('merge',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Dict: TDictionary<String, TValue>;
      JSONValue: TJSONValue;
      I: Integer;
      Output: TStringBuilder;
    begin
      Output := TStringBuilder.Create;
      try
        Output.Append('{');
        if Input.IsObject and (Input.AsObject is TDictionary<String, TValue>) then
        begin
          Dict := TDictionary<String, TValue>(Input.AsObject);
          for I := 0 to High(Args) do
          begin
            JSONValue := TJSONObject.ParseJSONValue(Args[I]);
            try
              if JSONValue is TJSONObject then
              begin
                for var Pair in TJSONObject(JSONValue) do
                begin
                  if Dict.ContainsKey(Pair.JsonString.Value) then
                    Dict[Pair.JsonString.Value] := TValue.From<String>(Pair.JsonValue.ToString)
                  else
                    Dict.Add(Pair.JsonString.Value, TValue.From<String>(Pair.JsonValue.ToString));
                end;
              end;
            finally
              JSONValue.Free;
            end;
          end;
          var Keys := Dict.Keys.ToArray;
          for I := 0 to High(Keys) do
          begin
            if I > 0 then
              Output.Append(',');
            Output.Append('"' + Keys[I] + '":' + Dict[Keys[I]].ToString);
          end;
        end;
        Output.Append('}');
        Result := Output.ToString;
      finally
        Output.Free;
      end;
    end);

  FFilters.Add('nl2br',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, sLineBreak, '<br>', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('number_format',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
    begin
      Decimals := 2;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 2);
      if Input.IsOrdinal then
        Val := Input.AsInt64
      else if Input.isType<Real> then
        Val := Input.AsExtended
      else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
        // Val already set
      else
        Exit(Input.ToString);
      Result := FormatFloat('0.' + StringOfChar('0', Decimals), Val);
    end);

  FFilters.Add('plural',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: pluralization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('raw',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      Result := Input.ToString; // No escaping
    end);

  FFilters.Add('reduce',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: reduce not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('replace',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Length(Args) < 2 then
        Result := Input.ToString
      else if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, Args[0], Args[1], [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('reverse',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      I: Integer;
    begin
      if Input.Kind in [tkString, tkUString] then
      begin
        Result := '';
        for I := Length(Input.AsString) downto 1 do
          Result := Result + Input.AsString[I];
      end
      else if Input.IsArray then
      begin
        var Arr := Input.AsType<TArray<TValue>>;
        Result := '[';
        for I := High(Arr) downto 0 do
        begin
          if I < High(Arr) then
            Result := Result + ',';
          Result := Result + Arr[I].ToString;
        end;
        Result := Result + ']';
      end
      else if Input.IsObject and (Input.AsObject is TJSONArray) then
      begin
        var JSONArray := TJSONArray(Input.AsObject);
        Result := '[';
        for I := JSONArray.Count - 1 downto 0 do
        begin
          if I < JSONArray.Count - 1 then
            Result := Result + ',';
          Result := Result + JSONArray.Items[I].ToString;
        end;
        Result := Result + ']';
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('round',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Val: Double;
      Decimals: Integer;
      FormatStr: String;
    begin
      Decimals := 0;
      if Length(Args) > 0 then
        Decimals := StrToIntDef(Args[0], 0);
      if Input.IsOrdinal then
        Val := Input.AsInt64
      else if Input.IsType<Real> then
        Val := Input.AsExtended
      else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
        // Val already set
      else
        Exit(Input.ToString);
      FormatStr := '0.' + StringOfChar('0', Decimals);
      Result := FormatFloat(FormatStr, RoundTo(Val, -Decimals));
    end);

  FFilters.Add('shuffle',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: shuffle not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('singular',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: singularization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('slice',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      StartIdx, Count, LenInput: Integer;
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      I: Integer;
      Output: TStringBuilder;
    begin
      StartIdx := 0;
      Count := MaxInt;

      if Input.Kind in [tkString, tkUString] then
      begin
        LenInput := Length(Input.AsString);
        if Length(Args) > 0 then
          StartIdx := StrToIntDef(Args[0], 0);
        if Length(Args) > 1 then
          Count := StrToIntDef(Args[1], LenInput);
        if StartIdx < 0 then
          StartIdx := LenInput + StartIdx;
        if StartIdx < 1 then
          StartIdx := 1;
        Result := Copy(Input.AsString, StartIdx, Count);
      end
      else if Input.IsArray then
      begin
        Arr := Input.AsType<TArray<TValue>>;
        LenInput := Length(Arr);
        if Length(Args) > 0 then
          StartIdx := StrToIntDef(Args[0], 0);
        if Length(Args) > 1 then
          Count := StrToIntDef(Args[1], LenInput);
        if StartIdx < 0 then
          StartIdx := LenInput + StartIdx;
        if StartIdx < 0 then
          StartIdx := 0;
        Output := TStringBuilder.Create;
        try
          Output.Append('[');
          for I := StartIdx to Min(StartIdx + Count - 1, LenInput - 1) do
          begin
            if I > StartIdx then
              Output.Append(',');
            Output.Append(Arr[I].ToString);
          end;
          Output.Append(']');
          Result := Output.ToString;
        finally
          Output.Free;
        end;
      end
      else if Input.IsObject and (Input.AsObject is TJSONArray) then
      begin
        JSONArray := TJSONArray(Input.AsObject);
        LenInput := JSONArray.Count;
        if Length(Args) > 0 then
          StartIdx := StrToIntDef(Args[0], 0);
        if Length(Args) > 1 then
          Count := StrToIntDef(Args[1], LenInput);
        if StartIdx < 0 then
          StartIdx := LenInput + StartIdx;
        if StartIdx < 0 then
          StartIdx := 0;
        Output := TStringBuilder.Create;
        try
          Output.Append('[');
          for I := StartIdx to Min(StartIdx + Count - 1, LenInput - 1) do
          begin
            if I > StartIdx then
              Output.Append(',');
            Output.Append(JSONArray.Items[I].ToString);
          end;
          Output.Append(']');
          Result := Output.ToString;
        finally
          Output.Free;
        end;
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('slug',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      I: Integer;
      S: String;
    begin
      if Input.Kind in [tkString, tkUString] then
      begin
        S := LowerCase(Input.AsString);
        for I := Length(S) downto 1 do
          if not (S[I] in ['a'..'z', '0'..'9']) then
            Delete(S, I, 1);
        Result := S;
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('sort',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: sorting not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('spaceless',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, ' ', '', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('split',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Delim: String;
      Parts: TArray<String>;
      I: Integer;
      ResultList: TStringList;
    begin
      if Input.Kind in [tkString, tkUString] then
      begin
        if Length(Args) > 0 then
          Delim := Args[0]
        else
          Delim := ',';
        Parts := Input.AsString.Split([Delim]);
        ResultList := TStringList.Create;
        try
          for I := 0 to High(Parts) do
            ResultList.Add(Parts[I]);
          Result := ResultList.Text;
        finally
          ResultList.Free;
        end;
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('striptags',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      Regex: TRegEx;
    begin
      if Input.Kind in [tkString, tkUString] then
      begin
        Regex := TRegEx.Create('<.*?>', [roIgnoreCase]);
        Result := Regex.Replace(Input.AsString, '');
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('timezone_name',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Stub: timezone name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('title',
    function(const Input: TValue; const Args: TArray<String>): String
    var
      I: Integer;
      Words: TArray<String>;
    begin
      if Input.Kind in [tkString, tkUString] then
      begin
        Words := Input.AsString.Split([' ']);
        for I := 0 to High(Words) do
          if Words[I].Length > 0 then
            Words[I] := UpperCase(Words[I][1]) + LowerCase(Copy(Words[I], 2, MaxInt));
        Result := String.Join(' ', Words);
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('trim',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := Trim(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('u',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      // Twig u filter is Unicode string conversion
      Result := Input.ToString;
    end);

  FFilters.Add('upper',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := UpperCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('url_encode',
    function(const Input: TValue; const Args: TArray<String>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := TNetEncoding.URL.Encode(Input.AsString)
      else
        Result := Input.ToString;
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
