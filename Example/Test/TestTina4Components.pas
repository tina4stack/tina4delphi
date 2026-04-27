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

    // Vertical-align on display:table-cell
    procedure TestVerticalAlignMiddleCentersCellChild;
    procedure TestVerticalAlignBottomPushesChildDown;
    procedure TestVerticalAlignTopStaysAtTop;
    procedure TestValignAttributeMiddleCenters;
    // margin:auto horizontal centering
    procedure TestMarginAutoCentersBlock;
    procedure TestMarginLeftAutoRightAligns;
    procedure TestMarginRightAutoLeftAligns;
    // margin:auto vertical centering inside fixed-height parent
    procedure TestMarginAutoVCentersInsideExplicitHeight;
    procedure TestTilePillCenterRepro;
    // width: fit-content
    procedure TestFitContentShrinksBlockToText;
    procedure TestFitContentWithMarginAutoCenters;
    procedure TestTilePillFitContentRepro;
    // CSS outline + outline-offset
    procedure TestOutlineShorthandParses;
    procedure TestOutlineLonghandsAndOffset;
    procedure TestOutlineNoneDisables;
    procedure TestTileInCartOutlineRepro;
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

// ---------------------------------------------------------------------------
// Layout-positioning tests for centering primitives.
//
// These exercise the layout engine directly (not the FMX paint pipeline) so
// we get deterministic numeric box positions to assert against. The pattern:
//   1. Parse a snippet via THTMLParser.
//   2. Run TLayoutEngine.Layout against the parsed DOM with a known width.
//   3. Walk the resulting box tree by id and assert .X / .Y / .ContentHeight.
//
// We assert with a small tolerance because text / box heights end up in
// fractional pixel space.
// ---------------------------------------------------------------------------

function FindBoxById(Box: Tina4HtmlRender.TLayoutBox; const Id: string): Tina4HtmlRender.TLayoutBox;
var
  Sub: Tina4HtmlRender.TLayoutBox;
begin
  Result := nil;
  if Box = nil then Exit;
  if Assigned(Box.Tag) and SameText(Box.Tag.GetAttribute('id', ''), Id) then
    Exit(Box);
  for var I := 0 to Box.Children.Count - 1 do
  begin
    Sub := FindBoxById(Box.Children[I], Id);
    if Assigned(Sub) then Exit(Sub);
  end;
end;

procedure RunLayout(Parser: Tina4HtmlRender.THTMLParser;
                    Engine: Tina4HtmlRender.TLayoutEngine;
                    const HTML: string; AvailWidth: Single);
begin
  Parser.Parse(HTML);
  Engine.Layout(Parser.Root, AvailWidth, nil);
end;

