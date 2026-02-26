unit TestTina4Core;

interface

uses
  TestFramework, System.SysUtils, System.Classes, System.DateUtils,
  System.Variants, System.NetEncoding, JSON,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Phys.Intf, FireDAC.Comp.DataSet, Data.DB,
  Tina4Core;

type
  TestTTina4Core = class(TTestCase)
  strict private
    FMemTable: TFDMemTable;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // CamelCase
    procedure TestCamelCaseSnakeInput;
    procedure TestCamelCaseSingleWord;
    procedure TestCamelCaseMultipleUnderscores;

    // SnakeCase
    procedure TestSnakeCaseCamelInput;
    procedure TestSnakeCaseSingleWord;
    procedure TestSnakeCaseRoundTrip;

    // GetGUID
    procedure TestGetGUIDNotEmpty;
    procedure TestGetGUIDUnique;

    // IsDate
    procedure TestIsDateISO8601;
    procedure TestIsDateShort;
    procedure TestIsDateUSFormat;
    procedure TestIsDateNumber;
    procedure TestIsDateString;
    procedure TestIsDateEmpty;
    procedure TestIsDateVariantDate;

    // GetJSONDate / JSONDateToDateTime
    procedure TestGetJSONDateRoundTrip;
    procedure TestJSONDateToDateTimeValid;

    // DecodeBase64
    procedure TestDecodeBase64;

    // FileToBase64
    procedure TestFileToBase64NotFound;

    // StrToJSONObject
    procedure TestStrToJSONObjectValid;
    procedure TestStrToJSONObjectInvalid;

    // StrToJSONValue
    procedure TestStrToJSONValueObject;
    procedure TestStrToJSONValueString;

    // StrToJSONArray
    procedure TestStrToJSONArrayValid;
    procedure TestStrToJSONArrayInvalid;

    // BytesToJSONObject
    procedure TestBytesToJSONObject;

    // GetJSONFieldName
    procedure TestGetJSONFieldName;
    procedure TestGetJSONFieldNameNoQuotes;

    // GetFieldDefsFromJSONObject
    procedure TestGetFieldDefsFromJSONObject;
    procedure TestGetFieldDefsSnakeCase;

    // PopulateMemTableFromJSON
    procedure TestPopulateMemTableClearMode;
    procedure TestPopulateMemTableSyncModeInsert;
    procedure TestPopulateMemTableSyncModeUpdate;

    // GetJSONFromTable (MemTable)
    procedure TestGetJSONFromMemTable;
    procedure TestGetJSONFromMemTableIgnoreFields;
    procedure TestGetJSONFromMemTableIgnoreBlanks;
  end;

implementation

procedure TestTTina4Core.SetUp;
begin
  FMemTable := TFDMemTable.Create(nil);
end;

procedure TestTTina4Core.TearDown;
begin
  FMemTable.Free;
  FMemTable := nil;
end;

// ---------------------------------------------------------------------------
// CamelCase
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestCamelCaseSnakeInput;
begin
  CheckEquals('firstName', CamelCase('first_name'), 'first_name should become firstName');
end;

procedure TestTTina4Core.TestCamelCaseSingleWord;
begin
  CheckEquals('id', CamelCase('id'), 'id should remain id');
end;

procedure TestTTina4Core.TestCamelCaseMultipleUnderscores;
begin
  CheckEquals('userFirstName', CamelCase('user_first_name'), 'user_first_name should become userFirstName');
end;

// ---------------------------------------------------------------------------
// SnakeCase
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestSnakeCaseCamelInput;
begin
  CheckEquals('first_name', SnakeCase('firstName'), 'firstName should become first_name');
end;

procedure TestTTina4Core.TestSnakeCaseSingleWord;
begin
  CheckEquals('id', SnakeCase('id'), 'id should remain id');
end;

procedure TestTTina4Core.TestSnakeCaseRoundTrip;
begin
  CheckEquals('first_name', SnakeCase(CamelCase('first_name')),
    'SnakeCase(CamelCase(first_name)) should round-trip back to first_name');
