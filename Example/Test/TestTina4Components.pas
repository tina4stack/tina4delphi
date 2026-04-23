unit TestTina4Components;

interface

uses
  TestFramework, System.SysUtils, System.Classes, JSON,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Phys.Intf, FireDAC.Comp.DataSet, Data.DB,
  Tina4Core, Tina4REST, Tina4RESTRequest, Tina4JSONAdapter, Tina4Route,
  Tina4WebServer, Tina4HtmlRender;

type
  TestTTina4Components = class(TTestCase)
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    // FreeNotification tests
    procedure TestRESTRequestNilsOnRESTFree;
    procedure TestRESTRequestNilsOnMemTableFree;
    procedure TestJSONAdapterNilsOnMemTableFree;
    procedure TestRouteNilsOnWebServerFree;

    // TTina4JSONAdapter Execute tests
    procedure TestJSONAdapterExecuteFromJSONData;
    procedure TestJSONAdapterExecuteSyncMode;
    procedure TestJSONAdapterExecuteEmptyJSON;

    // TTina4HTMLRender class-list helpers
    procedure TestAddElementClassAppends;
    procedure TestAddElementClassIdempotent;
    procedure TestAddElementClassPreservesExisting;
    procedure TestRemoveElementClassMiddleToken;
    procedure TestRemoveElementClassMissingIsNoOp;
    procedure TestToggleElementClassFlips;
    procedure TestHasElementClassCaseSensitive;
    procedure TestSetExclusiveClassHighlightsSingleRow;
  end;

implementation

procedure TestTTina4Components.SetUp;
begin
  // Nothing shared — each test creates its own components
end;

procedure TestTTina4Components.TearDown;
begin
  // Nothing shared — each test cleans up its own components
end;

// ---------------------------------------------------------------------------
// FreeNotification: deleting a linked component should nil the reference
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestRESTRequestNilsOnRESTFree;
var
  REST: TTina4REST;
  Req: TTina4RESTRequest;
begin
  REST := TTina4REST.Create(nil);
  Req := TTina4RESTRequest.Create(nil);
  try
    Req.Tina4REST := REST;
    Check(Req.Tina4REST = REST, 'Tina4REST should be assigned');

    // Free REST — Notification should nil the reference
    FreeAndNil(REST);
    Check(Req.Tina4REST = nil, 'Tina4REST should be nil after REST is freed');
  finally
    REST.Free; // safe: nil after FreeAndNil
    Req.Free;
  end;
end;

procedure TestTTina4Components.TestRESTRequestNilsOnMemTableFree;
var
  MT: TFDMemTable;
  Req: TTina4RESTRequest;
begin
  MT := TFDMemTable.Create(nil);
  Req := TTina4RESTRequest.Create(nil);
  try
    Req.MemTable := MT;
    Check(Req.MemTable = MT, 'MemTable should be assigned');

    FreeAndNil(MT);
    Check(Req.MemTable = nil, 'MemTable should be nil after MemTable is freed');
  finally
    MT.Free;
    Req.Free;
  end;
end;

procedure TestTTina4Components.TestJSONAdapterNilsOnMemTableFree;
var
  MT: TFDMemTable;
  Adapter: TTina4JSONAdapter;
begin
  MT := TFDMemTable.Create(nil);
  Adapter := TTina4JSONAdapter.Create(nil);
  try
    Adapter.MemTable := MT;
    Check(Adapter.MemTable = MT, 'MemTable should be assigned');

    FreeAndNil(MT);
    Check(Adapter.MemTable = nil, 'MemTable should be nil after MemTable is freed');
  finally
    MT.Free;
    Adapter.Free;
  end;
end;

procedure TestTTina4Components.TestRouteNilsOnWebServerFree;
var
  WS: TTina4WebServer;
  Route: TTina4Route;
begin
  WS := TTina4WebServer.Create(nil);
  Route := TTina4Route.Create(nil);
  try
    Route.WebServer := WS;
    Check(Route.WebServer = WS, 'WebServer should be assigned');

    FreeAndNil(WS);
    Check(Route.WebServer = nil, 'WebServer should be nil after WebServer is freed');
  finally
    WS.Free;
    Route.Free;
  end;
end;

// ---------------------------------------------------------------------------
// TTina4JSONAdapter.Execute
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestJSONAdapterExecuteFromJSONData;
var
  MT: TFDMemTable;
  Adapter: TTina4JSONAdapter;
begin
  MT := TFDMemTable.Create(nil);
  Adapter := TTina4JSONAdapter.Create(nil);
  try
    Adapter.MemTable := MT;
    Adapter.DataKey := 'records';
    Adapter.JSONData.Text := '{"records":[{"id":"1","name":"Alice"},{"id":"2","name":"Bob"}]}';

    Adapter.Execute;

    Check(MT.Active, 'MemTable should be active after Execute');
    CheckEquals(2, MT.RecordCount, 'Should have 2 records from JSONData');

    MT.First;
    CheckEquals('Alice', MT.FieldByName('name').AsString, 'First record should be Alice');
    MT.Next;
    CheckEquals('Bob', MT.FieldByName('name').AsString, 'Second record should be Bob');
  finally
    Adapter.Free;
    MT.Free;
  end;
end;

procedure TestTTina4Components.TestJSONAdapterExecuteSyncMode;
var
  MT: TFDMemTable;
  Adapter: TTina4JSONAdapter;
