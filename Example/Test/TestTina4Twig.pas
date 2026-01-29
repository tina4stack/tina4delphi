unit TestTina4Twig;

interface

uses
  TestFramework, Variants, System.Math, System.NetEncoding,
  System.Generics.Collections, JSON, System.SysUtils, System.Classes,
  System.RegularExpressions, System.Rtti, Tina4Twig;

type
  TestTTina4Twig = class(TTestCase)
  strict private
    FTina4Twig: TTina4Twig;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // TestRemoveComments
    procedure TestRemoveCommentsBasic;

    // TestSetVariable
    procedure TestSetVariablePeopleArray;
    procedure TestSetVariableSimpleName;
    procedure TestSetVariableSimpleNameInline;
    procedure TestSetVariableDateFunction;
    procedure TestSetVariableDateFormat;
    procedure TestSetVariableArrayWithMerge;
    procedure TestSetVariableArray;
    procedure TestIncrementingVariable;
    procedure TestComplexStringJSON;

    // TestTags
    procedure TestTagsWithBlockEmpty;
    procedure TestTagsWithBlockNoSpaces;
    procedure TestTagsIfBlock;
    procedure TestTagsIfBlockNoSpaces;
    procedure TestTagsForLoop;
    procedure TestTagsForLoopWithSpaces;

    // TestWith
    procedure TestWithNewVariablesOuterContext;
    procedure TestWithContextVariable;
    procedure TestWithEmptyBlock;
    procedure TestWithOnlyIsolation;
    procedure TestWithNestedBlocks;

    // TestTextExpressions
    procedure TestTextExpressionsArithmetic;
    procedure TestTextExpressionsStringAssignment;
    procedure TestTextExpressionsNumberIncrement;
    procedure TestTextExpressionsStringConcat;
    procedure TestTextExpressionsNumberFormatDash;
    procedure TestTextExpressionsNumberFormatDashRepeat;
    procedure TestTextExpressionsNumberFormatDotWithAddition;
    procedure TestTextExpressionsDictionaryAccess;
    procedure TestTextExpressionsDumpTasks;
    procedure TestTextExpressionsSequentialAssignment;

    // TestComplex
    procedure TestComplexForLoopWithIf;
    procedure TestComplexForLoopWithIfNoSpaces;
    procedure TestComplexDateOffsetDependencies;

    // TestDateFormat
    procedure TestDateFormatPlusOneDay;
    procedure TestDateFormatMinusTwoMonths;
    procedure TestDateFormatMultipleModifiers;
    procedure TestDateFormatInvalidDate;
    procedure TestDateFormatEmptyModifier;
    procedure TestDateFormatInvalidModifier;
    procedure TestDateFormatWithTime;

    // TestFilters
    procedure TestFiltersLastArray;
    procedure TestFiltersLastArrayWithSpaces;
    procedure TestFiltersLastArrayWithSpacesAlternate;
    procedure TestFiltersLastArrayNoSpaces;
    procedure TestFiltersLastString;
    procedure TestFiltersLastStringWithSpaces;
    procedure TestFiltersLastStringWithConcat;

    // TestForLoops
    procedure TestForLoopsEmptyWithElse;
    procedure TestForLoopsArrayOfObjects;
    procedure TestForLoopsJsonArray;
    procedure TestForLoopsInlineArray;
    procedure TestForLoopsDictionary;
    procedure TestForLoopsNested;
    procedure TestForLoopsSimpleArray;
    procedure TestForLoopsEmptyWithElseRepeat;
    procedure TestForLoopsRangeAscending;
    procedure TestForLoopsRangeDescending;
    procedure TestForLoopsDynamicRange;
    procedure TestForLoopsWithDateCondition;

    // TestFormat
    procedure TestFormatSimpleString;
    procedure TestFormatInteger;
    procedure TestFormatFloatPrecision;
    procedure TestFormatPadding;
    procedure TestFormatLeftJustify;
    procedure TestFormatZeroPad;
    procedure TestFormatSignPositive;
    procedure TestFormatSignNegative;
    procedure TestFormatArgNum;
    procedure TestFormatWidthAsterisk;
    procedure TestFormatPrecisionString;
    procedure TestFormatChar;
    procedure TestFormatPercentEscape;
    procedure TestFormatComplex;
    procedure TestFormatBinary;
    procedure TestFormatOctal;
    procedure TestFormatHexLower;
    procedure TestFormatHexUpper;
    procedure TestFormatScientificLower;
    procedure TestFormatScientificUpper;
    procedure TestFormatGeneral;
    procedure TestFormatUnsigned;

    // TestIf
    procedure TestIfTrueCondition;
    procedure TestIfFalseCondition;
    procedure TestIfWithElse;
    procedure TestIfWithComparison;
    procedure TestIfWithInOperator;
    procedure TestIfWithStartsWith;
    procedure TestIfWithMatches;
    procedure TestIfWithElseIf;
    procedure TestIfNested;
    procedure TestIfUserAgeGreaterThan35;
    procedure TestIfUserAgeSimple;
    procedure TestIfInForLoop;
    procedure TestIfWithAndConditionI7;
    procedure TestIfWithAndConditionI9;
    procedure TestIfWithAndConditionI5;
    procedure TestIfWithAndConditionI8;
    procedure TestIfWithAndConditionNotMet;

    // TestMacros
    procedure TestMacrosSingleInput;
    procedure TestMacrosMultipleMacros;

    // TestMinMax
    procedure TestMinMaxMaxDate;
    procedure TestMinMaxMinDate;
    procedure TestMinMaxNumericMin;
    procedure TestMinMaxNumericMax;

    // TestRender
    procedure TestRenderSimpleName;
    procedure TestRenderPeopleArray;
    procedure TestRenderSetName;
    procedure TestRenderExtendsBase;
    procedure TestRenderExtendsTitle;
    procedure TestRenderExtendsContent;
    procedure TestRenderExtendsBoth;
    procedure TestRenderDumpTrees;
    procedure TestRenderTreesIndex;
    procedure TestRenderTreesObject;
    procedure TestRenderTreesLength;
    procedure TestRenderUndefinedVariable;
    procedure TestRenderIfTrue;
    procedure TestRenderIfFalse;

    // TestRound
    procedure TestRoundDefaultPrecision;
    procedure TestRoundSpecifiedPrecision;
    procedure TestRoundFloor;
    procedure TestRoundCeil;
    procedure TestRoundIntegerInput;
    procedure TestRoundStringNumber;
    procedure TestRoundInvalidString;
    procedure TestRoundNegativeNumber;
    procedure TestRoundNegativeZeroPrecision;

    procedure TestMergeTwoArrays;
    procedure TestJSONDecode;
    procedure TestDumpJSONDecode;

    //Test Number format
    procedure TestNumberFormat;
  end;