end;

// ---------------------------------------------------------------------------
// GetGUID
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestGetGUIDNotEmpty;
begin
  Check(GetGUID <> '', 'GetGUID should return a non-empty string');
end;

procedure TestTTina4Core.TestGetGUIDUnique;
var
  GUID1, GUID2: String;
begin
  GUID1 := GetGUID;
  GUID2 := GetGUID;
  Check(GUID1 <> GUID2, 'Two calls to GetGUID should produce different values');
end;

// ---------------------------------------------------------------------------
// IsDate
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestIsDateISO8601;
begin
  Check(IsDate('2024-01-15T10:30:00') = True, 'ISO8601 date should be recognised');
end;

procedure TestTTina4Core.TestIsDateShort;
begin
  Check(IsDate('2024-01-15') = True, 'YYYY-MM-DD date should be recognised');
end;

procedure TestTTina4Core.TestIsDateUSFormat;
begin
  Check(IsDate('01/15/2024') = True, 'MM/DD/YYYY date should be recognised');
end;

procedure TestTTina4Core.TestIsDateNumber;
begin
  Check(IsDate(42) = False, 'Integer should not be a date');
end;

procedure TestTTina4Core.TestIsDateString;
begin
  Check(IsDate('hello') = False, 'Random string should not be a date');
end;

procedure TestTTina4Core.TestIsDateEmpty;
begin
  Check(IsDate('') = False, 'Empty string should not be a date');
end;

procedure TestTTina4Core.TestIsDateVariantDate;
begin
  Check(IsDate(VarFromDateTime(Now)) = True, 'Variant date should be recognised');
end;

// ---------------------------------------------------------------------------
// GetJSONDate / JSONDateToDateTime
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestGetJSONDateRoundTrip;
var
  Original, RoundTripped: TDateTime;
  ISOString: String;
begin
  Original := EncodeDateTime(2024, 6, 15, 14, 30, 0, 0);
  ISOString := GetJSONDate(Original);
  RoundTripped := JSONDateToDateTime(ISOString);
  // Compare with second precision (ISO8601 may lose milliseconds)
  Check(Abs(SecondsBetween(Original, RoundTripped)) < 2,
    'GetJSONDate -> JSONDateToDateTime should round-trip within 1 second');
end;

procedure TestTTina4Core.TestJSONDateToDateTimeValid;
var
  DT: TDateTime;
begin
  DT := JSONDateToDateTime('2024-06-15T14:30:00');
  CheckEquals(2024, YearOf(DT), 'Year should be 2024');
  CheckEquals(6, MonthOf(DT), 'Month should be 6');
  CheckEquals(15, DayOf(DT), 'Day should be 15');
end;

// ---------------------------------------------------------------------------
// DecodeBase64
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestDecodeBase64;
begin
  CheckEquals('Hello', DecodeBase64('SGVsbG8='), 'Should decode base64 to Hello');
end;

// ---------------------------------------------------------------------------
// FileToBase64
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestFileToBase64NotFound;
var
  RaisedException: Boolean;
begin
  RaisedException := False;
  try
    FileToBase64('C:\nonexistent_file_that_does_not_exist.xyz');
  except
    on E: EFileNotFoundException do
      RaisedException := True;
  end;
  Check(RaisedException, 'FileToBase64 should raise EFileNotFoundException for missing files');
end;

// ---------------------------------------------------------------------------
// StrToJSONObject
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestStrToJSONObjectValid;
var
  Obj: TJSONObject;
begin
  Obj := StrToJSONObject('{"name":"test","value":42}');
  try
    Check(Assigned(Obj), 'Should parse valid JSON object');
    CheckEquals('test', Obj.GetValue<String>('name'), 'name should be test');
  finally
    Obj.Free;
  end;
end;

procedure TestTTina4Core.TestStrToJSONObjectInvalid;
var
  Obj: TJSONObject;
