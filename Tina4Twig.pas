unit Tina4Twig;

interface



uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math, Variants, System.TypInfo, System.DateUtils;

type
  TStringDict = TDictionary<String, TValue>;
  TFilterFunc = reference to function(const Input: TValue; const Args: TArray<String>;const Context: TDictionary<String, TValue>): TValue;
  TFunctionFunc = reference to function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String;
  TMacroFunc = reference to function(const MacroName: String; const Args: TArray<String>; const MacroContext: TDictionary<String, TValue>): String;

  /// <summary>
  /// Twig-compatible template engine. Supports {{ variable }}, {% if %}, {% for %},
  /// {% include %}, {% extends %}, {% block %}, {% macro %}, filters (|upper, |lower,
  /// |length, |default, etc.), and functions (range(), dump(), etc.).
  /// </summary>
  TTina4Twig = class(TObject)
  private
    FDebug: Boolean;
    FContext: TDictionary<String, TValue>;
    FFilters: TDictionary<String, TFilterFunc>;
    FFunctions: TDictionary<String, TFunctionFunc>;
    FMacros: TDictionary<String, TMacroFunc>;
    FMacroParams: TDictionary<String, TArray<String>>;
    FMacroDefaults: TDictionary<String, TDictionary<String, String>>;
    FMacroBodies: TDictionary<String, String>;
    FTemplatePath: String;
    FDateFormat: String;
    FDaysFormat: String;
    function LoadTemplate(const TemplateName: String): String;
    procedure SetDateFormat(FormatDate: String; FormatDays: String);
    function IsStrictNumeric(const Value: TValue): Boolean;
    function GetAsExtendedLenient(const Value: TValue): Extended;
    function CompareValues(const Left, Right: TValue; const Op: String): Boolean;
    function EvaluateIncludes(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
    function EvaluateMacroBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
    function RemoveComments(const Template: String): String;
    function ParseVariableDict(const DictStr: String; OuterContext: TDictionary<String,TValue>): TDictionary<String,TValue>;
    procedure ProcessTemplate(const Template: String; var LocalContext: TDictionary<String, TValue>; var Result: String);
    function RenderInternal(const TemplateOrContent: String; var Context: TStringDict): String;
    function ResolveVariablePath(const VariablePath: string; Context: TDictionary<String, TValue>): TValue;
    function Contains(const Left, Right: TValue): Boolean;
    function ValuesAreEqual(const A, B: TValue): Boolean;
    function ToBool(const Value: TValue): Boolean;
    function GetExpressionValue(const Expr: String; Context: TDictionary<String, TValue>): TValue;
    function EvaluateExpression(const Expr: String; Context: TDictionary<String, TValue>): TValue;
    function InfixToRPN(const Tokens: TArray<String>): TArray<String>;
    function EvaluateRPN(const RPN: TArray<String>; const Context: TDictionary<String, TValue>): TValue;
    function Tokenize(const Expr: String): TArray<String>;
    function ConvertJSONToTValue(const JSON: TJSONValue): TValue;
    procedure DumpValue(const Value: TValue; List: TStringList; const Indent: String);
    procedure RegisterDefaultFilters;
    procedure RegisterDefaultFunctions;
  public
    /// <summary>
    /// Creates a new Twig engine instance.
    /// </summary>
    /// <param name="TemplatePath">Base directory for {% include %} and {% extends %} file resolution. Empty string disables file loading.</param>
    constructor Create(const TemplatePath: String = '');
    /// <summary>Frees the engine and all internal dictionaries.</summary>
    destructor Destroy; override;
    /// <summary>
    /// Renders a Twig template string or file. If TemplatePath is set and the
    /// value matches a filename, loads from disk; otherwise treats as inline content.
    /// </summary>
    /// <param name="TemplateOrContent">A template filename or inline Twig template string.</param>
    /// <param name="Variables">Optional additional variables merged into the rendering context.</param>
    /// <returns>The rendered HTML/text output.</returns>
    function Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;
    /// <summary>
    /// Sets a variable in the rendering context. Available as {{ AName }} in templates.
    /// </summary>
    /// <param name="AName">Variable name.</param>
    /// <param name="AValue">Variable value (supports string, integer, boolean, arrays, etc.).</param>
    procedure SetVariable(AName: String; AValue: TValue);
    /// <summary>Returns the current value of a context variable, or TValue.Empty if not found.</summary>
    /// <param name="AName">Variable name to look up.</param>
    function GetVariable(AName: String): TValue;
    /// <summary>Enables or disables debug output during template rendering.</summary>
    /// <param name="Value">True to enable debug output, False to disable.</param>
    procedure SetDebug(Value: Boolean=True);
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
/// Splits a string on top-level pipe symbols, respecting parentheses and quotes.
/// Stops splitting when encountering operators like ~ that indicate the end of a filter chain.
/// </summary>
/// <param name="S">The input string to split.</param>
/// <returns>An array of strings split on top-level pipes.</returns>
function SplitOnTopLevel(const S: String; Delim: Char): TArray<String>;
var
  Parts: TList<String>;
  Current: String;
  Depth: Integer;
  QuoteChar: Char;
  InQuote: Boolean;
  I: Integer;
begin
  Parts := TList<String>.Create;
  try
    Current := '';
    Depth := 0;
    InQuote := False;
    QuoteChar := #0;
    for I := 1 to Length(S) do
    begin
      if InQuote then
      begin
        Current := Current + S[I];
        if S[I] = QuoteChar then
          InQuote := False;
      end
      else if S[I] in ['''', '"'] then
      begin
        InQuote := True;
        QuoteChar := S[I];
        Current := Current + S[I];
      end
      else if S[I] in ['(', '[', '{'] then
      begin
        Inc(Depth);
        Current := Current + S[I];
      end
      else if S[I] in [')', ']', '}'] then
      begin
        Dec(Depth);
        Current := Current + S[I];
      end
      else if (S[I] = Delim) and (Depth = 0) then
      begin
        Parts.Add(Trim(Current));
        Current := '';
      end
      else
        Current := Current + S[I];
    end;
    if Current <> '' then
      Parts.Add(Trim(Current));
    Result := Parts.ToArray;
  finally
    Parts.Free;
  end;
end;


function NormalizeExpression(const Expr: String): String;
var
  SB: TStringBuilder;
  I: Integer;
  InQuote: Boolean;
  QuoteChar: Char;
  Depth: Integer;
  IsWhitespace: Boolean;
begin
  SB := TStringBuilder.Create;
  try
    InQuote := False;
    QuoteChar := #0;
    Depth := 0;
    for I := 1 to Length(Expr) do
    begin
      IsWhitespace := CharInSet(Expr[I], [#9, #10, #13, ' ']);
      if InQuote then
      begin
        SB.Append(Expr[I]);
        if Expr[I] = QuoteChar then
          InQuote := False;
      end
      else if Expr[I] in ['''', '"'] then
      begin
        InQuote := True;
        QuoteChar := Expr[I];
        SB.Append(Expr[I]);
      end
      else if Expr[I] in ['(', '[', '{'] then
      begin
        Inc(Depth);
        SB.Append(Expr[I]);
      end
      else if Expr[I] in [')', ']', '}'] then
      begin
        Dec(Depth);
        SB.Append(Expr[I]);
      end
      else if IsWhitespace then
      begin
        // Collapse multiple whitespace to single space, but only outside structures
        if (SB.Length > 0) and not CharInSet(SB.Chars[SB.Length - 1], [#9, #10, #13, ' ']) then
          SB.Append(' ');
      end
      else
        SB.Append(Expr[I]);
    end;
    Result := SB.ToString.Trim;
  finally
    SB.Free;
  end;
end;


/// <summary>
/// Tokenizes an expression into an array of tokens.
/// </summary>
/// <param name="Expr">The expression to tokenize.</param>
/// <returns>An array of tokens representing the expression.</returns>
/// <remarks>
/// Handles numbers, quoted strings, identifiers with dotted paths and subscripts, operators, and array/dictionary literals.
/// Updated to robustly recognize 'in', 'starts with', 'matches', 'ends with', 'and', 'or', 'not', 'not in', and '..' operators with flexible spacing and case.
/// </remarks>
function TTina4Twig.Tokenize(const Expr: String): TArray<String>;
var
  Tokens: TList<String>;
  I: Integer;
  Token: String;
  Quote: Char;
  HasDot: Boolean;
  Depth: Integer;
  InQuote: Boolean;
  QuoteChar: Char;
  LowerExpr: String;
begin
  Tokens := TList<String>.Create;
  try
    LowerExpr := LowerCase(Expr); // Precompute lowercase for case-insensitive checks
    I := 1;
    while I <= Length(Expr) do
    begin
      // Skip whitespace
      if CharInSet(Expr[I], [' ', #9, #10, #13]) then
      begin
        Inc(I);
        Continue;
      end;

      // Handle '..' operator before numbers
      if (I < Length(Expr)) and (Expr[I] = '.') and (Expr[I + 1] = '.') then
      begin
        Tokens.Add('..');
        Inc(I, 2);
        Continue;
      end;

      // Handle 'in' operator
      if (I <= Length(Expr) - 1) and (LowerExpr[I] = 'i') and (LowerExpr[I + 1] = 'n') and
         ((I + 1 = Length(Expr)) or CharInSet(Expr[I + 2], [' ', #9, #10, #13, ')', '}', ']', '''', '"'])) then
      begin
        Tokens.Add('in');
        Inc(I, 2);
        Continue;
      end;

      // Handle 'starts with' operator
      if (I <= Length(Expr) - 10) and (Copy(LowerExpr, I, 11) = 'starts with') and
         ((I + 10 = Length(Expr)) or CharInSet(Expr[I + 11], [' ', #9, #10, #13, '''', '"', ')', '}', ']'])) then
      begin
        Tokens.Add('starts with');
        Inc(I, 11);
        Continue;
      end;

      // Handle 'ends with' operator
      if (I <= Length(Expr) - 8) and (Copy(LowerExpr, I, 9) = 'ends with') and
         ((I + 8 = Length(Expr)) or CharInSet(Expr[I + 9], [' ', #9, #10, #13, '''', '"', ')', '}', ']'])) then
      begin
        Tokens.Add('ends with');
        Inc(I, 9);
        Continue;
      end;

      // Handle 'matches' operator
      if (I <= Length(Expr) - 6) and (Copy(LowerExpr, I, 7) = 'matches') and
         ((I + 6 = Length(Expr)) or CharInSet(Expr[I + 7], [' ', #9, #10, #13, '''', '"', ')', '}', ']'])) then
      begin
        Tokens.Add('matches');
        Inc(I, 7);
        Continue;
      end;

      // Handle 'and' operator
      if (I <= Length(Expr) - 2) and (Copy(LowerExpr, I, 3) = 'and') and
         ((I + 2 = Length(Expr)) or CharInSet(Expr[I + 3], [' ', #9, #10, #13, ')', '}', ']', '''', '"'])) then
      begin
        Tokens.Add('and');
        Inc(I, 3);
        Continue;
      end;

      // Handle 'or' operator
      if (I <= Length(Expr) - 1) and (Copy(LowerExpr, I, 2) = 'or') and
         ((I + 1 = Length(Expr)) or CharInSet(Expr[I + 2], [' ', #9, #10, #13, ')', '}', ']', '''', '"'])) then
      begin
        Tokens.Add('or');
        Inc(I, 2);
        Continue;
      end;

      // Handle 'not in' operator before 'not'
      if (I <= Length(Expr) - 5) and (Copy(LowerExpr, I, 6) = 'not in') and
         ((I + 5 = Length(Expr)) or CharInSet(Expr[I + 6], [' ', #9, #10, #13, ')', '}', ']', '''', '"'])) then
      begin
        Tokens.Add('not in');
        Inc(I, 6);
        Continue;
      end;

      // Handle 'not' operator
      if (I <= Length(Expr) - 2) and (Copy(LowerExpr, I, 3) = 'not') and
         ((I + 2 = Length(Expr)) or CharInSet(Expr[I + 3], [' ', #9, #10, #13, ')', '}', ']', '''', '"'])) then
      begin
        Tokens.Add('not');
        Inc(I, 3);
        Continue;
      end;

      // Handle multi-character operators (<=, >=, ==, !=, =>)
      if (I < Length(Expr)) then
      begin
        if (Expr[I] = '<') and (Expr[I + 1] = '=') then
        begin
          Tokens.Add('<=');
          Inc(I, 2);
          Continue;
        end;
        if (Expr[I] = '>') and (Expr[I + 1] = '=') then
        begin
          Tokens.Add('>=');
          Inc(I, 2);
          Continue;
        end;
        if (Expr[I] = '=') and (Expr[I + 1] = '=') then
        begin
          Tokens.Add('==');
          Inc(I, 2);
          Continue;
        end;
        if (Expr[I] = '!') and (Expr[I + 1] = '=') then
        begin
          Tokens.Add('!=');
          Inc(I, 2);
          Continue;
        end;
        if (Expr[I] = '=') and (Expr[I + 1] = '>') then
        begin
          Tokens.Add('=>');
          Inc(I, 2);
          Continue;
        end;
      end;

      // Handle single-character operators
      if CharInSet(Expr[I], ['+', '-', '*', '/', '%', '(', ')', '|', ',', '~', '<', '>']) then
      begin
        Tokens.Add(Expr[I]);
        Inc(I);
        Continue;
      end;

      // Handle quoted strings
      if Expr[I] in ['''', '"'] then
      begin
        Quote := Expr[I];
        Token := Quote;
        Inc(I);
        while (I <= Length(Expr)) and (Expr[I] <> Quote) do
        begin
          if (Expr[I] = '\') and (I < Length(Expr)) then
          begin
            Inc(I); // Skip escape character
            if I <= Length(Expr) then
              Token := Token + Expr[I];
          end
          else
            Token := Token + Expr[I];
          Inc(I);
        end;
        if I <= Length(Expr) then
        begin
          Token := Token + Quote;
          Inc(I);
        end;
        Tokens.Add(Token);
        Continue;
      end;

      // Handle numbers (integers and decimals)
      if CharInSet(Expr[I], ['0'..'9', '-']) then
      begin
        Token := Expr[I];
        Inc(I);
        HasDot := False;
        while I <= Length(Expr) do
        begin
          if Expr[I] = '.' then
          begin
            if HasDot then Break; // Only one decimal point allowed
            HasDot := True;
            // Ensure not followed by another dot (to avoid '..')
            if (I < Length(Expr)) and (Expr[I + 1] = '.') then
              Break;
            Token := Token + '.';
            Inc(I);
            Continue;
          end;
          if not CharInSet(Expr[I], ['0'..'9']) then Break;
          Token := Token + Expr[I];
          Inc(I);
        end;
        Tokens.Add(Token);
        Continue;
      end;

      // Handle identifiers (including dotted paths and subscripts)
      if CharInSet(Expr[I], ['a'..'z', 'A'..'Z', '_']) then
      begin
        Token := Expr[I];
        Inc(I);
        while (I <= Length(Expr)) and CharInSet(Expr[I], ['a'..'z', 'A'..'Z', '0'..'9', '_', '.', '[']) do
        begin
          if Expr[I] = '.' then
          begin
            // Ensure not followed by another dot (to avoid '..')
            if (I < Length(Expr)) and (Expr[I + 1] = '.') then
              Break;
            Token := Token + '.';
            Inc(I);
            if (I > Length(Expr)) or not CharInSet(Expr[I], ['a'..'z', 'A'..'Z', '_']) then
              raise Exception.Create('Expected identifier after .');
            Token := Token + Expr[I];
            Inc(I);
            while (I <= Length(Expr)) and CharInSet(Expr[I], ['a'..'z', 'A'..'Z', '0'..'9', '_']) do
            begin
              Token := Token + Expr[I];
              Inc(I);
            end;
          end
          else if Expr[I] = '[' then
          begin
            Token := Token + '[';
            Inc(I);
            Depth := 1;
            InQuote := False;
            QuoteChar := #0;
            while (I <= Length(Expr)) and (Depth > 0) do
            begin
              if InQuote then
              begin
                if Expr[I] = QuoteChar then
                  InQuote := False;
                Token := Token + Expr[I];
                Inc(I);
                Continue;
              end;
              if Expr[I] in ['''', '"'] then
              begin
                QuoteChar := Expr[I];
                InQuote := True;
                Token := Token + Expr[I];
                Inc(I);
                Continue;
              end;
              if Expr[I] = '[' then
                Inc(Depth)
              else if Expr[I] = ']' then
                Dec(Depth);
              Token := Token + Expr[I];
              Inc(I);
            end;
            if Depth > 0 then
              raise Exception.Create('Unmatched [ in expression');
          end
          else
          begin
            Token := Token + Expr[I];
            Inc(I);
          end;
        end;
        // Avoid adding partial operator tokens
        if (Token = 'matches') or (Token = 'starts') or (Token = 'ends') or (Token = 'with') or (Token = 'and') or (Token = 'or') or (Token = 'not') or (Token = 'in') then
          raise Exception.Create('Invalid partial operator: ' + Token);
        Tokens.Add(Token);
        Continue;
      end;

      // Handle array literals
      if Expr[I] = '[' then
      begin
        Token := '[';
        Inc(I);
        Depth := 1;
        while (I <= Length(Expr)) and (Depth > 0) do
        begin
          if Expr[I] in ['''', '"'] then
          begin
            Quote := Expr[I];
            Token := Token + Quote;
            Inc(I);
            while (I <= Length(Expr)) and (Expr[I] <> Quote) do
            begin
              if (Expr[I] = '\') and (I < Length(Expr)) then
              begin
                Inc(I);
                if I <= Length(Expr) then
                  Token := Token + Expr[I];
              end
              else
                Token := Token + Expr[I];
              Inc(I);
            end;
            if I <= Length(Expr) then
            begin
              Token := Token + Quote;
              Inc(I);
            end;
          end
          else
          begin
            if Expr[I] = '[' then
              Inc(Depth)
            else if Expr[I] = ']' then
              Dec(Depth);
            Token := Token + Expr[I];
            Inc(I);
          end;
        end;
        Tokens.Add(Token);
        Continue;
      end;

      // Handle dictionary literals
      if Expr[I] = '{' then
      begin
        Token := '{';
        Inc(I);
        Depth := 1;
        while (I <= Length(Expr)) and (Depth > 0) do
        begin
          if Expr[I] in ['''', '"'] then
          begin
            Quote := Expr[I];
            Token := Token + Quote;
            Inc(I);
            while (I <= Length(Expr)) and (Expr[I] <> Quote) do
            begin
              if (Expr[I] = '\') and (I < Length(Expr)) then
              begin
                Inc(I);
                if I <= Length(Expr) then
                  Token := Token + Expr[I];
              end
              else
                Token := Token + Expr[I];
              Inc(I);
            end;
            if I <= Length(Expr) then
            begin
              Token := Token + Quote;
              Inc(I);
            end;
          end
          else
          begin
            if Expr[I] = '{' then
              Inc(Depth)
            else if Expr[I] = '}' then
              Dec(Depth);
            Token := Token + Expr[I];
            Inc(I);
          end;
        end;
        Tokens.Add(Token);
        Continue;
      end;

      Inc(I);
    end;
    // Debug: Log tokenized output
    //WriteLn('Debug: Tokenize Input=', Expr, ' Output=', String.Join(' ', Tokens.ToArray));
    Result := Tokens.ToArray;
  finally
    Tokens.Free;
  end;
end;

/// <summary>
/// Converts an infix expression to Reverse Polish Notation (RPN).
/// </summary>
/// <param name="Tokens">Array of tokens in infix notation.</param>
/// <returns>Array of tokens in RPN.</returns>
/// <remarks>
/// Uses the Shunting Yard algorithm to handle operator precedence and parentheses.
/// Correctly orders operands for 'in', 'starts with', 'matches', and '..' operators.
/// </remarks>
function TTina4Twig.InfixToRPN(const Tokens: TArray<String>): TArray<String>;
var
  Output: TList<String>;
  OpStack: TStack<String>;
  Token, Top: String;
  Precedence: TDictionary<String, Integer>;
  TopPrec: Integer;
  FilterChain: String;
  I: Integer;
  InFilter: Boolean;
  ParenDepth: Integer;
  LastAppended: String;
  Dummy: Double;
begin
  Precedence := TDictionary<String, Integer>.Create;
  try
    Precedence.Add('+', 6);
    Precedence.Add('-', 6);
    Precedence.Add('*', 7);
    Precedence.Add('/', 7);
    Precedence.Add('%', 7);
    Precedence.Add('~', 8);
    Precedence.Add('|', 2);
    Precedence.Add('==', 0);
    Precedence.Add('!=', 0);
    Precedence.Add('<', 0);
    Precedence.Add('>', 0);
    Precedence.Add('<=', 0);
    Precedence.Add('>=', 0);
    Precedence.Add('in', 0);
    Precedence.Add('not in', 0);
    Precedence.Add('starts with', 0);
    Precedence.Add('ends with', 0);
    Precedence.Add('matches', 0);
    Precedence.Add('..', 0);
    Precedence.Add('and', 1);
    Precedence.Add('or', 0);
    Precedence.Add('not', 4);

    Output := TList<String>.Create;
    OpStack := TStack<String>.Create;
    try
      I := 0;
      InFilter := False;
      ParenDepth := 0;
      FilterChain := '';
      LastAppended := '';
      // Debug: Log input tokens
      //if FDebug then WriteLn('Debug: InfixToRPN Input=', String.Join(' ', Tokens));
      while I <= High(Tokens) do
      begin
        Token := Tokens[I];
        if Token.IsEmpty then
        begin
          Inc(I);
          Continue;
        end;
        // Handle filter chains (e.g., tasks[0].start_date | date('U'))
        if (Token = '|') or InFilter then
        begin
          if not InFilter then
          begin
            if Output.Count = 0 then
              raise Exception.Create('Invalid filter chain: no preceding value');
            FilterChain := '';
            if Output.Count > 0 then
            begin
              Top := Output[Output.Count - 1];
              if not Precedence.ContainsKey(Top) and (Top <> '(') and (Top <> ')') and (Top <> ',') then
              begin
                FilterChain := Top;
                Output.Delete(Output.Count - 1);
              end;
            end;
            InFilter := True;
            ParenDepth := 0;
            FilterChain := FilterChain + Token;
            LastAppended := Token;
          end
          else
          begin
            FilterChain := FilterChain + Token;
            LastAppended := Token;
            if Token = '(' then
              Inc(ParenDepth);
            if Token = ')' then
              Dec(ParenDepth);
          end;
          Inc(I);
          if (ParenDepth = 0) and (I <= High(Tokens)) and (Tokens[I] = '(') then
            Continue;
          if (ParenDepth = 0) and (LastAppended <> '|') and
             ((I > High(Tokens)) or (Tokens[I] <> '|')) then
          begin
            Output.Add(FilterChain);
            InFilter := False;
            // Debug: Log filter chain
            //if FDebug then WriteLn('Debug: Added FilterChain=', FilterChain, ' Output=', String.Join(' ', Output.ToArray));
            Continue;
          end;
          Continue;
        end;
        // Check if token is a number, quoted string, identifier, or array/dictionary literal
        if (TryStrToFloat(Token, Dummy) or
            (Token.StartsWith('''') and Token.EndsWith('''')) or
            (Token.StartsWith('"') and Token.EndsWith('"')) or
            (Token.StartsWith('[') and Token.EndsWith(']')) or
            (Token.StartsWith('{') and Token.EndsWith('}')) or
            ((Length(Token) > 0) and not Precedence.ContainsKey(Token) and
             (Token <> '(') and (Token <> ')') and (Token <> ','))) then
        begin
          Output.Add(Token);
          Inc(I);
          // Debug: Log operand
          //if FDebug then WriteLn('Debug: Added Operand=', Token, ' Output=', String.Join(' ', Output.ToArray));
          Continue;
        end;
        // Handle parentheses
        if Token = '(' then
        begin
          OpStack.Push(Token);
          Inc(I);
          // Debug: Log push to stack
          //if FDebug then WriteLn('Debug: Pushed to OpStack=', Token, ' OpStack=', String.Join(' ', OpStack.ToArray));
          Continue;
        end;
        if Token = ')' then
        begin
          while (OpStack.Count > 0) and (OpStack.Peek <> '(') do
            Output.Add(OpStack.Pop);
          if OpStack.Count = 0 then
            raise Exception.Create('Mismatched parentheses');
          OpStack.Pop; // Remove '('
          Inc(I);
          // Debug: Log after parentheses
          //if FDebug then WriteLn('Debug: Processed ) Output=', String.Join(' ', Output.ToArray), ' OpStack=', String.Join(' ', OpStack.ToArray));
          Continue;
        end;
        // Handle comma (used in filter arguments, e.g., date('U'))
        if Token = ',' then
        begin
          while (OpStack.Count > 0) and (OpStack.Peek <> '(') do
            Output.Add(OpStack.Pop);
          Inc(I);
          // Debug: Log after comma
          //if FDebug then WriteLn('Debug: Processed , Output=', String.Join(' ', Output.ToArray), ' OpStack=', String.Join(' ', OpStack.ToArray));
          Continue;
        end;
        // Handle operators
        if not Precedence.ContainsKey(Token) then
          raise Exception.Create('Unknown operator: ' + Token);
        while (OpStack.Count > 0) and (OpStack.Peek <> '(') do
        begin
          Top := OpStack.Peek;
          if not Precedence.TryGetValue(Top, TopPrec) then
            Break;
          if Precedence[Token] > TopPrec then
            Break;
          Output.Add(OpStack.Pop);
          // Debug: Log operator pop
          //if FDebug then WriteLn('Debug: Popped Operator=', Top, ' Output=', String.Join(' ', Output.ToArray));
        end;
        OpStack.Push(Token);
        Inc(I);
        // Debug: Log operator push
        //if FDebug then WriteLn('Debug: Pushed Operator=', Token, ' OpStack=', String.Join(' ', OpStack.ToArray));
      end;
      // Pop remaining operators
      while OpStack.Count > 0 do
      begin
        Top := OpStack.Pop;
        if Top = '(' then
          raise Exception.Create('Mismatched parentheses');
        Output.Add(Top);
        // Debug: Log final operator pop
        //if FDebug then WriteLn('Debug: Final Pop Operator=', Top, ' Output=', String.Join(' ', Output.ToArray));
      end;
      Result := Output.ToArray;
      // Debug: Log final RPN output
      //if FDebug then WriteLn('Debug: InfixToRPN Final Output=', String.Join(' ', Result));
    finally
      Output.Free;
      OpStack.Free;
    end;
  finally
    Precedence.Free;
  end;
end;

/// <summary>
/// Evaluates a Reverse Polish Notation (RPN) expression.
/// </summary>
/// <param name="RPN">Array of tokens in RPN.</param>
/// <param name="Context">The context dictionary for variable resolution.</param>
/// <returns>The evaluated result as a TValue.</returns>
/// <remarks>
/// Processes arithmetic operations, filter chains, comparisons, 'in', 'starts with', 'matches', and range '..' operators.
/// Updated to safely handle regex evaluation for 'matches' operator and range operator for array creation.
/// Ensures integer operands for '..' by converting strings and floats to integers where possible.
/// </remarks>
function TTina4Twig.EvaluateRPN(const RPN: TArray<String>; const Context: TDictionary<String, TValue>): TValue;
var
  Stack: TStack<TValue>;
  Token: String;
  A, B: TValue;
  FA, FB: Double;
  IA, IB: Int64;
  Parts: TArray<String>;
  J, I: Integer;
  CurrentVal: TValue;
  FilterExpr, FuncName, ArgsStr: String;
  ArgTokens: TArray<String>;
  ArgList: TList<String>;
  ArgToken, AArgToken: String;
  Args: TArray<String>;
  Filter: TFilterFunc;
  Func: TFunctionFunc;
  Condition: Boolean;
  IsSimpleInteger: Boolean;
  Regex: TRegEx;
  Arr: TArray<TValue>;
begin
  Stack := TStack<TValue>.Create;
  try
    //if FDebug then WriteLn('Debug: EvaluateRPN Input=', String.Join(' ', RPN));
    I := 0;
    while I < Length(RPN) do
    begin
      Token := RPN[I];
      //if FDebug then WriteLn('Debug: Processing Token=', Token, ' StackCount=', Stack.Count);
      if Token.Contains('|') then
      begin
        Parts := SplitOnTopLevel(Token, '|');
        if Trim(Parts[0]) = '' then
          CurrentVal := Stack.Pop
        else
          CurrentVal := ResolveVariablePath(Parts[0], Context);
        for J := 1 to High(Parts) do
        begin
          FilterExpr := Trim(Parts[J]);
          if FilterExpr.Contains('(') and FilterExpr.EndsWith(')') then
          begin
            FuncName := Trim(Copy(FilterExpr, 1, Pos('(', FilterExpr) - 1));
            ArgsStr := Copy(FilterExpr, Pos('(', FilterExpr) + 1, Length(FilterExpr) - Pos('(', FilterExpr) - 1);
            ArgTokens := SplitOnTopLevel(ArgsStr, ',');
            ArgList := TList<String>.Create;
            try
              for AArgToken in ArgTokens do
              begin
                ArgToken := Trim(AArgToken);
                if ((ArgToken.StartsWith('"') and ArgToken.EndsWith('"')) or
                    (ArgToken.StartsWith('''') and ArgToken.EndsWith(''''))) and (Length(ArgToken) >= 2) then
                  ArgToken := Copy(ArgToken, 2, Length(ArgToken) - 2);
                ArgList.Add(ArgToken);
              end;
              Args := ArgList.ToArray;
            finally
              ArgList.Free;
            end;
          end
          else
          begin
            FuncName := Trim(FilterExpr);
            SetLength(Args, 0);
          end;
          if FFilters.TryGetValue(FuncName, Filter) then
          begin
            CurrentVal := Filter(CurrentVal, Args, Context);
          end
          else
            CurrentVal := TValue.From<String>('(filter ' + FuncName + ' not found)');
        end;
        Stack.Push(CurrentVal);
        //if FDebug then WriteLn('Debug: After Filter=', Token, ' StackCount=', Stack.Count);
        Inc(I);
        Continue;
      end;
      if FFunctions.ContainsKey(Token) then
      begin
        ArgList := TList<String>.Create;
        try
          Inc(I);
          if I >= Length(RPN) then
            raise Exception.Create('Invalid function call: no arguments for ' + Token);
          ArgList.Add(RPN[I]);
          Args := ArgList.ToArray;
          if FFunctions.TryGetValue(Token, Func) then
          begin
            CurrentVal := TValue.From<String>(Func(Args, Context));
            Stack.Push(CurrentVal);
            //if FDebug then WriteLn('Debug: After Function=', Token, ' Args=', String.Join(',', Args), ' Result=', CurrentVal.ToString, ' StackCount=', Stack.Count);
          end
          else
            raise Exception.Create('Function ' + Token + ' not found');
        finally
          ArgList.Free;
        end;
        Inc(I);
        Continue;
      end;
      if TryStrToInt64(Token, IA) then
      begin
        Stack.Push(TValue.From<Int64>(IA));
        //if FDebug then WriteLn('Debug: Pushed Int=', Token, ' StackCount=', Stack.Count);
      end
      else if TryStrToFloat(Token, FA) then
      begin
        Stack.Push(TValue.From<Double>(FA));
        //if FDebug then WriteLn('Debug: Pushed Float=', Token, ' StackCount=', Stack.Count);
      end
      else if (Token.StartsWith('''') or Token.StartsWith('"')) and (Token.EndsWith(Token[1])) then
      begin
        Stack.Push(TValue.From<String>(Copy(Token, 2, Length(Token) - 2)));
        //if FDebug then WriteLn('Debug: Pushed String=', Token, ' StackCount=', Stack.Count);
      end
      else if not CharInSet(Token[1], ['+', '-', '*', '/', '%', '~', '<', '>', '=', '!']) and
              (Token <> 'in') and (Token <> 'starts with') and (Token <> 'matches') and (Token <> '..') and
              (Token <> 'and') and (Token <> 'or') and (Token <> 'not') and (Token <> 'not in') then
      begin
        CurrentVal := ResolveVariablePath(Token, Context);
        if (CurrentVal.Kind in [tkString, tkUString]) and TryStrToInt64(CurrentVal.AsString, IA) then
          CurrentVal := TValue.From<Int64>(IA)
        else if CurrentVal.IsType<Double> and (Frac(CurrentVal.AsExtended) = 0) then
          CurrentVal := TValue.From<Int64>(Trunc(CurrentVal.AsExtended));
        Stack.Push(CurrentVal);
        //if FDebug then WriteLn('Debug: Pushed Variable=', Token, ' Value=', CurrentVal.ToString, ' StackCount=', Stack.Count);
      end
      else
      begin
        if (Token = '-') and (Stack.Count = 1) then
        begin
          A := Stack.Pop;
          FA := GetAsExtendedLenient(A);
          Stack.Push(TValue.From<Double>(-FA));
          //if FDebug then WriteLn('Debug: After Unary Minus=', Token, ' StackCount=', Stack.Count);
          Inc(I);
          Continue;
        end;
        if Stack.Count < 2 then
          raise Exception.Create('Invalid expression: insufficient operands for ' + Token + ', StackCount=' + IntToStr(Stack.Count));
        B := Stack.Pop;
        A := Stack.Pop;
        //if FDebug then WriteLn('Debug: Popped A=', A.ToString, ' B=', B.ToString, ' for Operator=', Token);
        if (A.Kind in [tkString, tkUString]) and TryStrToInt64(A.AsString, IA) then
          A := TValue.From<Int64>(IA)
        else if A.IsType<Double> and (Frac(A.AsExtended) = 0) then
          A := TValue.From<Int64>(Trunc(A.AsExtended));
        if (B.Kind in [tkString, tkUString]) and TryStrToInt64(B.AsString, IB) then
          B := TValue.From<Int64>(IB)
        else if B.IsType<Double> and (Frac(B.AsExtended) = 0) then
          B := TValue.From<Int64>(Trunc(B.AsExtended));
        FA := GetAsExtendedLenient(A);
        FB := GetAsExtendedLenient(B);
        if Token = '+' then
          Stack.Push(TValue.From<Double>(FA + FB))
        else if Token = '-' then
        begin
          if A.IsOrdinal and B.IsOrdinal then
            Stack.Push(TValue.From<Int64>(A.AsInt64 - B.AsInt64))
          else
            Stack.Push(TValue.From<Double>(FA - FB));
        end
        else if Token = '*' then
          Stack.Push(TValue.From<Double>(FA * FB))
        else if Token = '/' then
        begin
          if FB <> 0 then
            Stack.Push(TValue.From<Double>(FA / FB))
          else
            Stack.Push(TValue.From<Double>(0));
        end
        else if Token = '%' then
        begin
          if FB <> 0 then
            Stack.Push(TValue.From<Double>(fmod(FA, FB)))
          else
            Stack.Push(TValue.From<Double>(0));
        end
        else if Token = '~' then
          Stack.Push(TValue.From<String>(A.ToString + B.ToString))
        else if Token = '==' then
          Stack.Push(TValue.From<Boolean>(ValuesAreEqual(A, B)))
        else if Token = '!=' then
          Stack.Push(TValue.From<Boolean>(not ValuesAreEqual(A, B)))
        else if Token = '<' then
          Stack.Push(TValue.From<Boolean>(CompareValues(A, B, '<')))
        else if Token = '>' then
          Stack.Push(TValue.From<Boolean>(CompareValues(A, B, '>')))
        else if Token = '<=' then
          Stack.Push(TValue.From<Boolean>(CompareValues(A, B, '<=')))
        else if Token = '>=' then
          Stack.Push(TValue.From<Boolean>(CompareValues(A, B, '>=')))
        else if Token = 'in' then
          Stack.Push(TValue.From<Boolean>(Contains(A, B)))
        else if Token = 'starts with' then
          Stack.Push(TValue.From<Boolean>((A.Kind in [tkString, tkUString]) and (B.Kind in [tkString, tkUString]) and A.AsString.StartsWith(B.AsString)))
        else if Token = 'matches' then
        begin
          if (A.Kind in [tkString, tkUString]) and (B.Kind in [tkString, tkUString]) then
          begin
            try
              Regex := TRegEx.Create(B.AsString);
              Condition := Regex.IsMatch(A.AsString);
            except
              on E: Exception do
                Condition := False;
            end;
            Stack.Push(TValue.From<Boolean>(Condition));
          end
          else
            Stack.Push(TValue.From<Boolean>(False));
        end
        else if Token = '..' then
        begin
          if not (A.IsOrdinal or (A.Kind in [tkString, tkUString]) and TryStrToInt64(A.AsString, IA)) or
             not (B.IsOrdinal or (B.Kind in [tkString, tkUString]) and TryStrToInt64(B.AsString, IB)) then
            raise Exception.Create('Range operator requires integer operands: A=' + A.ToString + ', B=' + B.ToString);
          if A.Kind in [tkString, tkUString] then
            IA := StrToInt64(A.AsString)
          else
            IA := A.AsInt64;
          if B.Kind in [tkString, tkUString] then
            IB := StrToInt64(B.AsString)
          else
            IB := B.AsInt64;
          var Start: Int64 := IA;
          var Finish: Int64 := IB;
          var Step: Integer := 1;
          if Start > Finish then
            Step := -1;
          var Count: Integer := Abs(Finish - Start) + 1;
          SetLength(Arr, Count);
          var Cur := Start;
          for J := 0 to Count - 1 do
          begin
            Arr[J] := TValue.From<Int64>(Cur);
            Cur := Cur + Step;
          end;
          Stack.Push(TValue.From<TArray<TValue>>(Arr));
          //if FDebug then WriteLn('Debug: Range ', Start, '..', Finish, ' produced array length=', Length(Arr));
        end
        else if Token = 'and' then
          Stack.Push(TValue.From<Boolean>(ToBool(A) and ToBool(B)))
        else if Token = 'or' then
          Stack.Push(TValue.From<Boolean>(ToBool(A) or ToBool(B)))
        else if Token = 'not' then
        begin
          if Stack.Count < 1 then
            raise Exception.Create('Invalid expression: insufficient operands for not');
          A := Stack.Pop;
          Stack.Push(TValue.From<Boolean>(not ToBool(A)));
        end;
        //if FDebug then WriteLn('Debug: After Operation=', Token, ' StackCount=', Stack.Count);
      end;
      Inc(I);
    end;
    if Stack.Count <> 1 then
    begin
      var StackItems: String;
      for var Item in Stack do
        StackItems := StackItems + Item.ToString + ', ';
      raise Exception.Create('Invalid expression: stack imbalance, StackCount=' + IntToStr(Stack.Count) + ', Items=[' + StackItems + ']');
    end;
    Result := Stack.Pop;
    //if FDebug then WriteLn('Debug: EvaluateRPN Result=', Result.ToString);
  finally
    Stack.Free;
  end;
end;

/// <summary>
/// Evaluates an expression and returns its value.
/// </summary>
/// <param name="Expr">The expression to evaluate.</param>
/// <param name="Context">The context dictionary for variable resolution.</param>
/// <returns>The evaluated result as a TValue.</returns>
/// <remarks>
/// Uses tokenization and RPN to handle complex expressions including arithmetic, comparisons, and variable paths.
/// Updated to handle single-token expressions more robustly.
/// Returns an empty string for undefined variables or invalid expressions to align with Twig behavior.
/// </remarks>
function TTina4Twig.EvaluateExpression(const Expr: String; Context: TDictionary<String, TValue>): TValue;
var
  Tokens: TArray<String>;
  RPN: TArray<String>;
begin
  Tokens := Tokenize(Expr);
  if Length(Tokens) = 0 then
    Exit(TValue.From<String>('')); // Return empty string for empty expressions
  if Length(Tokens) = 1 then
  begin
    // Handle single-token expressions (e.g., a variable or literal)
    Result := GetExpressionValue(Tokens[0], Context);
    if Result.IsEmpty then
      Result := TValue.From<String>(''); // Return empty string for undefined variables
    Exit;
  end;
  RPN := InfixToRPN(Tokens);
  Result := EvaluateRPN(RPN, Context);
  if Result.IsEmpty then
    Result := TValue.From<String>(''); // Return empty string for invalid expressions
end;


function FindTopLevelPos(const S: String; Ch: Char): Integer;
var
  Depth: Integer;
  QuoteChar: Char;
  InQuote: Boolean;
  I: Integer;
begin
  Result := -1;
  Depth := 0;
  InQuote := False;
  QuoteChar := #0;
  for I := 1 to Length(S) do
  begin
    if InQuote then
    begin
      if S[I] = QuoteChar then
        InQuote := False;
    end
    else if S[I] in ['''', '"'] then
    begin
      InQuote := True;
      QuoteChar := S[I];
    end
    else if S[I] in ['(', '[', '{'] then
      Inc(Depth)
    else if S[I] in [')', ']', '}'] then
      Dec(Depth)
    else if (S[I] = Ch) and (Depth = 0) then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

/// <summary>
/// Retrieves the value of an expression, handling literals and variable paths.
/// </summary>
/// <param name="Expr">The expression to evaluate.</param>
/// <param name="Context">The context dictionary.</param>
/// <returns>The evaluated value as a TValue.</returns>
/// <remarks>
/// Supports array literals, dictionary access, and filter chains.
/// Includes debug logging for expression evaluation.
/// </remarks>
function TTina4Twig.GetExpressionValue(const Expr: String; Context: TDictionary<String, TValue>): TValue;
var
  CleanExpr, Lower, Inner, Key, ValueStr: String;
  IntVal: Int64;
  FloatVal: Double;
  ElemStrs: TArray<String>;
  Arr: TList<TValue>;
  Elem, AElem, ASElem, ASAElem: String;
  Dict: TDictionary<String, TValue>;
  PosColon: Integer;
  Val: TValue;
begin
  CleanExpr := NormalizeExpression(Expr);
  //WriteLn('Debug: GetExpressionValue Expr=', CleanExpr); // Debug: Log expression
  if ((CleanExpr.StartsWith('"') and CleanExpr.EndsWith('"')) or (CleanExpr.StartsWith('''') and CleanExpr.EndsWith(''''))) and (Length(CleanExpr) >= 2) then
  begin
    Result := TValue.From<String>(Copy(CleanExpr, 2, Length(CleanExpr) - 2));
    //WriteLn('Debug: GetExpressionValue Result (String)=', Result.ToString); // Debug: Log string result
    Exit;
  end;

  Lower := CleanExpr.ToLower;
  if Lower = 'true' then
  begin
    Result := TValue.From<Boolean>(True);
    //WriteLn('Debug: GetExpressionValue Result (Boolean)=', Result.ToString); // Debug: Log boolean result
    Exit;
  end
  else if Lower = 'false' then
  begin
    Result := TValue.From<Boolean>(False);
    //WriteLn('Debug: GetExpressionValue Result (Boolean)=', Result.ToString); // Debug: Log boolean result
    Exit;
  end;

  if TryStrToInt64(CleanExpr, IntVal) then
  begin
    Result := TValue.From<Int64>(IntVal);
    //WriteLn('Debug: GetExpressionValue Result (Int)=', Result.ToString); // Debug: Log integer result
    Exit;
  end;

  if TryStrToFloat(CleanExpr, FloatVal) then
  begin
    Result := TValue.From<Double>(FloatVal);
    //WriteLn('Debug: GetExpressionValue Result (Float)=', Result.ToString); // Debug: Log float result
    Exit;
  end;

  if CleanExpr.StartsWith('[') and CleanExpr.EndsWith(']') then
  begin
    Inner := Copy(CleanExpr, 2, Length(CleanExpr) - 2).Trim;
    if Inner = '' then
    begin
      Result := TValue.From<TArray<TValue>>([]);
      //WriteLn('Debug: GetExpressionValue Result (Empty Array)=', Result.ToString); // Debug: Log empty array
      Exit;
    end;
    ElemStrs := SplitOnTopLevel(Inner, ',');
    Arr := TList<TValue>.Create;
    try
      for AElem in ElemStrs do
      begin
        Elem := Trim(AElem);
        if Elem = '' then Continue;
        if Elem.StartsWith('{') and Elem.EndsWith('}') then
        begin
          Dict := TDictionary<String, TValue>.Create;
          try
            var DictInner := Copy(Elem, 2, Length(Elem) - 2).Trim;
            if DictInner <> '' then
            begin
              var DictElems := SplitOnTopLevel(DictInner, ',');
              for ASElem in DictElems do
              begin
                ASAElem := Trim(ASElem);
                if ASAElem = '' then Continue;
                PosColon := FindTopLevelPos(ASAElem, ':');
                if PosColon <= 0 then
                  raise Exception.Create('Invalid dictionary pair: ' + ASAElem);
                Key := Trim(Copy(ASAElem, 1, PosColon - 1));
                if ((Key.StartsWith('"') and Key.EndsWith('"')) or (Key.StartsWith('''') and Key.EndsWith(''''))) and (Length(Key) >= 2) then
                  Key := Copy(Key, 2, Length(Key) - 2);
                ValueStr := Trim(Copy(ASAElem, PosColon + 1, MaxInt));
                Val := EvaluateExpression(ValueStr, Context);
                Dict.Add(Key, Val);
              end;
            end;
            Arr.Add(TValue.From<TDictionary<String, TValue>>(Dict));
          except
            Dict.Free;
            raise;
          end;
        end
        else
          Arr.Add(EvaluateExpression(Elem, Context));
      end;
      Result := TValue.From<TArray<TValue>>(Arr.ToArray);
      //WriteLn('Debug: GetExpressionValue Result (Array)=', Result.ToString); // Debug: Log array result
    finally
      Arr.Free;
    end;
    Exit;
  end;

  if CleanExpr.StartsWith('{') and CleanExpr.EndsWith('}') then
  begin
    Inner := Copy(CleanExpr, 2, Length(CleanExpr) - 2);
    ElemStrs := SplitOnTopLevel(Inner, ',');
    Dict := TDictionary<String, TValue>.Create;
    try
      for Elem in ElemStrs do
      begin
        AElem := Trim(Elem);
        if AElem = '' then Continue;
        PosColon := FindTopLevelPos(AElem, ':');
        if PosColon <= 0 then
          raise Exception.Create('Invalid dictionary pair: ' + AElem);
        Key := Trim(Copy(AElem, 1, PosColon - 1));
        if ((Key.StartsWith('"') and Key.EndsWith('"')) or (Key.StartsWith('''') and Key.EndsWith(''''))) and (Length(Key) >= 2) then
          Key := Copy(Key, 2, Length(Key) - 2);
        ValueStr := Trim(Copy(AElem, PosColon + 1, MaxInt));
        Val := EvaluateExpression(ValueStr, Context);
        Dict.Add(Key, Val);
      end;
      Result := TValue.From<TDictionary<String, TValue>>(Dict);
      //WriteLn('Debug: GetExpressionValue Result (Dict)=', Result.ToString); // Debug: Log dict result
    except
      Dict.Free;
      raise;
    end;
    Exit;
  end;

  if CleanExpr.Contains('|') then
  begin
    Result := EvaluateExpression(CleanExpr, Context);
    //WriteLn('Debug: GetExpressionValue Result ('+CleanExpr+')=', Result.ToString); // Debug: Log filter chain result
  end
   else
  begin
    Result := ResolveVariablePath(CleanExpr, Context);
    //WriteLn('Debug: GetExpressionValue Result ('+CleanExpr+')=', Result.ToString); // Debug: Log variable path result
  end;
end;

function TTina4Twig.GetVariable(AName: String): TValue;
begin
  try
    Result := FContext[AName];
  except
    Result := AName+' not found';
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
  FDebug := False;
  FContext := TDictionary<String, TValue>.Create;

  //Set the date format for the system to be used in date_format and date
  SetDateFormat('YYYY-mm-dd', '%d days');

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
  RegisterDefaultFunctions;

  FMacros := TDictionary<String, TMacroFunc>.Create;
  FMacroParams := TDictionary<String, TArray<String>>.Create;
  FMacroDefaults := TDictionary<String, TDictionary<String, String>>.Create;
  FMacroBodies := TDictionary<String, String>.Create;



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
  v: TValue;
begin
  for pair in FContext do
  begin
    if pair.Value.IsObject then
    begin
      if pair.Value.AsObject is TDictionary<String, TValue> then
        pair.Value.AsObject.Free
      else if pair.Value.AsObject is TJSONValue then
        pair.Value.AsObject.Free;
    end
    else if pair.Value.IsArray then
    begin
      for v in pair.Value.AsType<TArray<TValue>> do
      begin
        if v.IsObject and (v.AsObject is TDictionary<String, TValue>) then
          v.AsObject.Free;
      end;
    end;
  end;
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
/// Removes comments and surrounding line feeds from the template string.
/// </summary>
/// <param name="Template">The template string containing comments.</param>
/// <returns>The template without comments and their surrounding line feeds.</returns>
/// <remarks>
/// Removes {# ... #} comments, including multiline, and trims leading/trailing line feeds.
/// Preserves other content and whitespace outside of comments.
/// </remarks>
function TTina4Twig.RemoveComments(const Template: String): String;
var
  Regex: TRegEx;
begin
  // Match {# ... #} comments with optional leading/trailing \r\n, \n, or \r
  Regex := TRegEx.Create('(\r\n|\n|\r)?\{#.*?#\}(\r\n|\n|\r)?', [roSingleLine, roMultiLine]);
  Result := Regex.Replace(Template, '');
end;

/// <summary>
/// Checks if two TValue instances are equal.
/// </summary>
/// <param name="A">First value.</param>
/// <param name="B">Second value.</param>
/// <returns>True if values are equal, False otherwise.</returns>
/// <remarks>
/// Handles empty values, ordinal types, strings, and objects. Converts string to numeric for comparisons with numbers.
/// </remarks>
function TTina4Twig.ValuesAreEqual(const A, B: TValue): Boolean;
var
  IsNumA, IsNumB: Boolean;
  NA, NB: Extended;
  StrVal: String;
  IntVal: Int64;
  FloatVal: Extended;
begin
  if A.IsEmpty and B.IsEmpty then
    Exit(True);
  if A.IsEmpty <> B.IsEmpty then
    Exit(False);
  if (A.Kind = tkEnumeration) and (A.TypeInfo = TypeInfo(Boolean)) and
     (B.Kind = tkEnumeration) and (B.TypeInfo = TypeInfo(Boolean)) then
    Exit(A.AsBoolean = B.AsBoolean);
  IsNumA := IsStrictNumeric(A);
  IsNumB := IsStrictNumeric(B);
  if IsNumA and IsNumB then
    Exit(Abs(A.AsExtended - B.AsExtended) < 1E-12);
  if (A.Kind in [tkString, tkLString, tkWString, tkUString]) and
     (B.Kind in [tkString, tkLString, tkWString, tkUString]) then
    Exit(A.AsString = B.AsString);
  if A.IsObject and B.IsObject then
    Exit(A.AsObject = B.AsObject);
  // Handle string vs. numeric comparison
  if (A.Kind in [tkString, tkLString, tkWString, tkUString]) and IsNumB then
  begin
    StrVal := A.AsString;
    if TryStrToInt64(StrVal, IntVal) then
      Exit(Abs(IntVal - B.AsExtended) < 1E-12)
    else if TryStrToFloat(StrVal, FloatVal) then
      Exit(Abs(FloatVal - B.AsExtended) < 1E-12)
    else
      Exit(False);
  end;
  if (B.Kind in [tkString, tkLString, tkWString, tkUString]) and IsNumA then
  begin
    StrVal := B.AsString;
    if TryStrToInt64(StrVal, IntVal) then
      Exit(Abs(A.AsExtended - IntVal) < 1E-12)
    else if TryStrToFloat(StrVal, FloatVal) then
      Exit(Abs(A.AsExtended - FloatVal) < 1E-12)
    else
      Exit(False);
  end;
  NA := GetAsExtendedLenient(A);
  NB := GetAsExtendedLenient(B);
  Exit(Abs(NA - NB) < 1E-12);
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
  JSONArray: TJSONArray;
  I: Integer;
begin
  Result := False;
  if (Right.Kind in [tkString, tkUString]) and (Left.Kind in [tkString, tkUString]) then
    Result := Pos(Left.AsString, Right.AsString) > 0
  else if Right.IsArray then
  begin
    Arr := Right.AsType<TArray<TValue>>;
    for v in Arr do
      if (Left.Kind in [tkString, tkUString]) and (v.Kind in [tkString, tkUString]) and (Left.AsString = v.AsString) then
      begin
        Result := True;
        Exit;
      end;
  end
  else if Right.IsObject and (Right.AsObject is TJSONArray) then
  begin
    JSONArray := TJSONArray(Right.AsObject);
    for I := 0 to JSONArray.Count - 1 do
      if (Left.Kind in [tkString, tkUString]) and (JSONArray.Items[I] is TJSONString) and (Left.AsString = TJSONString(JSONArray.Items[I]).Value) then
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

function TTina4Twig.ConvertJSONToTValue(const JSON: TJSONValue): TValue;
var
  Dict: TDictionary<String, TValue>;
  Arr: TArray<TValue>;
  I: Integer;
  Obj: TJSONObject;
  JArr: TJSONArray;
  NumStr: String;
begin
  if JSON is TJSONObject then
  begin
    Obj := TJSONObject(JSON);
    Dict := TDictionary<String, TValue>.Create;
    try
      for var Pair in Obj do
      begin
        Dict.Add(Pair.JsonString.Value, ConvertJSONToTValue(Pair.JsonValue));
      end;
      Result := TValue.From<TDictionary<String, TValue>>(Dict);
    except
      Dict.Free;
      raise;
    end;
  end
  else if JSON is TJSONArray then
  begin
    JArr := TJSONArray(JSON);
    SetLength(Arr, JArr.Count);
    for I := 0 to JArr.Count - 1 do
      Arr[I] := ConvertJSONToTValue(JArr.Items[I]);
    Result := TValue.From<TArray<TValue>>(Arr);
  end
  else if JSON is TJSONNumber then
  begin
    NumStr := JSON.Value;
    if (Pos('.', NumStr) > 0) or (Pos('e', LowerCase(NumStr)) > 0) then
      Result := TValue.From<Double>(TJSONNumber(JSON).AsDouble)
    else
      Result := TValue.From<Int64>(TJSONNumber(JSON).AsInt64);
  end
  else if JSON is TJSONString then
    Result := TValue.From<String>(JSON.Value)
  else if JSON is TJSONTrue then
    Result := TValue.From<Boolean>(True)
  else if JSON is TJSONFalse then
    Result := TValue.From<Boolean>(False)
  else if JSON is TJSONNull then
    Result := TValue.Empty
  else
    Result := TValue.From<String>(JSON.ToString);
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
/// Determines if a value is strictly numeric (integer, float, or a string that fully represents a number).
/// </summary>
/// <param name="Value">The value to check.</param>
/// <returns>True if the value is strictly numeric; otherwise, False.</returns>
function TTina4Twig.IsStrictNumeric(const Value: TValue): Boolean;
var
  Dummy: Double;
begin
  case Value.Kind of
    tkInteger, tkInt64, tkFloat:
      Result := True;
    tkString, tkLString, tkWString, tkUString:
      Result := TryStrToFloat(Value.AsString, Dummy);
    else
      Result := False;
  end;
end;

/// <summary>
/// Converts a value to an extended floating-point number using lenient conversion rules similar to PHP.
/// </summary>
/// <param name="Value">The value to convert.</param>
/// <returns>The converted extended value.</returns>
function TTina4Twig.GetAsExtendedLenient(const Value: TValue): Extended;
var
  dt: TDateTime;
begin
  if Value.IsEmpty then Exit(0);
  case Value.Kind of
    tkInteger, tkInt64: Result := Value.AsInt64;
    tkFloat:
      begin
        if Value.TypeInfo = TypeInfo(TDateTime) then
          Result := DateTimeToUnix(Value.AsType<TDateTime>)
        else
          Result := Value.AsExtended;
      end;
    tkString, tkUString:
      begin
        if TryStrToFloat(Value.AsString, Result) then
          // Success
        else if TryStrToDateTime(Value.AsString, dt) then
          Result := DateTimeToUnix(dt)
        else
          Result := 0;
      end;
    else Result := 0;
  end;
end;

/// <summary>
/// Compares two values using the specified operator, handling types similarly to Twig/PHP.
/// </summary>
/// <param name="Left">The left value.</param>
/// <param name="Right">The right value.</param>
/// <param name="Op">The comparison operator (&lt;, &gt;, &lt;=, &gt;=).</param>
/// <returns>True if the comparison holds; otherwise, False.</returns>
function TTina4Twig.CompareValues(const Left, Right: TValue; const Op: String): Boolean;
var
  IsNumL, IsNumR: Boolean;
  NL, NR: Extended;
begin
  IsNumL := IsStrictNumeric(Left);
  IsNumR := IsStrictNumeric(Right);

  if IsNumL and IsNumR then
  begin
    NL := Left.AsExtended;
    NR := Right.AsExtended;
  end
   else
  if (Left.Kind in [tkString, tkUString]) and (Right.Kind in [tkString, tkUString]) then
  begin
    if Op.ToLower = '<' then
        Result := Left.AsString < Right.AsString
    else
    if Op.ToLower = '>' then
      Result := Left.AsString > Right.AsString
    else
    if Op.ToLower = '<=' then
     Result := Left.AsString <= Right.AsString
    else
    if Op.ToLower = '>=' then
      Result := Left.AsString >= Right.AsString
    else Result := False;

    Exit;
  end
    else
  begin
    NL := GetAsExtendedLenient(Left);
    NR := GetAsExtendedLenient(Right);
  end;

  if Op.ToLower = '<' then Result := NL < NR
  else
  if Op.ToLower = '>' then Result := NL > NR
  else
  if Op.ToLower = '<=' then Result := NL <= NR
  else
  if Op.ToLower = '>=' then Result := NL >= NR
  else
  Result := False;
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
  FloatVal: Double;
  IntVal: Int64;
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
    Exit(VariablePath);

  // Initial lookup
  if not Context.TryGetValue(Parts[0], Current) then
  begin
    // Check if VariablePath is a number, JSON array, or JSON object
    if TryStrToInt64(VariablePath, IntVal) or
       TryStrToFloat(VariablePath, FloatVal) or
       ((VariablePath.StartsWith('"') and VariablePath.EndsWith('"')) or
        (VariablePath.StartsWith('''') and VariablePath.EndsWith(''''))) or
       VariablePath.StartsWith('[') or
       VariablePath.StartsWith('{') then
    begin
      Result := GetExpressionValue(VariablePath, Context);
      Exit; // Return immediately since literals don't have nested paths
    end
    else
    begin
      Exit(TValue.Empty); // Not found in context and not a literal
    end;
  end;


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
              Current := TValue.From<TJSONObject>(TJSONObject(JSONVal))
            else if JSONVal is TJSONArray then
              Current := TValue.From<TJSONArray>(TJSONArray(JSONVal))
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
      else if Current.IsObject and (Current.AsObject is TJSONObject) then
      begin
        var obj := TJSONObject(Current.AsObject);
        var pair := obj.Get(Key);
        if Assigned(pair) then
        begin
          if pair.JsonValue is TJSONNumber then
          begin
            var numStr := pair.JsonValue.Value;
            if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
              Current := TValue.From<Double>(TJSONNumber(pair.JsonValue).AsDouble)
            else
              Current := TValue.From<Int64>(TJSONNumber(pair.JsonValue).AsInt64);
          end
          else if pair.JsonValue is TJSONString then
            Current := TValue.From<String>(TJSONString(pair.JsonValue).Value)
          else if pair.JsonValue is TJSONBool then
            Current := TValue.From<Boolean>(TJSONBool(pair.JsonValue).AsBoolean)
          else if pair.JsonValue is TJSONNull then
            Current := TValue.Empty
          else if pair.JsonValue is TJSONObject then
            Current := TValue.From<TJSONObject>(TJSONObject(pair.JsonValue))
          else if pair.JsonValue is TJSONArray then
            Current := TValue.From<TJSONArray>(TJSONArray(pair.JsonValue))
          else
            Current := TValue.From<String>(pair.JsonValue.ToString);
        end
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
  SubDict: TDictionary<String, TValue>;
  SubArray: TArray<TValue>;
  I: Integer;
begin
  Result := TDictionary<String, TValue>.Create;
  Content := Trim(DictStr);

  // Remove surrounding braces if present
  if Content.StartsWith('{') and Content.EndsWith('}') then
    Content := Content.Substring(1, Content.Length - 2).Trim
  else if Content.StartsWith('[') and Content.EndsWith(']') then
    Content := Content.Substring(1, Content.Length - 2).Trim;

  if Content = '' then
    Exit;

  // Try to parse as JSON array or object
  JSONValue := TJSONObject.ParseJSONValue('[' + Content + ']');
  try
    if (JSONValue <> nil) and (JSONValue is TJSONArray) then
    begin
      var JSONArray := TJSONArray(JSONValue);
      SetLength(SubArray, JSONArray.Count);
      for I := 0 to JSONArray.Count - 1 do
      begin
        var Item := JSONArray.Items[I];
        if Item is TJSONObject then
        begin
          SubDict := TDictionary<String, TValue>.Create;
          try
            for Pair in TJSONObject(Item) do
            begin
              Key := Pair.JsonString.Value;
              if Pair.JsonValue is TJSONNumber then
              begin
                ValueStr := Pair.JsonValue.Value;
                if (Pos('.', ValueStr) > 0) or (Pos('e', LowerCase(ValueStr)) > 0) then
                begin
                  if TryStrToFloat(ValueStr, FloatVal) then
                    Value := TValue.From<Double>(FloatVal)
                  else
                    Value := TValue.From<String>(ValueStr);
                end
                else if TryStrToInt64(ValueStr, Int64Val) then
                  Value := TValue.From<Int64>(Int64Val)
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
              else if Pair.JsonValue is TJSONObject then
              begin
                var NestedDict := TDictionary<String, TValue>.Create;
                try
                  for var NestedPair in TJSONObject(Pair.JsonValue) do
                  begin
                    if NestedPair.JsonValue is TJSONNumber then
                    begin
                      ValueStr := NestedPair.JsonValue.Value;
                      if (Pos('.', ValueStr) > 0) or (Pos('e', LowerCase(ValueStr)) > 0) then
                      begin
                        if TryStrToFloat(ValueStr, FloatVal) then
                          NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<Double>(FloatVal))
                        else
                          NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<String>(ValueStr));
                      end
                      else if TryStrToInt64(ValueStr, Int64Val) then
                        NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<Int64>(Int64Val))
                      else
                        NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<String>(ValueStr));
                    end
                    else if NestedPair.JsonValue is TJSONTrue then
                      NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<Boolean>(True))
                    else if NestedPair.JsonValue is TJSONFalse then
                      NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<Boolean>(False))
                    else if NestedPair.JsonValue is TJSONString then
                      NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<String>(TJSONString(NestedPair.JsonValue).Value))
                    else if NestedPair.JsonValue is TJSONNull then
                      NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.Empty)
                    else
                      NestedDict.AddOrSetValue(NestedPair.JsonString.Value, TValue.From<String>(NestedPair.JsonValue.ToString));
                  end;
                  Value := TValue.From<TDictionary<String, TValue>>(NestedDict);
                except
                  NestedDict.Free;
                  raise;
                end;
              end
              else if Pair.JsonValue is TJSONArray then
              begin
                var NestedArray := TJSONArray(Pair.JsonValue);
                var ArrayValues: TArray<TValue>;
                SetLength(ArrayValues, NestedArray.Count);
                for var J := 0 to NestedArray.Count - 1 do
                begin
                  var NestedItem := NestedArray.Items[J];
                  if NestedItem is TJSONNumber then
                  begin
                    ValueStr := NestedItem.Value;
                    if (Pos('.', ValueStr) > 0) or (Pos('e', LowerCase(ValueStr)) > 0) then
                    begin
                      if TryStrToFloat(ValueStr, FloatVal) then
                        ArrayValues[J] := TValue.From<Double>(FloatVal)
                      else
                        ArrayValues[J] := TValue.From<String>(ValueStr);
                    end
                    else if TryStrToInt64(ValueStr, Int64Val) then
                      ArrayValues[J] := TValue.From<Int64>(Int64Val)
                    else
                      ArrayValues[J] := TValue.From<String>(ValueStr);
                  end
                  else if NestedItem is TJSONTrue then
                    ArrayValues[J] := TValue.From<Boolean>(True)
                  else if NestedItem is TJSONFalse then
                    ArrayValues[J] := TValue.From<Boolean>(False)
                  else if NestedItem is TJSONString then
                    ArrayValues[J] := TValue.From<String>(TJSONString(NestedItem).Value)
                  else if NestedItem is TJSONNull then
                    ArrayValues[J] := TValue.Empty
                  else
                    ArrayValues[J] := TValue.From<String>(NestedItem.ToString);
                end;
                Value := TValue.From<TArray<TValue>>(ArrayValues);
              end
              else
                Value := TValue.From<String>(Pair.JsonValue.ToString);
              SubDict.AddOrSetValue(Key, Value);
            end;
            SubArray[I] := TValue.From<TDictionary<String, TValue>>(SubDict);
          except
            SubDict.Free;
            raise;
          end;
        end
        else if Item is TJSONNumber then
        begin
          ValueStr := Item.Value;
          if (Pos('.', ValueStr) > 0) or (Pos('e', LowerCase(ValueStr)) > 0) then
          begin
            if TryStrToFloat(ValueStr, FloatVal) then
              SubArray[I] := TValue.From<Double>(FloatVal)
            else
              SubArray[I] := TValue.From<String>(ValueStr);
          end
          else if TryStrToInt64(ValueStr, Int64Val) then
            SubArray[I] := TValue.From<Int64>(Int64Val)
          else
            SubArray[I] := TValue.From<String>(ValueStr);
        end
        else if Item is TJSONTrue then
          SubArray[I] := TValue.From<Boolean>(True)
        else if Item is TJSONFalse then
          SubArray[I] := TValue.From<Boolean>(False)
        else if Item is TJSONString then
          SubArray[I] := TValue.From<String>(TJSONString(Item).Value)
        else if Item is TJSONNull then
          SubArray[I] := TValue.Empty
        else
          SubArray[I] := TValue.From<String>(Item.ToString);
      end;
      Result.AddOrSetValue('array', TValue.From<TArray<TValue>>(SubArray));
    end
    else
    begin
      // Fallback for simple key-value pairs
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
/// <summary>
/// Replaces {% include %} tags with the content of the included templates.
/// </summary>
/// <param name="Template">The template string containing include tags.</param>
/// <param name="Context">The context dictionary for evaluating include expressions.</param>
/// <returns>The template with includes evaluated and replaced.</returns>
/// <remarks>
/// Recursively renders included templates using the current context.
/// Supports dynamic include names via expressions.
/// Handles optional 'with' and 'only' options, but simplified here.
/// </remarks>
function TTina4Twig.EvaluateIncludes(const Template: String; Context: TDictionary<String, TValue>): String;
var
  SB: TStringBuilder;
  CurrentPos, EndPos, TagStart: Integer;
  Tag, IncludeExpr, IncludeName, IncludedText: String;
  IncludeDict: TDictionary<String, TValue>;
  UseOnly: Boolean;
begin
  SB := TStringBuilder.Create;
  try
    CurrentPos := 1;
    while CurrentPos <= Length(Template) do
    begin
      EndPos := CurrentPos;
      while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
        Inc(EndPos);
      if EndPos > CurrentPos then
        SB.Append(Copy(Template, CurrentPos, EndPos - CurrentPos));
      if EndPos > Length(Template) then
        Break;
      TagStart := EndPos;
      CurrentPos := EndPos + 2;
      EndPos := CurrentPos;
      while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
        Inc(EndPos);
      if EndPos > Length(Template) then
        raise Exception.Create('Unclosed {%');
      Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
      CurrentPos := EndPos + 2;
      if Tag.StartsWith('include ') then
      begin
        IncludeExpr := Trim(Copy(Tag, 9, MaxInt));
        UseOnly := False;
        IncludeDict := nil;
        if IncludeExpr.Contains(' with ') then
        begin
          var WithPos := Pos(' with ', IncludeExpr);
          var WithExpr := Trim(Copy(IncludeExpr, WithPos + 6, MaxInt));
          IncludeExpr := Trim(Copy(IncludeExpr, 1, WithPos - 1));
          if WithExpr.EndsWith(' only') then
          begin
            UseOnly := True;
            WithExpr := Trim(Copy(WithExpr, 1, Length(WithExpr) - 5));
          end;
          IncludeDict := ParseVariableDict(WithExpr, Context);
        end;
        IncludeName := EvaluateExpression(IncludeExpr, Context).ToString;
        if ((IncludeName.StartsWith('"') and IncludeName.EndsWith('"')) or (IncludeName.StartsWith('''') and IncludeName.EndsWith(''''))) and (Length(IncludeName) >= 2) then
          IncludeName := Copy(IncludeName, 2, Length(IncludeName) - 2);
        var LocalContext: TDictionary<String, TValue> := TDictionary<String, TValue>.Create;
        try
          if not UseOnly then
            for var Pair in Context do
              LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
          if Assigned(IncludeDict) then
            for var Pair in IncludeDict do
              LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
          IncludedText := RenderInternal(IncludeName, LocalContext);
        finally
          LocalContext.Free;
          if Assigned(IncludeDict) then
            IncludeDict.Free;
        end;
        SB.Append(IncludedText);
      end
      else
        SB.Append('{% ' + Tag + ' %}');
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;




/// <summary>
/// Processes {% extends %} tags to integrate the parent template with child template blocks.
/// </summary>
/// <param name="Template">The child template containing extends and block tags.</param>
/// <param name="Context">The context dictionary for variable resolution.</param>
/// <returns>The fully rendered template with parent content and child blocks.</returns>
/// <remarks>
/// Loads the parent template, extracts blocks from the child template, and replaces corresponding
/// blocks in the parent. Ensures includes in the parent template are processed correctly.
/// </remarks>
function TTina4Twig.EvaluateExtends(const Template: String; Context: TDictionary<String, TValue>): String;
var
  SB: TStringBuilder;
  CurrentPos, EndPos, TagStart, BlockStart: Integer;
  Tag, ExtendsExpr, ParentTemplateName, ParentTemplate, BlockName, BlockContent: String;
  Blocks: TDictionary<String, String>;
  BlockDepth: Integer;
begin
  Blocks := TDictionary<String, String>.Create;
  try
    SB := TStringBuilder.Create;
    try
      CurrentPos := 1;
      while CurrentPos <= Length(Template) do
      begin
        EndPos := CurrentPos;
        while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
          Inc(EndPos);
        if EndPos > CurrentPos then
          SB.Append(Copy(Template, CurrentPos, EndPos - CurrentPos));
        if EndPos > Length(Template) then
          Break;
        TagStart := EndPos;
        CurrentPos := EndPos + 2;
        EndPos := CurrentPos;
        while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
          Inc(EndPos);
        if EndPos > Length(Template) then
          raise Exception.Create('Unclosed {%');
        Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
        CurrentPos := EndPos + 2;

        if Tag.StartsWith('extends ') then
        begin
          ExtendsExpr := Trim(Copy(Tag, 8, MaxInt));
          ParentTemplateName := EvaluateExpression(ExtendsExpr, Context).ToString;
          if ((ParentTemplateName.StartsWith('"') and ParentTemplateName.EndsWith('"')) or
              (ParentTemplateName.StartsWith('''') and ParentTemplateName.EndsWith(''''))) and
             (Length(ParentTemplateName) >= 2) then
            ParentTemplateName := Copy(ParentTemplateName, 2, Length(ParentTemplateName) - 2);
          ParentTemplate := LoadTemplate(ParentTemplateName);
        end
        else if Tag.StartsWith('block ') then
        begin
          BlockName := Trim(Copy(Tag, 6, MaxInt));
          BlockDepth := 1;
          BlockStart := CurrentPos;
          while (CurrentPos <= Length(Template)) and (BlockDepth > 0) do
          begin
            EndPos := CurrentPos;
            while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
              Inc(EndPos);
            if EndPos > Length(Template) then
              raise Exception.Create('Unclosed block');
            TagStart := EndPos;
            CurrentPos := EndPos + 2;
            EndPos := CurrentPos;
            while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
              Inc(EndPos);
            Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
            CurrentPos := EndPos + 2;
            if Tag.StartsWith('block ') then
              Inc(BlockDepth)
            else if Tag = 'endblock' then
              Dec(BlockDepth);
          end;
          BlockContent := Copy(Template, BlockStart, TagStart - BlockStart);
          Blocks.AddOrSetValue(BlockName, BlockContent);
        end
        else
        begin
          SB.Append('{% ' + Tag + ' %}');
        end;
      end;

      // If no extends tag was found, return the original template
      if ParentTemplateName = '' then
      begin
        Result := SB.ToString;
        Exit;
      end;

      // Process parent template, replacing blocks with child blocks
      CurrentPos := 1;
      SB.Clear;
      while CurrentPos <= Length(ParentTemplate) do
      begin
        EndPos := CurrentPos;
        while (EndPos <= Length(ParentTemplate)) and not ((ParentTemplate[EndPos] = '{') and (EndPos + 1 <= Length(ParentTemplate)) and (ParentTemplate[EndPos + 1] = '%')) do
          Inc(EndPos);
        if EndPos > CurrentPos then
          SB.Append(Copy(ParentTemplate, CurrentPos, EndPos - CurrentPos));
        if EndPos > Length(ParentTemplate) then
          Break;
        TagStart := EndPos;
        CurrentPos := EndPos + 2;
        EndPos := CurrentPos;
        while (EndPos <= Length(ParentTemplate)) and not ((ParentTemplate[EndPos] = '%') and (EndPos + 1 <= Length(ParentTemplate)) and (ParentTemplate[EndPos + 1] = '}')) do
          Inc(EndPos);
        if EndPos > Length(ParentTemplate) then
          raise Exception.Create('Unclosed {% in parent template');
        Tag := Trim(Copy(ParentTemplate, CurrentPos, EndPos - CurrentPos));
        CurrentPos := EndPos + 2;

        if Tag.StartsWith('block ') then
        begin
          BlockName := Trim(Copy(Tag, 6, MaxInt));
          BlockDepth := 1;
          BlockStart := CurrentPos;
          while (CurrentPos <= Length(ParentTemplate)) and (BlockDepth > 0) do
          begin
            EndPos := CurrentPos;
            while (EndPos <= Length(ParentTemplate)) and not ((ParentTemplate[EndPos] = '{') and (EndPos + 1 <= Length(ParentTemplate)) and (ParentTemplate[EndPos + 1] = '%')) do
              Inc(EndPos);
            if EndPos > Length(ParentTemplate) then
              raise Exception.Create('Unclosed block in parent template');
            TagStart := EndPos;
            CurrentPos := EndPos + 2;
            EndPos := CurrentPos;
            while (EndPos <= Length(ParentTemplate)) and not ((ParentTemplate[EndPos] = '%') and (EndPos + 1 <= Length(ParentTemplate)) and (ParentTemplate[EndPos + 1] = '}')) do
              Inc(EndPos);
            Tag := Trim(Copy(ParentTemplate, CurrentPos, EndPos - CurrentPos));
            CurrentPos := EndPos + 2;
            if Tag.StartsWith('block ') then
              Inc(BlockDepth)
            else if Tag = 'endblock' then
              Dec(BlockDepth);
          end;
          if Blocks.ContainsKey(BlockName) then
            SB.Append(Blocks[BlockName])
          else
            SB.Append(Copy(ParentTemplate, BlockStart, TagStart - BlockStart));
        end
        else
        begin
          SB.Append('{% ' + Tag + ' %}');
        end;
      end;

      // Render the resulting template to process any includes (like default.css)
      var LocalContext := TDictionary<String, TValue>.Create;
      try
        for var Pair in Context do
          LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
        Result := RenderInternal(SB.ToString, LocalContext);
      finally
        LocalContext.Free;
      end;
    finally
      SB.Free;
    end;
  finally
    Blocks.Free;
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
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  var
    Val: Double;
  begin
    if Input.IsOrdinal then
      Result := TValue.From<Int64>(Abs(Input.AsInt64))
    else if Input.IsType<Double> then
      Result := TValue.From<Double>(Abs(Input.AsExtended))
    else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
      Result := TValue.From<Double>(Abs(Val))
    else
      Result := Input;
  end);

  FFilters.Add('batch',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if (Input.Kind in [tkString, tkUString]) and (Input.AsString <> '') then
        Result := UpperCase(Input.AsString[1]) + LowerCase(Copy(Input.AsString, 2, MaxInt))
      else
        Result := Input.ToString;
    end);

  FFilters.Add('column',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: encoding conversion not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('country_name',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: country name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_name',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: currency name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_symbol',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: currency symbol lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('data_uri',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := 'data:;base64,' + TNetEncoding.Base64.Encode(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('date',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      dt: TDateTime;
      fmt: String;
      S: String;
      UnixTime: Int64;
    begin
      var SavedFormatSettings := FormatSettings;
      if Length(Args) > 0 then
      begin
        fmt := Args[0];
        if fmt.StartsWith('''') or fmt.StartsWith('"') then
          fmt := Copy(fmt, 2, Length(fmt) - 2); // Remove quotes

        if UpperCase(fmt) <> 'U' then
          fmt := ResolveVariablePath(fmt, Context).ToString;

        if fmt = '(empty)' then
        begin
          fmt := Args[0];
          if fmt.StartsWith('''') or fmt.StartsWith('"') then
            fmt := Copy(fmt, 2, Length(fmt) - 2); // Remove quotes
        end;
      end
      else
        fmt := FDateFormat;

      if Input.IsType<TDateTime> then
        dt := Input.AsType<TDateTime>
      else if Input.Kind in [tkString, tkUString] then
      begin
        S := Input.AsString;
        FormatSettings.LongDateFormat := FDateFormat; // Set format for ISO 8601 parsing
        FormatSettings.ShortDateFormat := FDateFormat;
        if S = 'now' then
        begin
          S := DateTimeToStr(Now);
        end;

        if not TryStrToDateTime(S, dt) then
        begin
          FormatSettings := SavedFormatSettings; // Restore original settings
          Exit('0'); // Return 0 for invalid dates
        end;
        FormatSettings := SavedFormatSettings; // Restore after parsing
      end
      else
        Exit('0'); // Return 0 for invalid input types

      if UpperCase(fmt) = 'U' then
      begin
        UnixTime := DateTimeToUnix(dt); // Explicitly convert to Int64
        Result := IntToStr(UnixTime);
      end
      else
        Result := FormatDateTime(fmt, dt);
    end);


   FFilters.Add('date_modify',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      dt: TDateTime;
      modifier: String;
      SavedFormatSettings: TFormatSettings;
      regex: TRegEx;
      matches: TMatchCollection;
      match: TMatch;
      sign: String;
      num: Integer;
      timeUnit: String;
      hasValidModifier: Boolean;
    begin
      if Length(Args) = 0 then
        Exit(Input.ToString);
      modifier := Args[0];

      if Input.IsType<TDateTime> then
        dt := Input.AsType<TDateTime>
      else if Input.Kind in [tkString, tkUString] then
      begin
        SavedFormatSettings := FormatSettings;
        FormatSettings.LongDateFormat := FDateFormat;
        FormatSettings.ShortDateFormat := FDateFormat;
        if not TryStrToDateTime(Input.AsString, dt) then
        begin
          FormatSettings := SavedFormatSettings;
          Exit(Input.AsString);
        end;
        FormatSettings := SavedFormatSettings;
      end
      else
        Exit(Input.ToString);

      hasValidModifier := False;
      regex := TRegEx.Create('([+-]?)\s*(\d+)\s*([a-zA-Z]+)', [roIgnoreCase]);
      matches := regex.Matches(modifier);
      for match in matches do
      begin
        hasValidModifier := True;
        sign := match.Groups[1].Value;
        num := StrToInt(match.Groups[2].Value);
        timeUnit := LowerCase(match.Groups[3].Value);
        if sign = '-' then
          num := -num;
        if timeUnit = 'year' then
          dt := IncYear(dt, num)
        else if timeUnit = 'years' then
          dt := IncYear(dt, num)
        else if timeUnit = 'month' then
          dt := IncMonth(dt, num)
        else if timeUnit = 'months' then
          dt := IncMonth(dt, num)
        else if timeUnit = 'week' then
          dt := IncDay(dt, num * 7)
        else if timeUnit = 'weeks' then
          dt := IncDay(dt, num * 7)
        else if timeUnit = 'day' then
          dt := IncDay(dt, num)
        else if timeUnit = 'days' then
          dt := IncDay(dt, num)
        else if timeUnit = 'hour' then
          dt := IncHour(dt, num)
        else if timeUnit = 'hours' then
          dt := IncHour(dt, num)
        else if timeUnit = 'minute' then
          dt := IncMinute(dt, num)
        else if timeUnit = 'minutes' then
          dt := IncMinute(dt, num)
        else if timeUnit = 'second' then
          dt := IncSecond(dt, num)
        else if timeUnit = 'seconds' then
          dt := IncSecond(dt, num)
        else
          hasValidModifier := False; // Invalid unit, mark as no valid modifiers
      end;

      if not hasValidModifier then
        Exit(Input.ToString); // Return original input string if no valid modifiers

      Result := StringReplace(FormatDateTime(FDateFormat+' hh:nn:ss', dt), ' 00:00:00', '', []);
    end);


  FFilters.Add('default',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      Strategy: String;
      InputStr: String;
      OutputStr: String;
    begin
      if Input.IsEmpty then
        Exit(''); // Return empty string for TValue.Empty

      InputStr := Input.ToString;
      OutputStr:= '';
      Strategy := 'html';
      if Length(Args) > 0 then
        Strategy := LowerCase(Args[0]);

      if Strategy = 'html' then
      begin
        OutputStr := StringReplace(InputStr, '&', '&amp;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '<', '&lt;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '>', '&gt;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '"', '&quot;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '''', '&#39;', [rfReplaceAll]);
      end
      else if Strategy = 'js' then
      begin
        OutputStr := StringReplace(InputStr, '\', '\\', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '"', '\"', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '''', '\''', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, sLineBreak, '\n', [rfReplaceAll]);
      end
      else if Strategy = 'css' then
        OutputStr := TNetEncoding.URL.Encode(InputStr)
      else if Strategy = 'url' then
        OutputStr := TNetEncoding.URL.Encode(InputStr)
      else if Strategy = 'html_attr' then
      begin
        OutputStr := StringReplace(InputStr, '&', '&amp;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '"', '&quot;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '''', '&#x27;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '<', '&lt;', [rfReplaceAll]);
        OutputStr := StringReplace(OutputStr, '>', '&gt;', [rfReplaceAll]);
      end
      else
        OutputStr := InputStr;

      Result := TValue.From<String>(OutputStr);
    end);

  FFilters.Add('e', FFilters['escape']);

  FFilters.Add('filter',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: generic filter not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('find',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  var
    Fmt: String;
    SB: TStringBuilder;
    ArgIndex: Integer;
    I: Integer;
    ArgValues: TArray<String>;
  begin
    Fmt := Input.ToString;
    SB := TStringBuilder.Create;
    try
      // Resolve all arguments via context, handling variables and literals
      SetLength(ArgValues, Length(Args));
      for I := 0 to High(Args) do
      begin
        ArgValues[I] := GetExpressionValue(Args[I], Context).ToString;
        // Remove quotes from string literals if present
        if ((ArgValues[I].StartsWith('"') and ArgValues[I].EndsWith('"')) or
            (ArgValues[I].StartsWith('''') and ArgValues[I].EndsWith(''''))) and (Length(ArgValues[I]) >= 2) then
          ArgValues[I] := Copy(ArgValues[I], 2, Length(ArgValues[I]) - 2);
      end;

      ArgIndex := 0;
      I := 1;
      while I <= Length(Fmt) do
      begin
        if Fmt[I] <> '%' then
        begin
          SB.Append(Fmt[I]);
          Inc(I);
          Continue;
        end;
        Inc(I);
        if (I <= Length(Fmt)) and (Fmt[I] = '%') then
        begin
          SB.Append('%');
          Inc(I);
          Continue;
        end;
        // Parse argnum tentatively
        var StartI := I;
        var ArgNumStr := '';
        while (I <= Length(Fmt)) and CharInSet(Fmt[I], ['0'..'9']) do
        begin
          ArgNumStr := ArgNumStr + Fmt[I];
          Inc(I);
        end;
        var ArgNum := ArgIndex;
        if (ArgNumStr <> '') and (I <= Length(Fmt)) and (Fmt[I] = '$') then
        begin
          ArgNum := StrToIntDef(ArgNumStr, ArgIndex + 1) - 1;
          Inc(I);
        end
        else
        begin
          // Not argnum, rewind I
          I := StartI;
          ArgNum := ArgIndex;
        end;
        // Flags
        var FlagLeftJustify := False;
        var FlagSign := False;
        var FlagSpace := False;
        var FlagZeroPad := False;
        var PadChar := ' ';
        while (I <= Length(Fmt)) and CharInSet(Fmt[I], ['-', '+', ' ', '0', '''']) do
        begin
          case Fmt[I] of
            '-': FlagLeftJustify := True;
            '+': FlagSign := True;
            ' ': FlagSpace := True;
            '0': FlagZeroPad := True;
            '''':
              begin
                Inc(I);
                if I <= Length(Fmt) then PadChar := Fmt[I];
              end;
          end;
          Inc(I);
        end;
        if (I > 1) and (Fmt[I-1] = '''') then Dec(I); // Adjust if ' was last
        // Width
        var WidthStr := '';
        var WidthFromArg := False;
        while (I <= Length(Fmt)) and CharInSet(Fmt[I], ['0'..'9']) do
        begin
          WidthStr := WidthStr + Fmt[I];
          Inc(I);
        end;
        var Width := StrToIntDef(WidthStr, 0);
        if (I <= Length(Fmt)) and (Fmt[I] = '*') then
        begin
          Inc(I);
          if ArgIndex <= High(ArgValues) then
          begin
            Width := StrToIntDef(ArgValues[ArgIndex], 0);
            Inc(ArgIndex);
            WidthFromArg := True;
          end;
        end;
        // Precision
        var Precision := -1;
        if (I <= Length(Fmt)) and (Fmt[I] = '.') then
        begin
          Inc(I);
          var PrecStr := '';
          while (I <= Length(Fmt)) and CharInSet(Fmt[I], ['0'..'9']) do
          begin
            PrecStr := PrecStr + Fmt[I];
            Inc(I);
          end;
          if PrecStr = '' then Precision := 0 else Precision := StrToIntDef(PrecStr, 0);
          if (I <= Length(Fmt)) and (Fmt[I] = '*') then
          begin
            Inc(I);
            if ArgIndex <= High(ArgValues) then
            begin
              Precision := StrToIntDef(ArgValues[ArgIndex], 0);
              Inc(ArgIndex);
            end;
          end;
        end;
        // Specifier
        if I > Length(Fmt) then
          raise Exception.Create('Incomplete format specifier');
        var Spec := Fmt[I];
        Inc(I);
        // Get arg
        if ArgNum > High(ArgValues) then
          raise Exception.Create('Too few arguments');
        var Arg := ArgValues[ArgNum];
        var StrVal: String;
        var NumVal: Double;
        var IntVal: Int64;
        var UIntVal: UInt64;
        case Spec of
          'b':
            begin
              UIntVal := StrToUInt64Def(Arg, 0);
              StrVal := '';
              if UIntVal = 0 then StrVal := '0';
              while UIntVal > 0 do
              begin
                StrVal := Char((UIntVal and 1) + Ord('0')) + StrVal;
                UIntVal := UIntVal shr 1;
              end;
            end;
          'c':
            begin
              IntVal := StrToIntDef(Arg, 0);
              StrVal := Char(IntVal);
              Width := 0; // Ignore width and padding for c
            end;
          'd':
            begin
              IntVal := StrToInt64Def(Arg, 0);
              StrVal := IntToStr(Abs(IntVal));
            end;
          'e', 'E':
            begin
              NumVal := StrToFloatDef(Arg, 0);
              if Precision = -1 then Precision := 6;
              StrVal := LowerCase(FloatToStrF(Abs(NumVal), ffExponent, Precision + 1, 0));
              if Spec = 'E' then StrVal := UpperCase(StrVal);
            end;
          'f', 'F':
            begin
              NumVal := StrToFloatDef(Arg, 0);
              if Precision = -1 then Precision := 6;
              StrVal := FloatToStrF(Abs(NumVal), ffFixed, 15, Precision);
              if Spec = 'F' then StrVal := UpperCase(StrVal);
            end;
          'g', 'G':
            begin
              NumVal := StrToFloatDef(Arg, 0);
              if Precision = -1 then Precision := 6;
              if Precision = 0 then Precision := 1;
              StrVal := FloatToStrF(Abs(NumVal), ffGeneral, Precision, 0);
              if Spec = 'G' then StrVal := UpperCase(StrVal);
            end;
          'h', 'H':
            begin
              NumVal := StrToFloatDef(Arg, 0);
              if Precision = -1 then Precision := 6;
              StrVal := FloatToStrF(Abs(NumVal), ffGeneral, Precision, 0);
              if Spec = 'H' then StrVal := UpperCase(StrVal);
            end;
          'o':
            begin
              UIntVal := StrToUInt64Def(Arg, 0);
              StrVal := '';
              if UIntVal = 0 then StrVal := '0';
              while UIntVal > 0 do
              begin
                StrVal := Char((UIntVal and 7) + Ord('0')) + StrVal;
                UIntVal := UIntVal shr 3;
              end;
            end;
          's':
            begin
              if WidthFromArg then
              begin
                // If width was from *, use the next argument for the string
                if ArgIndex > High(ArgValues) then
                  raise Exception.Create('Too few arguments for * specifier');
                StrVal := ArgValues[ArgIndex];
                Inc(ArgIndex);
              end
              else
                StrVal := Arg;
              if Precision >= 0 then
                StrVal := Copy(StrVal, 1, Precision);
              // Apply width padding
              var PadLen := Width - Length(StrVal);
              if PadLen > 0 then
              begin
                var PadStr := StringOfChar(PadChar, PadLen);
                if FlagLeftJustify then
                  StrVal := StrVal + PadStr
                else
                  StrVal := PadStr + StrVal;
              end;
            end;
          'u':
            begin
              UIntVal := StrToUInt64Def(Arg, 0);
              StrVal := UIntToStr(UIntVal);
            end;
          'x', 'X':
            begin
              UIntVal := StrToUInt64Def(Arg, 0);
              StrVal := IntToHex(UIntVal, 0);
              if Spec = 'x' then StrVal := LowerCase(StrVal);
            end;
          else
            StrVal := Arg; // Default to string representation
        end;
        // Apply sign for numeric
        var IsNumeric := Spec in ['d', 'e', 'E', 'f', 'F', 'g', 'G', 'h', 'H'];
        var IsPositive := (Spec = 'd') and (IntVal >= 0) or (Spec <> 'd') and (NumVal >= 0);
        var Sign := '';
        if IsNumeric then
        begin
          if IsPositive then
          begin
            if FlagSign then
              Sign := '+'
            else if FlagSpace then
              Sign := ' ';
          end
          else
          begin
            Sign := '-';
          end;
          // Apply padding
          var Pad := PadChar;
          if FlagZeroPad and not FlagLeftJustify and (Precision = -1) then
            Pad := '0';
          // Calculate pad length
          var PadLen := Width - Length(StrVal) - Length(Sign);
          if PadLen < 0 then PadLen := 0;
          var PadStr := StringOfChar(Pad, PadLen);
          // Assemble
          if FlagLeftJustify then
            StrVal := Sign + StrVal + PadStr
          else if Pad = '0' then
            StrVal := Sign + PadStr + StrVal
          else
            StrVal := PadStr + Sign + StrVal;
        end;
        SB.Append(StrVal);
        if (ArgNum = ArgIndex) and not WidthFromArg then Inc(ArgIndex);
      end;
      Result := SB.ToString;
    finally
      SB.Free;
    end;
  end);

  FFilters.Add('format_currency',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      Result := FFilters['date'](Input, Args, Context);
    end);

  FFilters.Add('format_datetime',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      FormatStr: String;
    begin
      if Length(Args) = 0 then
        FormatStr := 'yyyy-MM-dd HH:mm:ss'
      else
        FormatStr := Args[0];
      Result := FFilters['date'](Input, [FormatStr], Context);
    end);

  FFilters.Add('format_number',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      Result := FFilters['date'](Input, ['hh:nn:ss'], Context);
    end);

  FFilters.Add('join',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      Arr: TArray<TValue>;
      SB: TStringBuilder;
      I: Integer;
      Delimiter: String;
    begin
      if Length(Args) > 0 then
      begin
        Delimiter := Args[0];
        if Delimiter.StartsWith('''') or Delimiter.StartsWith('"') then
          Delimiter := Copy(Delimiter, 2, Length(Delimiter) - 2); // Remove quotes
      end
      else
        Delimiter := '';

      if Input.IsType<TArray<TValue>> then
      begin
        Arr := Input.AsType<TArray<TValue>>;
        SB := TStringBuilder.Create;
        try
          for I := 0 to High(Arr) do
          begin
            if I > 0 then
              SB.Append(Delimiter);
            SB.Append(Arr[I].ToString);
          end;
          Result := SB.ToString;
        finally
          SB.Free;
        end;
      end
      else if Input.IsType<TJSONArray> then
      begin
        SB := TStringBuilder.Create;
        try
          for I := 0 to Input.AsType<TJSONArray>.Count - 1 do
          begin
            if I > 0 then
              SB.Append(Delimiter);
            SB.Append(Input.AsType<TJSONArray>.Items[I]);
          end;
          Result := SB.ToString;
        finally
          SB.Free;
        end;
      end
      else
        Result := Input.ToString;
    end);

  FFilters.Add('json_encode',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      JsonValue: TJSONValue;
    begin
      if Input.IsObject and (Input.AsObject is TJSONValue) then
        Result := TJSONValue(Input.AsObject).ToString
      else if Input.Kind in [tkString, tkUString] then
      begin
        JsonValue := TJSONObject.ParseJSONValue(Input.AsString) as TJSONObject;
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

  FFilters.Add('json_decode',
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  var
    JSONValue: TJSONValue;
  begin
    if not (Input.Kind in [tkString, tkUString]) then
      Exit(Input);

    JSONValue := TJSONObject.ParseJSONValue(Input.AsString);
    if JSONValue = nil then
      Exit(TValue.Empty);

    try
      Result := Self.ConvertJSONToTValue(JSONValue);
    finally
      JSONValue.Free;
    end;
  end);

  FFilters.Add('keys',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      Dict: TDictionary<String, TValue>;
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
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  begin
    // Stub: language name lookup not implemented
    Result := Input.ToString;
  end);

  FFilters.Add('last',
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: locale name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('lower',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := LowerCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('map',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      ArrowExpr, VarName, Expr: String;
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      Dict: TDictionary<String, TValue>;
      ResultArr: TList<TValue>;
      LocalContext: TDictionary<String, TValue>;
      I: Integer;
      Pair: TPair<String, TValue>;
      PosArrow: Integer;
    begin
      if Length(Args) = 0 then
        Exit(Input.ToString);
      ArrowExpr := Trim(Args[0]);
      // Parse arrow function: e.g., "task => task.end_date"
      PosArrow := Pos('=>', ArrowExpr);
      if PosArrow <= 0 then
        raise Exception.Create('Invalid map filter argument: expected arrow function, got ' + ArrowExpr);
      VarName := Trim(Copy(ArrowExpr, 1, PosArrow - 1));
      Expr := Trim(Copy(ArrowExpr, PosArrow + 2, MaxInt));
      if (VarName = '') or (Expr = '') then
        raise Exception.Create('Invalid map filter argument: empty variable or expression in ' + ArrowExpr);

      ResultArr := TList<TValue>.Create;
      try
        // Handle input types
        if Input.IsArray then
        begin
          Arr := Input.AsType<TArray<TValue>>;
          for I := 0 to High(Arr) do
          begin
            LocalContext := TDictionary<String, TValue>.Create;
            try
              // Copy parent context
              for Pair in Context do
                LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
              // Set loop variable
              LocalContext.AddOrSetValue(VarName, Arr[I]);
              // Evaluate expression
              ResultArr.Add(EvaluateExpression(Expr, LocalContext));
            finally
              LocalContext.Free;
            end;
          end;
        end
        else if Input.IsObject and (Input.AsObject is TJSONArray) then
        begin
          JSONArray := TJSONArray(Input.AsObject);
          for I := 0 to JSONArray.Count - 1 do
          begin
            LocalContext := TDictionary<String, TValue>.Create;
            try
              for Pair in Context do
                LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
              // Convert JSON value to TValue
              var JSONVal := JSONArray.Items[I];
              var Val: TValue;
              if JSONVal is TJSONString then
                Val := TValue.From<String>(TJSONString(JSONVal).Value)
              else if JSONVal is TJSONNumber then
              begin
                var numStr := JSONVal.Value;
                if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                  Val := TValue.From<Double>(TJSONNumber(JSONVal).AsDouble)
                else
                  Val := TValue.From<Int64>(TJSONNumber(JSONVal).AsInt64);
              end
              else if JSONVal is TJSONBool then
                Val := TValue.From<Boolean>(TJSONBool(JSONVal).AsBoolean)
              else if JSONVal is TJSONNull then
                Val := TValue.Empty
              else if JSONVal is TJSONObject then
              begin
                var SubDict := TDictionary<String, TValue>.Create;
                try
                  for var JPair in TJSONObject(JSONVal) do
                  begin
                    var SubVal: TValue;
                    if JPair.JsonValue is TJSONNumber then
                    begin
                      var numStr := JPair.JsonValue.Value;
                      if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                        SubVal := TValue.From<Double>(TJSONNumber(JPair.JsonValue).AsDouble)
                      else
                        SubVal := TValue.From<Int64>(TJSONNumber(JPair.JsonValue).AsInt64);
                    end
                    else if JPair.JsonValue is TJSONBool then
                      SubVal := TValue.From<Boolean>(TJSONBool(JPair.JsonValue).AsBoolean)
                    else if JPair.JsonValue is TJSONString then
                      SubVal := TValue.From<String>(TJSONString(JPair.JsonValue).Value)
                    else if JPair.JsonValue is TJSONNull then
                      SubVal := TValue.Empty
                    else
                      SubVal := TValue.From<String>(JPair.JsonValue.ToString);
                    SubDict.AddOrSetValue(JPair.JsonString.Value, SubVal);
                  end;
                  Val := TValue.From<TDictionary<String, TValue>>(SubDict);
                except
                  SubDict.Free;
                  raise;
                end;
              end
              else
                Val := TValue.From<String>(JSONVal.ToString);
              LocalContext.AddOrSetValue(VarName, Val);
              ResultArr.Add(EvaluateExpression(Expr, LocalContext));
            finally
              LocalContext.Free;
            end;
          end;
        end
        else if Input.IsObject and (Input.AsObject is TDictionary<String, TValue>) then
        begin
          Dict := TDictionary<String, TValue>(Input.AsObject);
          for Pair in Dict do
          begin
            LocalContext := TDictionary<String, TValue>.Create;
            try
              for var ParentPair in Context do
                LocalContext.AddOrSetValue(ParentPair.Key, ParentPair.Value);
              LocalContext.AddOrSetValue(VarName, Pair.Value);
              ResultArr.Add(EvaluateExpression(Expr, LocalContext));
            finally
              LocalContext.Free;
            end;
          end;
        end
        else
        begin
          ResultArr.Free;
          Exit(Input.ToString); // Return input if not iterable
        end;

        // Convert result to string representation for filter chaining
        var ResultArray := ResultArr.ToArray;
        var SB := TStringBuilder.Create;
        try
          SB.Append('[');
          for I := 0 to High(ResultArray) do
          begin
            if I > 0 then
              SB.Append(',');
            if ResultArray[I].Kind in [tkString, tkUString] then
              SB.Append('"' + StringReplace(ResultArray[I].AsString, '"', '\"', [rfReplaceAll]) + '"')
            else if ResultArray[I].IsType<TDictionary<String, TValue>> then
            begin
              SB.Append('{');
              var SubDict := ResultArray[I].AsType<TDictionary<String, TValue>>;
              var Keys := SubDict.Keys.ToArray;
              for var J := 0 to High(Keys) do
              begin
                if J > 0 then
                  SB.Append(',');
                SB.Append('"' + Keys[J] + '":');
                var Val := SubDict[Keys[J]];
                if Val.Kind in [tkString, tkUString] then
                  SB.Append('"' + StringReplace(Val.AsString, '"', '\"', [rfReplaceAll]) + '"')
                else
                  SB.Append(Val.ToString);
              end;
              SB.Append('}');
            end
            else
              SB.Append(ResultArray[I].ToString);
          end;
          SB.Append(']');
          Result := SB.ToString;
        finally
          SB.Free;
        end;
      finally
        ResultArr.Free;
      end;
    end);

    FFilters.Add('min',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      Dict: TDictionary<String, TValue>;
      MinVal: TValue;
      I: Integer;
      Val, Min: Extended;
      StrVal, MinStr: String;
      IsNumeric, HasNumeric, HasString: Boolean;
      ParsedInput: TValue;
    begin
      MinVal := TValue.Empty;
      Min := MaxDouble; // Initialize to maximum possible value
      MinStr := '';
      HasNumeric := False;
      HasString := False;

      // Handle string input that looks like an array
      if (Input.Kind in [tkString, tkUString]) and Input.AsString.StartsWith('[') and Input.AsString.EndsWith(']') then
      begin
        ParsedInput := EvaluateExpression(Input.AsString, Context);
        if not ParsedInput.IsArray then
          Exit(Input.ToString); // Fallback to original input if parsing fails
      end
      else
        ParsedInput := Input;

      if ParsedInput.IsArray then
      begin
        Arr := ParsedInput.AsType<TArray<TValue>>;
        if Length(Arr) = 0 then
          Exit('');
        for I := 0 to High(Arr) do
        begin
          IsNumeric := False;
          if Arr[I].IsOrdinal then
          begin
            Val := Arr[I].AsInt64;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Arr[I].IsType<Double> then
          begin
            Val := Arr[I].AsExtended;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if (Arr[I].Kind in [tkString, tkUString]) and TryStrToFloat(Arr[I].AsString, Val) then
          begin
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Arr[I].Kind in [tkString, tkUString] then
          begin
            StrVal := Arr[I].AsString;
            if not HasNumeric then
            begin
              if (MinStr = '') or (StrVal < MinStr) then
              begin
                MinStr := StrVal;
                MinVal := Arr[I];
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val < Min) then
          begin
            Min := Val;
            MinVal := Arr[I];
          end;
        end;
      end
      else if ParsedInput.IsObject and (ParsedInput.AsObject is TJSONArray) then
      begin
        JSONArray := TJSONArray(ParsedInput.AsObject);
        if JSONArray.Count = 0 then
          Exit('');
        for I := 0 to JSONArray.Count - 1 do
        begin
          IsNumeric := False;
          var JSONVal := JSONArray.Items[I];
          if JSONVal is TJSONNumber then
          begin
            Val := TJSONNumber(JSONVal).AsDouble;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if JSONVal is TJSONString then
          begin
            StrVal := TJSONString(JSONVal).Value;
            if TryStrToFloat(StrVal, Val) then
            begin
              IsNumeric := True;
              HasNumeric := True;
            end
            else if not HasNumeric then
            begin
              if (MinStr = '') or (StrVal < MinStr) then
              begin
                MinStr := StrVal;
                MinVal := TValue.From<String>(StrVal);
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val < Min) then
          begin
            Min := Val;
            MinVal := TValue.From<Double>(Val);
          end;
        end;
      end
      else if ParsedInput.IsObject and (ParsedInput.AsObject is TDictionary<String, TValue>) then
      begin
        Dict := TDictionary<String, TValue>(ParsedInput.AsObject);
        if Dict.Count = 0 then
          Exit('');
        for var Pair in Dict do
        begin
          IsNumeric := False;
          if Pair.Value.IsOrdinal then
          begin
            Val := Pair.Value.AsInt64;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Pair.Value.IsType<Double> then
          begin
            Val := Pair.Value.AsExtended;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if (Pair.Value.Kind in [tkString, tkUString]) and TryStrToFloat(Pair.Value.AsString, Val) then
          begin
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Pair.Value.Kind in [tkString, tkUString] then
          begin
            StrVal := Pair.Value.AsString;
            if not HasNumeric then
            begin
              if (MinStr = '') or (StrVal < MinStr) then
              begin
                MinStr := StrVal;
                MinVal := Pair.Value;
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val < Min) then
          begin
            Min := Val;
            MinVal := Pair.Value;
          end;
        end;
      end
      else if ParsedInput.Kind in [tkString, tkUString] then
      begin
        var Str := ParsedInput.AsString;
        if Str = '' then
          Exit('');
        MinVal := TValue.From<String>(Str[1]);
        MinStr := Str[1];
        HasString := True;
        for I := 1 to Length(Str) do
        begin
          StrVal := Str[I];
          if StrVal < MinStr then
          begin
            MinStr := StrVal;
            MinVal := TValue.From<String>(StrVal);
          end;
        end;
      end
      else
      begin
        Exit(ParsedInput.ToString); // Non-iterable input returns as-is
      end;
      if MinVal.IsEmpty and not HasString then
        Exit('');
      Result := MinVal.ToString;
      //WriteLn('Debug: Min Filter Input=', Input.ToString, ' ParsedInput=', ParsedInput.ToString, ' Result=', Result);
    end);

  FFilters.Add('max',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      Arr: TArray<TValue>;
      JSONArray: TJSONArray;
      Dict: TDictionary<String, TValue>;
      MaxVal: TValue;
      I: Integer;
      Val, Max: Extended;
      StrVal, MaxStr: String;
      IsNumeric, HasNumeric, HasString: Boolean;
      ParsedInput: TValue;
    begin
      MaxVal := TValue.Empty;
      Max := -MaxDouble; // Initialize to minimum possible value
      MaxStr := '';
      HasNumeric := False;
      HasString := False;

      // Handle string input that looks like an array
      if (Input.Kind in [tkString, tkUString]) and Input.AsString.StartsWith('[') and Input.AsString.EndsWith(']') then
      begin
        ParsedInput := EvaluateExpression(Input.AsString, Context);
        if not ParsedInput.IsArray then
          Exit(Input.ToString); // Fallback to original input if parsing fails
      end
      else
        ParsedInput := Input;

      if ParsedInput.IsArray then
      begin
        Arr := ParsedInput.AsType<TArray<TValue>>;
        if Length(Arr) = 0 then
          Exit('');
        for I := 0 to High(Arr) do
        begin
          IsNumeric := False;
          if Arr[I].IsOrdinal then
          begin
            Val := Arr[I].AsInt64;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Arr[I].IsType<Double> then
          begin
            Val := Arr[I].AsExtended;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if (Arr[I].Kind in [tkString, tkUString]) and TryStrToFloat(Arr[I].AsString, Val) then
          begin
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Arr[I].Kind in [tkString, tkUString] then
          begin
            StrVal := Arr[I].AsString;
            if not HasNumeric then
            begin
              if (MaxStr = '') or (StrVal > MaxStr) then
              begin
                MaxStr := StrVal;
                MaxVal := Arr[I];
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val > Max) then
          begin
            Max := Val;
            MaxVal := Arr[I];
          end;
        end;
      end
      else if ParsedInput.IsObject and (ParsedInput.AsObject is TJSONArray) then
      begin
        JSONArray := TJSONArray(ParsedInput.AsObject);
        if JSONArray.Count = 0 then
          Exit('');
        for I := 0 to JSONArray.Count - 1 do
        begin
          IsNumeric := False;
          var JSONVal := JSONArray.Items[I];
          if JSONVal is TJSONNumber then
          begin
            Val := TJSONNumber(JSONVal).AsDouble;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if JSONVal is TJSONString then
          begin
            StrVal := TJSONString(JSONVal).Value;
            if TryStrToFloat(StrVal, Val) then
            begin
              IsNumeric := True;
              HasNumeric := True;
            end
            else if not HasNumeric then
            begin
              if (MaxStr = '') or (StrVal > MaxStr) then
              begin
                MaxStr := StrVal;
                MaxVal := TValue.From<String>(StrVal);
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val > Max) then
          begin
            Max := Val;
            MaxVal := TValue.From<Double>(Val);
          end;
        end;
      end
      else if ParsedInput.IsObject and (ParsedInput.AsObject is TDictionary<String, TValue>) then
      begin
        Dict := TDictionary<String, TValue>(ParsedInput.AsObject);
        if Dict.Count = 0 then
          Exit('');
        for var Pair in Dict do
        begin
          IsNumeric := False;
          if Pair.Value.IsOrdinal then
          begin
            Val := Pair.Value.AsInt64;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Pair.Value.IsType<Double> then
          begin
            Val := Pair.Value.AsExtended;
            IsNumeric := True;
            HasNumeric := True;
          end
          else if (Pair.Value.Kind in [tkString, tkUString]) and TryStrToFloat(Pair.Value.AsString, Val) then
          begin
            IsNumeric := True;
            HasNumeric := True;
          end
          else if Pair.Value.Kind in [tkString, tkUString] then
          begin
            StrVal := Pair.Value.AsString;
            if not HasNumeric then
            begin
              if (MaxStr = '') or (StrVal > MaxStr) then
              begin
                MaxStr := StrVal;
                MaxVal := Pair.Value;
              end;
              HasString := True;
            end;
          end;
          if IsNumeric and (Val > Max) then
          begin
            Max := Val;
            MaxVal := Pair.Value;
          end;
        end;
      end
      else if ParsedInput.Kind in [tkString, tkUString] then
      begin
        var Str := ParsedInput.AsString;
        if Str = '' then
          Exit('');
        MaxVal := TValue.From<String>(Str[1]);
        MaxStr := Str[1];
        HasString := True;
        for I := 1 to Length(Str) do
        begin
          StrVal := Str[I];
          if StrVal > MaxStr then
          begin
            MaxStr := StrVal;
            MaxVal := TValue.From<String>(StrVal);
          end;
        end;
      end
      else
      begin
        Exit(ParsedInput.ToString); // Non-iterable input returns as-is
      end;
      if MaxVal.IsEmpty and not HasString then
        Exit('');
      Result := MaxVal.ToString;
      //WriteLn('Debug: Max Filter Input=', Input.ToString, ' ParsedInput=', ParsedInput.ToString, ' Result=', Result);
    end);


    FFilters.Add('merge',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      MergeWith, TempVal: TValue;
      Arr1, Arr2, MergedArr: TArray<TValue>;
      Dict1, Dict2, MergedDict: TDictionary<String, TValue>;
      JA1, JA2: TJSONArray;
      JO1, JO2: TJSONObject;
      I: Integer;
    begin
      if Length(Args) < 1 then
        Exit(Input);

      MergeWith := EvaluateExpression(Args[0], Context);

      // Handle arrays including TJSONArray
      if Input.IsType<TArray<TValue>> or (Input.IsObject and (Input.AsObject is TJSONArray)) then
      begin
        if Input.IsType<TArray<TValue>> then
          Arr1 := Input.AsType<TArray<TValue>>
        else
        begin
          JA1 := TJSONArray(Input.AsObject);
          SetLength(Arr1, JA1.Count);
          for I := 0 to JA1.Count - 1 do
            Arr1[I] := TValue.FromVariant(JA1.Items[I].Value);
        end;

        if MergeWith.IsType<TArray<TValue>> then
          Arr2 := MergeWith.AsType<TArray<TValue>>
        else if MergeWith.IsObject and (MergeWith.AsObject is TJSONArray) then
        begin
          JA2 := TJSONArray(MergeWith.AsObject);
          SetLength(Arr2, JA2.Count);
          for I := 0 to JA2.Count - 1 do
            Arr2[I] := TValue.FromVariant(JA2.Items[I].Value);
        end
        else
          Exit(Input); // Invalid merge argument, return input unchanged

        SetLength(MergedArr, Length(Arr1) + Length(Arr2));
        for I := 0 to High(Arr1) do
          MergedArr[I] := Arr1[I];
        for I := 0 to High(Arr2) do
          MergedArr[Length(Arr1) + I] := Arr2[I];
        Result := TValue.From<TArray<TValue>>(MergedArr);
        Exit;
      end;

      // Handle dictionaries including TJSONObject
      if Input.IsType<TDictionary<String, TValue>> or (Input.IsObject and (Input.AsObject is TJSONObject)) then
      begin
        if Input.IsType<TDictionary<String, TValue>> then
          Dict1 := Input.AsType<TDictionary<String, TValue>>
        else
        begin
          JO1 := TJSONObject(Input.AsObject);
          Dict1 := TDictionary<String, TValue>.Create;
          try
            for var Pair in JO1 do
            begin
              if Pair.JsonValue is TJSONNumber then
                TempVal := TValue.From<Double>((Pair.JsonValue as TJSONNumber).AsDouble)
              else if Pair.JsonValue is TJSONBool then
                TempVal := TValue.From<Boolean>((Pair.JsonValue as TJSONBool).AsBoolean)
              else if Pair.JsonValue is TJSONString then
                TempVal := TValue.From<String>(Pair.JsonValue.Value)
              else
                TempVal := TValue.From<String>(Pair.JsonValue.ToString);
              Dict1.Add(Pair.JsonString.Value, TempVal);
            end;
          except
            Dict1.Free;
            raise;
          end;
        end;

        if MergeWith.IsType<TDictionary<String, TValue>> then
          Dict2 := MergeWith.AsType<TDictionary<String, TValue>>
        else if MergeWith.IsObject and (MergeWith.AsObject is TJSONObject) then
        begin
          JO2 := TJSONObject(MergeWith.AsObject);
          Dict2 := TDictionary<String, TValue>.Create;
          try
            for var Pair in JO2 do
            begin
              if Pair.JsonValue is TJSONNumber then
                TempVal := TValue.From<Double>((Pair.JsonValue as TJSONNumber).AsDouble)
              else if Pair.JsonValue is TJSONBool then
                TempVal := TValue.From<Boolean>((Pair.JsonValue as TJSONBool).AsBoolean)
              else if Pair.JsonValue is TJSONString then
                TempVal := TValue.From<String>(Pair.JsonValue.Value)
              else
                TempVal := TValue.From<String>(Pair.JsonValue.ToString);
              Dict2.Add(Pair.JsonString.Value, TempVal);
            end;
          except
            Dict2.Free;
            raise;
          end;
        end
        else
        begin
          if Input.IsType<TDictionary<String, TValue>> then
            Result := TValue.From<TDictionary<String, TValue>>(Dict1)
          else
            Dict1.Free;
          Exit;
        end;

        MergedDict := TDictionary<String, TValue>.Create;
        try
          for var Pair in Dict1 do
            MergedDict.Add(Pair.Key, Pair.Value);
          for var Pair in Dict2 do
            MergedDict.AddOrSetValue(Pair.Key, Pair.Value);
          Result := TValue.From<TDictionary<String, TValue>>(MergedDict);
        finally
          if Input.IsType<TDictionary<String, TValue>> then
            Dict1.Free;
          if MergeWith.IsType<TDictionary<String, TValue>> then
            Dict2.Free;
        end;
        Exit;
      end;

      Result := Input;
    end);

  FFilters.Add('nl2br',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, sLineBreak, '<br>', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);



  FFilters.Add('number_format',
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  var
    Val: Extended;
    Decimals: Integer;
    DecimalSep, ThousandSep: String;
    CustomFS: TFormatSettings;
    FormatStr: String;
    InvariantFS: TFormatSettings;
    Sign: String;
    AbsVal: Extended;
    FormattedAbs: String;
  begin
    InvariantFS := TFormatSettings.Invariant;

    Decimals := 0;
    DecimalSep := '.';
    ThousandSep := ',';

    if Length(Args) > 0 then
      Decimals := StrToIntDef(Args[0], 0);
    if Length(Args) > 1 then
      DecimalSep := Args[1];
    if Length(Args) > 2 then
      ThousandSep := Args[2];

    // Safe conversion (handles string input from variables)
    if Input.IsOrdinal then
      Val := Input.AsInt64
    else if Input.IsType<Extended> or Input.IsType<Double> or Input.IsType<Single> then
      Val := Input.AsExtended
    else if (Input.Kind in [tkString, tkUString]) then
    begin
      if not TryStrToFloat(Input.AsString, Val, InvariantFS) then
        Exit(TValue.From<String>(Input.AsString));
    end
    else
      Exit(TValue.From<String>(Input.ToString));

    // Separate sign for correct thousands grouping on negatives
    if Val < 0 then
    begin
      Sign := '-';
      AbsVal := -Val;
    end
    else
    begin
      Sign := '';
      AbsVal := Val;
    end;

    // Custom settings
    CustomFS := TFormatSettings.Create('');
    if DecimalSep <> '' then
      CustomFS.DecimalSeparator := DecimalSep[1]
    else
      CustomFS.DecimalSeparator := '.';  // will strip decimal if empty later
    if ThousandSep <> '' then
      CustomFS.ThousandSeparator := ThousandSep[1]
    else
      CustomFS.ThousandSeparator := #0;

    // Build format
    if Decimals = 0 then
    begin
      if (ThousandSep = '') then
      begin
        FormatStr := '0';
      end
        else
      begin
        FormatStr := '#,0';
      end;
    end
      else
    begin
      if (ThousandSep = '') then
      begin
        FormatStr := '0.';
      end
        else
      begin
        FormatStr := '#,0.'+ StringOfChar('0', Decimals);
      end;
    end;
    FormattedAbs := FormatFloat(FormatStr, AbsVal, CustomFS);

    // If no decimal point requested, remove decimal part
    if (DecimalSep = '') and (Decimals > 0) and (Pos(CustomFS.DecimalSeparator, FormattedAbs) > 0) then
      FormattedAbs := Copy(FormattedAbs, 1, Pos(CustomFS.DecimalSeparator, FormattedAbs) - 1);

    Result := TValue.From<String>(Sign + FormattedAbs);
  end);

  FFilters.Add('round',
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
  var
    Val: Extended;
    Decimals: Integer;
    Method: String;
    Multiplier, Rounded: Extended;
    InvariantFS: TFormatSettings;
    Formatted: String;
  begin
    InvariantFS := TFormatSettings.Invariant;

    Decimals := 0;
    Method := 'common';

    if Length(Args) > 0 then
      Decimals := StrToIntDef(Args[0], 0);
    if Length(Args) > 1 then
      Method := LowerCase(Trim(Args[1]));

    // Safe conversion to Extended
    if Input.IsOrdinal then
      Val := Input.AsInt64
    else if Input.IsType<Extended> or Input.IsType<Double> or Input.IsType<Single> then
      Val := Input.AsExtended
    else if (Input.Kind in [tkString, tkUString, tkLString, tkWString]) then
    begin
      if not TryStrToFloat(Input.AsString, Val, InvariantFS) then
        Exit(TValue.From<String>(Input.AsString));
    end
    else
      Exit(TValue.From<String>(Input.ToString));

    // Perform rounding
    if Decimals = 0 then
    begin
      if Method = 'floor' then
        Rounded := Floor(Val)
      else if Method = 'ceil' then
        Rounded := Ceil(Val)
      else // common
        Rounded := Round(Val);  // Delphi Round is half away from zero, matching Twig 'common'
    end
    else
    begin
      Multiplier := Power(10.0, Decimals);
      if Method = 'floor' then
        Rounded := Floor(Val * Multiplier) / Multiplier
      else if Method = 'ceil' then
        Rounded := Ceil(Val * Multiplier) / Multiplier
      else // common
        Rounded := Round(Val * Multiplier) / Multiplier;  // half away from zero
    end;

    // Format output with invariant locale to use '.' decimal
    // Always show fixed decimals if precision > 0, no trailing zeros trim (matches test expectations like 5.00)
    if Decimals <= 0 then
    begin
      // For integer result, output as integer string (no .00)
      Formatted := IntToStr(Trunc(Rounded));
    end
    else
    begin
      Formatted := FloatToStrF(Rounded, ffFixed, 15, Decimals, InvariantFS);
    end;

    Result := TValue.From<String>(Formatted);
  end);


  FFilters.Add('plural',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: pluralization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('raw',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      Result := Input.ToString; // No escaping
    end);

  FFilters.Add('reduce',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: reduce not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('replace',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Length(Args) < 2 then
        Result := Input.ToString
      else if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, Args[0], Args[1], [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('reverse',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    var
      I: Integer;
      OutputStr: String;

    begin
      OutputStr := '';
      if Input.Kind in [tkString, tkUString] then
      begin
        for I := Length(Input.AsString) downto 1 do
          OutputStr := OutputStr + Input.AsString[I];
      end
      else if Input.IsArray then
      begin
        var Arr := Input.AsType<TArray<TValue>>;
        OutputStr := '[';
        for I := High(Arr) downto 0 do
        begin
          if I < High(Arr) then
            OutputStr := OutputStr + ',';
          OutputStr := OutputStr + Arr[I].ToString;
        end;
        OutputStr := OutputStr + ']';
      end
       else
      if Input.IsObject and (Input.AsObject is TJSONArray) then
      begin
        var JSONArray := TJSONArray(Input.AsObject);
        OutputStr := '[';
        for I := JSONArray.Count - 1 downto 0 do
        begin
          if I < JSONArray.Count - 1 then
            OutputStr := OutputStr + ',';
          OutputStr := OutputStr + JSONArray.Items[I].ToString;
        end;
        OutputStr := OutputStr + ']';
      end
       else
        OutputStr := Input.ToString;

      Result := TValue.From<String>(OutputStr);
    end);

  

  FFilters.Add('shuffle',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: shuffle not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('singular',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: singularization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('slice',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: sorting not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('spaceless',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, ' ', '', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('split',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Stub: timezone name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('title',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := Trim(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('u',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      // Twig u filter is Unicode string conversion
      Result := Input.ToString;
    end);

  FFilters.Add('upper',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := UpperCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('url_encode',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): TValue
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := TNetEncoding.URL.Encode(Input.AsString)
      else
        Result := Input.ToString;
    end);
end;

procedure TTina4Twig.RegisterDefaultFunctions;
begin
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

  FFunctions.Add('date',
  function(const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
  var
    Input: TValue;
    DateTimeValue: TDateTime;
    FormatStr: String;
  begin
    if Length(Args) = 0 then
     Input := Now()
      else
    Input := ResolveVariablePath(Args[0], Context);

    if Length(Args) > 1 then
      FormatStr := Args[1]
    else
      FormatStr := FDateFormat; // Default format as per Twig

    if Input.IsType<Int64> then
      DateTimeValue := UnixToDateTime(Input.AsInt64)
    else if Input.Kind in [tkString, tkUString] then
    begin
      try
        DateTimeValue := StrToDateTime(Input.AsString);
      except
        DateTimeValue := Now; // Fallback to current date/time on parse failure
      end;
    end
    else if Input.IsType<TDateTime> then
      DateTimeValue := Input.AsType<TDateTime>
    else
      DateTimeValue := Now; // Fallback for unsupported types

    Result := FormatDateTime(FormatStr, DateTimeValue);
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
var
  LocalContext: TDictionary<String, TValue>;
begin
  LocalContext := TDictionary<String, TValue>.Create;
  try
    for var Pair in FContext do
      LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
    if Assigned(Variables) then
      for var Pair in Variables do
        LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
    Result := RenderInternal(TemplateOrContent, LocalContext);
  finally
    LocalContext.Free;
  end;
end;


/// <summary>
/// Processes the template sequentially, handling tags in order.
/// </summary>
/// <param name="Template">The template string to process.</param>
/// <param name="LocalContext">The context dictionary.</param>
/// <param name="Result">The rendered output.</param>
/// <remarks>
/// Handles set, if/elseif/else, for, include, with, macro blocks sequentially.
/// Updates context for sets and evaluates variables at the time of encounter.
/// Processes macro definitions and calls.
/// Supports 'only' option in with blocks and nested structures.
/// Handles TJSONArray for JSON array iteration in for loops.
/// Recurses for nested structures.
/// Supports array appending with set var[] = value syntax, with type conversion for integers.
/// Supports dictionary merging for set assignments, handling outputs from merge filter.
/// Fixed context persistence for scalar variables in for loops to ensure updates persist across iterations.
/// Updated to suppress output of complex types in {{ }} tags, aligning with Twig behavior.
/// </remarks>
procedure TTina4Twig.ProcessTemplate(const Template: String; var LocalContext: TDictionary<String, TValue>; var Result: String);
type
  TBranch = record
    Condition: String;
    Body: String;
  end;
var
  SB: TStringBuilder;
  CurrentPos, EndPos, TagStart: Integer;
  Tag, Current: String;
  IfDepth, ForDepth, WithDepth, MacroDepth: Integer;
  BodyStart: Integer;
  Body: String;
  ForTag: String;
  LoopVar, LoopExpr, LoopCondition: String;
  ForParts: TArray<String>;
  Iterable: TValue;
  Arr: TArray<TValue>;
  Item: TValue;
  LoopContext: TDictionary<String, TValue>;
  HasElse: Boolean;
  ElsePos: Integer;
  IncludeExpr, IncludeName, IncludeText: String;
  WithTag, WithExpr: String;
  WithDict: TDictionary<String, TValue>;
  MacroTag, MacroName: String;
  MacroParams: TArray<String>;
  MacroDefaults: TDictionary<String, String>;
  ParamParts: TArray<String>;
  UseOnly: Boolean;
begin
  try
    SB := TStringBuilder.Create;
    try
      CurrentPos := 1;
      while CurrentPos <= Length(Template) do
      begin
        EndPos := CurrentPos;
        while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] in ['{', '%'])) do
          Inc(EndPos);
        if EndPos > CurrentPos then
          SB.Append(Copy(Template, CurrentPos, EndPos - CurrentPos));
        if EndPos > Length(Template) then
          Break;

        if Template[EndPos + 1] = '{' then // {{ }}
        begin
          CurrentPos := EndPos + 2;
          EndPos := CurrentPos;
          while (EndPos <= Length(Template)) and not ((Template[EndPos] = '}') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
            Inc(EndPos);
          if EndPos > Length(Template) then
            raise Exception.Create('Unclosed {{');
          Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
          // Check if this is a macro call
          var OpenParen := System.Pos('(', Tag);
          if (OpenParen > 0) and Tag.EndsWith(')') and FMacros.ContainsKey(Tag.Substring(0, OpenParen - 1)) then
          begin
            MacroName := Tag.Substring(0, OpenParen - 1);
            var ArgsStr := Trim(Copy(Tag, OpenParen + 1, Length(Tag) - OpenParen - 1));
            var Args: TArray<String>;
            if ArgsStr <> '' then
              Args := SplitOnTopLevel(ArgsStr, ',')
            else
              SetLength(Args, 0);
            for var I := 0 to High(Args) do
              Args[I] := Trim(EvaluateExpression(Trim(Args[I]), LocalContext).ToString);
            var MacroFunc := FMacros[MacroName];
            Current := MacroFunc(MacroName, Args, LocalContext);
            SB.Append(Current);
          end
          else
          begin
            var ExprVal := EvaluateExpression(Tag, LocalContext);
            if ExprVal.IsEmpty then
              Current := ''
            else if ExprVal.IsType<TArray<TValue>> then
            begin
              Arr := ExprVal.AsType<TArray<TValue>>;
              var ArrStr: TArray<String>;
              SetLength(ArrStr, Length(Arr));
              for var I := 0 to High(Arr) do
                ArrStr[I] := Arr[I].ToString;
              Current := String.Join('', ArrStr);
              //if FDebug then WriteLn('Debug: Array output for ', Tag, ' = ', Current);
            end
            else if ExprVal.Kind in [tkClass, tkRecord] then
              Current := ''
            else
              Current := ExprVal.ToString;
            SB.Append(Current);
          end;
          CurrentPos := EndPos + 2;
        end
        else if Template[EndPos + 1] = '%' then // {% %}
        begin
          CurrentPos := EndPos + 2;
          EndPos := CurrentPos;
          while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
            Inc(EndPos);
          if EndPos > Length(Template) then
            raise Exception.Create('Unclosed {%');
          Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
          CurrentPos := EndPos + 2;
          if Tag.StartsWith('set ') then
          begin
            //if FDebug then WriteLn('Debug: Set: Tag passed is = ', Tag);
            var SetStr := Trim(Copy(Tag, 4, MaxInt));
            var EqPos := FindTopLevelPos(SetStr, '=');
            if EqPos <= 0 then
              raise Exception.Create('Invalid set: ' + Tag);
            var VarName := Trim(Copy(SetStr, 1, EqPos - 1));
            var Expr := Trim(Copy(SetStr, EqPos + 1, MaxInt));
            var Val := EvaluateExpression(Expr, LocalContext);

            if VarName.EndsWith('[]') then
            begin
              VarName := Trim(Copy(VarName, 1, Length(VarName) - 2));
              if VarName.IsEmpty then
                raise Exception.Create('Invalid array variable name in set: ' + Tag);
              //if FDebug then WriteLn('Debug: VarName = ' + VarName + ' Val = ' + Val.ToString);
              // Convert string to integer if possible
              if Val.Kind in [tkString, tkUString] then
              begin
                var IntVal: Int64;
                if TryStrToInt64(Val.AsString, IntVal) then
                  Val := TValue.From<Int64>(IntVal);
              end;
              var ExistingVal: TValue;

              if LocalContext.TryGetValue(VarName, ExistingVal) then
              begin
                if ExistingVal.IsType<TArray<TValue>> then
                begin
                  Arr := ExistingVal.AsType<TArray<TValue>>;
                  //if FDebug then WriteLn('Debug: Found existing array for ', VarName, ' with length ', Length(Arr));
                end
                else if ExistingVal.IsType<TJSONArray> then
                begin
                  var JsonArr := ExistingVal.AsType<TJSONArray>;
                  SetLength(Arr, JsonArr.Count);
                  for var I := 0 to JsonArr.Count - 1 do
                    Arr[I] := TValue.FromVariant(JsonArr.Items[I].Value);
                  //if FDebug then WriteLn('Debug: Converted JSONArray to array for ', VarName, ' with length ', Length(Arr));
                end
                else
                begin
                  SetLength(Arr, 0);
                  //if FDebug then WriteLn('Debug: Initialized empty array for ', VarName, ' due to invalid type: ', ExistingVal.TypeInfo.Name);
                end;
              end
              else
              begin
                SetLength(Arr, 0);
                //if FDebug then WriteLn('Debug: Initialized empty array for ', VarName, ' as it was not found');
              end;
              SetLength(Arr, Length(Arr) + 1);
              Arr[High(Arr)] := Val;
              LocalContext.AddOrSetValue(VarName, TValue.From<TArray<TValue>>(Arr));

              (*if FDebug then
              begin
                var ArrStr: TArray<String>;
                SetLength(ArrStr, Length(Arr));
                for var I := 0 to High(Arr) do
                  ArrStr[I] := Arr[I].ToString;
                WriteLn('Debug: Set array ' + VarName + ' = [' + String.Join(',', ArrStr) + ']');
              end;*)
            end
            else if Val.IsType<TDictionary<String, TValue>> then
            begin
              var NewDict := Val.AsType<TDictionary<String, TValue>>;
              var ExistingVal: TValue;
              if LocalContext.TryGetValue(VarName, ExistingVal) and ExistingVal.IsType<TDictionary<String, TValue>> then
              begin
                var ExistingDict := ExistingVal.AsType<TDictionary<String, TValue>>;
                for var Pair in NewDict do
                  ExistingDict.AddOrSetValue(Pair.Key, Pair.Value);
                LocalContext.AddOrSetValue(VarName, TValue.From<TDictionary<String, TValue>>(ExistingDict));
                //if FDebug then WriteLn('Debug: Merged dictionary into ' + VarName + ' with ' + IntToStr(NewDict.Count) + ' entries');
              end
              else
              begin
                LocalContext.AddOrSetValue(VarName, Val);
                //if FDebug then WriteLn('Debug: Set new dictionary ' + VarName + ' with ' + IntToStr(NewDict.Count) + ' entries');
              end;
            end
            else if Val.IsObject and (Val.AsObject is TJSONArray) then
            begin
              LocalContext.AddOrSetValue(VarName, ConvertJSONToTValue(Val.AsObject as TJSONArray));
              //if FDebug then WriteLn('Debug: Set array from JSONArray ' + VarName);
            end
            else
            begin
              if Expr.Trim = '[]' then
              begin
                Val := TValue.From<TArray<TValue>>([]);
                if FDebug then
                  WriteLn('Debug: Initialized empty array for ', VarName);
              end;

              LocalContext.AddOrSetValue(VarName, Val);
              //if FDebug then WriteLn('Debug: Set ' + VarName + ' = ' + Val.ToString);
            end;
          end
          else if Tag.StartsWith('if ') then
          begin
            var Branches := TList<TBranch>.Create;
            try
              IfDepth := 1;
              var Branch: TBranch;
              Branch.Condition := Trim(Copy(Tag, 3, MaxInt));
              BodyStart := CurrentPos;
              ForDepth := 0;
              WithDepth := 0;
              MacroDepth := 0;
              while CurrentPos <= Length(Template) do
              begin
                EndPos := CurrentPos;
                while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
                  Inc(EndPos);
                if EndPos > Length(Template) then
                  raise Exception.Create('Unclosed if');
                TagStart := EndPos;
                CurrentPos := EndPos + 2;
                EndPos := CurrentPos;
                while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
                  Inc(EndPos);
                if EndPos > Length(Template) then
                  raise Exception.Create('Unclosed {% in if block');
                Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
                CurrentPos := EndPos + 2;
                if Tag.StartsWith('if ') then
                  Inc(IfDepth)
                else if Tag = 'endif' then
                begin
                  Dec(IfDepth);
                  if IfDepth = 0 then
                  begin
                    Branch.Body := Copy(Template, BodyStart, TagStart - BodyStart);
                    Branches.Add(Branch);
                    Break;
                  end;
                end
                else if Tag.StartsWith('for ') then
                  Inc(ForDepth)
                else if Tag = 'endfor' then
                  Dec(ForDepth)
                else if Tag.StartsWith('with ') or (Tag = 'with') then
                  Inc(WithDepth)
                else if Tag = 'endwith' then
                  Dec(WithDepth)
                else if Tag.StartsWith('macro ') then
                  Inc(MacroDepth)
                else if Tag = 'endmacro' then
                  Dec(MacroDepth);
                if (IfDepth = 1) and (Tag.StartsWith('elseif ') or (Tag = 'else')) and (ForDepth = 0) and (WithDepth = 0) and (MacroDepth = 0) then
                begin
                  Branch.Body := Copy(Template, BodyStart, TagStart - BodyStart);
                  Branches.Add(Branch);
                  if Tag = 'else' then
                    Branch.Condition := ''
                  else
                    Branch.Condition := Trim(Copy(Tag, 8, MaxInt));
                  BodyStart := CurrentPos;
                end;
              end;
              if IfDepth > 0 then
                raise Exception.Create('Unclosed if');
              var Done := False;
              for Branch in Branches do
              begin
                if Done then Break;
                if Branch.Condition = '' then
                begin
                  var ABody := '';
                  ProcessTemplate(Branch.Body, LocalContext, ABody);
                  SB.Append(ABody);
                  Done := True;
                end
                else
                begin
                  if ToBool(EvaluateExpression(Branch.Condition, LocalContext)) then
                  begin
                    var ABody := '';
                    ProcessTemplate(Branch.Body, LocalContext, ABody);
                    SB.Append(ABody);
                    Done := True;
                  end;
                end;
              end;
            finally
              Branches.Free;
            end;
          end
          else if Tag.StartsWith('for ') then
          begin
            ForTag := Tag;
            ForDepth := 1;
            BodyStart := CurrentPos;
            HasElse := False;
            ElsePos := 0;
            IfDepth := 0;
            WithDepth := 0;
            MacroDepth := 0;
            while CurrentPos <= Length(Template) do
            begin
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
                Inc(EndPos);
              if EndPos > Length(Template) then
                raise Exception.Create('Unclosed for');
              TagStart := EndPos;
              CurrentPos := EndPos + 2;
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
                Inc(EndPos);
              if EndPos > Length(Template) then
                raise Exception.Create('Unclosed {% in for block');
              Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
              CurrentPos := EndPos + 2;
              if Tag.StartsWith('for ') then
                Inc(ForDepth);
              if Tag = 'endfor' then
              begin
                Dec(ForDepth);
                if ForDepth = 0 then
                begin
                  ForParts := Tokenize(Copy(ForTag, 5, MaxInt));
                  if (Length(ForParts) < 3) or (ForParts[1] <> 'in') then
                    raise Exception.Create('Invalid for: ' + ForTag);
                  LoopVar := ForParts[0];
                  LoopExpr := '';
                  LoopCondition := '';
                  for var J := 2 to High(ForParts) do
                  begin
                    if ForParts[J] = 'if' then
                    begin
                      LoopExpr := String.Join(' ', Copy(ForParts, 2, J - 2));
                      LoopCondition := String.Join(' ', Copy(ForParts, J + 1, MaxInt));
                      Break;
                    end;
                  end;
                  if LoopExpr = '' then
                    LoopExpr := String.Join(' ', Copy(ForParts, 2, MaxInt));
                  Iterable := EvaluateExpression(LoopExpr, LocalContext);

                  (*if FDebug then
                  begin
                    if Iterable.IsType<TArray<TValue>> then
                    begin
                      var ArrStr: TArray<String>;
                      SetLength(ArrStr, Length(Iterable.AsType<TArray<TValue>>));
                      for var I := 0 to High(Iterable.AsType<TArray<TValue>>) do
                        ArrStr[I] := Iterable.AsType<TArray<TValue>>[I].ToString;
                      WriteLn('Debug: For loop iterable ', LoopExpr, ' = [', String.Join(',', ArrStr), ']');
                    end
                    else
                      WriteLn('Debug: For loop iterable ', LoopExpr, ' = ', Iterable.ToString);
                  end;*)

                  var HasItems := False;
                  if Iterable.IsType<TArray<TValue>> then
                  begin
                    Arr := Iterable.AsType<TArray<TValue>>;
                    if Length(Arr) > 0 then
                      HasItems := True;
                    for Item in Arr do
                    begin
                      LoopContext := TDictionary<String, TValue>.Create(LocalContext);
                      try
                        // Set the loop variable
                        LoopContext.AddOrSetValue(LoopVar, Item);
                        //if FDebug then  WriteLn('Debug: Loop var ', LoopVar, ' = ', Item.ToString, ' ==== ', LoopCondition);
                        if (LoopCondition = '') or ToBool(EvaluateExpression(LoopCondition, LoopContext)) then
                        begin
                          var ForBody: String;
                          if HasElse then
                            ForBody := Copy(Template, BodyStart, ElsePos - BodyStart - Length('{% else %}'))
                          else
                            ForBody := Copy(Template, BodyStart, TagStart - BodyStart);
                          //if FDebug then WriteLn('Debug: Loop Body ', ForBody, LoopContext.ToString);
                          var BodyResult := '';
                          ProcessTemplate(ForBody, LoopContext, BodyResult);
                          for var Pair in LoopContext do
                          begin
                            //if FDebug then WriteLn('Reading: ', Pair.Key, ' = ', Pair.Value.ToString);
                            LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
                          end;
                          if BodyResult <> '' then
                            SB.Append(BodyResult);
                          //if FDebug then WriteLn('Debug: For body result = ', BodyResult);
                        end;
                      finally
                        LoopContext.Free;
                      end;
                    end;
                  end
                  else if Iterable.IsType<TDictionary<String, TValue>> then
                  begin
                    var Dict := Iterable.AsType<TDictionary<String, TValue>>;
                    if Dict.Count > 0 then
                      HasItems := True;
                    for var Pair in Dict do
                    begin
                      LoopContext := TDictionary<String, TValue>.Create;
                      try
                        // Copy all current LocalContext values to LoopContext
                        for var Pair2 in LocalContext do
                          LoopContext.AddOrSetValue(Pair2.Key, Pair2.Value);
                        LoopContext.AddOrSetValue(LoopVar, Pair.Value);
                        //if FDebug then WriteLn('Debug: Loop var ', LoopVar, ' = ', Pair.Value.ToString);
                        if (LoopCondition = '') or ToBool(EvaluateExpression(LoopCondition, LoopContext)) then
                        begin
                          var ForBody: String;
                          if HasElse then
                            ForBody := Copy(Template, BodyStart, ElsePos - BodyStart - Length('{% else %}'))
                          else
                            ForBody := Copy(Template, BodyStart, TagStart - BodyStart);
                          var BodyResult := '';
                          ProcessTemplate(ForBody, LoopContext, BodyResult);
                          SB.Append(BodyResult);
                          //if FDebug then WriteLn('Debug: For body result = ', BodyResult);
                          // Update LocalContext with all changes from LoopContext to persist changes across iterations
                          for var Pair2 in LoopContext do
                            LocalContext.AddOrSetValue(Pair2.Key, Pair2.Value);
                        end;
                      finally
                        LoopContext.Free;
                      end;
                    end;
                  end
                  else if Iterable.IsType<TJSONArray> then
                  begin
                    var JsonArr := Iterable.AsType<TJSONArray>;
                    if JsonArr.Count > 0 then
                      HasItems := True;
                    SetLength(Arr, JsonArr.Count);
                    for var I := 0 to JsonArr.Count - 1 do
                      Arr[I] := TValue.FromVariant(JsonArr.Items[I].Value);
                    for Item in Arr do
                    begin
                      LoopContext := TDictionary<String, TValue>.Create;
                      try
                        // Copy all current LocalContext values to LoopContext
                        for var Pair in LocalContext do
                          LoopContext.AddOrSetValue(Pair.Key, Pair.Value);
                        LoopContext.AddOrSetValue(LoopVar, Item);
                        //if FDebug then WriteLn('Debug: Loop var ', LoopVar, ' = ', Item.ToString);
                        if (LoopCondition = '') or ToBool(EvaluateExpression(LoopCondition, LoopContext)) then
                        begin
                          var ForBody: String;
                          if HasElse then
                            ForBody := Copy(Template, BodyStart, ElsePos - BodyStart - Length('{% else %}'))
                          else
                            ForBody := Copy(Template, BodyStart, TagStart - BodyStart);
                          var BodyResult := '';
                          ProcessTemplate(ForBody, LoopContext, BodyResult);
                          SB.Append(BodyResult);
                          //if FDebug then WriteLn('Debug: For body result = ', BodyResult);
                          // Update LocalContext with all changes from LoopContext to persist changes across iterations
                          for var Pair in LoopContext do
                            LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
                        end;
                      finally
                        LoopContext.Free;
                      end;
                    end;
                  end;

                  if not HasItems and HasElse then
                  begin
                    Body := Copy(Template, ElsePos, TagStart - ElsePos);
                    var ElseBody := '';
                    ProcessTemplate(Body, LocalContext, ElseBody);
                    SB.Append(ElseBody);
                    //if FDebug then WriteLn('Debug: For else body result = ', ElseBody);
                  end;
                  Break;
                end;
              end;
              if Tag.StartsWith('if ') then
                Inc(IfDepth)
              else if Tag = 'endif' then
                Dec(IfDepth);
              if Tag.StartsWith('with ') or (Tag = 'with') then
                Inc(WithDepth)
              else if Tag = 'endwith' then
                Dec(WithDepth);
              if Tag.StartsWith('macro ') then
                Inc(MacroDepth)
              else if Tag = 'endmacro' then
                Dec(MacroDepth);
              if (Tag = 'else') and (ForDepth = 1) and (IfDepth = 0) and (WithDepth = 0) and (MacroDepth = 0) then
              begin
                HasElse := True;
                ElsePos := CurrentPos;
              end;
            end;
            if ForDepth > 0 then
              raise Exception.Create('Unclosed for');
          end
          else if Tag.StartsWith('with ') or (Tag = 'with') then
          begin
            WithTag := Tag;
            WithDepth := 1;
            BodyStart := CurrentPos;
            IfDepth := 0;
            ForDepth := 0;
            MacroDepth := 0;
            UseOnly := False;
            while CurrentPos <= Length(Template) do
            begin
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
                Inc(EndPos);
              if EndPos > Length(Template) then
                raise Exception.Create('Unclosed with');
              TagStart := EndPos;
              CurrentPos := EndPos + 2;
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
                Inc(EndPos);
              Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
              CurrentPos := EndPos + 2;
              if Tag.StartsWith('with ') or (Tag = 'with') then
                Inc(WithDepth);
              if Tag = 'endwith' then
              begin
                Dec(WithDepth);
                if WithDepth = 0 then
                begin
                  WithExpr := Trim(Copy(WithTag, 5, MaxInt));
                  if WithExpr.EndsWith(' only') then
                  begin
                    UseOnly := True;
                    WithExpr := Trim(Copy(WithExpr, 1, Length(WithExpr) - Length(' only')));
                  end;
                  LoopContext := TDictionary<String, TValue>.Create;
                  try
                    if not UseOnly then
                      for var Pair in LocalContext do
                        LoopContext.AddOrSetValue(Pair.Key, Pair.Value);
                    if WithExpr <> '' then
                    begin
                      WithDict := ParseVariableDict(WithExpr, LocalContext);
                      try
                        for var Pair in WithDict do
                          LoopContext.AddOrSetValue(Pair.Key, Pair.Value);
                      finally
                        WithDict.Free;
                      end;
                    end;
                    Body := Copy(Template, BodyStart, TagStart - BodyStart);
                    var BodyResult := '';
                    ProcessTemplate(Body, LoopContext, BodyResult);
                    SB.Append(BodyResult);
                    // Update LocalContext with all changes from LoopContext
                    for var Pair in LoopContext do
                      LocalContext.AddOrSetValue(Pair.Key, Pair.Value);
                  finally
                    LoopContext.Free;
                  end;
                  Break;
                end;
              end;
              if Tag.StartsWith('if ') then
                Inc(IfDepth)
              else if Tag = 'endif' then
                Dec(IfDepth);
              if Tag.StartsWith('for ') then
                Inc(ForDepth)
              else if Tag = 'endfor' then
                Dec(ForDepth);
              if Tag.StartsWith('macro ') then
                Inc(MacroDepth)
              else if Tag = 'endmacro' then
                Dec(MacroDepth);
            end;
            if WithDepth > 0 then
              raise Exception.Create('Unclosed with');
          end
          else if Tag.StartsWith('macro ') then
          begin
            MacroTag := Tag;
            MacroDepth := 1;
            BodyStart := CurrentPos;
            IfDepth := 0;
            ForDepth := 0;
            WithDepth := 0;
            while CurrentPos <= Length(Template) do
            begin
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '{') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '%')) do
                Inc(EndPos);
              if EndPos > Length(Template) then
                raise Exception.Create('Unclosed macro');
              TagStart := EndPos;
              CurrentPos := EndPos + 2;
              EndPos := CurrentPos;
              while (EndPos <= Length(Template)) and not ((Template[EndPos] = '%') and (EndPos + 1 <= Length(Template)) and (Template[EndPos + 1] = '}')) do
                Inc(EndPos);
              Tag := Trim(Copy(Template, CurrentPos, EndPos - CurrentPos));
              CurrentPos := EndPos + 2;
              if Tag.StartsWith('macro ') then
                Inc(MacroDepth);
              if Tag = 'endmacro' then
              begin
                Dec(MacroDepth);
                if MacroDepth = 0 then
                begin
                  var MacroStr := Trim(Copy(MacroTag, 6, MaxInt));
                  var OpenParen := System.Pos('(', MacroStr);
                  if OpenParen <= 0 then
                    raise Exception.Create('Invalid macro: ' + MacroTag);
                  MacroName := Trim(Copy(MacroStr, 1, OpenParen - 1));
                  var ParamStr := Trim(Copy(MacroStr, OpenParen + 1, System.Pos(')', MacroStr) - OpenParen - 1));
                  MacroParams := SplitOnTopLevel(ParamStr, ',');
                  MacroDefaults := TDictionary<String, String>.Create;
                  try
                    for var I := 0 to High(MacroParams) do
                    begin
                      ParamParts := SplitOnTopLevel(Trim(MacroParams[I]), '=');
                      if Length(ParamParts) > 1 then
                      begin
                        MacroParams[I] := Trim(ParamParts[0]);
                        MacroDefaults.Add(MacroParams[I], Trim(ParamParts[1]));
                      end
                      else
                        MacroParams[I] := Trim(MacroParams[I]);
                    end;
                    var MacroBody := Copy(Template, BodyStart, TagStart - BodyStart);
                    FMacroBodies.AddOrSetValue(MacroName, MacroBody);
                    FMacroParams.AddOrSetValue(MacroName, MacroParams);
                    FMacroDefaults.AddOrSetValue(MacroName, MacroDefaults);
                    FMacros.AddOrSetValue(MacroName,
                      function(const MName: String; const Args: TArray<String>; const MacroContext: TDictionary<String, TValue>): String
                      var
                        LocalMacroContext: TDictionary<String, TValue>;
                        I: Integer;
                      begin
                        LocalMacroContext := TDictionary<String, TValue>.Create(MacroContext);
                        try
                          for I := 0 to High(FMacroParams[MName]) do
                          begin
                            if I < Length(Args) then
                              LocalMacroContext.AddOrSetValue(FMacroParams[MName][I], TValue.From<String>(Args[I]))
                            else if FMacroDefaults[MName].ContainsKey(FMacroParams[MName][I]) then
                              LocalMacroContext.AddOrSetValue(FMacroParams[MName][I], TValue.From<String>(FMacroDefaults[MName][FMacroParams[MName][I]]))
                            else
                              LocalMacroContext.AddOrSetValue(FMacroParams[MName][I], TValue.Empty);
                          end;
                          ProcessTemplate(FMacroBodies[MName], LocalMacroContext, Result);
                        finally
                          LocalMacroContext.Free;
                        end;
                      end);
                  except
                    MacroDefaults.Free;
                    raise;
                  end;
                  Break;
                end;
              end;
              if Tag.StartsWith('if ') then
                Inc(IfDepth)
              else if Tag = 'endif' then
                Dec(IfDepth);
              if Tag.StartsWith('for ') then
                Inc(ForDepth)
              else if Tag = 'endfor' then
                Dec(ForDepth);
              if Tag.StartsWith('with ') or (Tag = 'with') then
                Inc(WithDepth)
              else if Tag = 'endwith' then
                Dec(WithDepth);
            end;
            if MacroDepth > 0 then
              raise Exception.Create('Unclosed macro');
          end
          else
          begin
            SB.Append('{% ' + Tag + ' %}');
          end;
        end
        else
        begin
          SB.Append('{');
          CurrentPos := EndPos + 1;
        end;
      end;
      Result := SB.ToString;
    finally
      SB.Free;
    end;
  finally
    //LocalContext.Free;
  end;
end;


/// <summary>
/// Internal rendering logic for templates.
/// </summary>
/// <param name="TemplateOrContent">Template name or content.</param>
/// <param name="Context">The rendering context.</param>
/// <returns>The fully rendered template.</returns>
/// <remarks>
/// Processes comments, macros, extends, and delegates to ProcessTemplate.
/// Loads file if name provided, else treats as content.
/// </remarks>
function TTina4Twig.RenderInternal(const TemplateOrContent: String; var Context: TStringDict): String;
var
  TemplateText, FullPath: String;
begin
  FullPath := IncludeTrailingPathDelimiter(FTemplatePath) + TemplateOrContent;
  if FileExists(FullPath) then
    TemplateText := LoadTemplate(TemplateOrContent)
  else
    TemplateText := TemplateOrContent;

  TemplateText := RemoveComments(TemplateText);
  TemplateText := EvaluateMacroBlocks(TemplateText, Context);
  TemplateText := EvaluateIncludes(TemplateText, Context);
  TemplateText := EvaluateExtends(TemplateText, Context);
  ProcessTemplate(TemplateText, Context, Result);
  Result := StringReplace(Result, #$D#$A, '', []);
end;

procedure TTina4Twig.SetDateFormat(FormatDate, FormatDays: String);
begin
  FDateFormat := FormatDate;
  FDaysFormat := FormatDays;
end;

procedure TTina4Twig.SetDebug(Value: Boolean);
begin
  FDebug := Value;
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
  if AValue.IsEmpty then
  begin
     FContext.Remove(AName);
  end
    else
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