implementation

procedure TestTTina4Twig.SetUp;
var
  PeopleArray: TArray<TValue>;
begin
  FTina4Twig := TTina4Twig.Create;

  FTina4Twig.SetVariable('name', 'Andre');
  FTina4Twig.SetVariable('age', 46);

  var PersonDict := TDictionary<String, TValue>.Create;
  PersonDict.Add('name', TValue.From<String>('Andre'));
  PersonDict.Add('age', TValue.From<Integer>(46));

  SetLength(PeopleArray, 2);
  PeopleArray[0] := TValue.From<TDictionary<String, TValue>>(PersonDict);
  PersonDict := TDictionary<String, TValue>.Create;
  PersonDict.Add('name', TValue.From<String>('Bob'));
  PersonDict.Add('age', TValue.From<Integer>(25));
  PeopleArray[1] := TValue.From<TDictionary<String, TValue>>(PersonDict);

  FTina4Twig.SetVariable('people', TValue.From<TArray<TValue>>(PeopleArray));

  var JSONArray := TJSONArray.Create;
  JSONArray.AddElement(TJSONString.Create('Alice'));
  JSONArray.AddElement(TJSONString.Create('Bob'));
  FTina4Twig.SetVariable('names', TValue.From<TJSONArray>(JSONArray));

  var PJSONArray := TJSONArray.Create;
  PJSONArray.Add(TJSONObject.ParseJSONValue('{"name": "Alice", "age": 22}') as TJSONObject);
  PJSONArray.Add(TJSONObject.ParseJSONValue('{"name": "Bob", "age": 50}') as TJSONObject);
  FTina4Twig.SetVariable('people_json', PJSONArray);

  FTina4Twig.SetVariable('persons', TValue.From<TArray<TValue>>([]));
end;

procedure TestTTina4Twig.TearDown;
begin
  FTina4Twig.Free;
  FTina4Twig := nil;
end;

