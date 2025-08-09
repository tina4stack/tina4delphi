unit Tina4Twig;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.RegularExpressions,
  System.Rtti, JSON, System.NetEncoding, System.Math, Variants, System.TypInfo, System.DateUtils;

type
  TStringDict = TDictionary<String, TValue>;
  TFilterFunc = reference to function(const Input: TValue; const Args: TArray<String>;const Context: TDictionary<String, TValue>): String;
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
    FDateFormat: String;
    FDaysFormat: String;
    function LoadTemplate(const TemplateName: String): String;
    procedure SetDateFormat(FormatDate: String; FormatDays: String);
    function IsStrictNumeric(const Value: TValue): Boolean;
    function GetAsExtendedLenient(const Value: TValue): Extended;
    function CompareValues(const Left, Right: TValue; const Op: String): Boolean;
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
    function GetExpressionValue(const Expr: String; Context: TDictionary<String, TValue>): TValue;
    function EvaluateExpression(const Expr: String; Context: TDictionary<String, TValue>): TValue;
    function EvaluateRPN(const RPN: TArray<String>; const Context: TDictionary<String, TValue>): TValue;
    function Tokenize(const Expr: String): TArray<String>;
    procedure DumpValue(const Value: TValue; List: TStringList; const Indent: String);
    procedure RegisterDefaultFilters;
  public
    constructor Create(const TemplatePath: String = '');
    destructor Destroy; override;
    function Render(const TemplateOrContent: String; Variables: TStringDict = nil): String;
    procedure SetVariable(AName: string; AValue: TValue);
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
/// Updated to robustly recognize 'in', 'starts with', and 'matches' operators with flexible spacing and case.
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

      // Handle 'matches' operator
      if (I <= Length(Expr) - 6) and (Copy(LowerExpr, I, 7) = 'matches') and
         ((I + 6 = Length(Expr)) or CharInSet(Expr[I + 7], [' ', #9, #10, #13, '''', '"', ')', '}', ']'])) then
      begin
        Tokens.Add('matches');
        Inc(I, 7);
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

      // Handle numbers
      if CharInSet(Expr[I], ['0'..'9', '-']) then
      begin
        Token := Expr[I];
        Inc(I);
        HasDot := False;
        while I <= Length(Expr) do
        begin
          if Expr[I] = '.' then
          begin
            if HasDot then Break;
            HasDot := True;
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
        if (Token = 'matches') or (Token = 'starts') or (Token = 'with') then
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
/// Updated to correctly order operands for 'in', 'starts with', and 'matches' operators.
/// </remarks>
function InfixToRPN(const Tokens: TArray<String>): TArray<String>;
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
    Precedence.Add('+', 2);
    Precedence.Add('-', 2);
    Precedence.Add('*', 3);
    Precedence.Add('/', 3);
    Precedence.Add('%', 3);
    Precedence.Add('~', 1);
    Precedence.Add('==', 0);
    Precedence.Add('!=', 0);
    Precedence.Add('<', 0);
    Precedence.Add('>', 0);
    Precedence.Add('<=', 0);
    Precedence.Add('>=', 0);
    Precedence.Add('in', 0);
    Precedence.Add('starts with', 0);
    Precedence.Add('matches', 0);
    Output := TList<String>.Create;
    OpStack := TStack<String>.Create;
    try
      I := 0;
      InFilter := False;
      ParenDepth := 0;
      FilterChain := '';
      LastAppended := '';
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
              if not Precedence.ContainsKey(Top) then
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
            Output.Add(FilterChain); // Add completed filter chain
            InFilter := False;
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
          Continue;
        end;
        // Handle parentheses
        if Token = '(' then
        begin
          OpStack.Push(Token);
          Inc(I);
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
          Continue;
        end;
        // Handle comma (used in filter arguments, e.g., date('U'))
        if Token = ',' then
        begin
          while (OpStack.Count > 0) and (OpStack.Peek <> '(') do
            Output.Add(OpStack.Pop);
          Output.Add(Token);
          Inc(I);
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
          if Precedence[Token] >= TopPrec then // Changed to >= for correct operator precedence
            Break;
          Output.Add(OpStack.Pop);
        end;
        OpStack.Push(Token);
        Inc(I);
      end;
      // Pop remaining operators
      while OpStack.Count > 0 do
      begin
        Top := OpStack.Pop;
        if Top = '(' then
          raise Exception.Create('Mismatched parentheses');
        Output.Add(Top);
      end;
      Result := Output.ToArray;
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
/// Processes arithmetic operations, filter chains, comparisons, and 'in', 'starts with', 'matches' operators.
/// Updated to safely handle regex evaluation for 'matches' operator.
/// </remarks>
function TTina4Twig.EvaluateRPN(const RPN: TArray<String>; const Context: TDictionary<String, TValue>): TValue;
var
  Stack: TStack<TValue>;
  Token: String;
  A, B: TValue;
  FA, FB: Double;
  IA, IB: Int64;
  Parts: TArray<String>;
  J: Integer;
  CurrentVal: TValue;
  FilterExpr, FuncName, ArgsStr: String;
  ArgTokens: TArray<String>;
  ArgList: TList<String>;
  ArgToken: String;
  Args: TArray<String>;
  Filter: TFilterFunc;
  Condition: Boolean;
  IsSimpleInteger: Boolean;
  I: Integer;
begin
  Stack := TStack<TValue>.Create;
  try
    for Token in RPN do
    begin
      if Token.Contains('|') then
      begin
        Parts := SplitOnTopLevel(Token, '|');
        if Trim(Parts[0]) = '' then
          CurrentVal := Stack.Pop
        else
          CurrentVal := GetExpressionValue(Parts[0], Context);
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
              for ArgToken in ArgTokens do
                ArgList.Add(Trim(ArgToken));
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
            CurrentVal := TValue.From<String>(Filter(CurrentVal, Args, Context));
            IsSimpleInteger := TryStrToInt64(CurrentVal.AsString, IA);
            if IsSimpleInteger then
            begin
              for I := 1 to Length(CurrentVal.AsString) do
              begin
                if (CurrentVal.AsString[I] in ['0', '+', '-']) and (I < Length(CurrentVal.AsString)) then
                begin
                  IsSimpleInteger := False;
                  Break;
                end;
              end;
            end;
            if IsSimpleInteger then
              CurrentVal := TValue.From<Int64>(IA);
          end
          else
            CurrentVal := TValue.From<String>('(filter ' + FuncName + ' not found)');
        end;
        Stack.Push(CurrentVal);
        Continue;
      end;
      if TryStrToInt64(Token, IA) then
        Stack.Push(TValue.From<Int64>(IA))
      else if TryStrToFloat(Token, FA) then
        Stack.Push(TValue.From<Double>(FA))
      else if (Token.StartsWith('''') or Token.StartsWith('"')) and (Token.EndsWith(Token[1])) then
        Stack.Push(TValue.From<String>(Copy(Token, 2, Length(Token) - 2)))
      else if not CharInSet(Token[1], ['+', '-', '*', '/', '%', '~', '<', '>', '=', '!']) and
              (Token <> 'in') and (Token <> 'starts with') and (Token <> 'matches') then
        Stack.Push(GetExpressionValue(Token, Context))
      else
      begin
        if Stack.Count < 2 then
          raise Exception.Create('Invalid expression: insufficient operands for ' + Token);
        B := Stack.Pop;
        A := Stack.Pop;
        if Token = 'in' then
        begin
          Condition := Contains(A, B);
          Stack.Push(TValue.From<Boolean>(Condition));
          Continue;
        end;
        if Token = 'starts with' then
        begin
          Condition := (A.Kind in [tkString, tkUString]) and (B.Kind in [tkString, tkUString]) and
                      A.AsString.StartsWith(B.AsString);
          Stack.Push(TValue.From<Boolean>(Condition));
          Continue;
        end;
        if Token = 'matches' then
        begin
          if (A.Kind in [tkString, tkUString]) and (B.Kind in [tkString, tkUString]) then
          begin
            try
              Condition := TRegEx.IsMatch(A.AsString, B.AsString);
            except
              on E: Exception do
                Condition := False; // Handle invalid regex patterns gracefully
            end;
            Stack.Push(TValue.From<Boolean>(Condition));
          end
          else
            Stack.Push(TValue.From<Boolean>(False));
          Continue;
        end;
        if Token = '~' then
        begin
          Stack.Push(TValue.From<String>(A.ToString + B.ToString));
          Continue;
        end;
        if (Token = '==') or (Token = '!=') or (Token = '<') or (Token = '>') or (Token = '<=') or (Token = '>=') then
        begin
          if Token = '==' then
            Condition := ValuesAreEqual(A, B)
          else if Token = '!=' then
            Condition := not ValuesAreEqual(A, B)
          else
            Condition := CompareValues(A, B, Token);
          Stack.Push(TValue.From<Boolean>(Condition));
          Continue;
        end;
        FA := GetAsExtendedLenient(A);
        FB := GetAsExtendedLenient(B);
        case Token[1] of
          '+': Stack.Push(TValue.From<Double>(FA + FB));
          '-': Stack.Push(TValue.From<Double>(FA - FB));
          '*': Stack.Push(TValue.From<Double>(FA * FB));
          '/': if FB <> 0 then Stack.Push(TValue.From<Double>(FA / FB)) else Stack.Push(TValue.From<Double>(0));
          '%': if FB <> 0 then Stack.Push(TValue.From<Double>(fmod(FA, FB))) else Stack.Push(TValue.From<Double>(0));
        end;
      end;
    end;
    if Stack.Count = 1 then
      Result := Stack.Pop
    else
      raise Exception.Create('Invalid expression: stack imbalance');
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
/// </remarks>
function TTina4Twig.EvaluateExpression(const Expr: String; Context: TDictionary<String, TValue>): TValue;
var
  Tokens: TArray<String>;
  RPN: TArray<String>;
begin
  Tokens := Tokenize(Expr);
  if Length(Tokens) = 0 then
    Exit(TValue.Empty);
  if Length(Tokens) = 1 then
  begin
    // Handle single-token expressions (e.g., a variable or literal)
    Result := GetExpressionValue(Tokens[0], Context);
    if Result.IsEmpty then
      Result := TValue.From<Boolean>(False); // Fallback to False for undefined variables
    Exit;
  end;
  RPN := InfixToRPN(Tokens);
  Result := EvaluateRPN(RPN, Context);
  if Result.IsEmpty then
    Result := TValue.From<Boolean>(False); // Fallback to False for invalid expressions
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

  //Set the date format for the system to be used in date_format and date
  FDateFormat := 'YYYY-mm-dd';
  FDaysFormat := '%d days';

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
/// <returns>The template with if blocks evaluated.</returns>
/// <remarks>
/// Supports conditions with arithmetic expressions, filters, and operators, with debug logging.
/// </remarks>
function TTina4Twig.EvaluateIfBlocks(const Template: String; Context: TDictionary<String, TValue>): String;
var
  ResultSB: TStringBuilder;
  LowerTemplate: String;
  CurrentPos, IfTagStart, IfTagEnd, Depth, TagStart, TagEnd, ElseTagStart, ElseTagEnd, EndIfTagStart, EndIfTagEnd: Integer;
  IfExpr, TagContent, LowerTagContent, BlockContent: String;
  Condition: Boolean;
  Blocks: TList<String>;
  Conditions: TList<Boolean>;
  SelectedBlock: String;
begin
  ResultSB := TStringBuilder.Create;
  LowerTemplate := LowerCase(Template);
  CurrentPos := 0;
  Blocks := TList<String>.Create;
  Conditions := TList<Boolean>.Create;
  try
    while True do
    begin
      IfTagStart := LowerTemplate.IndexOf('{%if', CurrentPos);
      if IfTagStart < 0 then
        IfTagStart := LowerTemplate.IndexOf('{% if', CurrentPos);
      if IfTagStart < 0 then Break;
      ResultSB.Append(Template.Substring(CurrentPos, IfTagStart - CurrentPos));
      IfTagEnd := LowerTemplate.IndexOf('%}', IfTagStart + 2);
      if IfTagEnd < 0 then Break;
      IfExpr := Trim(Template.Substring(IfTagStart + 2, IfTagEnd - IfTagStart - 2));
      if not IfExpr.ToLower.StartsWith('if') then
      begin
        CurrentPos := IfTagEnd + 2;
        Continue;
      end;
      IfExpr := Trim(IfExpr.Substring(IfExpr.ToLower.IndexOf('if') + 2));
      Depth := 1;
      CurrentPos := IfTagEnd + 2;
      ElseTagStart := -1;
      ElseTagEnd := -1;
      EndIfTagStart := -1;
      EndIfTagEnd := -1;
      Blocks.Clear;
      Conditions.Clear;
      Blocks.Add('');
      Conditions.Add(False);

      // Evaluate the condition using EvaluateExpression
      Condition := ToBool(EvaluateExpression(IfExpr, Context));
      Conditions[0] := Condition;

      while True do
      begin
        TagStart := LowerTemplate.IndexOf('{%', CurrentPos);
        if TagStart < 0 then Break;
        TagEnd := LowerTemplate.IndexOf('%}', TagStart + 2);
        if TagEnd < 0 then Break;
        TagContent := Trim(Template.Substring(TagStart + 2, TagEnd - TagStart - 2));
        LowerTagContent := LowerCase(TagContent);
        if LowerTagContent.StartsWith('if') then
        begin
          Inc(Depth);
          Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagEnd + 2 - CurrentPos);
        end
        else if LowerTagContent.StartsWith('elseif') then
        begin
          if Depth = 1 then
          begin
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagStart - CurrentPos);
            Blocks.Add('');
            IfExpr := Trim(TagContent.Substring(TagContent.ToLower.IndexOf('elseif') + 6));
            Condition := ToBool(EvaluateExpression(IfExpr, Context));
            Conditions.Add(Condition);
          end
          else
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagEnd + 2 - CurrentPos);
        end
        else if LowerTagContent.StartsWith('else') then
        begin
          if Depth = 1 then
          begin
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagStart - CurrentPos);
            Blocks.Add('');
            Conditions.Add(True);
            ElseTagStart := TagStart;
            ElseTagEnd := TagEnd;
          end
          else
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagEnd + 2 - CurrentPos);
        end
        else if LowerTagContent.StartsWith('endif') then
        begin
          Dec(Depth);
          if Depth = 0 then
          begin
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagStart - CurrentPos);
            EndIfTagStart := TagStart;
            EndIfTagEnd := TagEnd;
            Break;
          end
          else
            Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagEnd + 2 - CurrentPos);
        end
        else
          Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos, TagEnd + 2 - CurrentPos);
        CurrentPos := TagEnd + 2;
      end;
      if EndIfTagStart < 0 then
      begin
        Blocks[Blocks.Count - 1] := Blocks[Blocks.Count - 1] + Template.Substring(CurrentPos);
        CurrentPos := Length(Template);
      end
      else
        CurrentPos := EndIfTagEnd + 2;
      SelectedBlock := '';
      for var I := 0 to Conditions.Count - 1 do
        if Conditions[I] then
        begin
          SelectedBlock := Blocks[I];
          Break;
        end;
      ResultSB.Append(RenderInternal(SelectedBlock, Context));
    end;
    ResultSB.Append(Template.Substring(CurrentPos));
    Result := ResultSB.ToString;
  finally
    Blocks.Free;
    Conditions.Free;
    ResultSB.Free;
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
/// Uses EvaluateExpression for complex expressions with filters and operators.
/// Strips quotes from macro and function arguments to ensure correct rendering.
/// </remarks>
function TTina4Twig.ReplaceContextVariables(const Template: String; Context: TDictionary<String, TValue>): String;
var
  Regex: TRegEx;
  Match: TMatch;
  FullMatch, Expr: String;
  TempVal: TValue;
  Func: TFunctionFunc;
  Macro: TMacroFunc;
  FilteredValue: String;
  I: Integer;
  Args: TArray<String>;
begin
  Result := Template;
  Regex := TRegEx.Create('{{\s*([^}]+)\s*}}', [roSingleLine, roIgnoreCase]);

  while True do
  begin
    Match := Regex.Match(Result);
    if not Match.Success then
      Break;

    FullMatch := Match.Value;
    Expr := Trim(Match.Groups[1].Value);


    // Initialize Args to empty array to avoid undefined issues
    SetLength(Args, 0);

    // Handle expressions with filters and/or operators
    if Expr.Contains('|') or Expr.Contains('+') or Expr.Contains('-') or Expr.Contains('*') or Expr.Contains('/') or Expr.Contains('%') or Expr.Contains('~') then
    begin
      TempVal := EvaluateExpression(Expr, Context);
      Result := StringReplace(Result, FullMatch, TempVal.ToString, [rfReplaceAll]);
      Continue;
    end;

    // Handle function or macro calls (e.g., {{ dump(var) }} or {{ input("Test") }})
    if Expr.Contains('(') and Expr.EndsWith(')') then
    begin
      var FuncName := Trim(Copy(Expr, 1, Pos('(', Expr) - 1));
      var ArgsStr := Trim(Copy(Expr, Pos('(', Expr) + 1, Length(Expr) - Pos('(', Expr) - 1));
      if ArgsStr <> '' then
        Args := ArgsStr.Split([','], TStringSplitOptions.ExcludeEmpty);
      for I := 0 to High(Args) do
      begin
        Args[I] := Trim(Args[I]);
        // Strip quotes from string literals in arguments
        if ((Args[I].StartsWith('"') and Args[I].EndsWith('"')) or
            (Args[I].StartsWith('''') and Args[I].EndsWith(''''))) and (Length(Args[I]) >= 2) then
          Args[I] := Copy(Args[I], 2, Length(Args[I]) - 2);
      end;

      // Try macro first
      if FMacros.TryGetValue(FuncName, Macro) then
      begin
        FilteredValue := Macro(FuncName, Args, Context);
        Result := StringReplace(Result, FullMatch, FilteredValue, [rfReplaceAll]);
        Continue;
      end
      else if FFunctions.TryGetValue(FuncName, Func) then
      begin
        FilteredValue := Func(Args, Context);
        Result := StringReplace(Result, FullMatch, FilteredValue, [rfReplaceAll]);
        Continue;
      end;
    end;

    // Handle simple variable lookup
    TempVal := ResolveVariablePath(Expr, Context);
    if not TempVal.IsEmpty then
      Result := StringReplace(Result, FullMatch, TempVal.ToString, [rfReplaceAll])
    else
      Result := StringReplace(Result, FullMatch, '', [rfReplaceAll]);
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
    Exit(TValue.Empty);

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
  ResultSB: TStringBuilder;
  LowerTemplate: String;
  CurrentPos, SetTagStart, SetTagEnd, PosColon: Integer;
  SetContent, VarName, ValueStr: String;
begin
  ResultSB := TStringBuilder.Create;
  LowerTemplate := LowerCase(Template);
  CurrentPos := 0;
  try
    while True do
    begin
      SetTagStart := LowerTemplate.IndexOf('{%set', CurrentPos);
      if SetTagStart < 0 then
        SetTagStart := LowerTemplate.IndexOf('{% set', CurrentPos);
      if SetTagStart < 0 then Break;
      ResultSB.Append(Template.Substring(CurrentPos, SetTagStart - CurrentPos));
      SetTagEnd := LowerTemplate.IndexOf('%}', SetTagStart + 2);
      if SetTagEnd < 0 then Break;
      SetContent := Trim(Template.Substring(SetTagStart + 2, SetTagEnd - SetTagStart - 2));
      if not SetContent.ToLower.StartsWith('set') then
      begin
        CurrentPos := SetTagEnd + 2;
        Continue;
      end;
      SetContent := Trim(SetContent.Substring(3));  // Remove 'set'
      PosColon := FindTopLevelPos(SetContent, '=');
      if PosColon <= 0 then
      begin
        CurrentPos := SetTagEnd + 2;
        Continue;
      end;
      VarName := Trim(Copy(SetContent, 1, PosColon - 1));
      ValueStr := Trim(Copy(SetContent, PosColon + 1, MaxInt));
      Context.AddOrSetValue(VarName, EvaluateExpression(ValueStr, Context));
      CurrentPos := SetTagEnd + 2;
    end;
    ResultSB.Append(Template.Substring(CurrentPos));
    Result := ResultSB.ToString;
  finally
    ResultSB.Free;
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
  ResultSB: TStringBuilder;
  LowerTemplate: String;
  CurrentPos, WithTagStart, WithTagEnd, Depth, TagStart, TagEnd, EndWithTagStart, EndWithTagEnd: Integer;
  WithExpr, TagContent, LowerTagContent, DictStr, BlockContent, Evaluated: String;
  ParsedDict, MergedContext: TDictionary<String, TValue>;
  Pair: TPair<String, TValue>;
  VarValue: TValue;
  SubDict: TDictionary<String, TValue>;
  UseOnly: Boolean;
begin
  ResultSB := TStringBuilder.Create;
  LowerTemplate := LowerCase(Template);
  CurrentPos := 0;
  while True do
  begin
    WithTagStart := LowerTemplate.IndexOf('{%with', CurrentPos);
    if WithTagStart < 0 then
      WithTagStart := LowerTemplate.IndexOf('{% with', CurrentPos);
    if WithTagStart < 0 then Break;
    ResultSB.Append(Template.Substring(CurrentPos, WithTagStart - CurrentPos));
    WithTagEnd := LowerTemplate.IndexOf('%}', WithTagStart + 2);
    if WithTagEnd < 0 then Break;
    WithExpr := Trim(Template.Substring(WithTagStart + 2, WithTagEnd - WithTagStart - 2));
    if not WithExpr.ToLower.StartsWith('with') then
    begin
      CurrentPos := WithTagEnd + 2;
      Continue;
    end;
    WithExpr := Trim(WithExpr.Substring(WithExpr.ToLower.IndexOf('with') + 4));
    // Check for 'only' keyword
    UseOnly := WithExpr.ToLower.EndsWith(' only');
    if UseOnly then
      DictStr := Trim(WithExpr.Substring(0, WithExpr.Length - Length('only')))
    else
      DictStr := WithExpr;
    Depth := 1;
    CurrentPos := WithTagEnd + 2;
    EndWithTagStart := -1;
    EndWithTagEnd := -1;
    while True do
    begin
      TagStart := LowerTemplate.IndexOf('{%', CurrentPos);
      if TagStart < 0 then Break;
      TagEnd := LowerTemplate.IndexOf('%}', TagStart + 2);
      if TagEnd < 0 then Break;
      TagContent := Trim(Template.Substring(TagStart + 2, TagEnd - TagStart - 2));
      LowerTagContent := LowerCase(TagContent);
      if LowerTagContent.StartsWith('with') then
        Inc(Depth)
      else if LowerTagContent = 'endwith' then
      begin
        Dec(Depth);
        if Depth = 0 then
        begin
          BlockContent := Template.Substring(WithTagEnd + 2, TagStart - WithTagEnd - 2);
          EndWithTagStart := TagStart;
          EndWithTagEnd := TagEnd;
          Break;
        end;
      end;
      CurrentPos := TagEnd + 2;
    end;
    if EndWithTagStart < 0 then Break;
    ParsedDict := ParseVariableDict(DictStr, Context);
    MergedContext := TDictionary<String, TValue>.Create;
    try
      // Only include parent context if 'only' is not specified
      if not UseOnly then
        for Pair in Context do
          MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
      for Pair in ParsedDict do
      begin
        VarValue := Pair.Value;
        if VarValue.IsType<TJSONObject> then
        begin
          SubDict := TDictionary<String, TValue>.Create;
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
              SubDict.AddOrSetValue(JPair.JsonString.Value, PVal);
            end;
            MergedContext.AddOrSetValue(Pair.Key, TValue.From<TDictionary<String, TValue>>(SubDict));
          except
            SubDict.Free;
            raise;
          end;
        end
        else
          MergedContext.AddOrSetValue(Pair.Key, VarValue);
      end;
    finally
      ParsedDict.Free;
    end;
    try
      Evaluated := EvaluateWithBlocks(BlockContent, MergedContext);
      Evaluated := RenderInternal(Evaluated, MergedContext);
      ResultSB.Append(Evaluated);
    finally
      MergedContext.Free;
    end;
    CurrentPos := EndWithTagEnd + 2;
  end;
  ResultSB.Append(Template.Substring(CurrentPos));
  Result := ResultSB.ToString;
  ResultSB.Free;
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
  ResultSB: TStringBuilder;
  LowerTemplate: String;
  CurrentPos, ForTagStart, ForTagEnd, InPos, Depth, IfDepth, TagStart, TagEnd, ElseTagStart, ElseTagEnd, EndForTagStart, EndForTagEnd: Integer;
  ForExpr, TagContent, LowerTagContent, VarName, ListExpr, BlockContent, ElseContent, Output: String;
  Items: TArray<TDictionary<String, TValue>>;
  Item: TDictionary<String, TValue>;
  MergedContext: TDictionary<String, TValue>;
  Pair: TPair<String, TValue>;
  Value: TValue;
  ValueArray: TArray<TValue>;
  JSONArray: TJSONArray;
  I: Integer;
  ProcessedBlock, Rendered: String;
begin
  ResultSB := TStringBuilder.Create;
  LowerTemplate := LowerCase(Template);
  CurrentPos := 0;
  try
    while True do
    begin
      ForTagStart := LowerTemplate.IndexOf('{%for', CurrentPos);
      if ForTagStart < 0 then
        ForTagStart := LowerTemplate.IndexOf('{% for', CurrentPos);
      if ForTagStart < 0 then Break;
      ResultSB.Append(Template.Substring(CurrentPos, ForTagStart - CurrentPos));
      ForTagEnd := LowerTemplate.IndexOf('%}', ForTagStart + 2);
      if ForTagEnd < 0 then Break;
      ForExpr := Trim(Template.Substring(ForTagStart + 2, ForTagEnd - ForTagStart - 2));
      if not ForExpr.ToLower.StartsWith('for') then
      begin
        CurrentPos := ForTagEnd + 2;
        Continue;
      end;
      ForExpr := ForExpr.Substring(3).Trim;
      InPos := ForExpr.ToLower.IndexOf(' in ');
      if InPos < 0 then
      begin
        CurrentPos := ForTagEnd + 2;
        Continue;
      end;
      VarName := ForExpr.Substring(0, InPos).Trim;
      ListExpr := ForExpr.Substring(InPos + 4).Trim;
      Depth := 1;
      IfDepth := 0;
      CurrentPos := ForTagEnd + 2;
      ElseTagStart := -1;
      ElseTagEnd := -1;
      EndForTagStart := -1;
      EndForTagEnd := -1;
      while True do
      begin
        TagStart := LowerTemplate.IndexOf('{%', CurrentPos);
        if TagStart < 0 then Break;
        TagEnd := LowerTemplate.IndexOf('%}', TagStart + 2);
        if TagEnd < 0 then Break;
        TagContent := Trim(Template.Substring(TagStart + 2, TagEnd - TagStart - 2));
        LowerTagContent := LowerCase(TagContent);
        if LowerTagContent.StartsWith('for') then
        begin
          Inc(Depth);
        end
        else if LowerTagContent.StartsWith('if') then
        begin
          Inc(IfDepth);
        end
        else if LowerTagContent = 'endif' then
        begin
          if IfDepth > 0 then
            Dec(IfDepth);
        end
        else if LowerTagContent = 'endfor' then
        begin
          Dec(Depth);
          if Depth = 0 then
          begin
            EndForTagStart := TagStart;
            EndForTagEnd := TagEnd;
            Break;
          end;
        end
        else if LowerTagContent = 'else' then
        begin
          if (Depth = 1) and (IfDepth = 0) then
          begin
            ElseTagStart := TagStart;
            ElseTagEnd := TagEnd;
          end;
        end;
        CurrentPos := TagEnd + 2;
      end;
      if EndForTagStart < 0 then Break;
      if ElseTagStart >= 0 then
      begin
        BlockContent := Template.Substring(ForTagEnd + 2, ElseTagStart - ForTagEnd - 2);
        ElseContent := Template.Substring(ElseTagEnd + 2, EndForTagStart - ElseTagEnd - 2);
      end
      else
      begin
        BlockContent := Template.Substring(ForTagEnd + 2, EndForTagStart - ForTagEnd - 2);
        ElseContent := '';
      end;
      Output := '';
      Items := nil;
      if ListExpr.StartsWith('[') and ListExpr.EndsWith(']') then
      begin
        var ArrayContent := ListExpr.Substring(1, ListExpr.Length - 2).Trim;
        if ArrayContent = '' then
          SetLength(Items, 0)
        else
        begin
          var ArrayItems := ArrayContent.Split([','], TStringSplitOptions.ExcludeEmpty);
          SetLength(Items, Length(ArrayItems));
          for I := 0 to High(ArrayItems) do
          begin
            var Element := Trim(ArrayItems[I]).Replace('''', '', [rfReplaceAll]).Replace('"', '', [rfReplaceAll]);
            Item := TDictionary<String, TValue>.Create;
            Item.Add(VarName, TValue.From(Element));
            Items[I] := Item;
          end;
        end;
      end
      else
      begin
        Value := ResolveVariablePath(ListExpr, Context);
        if Value.IsEmpty then
        begin
          Output := RenderInternal(ElseContent, Context);
          ResultSB.Append(Output);
          CurrentPos := EndForTagEnd + 2;
          Continue;
        end;
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
                Item.Add(VarName, TValue.From<TDictionary<String, TValue>>(SubDict));
              except
                SubDict.Free;
                raise;
              end;
            end
            else if JSONVal is TJSONArray then
              Item.Add(VarName, TValue.From<TJSONArray>(TJSONArray(JSONVal)))
            else
              Item.Add(VarName, TValue.From<String>(JSONVal.ToString));
            Items[I] := Item;
          end;
        end
        else
        begin
          SetLength(Items, 0);
          Output := RenderInternal(ElseContent, Context); // Render else block for non-iterable
          ResultSB.Append(Output);
          CurrentPos := EndForTagEnd + 2;
          Continue;
        end;
      end;
      if Length(Items) = 0 then
      begin
        Output := RenderInternal(ElseContent, Context);
        ResultSB.Append(Output);
        CurrentPos := EndForTagEnd + 2;
        if ListExpr.StartsWith('[') or Value.IsArray or Value.IsType<TJSONArray> then
          for Item in Items do
            Item.Free;
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
            if Pair.Value.IsType<TDictionary<String, TValue>> then
            begin
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
            end
            else if Pair.Value.IsType<TJSONObject> then
            begin
              var jsonObj := Pair.Value.AsType<TJSONObject>;
              var subDict := TDictionary<String, TValue>.Create;
              try
                for var jsonPair in jsonObj do
                begin
                  var val: TValue;
                  if jsonPair.JsonValue is TJSONNumber then
                  begin
                    var numStr := jsonPair.JsonValue.Value;
                    if (Pos('.', numStr) > 0) or (Pos('e', LowerCase(numStr)) > 0) then
                      val := TValue.From<Double>(TJSONNumber(jsonPair.JsonValue).AsDouble)
                    else
                      val := TValue.From<Int64>(TJSONNumber(jsonPair.JsonValue).AsInt64);
                  end
                  else if jsonPair.JsonValue is TJSONBool then
                    val := TValue.From<Boolean>(TJSONBool(jsonPair.JsonValue).AsBoolean)
                  else if jsonPair.JsonValue is TJSONString then
                    val := TValue.From<String>(TJSONString(jsonPair.JsonValue).Value)
                  else if jsonPair.JsonValue is TJSONNull then
                    val := TValue.Empty
                  else
                    val := TValue.From<String>(jsonPair.JsonValue.ToString);
                  subDict.AddOrSetValue(jsonPair.JsonString.Value, val);
                end;
                MergedContext.AddOrSetValue(Pair.Key, TValue.From<TDictionary<String, TValue>>(subDict));
              except
                subDict.Free;
                raise;
              end;
            end
            else
              MergedContext.AddOrSetValue(Pair.Key, Pair.Value);
          end;
          ProcessedBlock := EvaluateSetBlocks(BlockContent, MergedContext);
          ProcessedBlock := EvaluateExtends(ProcessedBlock, MergedContext);
          ProcessedBlock := EvaluateForBlocks(ProcessedBlock, MergedContext);
          ProcessedBlock := EvaluateIncludes(ProcessedBlock, MergedContext);
          ProcessedBlock := EvaluateWithBlocks(ProcessedBlock, MergedContext);
          ProcessedBlock := EvaluateIfBlocks(ProcessedBlock, MergedContext);
          ProcessedBlock := ReplaceContextVariables(ProcessedBlock, MergedContext);
          Rendered := ProcessedBlock;
          Output := Output + Rendered;
        finally
          MergedContext.Free;
        end;
      end;
      if (ListExpr.StartsWith('[') and ListExpr.EndsWith(']')) or Value.IsArray or Value.IsType<TJSONArray> then
        for Item in Items do
          Item.Free;
      ResultSB.Append(Output);
      CurrentPos := EndForTagEnd + 2;
    end;
    ResultSB.Append(Template.Substring(CurrentPos));
    Result := ResultSB.ToString;
  finally
    ResultSB.Free;
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if (Input.Kind in [tkString, tkUString]) and (Input.AsString <> '') then
        Result := UpperCase(Input.AsString[1]) + LowerCase(Copy(Input.AsString, 2, MaxInt))
      else
        Result := Input.ToString;
    end);

  FFilters.Add('column',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: encoding conversion not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('country_name',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: country name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_name',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: currency name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('currency_symbol',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: currency symbol lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('data_uri',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := 'data:;base64,' + TNetEncoding.Base64.Encode(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('date',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
      end
      else
        fmt := FDateFormat;

      if Input.IsType<TDateTime> then
        dt := Input.AsType<TDateTime>
      else if Input.Kind in [tkString, tkUString] then
      begin
        S := Input.AsString;
        FormatSettings.LongDateFormat := 'yyyy-mm-dd hh:nn:ss'; // Set format for ISO 8601 parsing
        FormatSettings.ShortDateFormat := 'yyyy-mm-dd';
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: date arithmetic not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('default',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: generic filter not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('find',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      Result := FFilters['date'](Input, Args, Context);
    end);

  FFilters.Add('format_datetime',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      Result := FFilters['date'](Input, ['hh:nn:ss'], Context);
    end);

  FFilters.Add('html_to_markdown',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: html-to-markdown not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('inky_to_html',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: inky-to-html not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('inline_css',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: inline CSS not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('join',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: language name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('last',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: locale name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('lower',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := LowerCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('map',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: map not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('markdown_to_html',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: markdown-to-html not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('merge',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, sLineBreak, '<br>', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('number_format',
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
  var
    Val: Double;
    Decimals: Integer;
    DecPoint, ThousandsSep: String;
    ArgValue: String;
    FormatStr: String;
  begin
    Decimals := 0;
    DecPoint := '.';
    ThousandsSep := ',';
    if Length(Args) > 0 then
      Decimals := StrToIntDef(GetExpressionValue(Args[0], Context).ToString, 0);
    if Length(Args) > 1 then
    begin
      ArgValue := GetExpressionValue(Args[1], Context).ToString;
      // Remove quotes from string literal if present
      if ((ArgValue.StartsWith('"') and ArgValue.EndsWith('"')) or
          (ArgValue.StartsWith('''') and ArgValue.EndsWith(''''))) and (Length(ArgValue) >= 2) then
        DecPoint := Copy(ArgValue, 2, Length(ArgValue) - 2)
      else
        DecPoint := ArgValue;
    end;
    if Length(Args) > 2 then
    begin
      ArgValue := GetExpressionValue(Args[2], Context).ToString;
      // Remove quotes from string literal if present
      if ((ArgValue.StartsWith('"') and ArgValue.EndsWith('"')) or
          (ArgValue.StartsWith('''') and ArgValue.EndsWith(''''))) and (Length(ArgValue) >= 2) then
        ThousandsSep := Copy(ArgValue, 2, Length(ArgValue) - 2)
      else
        ThousandsSep := ArgValue;
    end;
    if Input.IsOrdinal then
      Val := Input.AsInt64
    else if Input.IsType<Real> then
      Val := Input.AsExtended
    else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
      // Val already set
    else
      Exit(Input.ToString);
    // Construct format string explicitly
    if Decimals > 0 then
      FormatStr := '0.' + StringOfChar('0', Decimals)
    else
      FormatStr := '0';
    Result := FormatFloat(FormatStr, Val);
    if Decimals > 0 then
      Result := StringReplace(Result, '.', DecPoint, [rfReplaceAll]);
    // Note: Thousands separator not implemented due to lack of direct support in FormatFloat
  end);

  FFilters.Add('plural',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: pluralization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('raw',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      Result := Input.ToString; // No escaping
    end);

  FFilters.Add('reduce',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: reduce not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('replace',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Length(Args) < 2 then
        Result := Input.ToString
      else if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, Args[0], Args[1], [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('reverse',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
  function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
  var
    Val: Double;
    Decimals: Integer;
    Method: String;
    Multiplier: Double;
  begin
    Decimals := 0;
    Method := 'common';
    if Length(Args) > 0 then
      Decimals := StrToIntDef(Args[0], 0);
    if Length(Args) > 1 then
      Method := Args[1].ToLower;
    if Input.IsOrdinal then
      Val := Input.AsInt64
    else if Input.IsType<Real> then
      Val := Input.AsExtended
    else if (Input.Kind in [tkString, tkUString]) and TryStrToFloat(Input.AsString, Val) then
      // Val set
    else
      Exit(Input.ToString);
    Multiplier := Power(10, Decimals);
    if Method = 'floor' then
      Val := Floor(Val * Multiplier) / Multiplier
    else if Method = 'ceil' then
      Val := Ceil(Val * Multiplier) / Multiplier
    else // 'common' or default
      Val := RoundTo(Val, -Decimals);
    if Decimals = 0 then
      Result := IntToStr(Trunc(Val))
    else
      Result := FloatToStrF(Val, ffFixed, 15, Decimals);
  end);

  FFilters.Add('shuffle',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: shuffle not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('singular',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: singularization not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('slice',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: sorting not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('spaceless',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := StringReplace(Input.AsString, ' ', '', [rfReplaceAll])
      else
        Result := Input.ToString;
    end);

  FFilters.Add('split',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Stub: timezone name lookup not implemented
      Result := Input.ToString;
    end);

  FFilters.Add('title',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := Trim(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('u',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      // Twig u filter is Unicode string conversion
      Result := Input.ToString;
    end);

  FFilters.Add('upper',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
    begin
      if Input.Kind in [tkString, tkUString] then
        Result := UpperCase(Input.AsString)
      else
        Result := Input.ToString;
    end);

  FFilters.Add('url_encode',
    function(const Input: TValue; const Args: TArray<String>; const Context: TDictionary<String, TValue>): String
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

    Result := StringReplace(TemplateText, #$D#$A'', '', [rfIgnoreCase]);
  finally
    LocalContext.Free;
  end;
end;

procedure TTina4Twig.SetDateFormat(FormatDate, FormatDays: String);
begin
  FDateFormat := FormatDate;
  FDaysFormat := FormatDays;
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
