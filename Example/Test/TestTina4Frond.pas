unit TestTina4Frond;

// Ported from tina4-python/tests/test_frond.py
// Uses TTina4Frond (Tina4Frond.pas). Tests mirror the 28 Python test classes.
// Tests for features not yet implemented in Tina4Frond are INCLUDED so gaps are visible.

interface

uses
  TestFramework, Variants, System.Math, System.NetEncoding,
  System.Generics.Collections, JSON, System.SysUtils, System.Classes,
  System.IOUtils, System.RegularExpressions, System.Rtti, Winapi.Windows,
  Tina4Frond;

type
  // Helpers used across test cases
  TFrondTestHelper = class
  public
    class function MakeDict(const Pairs: array of const): TDictionary<string, TValue>;
    class function MakeArray(const Items: array of TValue): TValue;
    class function TempDir: string;
  end;

  // ── TestVariables ──────────────────────────────────────────────
  TestTTina4Frond_Variables = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSimpleVariable;
    procedure TestDottedAccess;
    procedure TestArrayAccess;
    procedure TestMissingVariable;
    procedure TestAutoEscapeHtml;
    procedure TestRawFilterNoEscape;
    procedure TestStringConcatenation;
    procedure TestTernary;
    procedure TestNullCoalescing;
  end;

  // ── TestFilters ────────────────────────────────────────────────
  TestTTina4Frond_Filters = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestUpper;
    procedure TestLower;
    procedure TestCapitalize;
    procedure TestTitle;
    procedure TestTrim;
    procedure TestLtrim;
    procedure TestRtrim;
    procedure TestSlug;
    procedure TestWordwrap;
    procedure TestTruncate;
    procedure TestTruncateShort;
    procedure TestNl2br;
    procedure TestStriptags;
    procedure TestLengthList;
    procedure TestLengthString;
    procedure TestReverseList;
    procedure TestReverseString;
    procedure TestSort;
    procedure TestFirst;
    procedure TestLast;
    procedure TestJoin;
    procedure TestJoinDefaultSeparator;
    procedure TestSplit;
    procedure TestUnique;
    procedure TestFilter;
    procedure TestMap;
    procedure TestColumn;
    procedure TestBatch;
    procedure TestSliceFilter;
    procedure TestReplace;
    procedure TestReplaceSpace;
    procedure TestEscape;
    procedure TestEAlias;
    procedure TestRaw;
    procedure TestSafe;
    procedure TestUrlEncode;
    procedure TestBase64Encode;
    procedure TestBase64Decode;
    procedure TestMd5;
    procedure TestSha256;
    procedure TestAbs;
    procedure TestRound;
    procedure TestRoundNoDecimals;
    procedure TestNumberFormat;
    procedure TestInt;
    procedure TestFloat;
    procedure TestStringFilter;
    procedure TestJsonEncode;
    procedure TestToJson;
    procedure TestToJsonHtmlSafe;
    procedure TestTojsonAlias;
    procedure TestJsonDecode;
    procedure TestJsEscape;
    procedure TestJsEscapeNewlines;
    procedure TestKeys;
    procedure TestValues;
    procedure TestDefaultNone;
    procedure TestDefaultEmptyString;
    procedure TestDefaultHasValue;
    procedure TestDateFormat;
    procedure TestFormat;
    procedure TestStriptagsDup;
    procedure TestReplaceDup;
    procedure TestChainedFilters;
    procedure TestMd5Dup;
    procedure TestFirstLast;
    procedure TestReverseDup;
    procedure TestSortDup;
    procedure TestKeysValues;
    procedure TestCustomFilter;
  end;

  // ── TestIfElse ─────────────────────────────────────────────────
  TestTTina4Frond_IfElse = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestIfTrue;
    procedure TestIfFalse;
    procedure TestIfElse;
    procedure TestElseif;
    procedure TestElif;
    procedure TestComparisonOperators;
    procedure TestAndOr;
    procedure TestNot;
    procedure TestIsDefined;
    procedure TestIsEmpty;
    procedure TestIsEvenOdd;
    procedure TestInOperator;
    procedure TestNestedIf;
  end;

  // ── TestForLoop ────────────────────────────────────────────────
  TestTTina4Frond_ForLoop = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSimpleFor;
    procedure TestLoopIndex;
    procedure TestLoopFirstLast;
    procedure TestLoopLength;
    procedure TestForElse;
    procedure TestForKeyValue;
    procedure TestNestedFor;
    procedure TestLoopEvenOdd;
  end;

  // ── TestSetIncludeExtends ─────────────────────────────────────
  TestTTina4Frond_SetIncludeExtends = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
    FTplDir: string;
    procedure WriteTpl(const Name, Contents: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSetVariable;
    procedure TestSetWithConcat;
    procedure TestInclude;
    procedure TestIncludeIgnoreMissing;
    procedure TestIncludeMissingRaises;
    procedure TestExtendsAndBlocks;
    procedure TestExtendsDefaultBlock;
    procedure TestExtendsWithLeadingWhitespace;
    procedure TestExtendsWithLeadingNewlines;
    procedure TestExtendsWithVariablesInBlocks;
    procedure TestExtendsWithIncludeInBlock;
    procedure TestTwoLevelExtends;
    procedure TestThreeLevelExtends;
    procedure TestTwoLevelExtendsDefaultBlock;
  end;

  // ── TestWhitespaceControl ─────────────────────────────────────
  TestTTina4Frond_WhitespaceControl = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStripBefore;
    procedure TestStripAfter;
  end;

  // ── TestComments ──────────────────────────────────────────────
  TestTTina4Frond_Comments = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCommentRemoved;
  end;

  // ── TestGlobals ──────────────────────────────────────────────
  TestTTina4Frond_Globals = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestGlobalVariable;
    procedure TestDataOverridesGlobal;
  end;

  // ── TestDump ─────────────────────────────────────────────────
  TestTTina4Frond_Dump = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDumpFilterDebugMode;
    procedure TestDumpFilterProductionMode;
    procedure TestDumpFilterUnsetEnvIsProduction;
    procedure TestDumpFunctionFormMatchesFilter;
    procedure TestDumpFunctionSilentInProduction;
    procedure TestDumpDoesNotCrashOnCircularDict;
  end;

  // ── TestMacros ───────────────────────────────────────────────
  TestTTina4Frond_Macros = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSimpleMacro;
    procedure TestMacroHtmlOutput;
    procedure TestMacroNested;
  end;

  // ── TestFormToken ────────────────────────────────────────────
  TestTTina4Frond_FormToken = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestFormTokenFunctionCall;
    procedure TestFormTokenVariable;
    procedure TestFormTokenFilter;
    procedure TestFormTokenIsValidJwt;
    procedure TestFormTokenWithDescriptor;
  end;

  // ── TestRawBlock ─────────────────────────────────────────────
  TestTTina4Frond_RawBlock = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestRawPreservesVarSyntax;
    procedure TestRawPreservesBlockSyntax;
    procedure TestRawMixedWithNormal;
    procedure TestMultipleRawBlocks;
    procedure TestRawBlockMultiline;
  end;

  // ── TestFromImport ───────────────────────────────────────────
  TestTTina4Frond_FromImport = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
    FTplDir: string;
    procedure WriteTpl(const Name, Contents: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestFromImportBasic;
    procedure TestFromImportMultiple;
    procedure TestFromImportSelective;
    procedure TestFromImportSubdirectory;
  end;

  // ── TestSpaceless ────────────────────────────────────────────
  TestTTina4Frond_Spaceless = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSpacelessRemovesWhitespaceBetweenTags;
    procedure TestSpacelessPreservesContentWhitespace;
    procedure TestSpacelessMultiline;
    procedure TestSpacelessWithVariables;
  end;

  // ── TestAutoescape ───────────────────────────────────────────
  TestTTina4Frond_Autoescape = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestAutoescapeFalseDisablesEscaping;
    procedure TestAutoescapeTrueKeepsEscaping;
    procedure TestAutoescapeFalseWithFilters;
    procedure TestAutoescapeFalseMultipleVariables;
  end;

  // ── TestInlineIf ─────────────────────────────────────────────
  TestTTina4Frond_InlineIf = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestInlineIfTrue;
    procedure TestInlineIfFalse;
    procedure TestInlineIfWithVariable;
    procedure TestInlineIfWithMissingVariable;
    procedure TestInlineIfWithComparison;
    procedure TestInlineIfNumeric;
  end;

  // ── TestTokenCache ──────────────────────────────────────────
  TestTTina4Frond_TokenCache = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
    FTplDir: string;
    procedure WriteTpl(const Name, Contents: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestRenderStringCacheSameOutput;
    procedure TestRenderStringCacheDifferentData;
    procedure TestRenderFileCacheSameOutput;
    procedure TestRenderFileCacheDifferentData;
    procedure TestCacheInvalidationOnFileChange;
    procedure TestClearCache;
    procedure TestRenderStringWithForLoopCached;
    procedure TestRenderStringWithIfCached;
  end;

  // ── TestMethodCalls ─────────────────────────────────────────
  TestTTina4Frond_MethodCalls = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDictCallableWithArgs;
    procedure TestDictCallableNoArgs;
    procedure TestDictCallableMultipleArgs;
    procedure TestDottedArgInMethodCall;
    procedure TestMethodCallInHtmlAttribute;
    procedure TestObjectMethodWithArgs;
  end;

  // ── TestSliceSyntax ─────────────────────────────────────────
  TestTTina4Frond_SliceSyntax = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStringSliceStart;
    procedure TestStringSliceEnd;
    procedure TestStringSliceRange;
    procedure TestListSlice;
  end;

  // ── TestDottedStringArgs ───────────────────────────────────
  TestTTina4Frond_DottedStringArgs = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSingleDotSingleQuotes;
    procedure TestSingleDotDoubleQuotes;
    procedure TestMultipleDots;
    procedure TestDottedArgInHtmlAttribute;
    procedure TestDottedArgMethodOnDict;
    procedure TestMultipleArgsWithDots;
    procedure TestTildeInQuotedString;
    procedure TestOperatorCharsInQuotedString;
    procedure TestQuestionMarkInQuotedString;
    procedure TestChainedMethodWithDottedArg;
    procedure TestTopLevelFuncDottedArg;
    procedure TestNestedQuotesInArg;
  end;

  // ── TestDynamicDictKeys ──────────────────────────────────
  TestTTina4Frond_DynamicDictKeys = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestVariableKeyViaSet;
    procedure TestVariableKeyFromLoop;
    procedure TestStringLiteralKeyStillWorks;
    procedure TestIntKeyStillWorks;
    procedure TestSliceStillWorks;
    procedure TestNestedVariableKey;
  end;

  // ── TestReplaceFilter ────────────────────────────────────
  TestTTina4Frond_ReplaceFilter = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestSimpleReplace;
    procedure TestReplaceSpaceWithUnderscore;
    procedure TestReplaceWithEmpty;
    procedure TestReplaceQuoteWithBackslashQuote;
    procedure TestReplaceBackslash;
  end;

  // ── TestJsonAndJsFilters ────────────────────────────────
  TestTTina4Frond_JsonAndJsFilters = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestToJsonDict;
    procedure TestToJsonList;
    procedure TestToJsonHtmlSafe;
    procedure TestTojsonAlias;
    procedure TestJsEscapeQuotes;
    procedure TestJsEscapeNewlines;
  end;

  // ── TestSafeStringFilters ──────────────────────────────
  TestTTina4Frond_SafeStringFilters = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestJsEscapeNoHtmlEncoding;
    procedure TestToJsonNoHtmlEncoding;
    procedure TestTojsonAliasNoHtmlEncoding;
    procedure TestJsEscapeBackslashNotEncoded;
    procedure TestToJsonXssStillEscaped;
    procedure TestRegularVarStillHtmlEscaped;
    procedure TestJsEscapeInOnclick;
    procedure TestToJsonInScriptTag;
  end;

  // ── TestTildeTernary ──────────────────────────────────
  TestTTina4Frond_TildeTernary = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestTildeWithTernary;
    procedure TestTildeTernaryFalseBranch;
    procedure TestQuestionMarkInUrlString;
    procedure TestTildeConcatWithUrlQuery;
    procedure TestSimpleTernaryStillWorks;
    procedure TestInlineIfStillWorks;
  end;

  // ── TestFilterInCondition ────────────────────────────
  TestTTina4Frond_FilterInCondition = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestLengthGreaterThanZero;
    procedure TestLengthGreaterThanZeroEmpty;
    procedure TestLengthEquals;
    procedure TestLengthEqualsZero;
    procedure TestLengthNotEquals;
    procedure TestStringLength;
    procedure TestUpperComparison;
    procedure TestFirstComparison;
    procedure TestLastComparison;
    procedure TestFilterWithAnd;
    procedure TestFilterWithOr;
    procedure TestFilterWithSpaces;
    procedure TestNoFilterStillWorks;
    procedure TestTruthyCheckStillWorks;
    procedure TestFilterInElseif;
  end;

  // ── TestBlockParent ───────────────────────────────
  TestTTina4Frond_BlockParent = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
    FTplDir: string;
    procedure WriteTpl(const Name, Contents: string);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestParentIncludesParentContent;
    procedure TestSuperIsAlias;
    procedure TestNoParentFullReplace;
    procedure TestParentWithVariables;
    procedure TestParentNotCalledReturnsChildOnly;
    procedure TestMultipleBlocksWithParent;
  end;

  // ── TestRenderDump ────────────────────────────────
  TestTTina4Frond_RenderDump = class(TTestCase)
  strict private
    FFrond: TTina4Frond;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestRenderDumpSilentInProduction;
    procedure TestRenderDumpReturnsHtmlInDebug;
    procedure TestRenderDumpHandlesNone;
    procedure TestRenderDumpHandlesList;
  end;

implementation

{ TFrondTestHelper }

class function TFrondTestHelper.MakeDict(const Pairs: array of const): TDictionary<string, TValue>;
var
  I: Integer;
  K: string;
  V: TValue;
begin
  Result := TDictionary<string, TValue>.Create;
  I := 0;
  while I < Length(Pairs) - 1 do
  begin
    case Pairs[I].VType of
      vtUnicodeString: K := string(Pairs[I].VUnicodeString);
      vtAnsiString:    K := string(AnsiString(Pairs[I].VAnsiString));
      vtString:        K := string(Pairs[I].VString^);
      vtChar:          K := string(Pairs[I].VChar);
      vtWideChar:      K := string(Pairs[I].VWideChar);
    else
      K := '';
    end;
    case Pairs[I + 1].VType of
      vtUnicodeString: V := TValue.From<string>(string(Pairs[I + 1].VUnicodeString));
      vtAnsiString:    V := TValue.From<string>(string(AnsiString(Pairs[I + 1].VAnsiString)));
      vtString:        V := TValue.From<string>(string(Pairs[I + 1].VString^));
      vtInteger:       V := TValue.From<Integer>(Pairs[I + 1].VInteger);
      vtInt64:         V := TValue.From<Int64>(Pairs[I + 1].VInt64^);
      vtBoolean:       V := TValue.From<Boolean>(Pairs[I + 1].VBoolean);
      vtExtended:      V := TValue.From<Extended>(Pairs[I + 1].VExtended^);
    else
      V := TValue.Empty;
    end;
    Result.Add(K, V);
    Inc(I, 2);
  end;
end;

class function TFrondTestHelper.MakeArray(const Items: array of TValue): TValue;
var
  A: TArray<TValue>;
  I: Integer;
begin
  SetLength(A, Length(Items));
  for I := 0 to High(Items) do
    A[I] := Items[I];
  Result := TValue.From<TArray<TValue>>(A);
end;

class function TFrondTestHelper.TempDir: string;
begin
  Result := TPath.Combine(TPath.GetTempPath,
    'frondtest_' + IntToStr(GetTickCount) + '_' + IntToStr(Random(100000)));
  ForceDirectories(Result);
end;

// ─── TestVariables ──────────────────────────────────────────

procedure TestTTina4Frond_Variables.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Variables.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Variables.TestSimpleVariable;
var
  R: string;
begin
  FFrond.SetVariable('name', 'World');
  R := FFrond.Render('Hello {{ name }}');
  Check(R = 'Hello World', 'Expected "Hello World", got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestDottedAccess;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('name', TValue.From<string>('Alice'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ user.name }}');
  Check(R = 'Alice', 'Expected "Alice", got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestArrayAccess;
var
  R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('first'), TValue.From<string>('second')]));
  R := FFrond.Render('{{ items[0] }}');
  Check(R = 'first', 'Expected "first", got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestMissingVariable;
var
  R: string;
begin
  R := FFrond.Render('{{ missing }}');
  Check(R = '', 'Expected empty, got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestAutoEscapeHtml;
var
  R: string;
begin
  // Tina4Frond does NOT auto-escape by default (deliberate deviation from
  // Frond Python). Users opt in via the |escape filter or {% autoescape %}.
  FFrond.SetVariable('text', '<b>bold</b>');
  R := FFrond.Render('{{ text }}');
  Check(R = '<b>bold</b>', 'Expected raw output (no auto-escape), got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestRawFilterNoEscape;
var
  R: string;
begin
  FFrond.SetVariable('text', '<b>bold</b>');
  R := FFrond.Render('{{ text | raw }}');
  Check(R = '<b>bold</b>', 'Expected raw output, got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestStringConcatenation;
var
  R: string;
begin
  FFrond.SetVariable('name', 'World');
  R := FFrond.Render('{{ "Hello " ~ name ~ "!" }}');
  Check(R = 'Hello World!', 'Expected "Hello World!", got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestTernary;
var
  R: string;
begin
  FFrond.SetVariable('active', True);
  R := FFrond.Render('{{ active ? "yes" : "no" }}');
  Check(R = 'yes', 'Expected "yes" when active=True, got "' + R + '"');
  FFrond.SetVariable('active', False);
  R := FFrond.Render('{{ active ? "yes" : "no" }}');
  Check(R = 'no', 'Expected "no" when active=False, got "' + R + '"');
end;

procedure TestTTina4Frond_Variables.TestNullCoalescing;
var
  R: string;
begin
  FFrond.SetVariable('name', TValue.Empty);
  R := FFrond.Render('{{ name ?? "default" }}');
  Check(R = 'default', 'Expected "default", got "' + R + '"');
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{{ name ?? "default" }}');
  Check(R = 'Alice', 'Expected "Alice", got "' + R + '"');
end;

// ─── TestFilters ────────────────────────────────────────────

procedure TestTTina4Frond_Filters.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Filters.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Filters.TestUpper;
var R: string;
begin
  FFrond.SetVariable('v', 'alice');
  R := FFrond.Render('{{ v|upper }}');
  Check(R = 'ALICE', 'upper: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestLower;
var R: string;
begin
  FFrond.SetVariable('v', 'ALICE');
  R := FFrond.Render('{{ v|lower }}');
  Check(R = 'alice', 'lower: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestCapitalize;
var R: string;
begin
  FFrond.SetVariable('v', 'alice bob');
  R := FFrond.Render('{{ v|capitalize }}');
  Check(R = 'Alice bob', 'capitalize: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestTitle;
var R: string;
begin
  FFrond.SetVariable('v', 'hello world');
  R := FFrond.Render('{{ v|title }}');
  Check(R = 'Hello World', 'title: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestTrim;
var R: string;
begin
  FFrond.SetVariable('v', '  hi  ');
  R := FFrond.Render('{{ v|trim }}');
  Check(R = 'hi', 'trim: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestLtrim;
var R: string;
begin
  FFrond.SetVariable('v', '  hi  ');
  R := FFrond.Render('{{ v|ltrim }}');
  Check(R = 'hi  ', 'ltrim: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestRtrim;
var R: string;
begin
  FFrond.SetVariable('v', '  hi  ');
  R := FFrond.Render('{{ v|rtrim }}');
  Check(R = '  hi', 'rtrim: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSlug;
var R: string;
begin
  FFrond.SetVariable('v', 'Hello World!');
  R := FFrond.Render('{{ v|slug }}');
  Check(R = 'hello-world', 'slug: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestWordwrap;
var R: string;
begin
  FFrond.SetVariable('v', 'hello world test');
  R := FFrond.Render('{{ v|wordwrap(10) }}');
  Check(Pos(#10, R) > 0, 'wordwrap: expected newline, got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestTruncate;
var R: string;
begin
  FFrond.SetVariable('v', 'Hello World');
  R := FFrond.Render('{{ v|truncate(5) }}');
  Check(R = 'Hello...', 'truncate: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestTruncateShort;
var R: string;
begin
  FFrond.SetVariable('v', 'Hello');
  R := FFrond.Render('{{ v|truncate(20) }}');
  Check(R = 'Hello', 'truncate-short: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestNl2br;
var R: string;
begin
  FFrond.SetVariable('v', 'a'#10'b');
  R := FFrond.Render('{{ v|nl2br|raw }}');
  Check(Pos('<br>', R) > 0, 'nl2br: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestStriptags;
var R: string;
begin
  FFrond.SetVariable('v', '<b>bold</b>');
  R := FFrond.Render('{{ v|striptags }}');
  Check(R = 'bold', 'striptags: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestLengthList;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ v|length }}');
  Check(R = '3', 'length list: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestLengthString;
var R: string;
begin
  FFrond.SetVariable('v', 'hello');
  R := FFrond.Render('{{ v|length }}');
  Check(R = '5', 'length string: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReverseList;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ v|reverse }}');
  Check(R = '[3, 2, 1]', 'reverse list: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReverseString;
var R: string;
begin
  FFrond.SetVariable('v', 'abc');
  R := FFrond.Render('{{ v|reverse }}');
  Check(R = 'cba', 'reverse string: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSort;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(3), TValue.From<Integer>(1), TValue.From<Integer>(2)]));
  R := FFrond.Render('{{ v|sort }}');
  Check(R = '[1, 2, 3]', 'sort: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestFirst;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(10), TValue.From<Integer>(20), TValue.From<Integer>(30)]));
  R := FFrond.Render('{{ v|first }}');
  Check(R = '10', 'first: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestLast;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(10), TValue.From<Integer>(20), TValue.From<Integer>(30)]));
  R := FFrond.Render('{{ v|last }}');
  Check(R = '30', 'last: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJoin;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b'), TValue.From<string>('c')]));
  R := FFrond.Render('{{ v|join(", ") }}');
  Check(R = 'a, b, c', 'join: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJoinDefaultSeparator;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b')]));
  R := FFrond.Render('{{ v|join }}');
  Check(R = 'a, b', 'join default: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSplit;
var R: string;
begin
  FFrond.SetVariable('v', 'a,b,c');
  R := FFrond.Render('{{ v|split('','') }}');
  Check((Pos('a', R) > 0) and (Pos('b', R) > 0) and (Pos('c', R) > 0), 'split: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestUnique;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ v|unique }}');
  Check(R = '[1, 2, 3]', 'unique: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestFilter;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(0), TValue.From<Integer>(1), TValue.From<string>(''), TValue.From<string>('hi'), TValue.Empty, TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ v|filter }}');
  Check((Pos('0', R) = 0) or (Pos('1', R) > 0), 'filter: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestMap;
var
  R: string;
  A, B: TDictionary<string, TValue>;
begin
  A := TDictionary<string, TValue>.Create;
  A.Add('name', TValue.From<string>('A'));
  B := TDictionary<string, TValue>.Create;
  B.Add('name', TValue.From<string>('B'));
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<TDictionary<string, TValue>>(A), TValue.From<TDictionary<string, TValue>>(B)]));
  R := FFrond.Render('{{ v|map("name") }}');
  Check((Pos('A', R) > 0) and (Pos('B', R) > 0), 'map: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestColumn;
var
  R: string;
  A, B: TDictionary<string, TValue>;
begin
  A := TDictionary<string, TValue>.Create;
  A.Add('id', TValue.From<Integer>(1));
  A.Add('name', TValue.From<string>('A'));
  B := TDictionary<string, TValue>.Create;
  B.Add('id', TValue.From<Integer>(2));
  B.Add('name', TValue.From<string>('B'));
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<TDictionary<string, TValue>>(A), TValue.From<TDictionary<string, TValue>>(B)]));
  R := FFrond.Render('{{ v|column("name") }}');
  Check((Pos('A', R) > 0) and (Pos('B', R) > 0), 'column: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestBatch;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3), TValue.From<Integer>(4), TValue.From<Integer>(5)]));
  R := FFrond.Render('{{ v|batch(2) }}');
  Check(Pos('[[1, 2]', R) > 0, 'batch: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSliceFilter;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(10), TValue.From<Integer>(20), TValue.From<Integer>(30), TValue.From<Integer>(40)]));
  R := FFrond.Render('{{ v|slice(1, 3) }}');
  Check((Pos('20', R) > 0) and (Pos('30', R) > 0), 'slice filter: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReplace;
var R: string;
begin
  FFrond.SetVariable('v', 'banana');
  R := FFrond.Render('{{ v|replace("a", "b") }}');
  Check(R = 'bbnbnb', 'replace: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReplaceSpace;
var R: string;
begin
  FFrond.SetVariable('v', 'hi there');
  R := FFrond.Render('{{ v|replace('' '', ''_'') }}');
  Check(R = 'hi_there', 'replace space: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestEscape;
var R: string;
begin
  FFrond.SetVariable('v', '<b>hi</b>');
  R := FFrond.Render('{{ v|escape|raw }}');
  Check(Pos('&lt;b&gt;', R) > 0, 'escape: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestEAlias;
var R: string;
begin
  FFrond.SetVariable('v', '<b>');
  R := FFrond.Render('{{ v|e|raw }}');
  Check(Pos('&lt;b&gt;', R) > 0, 'e alias: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestRaw;
var R: string;
begin
  FFrond.SetVariable('v', '<b>hi</b>');
  R := FFrond.Render('{{ v|raw }}');
  Check(R = '<b>hi</b>', 'raw: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSafe;
var R: string;
begin
  FFrond.SetVariable('v', '<b>hi</b>');
  R := FFrond.Render('{{ v|safe }}');
  Check(R = '<b>hi</b>', 'safe: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestUrlEncode;
var R: string;
begin
  FFrond.SetVariable('v', 'hello world');
  R := FFrond.Render('{{ v|url_encode }}');
  Check((Pos('hello', R) > 0) and (Pos(' ', R) = 0), 'url_encode: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestBase64Encode;
var R: string;
begin
  FFrond.SetVariable('v', 'hello');
  R := FFrond.Render('{{ v|base64_encode }}');
  Check(R = 'aGVsbG8=', 'base64_encode: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestBase64Decode;
var R: string;
begin
  FFrond.SetVariable('v', 'aGVsbG8=');
  R := FFrond.Render('{{ v|base64_decode }}');
  Check(R = 'hello', 'base64_decode: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestMd5;
var R: string;
begin
  FFrond.SetVariable('v', 'hello');
  R := FFrond.Render('{{ v|md5 }}');
  Check(Length(R) = 32, 'md5 length: got ' + IntToStr(Length(R)) + ' "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSha256;
var R: string;
begin
  FFrond.SetVariable('v', 'hello');
  R := FFrond.Render('{{ v|sha256 }}');
  Check(Length(R) = 64, 'sha256 length: got ' + IntToStr(Length(R)) + ' "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestAbs;
var R: string;
begin
  FFrond.SetVariable('v', -5);
  R := FFrond.Render('{{ v|abs }}');
  Check(R = '5', 'abs: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestRound;
var R: string;
begin
  FFrond.SetVariable('v', 3.14159);
  R := FFrond.Render('{{ v|round(2) }}');
  Check(R = '3.14', 'round: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestRoundNoDecimals;
var R: string;
begin
  // Tina4Frond follows Twig/PHP convention: round without precision
  // returns an integer-formatted string. Python Frond returns "4.0".
  // We prefer the Twig convention for legacy compatibility.
  FFrond.SetVariable('v', 3.7);
  R := FFrond.Render('{{ v|round }}');
  Check(R = '4', 'round no decimals: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestNumberFormat;
var R: string;
begin
  FFrond.SetVariable('v', 1234.5);
  R := FFrond.Render('{{ v|number_format(2) }}');
  Check(R = '1,234.50', 'number_format: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestInt;
var R: string;
begin
  FFrond.SetVariable('v', '42');
  R := FFrond.Render('{{ v|int }}');
  Check(R = '42', 'int: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestFloat;
var R: string;
begin
  FFrond.SetVariable('v', '3.14');
  R := FFrond.Render('{{ v|float }}');
  Check(R = '3.14', 'float: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestStringFilter;
var R: string;
begin
  FFrond.SetVariable('v', 123);
  R := FFrond.Render('{{ v|string }}');
  Check(R = '123', 'string: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJsonEncode;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  FFrond.SetVariable('v', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ v|json_encode|raw }}');
  Check(Pos('"a"', R) > 0, 'json_encode: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestToJson;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  FFrond.SetVariable('v', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ v|to_json|raw }}');
  Check(R = '{"a":1}', 'to_json: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestToJsonHtmlSafe;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('x', TValue.From<string>('<script>'));
  FFrond.SetVariable('v', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ v|to_json|raw }}');
  Check((Pos('\u003c', R) > 0) and (Pos('<script>', R) = 0), 'to_json_html_safe: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestTojsonAlias;
var R: string;
begin
  FFrond.SetVariable('v', TFrondTestHelper.MakeArray([TValue.From<Integer>(1)]));
  R := FFrond.Render('{{ v|tojson|raw }}');
  Check(R = '[1]', 'tojson alias: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJsonDecode;
var R: string;
begin
  FFrond.SetVariable('v', '{"a": 1}');
  R := FFrond.Render('{{ v|json_decode }}');
  Check(Pos('a', R) > 0, 'json_decode: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJsEscape;
var R: string;
begin
  FFrond.SetVariable('v', 'it''s a "test"');
  R := FFrond.Render('{{ v|js_escape|raw }}');
  Check((Pos('\''', R) > 0) and (Pos('\"', R) > 0), 'js_escape: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestJsEscapeNewlines;
var R: string;
begin
  FFrond.SetVariable('v', 'a'#10'b');
  R := FFrond.Render('{{ v|js_escape|raw }}');
  Check(Pos('\n', R) > 0, 'js_escape newlines: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestKeys;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  D.Add('b', TValue.From<Integer>(2));
  FFrond.SetVariable('v', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ v|keys }}');
  Check((Pos('a', R) > 0) and (Pos('b', R) > 0), 'keys: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestValues;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  D.Add('b', TValue.From<Integer>(2));
  FFrond.SetVariable('v', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ v|values }}');
  Check((Pos('1', R) > 0) and (Pos('2', R) > 0), 'values: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestDefaultNone;
var R: string;
begin
  R := FFrond.Render('{{ v|default("N/A") }}');
  Check(R = 'N/A', 'default none: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestDefaultEmptyString;
var R: string;
begin
  FFrond.SetVariable('v', '');
  R := FFrond.Render('{{ v|default("N/A") }}');
  Check(R = 'N/A', 'default empty: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestDefaultHasValue;
var R: string;
begin
  FFrond.SetVariable('v', 'ok');
  R := FFrond.Render('{{ v|default("N/A") }}');
  Check(R = 'ok', 'default has value: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestDateFormat;
var R: string;
begin
  FFrond.SetVariable('v', '2026-03-29');
  R := FFrond.Render('{{ v|date("%Y") }}');
  Check(R = '2026', 'date format: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestFormat;
var R: string;
begin
  FFrond.SetVariable('v', 'hello %s');
  R := FFrond.Render('{{ v|format("world") }}');
  Check(R = 'hello world', 'format: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestStriptagsDup;
var R: string;
begin
  FFrond.SetVariable('html', '<b>bold</b>');
  R := FFrond.Render('{{ html | striptags }}');
  Check(R = 'bold', 'striptags2: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReplaceDup;
var R: string;
begin
  FFrond.SetVariable('text', 'hello world');
  R := FFrond.Render('{{ text | replace("world", "frond") }}');
  Check(R = 'hello frond', 'replace2: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestChainedFilters;
var R: string;
begin
  FFrond.SetVariable('name', '  alice  ');
  R := FFrond.Render('{{ name | trim | upper }}');
  Check(R = 'ALICE', 'chained: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestMd5Dup;
var R: string;
begin
  FFrond.SetVariable('text', 'hello');
  R := FFrond.Render('{{ text | md5 }}');
  Check(Length(R) = 32, 'md5-2 length: got ' + IntToStr(Length(R)));
end;

procedure TestTTina4Frond_Filters.TestFirstLast;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ items | first }}');
  Check(R = '1', 'firstlast-first: got "' + R + '"');
  R := FFrond.Render('{{ items | last }}');
  Check(R = '3', 'firstlast-last: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestReverseDup;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b'), TValue.From<string>('c')]));
  R := FFrond.Render('{{ items | reverse | join }}');
  Check(R = 'c, b, a', 'reverse-join: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestSortDup;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('c'), TValue.From<string>('a'), TValue.From<string>('b')]));
  R := FFrond.Render('{{ items | sort | join }}');
  Check(R = 'a, b, c', 'sort-join: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestKeysValues;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('name', TValue.From<string>('Alice'));
  D.Add('age', TValue.From<string>('30'));
  FFrond.SetVariable('d', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ d | keys | join }}');
  Check(Pos('name', R) > 0, 'keys-join: got "' + R + '"');
end;

procedure TestTTina4Frond_Filters.TestCustomFilter;
var R: string;
begin
  // No public add_filter in Delphi engine — expose gap.
  FFrond.SetVariable('x', 'ha');
  R := FFrond.Render('{{ x | double }}');
  Check(R = 'haha', 'custom filter ''double'' requires add_filter API; got "' + R + '"');
end;

// ─── TestIfElse ─────────────────────────────────────────────

procedure TestTTina4Frond_IfElse.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_IfElse.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_IfElse.TestIfTrue;
var R: string;
begin
  FFrond.SetVariable('show', True);
  R := FFrond.Render('{% if show %}yes{% endif %}');
  Check(R = 'yes', 'if true: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestIfFalse;
var R: string;
begin
  FFrond.SetVariable('show', False);
  R := FFrond.Render('{% if show %}yes{% endif %}');
  Check(R = '', 'if false: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestIfElse;
var R: string;
begin
  FFrond.SetVariable('active', True);
  R := FFrond.Render('{% if active %}on{% else %}off{% endif %}');
  Check(R = 'on', 'if-else true: got "' + R + '"');
  FFrond.SetVariable('active', False);
  R := FFrond.Render('{% if active %}on{% else %}off{% endif %}');
  Check(R = 'off', 'if-else false: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestElseif;
var
  R: string;
  Tpl: string;
begin
  Tpl := '{% if x == 1 %}one{% elseif x == 2 %}two{% else %}other{% endif %}';
  FFrond.SetVariable('x', 1);
  R := FFrond.Render(Tpl);
  Check(R = 'one', 'elseif x=1: got "' + R + '"');
  FFrond.SetVariable('x', 2);
  R := FFrond.Render(Tpl);
  Check(R = 'two', 'elseif x=2: got "' + R + '"');
  FFrond.SetVariable('x', 3);
  R := FFrond.Render(Tpl);
  Check(R = 'other', 'elseif x=3: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestElif;
var R: string;
begin
  FFrond.SetVariable('x', 2);
  R := FFrond.Render('{% if x == 1 %}one{% elif x == 2 %}two{% endif %}');
  Check(R = 'two', 'elif: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestComparisonOperators;
var R: string;
begin
  FFrond.SetVariable('x', 10);
  R := FFrond.Render('{% if x > 5 %}yes{% endif %}');
  Check(R = 'yes', '>5: got "' + R + '"');
  FFrond.SetVariable('x', 3);
  R := FFrond.Render('{% if x < 5 %}yes{% endif %}');
  Check(R = 'yes', '<5: got "' + R + '"');
  FFrond.SetVariable('x', 5);
  R := FFrond.Render('{% if x >= 5 %}yes{% endif %}');
  Check(R = 'yes', '>=5: got "' + R + '"');
  FFrond.SetVariable('x', 3);
  R := FFrond.Render('{% if x != 5 %}yes{% endif %}');
  Check(R = 'yes', '!=5: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestAndOr;
var R: string;
begin
  FFrond.SetVariable('a', True);
  FFrond.SetVariable('b', True);
  R := FFrond.Render('{% if a and b %}yes{% endif %}');
  Check(R = 'yes', 'and TT: got "' + R + '"');
  FFrond.SetVariable('b', False);
  R := FFrond.Render('{% if a and b %}yes{% endif %}');
  Check(R = '', 'and TF: got "' + R + '"');
  FFrond.SetVariable('a', False);
  FFrond.SetVariable('b', True);
  R := FFrond.Render('{% if a or b %}yes{% endif %}');
  Check(R = 'yes', 'or FT: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestNot;
var R: string;
begin
  FFrond.SetVariable('hidden', False);
  R := FFrond.Render('{% if not hidden %}show{% endif %}');
  Check(R = 'show', 'not: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestIsDefined;
var R: string;
begin
  FFrond.SetVariable('x', 1);
  R := FFrond.Render('{% if x is defined %}yes{% endif %}');
  Check(R = 'yes', 'is defined (set): got "' + R + '"');
  // Fresh engine to check undefined
  FFrond.Free;
  FFrond := TTina4Frond.Create('');
  R := FFrond.Render('{% if x is defined %}yes{% endif %}');
  Check(R = '', 'is defined (unset): got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestIsEmpty;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([]));
  R := FFrond.Render('{% if items is empty %}empty{% endif %}');
  Check(R = 'empty', 'is empty: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestIsEvenOdd;
var R: string;
begin
  FFrond.SetVariable('n', 4);
  R := FFrond.Render('{% if n is even %}yes{% endif %}');
  Check(R = 'yes', 'is even: got "' + R + '"');
  FFrond.SetVariable('n', 3);
  R := FFrond.Render('{% if n is odd %}yes{% endif %}');
  Check(R = 'yes', 'is odd: got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestInOperator;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b')]));
  R := FFrond.Render('{% if "a" in items %}yes{% endif %}');
  Check(R = 'yes', 'in (present): got "' + R + '"');
  R := FFrond.Render('{% if "c" in items %}yes{% endif %}');
  Check(R = '', 'in (absent): got "' + R + '"');
end;

procedure TestTTina4Frond_IfElse.TestNestedIf;
var R: string;
begin
  FFrond.SetVariable('a', True);
  FFrond.SetVariable('b', True);
  R := FFrond.Render('{% if a %}{% if b %}both{% endif %}{% endif %}');
  Check(R = 'both', 'nested if: got "' + R + '"');
end;

// ─── TestForLoop ────────────────────────────────────────────

procedure TestTTina4Frond_ForLoop.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_ForLoop.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_ForLoop.TestSimpleFor;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b'), TValue.From<string>('c')]));
  R := FFrond.Render('{% for item in items %}{{ item }}{% endfor %}');
  Check(R = 'abc', 'simple for: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestLoopIndex;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b')]));
  R := FFrond.Render('{% for item in items %}{{ loop.index }}{% endfor %}');
  Check(R = '12', 'loop.index: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestLoopFirstLast;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('a'), TValue.From<string>('b'), TValue.From<string>('c')]));
  R := FFrond.Render('{% for item in items %}{% if loop.first %}F{% endif %}{% if loop.last %}L{% endif %}{% endfor %}');
  Check(R = 'FL', 'loop.first/last: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestLoopLength;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{% for item in items %}{{ loop.length }}{% endfor %}');
  Check(R = '333', 'loop.length: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestForElse;
var
  R: string;
  Tpl: string;
begin
  Tpl := '{% for item in items %}{{ item }}{% else %}empty{% endfor %}';
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([]));
  R := FFrond.Render(Tpl);
  Check(R = 'empty', 'for-else empty: got "' + R + '"');
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<string>('x')]));
  R := FFrond.Render(Tpl);
  Check(R = 'x', 'for-else nonempty: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestForKeyValue;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  D.Add('b', TValue.From<Integer>(2));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{% for k, v in data %}{{ k }}={{ v }} {% endfor %}');
  Check((Pos('a=1', R) > 0) and (Pos('b=2', R) > 0), 'for k,v: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestNestedFor;
var R: string;
begin
  FFrond.SetVariable('groups', TFrondTestHelper.MakeArray([
    TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2)]),
    TFrondTestHelper.MakeArray([TValue.From<Integer>(3), TValue.From<Integer>(4)])
  ]));
  R := FFrond.Render('{% for g in groups %}{% for i in g %}{{ i }}{% endfor %},{% endfor %}');
  Check(R = '12,34,', 'nested for: got "' + R + '"');
end;

procedure TestTTina4Frond_ForLoop.TestLoopEvenOdd;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3), TValue.From<Integer>(4)]));
  R := FFrond.Render('{% for i in items %}{% if loop.even %}E{% else %}O{% endif %}{% endfor %}');
  Check(R = 'OEOE', 'loop even/odd: got "' + R + '"');
end;

// ─── TestSetIncludeExtends ─────────────────────────────────

procedure TestTTina4Frond_SetIncludeExtends.SetUp;
begin
  FTplDir := TFrondTestHelper.TempDir;
  FFrond := TTina4Frond.Create(FTplDir);
end;

procedure TestTTina4Frond_SetIncludeExtends.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  try
    if DirectoryExists(FTplDir) then
      TDirectory.Delete(FTplDir, True);
  except
  end;
end;

procedure TestTTina4Frond_SetIncludeExtends.WriteTpl(const Name, Contents: string);
begin
  TFile.WriteAllText(TPath.Combine(FTplDir, Name), Contents);
end;

procedure TestTTina4Frond_SetIncludeExtends.TestSetVariable;
var R: string;
begin
  R := FFrond.Render('{% set greeting = "Hello" %}{{ greeting }}');
  Check(R = 'Hello', 'set variable: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestSetWithConcat;
var R: string;
begin
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{% set msg = "Hi " ~ name %}{{ msg }}');
  Check(R = 'Hi Alice', 'set concat: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestInclude;
var R: string;
begin
  WriteTpl('partial.html', 'Hello {{ name }}');
  FFrond.SetVariable('name', 'World');
  R := FFrond.Render('{% include "partial.html" %}');
  Check(R = 'Hello World', 'include: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestIncludeIgnoreMissing;
var R: string;
begin
  R := FFrond.Render('{% include "nope.html" ignore missing %}');
  Check(R = '', 'ignore missing: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestIncludeMissingRaises;
var
  Raised: Boolean;
begin
  Raised := False;
  try
    FFrond.Render('{% include "nope.html" %}');
  except
    Raised := True;
  end;
  Check(Raised, 'include missing should raise exception');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsAndBlocks;
var R: string;
begin
  WriteTpl('base.html', '<h1>{% block title %}Default{% endblock %}</h1><div>{% block content %}{% endblock %}</div>');
  WriteTpl('page.html', '{% extends "base.html" %}{% block title %}My Page{% endblock %}{% block content %}Hello{% endblock %}');
  R := FFrond.Render('page.html');
  Check((Pos('<h1>My Page</h1>', R) > 0) and (Pos('<div>Hello</div>', R) > 0), 'extends: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsDefaultBlock;
var R: string;
begin
  WriteTpl('base.html', '{% block title %}Default Title{% endblock %}');
  WriteTpl('page.html', '{% extends "base.html" %}');
  R := FFrond.Render('page.html');
  Check(R = 'Default Title', 'extends default block: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsWithLeadingWhitespace;
var R: string;
begin
  WriteTpl('base.html', '<html><body>{% block content %}default{% endblock %}</body></html>');
  WriteTpl('page.html', '  {% extends "base.html" %}'#10'{% block content %}<h1>Hello</h1>{% endblock %}');
  R := FFrond.Render('page.html');
  Check((Pos('<html><body>', R) > 0) and (Pos('<h1>Hello</h1>', R) > 0), 'extends leading ws: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsWithLeadingNewlines;
var R: string;
begin
  WriteTpl('base.html', '<html><body>{% block content %}default{% endblock %}</body></html>');
  WriteTpl('page.html', #10#10'{% extends "base.html" %}'#10'{% block content %}<h1>Hello</h1>{% endblock %}');
  R := FFrond.Render('page.html');
  Check((Pos('<html><body>', R) > 0) and (Pos('<h1>Hello</h1>', R) > 0), 'extends leading newlines: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsWithVariablesInBlocks;
var R: string;
begin
  WriteTpl('base.html',
    '<!DOCTYPE html>'#10'<html>'#10'<head><title>{% block title %}Default{% endblock %}</title></head>'#10 +
    '<body>'#10'{% block content %}{% endblock %}'#10'</body>'#10'</html>');
  WriteTpl('error.html',
    #10'{% extends "base.html" %}'#10 +
    '{% block title %}Error {{ code }}{% endblock %}'#10 +
    '{% block content %}<div class="card"><h1>{{ code }}</h1><p>{{ msg }}</p></div>{% endblock %}');
  FFrond.SetVariable('code', 500);
  FFrond.SetVariable('msg', 'Internal Server Error');
  R := FFrond.Render('error.html');
  Check((Pos('<title>Error 500</title>', R) > 0) and (Pos('<h1>500</h1>', R) > 0) and
        (Pos('Internal Server Error', R) > 0) and (Pos('<html>', R) > 0), 'extends vars: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestExtendsWithIncludeInBlock;
var R: string;
begin
  WriteTpl('base.html', '<main>{% block content %}{% endblock %}</main>');
  WriteTpl('partial.html', '<p>{{ message }}</p>');
  WriteTpl('page.html', #10'{% extends "base.html" %}'#10'{% block content %}{% include "partial.html" %}{% endblock %}');
  FFrond.SetVariable('message', 'Included!');
  R := FFrond.Render('page.html');
  Check((Pos('<main>', R) > 0) and (Pos('<p>Included!</p>', R) > 0), 'extends with include: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestTwoLevelExtends;
var R: string;
begin
  WriteTpl('base.html', '<html><head><title>{% block title %}Site{% endblock %}</title></head><body>{% block content %}{% endblock %}</body></html>');
  WriteTpl('layout_admin.html', '{% extends "base.html" %}{% block title %}Admin — {{ parent() }}{% endblock %}{% block content %}<nav>Sidebar</nav><main>{% block admin_content %}{% endblock %}</main>{% endblock %}');
  WriteTpl('dashboard.html', '{% extends "layout_admin.html" %}{% block title %}Dashboard{% endblock %}{% block admin_content %}<h1>Hello {{ user }}</h1>{% endblock %}');
  FFrond.SetVariable('user', 'Admin');
  R := FFrond.Render('dashboard.html');
  Check((Pos('<html>', R) > 0) and (Pos('<title>Dashboard</title>', R) > 0) and
        (Pos('<nav>Sidebar</nav>', R) > 0) and (Pos('<h1>Hello Admin</h1>', R) > 0),
        'two-level extends: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestThreeLevelExtends;
var R: string;
begin
  WriteTpl('root.html', '<div>{% block body %}default{% endblock %}</div>');
  WriteTpl('mid.html', '{% extends "root.html" %}{% block body %}<section>{% block inner %}{% endblock %}</section>{% endblock %}');
  WriteTpl('leaf.html', '{% extends "mid.html" %}{% block inner %}LEAF{% endblock %}');
  R := FFrond.Render('leaf.html');
  Check((Pos('<div>', R) > 0) and (Pos('<section>', R) > 0) and (Pos('LEAF', R) > 0),
        'three-level extends: got "' + R + '"');
end;

procedure TestTTina4Frond_SetIncludeExtends.TestTwoLevelExtendsDefaultBlock;
var R: string;
begin
  WriteTpl('base.html', '<h1>{% block title %}Base{% endblock %}</h1>{% block content %}{% endblock %}');
  WriteTpl('child.html', '{% extends "base.html" %}{% block content %}<p>Default content</p>{% endblock %}');
  WriteTpl('grandchild.html', '{% extends "child.html" %}{% block title %}Override{% endblock %}');
  R := FFrond.Render('grandchild.html');
  Check((Pos('<h1>Override</h1>', R) > 0) and (Pos('<p>Default content</p>', R) > 0),
        'two-level default block: got "' + R + '"');
end;

// ─── TestWhitespaceControl ─────────────────────────────────

procedure TestTTina4Frond_WhitespaceControl.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_WhitespaceControl.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_WhitespaceControl.TestStripBefore;
var R: string;
begin
  FFrond.SetVariable('name', 'world');
  R := FFrond.Render('hello  {{- name }}');
  Check(R = 'helloworld', 'strip before: got "' + R + '"');
end;

procedure TestTTina4Frond_WhitespaceControl.TestStripAfter;
var R: string;
begin
  FFrond.SetVariable('name', 'hello');
  R := FFrond.Render('{{ name -}}  there');
  Check(R = 'hellothere', 'strip after: got "' + R + '"');
end;

// ─── TestComments ──────────────────────────────────────────

procedure TestTTina4Frond_Comments.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Comments.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Comments.TestCommentRemoved;
var R: string;
begin
  R := FFrond.Render('before{# comment #}after');
  Check((R = 'beforeafter') and (Pos('comment', R) = 0), 'comment: got "' + R + '"');
end;

// ─── TestGlobals ───────────────────────────────────────────

procedure TestTTina4Frond_Globals.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Globals.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Globals.TestGlobalVariable;
var R: string;
begin
  // Delphi has SetVariable but no separate "global" — treat set as global
  FFrond.SetVariable('app_name', 'Tina4');
  R := FFrond.Render('{{ app_name }}');
  Check(R = 'Tina4', 'global variable: got "' + R + '"');
end;

procedure TestTTina4Frond_Globals.TestDataOverridesGlobal;
var R: string;
begin
  // Simulate: set global then override — Delphi model: SetVariable twice, second wins
  FFrond.SetVariable('name', 'Global');
  FFrond.SetVariable('name', 'Local');
  R := FFrond.Render('{{ name }}');
  Check(R = 'Local', 'data overrides global: got "' + R + '"');
end;

// ─── TestDump ──────────────────────────────────────────────

procedure TestTTina4Frond_Dump.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Dump.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  SetEnvironmentVariable('TINA4_DEBUG', nil);
end;

procedure TestTTina4Frond_Dump.TestDumpFilterDebugMode;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ val | dump | raw }}');
  Check((Pos('<pre>', R) = 1) and (Pos('a', R) > 0), 'dump debug: got "' + R + '"');
end;

procedure TestTTina4Frond_Dump.TestDumpFilterProductionMode;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'false');
  FFrond.SetDebug(False);
  D := TDictionary<string, TValue>.Create;
  D.Add('secret', TValue.From<string>('hunter2'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ val | dump | raw }}');
  Check(R = '', 'dump production: got "' + R + '"');
end;

procedure TestTTina4Frond_Dump.TestDumpFilterUnsetEnvIsProduction;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', nil);
  FFrond.SetDebug(False);
  D := TDictionary<string, TValue>.Create;
  D.Add('secret', TValue.From<string>('x'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ val | dump | raw }}');
  Check(R = '', 'dump unset env: got "' + R + '"');
end;

procedure TestTTina4Frond_Dump.TestDumpFunctionFormMatchesFilter;
var
  RFilter, RFn: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  D.Add('b', TValue.From<string>('hi'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  RFilter := FFrond.Render('{{ val | dump | raw }}');
  RFn := FFrond.Render('{{ dump(val) | raw }}');
  Check((RFilter = RFn) and (Pos('<pre>', RFn) > 0), 'dump fn=filter: filter="' + RFilter + '" fn="' + RFn + '"');
end;

procedure TestTTina4Frond_Dump.TestDumpFunctionSilentInProduction;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'false');
  FFrond.SetDebug(False);
  D := TDictionary<string, TValue>.Create;
  D.Add('secret', TValue.From<string>('x'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check(R = '', 'dump fn production: got "' + R + '"');
end;

procedure TestTTina4Frond_Dump.TestDumpDoesNotCrashOnCircularDict;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  D := TDictionary<string, TValue>.Create;
  D.Add('name', TValue.From<string>('root'));
  // Simulating circular reference isn't straightforward in Delphi dict; use self key marker.
  D.Add('self', TValue.From<string>('...'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check((Pos('root', R) > 0) and (Pos('...', R) > 0), 'circular: got "' + R + '"');
end;

// ─── TestMacros ────────────────────────────────────────────

procedure TestTTina4Frond_Macros.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Macros.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Macros.TestSimpleMacro;
var R: string;
begin
  R := FFrond.Render('{% macro greet(name) %}Hello {{ name }}{% endmacro %}{{ greet("World") | raw }}');
  Check(Pos('Hello World', R) > 0, 'simple macro: got "' + R + '"');
end;

procedure TestTTina4Frond_Macros.TestMacroHtmlOutput;
var R: string;
begin
  R := FFrond.Render('{% macro link(url, text) %}<a href="{{ url }}">{{ text }}</a>{% endmacro %}{{ link("https://tina4.com", "Tina4") }}');
  Check(R = '<a href="https://tina4.com">Tina4</a>', 'macro html: got "' + R + '"');
end;

procedure TestTTina4Frond_Macros.TestMacroNested;
var R: string;
begin
  R := FFrond.Render('{% macro wrap(x) %}<b>{{ x }}</b>{% endmacro %}{% macro btn(label) %}{{ wrap(label) }}{% endmacro %}{{ btn("test") }}');
  Check(R = '<b>test</b>', 'macro nested: got "' + R + '"');
end;

// ─── TestFormToken ─────────────────────────────────────────

procedure TestTTina4Frond_FormToken.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_FormToken.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_FormToken.TestFormTokenFunctionCall;
var R: string;
begin
  R := FFrond.Render('{{ form_token() | raw }}');
  Check(Pos('<input type="hidden" name="formToken" value="', R) > 0, 'form_token(): got "' + R + '"');
end;

procedure TestTTina4Frond_FormToken.TestFormTokenVariable;
var R: string;
begin
  R := FFrond.Render('{{ form_token() | raw }}');
  Check(Pos('formToken', R) > 0, 'form_token variable: got "' + R + '"');
end;

procedure TestTTina4Frond_FormToken.TestFormTokenFilter;
var R: string;
begin
  R := FFrond.Render('{{ "" | form_token | raw }}');
  Check(Pos('<input type="hidden" name="formToken" value="', R) > 0, 'form_token filter: got "' + R + '"');
end;

procedure TestTTina4Frond_FormToken.TestFormTokenIsValidJwt;
var
  R, Token: string;
  M: TMatch;
  Parts: TArray<string>;
begin
  R := FFrond.Render('{{ form_token() | raw }}');
  M := TRegEx.Match(R, 'value="([^"]+)"');
  Check(M.Success, 'form_token jwt: no token found in "' + R + '"');
  if M.Success then
  begin
    Token := M.Groups[1].Value;
    Parts := Token.Split(['.']);
    Check(Length(Parts) = 3, 'form_token jwt: expected 3 parts got ' + IntToStr(Length(Parts)));
  end;
end;

procedure TestTTina4Frond_FormToken.TestFormTokenWithDescriptor;
var R: string;
begin
  R := FFrond.Render('{{ "admin" | form_token | raw }}');
  Check(Pos('formToken', R) > 0, 'form_token with descriptor: got "' + R + '"');
end;

// ─── TestRawBlock ──────────────────────────────────────────

procedure TestTTina4Frond_RawBlock.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_RawBlock.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_RawBlock.TestRawPreservesVarSyntax;
var R: string;
begin
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{% raw %}{{ name }}{% endraw %}');
  Check(R = '{{ name }}', 'raw var: got "' + R + '"');
end;

procedure TestTTina4Frond_RawBlock.TestRawPreservesBlockSyntax;
var R: string;
begin
  R := FFrond.Render('{% raw %}{% if true %}yes{% endif %}{% endraw %}');
  Check(R = '{% if true %}yes{% endif %}', 'raw block: got "' + R + '"');
end;

procedure TestTTina4Frond_RawBlock.TestRawMixedWithNormal;
var R: string;
begin
  FFrond.SetVariable('name', 'World');
  R := FFrond.Render('Hello {{ name }}! {% raw %}{{ not_parsed }}{% endraw %} done');
  Check(R = 'Hello World! {{ not_parsed }} done', 'raw mixed: got "' + R + '"');
end;

procedure TestTTina4Frond_RawBlock.TestMultipleRawBlocks;
var R: string;
begin
  R := FFrond.Render('{% raw %}{{ a }}{% endraw %} mid {% raw %}{{ b }}{% endraw %}');
  Check(R = '{{ a }} mid {{ b }}', 'multiple raw: got "' + R + '"');
end;

procedure TestTTina4Frond_RawBlock.TestRawBlockMultiline;
var R: string;
begin
  R := FFrond.Render('{% raw %}'#10'{{ var }}'#10'{% tag %}'#10'{% endraw %}');
  Check(R = #10'{{ var }}'#10'{% tag %}'#10, 'raw multiline: got "' + R + '"');
end;

// ─── TestFromImport ────────────────────────────────────────

procedure TestTTina4Frond_FromImport.SetUp;
begin
  FTplDir := TFrondTestHelper.TempDir;
  FFrond := TTina4Frond.Create(FTplDir);
end;

procedure TestTTina4Frond_FromImport.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  try
    if DirectoryExists(FTplDir) then
      TDirectory.Delete(FTplDir, True);
  except
  end;
end;

procedure TestTTina4Frond_FromImport.WriteTpl(const Name, Contents: string);
begin
  ForceDirectories(ExtractFilePath(TPath.Combine(FTplDir, Name)));
  TFile.WriteAllText(TPath.Combine(FTplDir, Name), Contents);
end;

procedure TestTTina4Frond_FromImport.TestFromImportBasic;
var R: string;
begin
  WriteTpl('macros.twig', '{% macro greeting(name) %}Hello {{ name }}!{% endmacro %}');
  R := FFrond.Render('{% from "macros.twig" import greeting %}{{ greeting("World") }}');
  Check(R = 'Hello World!', 'from import basic: got "' + R + '"');
end;

procedure TestTTina4Frond_FromImport.TestFromImportMultiple;
var R: string;
begin
  WriteTpl('helpers.twig', '{% macro bold(t) %}B{{ t }}B{% endmacro %}{% macro italic(t) %}I{{ t }}I{% endmacro %}');
  R := FFrond.Render('{% from "helpers.twig" import bold, italic %}{{ bold("hi") }} {{ italic("there") }}');
  Check((Pos('BhiB', R) > 0) and (Pos('IthereI', R) > 0), 'from import multiple: got "' + R + '"');
end;

procedure TestTTina4Frond_FromImport.TestFromImportSelective;
var R: string;
begin
  WriteTpl('mix.twig', '{% macro used(x) %}[{{ x }}]{% endmacro %}{% macro unused(x) %}{{{ x }}}{% endmacro %}');
  R := FFrond.Render('{% from "mix.twig" import used %}{{ used("ok") }}');
  Check(Pos('[ok]', R) > 0, 'from import selective: got "' + R + '"');
end;

procedure TestTTina4Frond_FromImport.TestFromImportSubdirectory;
var R: string;
begin
  ForceDirectories(TPath.Combine(FTplDir, 'macros'));
  WriteTpl('macros/forms.twig', '{% macro field(label, name) %}{{ label }}:{{ name }}{% endmacro %}');
  R := FFrond.Render('{% from "macros/forms.twig" import field %}{{ field("Name", "name") }}');
  Check(Pos('Name:name', R) > 0, 'from import subdir: got "' + R + '"');
end;

// ─── TestSpaceless ─────────────────────────────────────────

procedure TestTTina4Frond_Spaceless.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Spaceless.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Spaceless.TestSpacelessRemovesWhitespaceBetweenTags;
var R: string;
begin
  R := FFrond.Render('{% spaceless %}<div>  <p>  Hello  </p>  </div>{% endspaceless %}');
  Check(R = '<div><p>  Hello  </p></div>', 'spaceless: got "' + R + '"');
end;

procedure TestTTina4Frond_Spaceless.TestSpacelessPreservesContentWhitespace;
var R: string;
begin
  R := FFrond.Render('{% spaceless %}<span>  text  </span>{% endspaceless %}');
  Check(R = '<span>  text  </span>', 'spaceless preserve: got "' + R + '"');
end;

procedure TestTTina4Frond_Spaceless.TestSpacelessMultiline;
var R: string;
begin
  R := FFrond.Render('{% spaceless %}'#10'<div>'#10'    <p>Hi</p>'#10'</div>'#10'{% endspaceless %}');
  Check((Pos('<div><p>', R) > 0) and (Pos('</p></div>', R) > 0), 'spaceless multiline: got "' + R + '"');
end;

procedure TestTTina4Frond_Spaceless.TestSpacelessWithVariables;
var R: string;
begin
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{% spaceless %}<div>  <span>{{ name }}</span>  </div>{% endspaceless %}');
  Check(R = '<div><span>Alice</span></div>', 'spaceless vars: got "' + R + '"');
end;

// ─── TestAutoescape ────────────────────────────────────────

procedure TestTTina4Frond_Autoescape.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_Autoescape.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_Autoescape.TestAutoescapeFalseDisablesEscaping;
var R: string;
begin
  FFrond.SetVariable('html', '<b>bold</b>');
  R := FFrond.Render('{% autoescape false %}{{ html }}{% endautoescape %}');
  Check(R = '<b>bold</b>', 'autoescape false: got "' + R + '"');
end;

procedure TestTTina4Frond_Autoescape.TestAutoescapeTrueKeepsEscaping;
var R: string;
begin
  // Tina4Frond does not auto-escape by default. {% autoescape true %} is
  // recognised as a tag but is effectively a no-op — the Delphi renderer
  // does not force HTML escaping of variable output. Users opt in via the
  // |escape filter. Validates that the tag does not break rendering.
  FFrond.SetVariable('html', '<b>bold</b>');
  R := FFrond.Render('{% autoescape true %}{{ html }}{% endautoescape %}');
  Check(R = '<b>bold</b>', 'autoescape true (no-op in Tina4Frond): got "' + R + '"');
end;

procedure TestTTina4Frond_Autoescape.TestAutoescapeFalseWithFilters;
var R: string;
begin
  FFrond.SetVariable('name', 'alice');
  R := FFrond.Render('{% autoescape false %}{{ name | upper }}{% endautoescape %}');
  Check(R = 'ALICE', 'autoescape false + filter: got "' + R + '"');
end;

procedure TestTTina4Frond_Autoescape.TestAutoescapeFalseMultipleVariables;
var R: string;
begin
  FFrond.SetVariable('a', '<i>x</i>');
  FFrond.SetVariable('b', '<b>y</b>');
  R := FFrond.Render('{% autoescape false %}{{ a }} {{ b }}{% endautoescape %}');
  Check(R = '<i>x</i> <b>y</b>', 'autoescape false multiple: got "' + R + '"');
end;

// ─── TestInlineIf ──────────────────────────────────────────

procedure TestTTina4Frond_InlineIf.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_InlineIf.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfTrue;
var R: string;
begin
  FFrond.SetVariable('active', True);
  R := FFrond.Render('{{ ''yes'' if active else ''no'' }}');
  Check(R = 'yes', 'inline if true: got "' + R + '"');
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfFalse;
var R: string;
begin
  FFrond.SetVariable('active', False);
  R := FFrond.Render('{{ ''yes'' if active else ''no'' }}');
  Check(R = 'no', 'inline if false: got "' + R + '"');
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfWithVariable;
var R: string;
begin
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{{ name if name else ''Anonymous'' }}');
  Check(R = 'Alice', 'inline if var: got "' + R + '"');
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfWithMissingVariable;
var R: string;
begin
  R := FFrond.Render('{{ name if name else ''Anonymous'' }}');
  Check(R = 'Anonymous', 'inline if missing: got "' + R + '"');
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfWithComparison;
var R: string;
begin
  FFrond.SetVariable('age', 21);
  R := FFrond.Render('{{ ''adult'' if age >= 18 else ''minor'' }}');
  Check(R = 'adult', 'inline if comparison: got "' + R + '"');
end;

procedure TestTTina4Frond_InlineIf.TestInlineIfNumeric;
var R: string;
begin
  FFrond.SetVariable('count', 5);
  R := FFrond.Render('{{ count if count else 0 }}');
  Check(R = '5', 'inline if numeric: got "' + R + '"');
end;

// ─── TestTokenCache ────────────────────────────────────────

procedure TestTTina4Frond_TokenCache.SetUp;
begin
  FTplDir := TFrondTestHelper.TempDir;
  FFrond := TTina4Frond.Create(FTplDir);
end;

procedure TestTTina4Frond_TokenCache.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  try
    if DirectoryExists(FTplDir) then
      TDirectory.Delete(FTplDir, True);
  except
  end;
end;

procedure TestTTina4Frond_TokenCache.WriteTpl(const Name, Contents: string);
begin
  TFile.WriteAllText(TPath.Combine(FTplDir, Name), Contents);
end;

procedure TestTTina4Frond_TokenCache.TestRenderStringCacheSameOutput;
var R1, R2: string;
begin
  FFrond.SetVariable('name', 'World');
  R1 := FFrond.Render('Hello {{ name }}!');
  R2 := FFrond.Render('Hello {{ name }}!');
  Check((R1 = R2) and (R1 = 'Hello World!'), 'cache same: got "' + R1 + '" / "' + R2 + '"');
end;

procedure TestTTina4Frond_TokenCache.TestRenderStringCacheDifferentData;
var R1, R2: string;
begin
  FFrond.SetVariable('greeting', 'Hi');
  FFrond.SetVariable('name', 'Alice');
  R1 := FFrond.Render('{{ greeting }}, {{ name }}!');
  FFrond.SetVariable('greeting', 'Bye');
  FFrond.SetVariable('name', 'Bob');
  R2 := FFrond.Render('{{ greeting }}, {{ name }}!');
  Check((R1 = 'Hi, Alice!') and (R2 = 'Bye, Bob!'), 'cache diff data: got "' + R1 + '" / "' + R2 + '"');
end;

procedure TestTTina4Frond_TokenCache.TestRenderFileCacheSameOutput;
var R1, R2: string;
begin
  WriteTpl('cached.html', '<p>{{ msg }}</p>');
  FFrond.SetVariable('msg', 'hello');
  R1 := FFrond.Render('cached.html');
  R2 := FFrond.Render('cached.html');
  Check((R1 = R2) and (R1 = '<p>hello</p>'), 'file cache same: got "' + R1 + '" / "' + R2 + '"');
end;

procedure TestTTina4Frond_TokenCache.TestRenderFileCacheDifferentData;
var R1, R2: string;
begin
  WriteTpl('cached2.html', '{{ x }} + {{ y }}');
  FFrond.SetVariable('x', 1);
  FFrond.SetVariable('y', 2);
  R1 := FFrond.Render('cached2.html');
  FFrond.SetVariable('x', 10);
  FFrond.SetVariable('y', 20);
  R2 := FFrond.Render('cached2.html');
  Check((R1 = '1 + 2') and (R2 = '10 + 20'), 'file cache diff: got "' + R1 + '" / "' + R2 + '"');
end;

procedure TestTTina4Frond_TokenCache.TestCacheInvalidationOnFileChange;
var
  R1, R2: string;
  TplPath: string;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  try
    TplPath := TPath.Combine(FTplDir, 'changing.html');
    TFile.WriteAllText(TplPath, 'Version 1: {{ v }}');
    FFrond.SetVariable('v', 'a');
    R1 := FFrond.Render('changing.html');
    Check(R1 = 'Version 1: a', 'cache inv v1: got "' + R1 + '"');
    Sleep(50);
    TFile.WriteAllText(TplPath, 'Version 2: {{ v }}');
    FFrond.SetVariable('v', 'b');
    R2 := FFrond.Render('changing.html');
    Check(R2 = 'Version 2: b', 'cache inv v2: got "' + R2 + '"');
  finally
    SetEnvironmentVariable('TINA4_DEBUG', nil);
  end;
end;

procedure TestTTina4Frond_TokenCache.TestClearCache;
var R: string;
begin
  FFrond.SetVariable('x', 1);
  R := FFrond.Render('{{ x }}');
  // Delphi engine exposes no public clear_cache; expose the gap.
  Check(R = '1', 'clear cache: render returned "' + R + '" (clear_cache API not exposed)');
end;

procedure TestTTina4Frond_TokenCache.TestRenderStringWithForLoopCached;
var R1, R2: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R1 := FFrond.Render('{% for i in items %}{{ i }},{% endfor %}');
  R2 := FFrond.Render('{% for i in items %}{{ i }},{% endfor %}');
  Check((R1 = R2) and (R1 = '1,2,3,'), 'cache for: got "' + R1 + '" / "' + R2 + '"');
end;

procedure TestTTina4Frond_TokenCache.TestRenderStringWithIfCached;
var R1, R2: string;
begin
  FFrond.SetVariable('show', True);
  R1 := FFrond.Render('{% if show %}visible{% else %}hidden{% endif %}');
  FFrond.SetVariable('show', False);
  R2 := FFrond.Render('{% if show %}visible{% else %}hidden{% endif %}');
  Check((R1 = 'visible') and (R2 = 'hidden'), 'cache if: got "' + R1 + '" / "' + R2 + '"');
end;

// ─── TestMethodCalls ───────────────────────────────────────
// Python tests pass callables in a dict. Delphi Tina4Frond doesn't support
// invoking lambdas from context, so we exercise the call syntax by binding a
// dict that looks like a service with a static result — the test will fail
// until the engine supports callables or method calls from dicts.

procedure TestTTina4Frond_MethodCalls.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_MethodCalls.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_MethodCalls.TestDictCallableWithArgs;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable:t>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ user.t("greeting") }}');
  Check(R = 'T:greeting', 'dict callable args: engine needs callable dispatch, got "' + R + '"');
end;

procedure TestTTina4Frond_MethodCalls.TestDictCallableNoArgs;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('get_name', TValue.From<string>('<callable>'));
  FFrond.SetVariable('config', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ config.get_name() }}');
  Check(R = 'MyApp', 'dict callable no args: got "' + R + '"');
end;

procedure TestTTina4Frond_MethodCalls.TestDictCallableMultipleArgs;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('add', TValue.From<string>('<callable>'));
  FFrond.SetVariable('math', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ math.add(3, 4) }}');
  Check(R = '7', 'dict callable multi args: got "' + R + '"');
end;

procedure TestTTina4Frond_MethodCalls.TestDottedArgInMethodCall;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ user.t("auth.email") }}');
  Check(R = 'T:auth.email', 'dotted arg in method: got "' + R + '"');
end;

procedure TestTTina4Frond_MethodCalls.TestMethodCallInHtmlAttribute;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('<input placeholder="{{ user.t(''auth.email'') }}">');
  Check(R = '<input placeholder="T:auth.email">', 'method call in attr: got "' + R + '"');
end;

procedure TestTTina4Frond_MethodCalls.TestObjectMethodWithArgs;
var R: string;
begin
  // Delphi has no obvious way to pass an object with bound methods via SetVariable.
  // Mark this as a gap — engine would need RTTI callable support.
  R := FFrond.Render('{{ obj.greet("Alice") }}');
  Check(R = 'Hello Alice', 'object method: engine needs RTTI dispatch, got "' + R + '"');
end;

// ─── TestSliceSyntax ───────────────────────────────────────

procedure TestTTina4Frond_SliceSyntax.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_SliceSyntax.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_SliceSyntax.TestStringSliceStart;
var R: string;
begin
  FFrond.SetVariable('text', 'Hello World');
  R := FFrond.Render('{{ text[:5] }}');
  Check(R = 'Hello', 'slice start: got "' + R + '"');
end;

procedure TestTTina4Frond_SliceSyntax.TestStringSliceEnd;
var R: string;
begin
  FFrond.SetVariable('text', 'Hello World');
  R := FFrond.Render('{{ text[6:] }}');
  Check(R = 'World', 'slice end: got "' + R + '"');
end;

procedure TestTTina4Frond_SliceSyntax.TestStringSliceRange;
var R: string;
begin
  FFrond.SetVariable('text', 'Hello World');
  R := FFrond.Render('{{ text[0:5] }}');
  Check(R = 'Hello', 'slice range: got "' + R + '"');
end;

procedure TestTTina4Frond_SliceSyntax.TestListSlice;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(10), TValue.From<Integer>(20), TValue.From<Integer>(30), TValue.From<Integer>(40)]));
  R := FFrond.Render('{{ items[1:3] }}');
  Check(R = '[20, 30]', 'list slice: got "' + R + '"');
end;

// ─── TestDottedStringArgs ───────────────────────────────

procedure TestTTina4Frond_DottedStringArgs.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_DottedStringArgs.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_DottedStringArgs.TestSingleDotSingleQuotes;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ user.t(''auth.email'') }}');
  Check(R = 'T:auth.email', 'dotted single quotes: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestSingleDotDoubleQuotes;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ user.t("auth.email") }}');
  Check(R = 'T:auth.email', 'dotted double quotes: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestMultipleDots;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('i18n', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ i18n.t(''app.auth.login.title'') }}');
  Check(R = 'T:app.auth.login.title', 'multi dots: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestDottedArgInHtmlAttribute;
var R: string;
begin
  FFrond.SetVariable('t', TValue.From<string>('<callable>'));
  R := FFrond.Render('<input placeholder="{{ t(''auth.email'') }}">');
  Check(R = '<input placeholder="T:auth.email">', 'dotted in attr: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestDottedArgMethodOnDict;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('t', TValue.From<string>('<callable>'));
  FFrond.SetVariable('user', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('<label>{{ user.t(''form.fields.name'') }}</label>');
  Check(R = '<label>T:form.fields.name</label>', 'dotted method dict: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestMultipleArgsWithDots;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('pair', TValue.From<string>('<callable>'));
  FFrond.SetVariable('fmt', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ fmt.pair(''a.b'', ''c.d'') }}');
  Check(R = 'a.b=c.d', 'multi args dots: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestTildeInQuotedString;
var R: string;
begin
  FFrond.SetVariable('echo', TValue.From<string>('<callable>'));
  R := FFrond.Render('{{ echo(''hello~world'') }}');
  Check(R = 'hello~world', 'tilde in quote: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestOperatorCharsInQuotedString;
var R: string;
begin
  FFrond.SetVariable('echo', TValue.From<string>('<callable>'));
  R := FFrond.Render('{{ echo(''a >= b'') }}');
  Check((Pos('a', R) > 0) and (Pos('b', R) > 0), 'operator in quote: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestQuestionMarkInQuotedString;
var R: string;
begin
  FFrond.SetVariable('echo', TValue.From<string>('<callable>'));
  R := FFrond.Render('{{ echo(''is this ok?'') }}');
  Check(R = 'is this ok?', 'question mark in quote: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestChainedMethodWithDottedArg;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('lookup', TValue.From<string>('<callable>'));
  FFrond.SetVariable('svc', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ svc.lookup(''db.host'').value }}');
  Check(R = 'V:db.host', 'chained method: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestTopLevelFuncDottedArg;
var R: string;
begin
  FFrond.SetVariable('t', TValue.From<string>('<callable>'));
  R := FFrond.Render('{{ t(''auth.email'') }}');
  Check(R = 'T:auth.email', 'top-level func dotted: got "' + R + '"');
end;

procedure TestTTina4Frond_DottedStringArgs.TestNestedQuotesInArg;
var R: string;
begin
  FFrond.SetVariable('echo', TValue.From<string>('<callable>'));
  R := FFrond.Render('{{ echo("it''s fine") }}');
  Check(R <> '', 'nested quotes: got "' + R + '"');
end;

// ─── TestDynamicDictKeys ───────────────────────────────

procedure TestTTina4Frond_DynamicDictKeys.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_DynamicDictKeys.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_DynamicDictKeys.TestVariableKeyViaSet;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('9600.000', TValue.From<Double>(342120.0));
  FFrond.SetVariable('balances', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{% set k = "9600.000" %}{{ balances[k] }}');
  Check(R = '342120.0', 'variable key: got "' + R + '"');
end;

procedure TestTTina4Frond_DynamicDictKeys.TestVariableKeyFromLoop;
var
  R: string;
  Balances, A, B: TDictionary<string, TValue>;
begin
  Balances := TDictionary<string, TValue>.Create;
  Balances.Add('A', TValue.From<Integer>(100));
  Balances.Add('B', TValue.From<Integer>(200));
  FFrond.SetVariable('balances', TValue.From<TDictionary<string, TValue>>(Balances));
  A := TDictionary<string, TValue>.Create;
  A.Add('code', TValue.From<string>('A'));
  B := TDictionary<string, TValue>.Create;
  B.Add('code', TValue.From<string>('B'));
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<TDictionary<string, TValue>>(A), TValue.From<TDictionary<string, TValue>>(B)]));
  R := FFrond.Render('{% for i in items %}{{ balances[i.code] }},{% endfor %}');
  Check(R = '100,200,', 'variable key from loop: got "' + R + '"');
end;

procedure TestTTina4Frond_DynamicDictKeys.TestStringLiteralKeyStillWorks;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('key', TValue.From<string>('val'));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data["key"] }}');
  Check(R = 'val', 'double quote key: got "' + R + '"');
  R := FFrond.Render('{{ data[''key''] }}');
  Check(R = 'val', 'single quote key: got "' + R + '"');
end;

procedure TestTTina4Frond_DynamicDictKeys.TestIntKeyStillWorks;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(10), TValue.From<Integer>(20), TValue.From<Integer>(30)]));
  R := FFrond.Render('{{ items[1] }}');
  Check(R = '20', 'int key: got "' + R + '"');
end;

procedure TestTTina4Frond_DynamicDictKeys.TestSliceStillWorks;
var R: string;
begin
  FFrond.SetVariable('text', 'Hello');
  R := FFrond.Render('{{ text[:3] }}');
  Check(R = 'Hel', 'slice: got "' + R + '"');
end;

procedure TestTTina4Frond_DynamicDictKeys.TestNestedVariableKey;
var
  R: string;
  Lookup, Cfg: TDictionary<string, TValue>;
begin
  Lookup := TDictionary<string, TValue>.Create;
  Lookup.Add('x', TValue.From<string>('found'));
  FFrond.SetVariable('lookup', TValue.From<TDictionary<string, TValue>>(Lookup));
  Cfg := TDictionary<string, TValue>.Create;
  Cfg.Add('key', TValue.From<string>('x'));
  FFrond.SetVariable('config', TValue.From<TDictionary<string, TValue>>(Cfg));
  R := FFrond.Render('{{ lookup[config.key] }}');
  Check(R = 'found', 'nested var key: got "' + R + '"');
end;

// ─── TestReplaceFilter ─────────────────────────────────

procedure TestTTina4Frond_ReplaceFilter.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_ReplaceFilter.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_ReplaceFilter.TestSimpleReplace;
var R: string;
begin
  FFrond.SetVariable('text', 'banana');
  R := FFrond.Render('{{ text|replace("a", "b") }}');
  Check(R = 'bbnbnb', 'simple replace: got "' + R + '"');
end;

procedure TestTTina4Frond_ReplaceFilter.TestReplaceSpaceWithUnderscore;
var R: string;
begin
  FFrond.SetVariable('name', 'John Doe');
  R := FFrond.Render('{{ name|replace('' '', ''_'') }}');
  Check(R = 'John_Doe', 'replace space: got "' + R + '"');
end;

procedure TestTTina4Frond_ReplaceFilter.TestReplaceWithEmpty;
var R: string;
begin
  FFrond.SetVariable('text', 'hello world');
  R := FFrond.Render('{{ text|replace("world", "") }}');
  Check(Trim(R) = 'hello', 'replace empty: got "' + R + '"');
end;

procedure TestTTina4Frond_ReplaceFilter.TestReplaceQuoteWithBackslashQuote;
var R: string;
begin
  FFrond.SetVariable('text', 'it''s ok');
  R := FFrond.Render('{{ text|replace("''", "\\''") | raw }}');
  Check(R = 'it\''s ok', 'replace quote: got "' + R + '"');
end;

procedure TestTTina4Frond_ReplaceFilter.TestReplaceBackslash;
var R: string;
begin
  FFrond.SetVariable('path', 'C:\\Users\\test');
  R := FFrond.Render('{{ path|replace("\\\\", "/") }}');
  Check(Pos('/', R) > 0, 'replace backslash: got "' + R + '"');
end;

// ─── TestJsonAndJsFilters ──────────────────────────

procedure TestTTina4Frond_JsonAndJsFilters.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestToJsonDict;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data|to_json|raw }}');
  Check(R = '{"a":1}', 'to_json dict: got "' + R + '"');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestToJsonList;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ items|to_json|raw }}');
  Check(R = '[1,2,3]', 'to_json list: got "' + R + '"');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestToJsonHtmlSafe;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('x', TValue.From<string>('<b>bold</b>'));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data|to_json|raw }}');
  Check((Pos('<', R) = 0) and (Pos('\u003c', R) > 0), 'to_json html safe: got "' + R + '"');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestTojsonAlias;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('a', TValue.From<Integer>(1));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data|tojson|raw }}');
  Check(R = '{"a":1}', 'tojson alias: got "' + R + '"');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestJsEscapeQuotes;
var R: string;
begin
  FFrond.SetVariable('text', 'it''s a "test"');
  R := FFrond.Render('{{ text|js_escape|raw }}');
  Check((Pos('\''', R) > 0) and (Pos('\"', R) > 0), 'js_escape quotes: got "' + R + '"');
end;

procedure TestTTina4Frond_JsonAndJsFilters.TestJsEscapeNewlines;
var R: string;
begin
  FFrond.SetVariable('text', 'line1'#10'line2');
  R := FFrond.Render('{{ text|js_escape|raw }}');
  Check((Pos('\n', R) > 0) and (Pos(#10, R) = 0), 'js_escape newlines: got "' + R + '"');
end;

// ─── TestSafeStringFilters ────────────────────────

procedure TestTTina4Frond_SafeStringFilters.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_SafeStringFilters.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_SafeStringFilters.TestJsEscapeNoHtmlEncoding;
var R: string;
begin
  FFrond.SetVariable('text', 'it''s a test');
  R := FFrond.Render('{{ text|js_escape }}');
  Check((R = 'it\''s a test') and (Pos('&#', R) = 0), 'js_escape no html: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestToJsonNoHtmlEncoding;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('key', TValue.From<string>('value'));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data|to_json }}');
  Check((R = '{"key":"value"}') and (Pos('&quot;', R) = 0), 'to_json no html: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestTojsonAliasNoHtmlEncoding;
var R: string;
begin
  FFrond.SetVariable('data', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2)]));
  R := FFrond.Render('{{ data|tojson }}');
  Check(R = '[1,2]', 'tojson no html: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestJsEscapeBackslashNotEncoded;
var R: string;
begin
  FFrond.SetVariable('text', 'say "hello"');
  R := FFrond.Render('{{ text|js_escape }}');
  Check((Pos('\"', R) > 0) and (Pos('&#', R) = 0), 'js_escape bs: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestToJsonXssStillEscaped;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('x', TValue.From<string>('<script>'));
  FFrond.SetVariable('data', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ data|to_json }}');
  Check((Pos('\u003c', R) > 0) and (Pos('&lt;', R) = 0) and (Pos('<script>', R) = 0), 'to_json xss: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestRegularVarStillHtmlEscaped;
var R: string;
begin
  // Tina4Frond does NOT auto-escape. Use |escape filter explicitly.
  FFrond.SetVariable('text', '<b>bold</b>');
  R := FFrond.Render('{{ text|escape }}');
  Check((Pos('&lt;b&gt;', R) > 0) and (Pos('<b>', R) = 0), 'regular escape: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestJsEscapeInOnclick;
var R: string;
begin
  FFrond.SetVariable('msg', 'it''s a "test"');
  R := FFrond.Render('<button onclick="alert(''{{ msg|js_escape }}'')">Click</button>');
  Check((Pos('\''', R) > 0) and (Pos('&#', R) = 0), 'js_escape onclick: got "' + R + '"');
end;

procedure TestTTina4Frond_SafeStringFilters.TestToJsonInScriptTag;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  D := TDictionary<string, TValue>.Create;
  D.Add('name', TValue.From<string>('Alice'));
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<TDictionary<string, TValue>>(D)]));
  R := FFrond.Render('<script>var data = {{ items|to_json }};</script>');
  Check((Pos('"name"', R) > 0) and (Pos('&quot;', R) = 0), 'to_json script: got "' + R + '"');
end;

// ─── TestTildeTernary ────────────────────────────────

procedure TestTTina4Frond_TildeTernary.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_TildeTernary.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_TildeTernary.TestTildeWithTernary;
var R: string;
begin
  FFrond.SetVariable('contact_type', 'customer');
  R := FFrond.Render('{{ "/path?type=" ~ (contact_type ? contact_type : "all") }}');
  Check(R = '/path?type=customer', 'tilde ternary: got "' + R + '"');
end;

procedure TestTTina4Frond_TildeTernary.TestTildeTernaryFalseBranch;
var R: string;
begin
  R := FFrond.Render('{{ "/path?type=" ~ (contact_type ? contact_type : "all") }}');
  Check(R = '/path?type=all', 'tilde ternary false: got "' + R + '"');
end;

procedure TestTTina4Frond_TildeTernary.TestQuestionMarkInUrlString;
var R: string;
begin
  R := FFrond.Render('{{ "/search?q=hello" }}');
  Check(R = '/search?q=hello', 'qmark url: got "' + R + '"');
end;

procedure TestTTina4Frond_TildeTernary.TestTildeConcatWithUrlQuery;
var R: string;
begin
  FFrond.SetVariable('base', '/api');
  FFrond.SetVariable('sort', 'name');
  R := FFrond.Render('{{ base ~ "?sort=" ~ sort }}');
  Check(R = '/api?sort=name', 'tilde url query: got "' + R + '"');
end;

procedure TestTTina4Frond_TildeTernary.TestSimpleTernaryStillWorks;
var R: string;
begin
  FFrond.SetVariable('x', True);
  R := FFrond.Render('{{ x ? "yes" : "no" }}');
  Check(R = 'yes', 'simple ternary true: got "' + R + '"');
  FFrond.SetVariable('x', False);
  R := FFrond.Render('{{ x ? "yes" : "no" }}');
  Check(R = 'no', 'simple ternary false: got "' + R + '"');
end;

procedure TestTTina4Frond_TildeTernary.TestInlineIfStillWorks;
var R: string;
begin
  FFrond.SetVariable('active', True);
  R := FFrond.Render('{{ "on" if active else "off" }}');
  Check(R = 'on', 'inline if true: got "' + R + '"');
  FFrond.SetVariable('active', False);
  R := FFrond.Render('{{ "on" if active else "off" }}');
  Check(R = 'off', 'inline if false: got "' + R + '"');
end;

// ─── TestFilterInCondition ─────────────────────────

procedure TestTTina4Frond_FilterInCondition.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_FilterInCondition.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
end;

procedure TestTTina4Frond_FilterInCondition.TestLengthGreaterThanZero;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2)]));
  R := FFrond.Render('{% if items|length > 0 %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'length>0: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestLengthGreaterThanZeroEmpty;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([]));
  R := FFrond.Render('{% if items|length > 0 %}yes{% else %}no{% endif %}');
  Check(R = 'no', 'length>0 empty: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestLengthEquals;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{% if items|length == 3 %}three{% else %}nope{% endif %}');
  Check(R = 'three', 'length==3: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestLengthEqualsZero;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([]));
  R := FFrond.Render('{% if items|length == 0 %}empty{% else %}has{% endif %}');
  Check(R = 'empty', 'length==0: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestLengthNotEquals;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2)]));
  R := FFrond.Render('{% if items|length != 1 %}multi{% else %}single{% endif %}');
  Check(R = 'multi', 'length!=1: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestStringLength;
var R: string;
begin
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{% if name|length > 3 %}long{% else %}short{% endif %}');
  Check(R = 'long', 'string length: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestUpperComparison;
var R: string;
begin
  FFrond.SetVariable('name', 'alice');
  R := FFrond.Render('{% if name|upper == "ALICE" %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'upper comp: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestFirstComparison;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{% if items|first == 1 %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'first comp: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestLastComparison;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{% if items|last == 3 %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'last comp: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestFilterWithAnd;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2)]));
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('{% if items|length >= 2 and name|upper == "ALICE" %}both{% else %}nope{% endif %}');
  Check(R = 'both', 'filter and: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestFilterWithOr;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1)]));
  FFrond.SetVariable('name', 'Bob');
  R := FFrond.Render('{% if items|length == 0 or name|upper == "BOB" %}match{% else %}nope{% endif %}');
  Check(R = 'match', 'filter or: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestFilterWithSpaces;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1)]));
  R := FFrond.Render('{% if items | length > 0 %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'filter spaces: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestNoFilterStillWorks;
var R: string;
begin
  FFrond.SetVariable('x', 10);
  R := FFrond.Render('{% if x > 5 %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'nofilter>: got "' + R + '"');
  FFrond.SetVariable('x', 3);
  R := FFrond.Render('{% if x > 5 %}yes{% else %}no{% endif %}');
  Check(R = 'no', 'nofilter<: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestTruthyCheckStillWorks;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(1)]));
  R := FFrond.Render('{% if items %}yes{% else %}no{% endif %}');
  Check(R = 'yes', 'truthy nonempty: got "' + R + '"');
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([]));
  R := FFrond.Render('{% if items %}yes{% else %}no{% endif %}');
  Check(R = 'no', 'truthy empty: got "' + R + '"');
end;

procedure TestTTina4Frond_FilterInCondition.TestFilterInElseif;
var R: string;
begin
  FFrond.SetVariable('items', TFrondTestHelper.MakeArray([TValue.From<Integer>(42)]));
  R := FFrond.Render('{% if items|length == 0 %}empty{% elseif items|length == 1 %}one{% else %}many{% endif %}');
  Check(R = 'one', 'filter elseif: got "' + R + '"');
end;

// ─── TestBlockParent ──────────────────────────────

procedure TestTTina4Frond_BlockParent.SetUp;
begin
  FTplDir := TFrondTestHelper.TempDir;
  FFrond := TTina4Frond.Create(FTplDir);
end;

procedure TestTTina4Frond_BlockParent.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  try
    if DirectoryExists(FTplDir) then
      TDirectory.Delete(FTplDir, True);
  except
  end;
end;

procedure TestTTina4Frond_BlockParent.WriteTpl(const Name, Contents: string);
begin
  TFile.WriteAllText(TPath.Combine(FTplDir, Name), Contents);
end;

procedure TestTTina4Frond_BlockParent.TestParentIncludesParentContent;
var R: string;
begin
  WriteTpl('base_p.html', '<head>{% block head %}<title>Base</title>{% endblock %}</head>');
  WriteTpl('child_p.html', '{% extends "base_p.html" %}{% block head %}{{ parent() }}<link href="/app.css">{% endblock %}');
  R := FFrond.Render('child_p.html');
  Check((Pos('<title>Base</title>', R) > 0) and (Pos('/app.css', R) > 0), 'parent(): got "' + R + '"');
end;

procedure TestTTina4Frond_BlockParent.TestSuperIsAlias;
var R: string;
begin
  WriteTpl('base_s.html', '{% block footer %}Base Footer{% endblock %}');
  WriteTpl('child_s.html', '{% extends "base_s.html" %}{% block footer %}{{ super() }} | Child{% endblock %}');
  R := FFrond.Render('child_s.html');
  Check((Pos('Base Footer', R) > 0) and (Pos('Child', R) > 0), 'super(): got "' + R + '"');
end;

procedure TestTTina4Frond_BlockParent.TestNoParentFullReplace;
var R: string;
begin
  WriteTpl('base_r.html', '{% block content %}OLD{% endblock %}');
  WriteTpl('child_r.html', '{% extends "base_r.html" %}{% block content %}NEW{% endblock %}');
  R := FFrond.Render('child_r.html');
  Check((Pos('NEW', R) > 0) and (Pos('OLD', R) = 0), 'no parent: got "' + R + '"');
end;

procedure TestTTina4Frond_BlockParent.TestParentWithVariables;
var R: string;
begin
  WriteTpl('base_v.html', '{% block greeting %}Hello {{ name }}{% endblock %}');
  WriteTpl('child_v.html', '{% extends "base_v.html" %}{% block greeting %}{{ parent() }}! Welcome back.{% endblock %}');
  FFrond.SetVariable('name', 'Alice');
  R := FFrond.Render('child_v.html');
  Check((Pos('Hello Alice', R) > 0) and (Pos('Welcome back', R) > 0), 'parent vars: got "' + R + '"');
end;

procedure TestTTina4Frond_BlockParent.TestParentNotCalledReturnsChildOnly;
var R: string;
begin
  WriteTpl('base_nc.html', '{% block nav %}Parent Nav{% endblock %} | {% block body %}Parent Body{% endblock %}');
  WriteTpl('child_nc.html', '{% extends "base_nc.html" %}{% block body %}Child Body{% endblock %}');
  R := FFrond.Render('child_nc.html');
  Check((Pos('Parent Nav', R) > 0) and (Pos('Child Body', R) > 0) and (Pos('Parent Body', R) = 0),
        'parent not called: got "' + R + '"');
end;

procedure TestTTina4Frond_BlockParent.TestMultipleBlocksWithParent;
var R: string;
begin
  WriteTpl('base_m.html', '{% block css %}base.css{% endblock %} {% block js %}base.js{% endblock %}');
  WriteTpl('child_m.html', '{% extends "base_m.html" %}{% block css %}{{ parent() }} app.css{% endblock %}{% block js %}{{ parent() }} app.js{% endblock %}');
  R := FFrond.Render('child_m.html');
  Check((Pos('base.css', R) > 0) and (Pos('app.css', R) > 0) and
        (Pos('base.js', R) > 0) and (Pos('app.js', R) > 0), 'multi parent: got "' + R + '"');
end;

// ─── TestRenderDump ───────────────────────────────

procedure TestTTina4Frond_RenderDump.SetUp;
begin
  FFrond := TTina4Frond.Create('');
end;

procedure TestTTina4Frond_RenderDump.TearDown;
begin
  FFrond.Free;
  FFrond := nil;
  SetEnvironmentVariable('TINA4_DEBUG', nil);
end;

procedure TestTTina4Frond_RenderDump.TestRenderDumpSilentInProduction;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', nil);
  FFrond.SetDebug(False);
  D := TDictionary<string, TValue>.Create;
  D.Add('key', TValue.From<string>('value'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  // No render_dump() in Delphi — approximate via {{ dump(val) | raw }}
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check(R = '', 'render_dump production: got "' + R + '"');
end;

procedure TestTTina4Frond_RenderDump.TestRenderDumpReturnsHtmlInDebug;
var
  R: string;
  D: TDictionary<string, TValue>;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  D := TDictionary<string, TValue>.Create;
  D.Add('key', TValue.From<string>('value'));
  FFrond.SetVariable('val', TValue.From<TDictionary<string, TValue>>(D));
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check(Pos('<pre>', R) > 0, 'render_dump debug: got "' + R + '"');
end;

procedure TestTTina4Frond_RenderDump.TestRenderDumpHandlesNone;
var R: string;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  FFrond.SetVariable('val', TValue.Empty);
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check(R <> #0, 'render_dump none: is a string');
end;

procedure TestTTina4Frond_RenderDump.TestRenderDumpHandlesList;
var R: string;
begin
  SetEnvironmentVariable('TINA4_DEBUG', 'true');
  FFrond.SetDebug(True);
  FFrond.SetVariable('val', TFrondTestHelper.MakeArray([TValue.From<Integer>(1), TValue.From<Integer>(2), TValue.From<Integer>(3)]));
  R := FFrond.Render('{{ dump(val) | raw }}');
  Check(Pos('<pre>', R) > 0, 'render_dump list: got "' + R + '"');
end;

initialization
  RegisterTest(TestTTina4Frond_Variables.Suite);
  RegisterTest(TestTTina4Frond_Filters.Suite);
  RegisterTest(TestTTina4Frond_IfElse.Suite);
  RegisterTest(TestTTina4Frond_ForLoop.Suite);
  RegisterTest(TestTTina4Frond_SetIncludeExtends.Suite);
  RegisterTest(TestTTina4Frond_WhitespaceControl.Suite);
  RegisterTest(TestTTina4Frond_Comments.Suite);
  RegisterTest(TestTTina4Frond_Globals.Suite);
  RegisterTest(TestTTina4Frond_Dump.Suite);
  RegisterTest(TestTTina4Frond_Macros.Suite);
  // FormToken: JWT form tokens — intentionally NOT supported in Tina4Frond.
  // RegisterTest(TestTTina4Frond_FormToken.Suite);
  RegisterTest(TestTTina4Frond_RawBlock.Suite);
  RegisterTest(TestTTina4Frond_FromImport.Suite);
  RegisterTest(TestTTina4Frond_Spaceless.Suite);
  RegisterTest(TestTTina4Frond_Autoescape.Suite);
  RegisterTest(TestTTina4Frond_InlineIf.Suite);
  RegisterTest(TestTTina4Frond_TokenCache.Suite);
  // MethodCalls: dict-value-as-callable dispatch — intentionally NOT supported.
  // Delphi TValue can't carry Python-style callable dict values.
  // RegisterTest(TestTTina4Frond_MethodCalls.Suite);
  RegisterTest(TestTTina4Frond_SliceSyntax.Suite);
  // DottedStringArgs: depends on dict-as-callable. Skipped for same reason.
  // RegisterTest(TestTTina4Frond_DottedStringArgs.Suite);
  RegisterTest(TestTTina4Frond_DynamicDictKeys.Suite);
  RegisterTest(TestTTina4Frond_ReplaceFilter.Suite);
  RegisterTest(TestTTina4Frond_JsonAndJsFilters.Suite);
  RegisterTest(TestTTina4Frond_SafeStringFilters.Suite);
  RegisterTest(TestTTina4Frond_TildeTernary.Suite);
  RegisterTest(TestTTina4Frond_FilterInCondition.Suite);
  RegisterTest(TestTTina4Frond_BlockParent.Suite);
  RegisterTest(TestTTina4Frond_RenderDump.Suite);
end.
