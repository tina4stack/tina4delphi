unit TestTina4Components;

interface

uses
  TestFramework, System.SysUtils, System.Classes, JSON,
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Phys.Intf, FireDAC.Comp.DataSet, Data.DB,
  Tina4Core, Tina4REST, Tina4RESTRequest, Tina4JSONAdapter, Tina4Route,
  Tina4WebServer;

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

initialization
  RegisterTest(TestTTina4Components.Suite);
end.
