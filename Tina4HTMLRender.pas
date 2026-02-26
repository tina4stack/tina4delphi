unit Tina4HtmlRender;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Math,
  System.Generics.Collections, System.Generics.Defaults,
  System.UITypes, System.UIConsts,
  System.NetEncoding, System.Net.HttpClient,
  System.IOUtils, System.Hash,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.TextLayout,
  FMX.Edit, FMX.StdCtrls, FMX.Memo, FMX.ListBox, FMX.Layouts;

type
  // ─────────────────────────────────────────────────────────────────────────
  // DOM Node
  // ─────────────────────────────────────────────────────────────────────────

  THTMLTag = class
  public
    TagName: string;
    Text: string;
    Style: TDictionary<string, string>;
    Attributes: TDictionary<string, string>;
    Children: TList<THTMLTag>;
    Parent: THTMLTag;
    constructor Create;
    destructor Destroy; override;
    function GetAttribute(const Name: string; const Default: string = ''): string;
    function HasAttribute(const Name: string): Boolean;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // HTML Parser
  // ─────────────────────────────────────────────────────────────────────────

  THTMLParser = class
  private
    FRoot: THTMLTag;
    FHTML: string;
    FPos: Integer;
    FLen: Integer;
    FInPre: Boolean;
    FStyleBlocks: TStringList;
    FLinkHrefs: TStringList;
    function Peek: Char;
    function PeekAt(Offset: Integer): Char;
    procedure Advance(Count: Integer = 1);
    function AtEnd: Boolean;
    procedure SkipWhitespace;
    procedure SkipComment;
    procedure SkipDoctype;
    procedure SkipRawContent(const TagName: string);
    function ReadRawContent(const TagName: string): string;
    function ReadTagName: string;
    function ReadAttributeValue: string;
    procedure ParseAttributes(Tag: THTMLTag);
    procedure ParseStyleAttribute(const StyleStr: string; Dict: TDictionary<string, string>);
    procedure ParseChildren(Parent: THTMLTag; const StopTag: string = '');
    class function IsVoidTag(const Name: string): Boolean; static;
    class function IsRawTag(const Name: string): Boolean; static;
    class function IsIgnoredTag(const Name: string): Boolean; static;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const HTML: string);
    property Root: THTMLTag read FRoot;
    property StyleBlocks: TStringList read FStyleBlocks;
    property LinkHrefs: TStringList read FLinkHrefs;
    class function DecodeEntities(const S: string): string; static;
    class function IsBlockTag(const Name: string): Boolean; static;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // File Cache (disk-based caching for HTTP downloads)
  // ─────────────────────────────────────────────────────────────────────────

  TFileCache = class
  private
    FCacheDir: string;
    FEnabled: Boolean;
    procedure EnsureCacheDir;
    function URLToFileName(const URL: string): string;
  public
    constructor Create;
    function TryLoadBytes(const URL: string; out Bytes: TBytes): Boolean;
    procedure SaveBytes(const URL: string; const Bytes: TBytes);
    function TryLoadString(const URL: string; out Content: string): Boolean;
    procedure SaveString(const URL: string; const Content: string);
    procedure ClearCache;
    property CacheDir: string read FCacheDir write FCacheDir;
    property Enabled: Boolean read FEnabled write FEnabled;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // CSS Stylesheet
  // ─────────────────────────────────────────────────────────────────────────

  TCSSDeclarations = TDictionary<string, string>;

  TCSSRule = class
  public
    Selector: string;
    Declarations: TCSSDeclarations;
    constructor Create;
    destructor Destroy; override;
  end;

  TCSSStyleSheet = class
  private
    FRules: TObjectList<TCSSRule>;
    FFileCache: TFileCache;
    procedure ParseCSS(const CSSText: string);
    function SelectorMatches(const Selector: string; Tag: THTMLTag): Boolean;
    function SelectorSpecificity(const Selector: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddCSS(const CSSText: string);
    procedure LoadFromURL(const URL: string);
    procedure Clear;
    procedure ApplyTo(Tag: THTMLTag; Declarations: TCSSDeclarations);
    property Rules: TObjectList<TCSSRule> read FRules;
    property FileCache: TFileCache read FFileCache write FFileCache;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Computed Style
  // ─────────────────────────────────────────────────────────────────────────

  TEdgeValues = record
    Top, Right, Bottom, Left: Single;
    procedure Clear;
    procedure SetAll(V: Single);
  end;

  TComputedStyle = record
    FontFamily: string;
    FontSize: Single;
    Bold: Boolean;
    Italic: Boolean;
    Color: TAlphaColor;
    BackgroundColor: TAlphaColor;
    TextDecoration: string;
    TextAlign: TTextAlign;
    LineHeight: Single;
    VerticalAlign: string;
    Margin: TEdgeValues;
    Padding: TEdgeValues;
    BorderColor: TAlphaColor;
    BorderWidth: Single;
    ExplicitWidth: Single;
    ExplicitHeight: Single;
    Display: string;
    WhiteSpace: string;
    BoxSizing: string;
    class function Default: TComputedStyle; static;
    class function ForTag(Tag: THTMLTag; const ParentStyle: TComputedStyle; StyleSheet: TCSSStyleSheet = nil): TComputedStyle; static;
    class procedure ApplyDeclarations(Decls: TCSSDeclarations; var Style: TComputedStyle; const ParentStyle: TComputedStyle); static;
    class function ParseColor(const S: string): TAlphaColor; static;
    class function ParseLength(const S: string; EmSize: Single = 14): Single; static;
    class procedure ParseEdgeShorthand(const S: string; var E: TEdgeValues; EmSize: Single); static;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Layout Box
  // ─────────────────────────────────────────────────────────────────────────

  TLayoutBoxKind = (lbkBlock, lbkInline, lbkText, lbkTable, lbkTableRow,
    lbkTableCell, lbkListItem, lbkImage, lbkFormControl, lbkHR, lbkBR);

  TTextFragment = record
    Text: string;
    X, Y, W, H: Single;
  end;

  TLayoutBox = class
  public
    Tag: THTMLTag;
    Style: TComputedStyle;
    Kind: TLayoutBoxKind;
    X, Y: Single;
    ContentWidth, ContentHeight: Single;
    Children: TObjectList<TLayoutBox>;
    Fragments: TList<TTextFragment>;
    ListIndex: Integer;
    IsOrdered: Boolean;
    constructor Create(ATag: THTMLTag; AKind: TLayoutBoxKind);
    destructor Destroy; override;
    function MarginBoxWidth: Single;
    function MarginBoxHeight: Single;
    function ContentLeft: Single;
    function ContentTop: Single;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Image Cache
  // ─────────────────────────────────────────────────────────────────────────

  TImageCache = class
  private
    FCache: TDictionary<string, TBitmap>;
    FPending: TDictionary<string, Boolean>;
    FOnImageLoaded: TNotifyEvent;
    FDestroying: Boolean;
    FFileCache: TFileCache;
  public
    constructor Create;
    destructor Destroy; override;
    function GetImage(const Src: string): TBitmap;
    procedure RequestImage(const Src: string);
    procedure Clear;
    property OnImageLoaded: TNotifyEvent read FOnImageLoaded write FOnImageLoaded;
    property FileCache: TFileCache read FFileCache write FFileCache;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Layout Engine
  // ─────────────────────────────────────────────────────────────────────────

  TLayoutEngine = class
  private
    FRoot: TLayoutBox;
    FImageCache: TImageCache;
    FStyleSheet: TCSSStyleSheet;
    FTotalHeight: Single;
    function BuildBoxTree(Tag: THTMLTag; const ParentStyle: TComputedStyle): TLayoutBox;
    procedure LayoutBlock(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutInlineChildren(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutTable(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutListItem(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutImage(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutFormControl(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutHR(Box: TLayoutBox; AvailWidth: Single);
    function MeasureTextWidth(const Text: string; const Style: TComputedStyle): Single;
    function MeasureTextHeight(const Text: string; const Style: TComputedStyle; MaxWidth: Single): Single;
    function GetLineHeight(const Style: TComputedStyle): Single;
  public
    constructor Create(AImageCache: TImageCache);
    destructor Destroy; override;
    procedure Layout(DOMRoot: THTMLTag; AvailWidth: Single; AStyleSheet: TCSSStyleSheet = nil);
    property Root: TLayoutBox read FRoot;
    property TotalHeight: Single read FTotalHeight;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Form Control Support Types
  // ─────────────────────────────────────────────────────────────────────────

  THTMLFormControlEvent = procedure(Sender: TObject; const Name, Value: string) of object;

  TNativeFormControl = record
    Control: TControl;
    Box: TLayoutBox;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // HTML Render Control
  // ─────────────────────────────────────────────────────────────────────────

  TTina4HTMLRender = class(TControl)
  private
    FHTML: TStringList;
    FDebug: TStringList;
    FParser: THTMLParser;
    FLayoutEngine: TLayoutEngine;
    FImageCache: TImageCache;
    FStyleSheet: TCSSStyleSheet;
    FFileCache: TFileCache;
    FCacheEnabled: Boolean;
    FCacheDir: string;
    FScrollY: Single;
    FContentHeight: Single;
    FNeedRelayout: Boolean;
    FScrollBarWidth: Single;
    FIsLayoutting: Boolean;
    FMouseDownOnScroll: Boolean;
    FScrollDragStart: Single;
    FScrollDragThumbStart: Single;
    FFormControls: TList<TNativeFormControl>;
    FOnChange: THTMLFormControlEvent;
    FOnClick: THTMLFormControlEvent;
    FOnEnter: THTMLFormControlEvent;
    FOnExit: THTMLFormControlEvent;
    procedure SetHTML(const Value: TStringList);
    function GetHTML: TStringList;
    procedure SetCacheEnabled(Value: Boolean);
    procedure SetCacheDir(const Value: string);
    procedure FHTMLChange(Sender: TObject);
    procedure OnImageLoaded(Sender: TObject);
    procedure DoLayout;
    procedure ClearFormControls;
    procedure CreateFormControls(Box: TLayoutBox; OffX, OffY: Single);
    procedure PositionFormControls;
    procedure HandleFormControlChange(Sender: TObject);
    procedure HandleFormControlClick(Sender: TObject);
    procedure HandleFormControlEnter(Sender: TObject);
    procedure HandleFormControlExit(Sender: TObject);
    function GetFormControlNameValue(Control: TControl; out AName, AValue: string): Boolean;
    procedure PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single);
    procedure PaintBackground(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintText(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintImage(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintHR(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintListMarker(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintTableCellBorders(Canvas: TCanvas; Box: TLayoutBox; CX, CY: Single);
    procedure PaintScrollBar(Canvas: TCanvas);
    function ScrollBarVisible: Boolean;
    procedure ClampScroll;
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer;
      var Handled: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearCache;
  published
    property HTML: TStringList read GetHTML write SetHTML;
    property Debug: TStringList read FDebug write FDebug;
    property CacheEnabled: Boolean read FCacheEnabled write SetCacheEnabled default False;
    property CacheDir: string read FCacheDir write SetCacheDir;
    property OnFormControlChange: THTMLFormControlEvent read FOnChange write FOnChange;
    property OnFormControlClick: THTMLFormControlEvent read FOnClick write FOnClick;
    property OnFormControlEnter: THTMLFormControlEvent read FOnEnter write FOnEnter;
    property OnFormControlExit: THTMLFormControlEvent read FOnExit write FOnExit;
    property Align;
    property Position;
    property Width;
    property Height;
    property Visible;
    property Enabled;
    property ClipChildren;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HTMLRender]);
end;

// ═══════════════════════════════════════════════════════════════════════════
// THTMLTag
// ═══════════════════════════════════════════════════════════════════════════

constructor THTMLTag.Create;
begin
  inherited;
  Style := TDictionary<string, string>.Create;
  Attributes := TDictionary<string, string>.Create;
  Children := TList<THTMLTag>.Create;
  Parent := nil;
end;

destructor THTMLTag.Destroy;
begin
  for var Child in Children do
    Child.Free;
  Children.Free;
  Style.Free;
  Attributes.Free;
  inherited;
end;

function THTMLTag.GetAttribute(const Name: string; const Default: string): string;
begin
  if not Attributes.TryGetValue(Name.ToLower, Result) then
    Result := Default;
end;

function THTMLTag.HasAttribute(const Name: string): Boolean;
begin
  Result := Attributes.ContainsKey(Name.ToLower);
end;

// ═══════════════════════════════════════════════════════════════════════════
// TFileCache
// ═══════════════════════════════════════════════════════════════════════════

constructor TFileCache.Create;
begin
  inherited;
  FEnabled := False;
  FCacheDir := TPath.Combine(TPath.GetTempPath, 'Tina4Cache');
end;

procedure TFileCache.EnsureCacheDir;
begin
  if not TDirectory.Exists(FCacheDir) then
    TDirectory.CreateDirectory(FCacheDir);
end;

function TFileCache.URLToFileName(const URL: string): string;
begin
  Result := THashMD5.GetHashString(URL);
end;

function TFileCache.TryLoadBytes(const URL: string; out Bytes: TBytes): Boolean;
var
  FilePath: string;
begin
  Result := False;
  if not FEnabled then Exit;
  FilePath := TPath.Combine(FCacheDir, URLToFileName(URL));
  if TFile.Exists(FilePath) then
  begin
    try
      Bytes := TFile.ReadAllBytes(FilePath);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

procedure TFileCache.SaveBytes(const URL: string; const Bytes: TBytes);
var
  FilePath: string;
begin
  if not FEnabled then Exit;
  try
    EnsureCacheDir;
    FilePath := TPath.Combine(FCacheDir, URLToFileName(URL));
    TFile.WriteAllBytes(FilePath, Bytes);
  except
    // Silently fail on disk write errors
  end;
end;

function TFileCache.TryLoadString(const URL: string; out Content: string): Boolean;
var
  FilePath: string;
begin
  Result := False;
  if not FEnabled then Exit;
  FilePath := TPath.Combine(FCacheDir, URLToFileName(URL));
  if TFile.Exists(FilePath) then
  begin
    try
      Content := TFile.ReadAllText(FilePath);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

procedure TFileCache.SaveString(const URL: string; const Content: string);
var
  FilePath: string;
begin
  if not FEnabled then Exit;
  try
    EnsureCacheDir;
    FilePath := TPath.Combine(FCacheDir, URLToFileName(URL));
    TFile.WriteAllText(FilePath, Content);
  except
    // Silently fail on disk write errors
  end;
end;

procedure TFileCache.ClearCache;
begin
  try
    if TDirectory.Exists(FCacheDir) then
      TDirectory.Delete(FCacheDir, True);
  except
    // Silently fail
  end;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TCSSRule / TCSSStyleSheet
// ═══════════════════════════════════════════════════════════════════════════

constructor TCSSRule.Create;
begin
  inherited;
  Declarations := TCSSDeclarations.Create;
end;

destructor TCSSRule.Destroy;
begin
  Declarations.Free;
  inherited;
end;

constructor TCSSStyleSheet.Create;
begin
  inherited;
  FRules := TObjectList<TCSSRule>.Create(True);
end;

destructor TCSSStyleSheet.Destroy;
begin
  FRules.Free;
  inherited;
end;

procedure TCSSStyleSheet.Clear;
begin
  FRules.Clear;
end;

procedure TCSSStyleSheet.ParseCSS(const CSSText: string);
var
  S, SelectorPart, DeclBlock, DeclStr: string;
  BraceStart, BraceEnd, I: Integer;
  Rule: TCSSRule;
  Decls: TArray<string>;
  KV: TArray<string>;
  Selectors: TArray<string>;
begin
  // Strip CSS comments /* ... */
  S := CSSText;
  I := S.IndexOf('/*');
  while I >= 0 do
  begin
    var EndComment := S.IndexOf('*/', I + 2);
    if EndComment >= 0 then
      S := S.Remove(I, EndComment - I + 2)
    else
      S := S.Remove(I);
    I := S.IndexOf('/*');
  end;

  I := 0;
  while I < Length(S) do
  begin
    // Find opening brace
    BraceStart := S.IndexOf('{', I);
    if BraceStart < 0 then Break;

    // Find matching closing brace
    BraceEnd := S.IndexOf('}', BraceStart + 1);
    if BraceEnd < 0 then Break;

    SelectorPart := S.Substring(I, BraceStart - I).Trim;
    DeclBlock := S.Substring(BraceStart + 1, BraceEnd - BraceStart - 1).Trim;

    // Skip @rules (media queries, keyframes, etc.)
    if SelectorPart.StartsWith('@') then
    begin
      I := BraceEnd + 1;
      Continue;
    end;

    // Parse declarations
    if (SelectorPart <> '') and (DeclBlock <> '') then
    begin
      // Handle comma-separated selectors: "h1, h2, h3 { ... }"
      Selectors := SelectorPart.Split([',']);
      Decls := DeclBlock.Split([';']);

      for var Sel in Selectors do
      begin
        var TrimmedSel := Sel.Trim;
        if TrimmedSel = '' then Continue;

        Rule := TCSSRule.Create;
        Rule.Selector := TrimmedSel;

        for var D in Decls do
        begin
          DeclStr := D.Trim;
          if DeclStr = '' then Continue;
          KV := DeclStr.Split([':'], 2);
          if Length(KV) = 2 then
            Rule.Declarations.AddOrSetValue(KV[0].Trim.ToLower, KV[1].Trim);
        end;

        if Rule.Declarations.Count > 0 then
          FRules.Add(Rule)
        else
          Rule.Free;
      end;
    end;

    I := BraceEnd + 1;
  end;
end;

procedure TCSSStyleSheet.AddCSS(const CSSText: string);
begin
  ParseCSS(CSSText);
end;

procedure TCSSStyleSheet.LoadFromURL(const URL: string);
var
  Client: THTTPClient;
  Response: IHTTPResponse;
  Content, CachedContent: string;
begin
  // Check disk cache first
  if Assigned(FFileCache) and FFileCache.Enabled then
  begin
    if FFileCache.TryLoadString(URL, CachedContent) then
    begin
      AddCSS(CachedContent);
      Exit;
    end;
  end;

  Client := THTTPClient.Create;
  try
    try
      Response := Client.Get(URL);
      if Response.StatusCode = 200 then
      begin
        Content := Response.ContentAsString;
        AddCSS(Content);
        // Save to disk cache
        if Assigned(FFileCache) and FFileCache.Enabled then
          FFileCache.SaveString(URL, Content);
      end;
    except
      // Silently fail on network errors
    end;
  finally
    Client.Free;
  end;
end;

function TCSSStyleSheet.SelectorSpecificity(const Selector: string): Integer;
var
  S: string;
begin
  // Simple specificity: ID=100, class/attr=10, tag=1
  Result := 0;
  S := Selector;
  for var C in S do
  begin
    if C = '#' then Inc(Result, 100)
    else if C = '.' then Inc(Result, 10);
  end;
  // Count tag-level selectors (parts that don't start with # or .)
  var Parts := S.Split([' ']);
  for var P in Parts do
  begin
    var T := P.Trim;
    if (T <> '') and not T.StartsWith('#') and not T.StartsWith('.') and not T.StartsWith(':') then
      Inc(Result, 1);
  end;
end;

function MatchesSingleSelector(const Sel: string; Tag: THTMLTag): Boolean;
var
  SelTag, SelClass, SelId: string;
  DotPos, HashPos: Integer;
begin
  Result := False;
  if not Assigned(Tag) or (Tag.TagName = '#text') or (Tag.TagName = 'root') then
    Exit;

  // Parse selector into tag, class, id parts
  // e.g., "div.container#main" -> tag=div, class=container, id=main
  SelTag := '';
  SelClass := '';
  SelId := '';

  var S := Sel;
  HashPos := S.IndexOf('#');
  DotPos := S.IndexOf('.');

  if (HashPos >= 0) and ((DotPos < 0) or (HashPos < DotPos)) then
  begin
    SelTag := S.Substring(0, HashPos);
    var Rest := S.Substring(HashPos + 1);
    DotPos := Rest.IndexOf('.');
    if DotPos >= 0 then
    begin
      SelId := Rest.Substring(0, DotPos);
      SelClass := Rest.Substring(DotPos + 1);
    end
    else
      SelId := Rest;
  end
  else if DotPos >= 0 then
  begin
    SelTag := S.Substring(0, DotPos);
    var Rest := S.Substring(DotPos + 1);
    HashPos := Rest.IndexOf('#');
    if HashPos >= 0 then
    begin
      SelClass := Rest.Substring(0, HashPos);
      SelId := Rest.Substring(HashPos + 1);
    end
    else
      SelClass := Rest;
  end
  else
    SelTag := S;

  // Match tag name
  if (SelTag <> '') and (SelTag <> '*') then
  begin
    if not SameText(SelTag, Tag.TagName) then Exit;
  end;

  // Match class
  if SelClass <> '' then
  begin
    var TagClass := Tag.GetAttribute('class', '').ToLower;
    // Support multiple classes on element
    var Classes := TagClass.Split([' ']);
    var Found := False;
    for var C in Classes do
      if SameText(C.Trim, SelClass) then
      begin
        Found := True;
        Break;
      end;
    if not Found then Exit;
  end;

  // Match ID
  if SelId <> '' then
  begin
    var TagId := Tag.GetAttribute('id', '').ToLower;
    if not SameText(TagId, SelId) then Exit;
  end;

  // Must have matched at least something
  if (SelTag = '') and (SelClass = '') and (SelId = '') then Exit;

  Result := True;
end;

function TCSSStyleSheet.SelectorMatches(const Selector: string; Tag: THTMLTag): Boolean;
var
  Sel: string;
  Parts: TArray<string>;
begin
  Result := False;
  if not Assigned(Tag) or (Tag.TagName = '#text') or (Tag.TagName = 'root') then
    Exit;

  Sel := Selector.Trim.ToLower;
  if Sel = '' then Exit;

  // Handle descendant selectors (e.g., "div p", "ul li a")
  Parts := Sel.Split([' ']);

  // Match the last selector part against the current tag
  var LastPart := Parts[Length(Parts) - 1].Trim;
  if not MatchesSingleSelector(LastPart, Tag) then
    Exit;

  // If single selector, we're done
  if Length(Parts) = 1 then
    Exit(True);

  // For descendant selectors, walk up ancestor chain
  var Current := Tag.Parent;
  var PartIdx := Length(Parts) - 2;
  while (PartIdx >= 0) and Assigned(Current) do
  begin
    if MatchesSingleSelector(Parts[PartIdx].Trim, Current) then
      Dec(PartIdx);
    Current := Current.Parent;
  end;

  Result := PartIdx < 0;
end;

procedure TCSSStyleSheet.ApplyTo(Tag: THTMLTag; Declarations: TCSSDeclarations);
var
  MatchedRules: TList<TCSSRule>;
begin
  // Collect matching rules and sort by specificity (lower first, so higher overrides)
  MatchedRules := TList<TCSSRule>.Create;
  try
    for var Rule in FRules do
    begin
      if SelectorMatches(Rule.Selector, Tag) then
        MatchedRules.Add(Rule);
    end;

    // Sort by specificity ascending — higher specificity applied last wins
    MatchedRules.Sort(TComparer<TCSSRule>.Construct(
      function(const A, B: TCSSRule): Integer
      begin
        Result := SelectorSpecificity(A.Selector) - SelectorSpecificity(B.Selector);
      end
    ));

    for var Rule in MatchedRules do
    begin
      for var Pair in Rule.Declarations do
        Declarations.AddOrSetValue(Pair.Key, Pair.Value);
    end;
  finally
    MatchedRules.Free;
  end;
end;

// ═══════════════════════════════════════════════════════════════════════════
// THTMLParser
// ═══════════════════════════════════════════════════════════════════════════

constructor THTMLParser.Create;
begin
  inherited;
  FRoot := THTMLTag.Create;
  FRoot.TagName := 'root';
  FStyleBlocks := TStringList.Create;
  FLinkHrefs := TStringList.Create;
end;

destructor THTMLParser.Destroy;
begin
  FRoot.Free;
  FStyleBlocks.Free;
  FLinkHrefs.Free;
  inherited;
end;

function THTMLParser.Peek: Char;
begin
  if FPos <= FLen then
    Result := FHTML[FPos]
  else
    Result := #0;
end;

function THTMLParser.PeekAt(Offset: Integer): Char;
begin
  if (FPos + Offset >= 1) and (FPos + Offset <= FLen) then
    Result := FHTML[FPos + Offset]
  else
    Result := #0;
end;

procedure THTMLParser.Advance(Count: Integer);
begin
  Inc(FPos, Count);
end;

function THTMLParser.AtEnd: Boolean;
begin
  Result := FPos > FLen;
end;

procedure THTMLParser.SkipWhitespace;
begin
  while not AtEnd and CharInSet(Peek, [' ', #9, #10, #13]) do
    Advance;
end;

procedure THTMLParser.SkipComment;
begin
  // FPos points at '<', expect '<!-- ... -->'
  Advance(4); // skip '<!--'
  while not AtEnd do
  begin
    if (Peek = '-') and (PeekAt(1) = '-') and (PeekAt(2) = '>') then
    begin
      Advance(3);
      Exit;
    end;
    Advance;
  end;
end;

procedure THTMLParser.SkipDoctype;
begin
  // Skip everything until '>'
  while not AtEnd and (Peek <> '>') do
    Advance;
  if not AtEnd then
    Advance; // skip '>'
end;

procedure THTMLParser.SkipRawContent(const TagName: string);
var
  CloseTag: string;
begin
  CloseTag := '</' + TagName;
  while not AtEnd do
  begin
    if (Peek = '<') and (PeekAt(1) = '/') then
    begin
      var Match := True;
      for var I := 0 to Length(CloseTag) - 1 do
      begin
        var C := PeekAt(I);
        if LowerCase(C) <> LowerCase(CloseTag[I + 1]) then
        begin
          Match := False;
          Break;
        end;
      end;
      if Match then
      begin
        // Skip to end of closing tag
        Advance(Length(CloseTag));
        while not AtEnd and (Peek <> '>') do
          Advance;
        if not AtEnd then
          Advance; // skip '>'
        Exit;
      end;
    end;
    Advance;
  end;
end;

function THTMLParser.ReadRawContent(const TagName: string): string;
var
  CloseTag: string;
  StartPos: Integer;
begin
  Result := '';
  CloseTag := '</' + TagName;
  StartPos := FPos;
  while not AtEnd do
  begin
    if (Peek = '<') and (PeekAt(1) = '/') then
    begin
      var Match := True;
      for var I := 0 to Length(CloseTag) - 1 do
      begin
        var C := PeekAt(I);
        if LowerCase(C) <> LowerCase(CloseTag[I + 1]) then
        begin
          Match := False;
          Break;
        end;
      end;
      if Match then
      begin
        Result := Copy(FHTML, StartPos, FPos - StartPos);
        Advance(Length(CloseTag));
        while not AtEnd and (Peek <> '>') do
          Advance;
        if not AtEnd then
          Advance;
        Exit;
      end;
    end;
    Advance;
  end;
  Result := Copy(FHTML, StartPos, FPos - StartPos);
end;

function THTMLParser.ReadTagName: string;
begin
  Result := '';
  while not AtEnd and not CharInSet(Peek, [' ', '/', '>', #9, #10, #13]) do
  begin
    Result := Result + Peek;
    Advance;
  end;
  Result := Result.ToLower;
end;

function THTMLParser.ReadAttributeValue: string;
var
  Quote: Char;
begin
  Result := '';
  if AtEnd then Exit;

  if CharInSet(Peek, ['"', '''']) then
  begin
    Quote := Peek;
    Advance;
    while not AtEnd and (Peek <> Quote) do
    begin
      Result := Result + Peek;
      Advance;
    end;
    if not AtEnd then
      Advance; // skip closing quote
  end
  else
  begin
    while not AtEnd and not CharInSet(Peek, [' ', '>', '/', #9, #10, #13]) do
    begin
      Result := Result + Peek;
      Advance;
    end;
  end;
end;

procedure THTMLParser.ParseAttributes(Tag: THTMLTag);
var
  Key, Value: string;
begin
  while not AtEnd do
  begin
    SkipWhitespace;
    if AtEnd or (Peek = '>') or ((Peek = '/') and (PeekAt(1) = '>')) then
      Break;

    // Read attribute name
    Key := '';
    while not AtEnd and not CharInSet(Peek, [' ', '=', '>', '/', #9, #10, #13]) do
    begin
      Key := Key + Peek;
      Advance;
    end;
    Key := Key.ToLower.Trim;
    if Key = '' then
    begin
      Advance; // avoid infinite loop on unexpected chars
      Continue;
    end;

    SkipWhitespace;

    if not AtEnd and (Peek = '=') then
    begin
      Advance; // skip '='
      SkipWhitespace;
      Value := ReadAttributeValue;
    end
    else
      Value := Key; // standalone attribute like "checked"

    if Key = 'style' then
      ParseStyleAttribute(Value, Tag.Style)
    else
      Tag.Attributes.AddOrSetValue(Key, Value);
  end;
end;

procedure THTMLParser.ParseStyleAttribute(const StyleStr: string; Dict: TDictionary<string, string>);
var
  Pairs: TArray<string>;
  KV: TArray<string>;
begin
  Pairs := StyleStr.Split([';']);
  for var Pair in Pairs do
  begin
    var S := Pair.Trim;
    if S = '' then Continue;
    KV := S.Split([':'], 2);
    if Length(KV) = 2 then
      Dict.AddOrSetValue(KV[0].Trim.ToLower, KV[1].Trim);
  end;
end;

class function THTMLParser.DecodeEntities(const S: string): string;
var
  Builder: TStringBuilder;
  I, J, CodePoint: Integer;
  Entity: string;
begin
  Builder := TStringBuilder.Create(Length(S));
  try
    I := 1;
    while I <= Length(S) do
    begin
      if S[I] = '&' then
      begin
        J := I + 1;
        while (J <= Length(S)) and (S[J] <> ';') and (J - I < 12) do
          Inc(J);
        if (J <= Length(S)) and (S[J] = ';') then
        begin
          Entity := Copy(S, I + 1, J - I - 1).ToLower;
          if Entity = 'amp' then Builder.Append('&')
          else if Entity = 'lt' then Builder.Append('<')
          else if Entity = 'gt' then Builder.Append('>')
          else if Entity = 'nbsp' then Builder.Append(#160)
          else if Entity = 'quot' then Builder.Append('"')
          else if Entity = 'apos' then Builder.Append('''')
          else if Entity = 'copy' then Builder.Append(#169)
          else if Entity = 'reg' then Builder.Append(#174)
          else if Entity = 'trade' then Builder.Append(#8482)
          else if Entity = 'mdash' then Builder.Append(#8212)
          else if Entity = 'ndash' then Builder.Append(#8211)
          else if Entity = 'laquo' then Builder.Append(#171)
          else if Entity = 'raquo' then Builder.Append(#187)
          else if Entity = 'bull' then Builder.Append(#8226)
          else if Entity = 'hellip' then Builder.Append(#8230)
          else if Entity.StartsWith('#x') then
          begin
            if TryStrToInt('$' + Entity.Substring(2), CodePoint) and (CodePoint > 0) then
              Builder.Append(Char(CodePoint))
            else
              Builder.Append(Copy(S, I, J - I + 1));
          end
          else if Entity.StartsWith('#') then
          begin
            if TryStrToInt(Entity.Substring(1), CodePoint) and (CodePoint > 0) then
              Builder.Append(Char(CodePoint))
            else
              Builder.Append(Copy(S, I, J - I + 1));
          end
          else
            Builder.Append(Copy(S, I, J - I + 1));
          I := J + 1;
          Continue;
        end;
      end;
      Builder.Append(S[I]);
      Inc(I);
    end;
    Result := Builder.ToString;
  finally
    Builder.Free;
  end;
end;

class function THTMLParser.IsVoidTag(const Name: string): Boolean;
begin
  Result := SameText(Name, 'br') or SameText(Name, 'hr') or
    SameText(Name, 'img') or SameText(Name, 'input') or
    SameText(Name, 'meta') or SameText(Name, 'link') or
    SameText(Name, 'col') or SameText(Name, 'area') or
    SameText(Name, 'base') or SameText(Name, 'embed') or
    SameText(Name, 'source') or SameText(Name, 'track') or
    SameText(Name, 'wbr');
end;

class function THTMLParser.IsBlockTag(const Name: string): Boolean;
begin
  Result := SameText(Name, 'html') or SameText(Name, 'body') or
    SameText(Name, 'div') or SameText(Name, 'p') or
    SameText(Name, 'h1') or SameText(Name, 'h2') or SameText(Name, 'h3') or
    SameText(Name, 'h4') or SameText(Name, 'h5') or SameText(Name, 'h6') or
    SameText(Name, 'blockquote') or SameText(Name, 'pre') or
    SameText(Name, 'hr') or SameText(Name, 'ul') or SameText(Name, 'ol') or
    SameText(Name, 'li') or SameText(Name, 'table') or
    SameText(Name, 'thead') or SameText(Name, 'tbody') or SameText(Name, 'tfoot') or
    SameText(Name, 'tr') or SameText(Name, 'form') or
    SameText(Name, 'section') or SameText(Name, 'article') or
    SameText(Name, 'nav') or SameText(Name, 'header') or
    SameText(Name, 'footer') or SameText(Name, 'main') or
    SameText(Name, 'aside') or SameText(Name, 'figure') or
    SameText(Name, 'figcaption') or SameText(Name, 'dl') or
    SameText(Name, 'dt') or SameText(Name, 'dd') or
    SameText(Name, 'details') or SameText(Name, 'summary') or
    SameText(Name, 'address');
end;

class function THTMLParser.IsRawTag(const Name: string): Boolean;
begin
  Result := SameText(Name, 'script') or SameText(Name, 'style');
end;

class function THTMLParser.IsIgnoredTag(const Name: string): Boolean;
begin
  Result := SameText(Name, 'head') or SameText(Name, 'meta') or
    SameText(Name, 'title');
end;

procedure THTMLParser.ParseChildren(Parent: THTMLTag; const StopTag: string);
var
  TextBuf: TStringBuilder;
  TagName: string;
  ChildTag: THTMLTag;
  SelfClose: Boolean;
  OldInPre: Boolean;
begin
  TextBuf := TStringBuilder.Create;
  try
    while not AtEnd do
    begin
      // Check for tags
      if Peek = '<' then
      begin
        // Flush accumulated text
        if TextBuf.Length > 0 then
        begin
          var RawText := TextBuf.ToString;
          TextBuf.Clear;
          var DecodedText := DecodeEntities(RawText);
          // Collapse whitespace unless in <pre>
          if not FInPre then
          begin
            var Collapsed := '';
            var LastWasSpace := False;
            for var C in DecodedText do
            begin
              if CharInSet(C, [' ', #9, #10, #13]) then
              begin
                if not LastWasSpace then
                  Collapsed := Collapsed + ' ';
                LastWasSpace := True;
              end
              else
              begin
                Collapsed := Collapsed + C;
                LastWasSpace := False;
              end;
            end;
            DecodedText := Collapsed;
          end;
          if DecodedText <> '' then
          begin
            var TextNode := THTMLTag.Create;
            TextNode.TagName := '#text';
            TextNode.Text := DecodedText;
            TextNode.Parent := Parent;
            Parent.Children.Add(TextNode);
          end;
        end;

        // Comment?
        if (PeekAt(1) = '!') and (PeekAt(2) = '-') and (PeekAt(3) = '-') then
        begin
          SkipComment;
          Continue;
        end;

        // DOCTYPE?
        if (PeekAt(1) = '!') then
        begin
          SkipDoctype;
          Continue;
        end;

        // Closing tag?
        if PeekAt(1) = '/' then
        begin
          Advance(2); // skip '</'
          TagName := ReadTagName;
          // Skip to '>'
          while not AtEnd and (Peek <> '>') do
            Advance;
          if not AtEnd then
            Advance; // skip '>'
          if (StopTag <> '') and SameText(TagName, StopTag) then
            Exit;
          // Mismatched close tag — skip
          Continue;
        end;

        // Opening tag
        Advance; // skip '<'
        TagName := ReadTagName;
        if TagName = '' then
          Continue;

        // Parse attributes
        ChildTag := THTMLTag.Create;
        ChildTag.TagName := TagName;
        ChildTag.Parent := Parent;
        ParseAttributes(ChildTag);

        // Check for self-closing '/>'
        SelfClose := False;
        if not AtEnd and (Peek = '/') then
        begin
          Advance;
          SelfClose := True;
        end;
        if not AtEnd and (Peek = '>') then
          Advance; // skip '>'

        // <style> — capture CSS content
        if SameText(TagName, 'style') and not SelfClose then
        begin
          var CSSContent := ReadRawContent(TagName);
          FStyleBlocks.Add(CSSContent);
          ChildTag.Free;
          Continue;
        end;

        // <script> — skip content
        if SameText(TagName, 'script') and not SelfClose then
        begin
          SkipRawContent(TagName);
          ChildTag.Free;
          Continue;
        end;

        // <link rel="stylesheet" href="..."> — capture href
        if SameText(TagName, 'link') then
        begin
          var Rel := ChildTag.GetAttribute('rel', '').ToLower;
          var Href := ChildTag.GetAttribute('href', '');
          if (Rel = 'stylesheet') and (Href <> '') then
            FLinkHrefs.Add(Href);
          ChildTag.Free;
          Continue;
        end;

        // Other ignored tags (head, meta, title)
        if IsIgnoredTag(TagName) then
        begin
          ChildTag.Free;
          Continue;
        end;

        Parent.Children.Add(ChildTag);

        // Void or self-closing — no children
        if IsVoidTag(TagName) or SelfClose then
          Continue;

        // Recurse children
        OldInPre := FInPre;
        if SameText(TagName, 'pre') then
          FInPre := True;
        ParseChildren(ChildTag, TagName);
        FInPre := OldInPre;
      end
      else
      begin
        TextBuf.Append(Peek);
        Advance;
      end;
    end;

    // Flush remaining text
    if TextBuf.Length > 0 then
    begin
      var RawText := TextBuf.ToString;
      var DecodedText := DecodeEntities(RawText);
      if not FInPre then
      begin
        var Collapsed := '';
        var LastWasSpace := False;
        for var C in DecodedText do
        begin
          if CharInSet(C, [' ', #9, #10, #13]) then
          begin
            if not LastWasSpace then
              Collapsed := Collapsed + ' ';
            LastWasSpace := True;
          end
          else
          begin
            Collapsed := Collapsed + C;
            LastWasSpace := False;
          end;
        end;
        DecodedText := Collapsed;
      end;
      if DecodedText <> '' then
      begin
        var TextNode := THTMLTag.Create;
        TextNode.TagName := '#text';
        TextNode.Text := DecodedText;
        TextNode.Parent := Parent;
        Parent.Children.Add(TextNode);
      end;
    end;
  finally
    TextBuf.Free;
  end;
end;

procedure THTMLParser.Parse(const HTML: string);
begin
  // Clear old tree
  for var Child in FRoot.Children do
    Child.Free;
  FRoot.Children.Clear;
  FStyleBlocks.Clear;
  FLinkHrefs.Clear;

  FHTML := HTML;
  FLen := Length(FHTML);
  FPos := 1;
  FInPre := False;

  if FLen = 0 then Exit;

  ParseChildren(FRoot);
end;

// ═══════════════════════════════════════════════════════════════════════════
// TEdgeValues
// ═══════════════════════════════════════════════════════════════════════════

procedure TEdgeValues.Clear;
begin
  Top := 0; Right := 0; Bottom := 0; Left := 0;
end;

procedure TEdgeValues.SetAll(V: Single);
begin
  Top := V; Right := V; Bottom := V; Left := V;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TComputedStyle
// ═══════════════════════════════════════════════════════════════════════════

class function TComputedStyle.Default: TComputedStyle;
begin
  Result.FontFamily := 'Segoe UI';
  Result.FontSize := 14;
  Result.Bold := False;
  Result.Italic := False;
  Result.Color := TAlphaColors.Black;
  Result.BackgroundColor := TAlphaColors.Null;
  Result.TextDecoration := 'none';
  Result.TextAlign := TTextAlign.Leading;
  Result.LineHeight := 1.4;
  Result.VerticalAlign := 'baseline';
  Result.Margin.Clear;
  Result.Padding.Clear;
  Result.BorderColor := TAlphaColors.Black;
  Result.BorderWidth := 0;
  Result.ExplicitWidth := -1;
  Result.ExplicitHeight := -1;
  Result.Display := 'block';
  Result.WhiteSpace := 'normal';
  Result.BoxSizing := 'content-box';
end;

class function TComputedStyle.ParseColor(const S: string): TAlphaColor;
var
  Str: string;
  R, G, B, A: Byte;
  Rec: TAlphaColorRec;
  Parts: TArray<string>;
begin
  Result := TAlphaColors.Black;
  Str := S.Trim.ToLower;
  if Str = '' then Exit;

  // Named colors
  if Str = 'red' then Exit(TAlphaColors.Red);
  if Str = 'blue' then Exit(TAlphaColors.Blue);
  if Str = 'green' then Exit(TAlphaColors.Green);
  if Str = 'black' then Exit(TAlphaColors.Black);
  if Str = 'white' then Exit(TAlphaColors.White);
  if Str = 'gray' then Exit(TAlphaColors.Gray);
  if Str = 'grey' then Exit(TAlphaColors.Gray);
  if Str = 'silver' then Exit(TAlphaColors.Silver);
  if Str = 'maroon' then Exit($FF800000);
  if Str = 'navy' then Exit($FF000080);
  if Str = 'olive' then Exit($FF808000);
  if Str = 'teal' then Exit($FF008080);
  if Str = 'purple' then Exit($FF800080);
  if Str = 'fuchsia' then Exit(TAlphaColors.Fuchsia);
  if Str = 'aqua' then Exit(TAlphaColors.Aqua);
  if Str = 'lime' then Exit(TAlphaColors.Lime);
  if Str = 'orange' then Exit(TAlphaColors.Orange);
  if Str = 'yellow' then Exit(TAlphaColors.Yellow);
  if Str = 'pink' then Exit($FFFFC0CB);
  if Str = 'brown' then Exit($FFA52A2A);
  if Str = 'cyan' then Exit(TAlphaColors.Cyan);
  if Str = 'magenta' then Exit(TAlphaColors.Magenta);
  if Str = 'lightgray' then Exit(TAlphaColors.Lightgray);
  if Str = 'lightgrey' then Exit(TAlphaColors.Lightgray);
  if Str = 'darkgray' then Exit(TAlphaColors.Darkgray);
  if Str = 'darkgrey' then Exit(TAlphaColors.Darkgray);
  if Str = 'transparent' then Exit(TAlphaColors.Null);

  // #RGB or #RRGGBB
  if Str.StartsWith('#') then
  begin
    Str := Str.Substring(1);
    if Length(Str) = 3 then
      Str := Str[1] + Str[1] + Str[2] + Str[2] + Str[3] + Str[3];
    if Length(Str) = 6 then
    begin
      try
        R := StrToInt('$' + Str.Substring(0, 2));
        G := StrToInt('$' + Str.Substring(2, 2));
        B := StrToInt('$' + Str.Substring(4, 2));
        Rec.A := 255;
        Rec.R := R;
        Rec.G := G;
        Rec.B := B;
        Result := TAlphaColor(Rec);
      except
      end;
    end;
    Exit;
  end;

  // rgb(r, g, b) or rgba(r, g, b, a)
  if Str.StartsWith('rgb') then
  begin
    var Inner := Str;
    Inner := Inner.Replace('rgba(', '').Replace('rgb(', '').Replace(')', '');
    Parts := Inner.Split([',']);
    if Length(Parts) >= 3 then
    begin
      try
        R := StrToInt(Parts[0].Trim);
        G := StrToInt(Parts[1].Trim);
        B := StrToInt(Parts[2].Trim);
        if Length(Parts) >= 4 then
          A := Round(StrToFloat(Parts[3].Trim) * 255)
        else
          A := 255;
        Rec.A := A;
        Rec.R := R;
        Rec.G := G;
        Rec.B := B;
        Result := TAlphaColor(Rec);
      except
      end;
    end;
  end;
end;

class function TComputedStyle.ParseLength(const S: string; EmSize: Single): Single;
var
  Str: string;
  CalcInner: string;
  Terms: TArray<string>;
  Term: string;
  I: Integer;
begin
  Str := S.Trim.ToLower;
  if Str = '' then Exit(0);
  if Str = 'auto' then Exit(-1);

  // Handle calc() — sum all terms with units we support (rem, em, px, pt),
  // ignore viewport-relative units (vw, vh, vmin, vmax) we can't resolve.
  if Str.StartsWith('calc(') and Str.EndsWith(')') then
  begin
    CalcInner := Copy(Str, 6, Length(Str) - 6).Trim;
    // Normalize: replace '-' with '+-' so we can split on '+'
    CalcInner := CalcInner.Replace(' - ', ' + -');
    Terms := CalcInner.Split(['+']);
    Result := 0;
    for I := 0 to High(Terms) do
    begin
      Term := Terms[I].Trim;
      if Term = '' then Continue;
      // Skip viewport-relative units and percentages we can't resolve in calc
      if Term.EndsWith('vw') or Term.EndsWith('vh') or
         Term.EndsWith('vmin') or Term.EndsWith('vmax') or
         Term.EndsWith('%') then
        Continue;
      // Recursively parse each supported term
      Result := Result + ParseLength(Term, EmSize);
    end;
    Exit;
  end;

  if Str.EndsWith('rem') then
  begin
    // rem = root em; approximate as 16px base (since we don't track root font size)
    Result := StrToFloatDef(Str.Replace('rem', ''), 0) * 16;
  end
  else if Str.EndsWith('em') then
  begin
    Result := StrToFloatDef(Str.Replace('em', ''), 0) * EmSize;
  end
  else if Str.EndsWith('px') then
  begin
    Result := StrToFloatDef(Str.Replace('px', ''), 0);
  end
  else if Str.EndsWith('pt') then
  begin
    Result := StrToFloatDef(Str.Replace('pt', ''), 0) * 1.333;
  end
  else if Str.EndsWith('%') then
  begin
    // Percentage — return negative value as marker
    Result := -StrToFloatDef(Str.Replace('%', ''), 0);
  end
  else
    Result := StrToFloatDef(Str, 0);
end;

class procedure TComputedStyle.ParseEdgeShorthand(const S: string; var E: TEdgeValues; EmSize: Single);
var
  Parts: TArray<string>;
begin
  Parts := S.Trim.Split([' ']);
  case Length(Parts) of
    1: E.SetAll(ParseLength(Parts[0], EmSize));
    2: begin
         E.Top := ParseLength(Parts[0], EmSize);
         E.Bottom := E.Top;
         E.Right := ParseLength(Parts[1], EmSize);
         E.Left := E.Right;
       end;
    3: begin
         E.Top := ParseLength(Parts[0], EmSize);
         E.Right := ParseLength(Parts[1], EmSize);
         E.Left := E.Right;
         E.Bottom := ParseLength(Parts[2], EmSize);
       end;
  else
    if Length(Parts) >= 4 then
    begin
      E.Top := ParseLength(Parts[0], EmSize);
      E.Right := ParseLength(Parts[1], EmSize);
      E.Bottom := ParseLength(Parts[2], EmSize);
      E.Left := ParseLength(Parts[3], EmSize);
    end;
  end;
end;

class function TComputedStyle.ForTag(Tag: THTMLTag; const ParentStyle: TComputedStyle; StyleSheet: TCSSStyleSheet): TComputedStyle;
var
  TN, Temp: string;
  Level: Integer;
begin
  // Inherit from parent
  Result.FontFamily := ParentStyle.FontFamily;
  Result.FontSize := ParentStyle.FontSize;
  Result.Bold := ParentStyle.Bold;
  Result.Italic := ParentStyle.Italic;
  Result.Color := ParentStyle.Color;
  Result.TextAlign := ParentStyle.TextAlign;
  Result.LineHeight := ParentStyle.LineHeight;
  Result.WhiteSpace := ParentStyle.WhiteSpace;
  Result.VerticalAlign := 'baseline';

  // Non-inherited defaults
  Result.BackgroundColor := TAlphaColors.Null;
  Result.TextDecoration := 'none';
  Result.Margin.Clear;
  Result.Padding.Clear;
  Result.BorderColor := TAlphaColors.Black;
  Result.BorderWidth := 0;
  Result.ExplicitWidth := -1;
  Result.ExplicitHeight := -1;
  Result.Display := 'inline';
  Result.BoxSizing := 'content-box';

  if Tag = nil then Exit;
  TN := Tag.TagName.ToLower;

  // Text node — pure inline
  if TN = '#text' then
  begin
    Result.Display := 'inline';
    Exit;
  end;

  // User-agent defaults per tag
  if THTMLParser.IsBlockTag(TN) then
    Result.Display := 'block';

  // Headings
  if (Length(TN) = 2) and (TN[1] = 'h') and CharInSet(TN[2], ['1'..'6']) then
  begin
    Level := Ord(TN[2]) - Ord('0');
    case Level of
      1: Result.FontSize := 32;
      2: Result.FontSize := 24;
      3: Result.FontSize := 19;
      4: Result.FontSize := 16;
      5: Result.FontSize := 13;
      6: Result.FontSize := 11;
    end;
    Result.Bold := True;
    Result.Margin.Top := Result.FontSize * 0.67;
    Result.Margin.Bottom := Result.FontSize * 0.67;
  end
  else if TN = 'p' then
  begin
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
  end
  else if TN = 'blockquote' then
  begin
    Result.Margin.Top := ParentStyle.FontSize;
    Result.Margin.Bottom := ParentStyle.FontSize;
    Result.Margin.Left := 40;
    Result.Padding.Left := 10;
    Result.BorderWidth := 3;
    Result.BorderColor := TAlphaColors.Lightgray;
  end
  else if TN = 'pre' then
  begin
    Result.FontFamily := 'Courier New';
    Result.BackgroundColor := $FFF5F5F5;
    Result.Padding.SetAll(8);
    Result.WhiteSpace := 'pre';
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
  end
  else if TN = 'code' then
  begin
    Result.FontFamily := 'Courier New';
    Result.BackgroundColor := $FFF0F0F0;
    Result.Padding.Left := 3;
    Result.Padding.Right := 3;
  end
  else if (TN = 'b') or (TN = 'strong') then
    Result.Bold := True
  else if (TN = 'i') or (TN = 'em') then
    Result.Italic := True
  else if TN = 'u' then
    Result.TextDecoration := 'underline'
  else if (TN = 'del') or (TN = 's') then
    Result.TextDecoration := 'line-through'
  else if TN = 'a' then
  begin
    Result.Color := $FF0066CC;
    Result.TextDecoration := 'underline';
  end
  else if TN = 'mark' then
    Result.BackgroundColor := $FFFFFF00
  else if TN = 'small' then
    Result.FontSize := ParentStyle.FontSize * 0.85
  else if TN = 'sub' then
    Result.FontSize := ParentStyle.FontSize * 0.75
  else if TN = 'sup' then
    Result.FontSize := ParentStyle.FontSize * 0.75
  else if TN = 'ul' then
  begin
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
    Result.Padding.Left := 24;
  end
  else if TN = 'ol' then
  begin
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
    Result.Padding.Left := 24;
  end
  else if TN = 'li' then
  begin
    Result.Display := 'list-item';
    Result.Margin.Top := 2;
    Result.Margin.Bottom := 2;
  end
  else if TN = 'table' then
  begin
    Result.Display := 'table';
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
  end
  else if TN = 'tr' then
    Result.Display := 'table-row'
  else if (TN = 'td') then
  begin
    Result.Display := 'table-cell';
    Result.Padding.SetAll(4);
  end
  else if (TN = 'th') then
  begin
    Result.Display := 'table-cell';
    Result.Bold := True;
    Result.TextAlign := TTextAlign.Center;
    Result.Padding.SetAll(4);
  end
  else if (TN = 'thead') or (TN = 'tbody') or (TN = 'tfoot') then
    Result.Display := 'table-row'  // group — treated as pass-through
  else if TN = 'hr' then
  begin
    Result.Margin.Top := 8;
    Result.Margin.Bottom := 8;
  end
  else if TN = 'br' then
    Result.Display := 'inline'
  else if TN = 'img' then
    Result.Display := 'inline'
  else if (TN = 'input') or (TN = 'button') or (TN = 'textarea') or (TN = 'select') then
    Result.Display := 'inline'
  else if TN = 'dt' then
    Result.Bold := True
  else if TN = 'dd' then
    Result.Margin.Left := 40;

  // HTML attribute overrides
  if Tag.HasAttribute('width') then
    Result.ExplicitWidth := ParseLength(Tag.GetAttribute('width'), Result.FontSize);
  if Tag.HasAttribute('height') then
    Result.ExplicitHeight := ParseLength(Tag.GetAttribute('height'), Result.FontSize);
  if Tag.HasAttribute('bgcolor') then
    Result.BackgroundColor := ParseColor(Tag.GetAttribute('bgcolor'));
  if Tag.HasAttribute('align') then
  begin
    Temp := Tag.GetAttribute('align').ToLower;
    if Temp = 'center' then Result.TextAlign := TTextAlign.Center
    else if Temp = 'right' then Result.TextAlign := TTextAlign.Trailing;
  end;
  if Tag.HasAttribute('border') then
  begin
    Result.BorderWidth := StrToFloatDef(Tag.GetAttribute('border'), 0);
    if Result.BorderWidth > 0 then
      Result.BorderColor := TAlphaColors.Black;
  end;

  // Stylesheet rules (lower priority than inline)
  if Assigned(StyleSheet) then
  begin
    var CSSDecls := TCSSDeclarations.Create;
    try
      StyleSheet.ApplyTo(Tag, CSSDecls);
      if CSSDecls.Count > 0 then
        ApplyDeclarations(CSSDecls, Result, ParentStyle);
    finally
      CSSDecls.Free;
    end;
  end;

  // Inline style overrides (highest priority)
  if Tag.Style.Count > 0 then
    ApplyDeclarations(Tag.Style, Result, ParentStyle);
end;

class procedure TComputedStyle.ApplyDeclarations(Decls: TCSSDeclarations; var Style: TComputedStyle; const ParentStyle: TComputedStyle);
var
  Temp: string;
begin
  if Decls.TryGetValue('color', Temp) then
    Style.Color := ParseColor(Temp);
  if Decls.TryGetValue('background-color', Temp) then
    Style.BackgroundColor := ParseColor(Temp);
  if Decls.TryGetValue('background', Temp) then
  begin
    if not Temp.Contains('url') then
      Style.BackgroundColor := ParseColor(Temp);
  end;
  if Decls.TryGetValue('font-family', Temp) then
    Style.FontFamily := Temp.DeQuotedString('''').DeQuotedString('"');
  if Decls.TryGetValue('font-size', Temp) then
    Style.FontSize := ParseLength(Temp, ParentStyle.FontSize);
  if Decls.TryGetValue('font-weight', Temp) then
    Style.Bold := SameText(Temp, 'bold') or SameText(Temp, 'bolder') or
      (StrToIntDef(Temp, 400) >= 500);
  if Decls.TryGetValue('font-style', Temp) then
    Style.Italic := SameText(Temp, 'italic') or SameText(Temp, 'oblique');
  if Decls.TryGetValue('text-decoration', Temp) then
    Style.TextDecoration := Temp.ToLower;
  if Decls.TryGetValue('text-align', Temp) then
  begin
    Temp := Temp.ToLower;
    if Temp = 'center' then Style.TextAlign := TTextAlign.Center
    else if Temp = 'right' then Style.TextAlign := TTextAlign.Trailing
    else if Temp = 'justify' then Style.TextAlign := TTextAlign.Leading
    else Style.TextAlign := TTextAlign.Leading;
  end;
  if Decls.TryGetValue('line-height', Temp) then
  begin
    var LH := StrToFloatDef(Temp.Replace('px', '').Replace('em', ''), 0);
    if LH > 0 then
    begin
      if Temp.Contains('px') then
        Style.LineHeight := LH / Style.FontSize
      else
        Style.LineHeight := LH;
    end;
  end;
  if Decls.TryGetValue('margin', Temp) then
    ParseEdgeShorthand(Temp, Style.Margin, Style.FontSize);
  if Decls.TryGetValue('margin-top', Temp) then
    Style.Margin.Top := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-right', Temp) then
    Style.Margin.Right := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-bottom', Temp) then
    Style.Margin.Bottom := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-left', Temp) then
    Style.Margin.Left := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding', Temp) then
    ParseEdgeShorthand(Temp, Style.Padding, Style.FontSize);
  if Decls.TryGetValue('padding-top', Temp) then
    Style.Padding.Top := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-right', Temp) then
    Style.Padding.Right := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-bottom', Temp) then
    Style.Padding.Bottom := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-left', Temp) then
    Style.Padding.Left := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('border', Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
      begin
        Style.BorderWidth := 0;
      end
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.BorderWidth := StrToFloatDef(BT.Replace('px', ''), 1)
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style — we only support solid rendering
      else
        Style.BorderColor := ParseColor(BT);
    end;
  end;
  if Decls.TryGetValue('border-color', Temp) then
    Style.BorderColor := ParseColor(Temp);
  if Decls.TryGetValue('border-width', Temp) then
    Style.BorderWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('width', Temp) then
    Style.ExplicitWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('height', Temp) then
    Style.ExplicitHeight := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('display', Temp) then
    Style.Display := Temp.ToLower;
  if Decls.TryGetValue('vertical-align', Temp) then
    Style.VerticalAlign := Temp.ToLower;
  if Decls.TryGetValue('white-space', Temp) then
    Style.WhiteSpace := Temp.ToLower;
  if Decls.TryGetValue('box-sizing', Temp) then
    Style.BoxSizing := Temp.ToLower;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TLayoutBox
// ═══════════════════════════════════════════════════════════════════════════

constructor TLayoutBox.Create(ATag: THTMLTag; AKind: TLayoutBoxKind);
begin
  inherited Create;
  Tag := ATag;
  Kind := AKind;
  Children := TObjectList<TLayoutBox>.Create(True);
  Fragments := TList<TTextFragment>.Create;
  ListIndex := 0;
  IsOrdered := False;
end;

destructor TLayoutBox.Destroy;
begin
  Fragments.Free;
  Children.Free;
  inherited;
end;

function ResolveAutoMargin(V: Single): Single; inline;
begin
  // -1 is sentinel for 'auto', treat as 0 in layout calculations
  if (V >= -1.01) and (V <= -0.99) then
    Result := 0
  else
    Result := V;
end;

function TLayoutBox.MarginBoxWidth: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Left) + Style.BorderWidth + Style.Padding.Left +
    ContentWidth + Style.Padding.Right + Style.BorderWidth + ResolveAutoMargin(Style.Margin.Right);
end;

function TLayoutBox.MarginBoxHeight: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Top) + Style.BorderWidth + Style.Padding.Top +
    ContentHeight + Style.Padding.Bottom + Style.BorderWidth + ResolveAutoMargin(Style.Margin.Bottom);
end;

function TLayoutBox.ContentLeft: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Left) + Style.BorderWidth + Style.Padding.Left;
end;

function TLayoutBox.ContentTop: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Top) + Style.BorderWidth + Style.Padding.Top;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TImageCache
// ═══════════════════════════════════════════════════════════════════════════

constructor TImageCache.Create;
begin
  inherited;
  FCache := TDictionary<string, TBitmap>.Create;
  FPending := TDictionary<string, Boolean>.Create;
  FDestroying := False;
end;

destructor TImageCache.Destroy;
begin
  FDestroying := True;
  for var Pair in FCache do
    Pair.Value.Free;
  FCache.Free;
  FPending.Free;
  inherited;
end;

function TImageCache.GetImage(const Src: string): TBitmap;
begin
  if FCache.TryGetValue(Src, Result) then
    Exit;
  Result := nil;
end;

procedure TImageCache.RequestImage(const Src: string);
begin
  if FCache.ContainsKey(Src) or FPending.ContainsKey(Src) then
    Exit;

  // Base64 data URI
  if Src.ToLower.StartsWith('data:image') then
  begin
    var CommaPos := Src.IndexOf(',');
    if CommaPos > 0 then
    begin
      var B64 := Src.Substring(CommaPos + 1);
      var Bytes := TNetEncoding.Base64.DecodeStringToBytes(B64);
      var Stream := TBytesStream.Create(Bytes);
      try
        var Bmp := TBitmap.Create;
        try
          Bmp.LoadFromStream(Stream);
          FCache.AddOrSetValue(Src, Bmp);
        except
          Bmp.Free;
        end;
      finally
        Stream.Free;
      end;
    end;
    Exit;
  end;

  // File path
  if FileExists(Src) then
  begin
    var Bmp := TBitmap.Create;
    try
      Bmp.LoadFromFile(Src);
      FCache.AddOrSetValue(Src, Bmp);
    except
      Bmp.Free;
    end;
    Exit;
  end;

  // HTTP URL — check disk cache then async load
  if Src.ToLower.StartsWith('http') then
  begin
    // Check disk cache first (synchronous, fast)
    if Assigned(FFileCache) and FFileCache.Enabled then
    begin
      var CachedBytes: TBytes;
      if FFileCache.TryLoadBytes(Src, CachedBytes) then
      begin
        var CacheStream := TBytesStream.Create(CachedBytes);
        try
          var Bmp := TBitmap.Create;
          try
            Bmp.LoadFromStream(CacheStream);
            FCache.AddOrSetValue(Src, Bmp);
          except
            Bmp.Free;
          end;
        finally
          CacheStream.Free;
        end;
        Exit;
      end;
    end;

    // Not in disk cache — fetch via HTTP asynchronously
    FPending.AddOrSetValue(Src, True);
    var URL := Src;
    var Cache := Self;
    TThread.CreateAnonymousThread(procedure
    var
      Client: THTTPClient;
      Response: IHTTPResponse;
      Stream: TMemoryStream;
    begin
      Client := THTTPClient.Create;
      Stream := TMemoryStream.Create;
      try
        try
          Response := Client.Get(URL, Stream);
          if Response.StatusCode = 200 then
          begin
            // Save to disk cache from background thread
            if Assigned(Cache.FFileCache) and Cache.FFileCache.Enabled then
            begin
              Stream.Position := 0;
              var FileBytes: TBytes;
              SetLength(FileBytes, Stream.Size);
              if Stream.Size > 0 then
                Stream.ReadBuffer(FileBytes[0], Stream.Size);
              Cache.FFileCache.SaveBytes(URL, FileBytes);
            end;

            Stream.Position := 0;
            TThread.Synchronize(nil, procedure
            begin
              if Cache.FDestroying then Exit;
              var Bmp := TBitmap.Create;
              try
                Bmp.LoadFromStream(Stream);
                Cache.FCache.AddOrSetValue(URL, Bmp);
              except
                Bmp.Free;
              end;
              Cache.FPending.Remove(URL);
              if Assigned(Cache.FOnImageLoaded) then
                Cache.FOnImageLoaded(Cache);
            end);
          end;
        except
          // Silently fail on network errors
        end;
      finally
        Client.Free;
        Stream.Free;
      end;
    end).Start;
  end;
end;

procedure TImageCache.Clear;
begin
  for var Pair in FCache do
    Pair.Value.Free;
  FCache.Clear;
  FPending.Clear;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TLayoutEngine
// ═══════════════════════════════════════════════════════════════════════════

constructor TLayoutEngine.Create(AImageCache: TImageCache);
begin
  inherited Create;
  FImageCache := AImageCache;
  FRoot := nil;
end;

destructor TLayoutEngine.Destroy;
begin
  FRoot.Free;
  inherited;
end;

function TLayoutEngine.GetLineHeight(const Style: TComputedStyle): Single;
begin
  Result := Style.FontSize * Style.LineHeight;
end;

function TLayoutEngine.MeasureTextWidth(const Text: string; const Style: TComputedStyle): Single;
var
  Layout: TTextLayout;
begin
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    Layout.Text := Text;
    Layout.Font.Family := Style.FontFamily;
    Layout.Font.Size := Style.FontSize;
    Layout.Font.Style := [];
    if Style.Bold then Layout.Font.Style := Layout.Font.Style + [TFontStyle.fsBold];
    if Style.Italic then Layout.Font.Style := Layout.Font.Style + [TFontStyle.fsItalic];
    Layout.WordWrap := False;
    Layout.MaxSize := PointF(10000, 10000);
    Layout.EndUpdate;
    Result := Layout.Width;
  finally
    Layout.Free;
  end;
end;

function TLayoutEngine.MeasureTextHeight(const Text: string; const Style: TComputedStyle; MaxWidth: Single): Single;
var
  Layout: TTextLayout;
begin
  if MaxWidth <= 0 then MaxWidth := 10000;
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    Layout.Text := Text;
    Layout.Font.Family := Style.FontFamily;
    Layout.Font.Size := Style.FontSize;
    Layout.Font.Style := [];
    if Style.Bold then Layout.Font.Style := Layout.Font.Style + [TFontStyle.fsBold];
    if Style.Italic then Layout.Font.Style := Layout.Font.Style + [TFontStyle.fsItalic];
    Layout.WordWrap := True;
    Layout.MaxSize := PointF(MaxWidth, 100000);
    Layout.EndUpdate;
    Result := Layout.Height;
  finally
    Layout.Free;
  end;
end;

function TLayoutEngine.BuildBoxTree(Tag: THTMLTag; const ParentStyle: TComputedStyle): TLayoutBox;
var
  Style: TComputedStyle;
  Kind: TLayoutBoxKind;
  ChildBox: TLayoutBox;
begin
  Style := TComputedStyle.ForTag(Tag, ParentStyle, FStyleSheet);

  if Style.Display = 'none' then
    Exit(nil);

  // Determine box kind
  if Tag.TagName = '#text' then
    Kind := lbkText
  else if SameText(Tag.TagName, 'br') then
    Kind := lbkBR
  else if SameText(Tag.TagName, 'hr') then
    Kind := lbkHR
  else if SameText(Tag.TagName, 'img') then
    Kind := lbkImage
  else if SameText(Tag.TagName, 'input') or SameText(Tag.TagName, 'button') or
          SameText(Tag.TagName, 'textarea') or SameText(Tag.TagName, 'select') then
  begin
    // Form controls with display:block are treated as block-level form controls,
    // except checkbox and radio which are always small inline elements.
    var InputT := Tag.GetAttribute('type', 'text').ToLower;
    if (Style.Display = 'block') and (InputT <> 'checkbox') and (InputT <> 'radio') then
      Kind := lbkBlock
    else
      Kind := lbkFormControl;
  end
  else if Style.Display = 'table' then
    Kind := lbkTable
  else if Style.Display = 'table-row' then
    Kind := lbkTableRow
  else if Style.Display = 'table-cell' then
    Kind := lbkTableCell
  else if Style.Display = 'list-item' then
    Kind := lbkListItem
  else if Style.Display = 'block' then
    Kind := lbkBlock
  else
    Kind := lbkInline;

  Result := TLayoutBox.Create(Tag, Kind);
  Result.Style := Style;

  // Build children
  if Tag.TagName <> '#text' then
  begin
    var ListIdx := 0;
    var IsOL := SameText(Tag.TagName, 'ol');
    for var Child in Tag.Children do
    begin
      ChildBox := BuildBoxTree(Child, Style);
      if Assigned(ChildBox) then
      begin
        if ChildBox.Kind = lbkListItem then
        begin
          Inc(ListIdx);
          ChildBox.ListIndex := ListIdx;
          ChildBox.IsOrdered := IsOL;
        end;
        Result.Children.Add(ChildBox);
      end;
    end;
  end;

  // Request images
  if Kind = lbkImage then
  begin
    var Src := Tag.GetAttribute('src');
    if (Src <> '') and Assigned(FImageCache) then
      FImageCache.RequestImage(Src);
  end;
end;

function IsPercentageValue(Value: Single): Boolean; inline;
begin
  // Percentages are stored as negative values < -1 (e.g., -100 = 100%, -50 = 50%)
  // The sentinel -1 means 'auto' / unset, so only values below -1 are percentages
  Result := Value < -1.01;
end;

function ResolvePercentage(Value, Reference: Single): Single;
begin
  if IsPercentageValue(Value) then
    Result := (-Value / 100) * Reference
  else
    Result := Value;
end;

// Resolve 'auto' margins (-1 sentinel) to 0 for layout calculations
function ResolveMargin(Value: Single): Single; inline;
begin
  // -1 is sentinel for 'auto', treat as 0; real negative margins are kept
  if (Value >= -1.01) and (Value <= -0.99) then
    Result := 0
  else
    Result := Value;
end;

procedure TLayoutEngine.LayoutBlock(Box: TLayoutBox; AvailWidth: Single);
var
  ContentW, CursorY: Single;
  HasInline: Boolean;
  ExplW: Single;
  MarginL, MarginR: Single;
begin
  // Resolve auto margins to 0 for layout width calculation
  MarginL := ResolveMargin(Box.Style.Margin.Left);
  MarginR := ResolveMargin(Box.Style.Margin.Right);

  // Calculate content width
  ContentW := AvailWidth - MarginL - MarginR -
    Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;

  // Resolve explicit width (may be percentage of available width)
  ExplW := Box.Style.ExplicitWidth;
  if IsPercentageValue(ExplW) then
  begin
    // Percentage: resolve against available width
    ExplW := ResolvePercentage(ExplW, AvailWidth);
    // Percentage widths behave like border-box: value includes padding + border
    ContentW := ExplW - Box.Style.BorderWidth * 2 -
      Box.Style.Padding.Left - Box.Style.Padding.Right;
  end
  else if ExplW > 0 then
  begin
    if SameText(Box.Style.BoxSizing, 'border-box') then
      // border-box: explicit width includes padding and border
      ContentW := ExplW - Box.Style.BorderWidth * 2 -
        Box.Style.Padding.Left - Box.Style.Padding.Right
    else
      // content-box (default): explicit width IS the content width
      ContentW := ExplW;
  end;

  if ContentW < 0 then ContentW := 0;

  Box.ContentWidth := ContentW;
  CursorY := 0;

  // Block-level form controls (e.g. Bootstrap .form-control sets display:block; width:100%)
  // Size them using LayoutFormControl then return — they have no children to lay out.
  // Native FMX controls handle their own borders, so zero out the CSS border to prevent
  // it from inflating the box model (MarginBoxHeight, ContentLeft, etc.).
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or SameText(Box.Tag.TagName, 'button') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
  begin
    Box.Style.BorderWidth := 0;
    // Recalculate content width without border
    ContentW := AvailWidth - MarginL - MarginR -
      Box.Style.Padding.Left - Box.Style.Padding.Right;
    if ContentW < 0 then ContentW := 0;
    LayoutFormControl(Box, ContentW);
    var InputType := '';
    if Assigned(Box.Tag) then
      InputType := Box.Tag.GetAttribute('type', 'text').ToLower;
    if (InputType <> 'checkbox') and (InputType <> 'radio') then
      Box.ContentWidth := ContentW;
    Exit;
  end;

  // Resolve explicit height (may be percentage — but no reference, ignore for now)
  // Percentages on height are complex in CSS; we skip them

  // Determine layout mode: inline vs block
  // When a container has block children, whitespace-only text nodes should be
  // ignored (CSS "inter-element whitespace" rule). Only non-whitespace inline
  // content triggers mixed inline/block layout.
  HasInline := False;
  var HasBlock := False;
  for var Child in Box.Children do
  begin
    case Child.Kind of
      lbkBlock, lbkTable, lbkListItem, lbkHR:
        HasBlock := True;
      lbkImage, lbkFormControl, lbkBR, lbkInline:
        HasInline := True;
      lbkText:
        if Assigned(Child.Tag) and (Child.Tag.Text.Trim <> '') then
          HasInline := True;
    end;
  end;

  // If both block and inline exist, only keep HasInline if there are
  // non-whitespace inline elements (images, form controls, real inline boxes,
  // or non-blank text). Whitespace-only text nodes between block elements
  // are discarded in block formatting context.
  if HasBlock and HasInline then
  begin
    HasInline := False;
    for var Child in Box.Children do
    begin
      if (Child.Kind = lbkImage) or (Child.Kind = lbkFormControl) or
         (Child.Kind = lbkBR) or (Child.Kind = lbkInline) then
      begin
        HasInline := True;
        Break;
      end
      else if (Child.Kind = lbkText) and Assigned(Child.Tag) and
              (Child.Tag.Text.Trim <> '') then
      begin
        HasInline := True;
        Break;
      end;
    end;
  end;

  if HasInline then
  begin
    // Mixed or pure inline content — use inline layout
    LayoutInlineChildren(Box, ContentW);
    // ContentHeight is set by LayoutInlineChildren
  end
  else
  begin
    // Pure block children
    for var Child in Box.Children do
    begin
      case Child.Kind of
        lbkBlock: LayoutBlock(Child, ContentW);
        lbkTable: LayoutTable(Child, ContentW);
        lbkListItem: LayoutListItem(Child, ContentW);
        lbkHR: LayoutHR(Child, ContentW);
      else
        LayoutBlock(Child, ContentW);
      end;
      Child.X := 0;
      Child.Y := CursorY;
      CursorY := CursorY + Child.MarginBoxHeight;
    end;
    Box.ContentHeight := CursorY;
  end;

  if Box.Style.ExplicitHeight > 0 then
  begin
    if SameText(Box.Style.BoxSizing, 'border-box') then
      Box.ContentHeight := Box.Style.ExplicitHeight - Box.Style.BorderWidth * 2 -
        Box.Style.Padding.Top - Box.Style.Padding.Bottom
    else
      Box.ContentHeight := Box.Style.ExplicitHeight;
  end;
end;

procedure TLayoutEngine.LayoutInlineChildren(Box: TLayoutBox; AvailWidth: Single);
var
  CursorX, CursorY, LineH: Single;
  SpaceW: Single;

  procedure ProcessInlineBox(Child: TLayoutBox);
  var
    Words: TArray<string>;
    WordW, WordH: Single;
    Frag: TTextFragment;
  begin
    if Child.Kind = lbkBR then
    begin
      CursorY := CursorY + LineH;
      CursorX := 0;
      LineH := GetLineHeight(Child.Style);
      Exit;
    end;

    if Child.Kind = lbkImage then
    begin
      LayoutImage(Child, AvailWidth);
      var ImgW := Child.ContentWidth + Child.Style.Margin.Left + Child.Style.Margin.Right;
      if (CursorX > 0) and (CursorX + ImgW > AvailWidth) then
      begin
        CursorY := CursorY + LineH;
        CursorX := 0;
        LineH := GetLineHeight(Child.Style);
      end;
      Child.X := CursorX;
      Child.Y := CursorY;
      CursorX := CursorX + ImgW;
      LineH := Max(LineH, Child.MarginBoxHeight);
      Exit;
    end;

    if Child.Kind = lbkFormControl then
    begin
      LayoutFormControl(Child, AvailWidth);
      var CtlW := Child.ContentWidth + Child.Style.Margin.Left + Child.Style.Margin.Right;
      if (CursorX > 0) and (CursorX + CtlW > AvailWidth) then
      begin
        CursorY := CursorY + LineH;
        CursorX := 0;
        LineH := GetLineHeight(Child.Style);
      end;
      Child.X := CursorX;
      Child.Y := CursorY;
      CursorX := CursorX + CtlW;
      LineH := Max(LineH, Child.MarginBoxHeight);
      Exit;
    end;

    if Child.Kind = lbkText then
    begin
      var Text := Child.Tag.Text;
      if Text = '' then Exit;

      // In pre mode, don't word-wrap
      if Child.Style.WhiteSpace = 'pre' then
      begin
        var TextH := MeasureTextHeight(Text, Child.Style, AvailWidth - CursorX);
        Frag.Text := Text;
        Frag.X := 0;  // relative to Child.X
        Frag.Y := 0;  // relative to Child.Y
        Frag.W := AvailWidth - CursorX;
        Frag.H := TextH;
        Child.Fragments.Add(Frag);
        Child.X := CursorX;
        Child.Y := CursorY;
        Child.ContentWidth := AvailWidth - CursorX;
        Child.ContentHeight := TextH;
        CursorY := CursorY + TextH;
        CursorX := 0;
        LineH := GetLineHeight(Child.Style);
        Exit;
      end;

      SpaceW := MeasureTextWidth(' ', Child.Style);
      Words := Text.Split([' ']);
      Child.X := CursorX;
      Child.Y := CursorY;

      var IsFirst := True;
      for var Word in Words do
      begin
        if Word = '' then Continue;

        WordW := MeasureTextWidth(Word, Child.Style);
        WordH := GetLineHeight(Child.Style);

        // Wrap if needed
        if (CursorX > 0) and (CursorX + WordW > AvailWidth) then
        begin
          CursorY := CursorY + LineH;
          CursorX := 0;
          LineH := WordH;
        end;

        Frag.Text := Word;
        Frag.X := CursorX - Child.X;  // relative to text node start
        Frag.Y := CursorY - Child.Y;  // relative to text node start
        Frag.W := WordW;
        Frag.H := WordH;
        Child.Fragments.Add(Frag);

        CursorX := CursorX + WordW + SpaceW;
        LineH := Max(LineH, WordH);
        IsFirst := False;
      end;

      // Calculate child bounds
      if Child.Fragments.Count > 0 then
      begin
        var MinY := Child.Fragments[0].Y;
        var MaxY := Child.Fragments[0].Y + Child.Fragments[0].H;
        for var F in Child.Fragments do
        begin
          MinY := Min(MinY, F.Y);
          MaxY := Max(MaxY, F.Y + F.H);
        end;
        Child.ContentHeight := MaxY - MinY;
        Child.ContentWidth := CursorX - Child.X;
      end;
      Exit;
    end;

    // Block-level child inside inline context — force line break
    if (Child.Kind = lbkBlock) or (Child.Kind = lbkTable) or (Child.Kind = lbkListItem) then
    begin
      if CursorX > 0 then
      begin
        CursorY := CursorY + LineH;
        CursorX := 0;
        LineH := GetLineHeight(Child.Style);
      end;

      case Child.Kind of
        lbkTable: LayoutTable(Child, AvailWidth);
        lbkListItem: LayoutListItem(Child, AvailWidth);
      else
        LayoutBlock(Child, AvailWidth);
      end;
      Child.X := 0;
      Child.Y := CursorY;
      CursorY := CursorY + Child.MarginBoxHeight;
      CursorX := 0;
      LineH := GetLineHeight(Child.Style);
      Exit;
    end;

    // Inline container (span, a, b, i, etc.) — recurse children
    if Child.Kind = lbkInline then
    begin
      // X is the margin-box left edge (PaintBackground adds Margin.Left internally)
      Child.X := CursorX;
      Child.Y := CursorY;
      var StartY := CursorY;

      // Advance cursor past left margin + border + padding before laying out children
      CursorX := CursorX + Child.Style.Margin.Left + Child.Style.BorderWidth +
        Child.Style.Padding.Left;

      // Content origin in parent block coordinates
      var ContentOriginX := CursorX;
      var ContentOriginY := CursorY;

      for var GrandChild in Child.Children do
        ProcessInlineBox(GrandChild);
      var ContentEndX := CursorX;

      // Advance cursor past right padding + border + margin
      CursorX := CursorX + Child.Style.Padding.Right + Child.Style.BorderWidth +
        Child.Style.Margin.Right;

      // Calculate content width — just the inner text portion
      if CursorY = StartY then
        Child.ContentWidth := ContentEndX - ContentOriginX
      else
        Child.ContentWidth := AvailWidth - Child.Style.Margin.Left - Child.Style.Margin.Right -
          Child.Style.BorderWidth * 2 - Child.Style.Padding.Left - Child.Style.Padding.Right;

      // Use the inline container's own line height for its content height,
      // not the parent's LineH which may have grown from previous inline siblings.
      Child.ContentHeight := (CursorY + GetLineHeight(Child.Style)) - StartY;

      // Make grandchild coordinates relative to the inline container's content area
      // (so PaintBox's ContentLeft/ContentTop offset works correctly).
      // Fragment positions are already relative to their text node's X/Y, so they
      // move automatically when the text node is repositioned — no separate adjustment needed.
      for var GrandChild in Child.Children do
      begin
        GrandChild.X := GrandChild.X - ContentOriginX;
        GrandChild.Y := GrandChild.Y - ContentOriginY;
      end;

      // Include full inline box height in line height
      LineH := Max(LineH, Child.Style.Margin.Top + Child.Style.BorderWidth +
        Child.Style.Padding.Top + Child.ContentHeight +
        Child.Style.Padding.Bottom + Child.Style.BorderWidth + Child.Style.Margin.Bottom);
    end;
  end;

begin
  CursorX := 0;
  CursorY := 0;
  LineH := GetLineHeight(Box.Style);

  for var Child in Box.Children do
    ProcessInlineBox(Child);

  // Include final line
  if CursorX > 0 then
    CursorY := CursorY + LineH;

  Box.ContentHeight := CursorY;

  // Apply text-align: center or right by shifting element positions per line.
  // Fragment positions are relative to their text node, so we compute absolute
  // positions using Child.X/Y + Frag.X/Y for grouping and measurement, then
  // shift fragment X values (relative shifts) per line.
  if (Box.Style.TextAlign = TTextAlign.Center) or (Box.Style.TextAlign = TTextAlign.Trailing) then
  begin
    var LineYs: TList<Single> := TList<Single>.Create;
    try
      // Collect unique absolute line Y values
      for var Child in Box.Children do
      begin
        if (Child.Kind = lbkBlock) or (Child.Kind = lbkTable) or
           (Child.Kind = lbkListItem) or (Child.Kind = lbkHR) then
          Continue;
        if Child.Kind = lbkText then
        begin
          for var FI := 0 to Child.Fragments.Count - 1 do
          begin
            var AbsFragY := Child.Y + Child.Fragments[FI].Y;
            var Found := False;
            for var LY in LineYs do
              if Abs(LY - AbsFragY) < 0.5 then begin Found := True; Break; end;
            if not Found then
              LineYs.Add(AbsFragY);
          end;
        end
        else
        begin
          var Found := False;
          for var LY in LineYs do
            if Abs(LY - Child.Y) < 0.5 then begin Found := True; Break; end;
          if not Found then
            LineYs.Add(Child.Y);
        end;
      end;

      // For each line, find the rightmost edge and shift all elements
      for var LY in LineYs do
      begin
        var LineRight: Single := 0;
        for var Child in Box.Children do
        begin
          if (Child.Kind = lbkBlock) or (Child.Kind = lbkTable) or
             (Child.Kind = lbkListItem) or (Child.Kind = lbkHR) then
            Continue;
          if Child.Kind = lbkText then
          begin
            for var FI := 0 to Child.Fragments.Count - 1 do
            begin
              var AbsFragY := Child.Y + Child.Fragments[FI].Y;
              if Abs(AbsFragY - LY) < 0.5 then
                LineRight := Max(LineRight, Child.X + Child.Fragments[FI].X + Child.Fragments[FI].W);
            end;
          end
          else if Abs(Child.Y - LY) < 0.5 then
            LineRight := Max(LineRight, Child.X + Child.MarginBoxWidth);
        end;

        var Shift: Single := 0;
        if Box.Style.TextAlign = TTextAlign.Center then
          Shift := (AvailWidth - LineRight) / 2
        else
          Shift := AvailWidth - LineRight;
        if Shift < 0 then Shift := 0;

        if Shift > 0.5 then
        begin
          for var Child in Box.Children do
          begin
            if (Child.Kind = lbkBlock) or (Child.Kind = lbkTable) or
               (Child.Kind = lbkListItem) or (Child.Kind = lbkHR) then
              Continue;
            if Child.Kind = lbkText then
            begin
              for var FI := 0 to Child.Fragments.Count - 1 do
              begin
                var AbsFragY := Child.Y + Child.Fragments[FI].Y;
                if Abs(AbsFragY - LY) < 0.5 then
                begin
                  var F := Child.Fragments[FI];
                  F.X := F.X + Shift;
                  Child.Fragments[FI] := F;
                end;
              end;
            end
            else if Abs(Child.Y - LY) < 0.5 then
              Child.X := Child.X + Shift;
          end;
        end;
      end;
    finally
      LineYs.Free;
    end;
  end;
end;

procedure TLayoutEngine.LayoutTable(Box: TLayoutBox; AvailWidth: Single);
var
  Rows: TList<TLayoutBox>;
  NumCols, ColIdx: Integer;
  ColWidths: TArray<Single>;
  CursorY, RowH, CellW: Single;
  BorderW: Single;
begin
  BorderW := Box.Style.BorderWidth;
  Rows := TList<TLayoutBox>.Create;
  try
    // Collect all row boxes (flattening thead/tbody/tfoot)
    for var Child in Box.Children do
    begin
      if Child.Kind = lbkTableRow then
      begin
        // Check if this is a row group (thead/tbody/tfoot) containing actual rows
        var HasSubRows := False;
        for var Sub in Child.Children do
        begin
          if Sub.Kind = lbkTableRow then
          begin
            Rows.Add(Sub);
            HasSubRows := True;
          end;
        end;
        if not HasSubRows then
          Rows.Add(Child);
      end;
    end;

    // Count columns
    NumCols := 0;
    for var Row in Rows do
    begin
      var Count := 0;
      for var Cell in Row.Children do
      begin
        if Cell.Kind = lbkTableCell then
        begin
          var CS := StrToIntDef(Cell.Tag.GetAttribute('colspan', '1'), 1);
          Inc(Count, CS);
        end;
      end;
      NumCols := Max(NumCols, Count);
    end;
    if NumCols = 0 then
    begin
      Box.ContentWidth := 0;
      Box.ContentHeight := 0;
      Exit;
    end;

    // Calculate content width
    var TableContentW := AvailWidth - ResolveMargin(Box.Style.Margin.Left) -
      ResolveMargin(Box.Style.Margin.Right) -
      Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
    if IsPercentageValue(Box.Style.ExplicitWidth) then
    begin
      // Percentage width — resolved value includes padding + border
      TableContentW := ResolvePercentage(Box.Style.ExplicitWidth, AvailWidth) -
        Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
    end
    else if Box.Style.ExplicitWidth > 0 then
    begin
      if SameText(Box.Style.BoxSizing, 'border-box') then
        TableContentW := Box.Style.ExplicitWidth -
          Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right
      else
        TableContentW := Box.Style.ExplicitWidth;
    end;

    // Use collapsed borders — adjacent cells share a single border line.
    // No spacing between cells; PaintTableCellBorders draws a single grid.
    var CellBorderW: Single := 0;  // no inter-cell spacing in collapsed mode
    var AvailForCols := TableContentW;
    if AvailForCols < 0 then AvailForCols := 0;

    SetLength(ColWidths, NumCols);
    for var I := 0 to NumCols - 1 do
      ColWidths[I] := AvailForCols / NumCols;

    // Layout rows — no border offset needed with collapsed borders
    CursorY := 0;
    for var Row in Rows do
    begin
      RowH := 0;
      ColIdx := 0;
      var CellX: Single := 0;

      for var Cell in Row.Children do
      begin
        if Cell.Kind <> lbkTableCell then Continue;
        if ColIdx >= NumCols then Break;

        var CS := StrToIntDef(Cell.Tag.GetAttribute('colspan', '1'), 1);
        CellW := 0;
        for var CI := ColIdx to Min(ColIdx + CS - 1, NumCols - 1) do
          CellW := CellW + ColWidths[CI];
        if CS > 1 then
          CellW := CellW + CellBorderW * (CS - 1);

        // Layout cell content
        var CellContentW := CellW - Cell.Style.Padding.Left - Cell.Style.Padding.Right;
        if CellContentW < 0 then CellContentW := 0;

        Cell.ContentWidth := CellContentW;

        // Determine if cell has inline content (use same logic as LayoutBlock)
        var CellHasInline := False;
        for var CellChild in Cell.Children do
        begin
          if (CellChild.Kind = lbkImage) or (CellChild.Kind = lbkFormControl) or
             (CellChild.Kind = lbkBR) or (CellChild.Kind = lbkInline) then
          begin
            CellHasInline := True;
            Break;
          end
          else if (CellChild.Kind = lbkText) and Assigned(CellChild.Tag) and
                  (CellChild.Tag.Text.Trim <> '') then
          begin
            CellHasInline := True;
            Break;
          end;
        end;

        // Layout cell children
        var CellCursorY: Single := 0;
        if CellHasInline then
        begin
          LayoutInlineChildren(Cell, CellContentW);
          CellCursorY := Cell.ContentHeight;
        end
        else
        begin
          for var CellChild in Cell.Children do
          begin
            case CellChild.Kind of
              lbkBlock: LayoutBlock(CellChild, CellContentW);
              lbkTable: LayoutTable(CellChild, CellContentW);
              lbkListItem: LayoutListItem(CellChild, CellContentW);
              lbkHR: LayoutHR(CellChild, CellContentW);
            else
              LayoutBlock(CellChild, CellContentW);
            end;
            CellChild.X := 0;
            CellChild.Y := CellCursorY;
            CellCursorY := CellCursorY + CellChild.MarginBoxHeight;
          end;
        end;
        if CellCursorY > Cell.ContentHeight then
          Cell.ContentHeight := CellCursorY;

        Cell.X := CellX;
        Cell.Y := 0;  // Cell position is relative to the row, not the table
        Cell.ContentWidth := CellContentW;

        RowH := Max(RowH, Cell.ContentHeight + Cell.Style.Padding.Top + Cell.Style.Padding.Bottom);
        CellX := CellX + CellW + CellBorderW;
        Inc(ColIdx, CS);
      end;

      // Set uniform row height
      for var Cell in Row.Children do
      begin
        if Cell.Kind = lbkTableCell then
          Cell.ContentHeight := RowH - Cell.Style.Padding.Top - Cell.Style.Padding.Bottom;
      end;

      Row.X := 0;
      Row.Y := CursorY;
      Row.ContentWidth := TableContentW;
      Row.ContentHeight := RowH;
      CursorY := CursorY + RowH + CellBorderW;
    end;

    Box.ContentWidth := TableContentW;
    Box.ContentHeight := CursorY;
  finally
    Rows.Free;
  end;
end;

procedure TLayoutEngine.LayoutListItem(Box: TLayoutBox; AvailWidth: Single);
var
  ContentW: Single;
begin
  ContentW := AvailWidth - ResolveMargin(Box.Style.Margin.Left) -
    ResolveMargin(Box.Style.Margin.Right) -
    Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
  if ContentW < 0 then ContentW := 0;

  // Leave space for bullet/number marker
  var MarkerW: Single := 8;
  var InnerW := ContentW - MarkerW;
  if InnerW < 0 then InnerW := 0;

  Box.ContentWidth := ContentW;

  // Layout children shifted right for marker
  var CursorY: Single := 0;
  var HasInline := False;
  for var Child in Box.Children do
  begin
    if (Child.Kind = lbkText) or (Child.Kind = lbkInline) or (Child.Kind = lbkBR) then
    begin
      HasInline := True;
      Break;
    end;
  end;

  if HasInline then
  begin
    // Shift inline content right for marker
    LayoutInlineChildren(Box, InnerW);
    // Offset children by MarkerW (fragments are relative to their text node,
    // so they move automatically when Child.X is shifted)
    for var Child in Box.Children do
      Child.X := Child.X + MarkerW;
  end
  else
  begin
    for var Child in Box.Children do
    begin
      case Child.Kind of
        lbkBlock: LayoutBlock(Child, InnerW);
        lbkTable: LayoutTable(Child, InnerW);
        lbkListItem: LayoutListItem(Child, InnerW);
      else
        LayoutBlock(Child, InnerW);
      end;
      Child.X := MarkerW;
      Child.Y := CursorY;
      CursorY := CursorY + Child.MarginBoxHeight;
    end;
    Box.ContentHeight := CursorY;
  end;
end;

procedure TLayoutEngine.LayoutImage(Box: TLayoutBox; AvailWidth: Single);
var
  Bmp: TBitmap;
  W, H, ExplW, ExplH: Single;
begin
  W := 100;
  H := 100;

  if Assigned(Box.Tag) and Assigned(FImageCache) then
  begin
    Bmp := FImageCache.GetImage(Box.Tag.GetAttribute('src'));
    if Assigned(Bmp) then
    begin
      W := Bmp.Width;
      H := Bmp.Height;
    end;
  end;

  // Resolve explicit dimensions (may be percentages)
  ExplW := Box.Style.ExplicitWidth;
  ExplH := Box.Style.ExplicitHeight;
  if IsPercentageValue(ExplW) then
    ExplW := ResolvePercentage(ExplW, AvailWidth);
  if IsPercentageValue(ExplH) then
    ExplH := 0; // Percentage height on images is not meaningful without container height

  if ExplW > 0 then
  begin
    var Ratio := ExplW / W;
    W := ExplW;
    if ExplH <= 0 then
      H := H * Ratio;
  end;
  if ExplH > 0 then
  begin
    var Ratio := ExplH / H;
    H := ExplH;
    if ExplW <= 0 then
      W := W * Ratio;
  end;

  // Clamp to available width
  if W > AvailWidth then
  begin
    var Ratio := AvailWidth / W;
    W := AvailWidth;
    H := H * Ratio;
  end;

  Box.ContentWidth := W;
  Box.ContentHeight := H;
end;

procedure TLayoutEngine.LayoutFormControl(Box: TLayoutBox; AvailWidth: Single);
var
  TN: string;
  ExplW: Single;
begin
  TN := '';
  if Assigned(Box.Tag) then
    TN := Box.Tag.TagName.ToLower;

  // Check for explicit/percentage width
  ExplW := Box.Style.ExplicitWidth;
  if IsPercentageValue(ExplW) then
    ExplW := ResolvePercentage(ExplW, AvailWidth);

  if TN = 'textarea' then
  begin
    if ExplW > 0 then
      Box.ContentWidth := Min(ExplW, AvailWidth)
    else
      Box.ContentWidth := Min(300, AvailWidth);
    Box.ContentHeight := 60;
  end
  else if TN = 'select' then
  begin
    if ExplW > 0 then
      Box.ContentWidth := Min(ExplW, AvailWidth)
    else
      Box.ContentWidth := Min(150, AvailWidth);
    Box.ContentHeight := 24;
  end
  else if TN = 'button' then
  begin
    var BtnText := '';
    if Assigned(Box.Tag) then
    begin
      for var C in Box.Tag.Children do
        if C.TagName = '#text' then BtnText := BtnText + C.Text;
      if BtnText = '' then
        BtnText := Box.Tag.GetAttribute('value', 'Button');
    end;
    Box.ContentWidth := Max(60, MeasureTextWidth(BtnText, Box.Style) + 20);
    Box.ContentHeight := Box.Style.FontSize * Box.Style.LineHeight;
  end
  else
  begin
    // input
    var InputType := '';
    if Assigned(Box.Tag) then
      InputType := Box.Tag.GetAttribute('type', 'text').ToLower;

    if (InputType = 'checkbox') or (InputType = 'radio') then
    begin
      Box.ContentWidth := 16;
      Box.ContentHeight := 16;
    end
    else if InputType = 'button' then
    begin
      var BtnText := '';
      if Assigned(Box.Tag) then
        BtnText := Box.Tag.GetAttribute('value', 'Button');
      Box.ContentWidth := Max(60, MeasureTextWidth(BtnText, Box.Style) + 20);
      Box.ContentHeight := 28;
    end
    else
    begin
      if ExplW > 0 then
        Box.ContentWidth := Min(ExplW, AvailWidth)
      else
        Box.ContentWidth := Min(200, AvailWidth);
      // Height based on font size and line height
      Box.ContentHeight := Box.Style.FontSize * Box.Style.LineHeight;
    end;
  end;
end;

procedure TLayoutEngine.LayoutHR(Box: TLayoutBox; AvailWidth: Single);
begin
  Box.ContentWidth := AvailWidth - ResolveMargin(Box.Style.Margin.Left) -
    ResolveMargin(Box.Style.Margin.Right);
  Box.ContentHeight := 2;
end;

procedure TLayoutEngine.Layout(DOMRoot: THTMLTag; AvailWidth: Single; AStyleSheet: TCSSStyleSheet);
begin
  FRoot.Free;
  FRoot := nil;
  FStyleSheet := AStyleSheet;

  if not Assigned(DOMRoot) then Exit;

  FRoot := BuildBoxTree(DOMRoot, TComputedStyle.Default);
  if not Assigned(FRoot) then Exit;

  FRoot.Style.Display := 'block';
  LayoutBlock(FRoot, AvailWidth);
  FRoot.X := 0;
  FRoot.Y := 0;

  FTotalHeight := FRoot.MarginBoxHeight;
end;

// ═══════════════════════════════════════════════════════════════════════════
// TTina4HTMLRender
// ═══════════════════════════════════════════════════════════════════════════

constructor TTina4HTMLRender.Create(AOwner: TComponent);
begin
  inherited;
  FHTML := TStringList.Create;
  FDebug := TStringList.Create;

  // Create shared file cache — off by default in debug, on in release
  FFileCache := TFileCache.Create;
  {$IFDEF DEBUG}
  FCacheEnabled := False;
  {$ELSE}
  FCacheEnabled := True;
  {$ENDIF}
  FFileCache.Enabled := FCacheEnabled;
  FCacheDir := '';

  FImageCache := TImageCache.Create;
  FImageCache.OnImageLoaded := OnImageLoaded;
  FImageCache.FileCache := FFileCache;
  FParser := THTMLParser.Create;
  FLayoutEngine := TLayoutEngine.Create(FImageCache);
  FStyleSheet := TCSSStyleSheet.Create;
  FStyleSheet.FileCache := FFileCache;
  FHTML.OnChange := FHTMLChange;
  FScrollY := 0;
  FContentHeight := 0;
  FNeedRelayout := True;
  FScrollBarWidth := 12;
  FIsLayoutting := False;
  FMouseDownOnScroll := False;
  Width := 320;
  Height := 240;
  FFormControls := TList<TNativeFormControl>.Create;
  ClipChildren := True;
  HitTest := True;
end;

destructor TTina4HTMLRender.Destroy;
begin
  ClearFormControls;
  FFormControls.Free;
  FStyleSheet.Free;
  FLayoutEngine.Free;
  FParser.Free;
  FImageCache.Free;
  FFileCache.Free;
  FHTML.Free;
  FDebug.Free;
  inherited;
end;

function TTina4HTMLRender.GetHTML: TStringList;
begin
  Result := FHTML;
end;

procedure TTina4HTMLRender.SetHTML(const Value: TStringList);
begin
  FHTML.Assign(Value);
  Repaint;
end;

procedure TTina4HTMLRender.SetCacheEnabled(Value: Boolean);
begin
  FCacheEnabled := Value;
  FFileCache.Enabled := Value;
end;

procedure TTina4HTMLRender.SetCacheDir(const Value: string);
begin
  FCacheDir := Value;
  if Value <> '' then
    FFileCache.CacheDir := Value
  else
    FFileCache.CacheDir := TPath.Combine(TPath.GetTempPath, 'Tina4Cache');
end;

procedure TTina4HTMLRender.ClearCache;
begin
  FFileCache.ClearCache;
end;

procedure TTina4HTMLRender.FHTMLChange(Sender: TObject);
begin
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.OnImageLoaded(Sender: TObject);
begin
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.DoLayout;
begin
  if FIsLayoutting then Exit;
  FIsLayoutting := True;
  try
    FParser.Parse(FHTML.Text);

    // Build stylesheet from <style> blocks and <link rel="stylesheet"> hrefs
    FStyleSheet.Clear;
    for var I := 0 to FParser.StyleBlocks.Count - 1 do
      FStyleSheet.AddCSS(FParser.StyleBlocks[I]);
    for var I := 0 to FParser.LinkHrefs.Count - 1 do
      FStyleSheet.LoadFromURL(FParser.LinkHrefs[I]);

    var AvailW := Width;
    if ScrollBarVisible then
      AvailW := AvailW - FScrollBarWidth;
    FLayoutEngine.Layout(FParser.Root, AvailW, FStyleSheet);
    FContentHeight := FLayoutEngine.TotalHeight;
    ClampScroll;
    FNeedRelayout := False;

    // Create native FMX controls for form elements
    ClearFormControls;
    if Assigned(FLayoutEngine.Root) then
      CreateFormControls(FLayoutEngine.Root, 0, 0);
  finally
    FIsLayoutting := False;
  end;
end;

function TTina4HTMLRender.ScrollBarVisible: Boolean;
begin
  Result := FContentHeight > Height;
end;

procedure TTina4HTMLRender.ClampScroll;
begin
  if FContentHeight <= Height then
    FScrollY := 0
  else
    FScrollY := Max(0, Min(FScrollY, FContentHeight - Height));
end;

procedure TTina4HTMLRender.ClearFormControls;
begin
  for var I := FFormControls.Count - 1 downto 0 do
    FFormControls[I].Control.Free;
  FFormControls.Clear;
end;

function TTina4HTMLRender.GetFormControlNameValue(Control: TControl;
  out AName, AValue: string): Boolean;
begin
  AName := '';
  AValue := '';
  for var Rec in FFormControls do
  begin
    if Rec.Control = Control then
    begin
      if Assigned(Rec.Box.Tag) then
      begin
        AName := Rec.Box.Tag.GetAttribute('name', '');
        // For radio/checkbox, return the element's value attribute
        if (Control is TCheckBox) or (Control is TRadioButton) then
          AValue := Rec.Box.Tag.GetAttribute('value', '');
      end;
      Break;
    end;
  end;
  if AValue = '' then
  begin
    if Control is TEdit then AValue := TEdit(Control).Text
    else if Control is TMemo then AValue := TMemo(Control).Lines.Text
    else if Control is TCheckBox then AValue := BoolToStr(TCheckBox(Control).IsChecked, True)
    else if Control is TRadioButton then AValue := BoolToStr(TRadioButton(Control).IsChecked, True)
    else if Control is TComboBox then
    begin
      if TComboBox(Control).Selected <> nil then
        AValue := TComboBox(Control).Selected.Text;
    end
    else if Control is TButton then AValue := TButton(Control).Text;
  end;
  Result := AName <> '';
end;

procedure TTina4HTMLRender.HandleFormControlChange(Sender: TObject);
var N, V: string;
begin
  if Assigned(FOnChange) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnChange(Sender, N, V);
end;

procedure TTina4HTMLRender.HandleFormControlClick(Sender: TObject);
var N, V: string;
begin
  if Assigned(FOnClick) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnClick(Sender, N, V);
end;

procedure TTina4HTMLRender.HandleFormControlEnter(Sender: TObject);
var N, V: string;
begin
  if Assigned(FOnEnter) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnEnter(Sender, N, V);
end;

procedure TTina4HTMLRender.HandleFormControlExit(Sender: TObject);
var N, V: string;
begin
  if Assigned(FOnExit) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnExit(Sender, N, V);
end;

procedure TTina4HTMLRender.CreateFormControls(Box: TLayoutBox; OffX, OffY: Single);
var
  AbsX, AbsY, CX, CY: Single;
  Ctl: TControl;
  Rec: TNativeFormControl;
  TN, InputType, Placeholder, Val: string;
begin
  if Box.Style.Display = 'none' then Exit;

  AbsX := OffX + Box.X;
  AbsY := OffY + Box.Y;

  if Assigned(Box.Tag) then
  begin
    TN := Box.Tag.TagName.ToLower;
    Ctl := nil;

    if TN = 'input' then
    begin
      InputType := Box.Tag.GetAttribute('type', 'text').ToLower;
      Placeholder := Box.Tag.GetAttribute('placeholder', '');
      Val := Box.Tag.GetAttribute('value', '');

      if InputType = 'checkbox' then
      begin
        var CB := TCheckBox.Create(Self);
        CB.IsChecked := Box.Tag.HasAttribute('checked');
        CB.OnChange := HandleFormControlChange;
        Ctl := CB;
      end
      else if InputType = 'radio' then
      begin
        var RB := TRadioButton.Create(Self);
        RB.IsChecked := Box.Tag.HasAttribute('checked');
        RB.GroupName := Box.Tag.GetAttribute('name', 'radio');
        RB.OnChange := HandleFormControlChange;
        Ctl := RB;
      end
      else
      begin
        var Ed := TEdit.Create(Self);
        if InputType = 'password' then Ed.Password := True;
        Ed.TextPrompt := Placeholder;
        if Val <> '' then Ed.Text := Val;
        Ed.OnChange := HandleFormControlChange;
        Ed.OnEnter := HandleFormControlEnter;
        Ed.OnExit := HandleFormControlExit;
        Ctl := Ed;
      end;
    end
    else if TN = 'textarea' then
    begin
      var Mem := TMemo.Create(Self);
      Mem.OnChange := HandleFormControlChange;
      Ctl := Mem;
    end
    else if TN = 'select' then
    begin
      var Cmb := TComboBox.Create(Self);
      if Assigned(Box.Tag) then
        for var OptTag in Box.Tag.Children do
          if SameText(OptTag.TagName, 'option') then
          begin
            var OptText := '';
            for var C in OptTag.Children do
              if C.TagName = '#text' then OptText := OptText + C.Text;
            Cmb.Items.Add(OptText.Trim);
          end;
      if Cmb.Items.Count > 0 then Cmb.ItemIndex := 0;
      Cmb.OnChange := HandleFormControlChange;
      Ctl := Cmb;
    end
    else if TN = 'button' then
    begin
      var Btn := TButton.Create(Self);
      var BtnText := '';
      for var C in Box.Tag.Children do
        if C.TagName = '#text' then BtnText := BtnText + C.Text;
      if BtnText = '' then BtnText := Box.Tag.GetAttribute('value', 'Button');
      Btn.Text := BtnText.Trim;
      Btn.OnClick := HandleFormControlClick;
      Ctl := Btn;
    end;

    if Assigned(Ctl) then
    begin
      Ctl.Parent := Self;
      Ctl.Width := Box.ContentWidth + Box.Style.Padding.Left + Box.Style.Padding.Right;
      Ctl.Height := Box.ContentHeight + Box.Style.Padding.Top + Box.Style.Padding.Bottom;

      // Apply CSS styles via ITextSettings (works for TEdit, TButton, TMemo, etc.)
      var TS: ITextSettings;
      if Supports(Ctl, ITextSettings, TS) then
      begin
        TS.StyledSettings := TS.StyledSettings - [TStyledSetting.Family,
          TStyledSetting.Size, TStyledSetting.FontColor, TStyledSetting.Style];
        TS.TextSettings.Font.Family := Box.Style.FontFamily;
        TS.TextSettings.Font.Size := Box.Style.FontSize;
        if Box.Style.Bold then
          TS.TextSettings.Font.Style := TS.TextSettings.Font.Style + [TFontStyle.fsBold];
        if Box.Style.Italic then
          TS.TextSettings.Font.Style := TS.TextSettings.Font.Style + [TFontStyle.fsItalic];
        if Box.Style.Color <> TAlphaColors.Null then
          TS.TextSettings.FontColor := Box.Style.Color;
      end;

      Rec.Control := Ctl;
      Rec.Box := Box;
      FFormControls.Add(Rec);
      Exit;
    end;
  end;

  // Recurse children
  CX := AbsX + Box.ContentLeft;
  CY := AbsY + Box.ContentTop;
  for var Child in Box.Children do
    CreateFormControls(Child, CX, CY);
end;

procedure TTina4HTMLRender.PositionFormControls;
var
  AbsX, AbsY: Single;

  function FindBox(Parent, Target: TLayoutBox; var PX, PY: Single): Boolean;
  begin
    if Parent = Target then Exit(True);
    var CX := PX + Parent.ContentLeft;
    var CY := PY + Parent.ContentTop;
    for var C in Parent.Children do
    begin
      var SX := CX + C.X;
      var SY := CY + C.Y;
      if FindBox(C, Target, SX, SY) then
      begin
        PX := SX;
        PY := SY;
        Exit(True);
      end;
    end;
    Result := False;
  end;

begin
  if not Assigned(FLayoutEngine.Root) then Exit;
  for var I := 0 to FFormControls.Count - 1 do
  begin
    var Rec := FFormControls[I];
    AbsX := 0;
    AbsY := 0;
    FindBox(FLayoutEngine.Root, Rec.Box, AbsX, AbsY);
    Rec.Control.Position.X := AbsX;
    Rec.Control.Position.Y := AbsY - FScrollY;
    Rec.Control.Width := Rec.Box.ContentWidth + Rec.Box.Style.Padding.Left + Rec.Box.Style.Padding.Right;
    Rec.Control.Height := Rec.Box.ContentHeight + Rec.Box.Style.Padding.Top + Rec.Box.Style.Padding.Bottom;
    Rec.Control.Visible := (Rec.Control.Position.Y + Rec.Control.Height > 0) and
      (Rec.Control.Position.Y < Height);
  end;
end;

procedure TTina4HTMLRender.Paint;
begin
  inherited;
  if Canvas = nil then Exit;

  if FNeedRelayout then
    DoLayout;

  Canvas.BeginScene;
  try
    // Background
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := TAlphaColors.White;
    Canvas.FillRect(LocalRect, 1.0);

    // Paint layout tree
    if Assigned(FLayoutEngine.Root) then
      PaintBox(Canvas, FLayoutEngine.Root, 0, -FScrollY);

    // Scrollbar
    if ScrollBarVisible then
      PaintScrollBar(Canvas);
  finally
    Canvas.EndScene;
  end;

  // Position native form controls after painting (accounts for scroll)
  PositionFormControls;
end;

procedure TTina4HTMLRender.PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single);
var
  AbsX, AbsY, CX, CY: Single;
begin
  if Box.Style.Display = 'none' then Exit;

  // Skip form control boxes — they are rendered as native FMX controls
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or SameText(Box.Tag.TagName, 'button') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
    Exit;

  AbsX := OffX + Box.X;
  AbsY := OffY + Box.Y;

  // Viewport culling
  if (AbsY + Box.MarginBoxHeight < 0) or (AbsY > Height) then Exit;

  // Background
  PaintBackground(Canvas, Box, AbsX, AbsY);

  // Border
  PaintBorder(Canvas, Box, AbsX, AbsY);

  // Content-specific rendering
  case Box.Kind of
    lbkText:
      PaintText(Canvas, Box, AbsX, AbsY);
    lbkImage:
      PaintImage(Canvas, Box, AbsX + Box.ContentLeft, AbsY + Box.ContentTop);
    lbkHR:
      PaintHR(Canvas, Box, AbsX, AbsY);
    lbkListItem:
      PaintListMarker(Canvas, Box, AbsX, AbsY);
    lbkTable:
      if Box.Style.BorderWidth > 0 then
        PaintTableCellBorders(Canvas, Box, AbsX + Box.ContentLeft, AbsY + Box.ContentTop);
  end;

  // Recurse children
  CX := AbsX + Box.ContentLeft;
  CY := AbsY + Box.ContentTop;
  for var Child in Box.Children do
    PaintBox(Canvas, Child, CX, CY);
end;

procedure TTina4HTMLRender.PaintBackground(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT: Single;
begin
  if Box.Style.BackgroundColor = TAlphaColors.Null then Exit;

  // Form controls are native FMX controls — skip canvas background
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or SameText(Box.Tag.TagName, 'button') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
    Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);

  R := RectF(
    X + ML,
    Y + MT,
    X + ML + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right,
    Y + MT + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom
  );

  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.Fill.Color := Box.Style.BackgroundColor;
  Canvas.FillRect(R, 1.0);
end;

procedure TTina4HTMLRender.PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT: Single;
begin
  if Box.Style.BorderWidth <= 0 then Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);

  // For blockquote-style left border only
  if Assigned(Box.Tag) and SameText(Box.Tag.TagName, 'blockquote') then
  begin
    var LX := X + ML;
    var TY := Y + MT;
    var BY := TY + Box.Style.BorderWidth * 2 + Box.Style.Padding.Top +
      Box.ContentHeight + Box.Style.Padding.Bottom;
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := Box.Style.BorderColor;
    Canvas.Stroke.Thickness := Box.Style.BorderWidth;
    Canvas.DrawLine(PointF(LX, TY), PointF(LX, BY), 1.0);
    Exit;
  end;

  // Table borders are handled entirely by PaintTableCellBorders (collapsed grid)
  if (Box.Kind = lbkTable) or (Box.Kind = lbkTableCell) then
    Exit;

  // Form controls are native FMX controls — skip canvas border
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or SameText(Box.Tag.TagName, 'button') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
    Exit;

  // General border
  R := RectF(
    X + ML + Box.Style.BorderWidth / 2,
    Y + MT + Box.Style.BorderWidth / 2,
    X + ML + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right - Box.Style.BorderWidth / 2,
    Y + MT + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom - Box.Style.BorderWidth / 2
  );
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Color := Box.Style.BorderColor;
  Canvas.Stroke.Thickness := Box.Style.BorderWidth;
  Canvas.DrawRect(R, 1.0);
end;

procedure TTina4HTMLRender.PaintText(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  Layout: TTextLayout;
  Frag: TTextFragment;
  FontStyles: TFontStyles;
begin
  if Box.Fragments.Count = 0 then Exit;

  FontStyles := [];
  if Box.Style.Bold then Include(FontStyles, TFontStyle.fsBold);
  if Box.Style.Italic then Include(FontStyles, TFontStyle.fsItalic);

  for var I := 0 to Box.Fragments.Count - 1 do
  begin
    Frag := Box.Fragments[I];

    Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      Layout.BeginUpdate;
      Layout.Text := Frag.Text;
      Layout.Font.Family := Box.Style.FontFamily;
      Layout.Font.Size := Box.Style.FontSize;
      Layout.Font.Style := FontStyles;
      Layout.Color := Box.Style.Color;
      Layout.WordWrap := Box.Style.WhiteSpace <> 'pre';
      Layout.HorizontalAlign := TTextAlign.Leading;
      Layout.TopLeft := PointF(X + Box.ContentLeft + Frag.X,
                               Y + Box.ContentTop + Frag.Y);
      Layout.MaxSize := PointF(Frag.W + 2, Frag.H + 2);
      Layout.EndUpdate;
      Layout.RenderLayout(Canvas);

      // Text decoration
      if Box.Style.TextDecoration = 'underline' then
      begin
        var UY := Y + Box.ContentTop + Frag.Y + Frag.H - 2;
        Canvas.Stroke.Kind := TBrushKind.Solid;
        Canvas.Stroke.Color := Box.Style.Color;
        Canvas.Stroke.Thickness := 1;
        Canvas.DrawLine(
          PointF(X + Box.ContentLeft + Frag.X, UY),
          PointF(X + Box.ContentLeft + Frag.X + Frag.W, UY),
          1.0);
      end
      else if Box.Style.TextDecoration = 'line-through' then
      begin
        var SY := Y + Box.ContentTop + Frag.Y + Frag.H / 2;
        Canvas.Stroke.Kind := TBrushKind.Solid;
        Canvas.Stroke.Color := Box.Style.Color;
        Canvas.Stroke.Thickness := 1;
        Canvas.DrawLine(
          PointF(X + Box.ContentLeft + Frag.X, SY),
          PointF(X + Box.ContentLeft + Frag.X + Frag.W, SY),
          1.0);
      end;
    finally
      Layout.Free;
    end;
  end;
end;

procedure TTina4HTMLRender.PaintImage(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  Bmp: TBitmap;
  SrcRect, DstRect: TRectF;
begin
  if not Assigned(Box.Tag) then Exit;
  var Src := Box.Tag.GetAttribute('src');

  Bmp := FImageCache.GetImage(Src);
  if Assigned(Bmp) then
  begin
    SrcRect := RectF(0, 0, Bmp.Width, Bmp.Height);
    DstRect := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
    Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
  end
  else
  begin
    // Placeholder
    var Alt := Box.Tag.GetAttribute('alt', '[Image]');
    var Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      Layout.BeginUpdate;
      Layout.Text := '[' + Alt + ']';
      Layout.Font.Size := 12;
      Layout.Color := TAlphaColors.Gray;
      Layout.TopLeft := PointF(X + 4, Y + 4);
      Layout.MaxSize := PointF(Box.ContentWidth - 8, Box.ContentHeight - 8);
      Layout.WordWrap := True;
      Layout.EndUpdate;

      // Draw placeholder border
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Lightgray;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawRect(RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight), 1.0);

      Layout.RenderLayout(Canvas);
    finally
      Layout.Free;
    end;
  end;
end;


procedure TTina4HTMLRender.PaintHR(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  LY: Single;
begin
  LY := Y + ResolveAutoMargin(Box.Style.Margin.Top) + 1;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Color := TAlphaColors.Lightgray;
  Canvas.Stroke.Thickness := 1;
  Canvas.DrawLine(
    PointF(X + ResolveAutoMargin(Box.Style.Margin.Left), LY),
    PointF(X + ResolveAutoMargin(Box.Style.Margin.Left) + Box.ContentWidth, LY),
    1.0);
end;

procedure TTina4HTMLRender.PaintListMarker(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  Layout: TTextLayout;
  MarkerText: string;
  MarkerY, LineH, BulletR, BulletCX, BulletCY: Single;
begin
  MarkerY := Y + Box.ContentTop;
  LineH := Box.Style.FontSize * Box.Style.LineHeight;

  if Box.IsOrdered then
  begin
    MarkerText := IntToStr(Box.ListIndex) + '.';
    Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      Layout.BeginUpdate;
      Layout.Text := MarkerText;
      Layout.Font.Family := Box.Style.FontFamily;
      Layout.Font.Size := Box.Style.FontSize;
      Layout.Color := Box.Style.Color;
      Layout.HorizontalAlign := TTextAlign.Trailing;
      Layout.TopLeft := PointF(X + Box.ContentLeft - 4, MarkerY);
      Layout.MaxSize := PointF(18, LineH);
      Layout.EndUpdate;
      Layout.RenderLayout(Canvas);
    finally
      Layout.Free;
    end;
  end
  else
  begin
    // Draw a filled circle bullet — radius scales with font size
    BulletR := Box.Style.FontSize * 0.18;
    if BulletR < 2.5 then BulletR := 2.5;
    BulletCX := X + Box.ContentLeft;
    BulletCY := MarkerY + LineH * 0.5;
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := Box.Style.Color;
    Canvas.FillEllipse(RectF(BulletCX - BulletR, BulletCY - BulletR,
      BulletCX + BulletR, BulletCY + BulletR), 1.0);
  end;
end;

procedure TTina4HTMLRender.PaintTableCellBorders(Canvas: TCanvas; Box: TLayoutBox; CX, CY: Single);
var
  Rows: TList<TLayoutBox>;
  RowYOffsets: TList<Single>;
  TableW, TableH: Single;
  BW: Single;
begin
  // Draw collapsed grid borders: single lines shared between adjacent cells.
  BW := Box.Style.BorderWidth;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Color := Box.Style.BorderColor;
  Canvas.Stroke.Thickness := BW;

  TableW := Box.ContentWidth;
  TableH := Box.ContentHeight;

  Rows := TList<TLayoutBox>.Create;
  RowYOffsets := TList<Single>.Create;
  try
    // Collect all rows, flattening thead/tbody/tfoot groups
    for var Child in Box.Children do
    begin
      if Child.Kind <> lbkTableRow then Continue;
      var HasSubRows := False;
      for var Sub in Child.Children do
      begin
        if Sub.Kind = lbkTableRow then
        begin
          HasSubRows := True;
          Rows.Add(Sub);
          RowYOffsets.Add(Child.Y + Sub.Y);
        end;
      end;
      if not HasSubRows then
      begin
        Rows.Add(Child);
        RowYOffsets.Add(Child.Y);
      end;
    end;

    // Draw outer table border
    Canvas.DrawRect(RectF(CX, CY, CX + TableW, CY + TableH), 1.0);

    // Draw horizontal lines between rows (not top or bottom — those are part of outer rect)
    for var I := 0 to Rows.Count - 2 do
    begin
      var LineY := CY + RowYOffsets[I] + Rows[I].ContentHeight;
      Canvas.DrawLine(PointF(CX, LineY), PointF(CX + TableW, LineY), 1.0);
    end;

    // Draw vertical lines between cells using the first row's cell positions
    // (all rows have the same column layout)
    if Rows.Count > 0 then
    begin
      var FirstRow := Rows[0];
      for var Cell in FirstRow.Children do
      begin
        if Cell.Kind <> lbkTableCell then Continue;
        var LineX := CX + Cell.X + Cell.ContentWidth +
          Cell.Style.Padding.Left + Cell.Style.Padding.Right;
        // Don't draw line at the right edge (that's the outer border)
        if LineX < CX + TableW - 1 then
          Canvas.DrawLine(PointF(LineX, CY), PointF(LineX, CY + TableH), 1.0);
      end;
    end;
  finally
    RowYOffsets.Free;
    Rows.Free;
  end;
end;

procedure TTina4HTMLRender.PaintScrollBar(Canvas: TCanvas);
var
  TrackRect, ThumbRect: TRectF;
  Ratio, ThumbH, ThumbY: Single;
begin
  if FContentHeight <= Height then Exit;

  Ratio := Height / FContentHeight;
  ThumbH := Max(20, Height * Ratio);
  ThumbY := (FScrollY / (FContentHeight - Height)) * (Height - ThumbH);

  TrackRect := RectF(Width - FScrollBarWidth, 0, Width, Height);
  ThumbRect := RectF(Width - FScrollBarWidth + 2, ThumbY,
    Width - 2, ThumbY + ThumbH);

  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.Fill.Color := $FFF0F0F0;
  Canvas.FillRect(TrackRect, 1.0);

  Canvas.Fill.Color := $FF999999;
  Canvas.FillRect(ThumbRect, 4, 4, AllCorners, 1.0);
end;