// TestRemoveComments
procedure TestTTina4Twig.TestRemoveCommentsBasic;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{# Comments #}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be blank, got ' + ReturnValue);
end;

// TestSetVariable
procedure TestTTina4Twig.TestSetVariablePeopleArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{people[0].name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre', TemplateOrContent + ' - Should be Andre, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableSimpleName;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre', TemplateOrContent + ' - Should be Andre, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableSimpleNameInline;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set name = "Cris" %}{{name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Cris', TemplateOrContent + ' - Should be Cris, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableDateFunction;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set my_date = date(1) %}{{ date(1) }}{{ my_date }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1970-01-011970-01-01', TemplateOrContent + ' - Should be 1970-01-011970-01-01, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableArray;
var
  ReturnValue, TemplateOrContent: String;

begin
  TemplateOrContent := '{% set some_array = [] %}{% for i in 0..5 %}{% set some_array[] = i %}{% endfor %}{% for a in some_array %}{{a}}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '012345', TemplateOrContent + ' - Should be 012345, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableArrayWithMerge;
var
  ReturnValue, TemplateOrContent: String;
begin
  FTina4Twig.SetDebug();
  TemplateOrContent := '{% set days_total = (1000000 / 86400) | round(0, ''ceil'') %}{% set date_headers = [] %}{% for i in 0..days_total %}{% set date_headers = date_headers|merge([start_date|date_modify(''+'' ~ i ~ '' days'')|date(''Y-m-d'')]) %}{% endfor %}{{dump(date_headers)}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '-', TemplateOrContent + ' - Should be , got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestSetVariableDateFormat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date_format = '''+FormatSettings.ShortDateFormat+''' %}{% set current_date = "now" | date(date_format) %}{% set current_date = current_date | date_modify(''+1 day'') %}{{current_date}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = DateToStr(Now), TemplateOrContent + ' - Should be '+DateToStr(Now)+', got ' + ReturnValue);
end;

// TestTags
procedure TestTTina4Twig.TestTagsWithBlockEmpty;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with %}{% endwith %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTagsWithBlockNoSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%with%}{%endwith%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTagsIfBlock;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% if 1 == 1 %}{% else %}}{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTagsIfBlockNoSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%if 1 == 1%}{%else%}{%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTagsForLoop;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for a in [1,2,3]%}{%else%}{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTagsForLoopWithSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% for a in [1,2,3] %}{% else %}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Empty, got ' + ReturnValue);
end;