begin
  Obj := StrToJSONObject('this is not json');
  Check(not Assigned(Obj), 'Invalid JSON should return nil');
end;

// ---------------------------------------------------------------------------
// StrToJSONValue
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestStrToJSONValueObject;
var
  Val: TJSONValue;
begin
  Val := StrToJSONValue('{"key":"value"}');
  try
    Check(Assigned(Val), 'Should parse valid JSON value');
    Check(Val is TJSONObject, 'Should be a TJSONObject');
  finally
    Val.Free;
  end;
end;

procedure TestTTina4Core.TestStrToJSONValueString;
var
  Val: TJSONValue;
begin
  Val := StrToJSONValue('"hello"');
  try
    Check(Assigned(Val), 'Should parse JSON string value');
    CheckEquals('hello', Val.Value, 'Should equal hello');
  finally
    Val.Free;
  end;
end;

// ---------------------------------------------------------------------------
// StrToJSONArray
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestStrToJSONArrayValid;
var
  Arr: TJSONArray;
begin
  Arr := StrToJSONArray('[1, 2, 3]');
  try
    Check(Assigned(Arr), 'Should parse valid JSON array');
    CheckEquals(3, Arr.Count, 'Array should have 3 elements');
  finally
    Arr.Free;
  end;
end;

procedure TestTTina4Core.TestStrToJSONArrayInvalid;
var
  Arr: TJSONArray;
begin
  Arr := StrToJSONArray('not an array');
  Check(not Assigned(Arr), 'Invalid JSON should return nil');
end;

// ---------------------------------------------------------------------------
// BytesToJSONObject
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestBytesToJSONObject;
var
  Bytes: TBytes;
  Obj: TJSONObject;
begin
  Bytes := TEncoding.UTF8.GetBytes('{"ok":true}');
  Obj := BytesToJSONObject(Bytes);
  try
    Check(Assigned(Obj), 'Should parse TBytes to TJSONObject');
  finally
    Obj.Free;
  end;
end;

// ---------------------------------------------------------------------------
// GetJSONFieldName
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestGetJSONFieldName;
begin
  CheckEquals('firstName', GetJSONFieldName('"firstName"'),
    'Should strip surrounding quotes');
end;

procedure TestTTina4Core.TestGetJSONFieldNameNoQuotes;
begin
  CheckEquals('id', GetJSONFieldName('id'),
    'Should return original if no quotes');
end;

// ---------------------------------------------------------------------------
// GetFieldDefsFromJSONObject
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestGetFieldDefsFromJSONObject;
var
  JSONObj: TJSONObject;
begin
  JSONObj := StrToJSONObject('{"name":"Andre","age":"30","address":{"city":"Cape Town"}}');
  try
    GetFieldDefsFromJSONObject(JSONObj, FMemTable, False);
    Check(FMemTable.FieldDefs.Count = 3, 'Should create 3 field defs');
    Check(FMemTable.FieldDefs.IndexOf('name') >= 0, 'Should have name field');
    Check(FMemTable.FieldDefs.IndexOf('age') >= 0, 'Should have age field');
    Check(FMemTable.FieldDefs.IndexOf('address') >= 0, 'Should have address field');
    // Nested object should be ftMemo
    CheckEquals(Ord(TFieldType.ftMemo), Ord(FMemTable.FieldDefs.Find('address').DataType),
      'Nested object field should be ftMemo');
  finally
    JSONObj.Free;
  end;
end;

procedure TestTTina4Core.TestGetFieldDefsSnakeCase;
var
  JSONObj: TJSONObject;
begin
  JSONObj := StrToJSONObject('{"firstName":"Andre","lastName":"Smith"}');
  try
    GetFieldDefsFromJSONObject(JSONObj, FMemTable, True);
    Check(FMemTable.FieldDefs.IndexOf('first_name') >= 0,
      'firstName should transform to first_name');
    Check(FMemTable.FieldDefs.IndexOf('last_name') >= 0,
      'lastName should transform to last_name');
  finally
    JSONObj.Free;
  end;