procedure TestTTina4Components.TestVerticalAlignMiddleCentersCellChild;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Cell, Child: Tina4HtmlRender.TLayoutBox;
  Expected: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // 200px-tall cell, vertical-align:middle, with a short inner block.
    // The inner block's natural height is small relative to the cell, so
    // the slack should be split equally above/below.
    RunLayout(Parser, Engine,
      '<table><tr>' +
      '<td id="c" style="height:200px; vertical-align:middle; padding:0">' +
      '  <div id="inner" style="height:40px">x</div>' +
      '</td></tr></table>',
      400);

    Cell := FindBoxById(Engine.Root, 'c');
    Child := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Cell),  'cell box must exist');
    Check(Assigned(Child), 'inner box must exist');

    // Child should be shifted down by (cell.ContentHeight - 40) / 2
    Expected := (Cell.ContentHeight - 40) / 2;
    Check(Abs(Child.Y - Expected) < 2.0,
      Format('vertical-align:middle: expected child.Y near %.1f, got %.1f (cellH=%.1f)',
             [Expected, Child.Y, Cell.ContentHeight]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestVerticalAlignBottomPushesChildDown;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Cell, Child: Tina4HtmlRender.TLayoutBox;
  Expected: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<table><tr>' +
      '<td id="c" style="height:200px; vertical-align:bottom; padding:0">' +
      '  <div id="inner" style="height:40px">x</div>' +
      '</td></tr></table>',
      400);

    Cell := FindBoxById(Engine.Root, 'c');
    Child := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Cell) and Assigned(Child), 'boxes must exist');

    Expected := Cell.ContentHeight - 40;
    Check(Abs(Child.Y - Expected) < 2.0,
      Format('vertical-align:bottom: expected child.Y near %.1f, got %.1f',
             [Expected, Child.Y]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestVerticalAlignTopStaysAtTop;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Child: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Default top alignment — child stays at Y=0.
    RunLayout(Parser, Engine,
      '<table><tr>' +
      '<td id="c" style="height:200px; padding:0">' +
      '  <div id="inner" style="height:40px">x</div>' +
      '</td></tr></table>',
      400);

    Child := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Child), 'inner box must exist');
    Check(Abs(Child.Y) < 2.0,
      Format('default vertical-align (top): expected child.Y near 0, got %.1f',
             [Child.Y]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestValignAttributeMiddleCenters;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Cell, Child: Tina4HtmlRender.TLayoutBox;
  Expected: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Legacy `valign="middle"` attribute should produce the same result as
    // `vertical-align:middle` CSS.
    RunLayout(Parser, Engine,
      '<table><tr>' +
      '<td id="c" valign="middle" style="height:200px; padding:0">' +
      '  <div id="inner" style="height:40px">x</div>' +
      '</td></tr></table>',
      400);

    Cell := FindBoxById(Engine.Root, 'c');
    Child := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Cell) and Assigned(Child), 'boxes must exist');

    Expected := (Cell.ContentHeight - 40) / 2;
    Check(Abs(Child.Y - Expected) < 2.0,
      Format('valign="middle": expected child.Y near %.1f, got %.1f',
             [Expected, Child.Y]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestMarginAutoCentersBlock;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Inner: Tina4HtmlRender.TLayoutBox;
  Expected: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Outer is 400px wide (fed via AvailWidth), inner is 200px with
    // margin: 0 auto — so inner should sit at X = (400 - 200) / 2 = 100.
    RunLayout(Parser, Engine,
      '<div id="outer" style="padding:0">' +
      '  <div id="inner" style="width:200px; margin:0 auto">x</div>' +
      '</div>',
      400);

    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Inner), 'inner block must exist');

    Expected := (400 - 200) / 2;
    Check(Abs(Inner.X - Expected) < 2.0,
      Format('margin:0 auto: expected inner.X near %.1f, got %.1f',
             [Expected, Inner.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestMarginLeftAutoRightAligns;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Inner: Tina4HtmlRender.TLayoutBox;
  Expected: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // margin-left:auto with fixed margin-right pushes the box to the right.
    RunLayout(Parser, Engine,
      '<div id="outer" style="padding:0">' +
      '  <div id="inner" style="width:200px; margin-left:auto; margin-right:0">x</div>' +
      '</div>',
      400);

    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Inner), 'inner block must exist');

    Expected := 400 - 200;
    Check(Abs(Inner.X - Expected) < 2.0,
      Format('margin-left:auto: expected inner.X near %.1f, got %.1f',
             [Expected, Inner.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestMarginAutoVCentersInsideExplicitHeight;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Outer, Inner: Tina4HtmlRender.TLayoutBox;
  ExpectedY: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Parent has explicit 200px height. Child has natural height ~26px and
    // `margin: auto` (= top auto + bottom auto). Strict CSS would top-align
    // it; Tina4 distributes the slack so the child sits dead-centre.
    RunLayout(Parser, Engine,
      '<div id="outer" style="height:200px; padding:0">' +
      '  <div id="inner" style="height:40px; margin:auto; width:100px">x</div>' +
      '</div>',
      400);

    Outer := FindBoxById(Engine.Root, 'outer');
    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Outer) and Assigned(Inner), 'boxes must exist');

    ExpectedY := (Outer.ContentHeight - 40) / 2;
    Check(Abs(Inner.Y - ExpectedY) < 2.0,
      Format('margin:auto vertical: expected inner.Y near %.1f, got %.1f (parentH=%.1f)',
             [ExpectedY, Inner.Y, Outer.ContentHeight]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTilePillCenterRepro;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Tile, Label_: Tina4HtmlRender.TLayoutBox;
  CenterX, CenterY: Single;
  TileCenterX, TileCenterY: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim repro of the production tile/label markup. The pill
    // (display:block; margin:auto) must end up dead-centre inside the
    // 176 x 98 inline-block tile — both axes.
    RunLayout(Parser, Engine,
      '<div id="tile" style="display:inline-block; width:176px; height:98px; ' +
      '       background:#c00; text-align:center; padding:0">' +
      '  <span id="lbl" style="display:block; margin:auto; width:60px; height:26px; ' +
      '         line-height:18px; font-size:15px; padding:4px 10px; ' +
      '         background:rgba(0,0,0,0.55); color:white">R10</span>' +
      '</div>',
      400);

    Tile  := FindBoxById(Engine.Root, 'tile');
    Label_ := FindBoxById(Engine.Root, 'lbl');
    Check(Assigned(Tile) and Assigned(Label_), 'tile + label boxes must exist');

    // Tile centre coordinates (within tile's content box)
    TileCenterX := Tile.ContentWidth  / 2;
    TileCenterY := Tile.ContentHeight / 2;
    // Label centre = its own X/Y plus half its outer box
    CenterX := Label_.X + Label_.MarginBoxWidth  / 2;
    CenterY := Label_.Y + Label_.MarginBoxHeight / 2;

    Check(Abs(CenterX - TileCenterX) < 4.0,
      Format('Tile pill X-centre: expected near %.1f, got %.1f',
             [TileCenterX, CenterX]));
    Check(Abs(CenterY - TileCenterY) < 4.0,
      Format('Tile pill Y-centre: expected near %.1f, got %.1f (tileH=%.1f, labelY=%.1f, labelH=%.1f)',
             [TileCenterY, CenterY, Tile.ContentHeight, Label_.Y, Label_.MarginBoxHeight]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestMarginRightAutoLeftAligns;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Inner: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // margin-right:auto with fixed margin-left -> default flush-left behaviour.
    RunLayout(Parser, Engine,
      '<div id="outer" style="padding:0">' +
      '  <div id="inner" style="width:200px; margin-left:0; margin-right:auto">x</div>' +
      '</div>',
      400);

    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Inner), 'inner block must exist');

    Check(Abs(Inner.X) < 2.0,
      Format('margin-right:auto: expected inner.X near 0, got %.1f',
             [Inner.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestFitContentShrinksBlockToText;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Inner: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Block with width:fit-content should shrink to roughly the width of
    // the text "R10" (~30px @ 14pt) — definitely less than the parent's
    // 400px content area, and much less than 200px.
    RunLayout(Parser, Engine,
      '<div style="padding:0">' +
      '  <div id="inner" style="display:block; width:fit-content; padding:0">R10</div>' +
      '</div>',
      400);

    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Inner), 'inner block must exist');
    Check(Inner.ContentWidth > 0,
      Format('fit-content width must be > 0, got %.1f', [Inner.ContentWidth]));
    Check(Inner.ContentWidth < 200,
      Format('fit-content should shrink-wrap "R10" well below 200px, got %.1f',
             [Inner.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestFitContentWithMarginAutoCenters;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Inner: Tina4HtmlRender.TLayoutBox;
  ChildOuter, ExpectedX: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // The combo that the production tile uses: shrink-wrap with fit-content
    // then horizontal centre with margin:auto. The shrunk box should sit
    // dead-centre in its 400px parent.
    RunLayout(Parser, Engine,
      '<div style="padding:0; text-align:center">' +
      '  <div id="inner" style="display:block; width:fit-content; ' +
      '         margin:0 auto; padding:0">R10</div>' +
      '</div>',
      400);

    Inner := FindBoxById(Engine.Root, 'inner');
    Check(Assigned(Inner), 'inner block must exist');

    ChildOuter := Inner.MarginBoxWidth;
    ExpectedX := (400 - ChildOuter) / 2;
    Check(Abs(Inner.X - ExpectedX) < 2.0,
      Format('fit-content + margin:0 auto: expected inner.X near %.1f, got %.1f (outer=%.1f)',
             [ExpectedX, Inner.X, ChildOuter]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTilePillFitContentRepro;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Tile, Label_: Tina4HtmlRender.TLayoutBox;
  CenterX, CenterY, TileCenterX, TileCenterY: Single;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Production tile + label using exactly the CSS the user posted:
    //   .label { display:block; margin:auto; width:fit-content; ... }
    // Pill must shrink-wrap the price, then sit dead-centre on both axes.
    RunLayout(Parser, Engine,
      '<div id="tile" style="display:inline-block; width:176px; height:98px; ' +
      '       background:#c00; text-align:center; padding:0">' +
      '  <span id="lbl" style="display:block; margin:auto; width:fit-content; ' +
      '         line-height:18px; font-size:15px; padding:4px 10px; ' +
      '         background:rgba(0,0,0,0.55); color:white">R10</span>' +
      '</div>',
      400);

    Tile  := FindBoxById(Engine.Root, 'tile');
    Label_ := FindBoxById(Engine.Root, 'lbl');
    Check(Assigned(Tile) and Assigned(Label_), 'tile + label boxes must exist');

    // Label must NOT span the full tile width — it should be the pill's
    // intrinsic width (a few characters of "R10" + 10px h-padding either
    // side). Empirically well below half the tile width.
    Check(Label_.MarginBoxWidth < 80,
      Format('fit-content label should shrink-wrap, got width %.1f',
             [Label_.MarginBoxWidth]));

    TileCenterX := Tile.ContentWidth  / 2;
    TileCenterY := Tile.ContentHeight / 2;
    CenterX := Label_.X + Label_.MarginBoxWidth  / 2;
    CenterY := Label_.Y + Label_.MarginBoxHeight / 2;

    Check(Abs(CenterX - TileCenterX) < 4.0,
      Format('Tile pill X-centre: expected %.1f, got %.1f',
             [TileCenterX, CenterX]));
    Check(Abs(CenterY - TileCenterY) < 4.0,
      Format('Tile pill Y-centre: expected %.1f, got %.1f',
             [TileCenterY, CenterY]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// CSS outline tests — parsing only (we can't easily assert painted pixels in
// DUnit, so we run layout and inspect Box.Style.Outline* directly).
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestOutlineShorthandParses;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Box: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<div id="d" style="outline: 4px solid #16a34a">x</div>', 400);
    Box := FindBoxById(Engine.Root, 'd');
    Check(Assigned(Box), 'box must exist');
    CheckEquals(4, Box.Style.OutlineWidth, 'outline width parsed from shorthand');
    CheckEquals('solid', Box.Style.OutlineStyle, 'outline style parsed from shorthand');
    Check(Box.Style.OutlineColor <> 0, 'outline color must be set (got null)');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestOutlineLonghandsAndOffset;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Box: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<div id="d" style="outline-width: 2px; outline-style: dashed; ' +
      '       outline-color: #ff0000; outline-offset: -4px">x</div>', 400);
    Box := FindBoxById(Engine.Root, 'd');
    Check(Assigned(Box), 'box must exist');
    CheckEquals(2, Box.Style.OutlineWidth, 'outline-width longhand');
    CheckEquals('dashed', Box.Style.OutlineStyle, 'outline-style longhand');
    CheckEquals(-4, Box.Style.OutlineOffset, 'outline-offset (negative)');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestOutlineNoneDisables;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Box: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<div id="d" style="outline: none">x</div>', 400);
    Box := FindBoxById(Engine.Root, 'd');
    Check(Assigned(Box), 'box must exist');
    CheckEquals(0, Box.Style.OutlineWidth, 'outline:none -> width 0');
    CheckEquals('none', Box.Style.OutlineStyle, 'outline:none -> style "none"');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTileInCartOutlineRepro;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Tile: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Production .tile-in-cart CSS: 4px solid green outline pulled inward
    // 4px so it sits flush with the card's inner edge.
    RunLayout(Parser, Engine,
      '<div id="t" style="display:inline-block; width:176px; height:98px; ' +
      '       border-radius:8px; outline: 4px solid #16a34a; outline-offset: -4px">' +
      '</div>', 400);
    Tile := FindBoxById(Engine.Root, 't');
    Check(Assigned(Tile), 'tile box must exist');
    CheckEquals(4,  Tile.Style.OutlineWidth,  'in-cart outline width');
    CheckEquals(-4, Tile.Style.OutlineOffset, 'in-cart outline offset (-4)');
    CheckEquals('solid', Tile.Style.OutlineStyle, 'in-cart outline style');
    Check(Tile.Style.OutlineColor <> 0, 'in-cart outline colour must be set');
    // Outline must NOT inflate layout — the tile should still occupy its
    // declared 176x98 box (this catches a regression where an over-eager
    // PaintOutline implementation added the outline-width to the layout).
    CheckEquals(176, Tile.ContentWidth,  'outline must not affect layout width');
    CheckEquals(98,  Tile.ContentHeight, 'outline must not affect layout height');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

initialization
  RegisterTest(TestTTina4Components.Suite);
end.