// TestWith
procedure TestTTina4Twig.TestWithNewVariablesOuterContext;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with { new_name: "Bob" } %}{{ people[0].name }} {{ new_name }}{% endwith %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre Bob', TemplateOrContent + ' - Should be Andre Bob, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestWithContextVariable;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with people[0] %}{{ name }} {{ age }}{% endwith %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre 46', TemplateOrContent + ' - Should be Andre 46, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestWithEmptyBlock;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with %}{% endwith %}{{ people[0].name }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre', TemplateOrContent + ' - Should be Andre, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestWithOnlyIsolation;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with { new_name: "Bob" } only %}{{ new_name }} {{ people[0].name }}{% endwith %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Bob ', TemplateOrContent + ' - Should be Bob (empty), got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestWithNestedBlocks;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% with { outer_name: "Outer" } %}{{ people[0].name }} {{ outer_name }} {% with { inner_name: "Inner" } %}{{ inner_name }} {{ outer_name }} {{ people[0].name }}{% endwith %}{% endwith %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre Outer Inner Outer Andre', TemplateOrContent + ' - Should be Andre Outer Inner Outer Andre, got ' + ReturnValue);
end;

// TestTextExpressions
procedure TestTTina4Twig.TestTextExpressionsArithmetic;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set value = ((200+300)) / 100 %}{{value}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '5', TemplateOrContent + ' - Should be 5, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsStringAssignment;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set name = "Something Cool" %}{{name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Something Cool', TemplateOrContent + ' - Should be Something Cool, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsNumberIncrement;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1 %}{{number + 1}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2', TemplateOrContent + ' - Should be 2, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsStringConcat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set name = "Jim" %}{{name ~ " Beam"}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Jim Beam', TemplateOrContent + ' - Should be Jim Beam, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsNumberFormatDash;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{number | number_format (2,"-") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1-86', TemplateOrContent + ' - Should be 1-86, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsNumberFormatDashRepeat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{number | number_format (2,"-") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1-86', TemplateOrContent + ' - Should be 1-86, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsNumberFormatDotWithAddition;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{number | number_format (2,".") + 2 }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '3.86', TemplateOrContent + ' - Should be 3.86, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsDictionaryAccess;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set user = {''name'': ''Fabien''} %}{{user.name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Fabien', TemplateOrContent + ' - Should be Fabien, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsDumpTasks;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set tasks = [{''id'': 1, ''name'': ''Test''},{''id'': 2, ''name'': ''Test 2''}] %}{{dump(tasks)}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '<pre>tasks =  array(2) {'#$D#$A'    [0]=>'#$D#$A'      array(2) {'#$D#$A'        ["id"]=>'#$D#$A'          int(1)'#$D#$A'        ["name"]=>'#$D#$A'          string(4) "Test"'#$D#$A'      }'#$D#$A'    [1]=>'#$D#$A'      array(2) {'#$D#$A'        ["id"]=>'#$D#$A'          int(2)'#$D#$A'        ["name"]=>'#$D#$A'          string(6) "Test 2"'#$D#$A'      }'#$D#$A'  }'#$D#$A'</pre>', TemplateOrContent + ' - Should be <pre>tasks ='#$D#$A'  array(2) {'#$D#$A'    [0]=>'#$D#$A'      array(2) {'#$D#$A'        ["id"]=>'#$D#$A'          int(1)'#$D#$A'        ["name"]=>'#$D#$A'          string(4) "Test"'#$D#$A'      }'#$D#$A'    [1]=>'#$D#$A'      array(2) {'#$D#$A'        ["id"]=>'#$D#$A'          int(2)'#$D#$A'        ["name"]=>'#$D#$A'          string(6) "Test 2"'#$D#$A'      }'#$D#$A'  }'#$D#$A'</pre>, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestTextExpressionsSequentialAssignment;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set a = 1 %} {{a}} {% set a = a + 1 %} {{a}} {% set a = a + 1 %} {{a}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = ' 1  2  3', TemplateOrContent + ' - Should be  1  2  3, got ' + ReturnValue);
end;

// TestComplex
procedure TestTTina4Twig.TestComplexForLoopWithIf;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set trees = [{"name": "Beech"}, {"name": "Oak"}, {"name": "Poplar"}]%}{%for a in trees%}{% if a.name == "Oak" %}OK{% else %}NO{% endif %}{% else %}No trees{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'NOOKNO', TemplateOrContent + ' - Should be NOOKNO, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestComplexForLoopWithIfNoSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set trees = [{"name": "Beech"}, {"name": "Oak"}, {"name": "Poplar"}]%}{%for a in trees%}{% if a.name == "Oak" %}OK{% else %}NO{% endif %}{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'NOOKNO', TemplateOrContent + ' - Should be NOOKNO, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestComplexStringJSON;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('error', '{"statusCode":"0","response":"{\"error\": \"Error sending data: (12029) A connection with the server could not be established\"}"}');
  ReturnValue := FTina4Twig.Render(
  '{% if error %}{% set message = error | json_decode %}{% if message.response %}{% set message = message.response | json_decode %}{% endif %}{% if message.error %}<h3 class="error-message">{{ message.error }}</h3>{% endif %}{% if message.message.error_description %}<h3 class="error-message">{{ message.message.error_description }}</h3>{% endif %}{% endif %}');

  Check(ReturnValue = '<h3 class="error-message">Error sending data: (12029) A connection with the server could not be established</h3>', TemplateOrContent + ' - Should be <h3 class="error-message">Error sending data: (12029) A connection with the server could not be established</h3>, got ' + ReturnValue);


end;

procedure TestTTina4Twig.TestComplexDateOffsetDependencies;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set start_date = "2025-08-01" %}{% set tasks = [{"name": "Project Kickoff", "start_date": "2025-08-01", "end_date": "2025-08-05", "duration": 4, "dependencies": []}, {"name": "Design Phase", "start_date": "2025-08-03", "end_date": "2025-08-10", "duration": 7, "dependencies": ["Project Kickoff"]}, {"name": "Development", "start_date": "2025-08-08", "end_date": "2025-08-15", "duration": 7, "dependencies": ["Design Phase"]}, {"name": "Testing", "start_date": "2025-08-12", "end_date": "2025-08-18", "duration": 6, "dependencies": ["Development"]}] %}{% for task in tasks %}{% set start_offset = ((start_date | date("U") - tasks[0].start_date | date("U") / 86400)) | round %}{{start_offset}}{% if task.dependencies|length > 0 %}{{ task.dependencies|join(", ") }}{% else %}None{% endif %}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1753986099None1753986099Project Kickoff1753986099Design Phase1753986099Development', TemplateOrContent + ' - Should be 1753986099None1753986099Project Kickoff1753986099Design Phase1753986099Development, got ' + ReturnValue);
end;

// TestDateFormat
procedure TestTTina4Twig.TestDateFormatPlusOneDay;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15" %}{{ date | date_modify("+1 day") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-10-16', TemplateOrContent + ' - Should be 2023-10-16 00:00:00, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatMinusTwoMonths;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15" %}{{ date | date_modify("-2 months") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-08-15', TemplateOrContent + ' - Should be 2023-08-15 00:00:00, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatMultipleModifiers;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15" %}{{ date | date_modify("+1 year +2 months -3 days") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2024-12-12', TemplateOrContent + ' - Should be 2024-12-12 00:00:00, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatInvalidDate;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "invalid-date" %}{{ date | date_modify("+1 day") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'invalid-date', TemplateOrContent + ' - Should return input string for invalid date, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatEmptyModifier;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15" %}{{ date | date_modify("") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-10-15', TemplateOrContent + ' - Should return original date for empty modifier, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatInvalidModifier;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15" %}{{ date | date_modify("invalid") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-10-15', TemplateOrContent + ' - Should return original date string for invalid modifier, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDateFormatWithTime;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set date = "2023-10-15 14:30:00" %}{{ date | date_modify("+1 hour") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-10-15 15:30:00', TemplateOrContent + ' - Should be 2023-10-15 15:30:00, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestDumpJSONDecode;
var
  ReturnValue, TemplateOrContent: string;

begin
  FTina4Twig.SetVariable('text', '{"something": "Hello", "messages": [{"id": 1, "message": "Hello 1"}, {"id": 2, "message": "Hello 2"}], "complex": {"name": "Test", "colors": ["red", "green", "yellow"]}}');
  FTina4Twig.SetDebug(True);
  TemplateOrContent := '{% set data = text | json_decode %} {{ dump(data) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(Pos('Hello 1', ReturnValue) <> 0 , TemplateOrContent + ' - Should be a dump, got ' + ReturnValue);
end;


// TestFilters
procedure TestTTina4Twig.TestFiltersLastArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ [1, 2, 3, 4]|last }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastArrayWithSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ [1, 2, 3, 4] | last }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastArrayWithSpacesAlternate;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ [1, 2, 3, 4] | last }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastArrayNoSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{[1, 2, 3, 4]|last}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastString;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{"1234"|last}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastStringWithSpaces;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ "1234" | last }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4', TemplateOrContent + ' - Should be 4, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFiltersLastStringWithConcat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ "1234" | last ~ "5" }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '45', TemplateOrContent + ' - Should be 45, got ' + ReturnValue);
end;

