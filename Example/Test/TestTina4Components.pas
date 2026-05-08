unit TestTina4Components;

interface

uses
  TestFramework, System.SysUtils, System.Classes, System.Generics.Collections, JSON,
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
    // Sticky table header inside scrollable container
    procedure TestStickyHeaderParsesInsideScrollContainer;
    // Per-column width on table cells
    procedure TestTablePercentageColumnWidthsRespected;
    procedure TestTablePixelColumnWidthsRespected;
    procedure TestTableUnsizedColumnsShareRemaining;
    // Bug report repros — every column-width declaration form
    procedure TestBugReportHtml4WidthAttribute;
    procedure TestBugReportInlineStyleWidth;
    procedure TestBugReportColgroupColWidth;
    procedure TestBugReportColgroupColWidthPercentage;
    procedure TestBugReportColSpanAttribute;
    // Anonymous table-row wrapping for orphan table-cells
    procedure TestDisplayTableWithOrphanCellsLaysOutSideBySide;
    procedure TestTileRowLogoLeftDescRightRepro;
    // CSS float
    procedure TestFloatLeftPushesSiblingRight;
    procedure TestFloatRightPushesSiblingLeft;
    procedure TestTwoLeftFloatsStackHorizontally;
    procedure TestSiblingPastFloatBottomReturnsToFullWidth;
    procedure TestParentEnclosesOverhangingFloat;
    procedure TestFloatLogoTextRowRepro;
    // display: inline-table
    procedure TestInlineTableLaysOutCellsSideBySide;
    procedure TestInlineTableSiblingsFlowHorizontally;
    // Bug-list regressions (cuttlefish bug list)
    procedure TestBoxSizingBorderBoxKeepsOuterWidthConstant;
    procedure TestTableCellWidthIsHardConstraint;
    procedure TestNotPseudoClassDoesNotDropSiblingRules;
    procedure TestDisplayFlowRootEnclosesFloats;
    // Bug-list 2026-05-08
    procedure TestStickyLeftPinsToScrollAncestorXEdge;
    procedure TestNowrapInlineBlockOverflowsContainer;
    procedure TestDataUriBackgroundImageInInlineStyleParsed;
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