begin
  MT := TFDMemTable.Create(nil);
  Adapter := TTina4JSONAdapter.Create(nil);
  try
    Adapter.MemTable := MT;
    Adapter.DataKey := 'records';

    // First populate with initial data
    Adapter.JSONData.Text := '{"records":[{"id":"1","name":"Alice"}]}';
    Adapter.Execute;
    CheckEquals(1, MT.RecordCount, 'Should start with 1 record');

    // Now sync a new record
    Adapter.SyncMode := TTina4RestSyncMode.Sync;
    Adapter.IndexFieldNames := 'id';
    Adapter.JSONData.Text := '{"records":[{"id":"2","name":"Bob"}]}';
    Adapter.Execute;

    CheckEquals(2, MT.RecordCount, 'Should have 2 records after sync insert');
  finally
    Adapter.Free;
    MT.Free;
  end;
end;

procedure TestTTina4Components.TestJSONAdapterExecuteEmptyJSON;
var
  MT: TFDMemTable;
  Adapter: TTina4JSONAdapter;
begin
  MT := TFDMemTable.Create(nil);
  Adapter := TTina4JSONAdapter.Create(nil);
  try
    Adapter.MemTable := MT;
    Adapter.DataKey := 'records';
    Adapter.JSONData.Text := '';

    // Should not crash
    Adapter.Execute;

    // MemTable should remain inactive since no data was provided
    Check(not MT.Active, 'MemTable should remain inactive with empty JSONData');
  finally
    Adapter.Free;
    MT.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Class-list helpers on TTina4HTMLRender
//
// These work against the parsed DOM, not the native form controls, so the
// render doesn't need a form parent to host the tests. Each test sets a
// fragment of HTML, calls a helper, and inspects the tag's class attribute
// via GetElementById.
// ---------------------------------------------------------------------------

function ClassOf(R: TTina4HTMLRender; const Id: string): string;
var
  Tag: Tina4HtmlRender.THTMLTag;
begin
  Tag := R.GetElementById(Id);
  if Assigned(Tag) then
    Result := Tag.GetAttribute('class', '')
  else
    Result := '';
end;

procedure TestTTina4Components.TestAddElementClassAppends;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d"></div>';
    R.AddElementClass('d', 'selected');
    CheckEquals('selected', ClassOf(R, 'd'),
      'AddElementClass on empty class attribute');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestAddElementClassIdempotent;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="selected"></div>';
    R.AddElementClass('d', 'selected');
    CheckEquals('selected', ClassOf(R, 'd'),
      'Adding an already-present class must not duplicate');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestAddElementClassPreservesExisting;
var
  R: TTina4HTMLRender;
  Got: string;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="row striped"></div>';
    R.AddElementClass('d', 'selected');
    Got := ClassOf(R, 'd');
    Check(Pos('row', Got) > 0,      'Existing class "row" must survive');
    Check(Pos('striped', Got) > 0,  'Existing class "striped" must survive');
    Check(Pos('selected', Got) > 0, 'New class "selected" must be present');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestRemoveElementClassMiddleToken;
var
  R: TTina4HTMLRender;
  Got: string;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="row selected striped"></div>';
    R.RemoveElementClass('d', 'selected');
    Got := ClassOf(R, 'd');
    Check(Pos('row', Got) > 0,       'row must survive removal of middle token');
    Check(Pos('striped', Got) > 0,   'striped must survive');
    Check(Pos('selected', Got) = 0,  '"selected" must be gone');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestRemoveElementClassMissingIsNoOp;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="row striped"></div>';
    R.RemoveElementClass('d', 'selected');  // not present
    CheckEquals('row striped', ClassOf(R, 'd'),
      'Removing an absent class must leave the list untouched');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestToggleElementClassFlips;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="row"></div>';
    Check(R.ToggleElementClass('d', 'selected'),
      'First toggle should report now-present');
    Check(R.HasElementClass('d', 'selected'),
      'HasElementClass should agree after first toggle');
    Check(not R.ToggleElementClass('d', 'selected'),
      'Second toggle should report now-absent');
    Check(not R.HasElementClass('d', 'selected'),
      'HasElementClass should agree after second toggle');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestHasElementClassCaseSensitive;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text := '<div id="d" class="Selected"></div>';
    Check(R.HasElementClass('d', 'Selected'),
      'HasElementClass must match exact casing');
    Check(not R.HasElementClass('d', 'selected'),
      'HasElementClass must reject different casing (browsers do the same)');
  finally
    R.Free;
  end;
end;

procedure TestTTina4Components.TestSetExclusiveClassHighlightsSingleRow;
var
  R: TTina4HTMLRender;
begin
  R := TTina4HTMLRender.Create(nil);
  try
    R.HTML.Text :=
      '<table><tbody>' +
      '  <tr id="r1" class="row selected"></tr>' +  // previously selected
      '  <tr id="r2" class="row"></tr>' +
      '  <tr id="r3" class="row selected"></tr>' +  // stale extra
      '</tbody></table>';

    R.SetExclusiveClass('r2', 'selected', 'tr');

    Check(not R.HasElementClass('r1', 'selected'),
      'r1 must no longer be selected after SetExclusiveClass');
    Check(R.HasElementClass('r2', 'selected'),
      'r2 must BE selected');
    Check(not R.HasElementClass('r3', 'selected'),
      'r3 (stale) must no longer be selected');
    // Base classes untouched
    Check(R.HasElementClass('r1', 'row'),
      'r1 base class "row" must survive');
    Check(R.HasElementClass('r2', 'row'),
      'r2 base class "row" must survive');
    Check(R.HasElementClass('r3', 'row'),
      'r3 base class "row" must survive');
  finally
    R.Free;
  end;
end;

initialization
  RegisterTest(TestTTina4Components.Suite);
end.