// TestForLoops
procedure TestTTina4Twig.TestForLoopsEmptyWithElse;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for a in persons%}{{a}}{%else%}No persons{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'No persons', TemplateOrContent + ' - Should be No persons, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsArrayOfObjects;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for person in people%}{{person.name}} {%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre Bob ', TemplateOrContent + ' - Should be Andre Bob , got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsJsonArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% for name in names %}{{name}} {% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Alice Bob ', TemplateOrContent + ' - Should be Alice Bob , got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsInlineArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for item in [1, 2, 3]%}{{item}} {%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1 2 3 ', TemplateOrContent + ' - Should be 1 2 3 , got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsDictionary;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for value in people[0]%}{{value}} {%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue.Contains('Andre') and ReturnValue.Contains('46'), TemplateOrContent + ' - Should contain Andre and 46, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsNested;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for person in people%}{%for name in names%}{{person.name}}-{{name}} {%endfor%}{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre-Alice Andre-Bob Bob-Alice Bob-Bob ', TemplateOrContent + ' - Should be Andre-Alice Andre-Bob Bob-Alice Bob-Bob , got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsSimpleArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for a in [1,2,3]%}{{a}}{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '123', TemplateOrContent + ' - Should be 123, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsEmptyWithElseRepeat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%for a in persons%}{{a}}{%else%}No persons{%endfor%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'No persons', TemplateOrContent + ' - Should be No persons, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsRangeAscending;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% for i in 0..5 %}{{i}}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '012345', TemplateOrContent + ' - Should be 012345, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsRangeDescending;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% for i in 5..1 %}{{i}}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '54321', TemplateOrContent + ' - Should be 54321, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsDynamicRange;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set total_days = 3 %}{% for i in 0..(total_days - 1) %}OK{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'OKOKOK', TemplateOrContent + ' - Should be OKOKOK, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestForLoopsWithDateCondition;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set current_date = "2023-01-01" %}{% set max_date = "2023-12-31" %}{% for i in 0..1000 if current_date <= max_date %}OK{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(Length(ReturnValue) = 1001 * Length('OK'), TemplateOrContent + ' - Should be OK repeated 1001 times, got length ' + IntToStr(Length(ReturnValue)));
end;

// TestFormat
procedure TestTTina4Twig.TestFormatSimpleString;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('value', 'World');
  TemplateOrContent := '{{ "Hello %s"|format(value) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Hello World', TemplateOrContent + ' - Should be "Hello World", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatInteger;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 123);
  TemplateOrContent := '{{ "Number %d"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Number 123', TemplateOrContent + ' - Should be "Number 123", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatFloatPrecision;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('pi', 3.14159);
  TemplateOrContent := '{{ "Pi is %.2f"|format(pi) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Pi is 3.14', TemplateOrContent + ' - Should be "Pi is 3.14", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatPadding;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('text', 'hello');
  TemplateOrContent := '{{ "%10s"|format(text) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '     hello', TemplateOrContent + ' - Should be "     hello", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatLeftJustify;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('text', 'hello');
  TemplateOrContent := '{{ "%-10s"|format(text) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'hello     ', TemplateOrContent + ' - Should be "hello     ", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatZeroPad;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 42);
  TemplateOrContent := '{{ "%010d"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '0000000042', TemplateOrContent + ' - Should be "0000000042", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatSignPositive;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 42);
  TemplateOrContent := '{{ "%+d"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '+42', TemplateOrContent + ' - Should be "+42", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatSignNegative;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', -42);
  TemplateOrContent := '{{ "%+d"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '-42', TemplateOrContent + ' - Should be "-42", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatArgNum;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('word1', 'world');
  FTina4Twig.SetVariable('word2', 'hello');
  TemplateOrContent := '{{ "%2$s %1$s"|format(word1, word2) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'hello world', TemplateOrContent + ' - Should be "hello world", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatWidthAsterisk;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('width', 10);
  FTina4Twig.SetVariable('text', 'hello');
  TemplateOrContent := '{{ "%*s"|format(width, text) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '     hello', TemplateOrContent + ' - Should be "     hello", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatPrecisionString;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('text', 'hello');
  TemplateOrContent := '{{ "%.3s"|format(text) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'hel', TemplateOrContent + ' - Should be "hel", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatChar;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('code', 65

);
  TemplateOrContent := '{{ "%c"|format(code) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'A', TemplateOrContent + ' - Should be "A", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatPercentEscape;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ "100%%"|format }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '100%', TemplateOrContent + ' - Should be "100%", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatComplex;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 42);
  TemplateOrContent := '{{ "%1$+5d"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '  +42', TemplateOrContent + ' - Should be "  +42", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatBinary;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 10);
  TemplateOrContent := '{{ "%b"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1010', TemplateOrContent + ' - Should be "1010", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatOctal;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 8);
  TemplateOrContent := '{{ "%o"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '10', TemplateOrContent + ' - Should be "10", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatHexLower;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 255);
  TemplateOrContent := '{{ "%x"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'ff', TemplateOrContent + ' - Should be "ff", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatHexUpper;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 255);
  TemplateOrContent := '{{ "%X"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'FF', TemplateOrContent + ' - Should be "FF", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatScientificLower;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 1234.56);
  TemplateOrContent := '{{ "%e"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1.234560e+3', TemplateOrContent + ' - Should be "1.234560e+3", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatScientificUpper;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 1234.56);
  TemplateOrContent := '{{ "%E"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1.234560E+3', TemplateOrContent + ' - Should be "1.234560E+3", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatGeneral;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 1234.56);
  TemplateOrContent := '{{ "%g"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1234.56', TemplateOrContent + ' - Should be "1234.56", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestFormatUnsigned;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', 4294967295);
  TemplateOrContent := '{{ "%u"|format(number) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '4294967295', TemplateOrContent + ' - Should be "4294967295", got ' + ReturnValue);