procedure TestTTina4Components.TestStickyHeaderParsesInsideScrollContainer;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Cart, Th: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim repro of the cart-with-sticky-header pattern. We can't
    // assert paint output here, but we can verify the parsed properties:
    //   - the .cart container has overflow-y:auto and explicit height
    //   - the <th> inherits position:sticky and top:0 through to the box
    // Together these are the inputs the new FStickyAnchorY logic needs.
    RunLayout(Parser, Engine,
      '<div id="cart" style="height:160px; overflow-y:auto; position:relative">' +
      '  <table style="width:100%">' +
      '    <thead><tr>' +
      '      <th id="hdr" style="position:sticky; top:0; background:#f1f5f9; ' +
      '             padding:6px 8px">Description</th>' +
      '    </tr></thead>' +
      '    <tbody><tr><td>Row 1</td></tr></tbody>' +
      '  </table>' +
      '</div>',
      400);

    Cart := FindBoxById(Engine.Root, 'cart');
    Th   := FindBoxById(Engine.Root, 'hdr');
    Check(Assigned(Cart) and Assigned(Th), 'cart + th boxes must exist');
    CheckEquals('auto', Cart.Style.OverflowY, 'cart must have overflow-y:auto');
    CheckEquals(160, Cart.ContentHeight, 'cart explicit height must apply');
    CheckEquals('sticky', Th.Style.CSSPosition, 'th must be position:sticky');
    CheckEquals(0, Th.Style.CSSTop, 'th must have top:0');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Per-column table widths
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestTablePercentageColumnWidthsRespected;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Th1, Th2, Th3, Th4: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // The user's cart-table column distribution: 68 / 5 / 13 / 14 = 100%.
    // The table is 400px wide so the columns should be ~272 / 20 / 52 / 56 px.
    RunLayout(Parser, Engine,
      '<table style="width:400px"><tr>' +
      '  <th id="h1" style="width:68%; padding:0">D</th>' +
      '  <th id="h2" style="width:5%;  padding:0">Q</th>' +
      '  <th id="h3" style="width:13%; padding:0">A</th>' +
      '  <th id="h4" style="width:14%; padding:0">T</th>' +
      '</tr></table>',
      400);

    Th1 := FindBoxById(Engine.Root, 'h1');
    Th2 := FindBoxById(Engine.Root, 'h2');
    Th3 := FindBoxById(Engine.Root, 'h3');
    Th4 := FindBoxById(Engine.Root, 'h4');
    Check(Assigned(Th1) and Assigned(Th2) and Assigned(Th3) and Assigned(Th4),
      'all four header cells must exist');

    // ContentWidth = column width (no padding in this test). Allow 1px
    // tolerance for accumulated rounding.
    Check(Abs(Th1.ContentWidth - 272) < 2, Format('h1 expected ~272, got %.1f', [Th1.ContentWidth]));
    Check(Abs(Th2.ContentWidth -  20) < 2, Format('h2 expected ~20, got %.1f',  [Th2.ContentWidth]));
    Check(Abs(Th3.ContentWidth -  52) < 2, Format('h3 expected ~52, got %.1f',  [Th3.ContentWidth]));
    Check(Abs(Th4.ContentWidth -  56) < 2, Format('h4 expected ~56, got %.1f',  [Th4.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTablePixelColumnWidthsRespected;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Th1, Th2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Pixel widths summing to less than table width get scaled up to fill
    // the table (matches table-layout:fixed in browsers).
    RunLayout(Parser, Engine,
      '<table style="width:400px"><tr>' +
      '  <th id="a" style="width:100px; padding:0">A</th>' +
      '  <th id="b" style="width:100px; padding:0">B</th>' +
      '</tr></table>', 400);

    Th1 := FindBoxById(Engine.Root, 'a');
    Th2 := FindBoxById(Engine.Root, 'b');
    Check(Assigned(Th1) and Assigned(Th2), 'cells must exist');

    // Each takes half (100/200 of 400 = 200).
    Check(Abs(Th1.ContentWidth - 200) < 2, Format('a expected 200, got %.1f', [Th1.ContentWidth]));
    Check(Abs(Th2.ContentWidth - 200) < 2, Format('b expected 200, got %.1f', [Th2.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTableUnsizedColumnsShareRemaining;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Sized, U1, U2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // One column at 50%, two unsized → remaining 50% split equally → 25% each.
    RunLayout(Parser, Engine,
      '<table style="width:400px"><tr>' +
      '  <th id="s" style="width:50%; padding:0">S</th>' +
      '  <th id="u1" style="padding:0">U1</th>' +
      '  <th id="u2" style="padding:0">U2</th>' +
      '</tr></table>', 400);

    Sized := FindBoxById(Engine.Root, 's');
    U1    := FindBoxById(Engine.Root, 'u1');
    U2    := FindBoxById(Engine.Root, 'u2');
    Check(Assigned(Sized) and Assigned(U1) and Assigned(U2), 'cells must exist');

    Check(Abs(Sized.ContentWidth - 200) < 2, Format('sized=%.1f, expected ~200', [Sized.ContentWidth]));
    Check(Abs(U1.ContentWidth -    100) < 2, Format('u1=%.1f, expected ~100',    [U1.ContentWidth]));
    Check(Abs(U2.ContentWidth -    100) < 2, Format('u2=%.1f, expected ~100',    [U2.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Bug-report regression tests — verbatim repros from
// D:\projects\cuttlefishmobile\TINA4_BUG_TABLE_COLUMN_WIDTHS.md
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestBugReportHtml4WidthAttribute;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  T1, T2, T3, T4: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug report case 3: <th width="520"> — declared "WORKS" before, must
    // still work after the fix.
    RunLayout(Parser, Engine,
      '<table style="width:720px"><tr>' +
      '  <th id="d" width="520">D</th>' +
      '  <th id="q" width="36">Q</th>' +
      '  <th id="a" width="78">A</th>' +
      '  <th id="t" width="84">T</th>' +
      '</tr></table>', 720);

    T1 := FindBoxById(Engine.Root, 'd');
    T2 := FindBoxById(Engine.Root, 'q');
    T3 := FindBoxById(Engine.Root, 'a');
    T4 := FindBoxById(Engine.Root, 't');
    Check(Assigned(T1) and Assigned(T2) and Assigned(T3) and Assigned(T4),
      'all four cells must exist');

    // 520+36+78+84 = 718 → scaled to fill 720. Each cell's content width
    // is the column width minus its own 8px (4+4) default <th> padding.
    Check(Abs(T1.ContentWidth + 8 - 521.4) < 2,
      Format('description content width = %.1f', [T1.ContentWidth]));
    Check(Abs(T2.ContentWidth + 8 -  36.1) < 2,
      Format('qty content width = %.1f', [T2.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestBugReportInlineStyleWidth;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  T1, T2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug report case 2: style="width:520px" — declared broken before
    // f35d857. After the fix, must lay out the same as the HTML4 attribute.
    RunLayout(Parser, Engine,
      '<table style="width:720px"><tr>' +
      '  <th id="d" style="width:520px">D</th>' +
      '  <th id="q" style="width:36px">Q</th>' +
      '  <th id="a" style="width:78px">A</th>' +
      '  <th id="t" style="width:84px">T</th>' +
      '</tr></table>', 720);

    T1 := FindBoxById(Engine.Root, 'd');
    T2 := FindBoxById(Engine.Root, 'q');
    Check(Assigned(T1) and Assigned(T2), 'cells must exist');

    // First column should get its declared 520px share (-padding -scaling).
    // Big check: it must NOT have collapsed to "Description" header text width.
    Check(T1.ContentWidth > 400,
      Format('inline style width must claim wide column, got %.1f', [T1.ContentWidth]));
    Check(T2.ContentWidth < 60,
      Format('qty must stay narrow, got %.1f', [T2.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestBugReportColgroupColWidth;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  C1, C2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug report case 1: <colgroup><col style="width:..."> — declared
    // "silently dropped" before. Must now apply column widths from <col>.
    RunLayout(Parser, Engine,
      '<table style="width:720px">' +
      '  <colgroup>' +
      '    <col style="width:520px">' +
      '    <col style="width:200px">' +
      '  </colgroup>' +
      '  <tr><th id="c1" style="padding:0">D</th><th id="c2" style="padding:0">Q</th></tr>' +
      '</table>', 720);

    C1 := FindBoxById(Engine.Root, 'c1');
    C2 := FindBoxById(Engine.Root, 'c2');
    Check(Assigned(C1) and Assigned(C2), 'cells must exist');

    Check(Abs(C1.ContentWidth - 520) < 2,
      Format('colgroup col 520px: got %.1f', [C1.ContentWidth]));
    Check(Abs(C2.ContentWidth - 200) < 2,
      Format('colgroup col 200px: got %.1f', [C2.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestBugReportColgroupColWidthPercentage;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  C1, C2, C3, C4: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<table style="width:720px">' +
      '  <colgroup>' +
      '    <col style="width:68%">' +
      '    <col style="width:5%">' +
      '    <col style="width:13%">' +
      '    <col style="width:14%">' +
      '  </colgroup>' +
      '  <tr>' +
      '    <th id="d" style="padding:0">Description</th>' +
      '    <th id="q" style="padding:0">Qty</th>' +
      '    <th id="a" style="padding:0">Amount</th>' +
      '    <th id="t" style="padding:0">Total</th>' +
      '  </tr></table>', 720);

    C1 := FindBoxById(Engine.Root, 'd');
    C2 := FindBoxById(Engine.Root, 'q');
    C3 := FindBoxById(Engine.Root, 'a');
    C4 := FindBoxById(Engine.Root, 't');
    Check(Assigned(C1) and Assigned(C2) and Assigned(C3) and Assigned(C4), 'cells exist');

    Check(Abs(C1.ContentWidth - 489.6) < 2,
      Format('68%% of 720 ≈ 489.6, got %.1f', [C1.ContentWidth]));
    Check(Abs(C2.ContentWidth -  36)   < 2,
      Format(' 5%% of 720 = 36, got %.1f', [C2.ContentWidth]));
    Check(Abs(C3.ContentWidth -  93.6) < 2,
      Format('13%% of 720 ≈ 93.6, got %.1f', [C3.ContentWidth]));
    Check(Abs(C4.ContentWidth - 100.8) < 2,
      Format('14%% of 720 ≈ 100.8, got %.1f', [C4.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestBugReportColSpanAttribute;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  C1, C2, C3: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // <col span="2"> applies the same width to two columns.
    RunLayout(Parser, Engine,
      '<table style="width:600px">' +
      '  <col span="2" style="width:100px">' +
      '  <col style="width:400px">' +
      '  <tr><th id="a" style="padding:0">A</th>' +
      '      <th id="b" style="padding:0">B</th>' +
      '      <th id="c" style="padding:0">C</th></tr>' +
      '</table>', 600);

    C1 := FindBoxById(Engine.Root, 'a');
    C2 := FindBoxById(Engine.Root, 'b');
    C3 := FindBoxById(Engine.Root, 'c');
    Check(Assigned(C1) and Assigned(C2) and Assigned(C3), 'cells exist');

    Check(Abs(C1.ContentWidth - 100) < 2, Format('span col 0 = %.1f', [C1.ContentWidth]));
    Check(Abs(C2.ContentWidth - 100) < 2, Format('span col 1 = %.1f', [C2.ContentWidth]));
    Check(Abs(C3.ContentWidth - 400) < 2, Format('lone col = %.1f',  [C3.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Anonymous table-row generation
//
// CSS 2.1 §17.2.1: a table-cell whose parent is `display:table` (without an
// intervening `display:table-row`) gets wrapped in an anonymous row. Before
// this fix, the row collection step found no rows, NumCols defaulted to 0,
// and the table rendered as 0x0 — making the orphan cells' content vanish.
// This is the bug report from cuttlefishmobile's Data drill-down tile.
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestDisplayTableWithOrphanCellsLaysOutSideBySide;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Tbl, A, B: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // The bug-report shape: parent display:table with two display:table-cell
    // children directly underneath, no <tr> wrapper. Both cells must have
    // non-zero width and the table itself must claim a non-zero size.
    RunLayout(Parser, Engine,
      '<div id="t" style="display:table; width:200px; padding:0">' +
      '  <div id="a" style="display:table-cell; padding:0">A</div>' +
      '  <div id="b" style="display:table-cell; padding:0">B</div>' +
      '</div>',
      400);

    Tbl := FindBoxById(Engine.Root, 't');
    A := FindBoxById(Engine.Root, 'a');
    B := FindBoxById(Engine.Root, 'b');
    Check(Assigned(Tbl) and Assigned(A) and Assigned(B), 'boxes must exist');

    Check(Tbl.ContentWidth > 0,
      Format('display:table with orphan cells must have width > 0, got %.1f', [Tbl.ContentWidth]));
    Check(A.ContentWidth > 0,
      Format('first orphan cell width > 0, got %.1f', [A.ContentWidth]));
    Check(B.ContentWidth > 0,
      Format('second orphan cell width > 0, got %.1f', [B.ContentWidth]));
    // Cells should be side-by-side: B starts to the right of A.
    Check(B.X > A.X,
      Format('B.X (%.1f) must be greater than A.X (%.1f)', [B.X, A.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTileRowLogoLeftDescRightRepro;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Logo, Desc: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim repro of the original cuttlefish drill-down tile shape that
    // rendered with blank text before the fix: logo+description side-by-side
    // via display:table / display:table-cell.
    RunLayout(Parser, Engine,
      '<div style="display:table; width:170px; padding:0">' +
      '  <div id="logo" style="display:table-cell; width:64px; ' +
      '       vertical-align:middle; padding:0">L</div>' +
      '  <div id="desc" style="display:table-cell; ' +
      '       vertical-align:middle; padding:0 6px">' +
      '       R12 MTN Hourly Data 1GB</div>' +
      '</div>',
      400);

    Logo := FindBoxById(Engine.Root, 'logo');
    Desc := FindBoxById(Engine.Root, 'desc');
    Check(Assigned(Logo) and Assigned(Desc), 'cells must exist');

    Check(Desc.X > Logo.X,
      Format('description must sit to the right of logo (logo.X=%.1f desc.X=%.1f)',
             [Logo.X, Desc.X]));
    Check(Desc.ContentWidth > 0,
      Format('description cell must have non-zero width, got %.1f', [Desc.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// CSS float
//
// Float MVP: out-of-flow positioning at parent's left/right edge, in-flow
// siblings shifted past the float horizontally. Parent stretches vertically
// to enclose any overhanging float (clearfix-like). Inline-content
// line-by-line wrap around floats is NOT yet implemented — siblings shift
// uniformly as full blocks.
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestFloatLeftPushesSiblingRight;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  L, S: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // float:left logo + sibling div. The sibling must sit to the right
    // of the float (X > 0) and have its width clamped accordingly.
    RunLayout(Parser, Engine,
      '<div style="width:300px; padding:0">' +
      '  <div id="lf" style="float:left; width:64px; height:64px; padding:0">L</div>' +
      '  <div id="sib" style="padding:0">S</div>' +
      '</div>',
      400);

    L := FindBoxById(Engine.Root, 'lf');
    S := FindBoxById(Engine.Root, 'sib');
    Check(Assigned(L) and Assigned(S), 'boxes must exist');

    Check(Abs(L.X) < 0.5, Format('float should sit at X=0, got %.1f', [L.X]));
    Check(Abs(S.X - 64) < 2, Format('sibling X should be past float (~64), got %.1f', [S.X]));
    Check(S.ContentWidth > 0, Format('sibling content width > 0, got %.1f', [S.ContentWidth]));
    Check(S.ContentWidth < 240,
      Format('sibling width should be reduced (<240), got %.1f', [S.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestFloatRightPushesSiblingLeft;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  R, S: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<div style="width:300px; padding:0">' +
      '  <div id="rf" style="float:right; width:64px; height:64px; padding:0">R</div>' +
      '  <div id="sib" style="padding:0">S</div>' +
      '</div>',
      400);

    R := FindBoxById(Engine.Root, 'rf');
    S := FindBoxById(Engine.Root, 'sib');
    Check(Assigned(R) and Assigned(S), 'boxes must exist');

    // float:right pinned to right edge: X+W ≈ 300.
    Check(Abs(R.X + R.MarginBoxWidth - 300) < 2,
      Format('float-right X+W should be 300, got %.1f', [R.X + R.MarginBoxWidth]));
    Check(Abs(S.X) < 0.5, Format('sibling X should be 0, got %.1f', [S.X]));
    Check(S.ContentWidth < 240,
      Format('sibling width reduced for right-float, got %.1f', [S.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTwoLeftFloatsStackHorizontally;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  F1, F2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    RunLayout(Parser, Engine,
      '<div style="width:400px; padding:0">' +
      '  <div id="a" style="float:left; width:80px; height:50px; padding:0">A</div>' +
      '  <div id="b" style="float:left; width:80px; height:50px; padding:0">B</div>' +
      '</div>',
      400);

    F1 := FindBoxById(Engine.Root, 'a');
    F2 := FindBoxById(Engine.Root, 'b');
    Check(Assigned(F1) and Assigned(F2), 'floats must exist');

    Check(Abs(F1.X) < 0.5, Format('first float at X=0, got %.1f', [F1.X]));
    Check(Abs(F2.X - 80) < 2, Format('second float X≈80, got %.1f', [F2.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestSiblingPastFloatBottomReturnsToFullWidth;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  S1, S2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // 50px float, two 30px siblings: first overlaps the float (shifted right),
    // second sits below the float bottom (full width back).
    RunLayout(Parser, Engine,
      '<div style="width:300px; padding:0">' +
      '  <div id="f"  style="float:left; width:64px; height:50px; padding:0">F</div>' +
      '  <div id="s1" style="height:30px; padding:0">A</div>' +
      '  <div id="s2" style="height:30px; padding:0">B</div>' +
      '</div>',
      400);

    S1 := FindBoxById(Engine.Root, 's1');
    S2 := FindBoxById(Engine.Root, 's2');
    Check(Assigned(S1) and Assigned(S2), 'siblings must exist');

    // s1 starts at Y=0, within float's 0..50 range → shifted.
    Check(Abs(S1.X - 64) < 2, Format('s1 (within float) shifted, got X=%.1f', [S1.X]));
    // s2 starts at Y=30, still inside float (0..50) → still shifted.
    Check(Abs(S2.X - 64) < 2, Format('s2 (still in float band) shifted, got X=%.1f', [S2.X]));
    // s2's Y must be past s1's height
    Check(S2.Y >= 30,
      Format('s2.Y should be at/past 30 (s1 bottom), got %.1f', [S2.Y]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestParentEnclosesOverhangingFloat;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  P: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Float is taller than the in-flow sibling. Parent's content height
    // must extend to cover the float (otherwise it would visually escape).
    RunLayout(Parser, Engine,
      '<div id="p" style="width:300px; padding:0">' +
      '  <div style="float:left; width:64px; height:120px; padding:0">F</div>' +
      '  <div style="height:20px; padding:0">S</div>' +
      '</div>',
      400);

    P := FindBoxById(Engine.Root, 'p');
    Check(Assigned(P), 'parent must exist');
    Check(P.ContentHeight >= 120,
      Format('parent must enclose 120px float, got height %.1f', [P.ContentHeight]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestFloatLogoTextRowRepro;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Logo, Desc: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim cuttlefish drill-down tile shape using floats — what the
    // bug report described as "floats are also a known weak spot".
    RunLayout(Parser, Engine,
      '<div style="width:170px; padding:0">' +
      '  <div id="logo" style="float:left; width:64px; height:64px; padding:0">L</div>' +
      '  <div id="desc" style="padding:0">R12 MTN Hourly Data 1GB</div>' +
      '</div>',
      400);

    Logo := FindBoxById(Engine.Root, 'logo');
    Desc := FindBoxById(Engine.Root, 'desc');
    Check(Assigned(Logo) and Assigned(Desc), 'logo + desc boxes must exist');

    Check(Abs(Logo.X) < 0.5, Format('logo at X=0, got %.1f', [Logo.X]));
    Check(Abs(Desc.X - 64) < 2,
      Format('description shifted past float (~64), got %.1f', [Desc.X]));
    Check(Desc.ContentWidth > 0, 'description width > 0');
    Check(Desc.ContentWidth < 110,
      Format('description width clamped (<110), got %.1f', [Desc.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// display: inline-table
//
// CSS Display Module Level 3 two-value model:
//   inline-table = outer-display:inline + inner-display:table
// Tina4 routes the outer placement through the inline-block path (so the
// box itself flows inline with surrounding text/elements) and the inner
// layout through LayoutTable (so anonymous-row wrapping and column-width
// rules kick in).
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestInlineTableLaysOutCellsSideBySide;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Tbl, A, B: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim bug-report repro: display:inline-table parent with two
    // direct display:table-cell children. Cells must lay out side-by-side
    // and the parent must have non-zero size.
    RunLayout(Parser, Engine,
      '<div id="row" style="display:inline-table; width:200px; padding:0">' +
      '  <div id="a" style="display:table-cell; padding:4px">A</div>' +
      '  <div id="b" style="display:table-cell; padding:4px">B</div>' +
      '</div>',
      400);

    Tbl := FindBoxById(Engine.Root, 'row');
    A := FindBoxById(Engine.Root, 'a');
    B := FindBoxById(Engine.Root, 'b');
    Check(Assigned(Tbl) and Assigned(A) and Assigned(B), 'boxes must exist');

    Check(Tbl.ContentWidth > 0,
      Format('inline-table must have width > 0, got %.1f', [Tbl.ContentWidth]));
    Check(Tbl.ContentHeight > 0,
      Format('inline-table must have height > 0, got %.1f', [Tbl.ContentHeight]));
    Check(B.X > A.X,
      Format('B (%.1f) must sit to the right of A (%.1f)', [B.X, A.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestInlineTableSiblingsFlowHorizontally;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  T1, T2: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Two inline-table siblings should sit side-by-side on the same line
    // (inline outer flow), not stack vertically like display:table would.
    RunLayout(Parser, Engine,
      '<div style="width:600px; padding:0">' +
      '  <div id="t1" style="display:inline-table; width:120px; padding:0">' +
      '    <div style="display:table-cell">A</div>' +
      '  </div>' +
      '  <div id="t2" style="display:inline-table; width:120px; padding:0">' +
      '    <div style="display:table-cell">B</div>' +
      '  </div>' +
      '</div>',
      600);

    T1 := FindBoxById(Engine.Root, 't1');
    T2 := FindBoxById(Engine.Root, 't2');
    Check(Assigned(T1) and Assigned(T2), 'both inline-tables must exist');

    Check(T2.X > T1.X,
      Format('inline-tables must flow horizontally: t1.X=%.1f t2.X=%.1f', [T1.X, T2.X]));
    Check(Abs(T1.Y - T2.Y) < 2,
      Format('inline-tables on same line: t1.Y=%.1f t2.Y=%.1f', [T1.Y, T2.Y]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// Bug-list regressions (cuttlefish html-render branch)
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestBoxSizingBorderBoxKeepsOuterWidthConstant;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  D: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Verbatim Bug 3 repro: width:100 + padding:10 + border:1 + box-sizing:
    // border-box must produce outer (margin-box) width of 100, with the
    // content shrunk to 100 - 20 - 2 = 78.
    RunLayout(Parser, Engine,
      '<div id="d" style="width:100px; padding:10px; border:1px solid red; ' +
      '       box-sizing:border-box">x</div>',
      400);
    D := FindBoxById(Engine.Root, 'd');
    Check(Assigned(D), 'box must exist');
    Check(Abs(D.ContentWidth - 78) < 0.5,
      Format('content width should be 78 (100 - 20 padding - 2 border), got %.1f', [D.ContentWidth]));
    Check(Abs(D.MarginBoxWidth - 100) < 0.5,
      Format('outer width should be 100, got %.1f', [D.MarginBoxWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestTableCellWidthIsHardConstraint;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  A, B: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug 5: explicit width on table-cell must NOT shrink/grow with
    // sibling text length.
    RunLayout(Parser, Engine,
      '<div style="display:table; width:200px; padding:0">' +
      '  <div id="a" style="display:table-cell; width:70px; padding:0">&nbsp;</div>' +
      '  <div id="b" style="display:table-cell; padding:0">short text</div>' +
      '</div>', 400);

    A := FindBoxById(Engine.Root, 'a');
    B := FindBoxById(Engine.Root, 'b');
    Check(Assigned(A) and Assigned(B), 'cells must exist');
    Check(Abs(A.ContentWidth - 70) < 2,
      Format('a (with width:70px) should be 70, got %.1f', [A.ContentWidth]));
    Check(Abs(B.ContentWidth - 130) < 2,
      Format('b should take rest (130), got %.1f', [B.ContentWidth]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestNotPseudoClassDoesNotDropSiblingRules;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  StyleSheet: Tina4HtmlRender.TCSSStyleSheet;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  StyleSheet := Tina4HtmlRender.TCSSStyleSheet.Create;
  try
    // Bug 2: a stylesheet that contains a :not() rule should still apply
    // the rules that don't use it. Most direct test we can do without
    // running paint: parse, then check the stylesheet's matching can
    // find the simple `.x` rule. That proves the parser didn't drop it.
    StyleSheet.AddCSS(
      '.x { color: red; }' + sLineBreak +
      '.button:not(.disabled) { background: blue; }' + sLineBreak +
      '.y { color: green; }');
    // Build a tiny DOM so we can ask the stylesheet what matches.
    Parser.Parse('<div id="t" class="x">A</div>');
    var Decls: TDictionary<string,string> := TDictionary<string,string>.Create;
    try
      StyleSheet.ApplyTo(Parser.Root.Children[0], Decls);
      // If :not() dropped the whole sheet, there'd be NO `color` decl set.
      Check(Decls.ContainsKey('color'),
        ':not() rule should not drop unrelated `.x { color }` rule');
    finally
      Decls.Free;
    end;
  finally
    StyleSheet.Free;
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestDisplayFlowRootEnclosesFloats;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  P: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug 4: a parent with `display: flow-root` should enclose its
    // floated children regardless of in-flow content height. Parent
    // here has only one float (no in-flow content), so without
    // flow-root semantics the parent height would collapse to 0.
    // (Tina4 already always encloses overhanging floats — flow-root
    // is supported as a synonym so authors get the explicit opt-in.)
    RunLayout(Parser, Engine,
      '<div id="p" style="display:flow-root; width:200px; padding:0">' +
      '  <div style="float:left; width:64px; height:80px; padding:0">F</div>' +
      '</div>', 400);
    P := FindBoxById(Engine.Root, 'p');
    Check(Assigned(P), 'flow-root box must exist');
    Check(P.ContentHeight >= 80,
      Format('flow-root parent must enclose 80px float, got %.1f', [P.ContentHeight]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

// ---------------------------------------------------------------------------
// 2026-05-08 bug list — sticky:left, nowrap on inline-block, data: URIs
// ---------------------------------------------------------------------------

procedure TestTTina4Components.TestStickyLeftPinsToScrollAncestorXEdge;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  Back: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug 1 from 2026-05-08 list: sticky `left:0` inside an
    // overflow-x: auto strip. We can't simulate scroll in a layout-only
    // test, but we can verify the BACK cell is laid out as an inline-block
    // (its X is sensible) and that its Style.CSSPosition + CSSLeft are
    // captured. Paint logic for horizontal sticky lives in PaintBox.
    RunLayout(Parser, Engine,
      '<div style="width:540px; overflow-x:auto; white-space:nowrap; padding:0">' +
      '  <div id="back" style="display:inline-block; width:72px; height:72px;' +
      '       position:sticky; left:0">BACK</div>' +
      '  <div style="display:inline-block; width:200px; height:72px">A</div>' +
      '  <div style="display:inline-block; width:200px; height:72px">B</div>' +
      '  <div style="display:inline-block; width:200px; height:72px">C</div>' +
      '</div>',
      540);

    Back := FindBoxById(Engine.Root, 'back');
    Check(Assigned(Back), 'BACK cell must exist');
    CheckEquals('sticky', Back.Style.CSSPosition,
      'BACK cell must keep position:sticky');
    Check(Back.Style.CSSLeft > -9990,
      Format('BACK cell must capture left:0, got CSSLeft=%.1f', [Back.Style.CSSLeft]));
    Check(Abs(Back.Style.CSSLeft) < 0.5,
      Format('BACK cell left:0 should resolve to 0, got %.1f', [Back.Style.CSSLeft]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestNowrapInlineBlockOverflowsContainer;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  A, B, C: Tina4HtmlRender.TLayoutBox;
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug 6 from 2026-05-08 list: nowrap on parent must keep inline-block
    // children on a single line even when their sum exceeds the parent.
    RunLayout(Parser, Engine,
      '<div style="width:300px; white-space:nowrap; padding:0">' +
      '  <div id="a" style="display:inline-block; width:200px; height:50px">A</div>' +
      '  <div id="b" style="display:inline-block; width:200px; height:50px">B</div>' +
      '  <div id="c" style="display:inline-block; width:200px; height:50px">C</div>' +
      '</div>',
      400);

    A := FindBoxById(Engine.Root, 'a');
    B := FindBoxById(Engine.Root, 'b');
    C := FindBoxById(Engine.Root, 'c');
    Check(Assigned(A) and Assigned(B) and Assigned(C), 'all 3 cells must exist');

    // Under nowrap all three siblings keep the same Y as A (one line),
    // overflowing the 300px container's right edge.
    Check(Abs(A.Y - B.Y) < 1,
      Format('B should be on same line as A: A.Y=%.1f B.Y=%.1f', [A.Y, B.Y]));
    Check(Abs(A.Y - C.Y) < 1,
      Format('C should be on same line as A: A.Y=%.1f C.Y=%.1f', [A.Y, C.Y]));
    Check(B.X > A.X,
      Format('B must sit to the right of A (no wrap): B.X=%.1f A.X=%.1f', [B.X, A.X]));
    Check(C.X > B.X,
      Format('C must sit to the right of B (no wrap): C.X=%.1f B.X=%.1f', [C.X, B.X]));
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

procedure TestTTina4Components.TestDataUriBackgroundImageInInlineStyleParsed;
var
  Parser: Tina4HtmlRender.THTMLParser;
  Engine: Tina4HtmlRender.TLayoutEngine;
  D: Tina4HtmlRender.TLayoutBox;
const
  // Tiny 1x1 PNG as base64. Real-world data: URIs are kilobytes; this is
  // enough to exercise the parser's handling of `;`, `:`, and `,` inside
  // a url() value.
  TINY_PNG = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';
begin
  Parser := Tina4HtmlRender.THTMLParser.Create;
  Engine := Tina4HtmlRender.TLayoutEngine.Create(nil);
  try
    // Bug 8 from 2026-05-08 list: inline style with data: URI for
    // background-image. The URI itself contains ';' (mediatype param
    // separator) and ':' (after data). Both can confuse a naive parser.
    // We verify that Style.BackgroundImage holds the FULL URI and that
    // the previously-set width on the same element survives parsing.
    RunLayout(Parser, Engine,
      '<div id="t" style="width:109px; height:50px; ' +
      '       background-image: url(' + TINY_PNG + ')">x</div>',
      400);

    D := FindBoxById(Engine.Root, 't');
    Check(Assigned(D), 'box must exist');
    Check(Abs(D.ContentWidth - 109) < 0.5,
      Format('width must be preserved past the url() value: got %.1f', [D.ContentWidth]));
    Check(D.Style.BackgroundImage <> '',
      'background-image must be captured from inline style');
    Check(D.Style.BackgroundImage.StartsWith('data:image/png;base64,'),
      Format('background-image should retain full data: URI prefix, got [%s]',
             [D.Style.BackgroundImage.Substring(0, 40)]));
    // The base64 payload must be intact (parser must not have truncated
    // at the ';' or ',' inside the URI).
    Check(D.Style.BackgroundImage.Contains('iVBORw0KGgo'),
      'base64 payload must survive parsing');
  finally
    Engine.Free;
    Parser.Free;
  end;
end;

initialization
  RegisterTest(TestTTina4Components.Suite);
end.