end;

// ---------------------------------------------------------------------------
// PopulateMemTableFromJSON
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestPopulateMemTableClearMode;
begin
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice"},{"id":"2","name":"Bob"}]}');

  Check(FMemTable.Active, 'MemTable should be active after population');
  CheckEquals(2, FMemTable.RecordCount, 'Should have 2 records');

  FMemTable.First;
  CheckEquals('Alice', FMemTable.FieldByName('name').AsString, 'First record should be Alice');
  FMemTable.Next;
  CheckEquals('Bob', FMemTable.FieldByName('name').AsString, 'Second record should be Bob');
end;

procedure TestTTina4Core.TestPopulateMemTableSyncModeInsert;
begin
  // First populate with initial data
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice"}]}');
  CheckEquals(1, FMemTable.RecordCount, 'Should start with 1 record');

  // Sync a new record (id=2 does not exist)
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"2","name":"Bob"}]}',
    'id', TTina4RestSyncMode.Sync);

  CheckEquals(2, FMemTable.RecordCount, 'Should have 2 records after sync insert');
end;

procedure TestTTina4Core.TestPopulateMemTableSyncModeUpdate;
begin
  // First populate with initial data
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice"},{"id":"2","name":"Bob"}]}');
  CheckEquals(2, FMemTable.RecordCount, 'Should start with 2 records');

  // Sync update: change Alice's name
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice Updated"}]}',
    'id', TTina4RestSyncMode.Sync);

  CheckEquals(2, FMemTable.RecordCount, 'Should still have 2 records after sync update');

  // Verify the update
  FMemTable.First;
  CheckEquals('Alice Updated', FMemTable.FieldByName('name').AsString,
    'First record should be Alice Updated');
end;

// ---------------------------------------------------------------------------
// GetJSONFromTable (MemTable)
// ---------------------------------------------------------------------------

procedure TestTTina4Core.TestGetJSONFromMemTable;
var
  JSONResult: TJSONObject;
  Arr: TJSONArray;
begin
  // Populate first
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice"},{"id":"2","name":"Bob"}]}');

  JSONResult := GetJSONFromTable(FMemTable, 'data');
  try
    Check(Assigned(JSONResult), 'Should return a JSON object');
    Arr := JSONResult.GetValue<TJSONArray>('data');
    Check(Assigned(Arr), 'Should have a data array');
    CheckEquals(2, Arr.Count, 'Array should have 2 records');
  finally
    JSONResult.Free;
  end;
end;

procedure TestTTina4Core.TestGetJSONFromMemTableIgnoreFields;
var
  JSONResult: TJSONObject;
  FirstRecord: TJSONObject;
begin
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice","secret":"hidden"}]}');

  JSONResult := GetJSONFromTable(FMemTable, 'records', 'secret');
  try
    FirstRecord := JSONResult.GetValue<TJSONArray>('records').Items[0] as TJSONObject;
    Check(FirstRecord.GetValue('secret') = nil, 'secret field should be ignored');
    Check(FirstRecord.GetValue('name') <> nil, 'name field should still be present');
  finally
    JSONResult.Free;
  end;
end;

procedure TestTTina4Core.TestGetJSONFromMemTableIgnoreBlanks;
var
  JSONResult: TJSONObject;
  FirstRecord: TJSONObject;
begin
  PopulateMemTableFromJSON(FMemTable, 'records',
    '{"records":[{"id":"1","name":"Alice","email":""}]}');

  JSONResult := GetJSONFromTable(FMemTable, 'records', '', True);
  try
    FirstRecord := JSONResult.GetValue<TJSONArray>('records').Items[0] as TJSONObject;
    Check(FirstRecord.GetValue('email') = nil, 'Blank email field should be ignored');
    Check(FirstRecord.GetValue('name') <> nil, 'name field should still be present');
  finally
    JSONResult.Free;
  end;
end;

initialization
  RegisterTest(TestTTina4Core.Suite);
end.