end;

// TestIf
procedure TestTTina4Twig.TestIfTrueCondition;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('is_active', TValue.From<Boolean>(True));
  TemplateOrContent := '{%if is_active %}Active{%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Active', TemplateOrContent + ' - Should be Active, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfFalseCondition;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('is_inactive', TValue.From<Boolean>(False));
  TemplateOrContent := '{%if is_inactive %}Inactive{%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be empty, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithElse;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('is_inactive', TValue.From<Boolean>(False));
  TemplateOrContent := '{% if is_inactive %}Inactive{% else %}Active{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Active', TemplateOrContent + ' - Should be Active, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithComparison;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', TValue.From<Integer>(42));
  TemplateOrContent := '{% if number > 40 %}Greater{% elseif number < 40 %}Less{% elseif number == 40 %}Equal{% else %}Exact{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Greater', TemplateOrContent + ' - Should be Greater, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithInOperator;
var
  ReturnValue, TemplateOrContent: string;
begin
  var Arr: TArray<TValue> := [TValue.From<String>('apple'), TValue.From<String>('banana'), TValue.From<String>('orange')];
  FTina4Twig.SetVariable('fruits', TValue.From<TArray<TValue>>(Arr));
  TemplateOrContent := '{% if "banana" in fruits %}Found{% else %}Not Found{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Found', TemplateOrContent + ' - Should be Found, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithStartsWith;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('text', TValue.From<String>('Hello World'));
  TemplateOrContent := '{% if text starts with "Hello" %}Starts Hello{% else %}Does Not Start{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Starts Hello', TemplateOrContent + ' - Should be Starts Hello, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIncrementingVariable;
var
  ReturnValue, TemplateOrContent: String;

begin
  TemplateOrContent := '{% set some_var = 1 %}{% for i in 0..5 %}{% set some_var = some_var + 1 %}{% endfor %}{{some_var}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '7', TemplateOrContent + ' - Should be 7, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestJSONDecode;
var
  ReturnValue, TemplateOrContent: string;

begin
  FTina4Twig.SetVariable('text', '{"something": "Hello", "messages": [{"id": 1, "message": "Hello 1"}, {"id": 2, "message": "Hello 2"}], "complex": {"name": "Test", "colors": ["red", "green", "yellow"]}}');
  FTina4Twig.SetDebug(True);
  TemplateOrContent := '{% set data = text | json_decode %}{{data.something}} {% for message in data.messages %}1{{message.id}} {% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Hello 11 12 ', TemplateOrContent + ' - Should be Hello 11 12, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithMatches;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('text', TValue.From<String>('Hello World'));
  TemplateOrContent := '{% if text matches "^Hello.*" %}Matches{% else %}No Match{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Matches', TemplateOrContent + ' - Should be Matches, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithElseIf;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('number', TValue.From<Integer>(42));
  TemplateOrContent := '{% if number == 0 %}Zero{% elseif number == 42 %}Forty-Two{% else %}Other{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Forty-Two', TemplateOrContent + ' - Should be Forty-Two, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfNested;
var
  ReturnValue, TemplateOrContent: string;
begin
  FTina4Twig.SetVariable('is_active', TValue.From<Boolean>(True));
  FTina4Twig.SetVariable('number', TValue.From<Integer>(42));
  TemplateOrContent := '{% if is_active %}{% if number > 40 %}High{% else %}Low{% endif %}{% else %}Inactive{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'High', TemplateOrContent + ' - Should be High, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfUserAgeGreaterThan35;
var
  ReturnValue, TemplateOrContent: string;
begin
  var Dict := TDictionary<String, TValue>.Create;
  Dict.Add('name', TValue.From<String>('Alice'));
  Dict.Add('age', TValue.From<Integer>(36));
  FTina4Twig.SetVariable('user', TValue.From<TDictionary<String, TValue>>(Dict));
  TemplateOrContent := '{%if user.age > 35 %}Older than 35{%else%}Younger than 35{%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Older than 35', TemplateOrContent + ' - Should be Older than 35, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfUserAgeSimple;
var
  ReturnValue, TemplateOrContent: string;
begin
  var Dict := TDictionary<String, TValue>.Create;
  Dict.Add('name', TValue.From<String>('Alice'));
  Dict.Add('age', TValue.From<Integer>(36));
  FTina4Twig.SetVariable('user', TValue.From<TDictionary<String, TValue>>(Dict));
  TemplateOrContent := '{%if user.age > 35 %}Older than 35{%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Older than 35', TemplateOrContent + ' - Should be Older than 35, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfInForLoop;
var
  ReturnValue, TemplateOrContent: string;
begin
  var Dict := TDictionary<String, TValue>.Create;
  Dict.Add('name', TValue.From<String>('Alice'));
  Dict.Add('age', TValue.From<Integer>(36));
  FTina4Twig.SetVariable('user', TValue.From<TDictionary<String, TValue>>(Dict));
  TemplateOrContent := '{% for data in user %}{{data}}{%if age > 35 %}Older than 35{%endif%}{% endfor %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '36Older than 35AliceOlder than 35', TemplateOrContent + ' - Should be 36Older than 35AliceOlder than 35, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithAndConditionI7;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set i = 7%} {%set start_days = 5 %} {%set duration_days = 4%} {% if (i >= start_days) and (i < (start_days + duration_days)) %} OK {%else%} NO {%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '    OK ', TemplateOrContent + ' - Should be " OK", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithAndConditionI9;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set i = 9%} {%set start_days = 5 %} {%set duration_days = 4%} {% if (i >= start_days) and (i < (start_days + duration_days)) %} OK {%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '   ', TemplateOrContent + ' - Should be "", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithAndConditionI5;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set i = 5%} {%set start_days = 5 %} {%set duration_days = 4%} {% if (i >= start_days) and (i < (start_days + duration_days)) %} OK {%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '    OK ', TemplateOrContent + ' - Should be " OK", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithAndConditionI8;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set i = 8%} {%set start_days = 5 %} {%set duration_days = 4%} {% if (i >= start_days) and (i < (start_days + duration_days)) %} OK {%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '    OK ', TemplateOrContent + ' - Should be " OK", got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestIfWithAndConditionNotMet;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set i = 9%} {%set start_days = 5 %} {%set duration_days = 4%} {% if (i >= start_days) and (i < (start_days + duration_days)) %} OK {%else%} NOT OK {%endif%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '    NOT OK ', TemplateOrContent + ' - Should be " NOT OK", got ' + ReturnValue);
end;

// TestMacros
procedure TestTTina4Twig.TestMacrosSingleInput;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% macro input(name, value, type = "text", size = 20) %}<input type="{{ type }}" name="{{ name }}" value="{{ value|e }}" size="{{ size }}"/>{% endmacro %}{{input("Test")}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '<input type="text" name="Test" value="" size="20"/>', TemplateOrContent + ' - Should be <input type="text" name="Test" value="" size="20"/>, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestMergeTwoArrays;
var
  ReturnValue, TemplateOrContent: String;
begin
  TemplateOrContent := '{{ names | merge(["Charlie", "David"]) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'AliceBobCharlieDavid', TemplateOrContent + ' - Should be AliceBobCharlieDavid, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestMacrosMultipleMacros;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% macro a(name, value, type = "text", size = 20) %}A<input type="{{ type }}" name="{{ name }}" value="{{ value|e }}" size="{{ size }}"/>{% endmacro %}{% macro b(name, value, type = "text", size = 20) %}B<input type="{{ type }}" name="{{ name }}" value="{{ value|e }}" size="{{ size }}"/>{% endmacro %}{{a("Test")}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'A<input type="text" name="Test" value="" size="20"/>', TemplateOrContent + ' - Should be A<input type="text" name="Test" value="" size="20"/>, got ' + ReturnValue);
end;

// TestMinMax
procedure TestTTina4Twig.TestMinMaxMaxDate;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set tasks = [{"end_date": "2023-01-01"}, {"end_date": "2023-02-01"}] %}{% set max_date = tasks|map(task => task.end_date)|max %}{{max_date}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-02-01', TemplateOrContent + ' - Should be 2023-02-01, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestMinMaxMinDate;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set tasks = [{"end_date": "2023-01-01"}, {"end_date": "2023-02-01"}] %}{% set min_date = tasks|map(task => task.end_date)|min %}{{min_date}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2023-01-01', TemplateOrContent + ' - Should be 2023-01-01, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestMinMaxNumericMin;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set numbers = [5, 2, 8, 1] %}{{ numbers|min }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1', TemplateOrContent + ' - Should be 1, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestNumberFormat;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{ -9800.333|number_format(2, ".", ",") }}{{ (-9800.333)|number_format(2, ".", ",")}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '-9-9,800.33', TemplateOrContent + ' - Should be -9-9,800.33, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestMinMaxNumericMax;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set numbers = [5, 2, 8, 1] %}{{ numbers|max }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '8', TemplateOrContent + ' - Should be 8, got ' + ReturnValue);
end;

// TestRender
procedure TestTTina4Twig.TestRenderSimpleName;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre', TemplateOrContent + ' - Should be Andre, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderPeopleArray;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{people[0].name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Andre', TemplateOrContent + ' - Should be Andre, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderSetName;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set name = "Hello"%}{{name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Hello', TemplateOrContent + ' - Should be Hello, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderExtendsBase;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% extends "base.twig" %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Original TitleOriginal Content', TemplateOrContent + ' - Should be Original TitleOriginal Content, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderExtendsTitle;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% extends "base.twig" %}{%block title%}My Title{%endblock%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'My TitleOriginal Content', TemplateOrContent + ' - Should be My TitleOriginal Content, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderExtendsContent;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% extends "base.twig" %}{%block content%}My Content{%endblock%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Original TitleMy Content', TemplateOrContent + ' - Should be Original TitleMy Content, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderExtendsBoth;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% extends "base.twig" %}{%block title%}My Title{%endblock%}{%block content%}My Content{%endblock%}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'My TitleMy Content', TemplateOrContent + ' - Should be My TitleMy Content, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderDumpTrees;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set trees = ["Beech", "Oak", "Popular"] %}{{dump(trees)}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '<pre>trees =  array(3) {'#$D#$A'    [0]=>'#$D#$A'      string(5) "Beech"'#$D#$A'    [1]=>'#$D#$A'      string(3) "Oak"'#$D#$A'    [2]=>'#$D#$A'      string(7) "Popular"'#$D#$A'  }'#$D#$A'</pre>', TemplateOrContent + ' - Should be array, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderTreesIndex;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set trees = ["Beech", "Oak", "Poplar"] %}{{trees[1]}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Oak', TemplateOrContent + ' - Should be Oak, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderTreesObject;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set trees = [{"name": "Beech"}, {"name": "Oak"}, {"name": "Poplar"}] %}{{trees[2].name}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Poplar', TemplateOrContent + ' - Should be Poplar, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderTreesLength;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{%set trees = [{"name": "Beech"}, {"name": "Oak"}, {"name": "Poplar"}]%}{{trees | length}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '3', TemplateOrContent + ' - Should be 3, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderUndefinedVariable;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{{Moo}}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '', TemplateOrContent + ' - Should be Blank, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderIfTrue;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% if name == "Andre" %}Yes{% else %}No{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'Yes', TemplateOrContent + ' - Should be Yes, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRenderIfFalse;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% if name != "Andre" %}Yes{% else %}No{% endif %}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'No', TemplateOrContent + ' - Should be No, got ' + ReturnValue);
end;

// TestRound
procedure TestTTina4Twig.TestRoundDefaultPrecision;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{ number | round }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '2', TemplateOrContent + ' - Should be 2, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundSpecifiedPrecision;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{ number | round(2) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1.86', TemplateOrContent + ' - Should be 1.86, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundFloor;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{ number | round(2, "floor") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1.85', TemplateOrContent + ' - Should be 1.85, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundCeil;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 1.859 %}{{ number | round(2, "ceil") }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '1.86', TemplateOrContent + ' - Should be 1.86, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundIntegerInput;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = 5 %}{{ number | round(2) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '5.00', TemplateOrContent + ' - Should be 5.00, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundStringNumber;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = "3.14159" %}{{ number | round(3) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '3.142', TemplateOrContent + ' - Should be 3.142, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundInvalidString;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = "invalid" %}{{ number | round(2) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = 'invalid', TemplateOrContent + ' - Should return input string for invalid number, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundNegativeNumber;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = -3.14159 %}{{ number | round(2) }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '-3.14', TemplateOrContent + ' - Should be -3.14, got ' + ReturnValue);
end;

procedure TestTTina4Twig.TestRoundNegativeZeroPrecision;
var
  ReturnValue, TemplateOrContent: string;
begin
  TemplateOrContent := '{% set number = -3.14159 %}{{ number | round }}';
  ReturnValue := FTina4Twig.Render(TemplateOrContent);
  Check(ReturnValue = '-3', TemplateOrContent + ' - Should be -3, got ' + ReturnValue);
end;

initialization
  RegisterTest(TestTTina4Twig.Suite);
end.
