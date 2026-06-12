unit Tina4HtmlRender;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Math,
  System.Generics.Collections, System.Generics.Defaults,
  System.UITypes, System.UIConsts,
  System.NetEncoding, System.Net.HttpClient,
  System.Hash, System.Rtti, System.Character,
  System.Math.Vectors, System.Messaging,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.TextLayout,
  FMX.Edit, FMX.StdCtrls, FMX.Memo, FMX.ListBox, FMX.Layouts, FMX.Objects, FMX.Forms,
  FMX.DialogService, FMX.Dialogs, Fmx.Surfaces,
  FMX.VirtualKeyboard, FMX.Platform,
  System.IOUtils
  {$IFDEF ANDROID}
  , Androidapi.Log
  {$ENDIF}
  ;

type
  // ─────────────────────────────────────────────────────────────────────────
  // DOM Node
  // ─────────────────────────────────────────────────────────────────────────

  /// <summary>
  /// Represents a single node in the parsed HTML DOM tree. Stores the tag name,
  /// text content, inline styles, HTML attributes, and child nodes.
  /// </summary>
  THTMLTag = class
  public
    /// <summary>The HTML tag name (e.g. 'div', 'p', 'a'). '#text' for text nodes.</summary>
    TagName: string;
    /// <summary>The text content of this node (for text nodes).</summary>
    Text: string;
    /// <summary>Inline CSS styles parsed from the style attribute.</summary>
    Style: TDictionary<string, string>;
    /// <summary>HTML attributes dictionary (e.g. 'id', 'class', 'href', 'onclick').</summary>
    Attributes: TDictionary<string, string>;
    /// <summary>Ordered list of child nodes.</summary>
    Children: TList<THTMLTag>;
    /// <summary>Reference to the parent node. Nil for the root.</summary>
    Parent: THTMLTag;
    /// <summary>Pseudo-class runtime state. The renderer maintains these
    /// flags as the user mouses around / clicks; CSS selectors with
    /// `:hover`, `:active`, or `:focus` consult them at match time.</summary>
    IsHovered: Boolean;
    IsActive: Boolean;
    IsFocused: Boolean;
    /// <summary>Creates an empty tag with initialised dictionaries and child list.</summary>
    constructor Create;
    /// <summary>Frees all children recursively and the internal dictionaries.</summary>
    destructor Destroy; override;
    /// <summary>Returns an attribute value by name, or Default if not found.</summary>
    /// <param name="Name">The attribute name to look up.</param>
    /// <param name="Default">Value returned when the attribute does not exist.</param>
    function GetAttribute(const Name: string; const Default: string = ''): string;
    /// <summary>Returns True if the attribute exists on this element.</summary>
    /// <param name="Name">The attribute name to check.</param>
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
    SourceOrder: Integer;  // Order in which rule appeared in CSS (for stable sorting)
    // Pre-classified routing key set at parse time so the cascade can
    // lookup-instead-of-scan. Determined from the rule's last selector
    // part (the one that targets the tag itself):
    //   '#X'  -> indexed by tag id 'X'
    //   '.X'  -> indexed by tag class 'X' (first class wins for multi-class)
    //   'tag' -> indexed by tag name
    //   ''    -> universal bucket (matched against every tag)
    RoutingKey: string;
    // Selector pre-tokenized at parse time:
    //   SelectorLower    — Selector.Trim.ToLower (cached)
    //   SelectorParts    — descendant-split parts of SelectorLower
    // The matcher reads these directly instead of repeating the
    // Trim/ToLower/Split work on every match call.
    SelectorLower: string;
    SelectorParts: TArray<string>;
    constructor Create;
    destructor Destroy; override;
  end;

  TCSSStyleSheetParseError = procedure(Sender: TObject;
    const Selector, Reason: string) of object;

  TCSSStyleSheet = class
  private
    FRules: TObjectList<TCSSRule>;
    FFileCache: TFileCache;
    FCustomProps: TDictionary<string, string>;
    FOnParseError: TCSSStyleSheetParseError;
    FHasInteractiveSelectors: Boolean;  // any rule uses :hover/:active/:focus?
    // Indexed cascade — rules grouped by their routing key so a tag
    // with class "btn" only checks rules that could plausibly match it.
    // Cuts ApplyTo from O(rules) to O(matching-rules) per tag, which on
    // a stylesheet of any size dominates layout cost.
    FRulesByKey: TDictionary<string, TList<TCSSRule>>;
    FUniversalRules: TList<TCSSRule>;  // rules with empty RoutingKey
    procedure ParseCSS(const CSSText: string);
    function SelectorMatches(Rule: TCSSRule; Tag: THTMLTag): Boolean;
    function SelectorSpecificity(const Selector: string): Integer;
    procedure ClassifyRule(Rule: TCSSRule);
    procedure ClearRuleIndex;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddCSS(const CSSText: string);
    procedure LoadFromURL(const URL: string);
    procedure Clear;
    procedure ApplyTo(Tag: THTMLTag; Declarations: TCSSDeclarations);
    function ResolveVar(const Value: string): string;
    function ResolveVarWith(const Value: string; Props: TDictionary<string, string>): string;
    property Rules: TObjectList<TCSSRule> read FRules;
    property FileCache: TFileCache read FFileCache write FFileCache;
    property OnParseError: TCSSStyleSheetParseError read FOnParseError write FOnParseError;
    /// <summary>
    /// True when any rule's selector contains `:hover`, `:active`, or
    /// `:focus`. Lets the renderer short-circuit mouse-tracking when no
    /// stylesheet rule cares about interactive state.
    /// </summary>
    property HasInteractiveSelectors: Boolean read FHasInteractiveSelectors;
    property CustomProps: TDictionary<string, string> read FCustomProps;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Computed Style
  // ─────────────────────────────────────────────────────────────────────────

  TEdgeValues = record
    Top, Right, Bottom, Left: Single;
    procedure Clear;
    procedure SetAll(V: Single);
    function Horz: Single;   // Left + Right
    function Vert: Single;   // Top + Bottom
    function Any: Boolean;   // True if any side > 0
  end;

  TBoxShadow = record
    OffsetX: Single;
    OffsetY: Single;
    BlurRadius: Single;
    SpreadRadius: Single;
    Color: TAlphaColor;
    Inset: Boolean;
    Active: Boolean;  // True when a box-shadow has been set
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
    BorderColors: array[0..3] of TAlphaColor;  // Top, Right, Bottom, Left
    BorderWidths: TEdgeValues;
    BorderRadius: Single;
    BorderRadii: array[0..3] of Single;  // TL, TR, BR, BL — -1 means inherit from BorderRadius
    ExplicitWidth: Single;
    ExplicitHeight: Single;
    Display: string;
    WhiteSpace: string;
    BoxSizing: string;
    CSSCursor: string;
    TextTransform: string;
    Opacity: Single;
    MinWidth: Single;
    MaxWidth: Single;
    MinHeight: Single;
    MaxHeight: Single;
    LetterSpacing: Single;
    TextIndent: Single;
    Visibility: string;
    ListStyleType: string;
    Overflow: string;
    // overflow-x / overflow-y: per-axis scroll control. CSS allows each axis
    // independent — e.g. `overflow-x: hidden; overflow-y: auto` makes a div
    // that scrolls vertically but clips horizontally. The legacy `Overflow`
    // field is kept as a parser landing point for the shorthand and text-
    // overflow detection, but painting/scrolling uses OverflowX/OverflowY.
    OverflowX: string;
    OverflowY: string;
    WordBreak: string;
    OverflowWrap: string;
    TextOverflow: string;
    BoxShadow: TBoxShadow;
    ObjectFit: string;     // 'fill' (default), 'cover', 'contain', 'none', 'scale-down'
    BackgroundImage: string; // URL from background-image: url(...)
    BackgroundSize: string;  // 'auto', 'cover', 'contain', or explicit size
    CSSPosition: string;   // 'static', 'relative', 'absolute', 'fixed', 'sticky'
    CSSTop: Single;        // top offset for sticky/absolute positioning (-1 = not set)
    CSSLeft: Single;
    CSSRight: Single;
    CSSBottom: Single;
    // CSS `outline` — drawn on TOP of the border-box edge, doesn't affect
    // layout. `outline-offset` shifts the rectangle outward (positive) or
    // inward (negative). Negative offsets are useful for status indicators
    // that want to stay inside a card's border-radius.
    OutlineWidth: Single;
    OutlineColor: TAlphaColor;
    OutlineStyle: string;       // 'solid' | 'dashed' | 'dotted' | 'none'
    OutlineOffset: Single;
    // CSS `float`: 'none' (default) | 'left' | 'right'. Only honoured in
    // block-flow context — a floated child of an inline-formatting parent
    // currently still flows inline. Floats are taken out of normal flow:
    // a left float occupies the parent's left edge at the current cursor
    // Y, the next non-float sibling positions to its right with reduced
    // width. The parent's content height stretches to enclose any float
    // that would otherwise overhang.
    CSSFloat: string;
    // CSS Flexbox (subset). The container has FlexDirection / JustifyContent
    // / AlignItems / FlexGap; flex items have FlexGrow / FlexShrink /
    // FlexBasis. `flex: 1` sets grow=1, shrink=1, basis=0. flex-wrap and
    // baseline alignment are not yet supported.
    FlexDirection: string;     // 'row' (default) | 'column' | 'row-reverse' | 'column-reverse'
    JustifyContent: string;    // 'flex-start' (default) | 'flex-end' | 'center' | 'space-between' | 'space-around' | 'space-evenly'
    AlignItems: string;        // 'stretch' (default) | 'flex-start' | 'flex-end' | 'center'
    FlexGrow: Single;          // 0 = don't grow (default)
    FlexShrink: Single;        // 1 = shrink to fit (default)
    FlexBasis: Single;         // -1 = auto (use width/height)
    FlexGap: Single;           // 0 = no gap (default) — applies between items along main axis
    // text-shadow: offsetX offsetY [blur] color
    TextShadowOffsetX: Single;
    TextShadowOffsetY: Single;
    TextShadowBlur: Single;
    TextShadowColor: TAlphaColor;
    TextShadowActive: Boolean;
    // background-position: stored as percentage (negative sentinel < -1) or
    // explicit pixel offset. -50 means 50%; +20 means 20px from left/top.
    // Default is 0% / 0% (top-left), which Tina4 already painted before;
    // for `background-size: cover` the cropped source still centres.
    BgPosX: Single;
    BgPosY: Single;
    // background-repeat: 'no-repeat' (default) | 'repeat' | 'repeat-x' | 'repeat-y'
    BgRepeat: string;
    // Linear gradient: start/end color + angle (degrees, 0=top, 90=right).
    // When BgGradientActive, the gradient is painted UNDER any
    // background-image. Multi-stop gradients are not yet supported.
    BgGradientStart: TAlphaColor;
    BgGradientEnd: TAlphaColor;
    BgGradientAngle: Single;     // degrees clockwise from `to top`
    BgGradientActive: Boolean;
    // CSS transforms (subset): translate/translateX/translateY, rotate, scale.
    // Applied as a single matrix at paint time around the element's
    // border-box centre. matrix() / matrix3d() / 3D transforms not yet
    // supported.
    TransformActive: Boolean;
    TransformTranslateX: Single;
    TransformTranslateY: Single;
    TransformRotate: Single;       // degrees clockwise
    TransformScaleX: Single;
    TransformScaleY: Single;
    // CSS `clear`: 'none' (default) | 'left' | 'right' | 'both'
    // Pushes the box's top edge past any active float on the indicated
    // side. Honoured by LayoutBlock's float pass.
    CSSClear: string;
    procedure SetBorderWidth(W: Single);
    procedure SetBorderColor(C: TAlphaColor);
    function BorderColor: TAlphaColor;  // returns Top color (legacy compat)
    function CornerRadius(Index: Integer): Single;  // 0=TL, 1=TR, 2=BR, 3=BL
    function HasUniformRadius: Boolean;
    function MaxCornerRadius: Single;
    class function Default: TComputedStyle; static;
    class function ForTag(Tag: THTMLTag; const ParentStyle: TComputedStyle; StyleSheet: TCSSStyleSheet = nil): TComputedStyle; static;
    class procedure ApplyDeclarations(Decls: TCSSDeclarations; var Style: TComputedStyle; const ParentStyle: TComputedStyle); static;
    class procedure ExtractBgImageUrl(const Value: string; out Url: string); static;
    class function ParseColor(const S: string): TAlphaColor; static;
    class function ParseLength(const S: string; EmSize: Single = 14): Single; static;
    class procedure ParseEdgeShorthand(const S: string; var E: TEdgeValues; EmSize: Single); static;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Layout Box
  // ─────────────────────────────────────────────────────────────────────────

  TLayoutBoxKind = (lbkBlock, lbkInline, lbkInlineBlock, lbkText, lbkTable,
    lbkTableRow, lbkTableCell, lbkListItem, lbkImage, lbkFormControl, lbkHR, lbkBR);

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
    // Intrinsic content size BEFORE clamping to ExplicitHeight/MaxHeight.
    // ScrollWidth/ScrollHeight represent what the children actually need,
    // used to compute scroll range and scrollbar thumb sizes when the box
    // has `overflow: auto/scroll`. If the box is not scrollable these are
    // simply == ContentWidth/ContentHeight.
    ScrollWidth: Single;
    ScrollHeight: Single;
    // Current scroll offset within this box (independent of viewport scroll)
    ScrollX: Single;
    ScrollY: Single;
    Children: TObjectList<TLayoutBox>;
    Fragments: TList<TTextFragment>;
    ListIndex: Integer;
    IsOrdered: Boolean;
    // Cached subtree facts, populated during BuildBoxTree. Used by the
    // paint pass to skip the two-pass position-segregated walk when the
    // subtree contains nothing that requires it. A repaint of an entire
    // tree of plain `<div>`s should not pay any per-box cost for sticky
    // and positioned-stacking segregation that adds zero visible work.
    HasStickyDescendant: Boolean;     // self or any descendant has position:sticky
    HasPositionedDescendant: Boolean; // self or any descendant has non-static position
    constructor Create(ATag: THTMLTag; AKind: TLayoutBoxKind);
    destructor Destroy; override;
    function MarginBoxWidth: Single;
    function MarginBoxHeight: Single;
    function ContentLeft: Single;
    function ContentTop: Single;
    // Is the box allowed to scroll on an axis (i.e. overflow is not 'visible')?
    function IsScrollableX: Boolean;
    function IsScrollableY: Boolean;
    // Does it currently need a visible scrollbar (content bigger than viewport)?
    function NeedsScrollBarX: Boolean;
    function NeedsScrollBarY: Boolean;
    // Clamp ScrollX/ScrollY to valid range based on content vs viewport.
    procedure ClampOwnScroll;
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
    // Pooled TTextLayout used for width/height measurements during layout.
    // Constructing TTextLayout is expensive on FMX (allocates HarfBuzz /
    // platform-specific layout engine), so we lazy-create one per engine
    // and reset it via BeginUpdate/EndUpdate per measurement. The pool
    // pays off because MeasureTextWidth fires once per word during inline
    // layout — hundreds of times on a text-heavy page.
    FMeasureLayout: TTextLayout;
    function GetMeasureLayout: TTextLayout;
    function BuildBoxTree(Tag: THTMLTag; const ParentStyle: TComputedStyle): TLayoutBox;
    procedure LayoutBlock(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutInlineChildren(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutTable(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutFlex(Box: TLayoutBox; AvailWidth: Single);
    procedure LayoutAbsoluteChildren(Box: TLayoutBox);
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

  /// <summary>Event for form control changes and clicks (Name = control name, Value = current value).</summary>
  THTMLFormControlEvent = procedure(Sender: TObject; const Name, Value: string) of object;
  /// <summary>Event for form submission (FormName = form name attribute, FormData = name=value pairs).</summary>
  THTMLFormSubmitEvent = procedure(Sender: TObject; const FormName: string; FormData: TStrings) of object;
  /// <summary>Event for onclick attribute handling when RTTI invocation is not available.</summary>
  THTMLElementClickEvent = procedure(Sender: TObject; const ObjectName, MethodName: string; Params: TStrings) of object;
  /// <summary>
  /// Fired when an `onclick="Obj:Method(args)"` dispatch fails because
  /// the registered object can't be found, the method doesn't exist,
  /// the parameter count doesn't match, or invocation raised an
  /// exception. `Reason` is a short human-readable explanation. Use
  /// this for diagnostic logging during development — silent click
  /// drops are otherwise invisible.
  /// </summary>
  THTMLUnresolvedClickEvent = procedure(Sender: TObject;
    const ObjectName, MethodName: string; Params: TStrings;
    const Reason: string) of object;
  /// <summary>
  /// Diagnostic hook fired when a CSS rule fails to parse cleanly. Currently
  /// emitted for selectors that produce zero declarations (a malformed rule
  /// or one whose declaration block is entirely unrecognised). Useful for
  /// dev-time logging — without it, broken CSS just silently disappears.
  /// </summary>
  THTMLCssParseErrorEvent = procedure(Sender: TObject;
    const Selector, Reason: string) of object;
  /// <summary>Event for anchor link clicks. Set Handled := True to prevent default processing.</summary>
  THTMLLinkClickEvent = procedure(Sender: TObject; const AURL: string; var Handled: Boolean) of object;
  /// <summary>Event fired when the scroll position changes (wheel, drag, or programmatic).</summary>
  TTina4ScrollEvent = procedure(Sender: TObject; ScrollX, ScrollY: Single) of object;

  TNativeFormControl = record
    Control: TControl;
    Box: TLayoutBox;
  end;

  TClickableRegion = record
    Rect: TRectF;
    Tag: THTMLTag;
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
    // Pooled TTextLayout for paint — mirror of TLayoutEngine.FMeasureLayout
    // but lives on the renderer because paint sites need it. PaintText
    // and the ellipsis / shadow / form-control paths all share it; they
    // run sequentially within a single paint pass, so reconfiguring
    // between uses is safe.
    FPaintLayout: TTextLayout;
    FScrollX: Single;
    FScrollY: Single;
    // Absolute Y of the nearest scroll-ancestor's content-top during paint.
    // Sticky elements pin against this value plus their `top` offset, so a
    // sticky <th> inside an `overflow-y:auto .cart` correctly sticks to the
    // cart's visible top edge — not the viewport's Y=0. Threaded through
    // PaintBox (saved/restored on entry to each scroll container) instead of
    // an extra parameter, since most callers don't care.
    FStickyAnchorY: Single;
    FStickyAnchorX: Single;  // mirror of FStickyAnchorY for horizontal sticky
    // Bottom / right edges of the nearest scroll-ancestor's content area
    // in absolute paint coords. Used for bottom-sticky (`<tfoot>` pinned
    // to the bottom of a scroll container) and right-sticky (last column
    // pinned to the right of a horizontal scroll strip). Saved/restored
    // alongside the top/left anchors per scroll subtree.
    FStickyAnchorBottom: Single;
    FStickyAnchorRight: Single;
    // Pseudo-class state tracking. The renderer owns the chain of currently
    // hovered / active tags so :hover / :active selectors update at runtime
    // without a full DOM rebuild. Each entry's IsHovered / IsActive flag is
    // toggled when this list changes; the renderer triggers Repaint on
    // change so style cascade re-evaluates.
    FHoverChain: TList<THTMLTag>;   // nil-or-list, deepest first
    FActiveChain: TList<THTMLTag>;
    FContentWidth: Single;
    FContentHeight: Single;
    FNeedRelayout: Boolean;
    FParserDirty: Boolean;
    // FHTML.Text of the last layout that completed WITHOUT a fault. The
    // DoLayout recovery ladder re-renders this known-good markup when the
    // current screen faults, so a contained AV restores the PREVIOUS screen
    // instead of going blank (customer: "no blank screens", 2026-06-12).
    FLastGoodHTML: string;
    FScrollBarWidth: Single;
    FOnScroll: TTina4ScrollEvent;
    FIsLayoutting: Boolean;
    FMouseDownOnScroll: Boolean;
    FScrollDragStart: Single;
    FScrollDragThumbStart: Single;
    // Per-box scrollbar drag state: which box's scrollbar is being dragged,
    // which axis, and the content-rect origin of that box at drag start.
    FDragScrollBox: TLayoutBox;
    FDragScrollAxis: Integer;  // 0 = none, 1 = vertical, 2 = horizontal
    FDragScrollBoxCX, FDragScrollBoxCY: Single;
    FDragStartPos: Single;
    FDragStartScroll: Single;
    // Most recently hovered scrollable box — used to route mousewheel deltas
    // to an inner container rather than the viewport when the cursor is over it.
    FHoverScrollBox: TLayoutBox;
    FHoverScrollBoxCX, FHoverScrollBoxCY: Single;
    // Touch/mouse pan-to-scroll state. Lets the user drag the *content* of a
    // scrollable container (including the viewport) to scroll it — the primary
    // scroll gesture on mobile. FPanBox = nil when inactive, = Self-as-marker
    // (using a sentinel) when panning the viewport, or = the inner scrollable
    // box otherwise. FPanActive flips true once the cursor moves past a small
    // threshold, which both activates scrolling and suppresses the click on
    // mouse-up.
    FPanBox: TLayoutBox;
    FPanIsViewport: Boolean;
    FPanActive: Boolean;
    FPanLockedAxis: Integer;  // 0 = undecided, 1 = vertical, 2 = horizontal
    FPanStartX, FPanStartY: Single;
    FPanStartScrollX, FPanStartScrollY: Single;
    FPanViewportStartScrollX, FPanViewportStartScrollY: Single;
    FPanLastX, FPanLastY: Single;       // previous move position for velocity
    FPanLastTick: Cardinal;             // tick of previous move
    FPanVelocityX, FPanVelocityY: Single; // pixels/ms at release
    // Inertia timer — decays velocity after finger lifts
    FInertiaTimer: TTimer;
    FInertiaBox: TLayoutBox;            // nil = viewport inertia
    FInertiaVX, FInertiaVY: Single;     // current velocity (decaying)
    FDebugLastMouseX, FDebugLastMouseY: Single;
    FDebugMouseHit: Boolean;
    FDebugOverlay: Boolean;
    FDebugBoxOverlay: Boolean;
    // Scrollbar fade — scrollbars are fully visible for a short window after
    // any scroll activity, then fade out. Mobile-friendly default so bars
    // don't clutter the content when idle. FScrollbarLastActivity is a tick
    // count; FScrollbarFadeTimer runs while a fade is in progress to drive
    // repaints.
    FScrollbarLastActivity: Cardinal;
    FScrollbarFadeTimer: TTimer;
    // Coalesces resize-driven relayouts. The soft-keyboard slide animation
    // fires many resize events; relaying out (esp. the heavy POS grid still
    // visible under an overlay) on each one saturates the UI thread during
    // the keyboard's window-surface transaction and stalls the MTK
    // compositor (sync-point timeout -> process killed). Restart this short
    // timer on every resize and relayout only ONCE after the size settles.
    FResizeTimer: TTimer;
    // Set when a settle-timer relayout was suppressed because the soft keyboard
    // was up (a keyboard-driven resize needs no relayout — the HTML content
    // doesn't reflow for a keyboard overlay). Serviced once on keyboard-down so
    // any genuine geometry change that happened to land during the keyboard
    // window is still reflected. Defeats the N-renderer relayout storm that
    // saturates the MTK surface transaction and steals focus mid-IME-bind.
    FRelayoutAfterKbd: Boolean;
    FScrollBarsVisible: Boolean;
    FScrollBarOverlay: Boolean;
    // Preserves per-box ScrollX/ScrollY across relayouts. The layout tree is
    // rebuilt from scratch each pass, so without this the user's scroll
    // position in inner divs would reset every relayout. Keyed by DOM tag.
    FBoxScrollState: TDictionary<THTMLTag, TPointF>;
    FFormControls: TList<TNativeFormControl>;
    // Bumped every time ClearFormControls runs (i.e. every relayout that
    // rebuilds the native peers). Deferred actions that captured a TEdit
    // reference compare the gen they saw at queue-time against the
    // current one — if it advanced, the captured edit may already be
    // DisposeOf'd, so they must no-op.
    FFormControlsGen: NativeUInt;
    FClickableRegions: TList<TClickableRegion>;
    FRegisteredObjects: TDictionary<string, TObject>;
    /// <summary>
    /// Long-lived TRttiContext shared across every onclick="Object:Method()"
    /// dispatch. Pre-2026-06-05 we created+freed a per-call TRttiContext
    /// inside FireOnClick, but TRttiContext is a record wrapper over a
    /// REFERENCE-COUNTED pool — if the invoked method (e.g. an
    /// HtmlBackClick handler) itself uses RTTI on any code path, the
    /// nested Create/Free can drop the pool ref count to zero mid-call
    /// and invalidate the TRttiMethod we're holding. The next time
    /// anything tries to dereference it (or the Delphi RTL tries to
    /// destroy the now-orphaned TRttiObject during teardown), we crash
    /// with EAccessViolation followed by
    ///     EInvalidOpException: RTTI objects cannot be manually destroyed
    ///     by application code
    /// Owning the context for the renderer's whole lifetime keeps the
    /// pool ref count >= 1 throughout, so no nested Create/Free can
    /// ever drop it to zero while a dispatch is in flight.
    /// </summary>
    FRttiCtx: TRttiContext;
    FOnChange: THTMLFormControlEvent;
    FOnClick: THTMLFormControlEvent;
    FOnEnter: THTMLFormControlEvent;
    FOnExit: THTMLFormControlEvent;
    // When True (default), the renderer rebuilds its native form
    // controls whenever focus leaves the renderer entirely (i.e. the
    // newly focused control is NOT another input inside this same
    // renderer's child tree). Defends against the FMX Android
    // Platform-TEdit refocus AV at presenter offset 0x0C: after a
    // visibility/focus cycle, the stale presenter is replaced by a
    // fresh one before the user's next tap.
    FRerenderOnFocus: Boolean;
    // Used by HandleFormControlExit's deferred check to verify focus
    // has truly left the renderer (vs. simply moved to a sibling input).
    FPendingRerender: Boolean;
    FOnSubmit: THTMLFormSubmitEvent;
    FOnElementClick: THTMLElementClickEvent;
    FOnUnresolvedClick: THTMLUnresolvedClickEvent;
    FOnCssParseError: THTMLCssParseErrorEvent;
    FOnLinkClick: THTMLLinkClickEvent;
    FFrond: TStringList;
    FFrondEngine: TObject;        // TTina4Frond (declared in implementation uses)
    FFrondTemplatePath: string;
    // Virtual-keyboard state — set by VKStateChangeHandler when FMX
    // broadcasts TVKStateChangeMessage. Used to scroll the focused
    // input above the keyboard on iOS (Android adjustResize already
    // shrinks Self.Height so the math falls through naturally).
    FKeyboardVisible: Boolean;
    FKeyboardBounds: TRect;
    // The native input the Android IME is (or is about to be) bound to. Set
    // from OnEnter (the focus tap that starts the IME bind) and held until the
    // keyboard is confirmed DOWN (VKStateChangeHandler visible=False = IME
    // released). FKeyboardVisible alone is NOT enough: it only goes True once
    // the keyboard is fully up, leaving the slide-up window (IME binding, but
    // FKeyboardVisible still False) unguarded — and that is exactly when a
    // relayout storm disposed a just-tapped, just-blurred input out from under
    // the binding IME and killed the process. ClearFormControls never frees
    // this control inline; it defers it to keyboard-down like the focused one.
    FImeBoundCtl: TControl;
    FVKSubscriptionId: Integer;
    // Coalescing flag for ScrollFocusedControlAboveKeyboard. FMX re-fires
    // the virtual-keyboard frame-change message on every decor-view layout
    // change (every frame of the keyboard slide-in animation). Without
    // this, each fire queues another scroll, flooding the message loop and
    // starving input -> ANR on slow devices. Only one scroll may be in
    // flight at a time.
    FScrollAboveKbQueued: Boolean;
    // Controls detached during a relayout while the soft keyboard was up,
    // awaiting safe disposal. A focused TEdit must NOT be freed while the
    // Android IME still holds its InputConnection (async release) — doing so
    // crashes (sync) or hangs the IME (next-tick defer). We hold it here,
    // detached from view, and free it only once the keyboard is confirmed
    // DOWN (VKStateChange visible=False) — the definite IME-release point.
    FPendingDispose: TArray<TControl>;
    // Set by DoLayout to the currently-focused form control (and its DOM id)
    // so a relayout REUSES it instead of disposing + recreating it. Keeps
    // the Android IME bound to one live TEdit across an in-render value
    // change / re-render (lookup result, live balance) — the core of the
    // "transfer corrupts the IME, next screen crashes" fix.
    FReuseCtl: TControl;
    FReuseId: string;
    // Reuse pool: id -> existing TEdit/TMemo (EXCLUDING FReuseCtl), snapshotted
    // by DoLayout each relayout BEFORE the boxes are freed. CreateFormControls
    // re-adopts every input by id from here instead of dispose+recreate, so NO
    // native control (and its live Android IME InputConnection) churns across a
    // relayout. That removes the surface op that stalls the MT6761 compositor
    // when a relayout coincides with a keyboard transition (the Electricity
    // "Process with no amount -> focus" freeze), makes programmatic FocusElement
    // safe to call anywhere, and speeds up every relayout (no native re-create).
    FReusePool: TDictionary<string, TControl>;
    // True only while ClearFormControls is disposing controls. During that
    // window FFormControls still references boxes already freed by the reparse,
    // and DisposeOf fires OnEnter/OnExit/OnChange synchronously — the event
    // handlers check this flag and bail so none walks the stale list (the async
    // use-after-free SIGSEGV the harness reproduced at C16A144A / C179B4EA).
    FDisposingControls: Boolean;
    /// <summary>
    /// "We've already asked FMX to show the soft keyboard for the
    /// currently-focused input" flag. Set by RequestKeyboardShow when
    /// it dispatches a ShowVirtualKeyboard call; cleared by
    /// VKStateChangeHandler when the platform reports the keyboard
    /// has gone down (visible=False). RequestKeyboardShow gates on
    /// this — if True, it skips the Show entirely, so back-to-back
    /// focus events (taps between inputs, programmatic re-focus on
    /// re-render) don't redundantly poke the IMM.
    /// </summary>
    FKbdShowAsked: Boolean;
    /// <summary>
    /// "We wanted the keyboard but skipped Show because FKbdShowAsked
    /// was already True." Set by RequestKeyboardShow on the skip-path.
    /// Consulted by VKStateChangeHandler on visible=False: if True and
    /// a TEdit/TMemo currently has focus, the dismiss was likely a
    /// side effect of a re-render-driven button tap (not a deliberate
    /// user dismiss), so re-fire ShowVirtualKeyboard on the focused
    /// control. Cleared after re-summon or after a successful Show.
    /// </summary>
    FKbdResummonPending: Boolean;
    procedure ScrollbarFadeTimerTick(Sender: TObject);
    procedure BumpScrollbarVisibility;
    function GetScrollbarOpacity: Single;
    procedure SetScrollBarOverlay(const Value: Boolean);
    procedure InertiaTimerTick(Sender: TObject);
    procedure SetHTML(const Value: TStringList);
    function GetHTML: TStringList;
    procedure SetCacheEnabled(Value: Boolean);
    procedure SetCacheDir(const Value: string);
    procedure FHTMLChange(Sender: TObject);
    procedure SetFrond(const Value: TStringList);
    function GetFrond: TStringList;
    procedure FFrondChange(Sender: TObject);
    procedure CssParseErrorRelay(Sender: TObject; const Selector, Reason: string);
    procedure RenderFrond;
    procedure SetFrondTemplatePath(const Value: string);
    procedure OnImageLoaded(Sender: TObject);
    procedure DoLayout;
    procedure ClearFormControls;
    procedure DrainPendingDispose;
    procedure ResizeSettleTick(Sender: TObject);
    procedure CreateFormControls(Box: TLayoutBox; OffX, OffY: Single);
    procedure PositionFormControls;
    procedure HandleFormControlChange(Sender: TObject);
    procedure HandleFileInputClick(Sender: TObject);
    procedure HandleFormControlEnter(Sender: TObject);
    procedure HandleFormControlExit(Sender: TObject);
    /// <summary>
    /// Idempotently request the Android/iOS soft keyboard for a
    /// TControl that just received focus. Never calls
    /// HideVirtualKeyboard (which would visibly bounce the IME when
    /// it's already up). Instead, fires ShowVirtualKeyboard at three
    /// staggered main-thread ticks via TTimer — first immediately
    /// (queued), then ~80ms later, then ~200ms later. If the first
    /// Show races a pending dismiss from a prior button tap and
    /// loses, one of the later re-fires lands after the dismiss
    /// completes. When the IME is already visible (e.g. user is
    /// tapping between two TEdits without dismissing), each Show is
    /// a no-op and Android re-binds the IME to the new control
    /// automatically — zero visible toggle. No-op on platforms
    /// without IFMXVirtualKeyboardService.
    /// </summary>
    procedure RequestKeyboardShow(ACtl: TControl);
    {$IFDEF ANDROID}
    /// <summary>
    /// Force-shows the Android soft keyboard via direct JNI to
    /// InputMethodManager.showSoftInput with SHOW_FORCED on the
    /// activity's decor view. Bypasses Android's anti-spawn check
    /// that silently drops Show requests from un-touched windows
    /// (the root cause of "autofocus doesn't work on screen entry").
    /// Idempotent when the keyboard is already up.
    /// </summary>
    procedure ForceShowSoftKeyboard;
    {$ENDIF}
    // RerenderOnFocus implementation — full DOM/form-control rebuild
    // with id-based value preservation. Internal use only; the
    // public surface is the RerenderOnFocus property.
    procedure RebuildFormControlsPreservingValues;
    procedure HandleFormControlKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: WideChar; Shift: TShiftState);
    procedure ApplyHtmlInputAttrsToEdit(Box: TLayoutBox; Ed: TEdit);
    function CollectFormData(FormTag: THTMLTag): TStringList;
    procedure SubmitFormFor(Ctl: TControl);
    function FindNextFocusableFormControl(Ctl: TControl): TControl;
    procedure HideVirtualKeyboardIfAny;
    // Virtual keyboard state listener — updates FKeyboardVisible /
    // FKeyboardBounds and scrolls the focused input into the visible
    // area when the keyboard comes up.
    procedure VKStateChangeHandler(const Sender: TObject;
      const M: System.Messaging.TMessage);
    procedure ScrollFocusedControlAboveKeyboard;
    function GetKeyboardOverlapHeight: Single;
    function GetFormControlNameValue(Control: TControl; out AName, AValue: string): Boolean;
    function ResolveOnClickParam(const Expr: string; ClickedTag: THTMLTag): string;
    procedure FireOnClick(ClickedTag: THTMLTag);
    procedure PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single;
      AStickyMode: Integer = 0);
      // 0 = normal (paint everything in DOM order with sticky-last
      //     among direct siblings — used outside scroll containers and as
      //     the inner mode once inside a sticky subtree)
      // 1 = non-sticky pass: paint everything except sticky elements; if
      //     this box is sticky, return immediately. Used by scroll
      //     containers to do background pass before pinning sticky on top.
      // 2 = sticky pass: don't paint non-sticky boxes themselves but still
      //     recurse to find sticky descendants. When a sticky descendant
      //     is found, paint it (with pinning) and switch its subtree to
      //     normal mode. Skip nested scroll containers (they handle their
      //     own sticky descendants internally).
    procedure PaintBoxShadow(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintBackground(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintOutline(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintBoxOverlay(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single);
    procedure BuildRoundedRectPath(Path: TPathData; const R: TRectF;
      RTL, RTR, RBR, RBL: Single);
    procedure FillRoundedRect(Canvas: TCanvas; const R: TRectF;
      RTL, RTR, RBR, RBL: Single; AOpacity: Single);
    procedure StrokeRoundedRect(Canvas: TCanvas; const R: TRectF;
      RTL, RTR, RBR, RBL: Single; AOpacity: Single);
    procedure PaintText(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintImage(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintHR(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintListMarker(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintTableCellBorders(Canvas: TCanvas; Box: TLayoutBox; CX, CY: Single);
    procedure PaintScrollBar(Canvas: TCanvas);
    // Per-box scrollbar helpers — used when a box has overflow: auto/scroll
    // and its content exceeds its viewport on one or both axes.
    procedure GetBoxScrollBarRects(Box: TLayoutBox; CX, CY: Single;
      out VTrack, VThumb, HTrack, HThumb: TRectF;
      out HasV, HasH: Boolean);
    procedure PaintBoxScrollBars(Canvas: TCanvas; Box: TLayoutBox;
      CX, CY: Single);
    // Hit-test helper: HX/HY are in widget-local coords. Returns True if
    // (HX,HY) lies on a scrollbar of Box (with content origin CX,CY) and
    // sets Axis (1=vertical, 2=horizontal). OnThumb indicates thumb vs track.
    function HitTestBoxScrollBar(Box: TLayoutBox; CX, CY: Single;
      HX, HY: Single; out Axis: Integer; out OnThumb: Boolean): Boolean;
    // Walk the layout tree from Root and return the innermost scrollable
    // box whose padding-box contains (HX,HY). Used to route mousewheel
    // and hover tracking to inner scrolled containers. OutCX/OutCY receive
    // the absolute content origin of the returned box (so callers don't
    // have to re-walk). Returns nil if no scrollable ancestor is found.
    function FindScrollableAncestor(HX, HY: Single;
      out OutCX, OutCY: Single): TLayoutBox;
    function ScrollBarVisible: Boolean;
    procedure ClampScroll;
    procedure SetScrollX(const Value: Single);
    procedure SetScrollY(const Value: Single);
    function GetViewportWidth: Single;
    function GetViewportHeight: Single;
    function FindLayoutBoxByTag(Box: TLayoutBox; Target: THTMLTag): TLayoutBox;
    /// <summary>
    /// In-place text update of a laid-out box's text fragment WITHOUT a
    /// relayout. Used by SetElementText when a form control is focused
    /// (IME bound) — a full relayout would dispose the focused TEdit and
    /// hang the IME. Single-fragment replacement; correct for single-line
    /// display elements (e.g. a balance label).
    /// </summary>
    procedure UpdateBoxTextInPlace(Box: TLayoutBox; const NewText: string);
    function GetPaintLayout: TTextLayout;
    function HitTestTagAt(Box: TLayoutBox; OffX, OffY, X, Y: Single): THTMLTag;
    procedure UpdatePseudoChain(Chain: TList<THTMLTag>; NewLeaf: THTMLTag;
      const FlagName: string);
    function GetBoxAbsolutePosition(Target: TLayoutBox; out AX, AY: Single): Boolean;
    procedure DoScrollChanged;
    procedure InsertHTMLFragment(Target: THTMLTag; const Html: string; AtFront: Boolean);
  protected
    // Purge a just-freed native control from FFormControls + all cached
    // pointers. Without this a control freed elsewhere (keyboard-down drain,
    // ANOTHER renderer's teardown, FMX) stays in our FFormControls and is later
    // read by SetElementValue / FocusElement / etc. as a live TEdit -> AV
    // (use-after-free). Registered via FreeNotification on every form control.
    // Protected to match TControl's declaration (was private — H2269).
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseWheel(Shift: TShiftState; WheelDelta: Integer;
      var Handled: Boolean); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Single); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Single); override;
    // CMGesture override removed — MouseDown/Move/Up handle pan on all
    // platforms including Android. CMGesture added latency and caused
    // double-handling conflicts with MouseMove.
  public
    /// <summary>Creates the HTML renderer and initialises internal caches, parser, and layout engine.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Frees all internal objects, form controls, caches, and the DOM tree.</summary>
    destructor Destroy; override;
    /// <summary>Clears the in-memory image cache and the on-disk file cache.</summary>
    procedure ClearCache;
    /// <summary>
    /// Demotes every native form-control TEdit/TMemo to ControlType.Styled so
    /// the Android peer is cleanly torn down. Call this immediately BEFORE
    /// hiding the renderer (Visible := False), so the IME doesn't end up
    /// bound to a peer that's about to be detached from the view hierarchy.
    /// On non-Android/iOS platforms this is a no-op.
    /// </summary>
    procedure DeactivateNativePeers;
    /// <summary>
    /// Promotes every native form-control TEdit/TMemo back to
    /// ControlType.Platform so the OS picks up the configured keyboard hint
    /// and the native EditText auto-shows on first focus. Call this
    /// immediately AFTER showing the renderer (Visible := True). Done
    /// OUTSIDE any FMX focus event so the presenter rebuild can't tear
    /// down a live focus chain (which AVs at offset 0x0C on Sunmi Android
    /// 11 when triggered from inside OnEnter).
    /// </summary>
    procedure ActivateNativePeers;
    /// <summary>
    /// Registers a Delphi object for direct RTTI method invocation from HTML
    /// onclick attributes. Format: onclick="ObjectName:MethodName(params)".
    /// </summary>
    /// <param name="Name">The name used to reference this object in onclick attributes.</param>
    /// <param name="Obj">The Delphi object instance whose published methods will be callable.</param>
    procedure RegisterObject(const Name: string; Obj: TObject);
    /// <summary>
    /// Force a full re-parse + re-cascade on the next paint. Use this when
    /// you suspect cached state is masking a fresh Twig.Text / HTML.Text
    /// assignment — clears the stylesheet, the parsed DOM, the file cache
    /// (for external CSS), and any per-paint pseudo-class chains, then
    /// schedules a relayout. The next paint pass will re-parse FHTML.Text
    /// from scratch.
    /// </summary>
    procedure InvalidateAllCaches;
    /// <summary>Removes a previously registered object by name.</summary>
    /// <param name="Name">The registered name to remove.</param>
    procedure UnregisterObject(const Name: string);
    /// <summary>Finds a DOM element by its id attribute. Returns nil if not found.</summary>
    /// <param name="Id">The HTML id attribute value to search for.</param>
    function GetElementById(const Id: string): THTMLTag;
    /// <summary>
    /// Gets the current value of a form element. For native controls (TEdit, TCheckBox, etc.)
    /// returns the live control value; otherwise returns the DOM value attribute.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    function GetElementValue(const Id: string): string;
    /// <summary>
    /// Sets the value of a form element. Updates both the native FMX control
    /// (TEdit, TCheckBox, TComboBox, etc.) and the DOM value attribute.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="Value">The new value to set.</param>
    procedure SetElementValue(const Id: string; const Value: string);
    /// <summary>
    /// Sets any HTML attribute on an element. Triggers relayout for class or
    /// style changes.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="AttrName">The attribute name (e.g. 'class', 'href', 'data-value').</param>
    /// <param name="AttrValue">The new attribute value.</param>
    procedure SetElementAttribute(const Id, AttrName, AttrValue: string);
    /// <summary>
    /// Returns True when the element's `class` attribute contains
    /// ClassName as a whole token. Case-sensitive, matching browser
    /// behaviour. Returns False if the element isn't found.
    /// </summary>
    function HasElementClass(const Id, ClassName: string): Boolean;
    /// <summary>
    /// Adds ClassName to the element's class attribute if it isn't
    /// already there. No-op when already present. Triggers relayout.
    /// </summary>
    procedure AddElementClass(const Id, ClassName: string);
    /// <summary>
    /// Removes ClassName from the element's class attribute if present.
    /// Other classes on the element are preserved. Triggers relayout.
    /// </summary>
    procedure RemoveElementClass(const Id, ClassName: string);
    /// <summary>
    /// Flips ClassName on the element: adds it if absent, removes it
    /// if present. Returns the new state (True = now has the class).
    /// Triggers relayout.
    /// </summary>
    function ToggleElementClass(const Id, ClassName: string): Boolean;
    /// <summary>
    /// "Single-select" pattern: removes ClassName from every element
    /// whose tag matches TagName, then adds it to Id. Perfect for
    /// highlighting one row / tab / nav item at a time from a single
    /// call. TagName comparison is case-insensitive ('TR' = 'tr').
    /// Triggers a single relayout at the end.
    /// </summary>
    procedure SetExclusiveClass(const Id, ClassName, TagName: string);
    /// <summary>
    /// Enables or disables a native form control and adjusts its opacity.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="Enabled">True to enable, False to disable (opacity 0.5).</param>
    procedure SetElementEnabled(const Id: string; Enabled: Boolean);
    /// <summary>
    /// Shows or hides an element by toggling display:none. Triggers relayout.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="Visible">True to show, False to hide.</param>
    procedure SetElementVisible(const Id: string; Visible: Boolean);
    /// <summary>
    /// Updates the inner text content of an element and its native control label.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="Text">The new text content.</param>
    procedure SetElementText(const Id: string; const Text: string);
    /// <summary>
    /// Sets an inline CSS style property on an element. Triggers relayout.
    /// </summary>
    /// <param name="Id">The HTML id of the element.</param>
    /// <param name="StyleProp">CSS property name (e.g. 'background-color', 'display').</param>
    /// <param name="StyleValue">CSS property value (e.g. 'red', 'none').</param>
    procedure SetElementStyle(const Id, StyleProp, StyleValue: string);
    /// <summary>Forces a full re-layout and repaint of the rendered HTML.</summary>
    /// <param name="Id">The HTML id of the element (currently triggers full relayout).</param>
    procedure RefreshElement(const Id: string);
    /// <summary>
    /// Sets a variable in the Frond rendering context. Call before setting
    /// the Frond property to make variables available in templates.
    /// </summary>
    /// <param name="AName">Variable name (used as {{ name }} in Frond templates).</param>
    /// <param name="AValue">Variable value.</param>
    procedure SetFrondVariable(const AName: string; const AValue: string);
    /// <summary>Alias for SetFrondVariable — kept for source-compatibility.</summary>
    procedure SetTwigVariable(const AName: string; const AValue: string);
    /// <summary>Scrolls to an absolute position. Values are clamped to content bounds.</summary>
    /// <param name="X">Absolute horizontal scroll offset in pixels.</param>
    /// <param name="Y">Absolute vertical scroll offset in pixels.</param>
    procedure ScrollTo(X, Y: Single);
    /// <summary>Scrolls by a relative delta from the current scroll position.</summary>
    /// <param name="DX">Horizontal pixels to scroll (positive = right).</param>
    /// <param name="DY">Vertical pixels to scroll (positive = down).</param>
    procedure ScrollBy(DX, DY: Single);
    /// <summary>Scrolls to the top-left of the content (0, 0).</summary>
    procedure ScrollToTop;
    /// <summary>Scrolls to the bottom of the content. Useful for chat / log views.</summary>
    procedure ScrollToBottom;
    /// <summary>Scrolls so the element with the given id is visible in the viewport.</summary>
    /// <param name="Id">The HTML id attribute of the element to scroll into view.</param>
    /// <returns>True if the element was found and scrolled to, False otherwise.</returns>
    /// <summary>
    /// Scrolls the element with the given id into the viewport.
    /// BottomInset shrinks the effective viewport height during the
    /// outer-scroll check — useful for keeping the element above the
    /// on-screen keyboard without a second ScrollBy pass. Defaults
    /// to 0 so existing callers behave identically.
    /// </summary>
    function ScrollToElement(const Id: string;
      BottomInset: Single = 0): Boolean;
    /// <summary>Sets keyboard focus to a native form control (input, textarea, select)
    /// identified by its HTML id attribute. Returns True if the element was found
    /// and focused.</summary>
    function FocusElement(const Id: string): Boolean;
    /// <summary>
    /// Parses an HTML fragment and prepends it as the first children of the
    /// element with the given id. Triggers a synchronous re-layout. When
    /// PreserveScrollPosition is True, the visible content stays anchored —
    /// the scroll offset is shifted by the height added above, so the user's
    /// view does not jump. Use this for "load older items at the top" patterns.
    /// </summary>
    /// <param name="Id">The HTML id of the container element.</param>
    /// <param name="Html">The HTML fragment to parse and insert.</param>
    /// <param name="PreserveScrollPosition">True (default) to keep the visible content anchored.</param>
    /// <returns>True if the element was found and the fragment inserted, False otherwise.</returns>
    function PrependHTML(const Id, Html: string;
      PreserveScrollPosition: Boolean = True): Boolean;
    /// <summary>
    /// Parses an HTML fragment and appends it as the last children of the
    /// element with the given id. Triggers a re-layout.
    /// </summary>
    /// <param name="Id">The HTML id of the container element.</param>
    /// <param name="Html">The HTML fragment to parse and insert.</param>
    /// <returns>True if the element was found and the fragment inserted, False otherwise.</returns>
    function AppendHTML(const Id, Html: string): Boolean;
    /// <summary>
    /// Replaces all children of the element with the given id by parsing
    /// the HTML fragment and inserting the result. Triggers a re-layout.
    /// </summary>
    /// <param name="Id">The HTML id of the container element.</param>
    /// <param name="Html">The HTML fragment to parse and use as the new content.</param>
    /// <returns>True if the element was found and replaced, False otherwise.</returns>
    function SetInnerHTML(const Id, Html: string): Boolean;
  published
    /// <summary>HTML content to render. Changes trigger automatic relayout and repaint.</summary>
    property HTML: TStringList read GetHTML write SetHTML;
    /// <summary>Frond template content. Automatically rendered to HTML via TTina4Frond on change.</summary>
    property Frond: TStringList read GetFrond write SetFrond;
    /// <summary>Base path for Frond {% include %} and {% extends %} resolution.</summary>
    property FrondTemplatePath: string read FFrondTemplatePath write SetFrondTemplatePath;
    /// <summary>Alias for Frond — kept for source-compatibility. Prefer Frond.</summary>
    property Twig: TStringList read GetFrond write SetFrond stored False;
    /// <summary>Alias for FrondTemplatePath — kept for source-compatibility.</summary>
    property TwigTemplatePath: string read FFrondTemplatePath write SetFrondTemplatePath stored False;
    /// <summary>Debug output string list for diagnostic information.</summary>
    property Debug: TStringList read FDebug write FDebug;
    /// <summary>Enables disk-based caching for downloaded images and stylesheets.</summary>
    property CacheEnabled: Boolean read FCacheEnabled write SetCacheEnabled default False;
    /// <summary>Directory path for the disk-based file cache.</summary>
    property CacheDir: string read FCacheDir write SetCacheDir;
    /// <summary>Fires when any form control value changes.</summary>
    property OnFormControlChange: THTMLFormControlEvent read FOnChange write FOnChange;
    /// <summary>Fires when a form control is clicked.</summary>
    property OnFormControlClick: THTMLFormControlEvent read FOnClick write FOnClick;
    /// <summary>Fires when a form control gains focus.</summary>
    property OnFormControlEnter: THTMLFormControlEvent read FOnEnter write FOnEnter;
    /// <summary>Fires when a form control loses focus.</summary>
    property OnFormControlExit: THTMLFormControlEvent read FOnExit write FOnExit;
    /// <summary>
    /// When True (default), the renderer rebuilds its native form
    /// controls whenever focus leaves the renderer entirely — i.e. the
    /// newly focused control isn't another input inside this same
    /// renderer. Existing input values are snapshotted by id and
    /// restored into the freshly-built controls, so the user sees no
    /// data loss. Defends against the FMX Android Platform-TEdit
    /// refocus AV at presenter offset 0x0C: instead of relying on
    /// FMX's broken presenter-rebuild path between focus cycles, we
    /// dispose every native peer and create new ones at a quiet
    /// moment (deferred via ForceQueue after the focus event chain
    /// unwinds). Set to False if you have an alternative strategy
    /// or are targeting a platform without this AV (desktop, iOS).
    /// </summary>
    property RerenderOnFocus: Boolean read FRerenderOnFocus write FRerenderOnFocus default True;
    /// <summary>Fires when a submit button is clicked with form name and name=value data.</summary>
    property OnFormSubmit: THTMLFormSubmitEvent read FOnSubmit write FOnSubmit;
    /// <summary>Fires when an element with onclick attribute is clicked (RTTI fallback).</summary>
    property OnElementClick: THTMLElementClickEvent read FOnElementClick write FOnElementClick;
    /// <summary>
    /// Diagnostic hook fired when an onclick="Obj:Method(...)" call can't
    /// be dispatched. Useful during development — without it, a typo or
    /// `private`-visibility method on the target produces zero feedback.
    /// </summary>
    property OnUnresolvedClick: THTMLUnresolvedClickEvent read FOnUnresolvedClick write FOnUnresolvedClick;
    /// <summary>
    /// Diagnostic hook fired when a CSS rule yields zero declarations
    /// (malformed). Wire it in dev builds to log unrecognised CSS.
    /// </summary>
    property OnCssParseError: THTMLCssParseErrorEvent read FOnCssParseError write FOnCssParseError;
    /// <summary>
    /// Fires when an anchor tag with href is clicked. Set Handled := True to
    /// prevent default processing. Used by TTina4HTMLPages for page navigation.
    /// </summary>
    property OnLinkClick: THTMLLinkClickEvent read FOnLinkClick write FOnLinkClick;
    /// <summary>Current horizontal scroll offset in pixels. Setting clamps to [0..ContentWidth - ViewportWidth].</summary>
    property ScrollX: Single read FScrollX write SetScrollX;
    /// <summary>Current vertical scroll offset in pixels. Setting clamps to [0..ContentHeight - ViewportHeight].</summary>
    property ScrollY: Single read FScrollY write SetScrollY;
    /// <summary>Total width of the laid-out content in pixels (read-only).</summary>
    property ContentWidth: Single read FContentWidth;
    /// <summary>Total height of the laid-out content in pixels (read-only).</summary>
    property ContentHeight: Single read FContentHeight;
    /// <summary>Width of the visible viewport (Width minus vertical scrollbar if visible).</summary>
    property ViewportWidth: Single read GetViewportWidth;
    /// <summary>Height of the visible viewport.</summary>
    property ViewportHeight: Single read GetViewportHeight;
    /// <summary>Fires when the scroll position changes from any source (wheel, drag, programmatic).</summary>
    property OnScroll: TTina4ScrollEvent read FOnScroll write FOnScroll;
    /// <summary>When False, scrollbars are never drawn but pan-to-scroll still works.
    /// Set to False on mobile where scrollbars clutter the UI and swiping is the
    /// primary scroll gesture. Default is True.</summary>
    property ScrollBarsVisible: Boolean read FScrollBarsVisible write FScrollBarsVisible default True;
    /// <summary>When True, scrollbars are thin overlay indicators that don't reserve
    /// layout width and have no track background — iOS/Android style. When False
    /// (default), scrollbars use a 12px track with background. Set True on mobile.</summary>
    property ScrollBarOverlay: Boolean read FScrollBarOverlay write SetScrollBarOverlay default False;
    /// <summary>When True, shows a red dot at the last MouseDown position and
    /// debug info (Width, Height, ContentHeight, pan state). Off by default.</summary>
    property DebugOverlay: Boolean read FDebugOverlay write FDebugOverlay default False;
    /// <summary>
    /// When True, paints a translucent box-model overlay on every laid-out
    /// box: blue border outline, green padding band, orange margin band.
    /// Triggers a full repaint on toggle. Cheap force-multiplier when
    /// debugging "why is this 122px instead of 100px" puzzles.
    /// </summary>
    property DebugBoxOverlay: Boolean read FDebugBoxOverlay write FDebugBoxOverlay default False;
    property Align;
    property Anchors;
    property ClipChildren;
    property Enabled;
    property Height;
    property Margins;
    property Padding;
    property Position;
    property Size;
    property Visible;
    property Width;
  end;

var
  /// <summary>
  /// Host-provided sink for Tina4 trace messages — wire to a
  /// persistent log file (e.g. the app's debug.log writer) so
  /// renderer diagnostics survive a process kill. Assign once at
  /// startup; nil = file logging disabled (logcat still works).
  /// Uses System.SysUtils.TProc<string> to avoid declaring a new
  /// `reference to procedure (...)` type that confused the
  /// compiler's overload resolution for TThread.Synchronize in
  /// downstream units.
  /// </summary>
  Tina4LogSink: TProc<string> = nil;
  /// <summary>
  /// Master tracing switch. When False, TraceLog short-circuits
  /// without touching logcat OR the sink — the cost of every trace
  /// call becomes a single boolean check. Host should set this False
  /// in Release builds to keep the production runtime quiet. Default
  /// is True so library development / Debug builds get full output
  /// out of the box.
  /// </summary>
  Tina4TracingEnabled: Boolean = True;

procedure Register;

implementation

uses
  Tina4Frond
  {$IFDEF ANDROID}
  , Tina4AndroidIME
  {$ENDIF}
  ;

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HTMLRender]);
end;

// Instrumentation logger — routes to Android logcat under the same
// `CuttlefishV2` tag the host uses, so a single `adb logcat -s
// CuttlefishV2:*` filter captures both. No-op on non-Android builds.
procedure TraceLog(const Msg: string);
begin
  // Master gate — Release builds set Tina4TracingEnabled := False so
  // the renderer goes quiet. Skip every downstream cost: no logcat
  // syscall, no sink callback, no string concatenation. Single
  // boolean check per call.
  if not Tina4TracingEnabled then Exit;

  {$IFDEF ANDROID}
  try
    __android_log_write(
      android_LogPriority.ANDROID_LOG_INFO,
      MarshaledAString('CuttlefishV2'),
      MarshaledAString(PAnsiChar(AnsiString('Tina4: ' + Msg))));
  except
  end;
  {$ENDIF}
  if Assigned(Tina4LogSink) then
    try
      var Forwarded: string := 'Tina4: ' + Msg;
      Tina4LogSink(Forwarded);
    except
    end;
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
  FCacheDir := TPath.GetTempPath + 'Tina4Cache';
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
  FilePath := FCacheDir + PathDelim + URLToFileName(URL);
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
    FilePath := FCacheDir + PathDelim + URLToFileName(URL);
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
  FilePath := FCacheDir + PathDelim + URLToFileName(URL);
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
    FilePath := FCacheDir + PathDelim + URLToFileName(URL);
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
  FCustomProps := TDictionary<string, string>.Create;
  FRulesByKey := TObjectDictionary<string, TList<TCSSRule>>.Create([doOwnsValues]);
  FUniversalRules := TList<TCSSRule>.Create;
end;

destructor TCSSStyleSheet.Destroy;
begin
  FCustomProps.Free;
  FUniversalRules.Free;
  FRulesByKey.Free;
  FRules.Free;
  inherited;
end;

procedure TCSSStyleSheet.Clear;
begin
  FRules.Clear;
  FCustomProps.Clear;
  ClearRuleIndex;
end;

procedure TCSSStyleSheet.ClearRuleIndex;
begin
  FRulesByKey.Clear;
  FUniversalRules.Clear;
end;

procedure TCSSStyleSheet.ClassifyRule(Rule: TCSSRule);
// Compute the routing key for a rule based on its LAST selector part
// (the one that selects the tag itself; preceding parts are descendant
// constraints checked at match time). Index the rule under that key.
// Also pre-tokenize the selector so SelectorMatches doesn't repeat the
// Trim/ToLower/Split work on every call.
//
// Examples:
//   `.btn`              -> RoutingKey = '.btn'
//   `.btn.active`       -> RoutingKey = '.btn'   (first class wins)
//   `#submit`           -> RoutingKey = '#submit'
//   `div p.note`        -> RoutingKey = '.note'
//   `input[type=email]` -> RoutingKey = 'input'
//   `*`, `[disabled]`   -> RoutingKey = '' (universal)
var
  Sel, LastPart: string;
  I, DotPos, HashPos, BracketPos, ColonPos: Integer;
  List: TList<TCSSRule>;
begin
  // Pre-tokenize the selector. Lowercase once, split-by-space once.
  Rule.SelectorLower := Rule.Selector.Trim.ToLower;
  Rule.SelectorParts := Rule.SelectorLower.Split([' '], TStringSplitOptions.ExcludeEmpty);

  Sel := Rule.Selector.Trim;
  // Find the last descendant-separated part. Trim trailing combinators.
  I := Sel.LastIndexOf(' ');
  if I >= 0 then LastPart := Sel.Substring(I + 1).Trim
  else LastPart := Sel;
  if LastPart = '' then Exit;

  // Strip any trailing pseudo-class / attribute selector for routing
  // purposes — the routing key is just the tag/class/id of the last
  // simple selector. The full match (incl. pseudo / attr) still runs
  // later in MatchesSingleSelector.
  ColonPos := LastPart.IndexOf(':');
  if ColonPos >= 0 then LastPart := LastPart.Substring(0, ColonPos);
  BracketPos := LastPart.IndexOf('[');
  if BracketPos >= 0 then LastPart := LastPart.Substring(0, BracketPos);

  HashPos := LastPart.IndexOf('#');
  DotPos := LastPart.IndexOf('.');

  if (HashPos >= 0) and ((DotPos < 0) or (HashPos < DotPos)) then
  begin
    // ID first: '#X' or 'tag#X'. Routing key = '#X'.
    var Rest := LastPart.Substring(HashPos + 1);
    var EndPos := Rest.IndexOfAny(['.']);
    if EndPos >= 0 then Rest := Rest.Substring(0, EndPos);
    Rule.RoutingKey := '#' + Rest.ToLower;
  end
  else if DotPos >= 0 then
  begin
    // Class first: '.X', 'tag.X', '.X.Y'. Routing key = '.X' (first class).
    var Rest := LastPart.Substring(DotPos + 1);
    var EndPos := Rest.IndexOfAny(['.', '#']);
    if EndPos >= 0 then Rest := Rest.Substring(0, EndPos);
    Rule.RoutingKey := '.' + Rest.ToLower;
  end
  else if (LastPart <> '') and (LastPart <> '*') then
  begin
    // Plain tag: 'div', 'p'. Lowercase since HTML is case-insensitive.
    Rule.RoutingKey := LastPart.ToLower;
  end
  else
    Rule.RoutingKey := '';

  if Rule.RoutingKey = '' then
    FUniversalRules.Add(Rule)
  else
  begin
    if not FRulesByKey.TryGetValue(Rule.RoutingKey, List) then
    begin
      List := TList<TCSSRule>.Create;
      FRulesByKey.Add(Rule.RoutingKey, List);
    end;
    List.Add(Rule);
  end;
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

    // Skip @rules (media queries, keyframes, etc.) — must find matching '}'
    // by counting brace nesting, since @media blocks contain nested rules
    if SelectorPart.StartsWith('@') then
    begin
      var Depth := 1;
      var J := BraceStart + 1;
      while (J < Length(S)) and (Depth > 0) do
      begin
        if S.Chars[J] = '{' then Inc(Depth)
        else if S.Chars[J] = '}' then Dec(Depth);
        Inc(J);
      end;
      I := J;
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

        // Check if this is a :root or * selector (global custom properties)
        var IsGlobalScope := SameText(TrimmedSel, ':root') or (TrimmedSel = '*');

        for var D in Decls do
        begin
          DeclStr := D.Trim;
          if DeclStr = '' then Continue;
          KV := DeclStr.Split([':'], 2);
          if Length(KV) = 2 then
          begin
            var PropName := KV[0].Trim.ToLower;
            var PropVal := KV[1].Trim;
            // Strip !important (we don't track priority yet but must strip for parsing)
            if PropVal.EndsWith('!important') then
              PropVal := PropVal.Substring(0, PropVal.Length - 10).Trim;
            // Collect CSS custom properties (--var-name) from :root as globals
            if PropName.StartsWith('--') then
            begin
              if IsGlobalScope then
                FCustomProps.AddOrSetValue(PropName, PropVal)
              else
                Rule.Declarations.AddOrSetValue(PropName, PropVal);
            end
            else
              Rule.Declarations.AddOrSetValue(PropName, PropVal);
          end;
        end;

        if Rule.Declarations.Count > 0 then
        begin
          Rule.SourceOrder := FRules.Count;
          FRules.Add(Rule);
          ClassifyRule(Rule);
          // Note any interactive pseudo-class so the renderer can skip
          // mouse-tracking when no rule needs it.
          if (Pos(':hover', TrimmedSel.ToLower) > 0) or
             (Pos(':active', TrimmedSel.ToLower) > 0) or
             (Pos(':focus', TrimmedSel.ToLower) > 0) then
            FHasInteractiveSelectors := True;
        end
        else
        begin
          if Assigned(FOnParseError) then
            FOnParseError(Self, TrimmedSel,
              'rule produced no parsable declarations');
          Rule.Free;
        end;
      end;
    end;

    I := BraceEnd + 1;
  end;
end;

procedure TCSSStyleSheet.AddCSS(const CSSText: string);
begin
  ParseCSS(CSSText);
end;

function TCSSStyleSheet.ResolveVar(const Value: string): string;
var
  VarStart, VarEnd, CommaPos: Integer;
  VarExpr, VarName, Fallback, Resolved: string;
begin
  Result := Value;
  // Resolve all var() references in the value
  VarStart := Result.IndexOf('var(');
  while VarStart >= 0 do
  begin
    // Find matching closing paren
    VarEnd := Result.IndexOf(')', VarStart + 4);
    if VarEnd < 0 then Break;
    VarExpr := Result.Substring(VarStart + 4, VarEnd - VarStart - 4).Trim;
    // Check for fallback: var(--name, fallback)
    CommaPos := VarExpr.IndexOf(',');
    if CommaPos >= 0 then
    begin
      VarName := VarExpr.Substring(0, CommaPos).Trim;
      Fallback := VarExpr.Substring(CommaPos + 1).Trim;
    end
    else
    begin
      VarName := VarExpr;
      Fallback := '';
    end;
    // Look up the custom property
    if FCustomProps.TryGetValue(VarName, Resolved) then
    begin
      // Recursively resolve if the value itself contains var()
      if Resolved.Contains('var(') then
        Resolved := ResolveVar(Resolved);
      Result := Result.Substring(0, VarStart) + Resolved + Result.Substring(VarEnd + 1);
    end
    else if Fallback <> '' then
      Result := Result.Substring(0, VarStart) + Fallback + Result.Substring(VarEnd + 1)
    else
      Break; // Can't resolve, leave as-is
    VarStart := Result.IndexOf('var(');
  end;
end;

function TCSSStyleSheet.ResolveVarWith(const Value: string;
  Props: TDictionary<string, string>): string;
var
  VarStart, VarEnd, CommaPos: Integer;
  VarExpr, VarName, Fallback, Resolved: string;
begin
  Result := Value;
  VarStart := Result.IndexOf('var(');
  while VarStart >= 0 do
  begin
    VarEnd := Result.IndexOf(')', VarStart + 4);
    if VarEnd < 0 then Break;
    VarExpr := Result.Substring(VarStart + 4, VarEnd - VarStart - 4).Trim;
    CommaPos := VarExpr.IndexOf(',');
    if CommaPos >= 0 then
    begin
      VarName := VarExpr.Substring(0, CommaPos).Trim;
      Fallback := VarExpr.Substring(CommaPos + 1).Trim;
    end
    else
    begin
      VarName := VarExpr;
      Fallback := '';
    end;
    if Props.TryGetValue(VarName, Resolved) then
    begin
      if Resolved.Contains('var(') then
        Resolved := ResolveVarWith(Resolved, Props);
      Result := Result.Substring(0, VarStart) + Resolved + Result.Substring(VarEnd + 1);
    end
    else if Fallback <> '' then
      Result := Result.Substring(0, VarStart) + Fallback + Result.Substring(VarEnd + 1)
    else
      Break;
    VarStart := Result.IndexOf('var(');
  end;
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
  RequireHover, RequireActive, RequireFocus: Boolean;
begin
  Result := False;
  if not Assigned(Tag) or (Tag.TagName = '#text') or (Tag.TagName = 'root') then
    Exit;

  // Parse selector into tag, class, id parts
  // e.g., "div.container#main" -> tag=div, class=container, id=main
  SelTag := '';
  SelClass := '';
  SelId := '';
  RequireHover := False;
  RequireActive := False;
  RequireFocus := False;

  var S := Sel;
  var AttrChecks: TArray<TPair<string, string>>;

  // Fast path: most CSS selectors are pure tag/class/id and contain
  // neither `:` nor `[`. Skip the pseudo-class suffix scan and the
  // attribute-selector scan entirely in that case — saves an order of
  // magnitude on per-render selector matching for stylesheets that
  // don't use these features. (The previous unconditional code did
  // LastIndexOf+Substring on every call, which became visible on
  // mobile during pan/scroll.)
  if (S.IndexOf(':') >= 0) then
  begin
    // Strip recognised pseudo-class suffixes (`:hover`, `:active`,
    // `:focus`). Unknown pseudo-classes (`:not(...)`, `:nth-child()`)
    // are left embedded — they'll fail the class/tag compare below
    // and produce a no-match without bringing down the surrounding
    // stylesheet.
    while True do
    begin
      var ColonIdx := S.LastIndexOf(':');
      if ColonIdx <= 0 then Break;
      var Suffix := S.Substring(ColonIdx).ToLower;
      if Suffix = ':hover' then begin RequireHover := True; S := S.Substring(0, ColonIdx); end
      else if Suffix = ':active' then begin RequireActive := True; S := S.Substring(0, ColonIdx); end
      else if Suffix = ':focus' then begin RequireFocus := True; S := S.Substring(0, ColonIdx); end
      else Break;
    end;
  end;

  if S.IndexOf('[') >= 0 then
  begin
    // Strip attribute selectors `[name]` (presence) and `[name="value"]`
    // (exact-match). Other operators (`~=`, `^=`, `$=`, `*=`) aren't
    // honoured; they'll fall through to a no-match.
    while True do
    begin
      var BracketStart := S.IndexOf('[');
      if BracketStart < 0 then Break;
      var BracketEnd := S.IndexOf(']', BracketStart + 1);
      if BracketEnd < 0 then Break;
      var Inner := S.Substring(BracketStart + 1, BracketEnd - BracketStart - 1).Trim;
      var Pair: TPair<string, string>;
      var EqIdx := Inner.IndexOf('=');
      if EqIdx > 0 then
      begin
        Pair.Key := Inner.Substring(0, EqIdx).Trim.ToLower;
        var V := Inner.Substring(EqIdx + 1).Trim;
        if (V.Length >= 2) and ((V.Chars[0] = '"') or (V.Chars[0] = '''')) then
          V := V.Substring(1, V.Length - 2);
        Pair.Value := V;
      end
      else
      begin
        Pair.Key := Inner.ToLower;
        Pair.Value := #1#1;  // sentinel meaning "presence only"
      end;
      SetLength(AttrChecks, Length(AttrChecks) + 1);
      AttrChecks[High(AttrChecks)] := Pair;
      // Remove the [...] segment from S
      S := S.Remove(BracketStart, BracketEnd - BracketStart + 1);
    end;
  end;
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

  // Must have matched at least something — the bare-pseudo or bare-attr
  // case (e.g. `:hover` or `[disabled]`) is allowed when one of the
  // pseudo-class flags is required or an attribute check is in play.
  if (SelTag = '') and (SelClass = '') and (SelId = '') and
     (not (RequireHover or RequireActive or RequireFocus)) and
     (Length(AttrChecks) = 0) then Exit;

  // Pseudo-class state checks. All required flags must currently be set
  // on the tag for the selector to match.
  if RequireHover and (not Tag.IsHovered) then Exit;
  if RequireActive and (not Tag.IsActive) then Exit;
  if RequireFocus and (not Tag.IsFocused) then Exit;

  // Attribute checks — `[name]` requires presence, `[name="val"]` requires
  // exact value match.
  for var Check in AttrChecks do
  begin
    if not Tag.HasAttribute(Check.Key) then Exit;
    if Check.Value <> #1#1 then
      if Tag.GetAttribute(Check.Key, '') <> Check.Value then Exit;
  end;

  Result := True;
end;

function TCSSStyleSheet.SelectorMatches(Rule: TCSSRule; Tag: THTMLTag): Boolean;
// Uses Rule.SelectorParts cached at parse time so we don't pay
// Trim+ToLower+Split per match: match the last simple selector against
// the tag, then walk ancestors for descendant parts.
begin
  Result := False;
  if not Assigned(Tag) or (Tag.TagName = '#text') or (Tag.TagName = 'root') then
    Exit;
  if Length(Rule.SelectorParts) = 0 then Exit;

  // Match the last simple selector against the tag
  if not MatchesSingleSelector(Rule.SelectorParts[High(Rule.SelectorParts)], Tag) then
    Exit;

  if Length(Rule.SelectorParts) = 1 then
    Exit(True);

  // Walk ancestors greedy-matching descendant parts in reverse
  var Current := Tag.Parent;
  var PartIdx := Length(Rule.SelectorParts) - 2;
  while (PartIdx >= 0) and Assigned(Current) do
  begin
    if MatchesSingleSelector(Rule.SelectorParts[PartIdx], Current) then
      Dec(PartIdx);
    Current := Current.Parent;
  end;
  Result := PartIdx < 0;
end;

procedure TCSSStyleSheet.ApplyTo(Tag: THTMLTag; Declarations: TCSSDeclarations);
var
  MatchedRules: TList<TCSSRule>;
  LocalProps: TDictionary<string, string>;
begin
  // Collect matching rules and sort by specificity (lower first, so higher overrides)
  MatchedRules := TList<TCSSRule>.Create;
  // Create a local copy of global custom props for this element's scope.
  // This prevents scoped vars from one element leaking into the next.
  LocalProps := TDictionary<string, string>.Create;
  try
    // Start with global custom props (from :root and *)
    for var Pair in FCustomProps do
      LocalProps.AddOrSetValue(Pair.Key, Pair.Value);

    // Indexed cascade: instead of asking every rule "do you match?", we
    // build a candidate set from rules indexed by the tag's id, classes,
    // tag name, plus the universal-rule bucket. SelectorMatches then
    // verifies (descendants, pseudo-classes, attribute filters). For
    // typical stylesheets this drops the per-tag selector-match count
    // from O(rules) to O(matching-prefix-rules) — the dominant cost
    // saving for any non-trivial CSS.
    var Candidates: TList<TCSSRule> := TList<TCSSRule>.Create;
    var Seen: TDictionary<TCSSRule, Boolean> := TDictionary<TCSSRule, Boolean>.Create;
    try
      var TagId := Tag.GetAttribute('id', '').ToLower;
      if TagId <> '' then
      begin
        var List: TList<TCSSRule>;
        if FRulesByKey.TryGetValue('#' + TagId, List) then
          for var R in List do
            if not Seen.ContainsKey(R) then begin Candidates.Add(R); Seen.Add(R, True); end;
      end;

      var TagClassAttr := Tag.GetAttribute('class', '').ToLower;
      if TagClassAttr <> '' then
      begin
        for var Cls in TagClassAttr.Split([' ']) do
        begin
          var ClsTrimmed := Cls.Trim;
          if ClsTrimmed = '' then Continue;
          var List: TList<TCSSRule>;
          if FRulesByKey.TryGetValue('.' + ClsTrimmed, List) then
            for var R in List do
              if not Seen.ContainsKey(R) then begin Candidates.Add(R); Seen.Add(R, True); end;
        end;
      end;

      var TagName := Tag.TagName.ToLower;
      if TagName <> '' then
      begin
        var List: TList<TCSSRule>;
        if FRulesByKey.TryGetValue(TagName, List) then
          for var R in List do
            if not Seen.ContainsKey(R) then begin Candidates.Add(R); Seen.Add(R, True); end;
      end;

      // Universal rules (selectors with no clear routing key — e.g. `*`,
      // `[disabled]`, anything that fell through). Always considered.
      for var R in FUniversalRules do
        if not Seen.ContainsKey(R) then begin Candidates.Add(R); Seen.Add(R, True); end;

      // Verify each candidate with the full selector matcher (handles
      // descendant ancestry, pseudo-classes, attribute filters). Uses
      // the cached-parts overload — no per-call Split or ToLower.
      for var Rule in Candidates do
        if SelectorMatches(Rule, Tag) then
          MatchedRules.Add(Rule);
    finally
      Seen.Free;
      Candidates.Free;
    end;

    // Sort by specificity ascending (stable: use SourceOrder as tiebreaker).
    // Later rules with equal specificity override earlier ones, matching CSS cascade.
    MatchedRules.Sort(TComparer<TCSSRule>.Construct(
      function(const A, B: TCSSRule): Integer
      begin
        Result := SelectorSpecificity(A.Selector) - SelectorSpecificity(B.Selector);
        if Result = 0 then
          Result := A.SourceOrder - B.SourceOrder;
      end
    ));

    // Pass 1: Collect ALL scoped --custom-property declarations from matching rules.
    // This must happen before resolving var() so that e.g. .btn-danger's --bs-btn-bg
    // is available when .btn's background-color: var(--bs-btn-bg) is resolved.
    for var Rule in MatchedRules do
      for var Pair in Rule.Declarations do
        if Pair.Key.StartsWith('--') then
          LocalProps.AddOrSetValue(Pair.Key, Pair.Value);

    // Pass 2: Resolve var() references using local scope and add to output declarations
    for var Rule in MatchedRules do
      for var Pair in Rule.Declarations do
        if not Pair.Key.StartsWith('--') then
        begin
          var Val := Pair.Value;
          if Val.Contains('var(') then
            Val := ResolveVarWith(Val, LocalProps);
          Declarations.AddOrSetValue(Pair.Key, Val);
        end;
  finally
    LocalProps.Free;
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
  Pairs: TList<string>;
  Start, I, ParenDepth: Integer;
begin
  // Split on ';' but skip semicolons inside url() parentheses
  Pairs := TList<string>.Create;
  try
    Start := 1;
    ParenDepth := 0;
    for I := 1 to Length(StyleStr) do
    begin
      if StyleStr[I] = '(' then
        Inc(ParenDepth)
      else if StyleStr[I] = ')' then
      begin
        if ParenDepth > 0 then
          Dec(ParenDepth);
      end
      else if (StyleStr[I] = ';') and (ParenDepth = 0) then
      begin
        Pairs.Add(Copy(StyleStr, Start, I - Start));
        Start := I + 1;
      end;
    end;
    if Start <= Length(StyleStr) then
      Pairs.Add(Copy(StyleStr, Start, Length(StyleStr) - Start + 1));

    for var Pair in Pairs do
    begin
      var S := Pair.Trim;
      if S = '' then Continue;
      // Split on first ':' only — can't use Split([':'], 2) because
      // Delphi's Split truncates at the Nth delimiter instead of keeping
      // the remainder (e.g. 'background-image: url(https://...)' would
      // lose everything after the ':' in 'https:').
      var ColonPos := S.IndexOf(':');
      if ColonPos > 0 then
        Dict.AddOrSetValue(
          S.Substring(0, ColonPos).Trim.ToLower,
          S.Substring(ColonPos + 1).Trim);
    end;
  finally
    Pairs.Free;
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
    SameText(Name, 'address') or SameText(Name, 'fieldset');
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

function TEdgeValues.Horz: Single;
begin
  Result := Left + Right;
end;

function TEdgeValues.Vert: Single;
begin
  Result := Top + Bottom;
end;

function TEdgeValues.Any: Boolean;
begin
  Result := (Top > 0) or (Right > 0) or (Bottom > 0) or (Left > 0);
end;

procedure TComputedStyle.SetBorderWidth(W: Single);
begin
  BorderWidths.SetAll(W);
end;

procedure TComputedStyle.SetBorderColor(C: TAlphaColor);
begin
  BorderColors[0] := C;
  BorderColors[1] := C;
  BorderColors[2] := C;
  BorderColors[3] := C;
end;

function TComputedStyle.BorderColor: TAlphaColor;
begin
  Result := BorderColors[0];  // return top color as default
end;

function TComputedStyle.CornerRadius(Index: Integer): Single;
begin
  if (Index < 0) or (Index > 3) then Exit(0);
  if BorderRadii[Index] >= 0 then
    Result := BorderRadii[Index]
  else if BorderRadius > 0 then
    Result := BorderRadius
  else
    Result := 0;
end;

function TComputedStyle.HasUniformRadius: Boolean;
var
  R0: Single;
begin
  R0 := CornerRadius(0);
  Result := SameValue(R0, CornerRadius(1)) and
            SameValue(R0, CornerRadius(2)) and
            SameValue(R0, CornerRadius(3));
end;

function TComputedStyle.MaxCornerRadius: Single;
var
  I: Integer;
  V: Single;
begin
  Result := 0;
  for I := 0 to 3 do
  begin
    V := CornerRadius(I);
    if V > Result then Result := V;
  end;
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
  Result.SetBorderColor(TAlphaColors.Black);
  Result.BorderWidths.Clear;
  Result.BorderRadius := -1;
  Result.BorderRadii[0] := -1;
  Result.BorderRadii[1] := -1;
  Result.BorderRadii[2] := -1;
  Result.BorderRadii[3] := -1;
  Result.ExplicitWidth := -1;
  Result.ExplicitHeight := -1;
  Result.Display := 'block';
  Result.WhiteSpace := 'normal';
  Result.BoxSizing := 'content-box';
  Result.CSSCursor := '';
  Result.TextTransform := 'none';
  Result.Opacity := 1.0;
  Result.MinWidth := -1;
  Result.MaxWidth := -1;
  Result.MinHeight := -1;
  Result.MaxHeight := -1;
  Result.LetterSpacing := 0;
  Result.TextIndent := 0;
  Result.Visibility := 'visible';
  Result.ListStyleType := '';
  Result.Overflow := 'visible';
  Result.OverflowX := 'visible';
  Result.OverflowY := 'visible';
  Result.WordBreak := 'normal';
  Result.OverflowWrap := 'normal';
  Result.TextOverflow := 'clip';
  Result.BoxShadow.Active := False;
  Result.ObjectFit := 'fill';
  Result.BackgroundImage := '';
  Result.BackgroundSize := 'auto';
  Result.CSSPosition := 'static';
  Result.CSSTop := -9999;
  Result.CSSLeft := -9999;
  Result.CSSRight := -9999;
  Result.CSSBottom := -9999;
  Result.OutlineWidth := 0;
  Result.OutlineColor := TAlphaColors.Null;
  Result.OutlineStyle := 'none';
  Result.OutlineOffset := 0;
  Result.CSSFloat := 'none';
  Result.FlexDirection := 'row';
  Result.JustifyContent := 'flex-start';
  Result.AlignItems := 'stretch';
  Result.FlexGrow := 0;
  Result.FlexShrink := 1;
  Result.FlexBasis := -1;
  Result.FlexGap := 0;
  Result.TextShadowActive := False;
  Result.BgPosX := 0;
  Result.BgPosY := 0;
  Result.BgRepeat := 'no-repeat';
  Result.BgGradientActive := False;
  Result.TransformActive := False;
  Result.TransformScaleX := 1;
  Result.TransformScaleY := 1;
  Result.CSSClear := 'none';
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
  // Shrink-to-fit width keywords. We collapse fit-content / min-content /
  // max-content onto a single sentinel (-3); the layout pass treats it like
  // an inline-block for width measurement (lay out at parent width, then
  // shrink to the widest child / longest line). The sentinel is < -1.01 so
  // it doesn't collide with the percentage range used by the layout engine,
  // and < 0 so existing "no explicit width" branches keep working.
  if (Str = 'fit-content') or (Str = 'min-content') or (Str = 'max-content') then
    Exit(-3);

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
  Result.ListStyleType := ParentStyle.ListStyleType;
  Result.TextTransform := ParentStyle.TextTransform;
  Result.LetterSpacing := ParentStyle.LetterSpacing;
  Result.TextIndent := ParentStyle.TextIndent;
  Result.Visibility := ParentStyle.Visibility;
  Result.WordBreak := ParentStyle.WordBreak;
  Result.OverflowWrap := ParentStyle.OverflowWrap;
  Result.VerticalAlign := 'baseline';

  // Non-inherited defaults
  Result.BackgroundColor := TAlphaColors.Null;
  Result.TextDecoration := 'none';
  Result.Margin.Clear;
  Result.Padding.Clear;
  Result.SetBorderColor(TAlphaColors.Black);
  Result.BorderWidths.Clear;
  Result.BorderRadius := -1;
  Result.BorderRadii[0] := -1;
  Result.BorderRadii[1] := -1;
  Result.BorderRadii[2] := -1;
  Result.BorderRadii[3] := -1;
  Result.ExplicitWidth := -1;
  Result.ExplicitHeight := -1;
  Result.Display := 'inline';
  Result.BoxSizing := 'content-box';
  Result.CSSCursor := '';
  Result.Opacity := 1.0;
  Result.MinWidth := -1;
  Result.MaxWidth := -1;
  Result.MinHeight := -1;
  Result.MaxHeight := -1;
  Result.Overflow := 'visible';
  Result.OverflowX := 'visible';
  Result.OverflowY := 'visible';
  Result.TextOverflow := 'clip';
  Result.ObjectFit := 'fill';
  Result.BackgroundImage := '';
  Result.BackgroundSize := 'auto';
  Result.CSSPosition := 'static';
  Result.CSSTop := -9999;
  Result.CSSLeft := -9999;
  Result.CSSRight := -9999;
  Result.CSSBottom := -9999;
  Result.OutlineWidth := 0;
  Result.OutlineColor := TAlphaColors.Null;
  Result.OutlineStyle := 'none';
  Result.OutlineOffset := 0;
  Result.CSSFloat := 'none';
  Result.FlexDirection := 'row';
  Result.JustifyContent := 'flex-start';
  Result.AlignItems := 'stretch';
  Result.FlexGrow := 0;
  Result.FlexShrink := 1;
  Result.FlexBasis := -1;
  Result.FlexGap := 0;
  Result.TextShadowActive := False;
  Result.BgPosX := 0;
  Result.BgPosY := 0;
  Result.BgRepeat := 'no-repeat';
  Result.BgGradientActive := False;
  Result.TransformActive := False;
  Result.TransformScaleX := 1;
  Result.TransformScaleY := 1;
  Result.CSSClear := 'none';

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
    Result.SetBorderWidth(3);
    Result.SetBorderColor(TAlphaColors.Lightgray);
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
    Result.Padding.Left := 32;
    Result.ListStyleType := 'disc';
  end
  else if TN = 'ol' then
  begin
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
    Result.Padding.Left := 32;
    Result.ListStyleType := 'decimal';
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
    Result.Margin.Left := 40
  else if TN = 'kbd' then
  begin
    Result.FontFamily := 'Courier New';
    Result.FontSize := ParentStyle.FontSize * 0.9;
    Result.BackgroundColor := $FFF0F0F0;
    Result.SetBorderColor($FFCCCCCC);
    Result.SetBorderWidth(1);
    Result.BorderRadius := 3;
    Result.Padding.SetAll(2);
  end
  else if TN = 'abbr' then
    Result.TextDecoration := 'underline'
  else if (TN = 'cite') or (TN = 'dfn') then
    Result.Italic := True
  else if (TN = 'var') then
  begin
    Result.Italic := True;
    Result.FontFamily := 'Courier New';
  end
  else if TN = 'samp' then
    Result.FontFamily := 'Courier New'
  else if TN = 'fieldset' then
  begin
    Result.SetBorderColor($FF808080);
    Result.SetBorderWidth(2);
    Result.BorderRadius := 4;
    Result.Padding.SetAll(10);
    Result.Margin.Top := 8;
    Result.Margin.Bottom := 8;
  end
  else if TN = 'legend' then
  begin
    Result.Bold := True;
    Result.Padding.Left := 4;
    Result.Padding.Right := 4;
  end;

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
    var BdrW := StrToFloatDef(Tag.GetAttribute('border'), 0);
    Result.SetBorderWidth(BdrW);
    if BdrW > 0 then
      Result.SetBorderColor(TAlphaColors.Black);
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

  // Bootstrap button class fallback — for non-native elements (span, div, a)
  // that have btn classes. Always apply layout properties; only apply colors
  // when CSS variable resolution didn't provide them.
  if not SameText(TN, 'button') and not SameText(TN, 'input') and
     not SameText(TN, '#text') then
  begin
    var BtnClass := Tag.GetAttribute('class', '').ToLower;
    if BtnClass.Contains('btn-primary') or BtnClass.Contains('btn-secondary') or
       BtnClass.Contains('btn-success') or BtnClass.Contains('btn-danger') or
       BtnClass.Contains('btn-warning') or BtnClass.Contains('btn-info') or
       BtnClass.Contains('btn-dark') or BtnClass.Contains('btn-light') then
    begin
      // Color fallback — only when CSS didn't provide a background
      if Result.BackgroundColor = TAlphaColors.Null then
      begin
        if BtnClass.Contains('btn-primary') then begin Result.BackgroundColor := $FF0D6EFD; Result.Color := TAlphaColors.White; end
        else if BtnClass.Contains('btn-secondary') then begin Result.BackgroundColor := $FF6C757D; Result.Color := TAlphaColors.White; end
        else if BtnClass.Contains('btn-success') then begin Result.BackgroundColor := $FF198754; Result.Color := TAlphaColors.White; end
        else if BtnClass.Contains('btn-danger') then begin Result.BackgroundColor := $FFDC3545; Result.Color := TAlphaColors.White; end
        else if BtnClass.Contains('btn-warning') then begin Result.BackgroundColor := $FFFFC107; Result.Color := TAlphaColors.Black; end
        else if BtnClass.Contains('btn-info') then begin Result.BackgroundColor := $FF0DCAF0; Result.Color := TAlphaColors.Black; end
        else if BtnClass.Contains('btn-dark') then begin Result.BackgroundColor := $FF212529; Result.Color := TAlphaColors.White; end
        else if BtnClass.Contains('btn-light') then begin Result.BackgroundColor := $FFF8F9FA; Result.Color := TAlphaColors.Black; end;
      end;
      // Layout properties — always apply as defaults
      if Result.Display <> 'inline-block' then
        Result.Display := 'inline-block';
      Result.TextAlign := TTextAlign.Center;
      if (Result.Padding.Top = 0) and (Result.Padding.Bottom = 0) then
      begin
        Result.Padding.Top := 6;    // 0.375rem ≈ 6px
        Result.Padding.Bottom := 6;
        Result.Padding.Left := 12;  // 0.75rem ≈ 12px
        Result.Padding.Right := 12;
      end;
      if Result.BorderRadius < 0 then
        Result.BorderRadius := 6;   // 0.375rem ≈ 6px
    end;
  end;
end;

class procedure TComputedStyle.ExtractBgImageUrl(const Value: string; out Url: string);
var
  S: string;
  P1, P2: Integer;
begin
  Url := '';
  S := Value.Trim;
  P1 := S.ToLower.IndexOf('url(');
  if P1 < 0 then Exit;
  P2 := S.LastIndexOf(')');
  if P2 <= P1 + 4 then Exit;
  Url := S.Substring(P1 + 4, P2 - P1 - 4).Trim;
  // Strip quotes
  if (Url.Length >= 2) and ((Url.Chars[0] = '''') or (Url.Chars[0] = '"')) then
    Url := Url.Substring(1, Url.Length - 2);
end;

class procedure TComputedStyle.ApplyDeclarations(Decls: TCSSDeclarations; var Style: TComputedStyle; const ParentStyle: TComputedStyle);
var
  Temp: string;

  function ShouldSkip(const V: string): Boolean; inline;
  var TV: string;
  begin
    TV := V.Trim;
    Result := TV.Contains('var(') or SameText(TV, 'inherit') or
      SameText(TV, 'initial') or SameText(TV, 'unset') or SameText(TV, 'revert');
  end;

begin
  if Decls.TryGetValue('color', Temp) and not ShouldSkip(Temp) then
    Style.Color := ParseColor(Temp);
  if Decls.TryGetValue('background-color', Temp) and not ShouldSkip(Temp) then
    Style.BackgroundColor := ParseColor(Temp);
  if Decls.TryGetValue('background', Temp) and not ShouldSkip(Temp) then
  begin
    var BgVal := Temp.Trim;
    // Extract url(...) if present
    if BgVal.ToLower.Contains('url(') then
    begin
      ExtractBgImageUrl(BgVal, Style.BackgroundImage);
      // Try to parse a color from the portion before url()
      var UrlPos := BgVal.ToLower.IndexOf('url(');
      if UrlPos > 0 then
      begin
        var ColorPart := BgVal.Substring(0, UrlPos).Trim;
        if ColorPart <> '' then
          Style.BackgroundColor := ParseColor(ColorPart);
      end;
    end
    else
      Style.BackgroundColor := ParseColor(BgVal);
  end;
  if Decls.TryGetValue('font-family', Temp) and not ShouldSkip(Temp) then
    Style.FontFamily := Temp.DeQuotedString('''').DeQuotedString('"');
  if Decls.TryGetValue('font-size', Temp) and not ShouldSkip(Temp) then
    Style.FontSize := ParseLength(Temp, ParentStyle.FontSize);
  if Decls.TryGetValue('font-weight', Temp) and not ShouldSkip(Temp) then
    Style.Bold := SameText(Temp, 'bold') or SameText(Temp, 'bolder') or
      (StrToIntDef(Temp, 400) >= 500);
  if Decls.TryGetValue('font-style', Temp) and not ShouldSkip(Temp) then
    Style.Italic := SameText(Temp, 'italic') or SameText(Temp, 'oblique');
  if Decls.TryGetValue('text-decoration', Temp) and not ShouldSkip(Temp) then
    Style.TextDecoration := Temp.ToLower;
  if Decls.TryGetValue('text-align', Temp) and not ShouldSkip(Temp) then
  begin
    Temp := Temp.ToLower;
    if Temp = 'center' then Style.TextAlign := TTextAlign.Center
    else if Temp = 'right' then Style.TextAlign := TTextAlign.Trailing
    else if Temp = 'justify' then Style.TextAlign := TTextAlign.Leading
    else Style.TextAlign := TTextAlign.Leading;
  end;
  if Decls.TryGetValue('line-height', Temp) and not ShouldSkip(Temp) then
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
  if Decls.TryGetValue('margin', Temp) and not ShouldSkip(Temp) then
    ParseEdgeShorthand(Temp, Style.Margin, Style.FontSize);
  if Decls.TryGetValue('margin-top', Temp) and not ShouldSkip(Temp) then
    Style.Margin.Top := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-right', Temp) and not ShouldSkip(Temp) then
    Style.Margin.Right := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-bottom', Temp) and not ShouldSkip(Temp) then
    Style.Margin.Bottom := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('margin-left', Temp) and not ShouldSkip(Temp) then
    Style.Margin.Left := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding', Temp) and not ShouldSkip(Temp) then
    ParseEdgeShorthand(Temp, Style.Padding, Style.FontSize);
  if Decls.TryGetValue('padding-top', Temp) and not ShouldSkip(Temp) then
    Style.Padding.Top := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-right', Temp) and not ShouldSkip(Temp) then
    Style.Padding.Right := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-bottom', Temp) and not ShouldSkip(Temp) then
    Style.Padding.Bottom := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('padding-left', Temp) and not ShouldSkip(Temp) then
    Style.Padding.Left := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('border', Temp) and not ShouldSkip(Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
        Style.BorderWidths.Clear
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.SetBorderWidth(StrToFloatDef(BT.Replace('px', ''), 1))
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style — we only support solid rendering
      else
        Style.SetBorderColor(ParseColor(BT));
    end;
  end;
  // Per-side border shorthands: border-top, border-right, border-bottom, border-left
  if Decls.TryGetValue('border-top', Temp) and not ShouldSkip(Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
        Style.BorderWidths.Top := 0
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.BorderWidths.Top := StrToFloatDef(BT.Replace('px', ''), 1)
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style
      else
        Style.BorderColors[0] := ParseColor(BT);
    end;
  end;
  if Decls.TryGetValue('border-right', Temp) and not ShouldSkip(Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
        Style.BorderWidths.Right := 0
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.BorderWidths.Right := StrToFloatDef(BT.Replace('px', ''), 1)
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style
      else
        Style.BorderColors[1] := ParseColor(BT);
    end;
  end;
  if Decls.TryGetValue('border-bottom', Temp) and not ShouldSkip(Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
        Style.BorderWidths.Bottom := 0
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.BorderWidths.Bottom := StrToFloatDef(BT.Replace('px', ''), 1)
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style
      else
        Style.BorderColors[2] := ParseColor(BT);
    end;
  end;
  if Decls.TryGetValue('border-left', Temp) and not ShouldSkip(Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if BT = 'none' then
        Style.BorderWidths.Left := 0
      else if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Style.BorderWidths.Left := StrToFloatDef(BT.Replace('px', ''), 1)
      else if (BT = 'solid') or (BT = 'dashed') or (BT = 'dotted') or
              (BT = 'double') or (BT = 'groove') or (BT = 'ridge') or
              (BT = 'inset') or (BT = 'outset') then
        // border style
      else
        Style.BorderColors[3] := ParseColor(BT);
    end;
  end;
  if Decls.TryGetValue('border-color', Temp) and not ShouldSkip(Temp) then
    Style.SetBorderColor(ParseColor(Temp));
  if Decls.TryGetValue('border-width', Temp) and not ShouldSkip(Temp) then
    Style.SetBorderWidth(ParseLength(Temp, Style.FontSize));
  if Decls.TryGetValue('border-radius', Temp) and not ShouldSkip(Temp) then
  begin
    var RParts := Temp.Trim.Split([' '], TStringSplitOptions.ExcludeEmpty);
    case Length(RParts) of
      1: begin
           var R0 := ParseLength(RParts[0], Style.FontSize);
           Style.BorderRadius := R0;
           Style.BorderRadii[0] := R0;
           Style.BorderRadii[1] := R0;
           Style.BorderRadii[2] := R0;
           Style.BorderRadii[3] := R0;
         end;
      2: begin
           // TL+BR | TR+BL
           var Ra := ParseLength(RParts[0], Style.FontSize);
           var Rb := ParseLength(RParts[1], Style.FontSize);
           Style.BorderRadii[0] := Ra;
           Style.BorderRadii[2] := Ra;
           Style.BorderRadii[1] := Rb;
           Style.BorderRadii[3] := Rb;
           Style.BorderRadius := Ra;
         end;
      3: begin
           // TL | TR+BL | BR
           var Ra := ParseLength(RParts[0], Style.FontSize);
           var Rb := ParseLength(RParts[1], Style.FontSize);
           var Rc := ParseLength(RParts[2], Style.FontSize);
           Style.BorderRadii[0] := Ra;
           Style.BorderRadii[1] := Rb;
           Style.BorderRadii[3] := Rb;
           Style.BorderRadii[2] := Rc;
           Style.BorderRadius := Ra;
         end;
    else
      if Length(RParts) >= 4 then
      begin
        // TL | TR | BR | BL
        Style.BorderRadii[0] := ParseLength(RParts[0], Style.FontSize);
        Style.BorderRadii[1] := ParseLength(RParts[1], Style.FontSize);
        Style.BorderRadii[2] := ParseLength(RParts[2], Style.FontSize);
        Style.BorderRadii[3] := ParseLength(RParts[3], Style.FontSize);
        Style.BorderRadius := Style.BorderRadii[0];
      end;
    end;
  end;
  if Decls.TryGetValue('border-top-left-radius', Temp) and not ShouldSkip(Temp) then
    Style.BorderRadii[0] := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('border-top-right-radius', Temp) and not ShouldSkip(Temp) then
    Style.BorderRadii[1] := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('border-bottom-right-radius', Temp) and not ShouldSkip(Temp) then
    Style.BorderRadii[2] := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('border-bottom-left-radius', Temp) and not ShouldSkip(Temp) then
    Style.BorderRadii[3] := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('width', Temp) and not ShouldSkip(Temp) then
    Style.ExplicitWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('height', Temp) and not ShouldSkip(Temp) then
    Style.ExplicitHeight := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('display', Temp) and not ShouldSkip(Temp) then
    Style.Display := Temp.ToLower;
  if Decls.TryGetValue('vertical-align', Temp) and not ShouldSkip(Temp) then
    Style.VerticalAlign := Temp.ToLower;
  if Decls.TryGetValue('white-space', Temp) and not ShouldSkip(Temp) then
    Style.WhiteSpace := Temp.Trim.ToLower;
  if Decls.TryGetValue('box-sizing', Temp) and not ShouldSkip(Temp) then
    Style.BoxSizing := Temp.ToLower;
  if Decls.TryGetValue('cursor', Temp) and not ShouldSkip(Temp) then
    Style.CSSCursor := Temp.ToLower;

  if Decls.TryGetValue('object-fit', Temp) and not ShouldSkip(Temp) then
    Style.ObjectFit := Temp.Trim.ToLower;
  if Decls.TryGetValue('background-image', Temp) and not ShouldSkip(Temp) then
    ExtractBgImageUrl(Temp, Style.BackgroundImage);
  if Decls.TryGetValue('background-size', Temp) and not ShouldSkip(Temp) then
    Style.BackgroundSize := Temp.Trim.ToLower;

  if Decls.TryGetValue('position', Temp) and not ShouldSkip(Temp) then
    Style.CSSPosition := Temp.Trim.ToLower;
  if Decls.TryGetValue('top', Temp) and not ShouldSkip(Temp) then
    Style.CSSTop := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('left', Temp) and not ShouldSkip(Temp) then
    Style.CSSLeft := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('right', Temp) and not ShouldSkip(Temp) then
    Style.CSSRight := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('bottom', Temp) and not ShouldSkip(Temp) then
    Style.CSSBottom := ParseLength(Temp, Style.FontSize);

  // CSS `inset` shorthand for top/right/bottom/left. Same 1-2-3-4 value
  // pattern as `margin` / `padding`:
  //   1 value  -> all four sides
  //   2 values -> top/bottom, left/right
  //   3 values -> top, left/right, bottom
  //   4 values -> top, right, bottom, left
  // Most common usage is `inset: 0` to stretch an absolute child to fill
  // its containing block. Without this, `inset:0` is silently dropped and
  // authors are forced to write the four longhands explicitly.
  // Per CSS cascade order, longhand `top` / `right` / `bottom` / `left`
  // declarations after `inset` should win — but in practice we keep the
  // longhand block ABOVE so authors who explicitly set both get the
  // longhand value (a deliberate one-off override beats the shorthand).
  if Decls.TryGetValue('inset', Temp) and not ShouldSkip(Temp) then
  begin
    var Parts := Temp.Trim.Split([' '], TStringSplitOptions.ExcludeEmpty);
    var T, R, B, L: string;
    case Length(Parts) of
      1: begin T := Parts[0]; R := Parts[0]; B := Parts[0]; L := Parts[0]; end;
      2: begin T := Parts[0]; B := Parts[0]; R := Parts[1]; L := Parts[1]; end;
      3: begin T := Parts[0]; R := Parts[1]; L := Parts[1]; B := Parts[2]; end;
    else
      T := Parts[0]; R := Parts[1]; B := Parts[2]; L := Parts[3];
    end;
    // Only fill sides the longhand block didn't already set, so an
    // explicit `top: 10px` after `inset: 0` keeps the 10px.
    if Style.CSSTop    <= -9990 then Style.CSSTop    := ParseLength(T, Style.FontSize);
    if Style.CSSRight  <= -9990 then Style.CSSRight  := ParseLength(R, Style.FontSize);
    if Style.CSSBottom <= -9990 then Style.CSSBottom := ParseLength(B, Style.FontSize);
    if Style.CSSLeft   <= -9990 then Style.CSSLeft   := ParseLength(L, Style.FontSize);
  end;

  if Decls.TryGetValue('text-transform', Temp) and not ShouldSkip(Temp) then
    Style.TextTransform := Temp.ToLower;

  if Decls.TryGetValue('opacity', Temp) and not ShouldSkip(Temp) then
    Style.Opacity := Max(0, Min(1, StrToFloatDef(Temp, 1.0)));

  if Decls.TryGetValue('min-width', Temp) and not ShouldSkip(Temp) then
    Style.MinWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('max-width', Temp) and not ShouldSkip(Temp) then
    Style.MaxWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('min-height', Temp) and not ShouldSkip(Temp) then
    Style.MinHeight := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('max-height', Temp) and not ShouldSkip(Temp) then
    Style.MaxHeight := ParseLength(Temp, Style.FontSize);

  if Decls.TryGetValue('letter-spacing', Temp) and not ShouldSkip(Temp) then
    Style.LetterSpacing := ParseLength(Temp, Style.FontSize);

  if Decls.TryGetValue('text-indent', Temp) and not ShouldSkip(Temp) then
    Style.TextIndent := ParseLength(Temp, Style.FontSize);

  if Decls.TryGetValue('visibility', Temp) and not ShouldSkip(Temp) then
    Style.Visibility := Temp.ToLower;

  if Decls.TryGetValue('list-style-type', Temp) and not ShouldSkip(Temp) then
    Style.ListStyleType := Temp.ToLower;
  if Decls.TryGetValue('list-style', Temp) and not ShouldSkip(Temp) then
    Style.ListStyleType := Temp.ToLower;

  if Decls.TryGetValue('overflow', Temp) and not ShouldSkip(Temp) then
  begin
    // overflow shorthand: `overflow: <x> <y>` or `overflow: <both>`
    var OvParts := Temp.Trim.ToLower.Split([' '], TStringSplitOptions.ExcludeEmpty);
    if Length(OvParts) >= 2 then
    begin
      Style.OverflowX := OvParts[0];
      Style.OverflowY := OvParts[1];
      Style.Overflow := OvParts[0];
    end
    else if Length(OvParts) = 1 then
    begin
      Style.Overflow := OvParts[0];
      Style.OverflowX := OvParts[0];
      Style.OverflowY := OvParts[0];
    end;
  end;
  if Decls.TryGetValue('overflow-x', Temp) and not ShouldSkip(Temp) then
    Style.OverflowX := Temp.Trim.ToLower;
  if Decls.TryGetValue('overflow-y', Temp) and not ShouldSkip(Temp) then
    Style.OverflowY := Temp.Trim.ToLower;

  if Decls.TryGetValue('word-break', Temp) and not ShouldSkip(Temp) then
    Style.WordBreak := Temp.ToLower;
  if Decls.TryGetValue('overflow-wrap', Temp) and not ShouldSkip(Temp) then
    Style.OverflowWrap := Temp.ToLower;
  if Decls.TryGetValue('word-wrap', Temp) and not ShouldSkip(Temp) then
    Style.OverflowWrap := Temp.ToLower;  // word-wrap is legacy alias

  if Decls.TryGetValue('text-overflow', Temp) and not ShouldSkip(Temp) then
    Style.TextOverflow := Temp.ToLower;

  // box-shadow: offsetX offsetY [blur [spread]] color [inset]
  if Decls.TryGetValue('box-shadow', Temp) and not ShouldSkip(Temp) then
  begin
    var ShadowStr := Temp.Trim.ToLower;
    if ShadowStr = 'none' then
      Style.BoxShadow.Active := False
    else
    begin
      Style.BoxShadow.Active := True;
      Style.BoxShadow.Inset := ShadowStr.Contains('inset');
      ShadowStr := ShadowStr.Replace('inset', '').Trim;
      // Parse: values are space-separated lengths then a color
      // Split and collect numeric values and the color
      var SParts := ShadowStr.Split([' ']);
      var Nums: TArray<Single>;
      SetLength(Nums, 0);
      Style.BoxShadow.Color := $40000000;  // default: semi-transparent black
      for var SP in SParts do
      begin
        var ST := SP.Trim;
        if ST = '' then Continue;
        var PL := ParseLength(ST, Style.FontSize);
        // ParseLength returns 0 for unknown strings, but also for "0px"
        // Check if it looks numeric
        if (ST.EndsWith('px')) or (ST.EndsWith('em')) or (ST.EndsWith('rem')) or
           (ST = '0') or (StrToFloatDef(ST, Single.MaxValue) <> Single.MaxValue) then
        begin
          SetLength(Nums, Length(Nums) + 1);
          Nums[High(Nums)] := PL;
        end
        else
          Style.BoxShadow.Color := ParseColor(ST);
      end;
      // Assign numeric values: offsetX, offsetY, [blur, [spread]]
      if Length(Nums) >= 1 then Style.BoxShadow.OffsetX := Nums[0];
      if Length(Nums) >= 2 then Style.BoxShadow.OffsetY := Nums[1];
      if Length(Nums) >= 3 then Style.BoxShadow.BlurRadius := Nums[2] else Style.BoxShadow.BlurRadius := 0;
      if Length(Nums) >= 4 then Style.BoxShadow.SpreadRadius := Nums[3] else Style.BoxShadow.SpreadRadius := 0;
    end;
  end;

  // outline: <width> [<style>] <color>   (any order, space-separated)
  // outline-width / outline-color / outline-style / outline-offset are also
  // accepted as longhands. Outlines are painted on top of the border-box
  // edge and don't affect layout. `outline-offset: -4px` pulls the rectangle
  // inward — useful for status indicators that must stay inside a rounded
  // card without escaping the corner radius.
  if Decls.TryGetValue('outline', Temp) and not ShouldSkip(Temp) then
  begin
    var OutlineStr := Temp.Trim.ToLower;
    if (OutlineStr = 'none') or (OutlineStr = '0') then
    begin
      Style.OutlineWidth := 0;
      Style.OutlineStyle := 'none';
    end
    else
    begin
      // Default: solid, current color
      Style.OutlineStyle := 'solid';
      Style.OutlineColor := Style.Color;
      Style.OutlineWidth := 0;
      var OParts := OutlineStr.Split([' ']);
      for var OP in OParts do
      begin
        var OT := OP.Trim;
        if OT = '' then Continue;
        if (OT = 'solid') or (OT = 'dashed') or (OT = 'dotted') or
           (OT = 'double') or (OT = 'groove') or (OT = 'ridge') or
           (OT = 'inset') or (OT = 'outset') then
          Style.OutlineStyle := OT
        else if (OT.EndsWith('px')) or (OT.EndsWith('em')) or (OT.EndsWith('rem')) or
                (OT = '0') or (StrToFloatDef(OT, Single.MaxValue) <> Single.MaxValue) then
          Style.OutlineWidth := ParseLength(OT, Style.FontSize)
        else
          Style.OutlineColor := ParseColor(OT);
      end;
    end;
  end;
  if Decls.TryGetValue('outline-width', Temp) and not ShouldSkip(Temp) then
    Style.OutlineWidth := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('outline-color', Temp) and not ShouldSkip(Temp) then
    Style.OutlineColor := ParseColor(Temp);
  if Decls.TryGetValue('outline-style', Temp) and not ShouldSkip(Temp) then
    Style.OutlineStyle := Temp.Trim.ToLower;
  if Decls.TryGetValue('outline-offset', Temp) and not ShouldSkip(Temp) then
    Style.OutlineOffset := ParseLength(Temp, Style.FontSize);

  if Decls.TryGetValue('float', Temp) and not ShouldSkip(Temp) then
  begin
    var FloatStr := Temp.Trim.ToLower;
    if (FloatStr = 'left') or (FloatStr = 'right') or (FloatStr = 'none') then
      Style.CSSFloat := FloatStr;
  end;
  if Decls.TryGetValue('clear', Temp) and not ShouldSkip(Temp) then
  begin
    var ClrStr := Temp.Trim.ToLower;
    if (ClrStr = 'left') or (ClrStr = 'right') or (ClrStr = 'both') or
       (ClrStr = 'none') then
      Style.CSSClear := ClrStr;
  end;

  // Flexbox container properties
  if Decls.TryGetValue('flex-direction', Temp) and not ShouldSkip(Temp) then
    Style.FlexDirection := Temp.Trim.ToLower;
  if Decls.TryGetValue('justify-content', Temp) and not ShouldSkip(Temp) then
    Style.JustifyContent := Temp.Trim.ToLower;
  if Decls.TryGetValue('align-items', Temp) and not ShouldSkip(Temp) then
    Style.AlignItems := Temp.Trim.ToLower;
  if Decls.TryGetValue('gap', Temp) and not ShouldSkip(Temp) then
    Style.FlexGap := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('column-gap', Temp) and not ShouldSkip(Temp) then
    Style.FlexGap := ParseLength(Temp, Style.FontSize);
  if Decls.TryGetValue('row-gap', Temp) and not ShouldSkip(Temp) then
    Style.FlexGap := ParseLength(Temp, Style.FontSize);

  // Flexbox item properties — `flex` is a shorthand for grow/shrink/basis.
  // Common forms: `flex: 1` -> grow=1 shrink=1 basis=0
  //               `flex: auto` -> grow=1 shrink=1 basis=auto
  //               `flex: 0 0 100px` -> grow=0 shrink=0 basis=100px
  if Decls.TryGetValue('flex', Temp) and not ShouldSkip(Temp) then
  begin
    var FlexStr := Temp.Trim.ToLower;
    if FlexStr = 'auto' then
    begin
      Style.FlexGrow := 1; Style.FlexShrink := 1; Style.FlexBasis := -1;
    end
    else if FlexStr = 'none' then
    begin
      Style.FlexGrow := 0; Style.FlexShrink := 0; Style.FlexBasis := -1;
    end
    else
    begin
      var Parts := FlexStr.Split([' ']);
      if Length(Parts) >= 1 then Style.FlexGrow := StrToFloatDef(Parts[0], 0);
      if Length(Parts) >= 2 then Style.FlexShrink := StrToFloatDef(Parts[1], 1)
      else Style.FlexShrink := 1;
      if Length(Parts) >= 3 then Style.FlexBasis := ParseLength(Parts[2], Style.FontSize)
      else Style.FlexBasis := 0;  // single-number `flex: 1` -> basis 0
    end;
  end;
  if Decls.TryGetValue('flex-grow', Temp) and not ShouldSkip(Temp) then
    Style.FlexGrow := StrToFloatDef(Temp.Trim, 0);
  if Decls.TryGetValue('flex-shrink', Temp) and not ShouldSkip(Temp) then
    Style.FlexShrink := StrToFloatDef(Temp.Trim, 1);
  if Decls.TryGetValue('flex-basis', Temp) and not ShouldSkip(Temp) then
    Style.FlexBasis := ParseLength(Temp, Style.FontSize);

  // text-shadow: offsetX offsetY [blur] color  (similar form to box-shadow)
  if Decls.TryGetValue('text-shadow', Temp) and not ShouldSkip(Temp) then
  begin
    var TsStr := Temp.Trim.ToLower;
    if (TsStr = 'none') or (TsStr = '') then
      Style.TextShadowActive := False
    else
    begin
      Style.TextShadowActive := True;
      Style.TextShadowColor := $80000000;  // default semi-transparent black
      var Parts := TsStr.Split([' ']);
      var Nums: TArray<Single>;
      for var P in Parts do
      begin
        var T := P.Trim;
        if T = '' then Continue;
        if T.EndsWith('px') or T.EndsWith('em') or T.EndsWith('rem') or
           (T = '0') or (StrToFloatDef(T, Single.MaxValue) <> Single.MaxValue) then
        begin
          SetLength(Nums, Length(Nums) + 1);
          Nums[High(Nums)] := ParseLength(T, Style.FontSize);
        end
        else
          Style.TextShadowColor := ParseColor(T);
      end;
      if Length(Nums) >= 1 then Style.TextShadowOffsetX := Nums[0];
      if Length(Nums) >= 2 then Style.TextShadowOffsetY := Nums[1];
      if Length(Nums) >= 3 then Style.TextShadowBlur    := Nums[2]
      else Style.TextShadowBlur := 0;
    end;
  end;

  // background-position: keywords (top/right/bottom/left/center) +
  // percentages + lengths. Two values: horizontal first, vertical second.
  if Decls.TryGetValue('background-position', Temp) and not ShouldSkip(Temp) then
  begin
    var Parts := Temp.Trim.ToLower.Split([' ']);
    if Length(Parts) >= 1 then
    begin
      if Parts[0] = 'left' then Style.BgPosX := 0
      else if Parts[0] = 'center' then Style.BgPosX := -50  // 50% sentinel
      else if Parts[0] = 'right' then Style.BgPosX := -100
      else Style.BgPosX := ParseLength(Parts[0], Style.FontSize);
    end;
    if Length(Parts) >= 2 then
    begin
      if Parts[1] = 'top' then Style.BgPosY := 0
      else if Parts[1] = 'center' then Style.BgPosY := -50
      else if Parts[1] = 'bottom' then Style.BgPosY := -100
      else Style.BgPosY := ParseLength(Parts[1], Style.FontSize);
    end
    else if (Length(Parts) = 1) and (Parts[0] = 'center') then
      Style.BgPosY := -50;  // single 'center' applies to both axes
  end;

  // background-repeat
  if Decls.TryGetValue('background-repeat', Temp) and not ShouldSkip(Temp) then
    Style.BgRepeat := Temp.Trim.ToLower;

  // linear-gradient — extract from background-image OR the background
  // shorthand. Form: linear-gradient(<angle>, <color1>, <color2>)
  // Multi-stop gradients fall back to first + last colour (no
  // intermediate stops yet).
  var GradientSrc := '';
  if Decls.TryGetValue('background-image', Temp) and not ShouldSkip(Temp) then
    if Temp.ToLower.Contains('linear-gradient(') then
      GradientSrc := Temp;
  if (GradientSrc = '') and Decls.TryGetValue('background', Temp) and not ShouldSkip(Temp) then
    if Temp.ToLower.Contains('linear-gradient(') then
      GradientSrc := Temp;
  if GradientSrc <> '' then
  begin
    var GS := GradientSrc;
    var L := GS.ToLower;
    var P1 := L.IndexOf('linear-gradient(');
    var P2 := L.IndexOf(')', P1 + 16);
    if (P1 >= 0) and (P2 > P1) then
    begin
      var Inner := GS.Substring(P1 + 16, P2 - P1 - 16);
      var Args := Inner.Split([',']);
      Style.BgGradientAngle := 180;  // default `to bottom` (top→bottom)
      var Colors: TArray<TAlphaColor>;
      for var A in Args do
      begin
        var T := A.Trim.ToLower;
        if T.EndsWith('deg') then
          Style.BgGradientAngle := StrToFloatDef(T.Substring(0, T.Length - 3), 180)
        else if T.StartsWith('to ') then
        begin
          if T = 'to top' then Style.BgGradientAngle := 0
          else if T = 'to right' then Style.BgGradientAngle := 90
          else if T = 'to bottom' then Style.BgGradientAngle := 180
          else if T = 'to left' then Style.BgGradientAngle := 270;
        end
        else
        begin
          SetLength(Colors, Length(Colors) + 1);
          Colors[High(Colors)] := ParseColor(A.Trim);
        end;
      end;
      if Length(Colors) >= 2 then
      begin
        Style.BgGradientStart := Colors[0];
        Style.BgGradientEnd := Colors[High(Colors)];
        Style.BgGradientActive := True;
      end;
    end;
  end;

  // CSS transform: parse a chain of translate/rotate/scale function
  // calls into the per-axis fields. Multiple transforms compose in
  // CSS order; we aggregate translate offsets, multiply scales,
  // and sum rotation. Functions we don't recognise are skipped.
  if Decls.TryGetValue('transform', Temp) and not ShouldSkip(Temp) then
  begin
    var TfStr := Temp.Trim.ToLower;
    if (TfStr = 'none') or (TfStr = '') then
    begin
      Style.TransformActive := False;
      Style.TransformScaleX := 1;
      Style.TransformScaleY := 1;
    end
    else
    begin
      Style.TransformActive := True;
      var Pos := 0;
      while Pos < TfStr.Length do
      begin
        // Skip whitespace / commas
        while (Pos < TfStr.Length) and ((TfStr.Chars[Pos] = ' ') or (TfStr.Chars[Pos] = ',')) do
          Inc(Pos);
        if Pos >= TfStr.Length then Break;
        // Function name up to '('
        var NameStart := Pos;
        while (Pos < TfStr.Length) and (TfStr.Chars[Pos] <> '(') do Inc(Pos);
        if Pos >= TfStr.Length then Break;
        var FnName := TfStr.Substring(NameStart, Pos - NameStart).Trim;
        Inc(Pos); // skip '('
        var ArgStart := Pos;
        while (Pos < TfStr.Length) and (TfStr.Chars[Pos] <> ')') do Inc(Pos);
        var ArgStr := TfStr.Substring(ArgStart, Pos - ArgStart);
        if Pos < TfStr.Length then Inc(Pos);  // skip ')'
        var Args := ArgStr.Split([',']);

        if FnName = 'translate' then
        begin
          if Length(Args) >= 1 then
            Style.TransformTranslateX := Style.TransformTranslateX + ParseLength(Args[0].Trim, Style.FontSize);
          if Length(Args) >= 2 then
            Style.TransformTranslateY := Style.TransformTranslateY + ParseLength(Args[1].Trim, Style.FontSize);
        end
        else if FnName = 'translatex' then
        begin
          if Length(Args) >= 1 then
            Style.TransformTranslateX := Style.TransformTranslateX + ParseLength(Args[0].Trim, Style.FontSize);
        end
        else if FnName = 'translatey' then
        begin
          if Length(Args) >= 1 then
            Style.TransformTranslateY := Style.TransformTranslateY + ParseLength(Args[0].Trim, Style.FontSize);
        end
        else if FnName = 'rotate' then
        begin
          if Length(Args) >= 1 then
          begin
            var A := Args[0].Trim;
            if A.EndsWith('deg') then A := A.Substring(0, A.Length - 3);
            Style.TransformRotate := Style.TransformRotate + StrToFloatDef(A, 0);
          end;
        end
        else if FnName = 'scale' then
        begin
          if Length(Args) >= 1 then
            Style.TransformScaleX := Style.TransformScaleX * StrToFloatDef(Args[0].Trim, 1);
          if Length(Args) >= 2 then
            Style.TransformScaleY := Style.TransformScaleY * StrToFloatDef(Args[1].Trim, 1)
          else if Length(Args) >= 1 then
            Style.TransformScaleY := Style.TransformScaleY * StrToFloatDef(Args[0].Trim, 1);
        end
        else if FnName = 'scalex' then
        begin
          if Length(Args) >= 1 then
            Style.TransformScaleX := Style.TransformScaleX * StrToFloatDef(Args[0].Trim, 1);
        end
        else if FnName = 'scaley' then
        begin
          if Length(Args) >= 1 then
            Style.TransformScaleY := Style.TransformScaleY * StrToFloatDef(Args[0].Trim, 1);
        end;
      end;
    end;
  end;
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
  ScrollWidth := 0;
  ScrollHeight := 0;
  ScrollX := 0;
  ScrollY := 0;
end;

function TLayoutBox.IsScrollableX: Boolean;
begin
  Result := (Style.OverflowX = 'auto') or (Style.OverflowX = 'scroll');
end;

function TLayoutBox.IsScrollableY: Boolean;
begin
  Result := (Style.OverflowY = 'auto') or (Style.OverflowY = 'scroll');
end;

function TLayoutBox.NeedsScrollBarX: Boolean;
begin
  // hidden scrolls programmatically but never shows a bar
  if (Style.OverflowX = 'visible') or (Style.OverflowX = 'hidden') then
    Exit(False);
  if Style.OverflowX = 'scroll' then
    Exit(True);
  // auto — show only when content exceeds viewport
  Result := ScrollWidth > ContentWidth + 0.5;
end;

function TLayoutBox.NeedsScrollBarY: Boolean;
begin
  if (Style.OverflowY = 'visible') or (Style.OverflowY = 'hidden') then
    Exit(False);
  if Style.OverflowY = 'scroll' then
    Exit(True);
  Result := ScrollHeight > ContentHeight + 0.5;
end;

procedure TLayoutBox.ClampOwnScroll;
var
  MaxX, MaxY: Single;
begin
  if IsScrollableX then
  begin
    MaxX := ScrollWidth - ContentWidth;
    if MaxX < 0 then MaxX := 0;
    if ScrollX < 0 then ScrollX := 0;
    if ScrollX > MaxX then ScrollX := MaxX;
  end
  else
    ScrollX := 0;

  if IsScrollableY then
  begin
    MaxY := ScrollHeight - ContentHeight;
    if MaxY < 0 then MaxY := 0;
    if ScrollY < 0 then ScrollY := 0;
    if ScrollY > MaxY then ScrollY := MaxY;
  end
  else
    ScrollY := 0;
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
  Result := ResolveAutoMargin(Style.Margin.Left) + Style.BorderWidths.Left + Style.Padding.Left +
    ContentWidth + Style.Padding.Right + Style.BorderWidths.Right + ResolveAutoMargin(Style.Margin.Right);
end;

function TLayoutBox.MarginBoxHeight: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Top) + Style.BorderWidths.Top + Style.Padding.Top +
    ContentHeight + Style.Padding.Bottom + Style.BorderWidths.Bottom + ResolveAutoMargin(Style.Margin.Bottom);
end;

function TLayoutBox.ContentLeft: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Left) + Style.BorderWidths.Left + Style.Padding.Left;
end;

function TLayoutBox.ContentTop: Single;
begin
  Result := ResolveAutoMargin(Style.Margin.Top) + Style.BorderWidths.Top + Style.Padding.Top;
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
  if Src = '' then Exit;
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
      var Surf := TBitmapSurface.Create;
      try
        if TBitmapCodecManager.LoadFromStream(Stream, surf) then
        begin
          try
            var Bmp := TBitmap.Create;
            try
              Bmp.Assign(Surf);
              if (Bmp.Width > 0) and (Bmp.Height > 0) then
                FCache.AddOrSetValue(Src, Bmp)
              else
              begin
                // LoadFromStream succeeded but bitmap is empty
                Bmp.Free;
              end;
            except
              Bmp.Free;
            end;
          finally
            Stream.Free;
          end;
        end
      finally
        surf.Free;
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
  FMeasureLayout.Free;
  FRoot.Free;
  inherited;
end;

function TLayoutEngine.GetLineHeight(const Style: TComputedStyle): Single;
begin
  Result := Style.FontSize * Style.LineHeight;
end;

function TLayoutEngine.GetMeasureLayout: TTextLayout;
// Lazy-create-and-reuse a single TTextLayout for all text measurement
// during this engine's lifetime. Callers MUST fully reconfigure it via
// BeginUpdate/EndUpdate — properties may carry over from the previous
// use. The pool saves one FMX TextLayout allocation per word measured
// during inline layout (and per text fragment overall).
begin
  if not Assigned(FMeasureLayout) then
    FMeasureLayout := TTextLayoutManager.DefaultTextLayout.Create;
  Result := FMeasureLayout;
end;

function TLayoutEngine.MeasureTextWidth(const Text: string; const Style: TComputedStyle): Single;
var
  Layout: TTextLayout;
begin
  Layout := GetMeasureLayout;
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
  if (Style.LetterSpacing <> 0) and (Text.Length > 1) then
    Result := Result + Style.LetterSpacing * (Text.Length - 1);
end;

function TLayoutEngine.MeasureTextHeight(const Text: string; const Style: TComputedStyle; MaxWidth: Single): Single;
var
  Layout: TTextLayout;
begin
  if MaxWidth <= 0 then MaxWidth := 10000;
  Layout := GetMeasureLayout;
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
  else if (Style.Display = 'block') or (Style.Display = 'flow-root') or
          (Style.Display = 'flex') then
    // `flow-root` (CSS Display L3) establishes a new block-formatting
    // context. Tina4's LayoutBlock already encloses overhanging floats
    // so a plain block is functionally equivalent — accept the explicit
    // opt-in keyword so authors don't need overflow:hidden hacks.
    // `flex` keeps block outer-display; LayoutBlock detects it and
    // dispatches to LayoutFlex.
    Kind := lbkBlock
  else if (Style.Display = 'inline-block') or (Style.Display = 'inline-flex') then
    Kind := lbkInlineBlock
  else if Style.Display = 'inline-table' then
    // CSS Display Module Level 3 two-value model:
    //   inline-table = outer-display:inline + inner-display:table
    // We reuse the inline-block kind for outer flow (so siblings flow
    // horizontally) and key off Style.Display in LayoutInlineChildren
    // to dispatch the inner layout to LayoutTable instead of LayoutBlock.
    Kind := lbkInlineBlock
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
        // Bubble subtree facts up so the paint pass can short-circuit.
        if ChildBox.HasStickyDescendant then
          Result.HasStickyDescendant := True;
        if ChildBox.HasPositionedDescendant then
          Result.HasPositionedDescendant := True;
      end;
    end;
  end;

  // Self contributes too — a sticky / positioned box marks its OWN flag
  // so the parent's loop above bubbles correctly.
  if Style.CSSPosition = 'sticky' then
  begin
    Result.HasStickyDescendant := True;
    Result.HasPositionedDescendant := True;
  end
  else if (Style.CSSPosition = 'relative') or
          (Style.CSSPosition = 'absolute') or
          (Style.CSSPosition = 'fixed') then
    Result.HasPositionedDescendant := True;

  // Request images
  if Kind = lbkImage then
  begin
    var Src := Tag.GetAttribute('src');
    if (Src <> '') and Assigned(FImageCache) then
      FImageCache.RequestImage(Src);
  end;

  // Request background images
  if (Result.Style.BackgroundImage <> '') and Assigned(FImageCache) then
    FImageCache.RequestImage(Result.Style.BackgroundImage);
end;

function IsPercentageValue(Value: Single): Boolean; inline;
begin
  // Percentages are stored as negative values < -1 (e.g., -100 = 100%, -50 = 50%)
  // The sentinel -1 means 'auto' / unset, so only values below -1 are percentages.
  // Exclude the fit-content sentinel (-3) so it isn't mistaken for a 3% width.
  Result := (Value < -1.01) and not ((Value >= -3.01) and (Value <= -2.99));
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

// True when a margin value was specified as `auto` in CSS.
// Used by block layout to distribute slack horizontally for `margin: 0 auto`
// centering and right-shift for `margin-left: auto`.
function IsAutoMargin(Value: Single): Boolean; inline;
begin
  Result := (Value >= -1.01) and (Value <= -0.99);
end;

// True when a width was specified as `fit-content` (or min/max-content).
// Layout treats these as "shrink to widest child / longest text run".
function IsFitContentWidth(Value: Single): Boolean; inline;
begin
  Result := (Value >= -3.01) and (Value <= -2.99);
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
    Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right;

  // Resolve explicit width (may be percentage of available width)
  ExplW := Box.Style.ExplicitWidth;
  if IsPercentageValue(ExplW) then
  begin
    // Percentage: resolve against available width
    ExplW := ResolvePercentage(ExplW, AvailWidth);
    // Percentage widths behave like border-box: value includes padding + border
    ContentW := ExplW - Box.Style.BorderWidths.Horz -
      Box.Style.Padding.Left - Box.Style.Padding.Right;
  end
  else if ExplW > 0 then
  begin
    if SameText(Box.Style.BoxSizing, 'border-box') then
      // border-box: explicit width includes padding and border
      ContentW := ExplW - Box.Style.BorderWidths.Horz -
        Box.Style.Padding.Left - Box.Style.Padding.Right
    else
      // content-box (default): explicit width IS the content width
      ContentW := ExplW;
  end;

  if ContentW < 0 then ContentW := 0;

  // Apply min/max width constraints BEFORE layout so text wraps correctly
  if (Box.Style.MaxWidth >= 0) and (ContentW > Box.Style.MaxWidth) then
    ContentW := Box.Style.MaxWidth;
  if (Box.Style.MinWidth >= 0) and (ContentW < Box.Style.MinWidth) then
    ContentW := Box.Style.MinWidth;

  Box.ContentWidth := ContentW;
  CursorY := 0;

  // For fit-content boxes, temporarily force text-align to leading during
  // inline layout. Otherwise text fragments get centred to the *parent*
  // available width — leaving them sitting in the middle of a 176px row,
  // which makes the shrink-to-fit pass at the bottom of this routine
  // pointless (ScrollWidth would still report ~176). We restore the
  // original alignment before returning.
  var FitContentSavedAlign := Box.Style.TextAlign;
  var IsFitContentBox := IsFitContentWidth(Box.Style.ExplicitWidth);
  if IsFitContentBox then
    Box.Style.TextAlign := TTextAlign.Leading;

  // `display: flex` (and `inline-flex`) — dispatch to the flex layout
  // algorithm. We still computed ContentW above so the box has a
  // consistent ContentWidth; LayoutFlex will overwrite ContentHeight
  // (and possibly ContentWidth for column flex) once items are placed.
  if (Box.Style.Display = 'flex') or (Box.Style.Display = 'inline-flex') then
  begin
    LayoutFlex(Box, AvailWidth);
    // Apply explicit-height clamp (mirrors what the block path does later).
    if Box.Style.ExplicitHeight > 0 then
    begin
      if SameText(Box.Style.BoxSizing, 'border-box') then
        Box.ContentHeight := Box.Style.ExplicitHeight - Box.Style.BorderWidths.Vert -
          Box.Style.Padding.Top - Box.Style.Padding.Bottom
      else
        Box.ContentHeight := Box.Style.ExplicitHeight;
    end;
    Box.ScrollWidth := Box.ContentWidth;
    Box.ScrollHeight := Box.ContentHeight;
    LayoutAbsoluteChildren(Box);
    Exit;
  end;

  // Block-level form controls (e.g. Bootstrap .form-control sets display:block; width:100%)
  // Size them using LayoutFormControl then return — they have no children to lay out.
  // Native FMX controls handle their own borders, so zero out the CSS border to prevent
  // it from inflating the box model (MarginBoxHeight, ContentLeft, etc.).
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or SameText(Box.Tag.TagName, 'button') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
  begin
    Box.Style.SetBorderWidth(0);
    var InputType := '';
    if Assigned(Box.Tag) then
      InputType := Box.Tag.GetAttribute('type', 'text').ToLower;
    // Checkbox/radio are small fixed-size controls — clear padding and
    // negative margins so they render inline without CSS float offset
    if (InputType = 'checkbox') or (InputType = 'radio') then
    begin
      Box.Style.Padding.Clear;
      // Keep negative margins (used by Bootstrap form-check layout)
      Box.Style.Margin.Top := 0;
      Box.Style.Margin.Bottom := 0;
    end;
    // Recalculate content width without border
    ContentW := AvailWidth - MarginL - MarginR -
      Box.Style.Padding.Left - Box.Style.Padding.Right;
    if ContentW < 0 then ContentW := 0;
    LayoutFormControl(Box, ContentW);
    // Text inputs, textareas, and selects stretch to full available width
    // (Bootstrap .form-control sets width:100%).  Buttons and checkbox/radio
    // keep their intrinsic size from LayoutFormControl.
    if (not SameText(Box.Tag.TagName, 'button')) and
       (InputType <> 'checkbox') and (InputType <> 'radio') and
       (InputType <> 'submit') and (InputType <> 'button') and (InputType <> 'reset') and
       (InputType <> 'file') then
      Box.ContentWidth := ContentW;
    Exit;
  end;

  // Resolve explicit height (may be percentage — but no reference, ignore for now)
  // Percentages on height are complex in CSS; we skip them

  // Determine layout mode: inline vs block. Float children are out of normal
  // flow and don't influence the parent's flow type — they're handled
  // separately inside the block branch below.
  HasInline := False;
  var HasBlock := False;
  for var Child in Box.Children do
  begin
    if Child.Style.CSSFloat <> 'none' then Continue;  // out of flow (float)
    // Absolutely-positioned / fixed children are ALSO out of flow — they
    // must not influence the parent's block-vs-inline formatting context
    // (otherwise an absolute <span> sibling wrongly forces inline layout
    // and the block-only auto-margin vertical-centre never runs).
    if (Child.Style.CSSPosition = 'absolute') or
       (Child.Style.CSSPosition = 'fixed') then Continue;
    case Child.Kind of
      lbkBlock, lbkTable, lbkListItem, lbkHR:
        HasBlock := True;
      lbkImage, lbkFormControl, lbkBR, lbkInline, lbkInlineBlock:
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
      if Child.Style.CSSFloat <> 'none' then Continue;  // out of flow (float)
      if (Child.Style.CSSPosition = 'absolute') or
         (Child.Style.CSSPosition = 'fixed') then Continue;  // out of flow
      if (Child.Kind = lbkImage) or (Child.Kind = lbkFormControl) or
         (Child.Kind = lbkBR) or (Child.Kind = lbkInline) or
         (Child.Kind = lbkInlineBlock) then
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
    // Pure block children, with float support. CSS float positions a child
    // at the parent's left/right edge and removes it from normal flow;
    // subsequent in-flow siblings get shifted past the float and width-
    // reduced for as long as their natural Y is within the float's
    // vertical span. Multiple floats stack: a second left float sits to
    // the right of the first, etc. When a non-floated child reaches a Y
    // past the bottom of all left/right floats, it returns to full width.
    //
    // Limitation: inline content inside an in-flow block child does NOT
    // wrap around floats line-by-line — the whole child box is shifted
    // and width-clamped for its full extent. Good enough for the common
    // "logo on the left, description block on the right" pattern.
    var LeftFloatRight: Single := 0;     // X past rightmost active left float
    var LeftFloatBottom: Single := 0;    // Bottom Y of active left floats
    var RightFloatLeft: Single := ContentW;
    var RightFloatBottom: Single := 0;

    for var Child in Box.Children do
    begin
      // Absolutely-positioned and fixed children are out-of-flow — defer
      // layout until after the in-flow cursor has settled (we lay them
      // out below using the parent's final ContentWidth/Height).
      if (Child.Style.CSSPosition = 'absolute') or
         (Child.Style.CSSPosition = 'fixed') then
        Continue;

      var FloatKind := Child.Style.CSSFloat;
      var IsFloat := (FloatKind = 'left') or (FloatKind = 'right');

      if IsFloat then
      begin
        // Available width inside the band between active floats.
        var FloatAvail := RightFloatLeft - LeftFloatRight;
        if FloatAvail < 0 then FloatAvail := 0;
        case Child.Kind of
          lbkBlock:       LayoutBlock(Child, FloatAvail);
          lbkTable:       LayoutTable(Child, FloatAvail);
          lbkImage:       LayoutImage(Child, FloatAvail);
          lbkListItem:    LayoutListItem(Child, FloatAvail);
          lbkInlineBlock: LayoutBlock(Child, FloatAvail);
          lbkHR:          LayoutHR(Child, FloatAvail);
          lbkFormControl: LayoutFormControl(Child, FloatAvail);
        else
          LayoutBlock(Child, FloatAvail);
        end;

        if FloatKind = 'left' then
        begin
          Child.X := LeftFloatRight;
          Child.Y := CursorY;
          LeftFloatRight := Child.X + Child.MarginBoxWidth;
          if Child.Y + Child.MarginBoxHeight > LeftFloatBottom then
            LeftFloatBottom := Child.Y + Child.MarginBoxHeight;
        end
        else
        begin
          Child.X := RightFloatLeft - Child.MarginBoxWidth;
          Child.Y := CursorY;
          RightFloatLeft := Child.X;
          if Child.Y + Child.MarginBoxHeight > RightFloatBottom then
            RightFloatBottom := Child.Y + Child.MarginBoxHeight;
        end;
        // Floats don't advance the in-flow cursor.
        Continue;
      end;

      // CSS `clear`: push the cursor past the relevant float's bottom
      // BEFORE positioning. clear:left waits for left floats, clear:right
      // for right, clear:both for the latest of either.
      var Clr := Child.Style.CSSClear;
      if (Clr = 'left') or (Clr = 'both') then
        if CursorY < LeftFloatBottom then CursorY := LeftFloatBottom;
      if (Clr = 'right') or (Clr = 'both') then
        if CursorY < RightFloatBottom then CursorY := RightFloatBottom;

      // In-flow child — shift past active floats whose vertical span
      // covers the current cursor.
      var ShiftL: Single := 0;
      var ShiftR: Single := 0;
      if CursorY < LeftFloatBottom  then ShiftL := LeftFloatRight;
      if CursorY < RightFloatBottom then ShiftR := ContentW - RightFloatLeft;
      var EffW := ContentW - ShiftL - ShiftR;
      if EffW < 0 then EffW := 0;

      case Child.Kind of
        lbkBlock: LayoutBlock(Child, EffW);
        lbkTable: LayoutTable(Child, EffW);
        lbkListItem: LayoutListItem(Child, EffW);
        lbkHR: LayoutHR(Child, EffW);
      else
        LayoutBlock(Child, EffW);
      end;

      // Distribute auto margins horizontally — Slack is now relative to
      // the float-reduced effective width, not the parent ContentW.
      var AutoL := IsAutoMargin(Child.Style.Margin.Left);
      var AutoR := IsAutoMargin(Child.Style.Margin.Right);
      if AutoL or AutoR then
      begin
        var ChildOuterW := Child.MarginBoxWidth;
        var Slack := EffW - ChildOuterW;
        if Slack < 0 then Slack := 0;
        if AutoL and AutoR then
          Child.X := ShiftL + Slack / 2
        else if AutoL then
          Child.X := ShiftL + Slack
        else
          Child.X := ShiftL;
      end
      else
        Child.X := ShiftL;
      Child.Y := CursorY;
      CursorY := CursorY + Child.MarginBoxHeight;
    end;

    // Clearfix-equivalent: parent stretches to enclose any float that
    // overhangs below the in-flow content cursor. Without this the
    // floats would visually escape the parent's box.
    if LeftFloatBottom  > CursorY then CursorY := LeftFloatBottom;
    if RightFloatBottom > CursorY then CursorY := RightFloatBottom;
    Box.ContentHeight := CursorY;
  end;

  // Capture intrinsic content size BEFORE clamping to explicit/min/max.
  // This is what scrollbars measure against. For width, also find the
  // furthest right edge any child reaches — children may explicitly
  // overflow their parent horizontally.
  Box.ScrollHeight := Box.ContentHeight;
  Box.ScrollWidth := Box.ContentWidth;
  for var Child in Box.Children do
  begin
    var Right := Child.X + Child.MarginBoxWidth;
    if Right > Box.ScrollWidth then
      Box.ScrollWidth := Right;
    // Text children carry their natural extent in Fragments — MarginBoxWidth
    // would only reflect the (parent-derived) ContentWidth.
    if Child.Kind = lbkText then
    begin
      for var FI := 0 to Child.Fragments.Count - 1 do
      begin
        var FragRight := Child.X + Child.Fragments[FI].X + Child.Fragments[FI].W;
        if FragRight > Box.ScrollWidth then
          Box.ScrollWidth := FragRight;
      end;
    end;
  end;

  // `width: fit-content` (also min-content/max-content) — shrink the box to
  // the widest line / widest child. The children were laid out at the parent
  // ContentW, so text already wrapped at that limit; here we recompute the
  // *intrinsic* extent (max child right + max fragment right) from scratch
  // — independent of ScrollWidth, which was pre-seeded to ContentWidth and
  // therefore never goes below it — and clamp ContentWidth to that.
  if IsFitContentBox then
  begin
    var IntrinsicW: Single := 0;
    for var Child in Box.Children do
    begin
      var ChildRight := Child.X + Child.MarginBoxWidth;
      if ChildRight > IntrinsicW then IntrinsicW := ChildRight;
      if Child.Kind = lbkText then
      begin
        for var FI := 0 to Child.Fragments.Count - 1 do
        begin
          var FragRight := Child.X + Child.Fragments[FI].X + Child.Fragments[FI].W;
          if FragRight > IntrinsicW then IntrinsicW := FragRight;
        end;
      end;
    end;
    if (IntrinsicW > 0) and (IntrinsicW < Box.ContentWidth) then
    begin
      Box.ContentWidth := IntrinsicW;
      Box.ScrollWidth := IntrinsicW;
    end;
    Box.Style.TextAlign := FitContentSavedAlign;
  end;

  if Box.Style.ExplicitHeight > 0 then
  begin
    if SameText(Box.Style.BoxSizing, 'border-box') then
      Box.ContentHeight := Box.Style.ExplicitHeight - Box.Style.BorderWidths.Vert -
        Box.Style.Padding.Top - Box.Style.Padding.Bottom
    else
      Box.ContentHeight := Box.Style.ExplicitHeight;
  end;

  // Clamp to min/max height (width was already applied before layout)
  if (Box.Style.MinHeight >= 0) and (Box.ContentHeight < Box.Style.MinHeight) then
    Box.ContentHeight := Box.Style.MinHeight;
  if (Box.Style.MaxHeight >= 0) and (Box.ContentHeight > Box.Style.MaxHeight) then
    Box.ContentHeight := Box.Style.MaxHeight;

  // Distribute auto margins vertically. Strict CSS spec resolves
  // margin-top/bottom: auto in normal block flow to 0 — but Tina4 has the
  // parent's resolved height and the children's intrinsic heights right here,
  // so it's a pragmatic extension to actually centre. Each block child whose
  // top AND bottom margins are both `auto` claims an equal share of the
  // leftover vertical slack: top absorbs Share/2, bottom absorbs Share/2,
  // and subsequent children shift down by the full Share. Children before
  // an auto-margin child are unaffected.
  //
  // Practical effect: a single child with `margin: auto` inside a parent
  // with explicit `height` is vertically centred — which is what the
  // tile/label pattern expects.
  if (Box.ContentHeight > CursorY) and (CursorY > 0) then
  begin
    var VSlack := Box.ContentHeight - CursorY;
    var AutoCount := 0;
    for var Child in Box.Children do
    begin
      if (Child.Kind in [lbkBlock, lbkTable, lbkListItem, lbkHR, lbkInlineBlock]) and
         IsAutoMargin(Child.Style.Margin.Top) and
         IsAutoMargin(Child.Style.Margin.Bottom) then
        Inc(AutoCount);
    end;
    if AutoCount > 0 then
    begin
      var Share := VSlack / AutoCount;
      var YOff: Single := 0;
      for var Child in Box.Children do
      begin
        Child.Y := Child.Y + YOff;
        if (Child.Kind in [lbkBlock, lbkTable, lbkListItem, lbkHR, lbkInlineBlock]) and
           IsAutoMargin(Child.Style.Margin.Top) and
           IsAutoMargin(Child.Style.Margin.Bottom) then
        begin
          Child.Y := Child.Y + Share / 2;  // top auto absorbs half
          YOff := YOff + Share;            // bottom auto absorbs the other half
        end;
      end;
    end;
  end;

  // If the box is not scrollable, keep ScrollHeight/Width in lockstep with
  // the clamped ContentHeight/Width so NeedsScrollBar* never fires for
  // non-scroll containers. ClampOwnScroll relies on these values.
  if not Box.IsScrollableY then
    Box.ScrollHeight := Box.ContentHeight;
  if not Box.IsScrollableX then
    Box.ScrollWidth := Box.ContentWidth;

  // Position any absolute / fixed children now that the containing block
  // (this Box) has its final ContentWidth + ContentHeight.
  LayoutAbsoluteChildren(Box);
end;

procedure TLayoutEngine.LayoutInlineChildren(Box: TLayoutBox; AvailWidth: Single);
var
  CursorX, CursorY, LineH: Single;
  SpaceW: Single;
  // When the container has `white-space: nowrap`, inline and inline-block
  // children must stay on a single line regardless of whether they exceed
  // the available width. The overflow clip (if any) hides the spill.
  NoWrap: Boolean;

  procedure ProcessInlineBox(Child: TLayoutBox);
  var
    Words: TArray<string>;
    WordW, WordH: Single;
    Frag: TTextFragment;
  begin
    // Absolutely-positioned / fixed children are OUT OF FLOW. They must
    // not advance CursorX, must not force a line break, and must not
    // contribute to line height. LayoutAbsoluteChildren positions them
    // afterwards against the containing block. Without this skip an
    // absolute badge inside a text paragraph would steal inline space
    // (and a block-level absolute child would even force a line break)
    // — which looks like "position:absolute doesn't work" because the
    // surrounding content gets pushed around.
    if (Child.Style.CSSPosition = 'absolute') or
       (Child.Style.CSSPosition = 'fixed') then
      Exit;

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
      var ImgW := Child.MarginBoxWidth;
      if (not NoWrap) and (CursorX > 0) and (CursorX + ImgW > AvailWidth) then
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
      var CtlW := Child.MarginBoxWidth;
      if (not NoWrap) and (CursorX > 0) and (CursorX + CtlW > AvailWidth) then
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

    // Inline-block: internally formatted as block, placed in inline flow
    if Child.Kind = lbkInlineBlock then
    begin
      // For shrink-to-fit inline-blocks, temporarily disable text-align
      // centering during layout. When there's no explicit width, the box
      // shrinks to fit its content, making centering a no-op.  The centering
      // code in LayoutInlineChildren uses the initial (large) available width,
      // which would push text fragments outside the eventually-shrunk box.
      var SavedAlign := Child.Style.TextAlign;
      if Child.Style.ExplicitWidth < 0 then
        Child.Style.TextAlign := TTextAlign.Leading;

      // For `display: inline-table` we route the inner layout through
      // LayoutTable (so anonymous-row wrapping for orphan table-cells and
      // per-column widths kick in), but keep the outer placement inline
      // — same path as inline-block.
      var IsInlineTable := (Child.Style.Display = 'inline-table');

      // Use shrink-to-fit width: lay out with available width, then shrink.
      // Under nowrap the child shouldn't be squeezed by the remaining row
      // space — give it the full container width so its intrinsic size wins.
      if NoWrap then
      begin
        if IsInlineTable then LayoutTable(Child, AvailWidth)
        else                  LayoutBlock(Child, AvailWidth);
      end
      else
      begin
        if IsInlineTable then LayoutTable(Child, AvailWidth - CursorX)
        else                  LayoutBlock(Child, AvailWidth - CursorX);
      end;
      // If no explicit width, shrink content width to fit children. For
      // inline-table this is unnecessary — LayoutTable already produces
      // a width-fitted box from its column sums.
      if (not IsInlineTable) and (Child.Style.ExplicitWidth < 0) then
      begin
        var MaxChildRight: Single := 0;
        for var GC in Child.Children do
          MaxChildRight := Max(MaxChildRight, GC.X + GC.MarginBoxWidth);
        if MaxChildRight > 0 then
          Child.ContentWidth := MaxChildRight;
      end;

      // Restore text-align
      Child.Style.TextAlign := SavedAlign;

      var BoxW := Child.MarginBoxWidth;
      if (not NoWrap) and (CursorX > 0) and (CursorX + BoxW > AvailWidth) then
      begin
        CursorY := CursorY + LineH;
        CursorX := 0;
        LineH := GetLineHeight(Child.Style);
        // Re-layout with full available width after wrap
        if Child.Style.ExplicitWidth < 0 then
          Child.Style.TextAlign := TTextAlign.Leading;
        if IsInlineTable then
          LayoutTable(Child, AvailWidth)
        else
          LayoutBlock(Child, AvailWidth);
        if (not IsInlineTable) and (Child.Style.ExplicitWidth < 0) then
        begin
          var MaxChildRight2: Single := 0;
          for var GC in Child.Children do
            MaxChildRight2 := Max(MaxChildRight2, GC.X + GC.MarginBoxWidth);
          if MaxChildRight2 > 0 then
            Child.ContentWidth := MaxChildRight2;
        end;
        Child.Style.TextAlign := SavedAlign;
        BoxW := Child.MarginBoxWidth;
      end;
      Child.X := CursorX;
      Child.Y := CursorY;
      CursorX := CursorX + BoxW;
      LineH := Max(LineH, Child.MarginBoxHeight);
      Exit;
    end;

    if Child.Kind = lbkText then
    begin
      var Text := Child.Tag.Text;
      if Text = '' then Exit;

      // Apply text-transform
      if Child.Style.TextTransform = 'uppercase' then
        Text := Text.ToUpper
      else if Child.Style.TextTransform = 'lowercase' then
        Text := Text.ToLower
      else if Child.Style.TextTransform = 'capitalize' then
      begin
        var CapText := Text;
        var PrevSpace := True;
        for var C := 1 to Length(CapText) do
        begin
          if PrevSpace and CapText[C].IsLetter then
            CapText[C] := CapText[C].ToUpper;
          PrevSpace := CapText[C].IsWhiteSpace;
        end;
        Text := CapText;
      end;

      // Whitespace-only text between inline elements creates a space gap
      if (Text.Trim = '') and (Child.Style.WhiteSpace <> 'pre') then
      begin
        if CursorX > 0 then
          CursorX := CursorX + MeasureTextWidth(' ', Child.Style);
        Child.X := CursorX;
        Child.Y := CursorY;
        Child.ContentWidth := 0;
        Child.ContentHeight := 0;
        Exit;
      end;

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
      var BreakAll := (Child.Style.WordBreak = 'break-all');
      var BreakWord := (Child.Style.OverflowWrap = 'break-word') or
                        (Child.Style.OverflowWrap = 'anywhere');

      if BreakAll then
      begin
        // word-break: break-all — split text into individual characters
        SetLength(Words, Text.Length);
        for var J := 0 to Text.Length - 1 do
          Words[J] := string(Text[J + 1]);
      end
      else
        Words := Text.Split([' ']);

      Child.X := CursorX;
      Child.Y := CursorY;

      for var WI := 0 to Length(Words) - 1 do
      begin
        var W := Words[WI];
        if W = '' then Continue;

        WordW := MeasureTextWidth(W, Child.Style);
        WordH := GetLineHeight(Child.Style);

        // overflow-wrap: break-word — break long words that overflow
        // (nowrap containers never break — the word must stay on one line)
        if (not NoWrap) and BreakWord and (not BreakAll) and (WordW > AvailWidth) and (W.Length > 1) then
        begin
          // Split the word character by character
          var Remaining := W;
          while Remaining <> '' do
          begin
            var Chunk := '';
            var ChunkW: Single := 0;
            for var K := 1 to Remaining.Length do
            begin
              var TestChunk := Remaining.Substring(0, K);
              var TestW := MeasureTextWidth(TestChunk, Child.Style);
              if (ChunkW > 0) and (CursorX + TestW > AvailWidth) then
                Break;
              Chunk := TestChunk;
              ChunkW := TestW;
            end;
            if Chunk = '' then
            begin
              Chunk := string(Remaining[1]);
              ChunkW := MeasureTextWidth(Chunk, Child.Style);
            end;

            Frag.Text := Chunk;
            Frag.X := CursorX - Child.X;
            Frag.Y := CursorY - Child.Y;
            Frag.W := ChunkW;
            Frag.H := WordH;
            Child.Fragments.Add(Frag);
            CursorX := CursorX + ChunkW;
            LineH := Max(LineH, WordH);
            Remaining := Remaining.Substring(Chunk.Length);
            if (Remaining <> '') and (CursorX >= AvailWidth) then
            begin
              CursorY := CursorY + LineH;
              CursorX := 0;
              LineH := WordH;
            end;
          end;
          CursorX := CursorX + SpaceW;
          Continue;
        end;

        // Wrap if needed — but not if the parent has white-space: nowrap
        if (not NoWrap) and (CursorX > 0) and (CursorX + WordW > AvailWidth) then
        begin
          CursorY := CursorY + LineH;
          CursorX := 0;
          LineH := WordH;
        end;

        Frag.Text := W;
        Frag.X := CursorX - Child.X;  // relative to text node start
        Frag.Y := CursorY - Child.Y;  // relative to text node start
        Frag.W := WordW;
        Frag.H := WordH;
        Child.Fragments.Add(Frag);

        if BreakAll then
          CursorX := CursorX + WordW  // no space between chars
        else
          CursorX := CursorX + WordW + SpaceW;
        LineH := Max(LineH, WordH);
      end;

      // Calculate child bounds
      if Child.Fragments.Count > 0 then
      begin
        var MinY := Child.Fragments[0].Y;
        var MaxY := Child.Fragments[0].Y + Child.Fragments[0].H;
        var MaxRight: Single := 0;
        for var F in Child.Fragments do
        begin
          MinY := Min(MinY, F.Y);
          MaxY := Max(MaxY, F.Y + F.H);
          MaxRight := Max(MaxRight, F.X + F.W);
        end;
        Child.ContentHeight := MaxY - MinY;
        // Width = the widest line's right edge, NOT the running cursor.
        // CursorX includes the inter-word space appended after the LAST
        // word, and after a wrap it reflects only the (possibly shorter)
        // final line. Both inflated/deflated inline-block shrink-to-fit,
        // so a chat-bubble background painted one space wider than its
        // text (visible as asymmetric padding on centered bubbles).
        // The parent flow cursor still advances past the trailing space —
        // only the box's own reported width changes here.
        Child.ContentWidth := MaxRight;
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
      CursorX := CursorX + Child.Style.Margin.Left + Child.Style.BorderWidths.Left +
        Child.Style.Padding.Left;

      // Content origin in parent block coordinates
      var ContentOriginX := CursorX;
      var ContentOriginY := CursorY;

      for var GrandChild in Child.Children do
        ProcessInlineBox(GrandChild);
      var ContentEndX := CursorX;

      // Advance cursor past right padding + border + margin
      CursorX := CursorX + Child.Style.Padding.Right + Child.Style.BorderWidths.Right +
        Child.Style.Margin.Right;

      // Calculate content width — just the inner text portion
      if CursorY = StartY then
        Child.ContentWidth := ContentEndX - ContentOriginX
      else
        Child.ContentWidth := AvailWidth - Child.Style.Margin.Left - Child.Style.Margin.Right -
          Child.Style.BorderWidths.Horz - Child.Style.Padding.Left - Child.Style.Padding.Right;

      // Use the inline container's own line height for its content height,
      // not the parent's LineH which may have grown from previous inline siblings.
      Child.ContentHeight := (CursorY + GetLineHeight(Child.Style)) - StartY;

      // Make grandchild coordinates relative to the inline container's content area
      // (so PaintBox's ContentLeft/ContentTop offset works correctly).
      // Fragment positions are already relative to their text node's X/Y, so they
      // move automatically when the text node is repositioned — no separate adjustment needed.
      var InnerMaxRight: Single := 0;
      for var GrandChild in Child.Children do
      begin
        GrandChild.X := GrandChild.X - ContentOriginX;
        GrandChild.Y := GrandChild.Y - ContentOriginY;
        InnerMaxRight := Max(InnerMaxRight, GrandChild.X + GrandChild.MarginBoxWidth);
      end;
      // Single-line width: prefer the children's true extents over the
      // running cursor — ContentEndX includes the trailing inter-word
      // space a final text child appended (same chat-bubble bug as the
      // text-node width: <small>System 09:16</small> reported one space
      // too wide, inflating the inline-block shrink-to-fit background).
      if (CursorY = StartY) and (InnerMaxRight > 0) then
        Child.ContentWidth := InnerMaxRight;

      // Include full inline box height in line height
      LineH := Max(LineH, Child.Style.Margin.Top + Child.Style.BorderWidths.Top +
        Child.Style.Padding.Top + Child.ContentHeight +
        Child.Style.Padding.Bottom + Child.Style.BorderWidths.Bottom + Child.Style.Margin.Bottom);
    end;
  end;

begin
  NoWrap := SameText(Box.Style.WhiteSpace, 'nowrap');
  CursorX := Box.Style.TextIndent;
  CursorY := 0;
  LineH := GetLineHeight(Box.Style);

  // Clear any fragments from a previous layout pass (e.g. when an inline-block
  // is laid out twice — first to measure, then again after wrapping).
  for var Child in Box.Children do
    if Child.Kind = lbkText then
      Child.Fragments.Clear;

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

        var Shift: Single;
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
  BorderW := Box.Style.BorderWidths.Top;
  Rows := TList<TLayoutBox>.Create;
  // Synthetic anonymous rows generated for orphan table-cell children of
  // a `display:table` box (CSS 2.1 §17.2.1). The synthetic rows hold
  // *references* to the cells (Children.OwnsObjects = False); the cells
  // themselves stay in Box.Children so the painter still finds them as
  // direct descendants of the table. After layout we convert the cells'
  // row-relative Y to table-relative Y.
  var SyntheticRows := TObjectList<TLayoutBox>.Create(True);
  try
    // Collect all row boxes (flattening thead/tbody/tfoot). Orphan cells
    // — direct table-cell children of a `display:table` parent without a
    // `display:table-row` wrapper — get rolled up into anonymous rows.
    //
    // CSS / HTML spec: <tfoot> renders below <tbody> regardless of source
    // order. <thead> renders above. So we bucket by group identity (read
    // off the underlying THTMLTag name) and only concatenate at the end
    // in `thead -> body+anonymous -> tfoot` order.
    var HeadRows := TList<TLayoutBox>.Create;
    var BodyRows := TList<TLayoutBox>.Create;
    var FootRows := TList<TLayoutBox>.Create;
    try
      var CurrentSyn: TLayoutBox := nil;
      for var Child in Box.Children do
      begin
        if Child.Kind = lbkTableRow then
        begin
          CurrentSyn := nil;  // a real row terminates any synthetic-row run
          // Identify the group this row(s) belongs to by the HTML tag.
          var Target: TList<TLayoutBox> := BodyRows;
          if Assigned(Child.Tag) then
          begin
            if SameText(Child.Tag.TagName, 'thead') then Target := HeadRows
            else if SameText(Child.Tag.TagName, 'tfoot') then Target := FootRows;
          end;
          // Check if this is a row group (thead/tbody/tfoot) containing actual rows
          var HasSubRows := False;
          for var Sub in Child.Children do
          begin
            if Sub.Kind = lbkTableRow then
            begin
              Target.Add(Sub);
              HasSubRows := True;
            end;
          end;
          if not HasSubRows then
            Target.Add(Child);
        end
        else if Child.Kind = lbkTableCell then
        begin
          // Orphan cell — start (or continue) an anonymous row.
          if CurrentSyn = nil then
          begin
            CurrentSyn := TLayoutBox.Create(nil, lbkTableRow);
            CurrentSyn.Children.OwnsObjects := False;
            CurrentSyn.Style := TComputedStyle.Default;
            SyntheticRows.Add(CurrentSyn);
            BodyRows.Add(CurrentSyn);
          end;
          CurrentSyn.Children.Add(Child);
        end;
        // Other kinds (whitespace text nodes, stray inline elements between
        // cells, etc.) don't break the synthetic-row run — only an explicit
        // <tr> does. This matches browser behaviour and survives the HTML
        // parser inserting #text nodes for inter-element whitespace.
      end;

      // Concatenate in spec order: head, body+anonymous, foot.
      for var R in HeadRows do Rows.Add(R);
      for var R in BodyRows do Rows.Add(R);
      for var R in FootRows do Rows.Add(R);
    finally
      HeadRows.Free;
      BodyRows.Free;
      FootRows.Free;
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
      Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right;
    if IsPercentageValue(Box.Style.ExplicitWidth) then
    begin
      // Percentage width — resolved value includes padding + border
      TableContentW := ResolvePercentage(Box.Style.ExplicitWidth, AvailWidth) -
        Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right;
    end
    else if Box.Style.ExplicitWidth > 0 then
    begin
      if SameText(Box.Style.BoxSizing, 'border-box') then
        TableContentW := Box.Style.ExplicitWidth -
          Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right
      else
        TableContentW := Box.Style.ExplicitWidth;
    end;

    // Use collapsed borders — adjacent cells share a single border line.
    // No spacing between cells; PaintTableCellBorders draws a single grid.
    var CellBorderW: Single := 0;  // no inter-cell spacing in collapsed mode
    var AvailForCols := TableContentW;
    if AvailForCols < 0 then AvailForCols := 0;

    // Column widths: read declarations in priority order
    //   1. <colgroup>/<col> children of the table (highest — CSS spec)
    //   2. First cell in each column to declare a width via
    //      `style="width:..."`, `width="..."` HTML attr, or any CSS rule
    //      (all flow through Cell.Style.ExplicitWidth)
    //   3. Equal share of whatever space remains
    // Percentages resolve against the table's content width. We implement
    // the browser's `table-layout: fixed` model — no content-aware auto
    // sizing.
    SetLength(ColWidths, NumCols);
    for var I := 0 to NumCols - 1 do
      ColWidths[I] := -1;  // -1 = not yet assigned

    // Pass 1: <colgroup>/<col> on the source DOM. <col> is a void element
    // and never appears in the layout box tree as a table-cell — we have
    // to walk Box.Tag directly. Both forms are supported:
    //   <table><col style="width:50%"><col style="width:50%">...</table>
    //   <table><colgroup><col span="2" width="100"/></colgroup>...</table>
    if Assigned(Box.Tag) then
    begin
      var ColAccumIdx := 0;
      var WalkColTags: TProc<THTMLTag>;
      WalkColTags := procedure(ParentTag: THTMLTag)
      begin
        if ParentTag = nil then Exit;
        for var SubTag in ParentTag.Children do
        begin
          if SameText(SubTag.TagName, 'colgroup') then
            WalkColTags(SubTag)
          else if SameText(SubTag.TagName, 'col') then
          begin
            var Span := StrToIntDef(SubTag.GetAttribute('span', '1'), 1);
            if Span < 1 then Span := 1;
            // Compute the col's style — picks up `style="width:..."`,
            // `width="..."` HTML attr, and any CSS rule targeting <col>.
            var ColStyle := TComputedStyle.ForTag(SubTag, Box.Style, FStyleSheet);
            var ColW := ColStyle.ExplicitWidth;
            var Resolved: Single := -1;
            if IsPercentageValue(ColW) then
              Resolved := ResolvePercentage(ColW, AvailForCols)
            else if ColW > 0 then
              Resolved := ColW;
            for var SI := 0 to Span - 1 do
            begin
              if ColAccumIdx >= NumCols then Break;
              if (Resolved >= 0) and (ColWidths[ColAccumIdx] < 0) then
                ColWidths[ColAccumIdx] := Resolved;
              Inc(ColAccumIdx);
            end;
          end;
        end;
      end;
      WalkColTags(Box.Tag);
    end;

    // Pass 2: per-cell declarations from any row. First decl per column
    // wins. Cells with colspan > 1 don't contribute (would need
    // content-aware splitting we don't implement).
    for var Row in Rows do
    begin
      var ColIdxScan := 0;
      for var Cell in Row.Children do
      begin
        if Cell.Kind <> lbkTableCell then Continue;
        if ColIdxScan >= NumCols then Break;
        var ScanCS := StrToIntDef(Cell.Tag.GetAttribute('colspan', '1'), 1);
        if (ScanCS = 1) and (ColWidths[ColIdxScan] < 0) then
        begin
          var DeclW := Cell.Style.ExplicitWidth;
          if IsPercentageValue(DeclW) then
            ColWidths[ColIdxScan] := ResolvePercentage(DeclW, AvailForCols)
          else if DeclW > 0 then
            ColWidths[ColIdxScan] := DeclW;
        end;
        Inc(ColIdxScan, ScanCS);
      end;
    end;

    // Sum declared widths; share remaining space among unsized columns.
    var SizedTotal: Single := 0;
    var UnsizedCount := 0;
    for var I := 0 to NumCols - 1 do
      if ColWidths[I] >= 0 then
        SizedTotal := SizedTotal + ColWidths[I]
      else
        Inc(UnsizedCount);

    if UnsizedCount > 0 then
    begin
      var PerCol := (AvailForCols - SizedTotal) / UnsizedCount;
      if PerCol < 0 then PerCol := 0;
      for var I := 0 to NumCols - 1 do
        if ColWidths[I] < 0 then
          ColWidths[I] := PerCol;
    end
    else if (SizedTotal > 0) and (Abs(SizedTotal - AvailForCols) > 0.5) then
    begin
      // All columns specified but they don't sum to the available width
      // (e.g. percentages totalling 99% from rounding, or pixel widths
      // shorter than the parent). Scale proportionally so the table still
      // fills its declared width — that's what `table-layout: fixed`
      // does in browsers.
      var Scale := AvailForCols / SizedTotal;
      for var I := 0 to NumCols - 1 do
        ColWidths[I] := ColWidths[I] * Scale;
    end;

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
             (CellChild.Kind = lbkBR) or (CellChild.Kind = lbkInline) or
             (CellChild.Kind = lbkInlineBlock) then
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
            // Absolute / fixed cell children are out of flow — don't
            // advance the in-flow cursor; LayoutAbsoluteChildren places
            // them below once the cell's content size is known.
            if (CellChild.Style.CSSPosition = 'absolute') or
               (CellChild.Style.CSSPosition = 'fixed') then Continue;
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

        // Position absolute / fixed descendants of the cell against the
        // cell's content area (the cell is their containing block).
        LayoutAbsoluteChildren(Cell);

        Cell.X := CellX;
        Cell.Y := 0;  // Cell position is relative to the row, not the table
        Cell.ContentWidth := CellContentW;

        RowH := Max(RowH, Cell.ContentHeight + Cell.Style.Padding.Top + Cell.Style.Padding.Bottom);
        CellX := CellX + CellW + CellBorderW;
        Inc(ColIdx, CS);
      end;

      // Set uniform row height, then apply vertical-align on each cell.
      // Cells default to top alignment; explicit `vertical-align: middle`
      // (CSS) or `valign="middle"` (legacy HTML attr) shifts the cell's
      // direct children down by half the slack, `bottom`/`valign="bottom"`
      // shifts by the full slack. Anything else (top/baseline/empty) is
      // a no-op.
      for var Cell in Row.Children do
      begin
        if Cell.Kind <> lbkTableCell then Continue;

        var NaturalH := Cell.ContentHeight;
        var StretchedH := RowH - Cell.Style.Padding.Top - Cell.Style.Padding.Bottom;
        Cell.ContentHeight := StretchedH;

        if StretchedH <= NaturalH then Continue;

        var VA := Cell.Style.VerticalAlign;
        // Fall back to legacy <td valign="..."> when no CSS is set
        if (VA = '') or (VA = 'baseline') then
        begin
          var ValignAttr := '';
          if Assigned(Cell.Tag) then
            ValignAttr := Cell.Tag.GetAttribute('valign', '').ToLower;
          if ValignAttr <> '' then
            VA := ValignAttr;
        end;

        var Offset: Single := 0;
        if (VA = 'middle') or (VA = 'center') then
          Offset := (StretchedH - NaturalH) / 2
        else if VA = 'bottom' then
          Offset := StretchedH - NaturalH;

        if Offset > 0 then
        begin
          for var CellChild in Cell.Children do
            CellChild.Y := CellChild.Y + Offset;
        end;
      end;

      Row.X := 0;
      Row.Y := CursorY;
      Row.ContentWidth := TableContentW;
      Row.ContentHeight := RowH;
      CursorY := CursorY + RowH + CellBorderW;
    end;

    // Synthetic anonymous rows aren't in Box.Children — the painter sees
    // their cells as direct children of the table. Promote each cell's
    // row-relative Y into table-relative Y so it paints in the right place.
    for var SynRow in SyntheticRows do
    begin
      for var Cell in SynRow.Children do
        Cell.Y := Cell.Y + SynRow.Y;
    end;

    // Promote <thead>/<tbody>/<tfoot> row groups from "zero-height phantom
    // pass-through" to proper containers with Y and ContentHeight derived
    // from their TR children. This is what makes `position: sticky` work
    // on `<thead>` — without it, sticky pinning would apply to a 0x0
    // box and the underlying TR (still positioned in TABLE coordinates)
    // would scroll away with the rest of the table.
    //
    // After this pass, each row-group container:
    //   * Y     = the Y of its first <tr> (table-relative)
    //   * Hgt   = sum of its <tr> heights
    //   * Each <tr> child has its Y rewritten to be *container-relative*,
    //     so paint produces the same absolute Y as before (the rendering
    //     hierarchy is now consistent with the CSS box model).
    for var GroupCandidate in Box.Children do
    begin
      if GroupCandidate.Kind <> lbkTableRow then Continue;
      // Only operate on row GROUPS (thead/tbody/tfoot whose children are
      // themselves table-rows). Plain <tr> children of the table are
      // skipped — their Y is already correct (table-relative).
      var HasSubRowChildren := False;
      for var Sub in GroupCandidate.Children do
        if Sub.Kind = lbkTableRow then
        begin
          HasSubRowChildren := True;
          Break;
        end;
      if not HasSubRowChildren then Continue;

      // Compute the group's bounding box from its sub-row positions.
      var MinSubY: Single := MaxSingle;
      var MaxSubBottom: Single := 0;
      for var Sub in GroupCandidate.Children do
      begin
        if Sub.Kind <> lbkTableRow then Continue;
        if Sub.Y < MinSubY then MinSubY := Sub.Y;
        if Sub.Y + Sub.ContentHeight > MaxSubBottom then
          MaxSubBottom := Sub.Y + Sub.ContentHeight;
      end;
      if MinSubY = MaxSingle then Continue;  // no rows actually found

      GroupCandidate.X := 0;
      GroupCandidate.Y := MinSubY;
      GroupCandidate.ContentWidth := TableContentW;
      GroupCandidate.ContentHeight := MaxSubBottom - MinSubY;

      // Rewrite each sub-row's Y to be relative to its container instead
      // of the table.
      for var Sub in GroupCandidate.Children do
        if Sub.Kind = lbkTableRow then
          Sub.Y := Sub.Y - MinSubY;
    end;

    Box.ContentWidth := TableContentW;
    Box.ContentHeight := CursorY;
  finally
    Rows.Free;
    SyntheticRows.Free;
  end;
end;

procedure TLayoutEngine.LayoutFlex(Box: TLayoutBox; AvailWidth: Single);
// CSS Flexbox subset:
//   * row + row-reverse + column + column-reverse main axes
//   * justify-content: flex-start / flex-end / center / space-between /
//                      space-around / space-evenly
//   * align-items: flex-start / flex-end / center / stretch
//   * flex-grow / flex-shrink / flex-basis on items (also `flex` shorthand)
//   * gap / row-gap / column-gap between items
// Not implemented: flex-wrap (single-line layout), align-self, baseline
//   alignment, multi-line align-content, intrinsic-size resolution beyond
//   "lay out at container size, take resulting width". Good enough for the
//   90% of "row of buttons / centred logo / two-column grow layout"
//   patterns that drive most app UI.
var
  IsRow, IsReverse: Boolean;
  ContentW, MarginL, MarginR, ExpW: Single;
  Items: TList<TLayoutBox>;
  HypoSizes, FinalSizes: TArray<Single>;
  CrossSize: Single;
  Gap: Single;
  I: Integer;

  procedure LayoutItemAt(Item: TLayoutBox; ItemAvail: Single);
  begin
    case Item.Kind of
      lbkBlock, lbkInlineBlock: LayoutBlock(Item, ItemAvail);
      lbkImage: LayoutImage(Item, ItemAvail);
      lbkTable: LayoutTable(Item, ItemAvail);
      lbkListItem: LayoutListItem(Item, ItemAvail);
      lbkFormControl: LayoutFormControl(Item, ItemAvail);
    else
      LayoutBlock(Item, ItemAvail);
    end;
  end;

begin
  IsRow := (Box.Style.FlexDirection = '') or
           (Box.Style.FlexDirection = 'row') or
           (Box.Style.FlexDirection = 'row-reverse');
  IsReverse := (Box.Style.FlexDirection = 'row-reverse') or
               (Box.Style.FlexDirection = 'column-reverse');
  Gap := Box.Style.FlexGap;

  // Resolve content width — same dance as LayoutBlock's prologue.
  MarginL := ResolveMargin(Box.Style.Margin.Left);
  MarginR := ResolveMargin(Box.Style.Margin.Right);
  ContentW := AvailWidth - MarginL - MarginR -
    Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right;
  ExpW := Box.Style.ExplicitWidth;
  if IsPercentageValue(ExpW) then
    ContentW := ResolvePercentage(ExpW, AvailWidth) -
      Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right
  else if ExpW > 0 then
  begin
    if SameText(Box.Style.BoxSizing, 'border-box') then
      ContentW := ExpW - Box.Style.BorderWidths.Horz -
        Box.Style.Padding.Left - Box.Style.Padding.Right
    else
      ContentW := ExpW;
  end;
  if ContentW < 0 then ContentW := 0;
  Box.ContentWidth := ContentW;

  // Container's main-axis size is ContentW (row) or its content height
  // (column — but height isn't known until items lay out, so we use the
  // explicit height if any, otherwise fall back to AvailWidth as a
  // proxy and let stretch absorb).
  var MainSize: Single;
  if IsRow then MainSize := ContentW
  else if Box.Style.ExplicitHeight > 0 then MainSize := Box.Style.ExplicitHeight
  else MainSize := AvailWidth;  // best-effort proxy

  Items := TList<TLayoutBox>.Create;
  try
    // Collect flex items. Skip floats (taken out of flow), display:none
    // children (already filtered upstream), absolute/fixed positioned
    // children (laid out separately by LayoutAbsoluteChildren), and
    // empty whitespace text.
    for var Child in Box.Children do
    begin
      if Child.Style.CSSFloat <> 'none' then Continue;
      if (Child.Style.CSSPosition = 'absolute') or
         (Child.Style.CSSPosition = 'fixed') then Continue;
      if (Child.Kind = lbkText) and Assigned(Child.Tag) and
         (Child.Tag.Text.Trim = '') then Continue;
      Items.Add(Child);
    end;

    if Items.Count = 0 then
    begin
      Box.ContentHeight := 0;
      Exit;
    end;

    // Phase 1: hypothetical main size for each item.
    //   1. flex-basis explicit -> use that
    //   2. width / height explicit -> use that
    //   3. flex-grow > 0 (and no explicit basis/size) -> treat hypothetical
    //      as 0. This matches the common `flex: 1` / `flex-grow: 1`
    //      "fill the remaining space" intent — a hypothetical of 0 leaves
    //      all the container's main-size as Remaining for grow distribution.
    //   4. otherwise -> lay out tentatively and measure intrinsic main size
    SetLength(HypoSizes, Items.Count);
    for I := 0 to Items.Count - 1 do
    begin
      var Item := Items[I];
      var ItemMainSize: Single := -1;
      if Item.Style.FlexBasis >= 0 then
        ItemMainSize := Item.Style.FlexBasis
      else if IsRow and (Item.Style.ExplicitWidth > 0) then
        ItemMainSize := Item.Style.ExplicitWidth
      else if (not IsRow) and (Item.Style.ExplicitHeight > 0) then
        ItemMainSize := Item.Style.ExplicitHeight
      else if Item.Style.FlexGrow > 0 then
        ItemMainSize := 0;

      if ItemMainSize < 0 then
      begin
        // Lay out tentatively at the container's main size to get an
        // intrinsic measure.
        LayoutItemAt(Item, MainSize);
        if IsRow then ItemMainSize := Item.MarginBoxWidth
        else ItemMainSize := Item.MarginBoxHeight;
      end;
      HypoSizes[I] := ItemMainSize;
    end;

    // Phase 2: distribute remaining space among grow/shrink items.
    SetLength(FinalSizes, Items.Count);
    for I := 0 to Items.Count - 1 do FinalSizes[I] := HypoSizes[I];
    var TotalBasis: Single := 0;
    for var H in HypoSizes do TotalBasis := TotalBasis + H;
    var TotalGap := Gap * Max(0, Items.Count - 1);
    var Remaining := MainSize - TotalBasis - TotalGap;

    if Remaining > 0 then
    begin
      var TotalGrow: Single := 0;
      for var Item in Items do TotalGrow := TotalGrow + Item.Style.FlexGrow;
      if TotalGrow > 0 then
        for I := 0 to Items.Count - 1 do
          FinalSizes[I] := FinalSizes[I] + Remaining * (Items[I].Style.FlexGrow / TotalGrow);
    end
    else if Remaining < 0 then
    begin
      var TotalShrink: Single := 0;
      for var Item in Items do TotalShrink := TotalShrink + Item.Style.FlexShrink;
      if TotalShrink > 0 then
      begin
        for I := 0 to Items.Count - 1 do
          FinalSizes[I] := FinalSizes[I] +
            Remaining * (Items[I].Style.FlexShrink / TotalShrink);
        for I := 0 to Items.Count - 1 do
          if FinalSizes[I] < 0 then FinalSizes[I] := 0;
      end;
    end;

    // Phase 3: lay out items at their final main-axis size and find the
    // tallest cross-axis extent. Forcing main size via ExplicitWidth/Height
    // is the simplest way to get LayoutBlock to size the item correctly;
    // any prior explicit size on the item is overridden by flex.
    var MaxCrossSize: Single := 0;
    for I := 0 to Items.Count - 1 do
    begin
      var Item := Items[I];
      if IsRow then
      begin
        Item.Style.ExplicitWidth := FinalSizes[I];
        LayoutItemAt(Item, FinalSizes[I]);
        if Item.MarginBoxHeight > MaxCrossSize then MaxCrossSize := Item.MarginBoxHeight;
      end
      else
      begin
        Item.Style.ExplicitHeight := FinalSizes[I];
        LayoutItemAt(Item, ContentW);
        if Item.MarginBoxWidth > MaxCrossSize then MaxCrossSize := Item.MarginBoxWidth;
      end;
    end;

    // Cross-axis size: explicit container size if present, otherwise the
    // tallest item.
    var ExpCrossSize: Single;
    if IsRow then ExpCrossSize := Box.Style.ExplicitHeight
    else ExpCrossSize := -1;  // column — already used ExplicitWidth as main
    if ExpCrossSize > 0 then CrossSize := ExpCrossSize
    else CrossSize := MaxCrossSize;

    // Phase 4: stretch items without explicit cross-size to the container's
    // cross-size — only when align-items is `stretch` (default) and the
    // container's cross-size is known.
    if (Box.Style.AlignItems = 'stretch') or (Box.Style.AlignItems = '') then
    begin
      for I := 0 to Items.Count - 1 do
      begin
        var Item := Items[I];
        if IsRow then
        begin
          if Item.Style.ExplicitHeight <= 0 then
          begin
            var TargetH := CrossSize -
              ResolveMargin(Item.Style.Margin.Top) - ResolveMargin(Item.Style.Margin.Bottom) -
              Item.Style.BorderWidths.Vert -
              Item.Style.Padding.Top - Item.Style.Padding.Bottom;
            if TargetH > Item.ContentHeight then Item.ContentHeight := TargetH;
          end;
        end;
      end;
    end;

    // Phase 5: position items along the main axis according to
    // justify-content. FreeSpace is what's left after items + gaps consume
    // their share of MainSize.
    var TotalUsed: Single := 0;
    for I := 0 to Items.Count - 1 do TotalUsed := TotalUsed + FinalSizes[I];
    TotalUsed := TotalUsed + TotalGap;
    var FreeSpace := MainSize - TotalUsed;
    if FreeSpace < 0 then FreeSpace := 0;

    var StartOffset: Single := 0;
    var ExtraSpacing: Single := 0;
    var JC := Box.Style.JustifyContent;
    if (JC = 'flex-end') or (JC = 'end') or (JC = 'right') then
      StartOffset := FreeSpace
    else if JC = 'center' then
      StartOffset := FreeSpace / 2
    else if JC = 'space-between' then
    begin
      if Items.Count > 1 then
        ExtraSpacing := FreeSpace / (Items.Count - 1);
    end
    else if JC = 'space-around' then
    begin
      if Items.Count > 0 then
      begin
        var AroundEach := FreeSpace / Items.Count;
        StartOffset := AroundEach / 2;
        ExtraSpacing := AroundEach;
      end;
    end
    else if JC = 'space-evenly' then
    begin
      if Items.Count > 0 then
      begin
        var EvenEach := FreeSpace / (Items.Count + 1);
        StartOffset := EvenEach;
        ExtraSpacing := EvenEach;
      end;
    end;

    var Cursor: Single := StartOffset;
    for I := 0 to Items.Count - 1 do
    begin
      var Idx := I;
      if IsReverse then Idx := Items.Count - 1 - I;
      var Item := Items[Idx];
      var ItemMain := FinalSizes[Idx];

      // Cross-axis position
      var CrossOffset: Single := 0;
      var ItemCrossOuter: Single;
      if IsRow then ItemCrossOuter := Item.MarginBoxHeight
      else ItemCrossOuter := Item.MarginBoxWidth;

      var AI := Box.Style.AlignItems;
      if (AI = 'flex-end') or (AI = 'end') then
        CrossOffset := CrossSize - ItemCrossOuter
      else if AI = 'center' then
        CrossOffset := (CrossSize - ItemCrossOuter) / 2;
      // 'flex-start' / 'stretch' / default → 0

      if IsRow then
      begin
        Item.X := Cursor;
        Item.Y := CrossOffset;
      end
      else
      begin
        Item.Y := Cursor;
        Item.X := CrossOffset;
      end;
      Cursor := Cursor + ItemMain + Gap + ExtraSpacing;
    end;

    if IsRow then Box.ContentHeight := CrossSize
    else Box.ContentWidth := CrossSize;
  finally
    Items.Free;
  end;
end;

procedure TLayoutEngine.LayoutAbsoluteChildren(Box: TLayoutBox);
// Position any absolute / fixed descendants of Box that haven't been laid
// out yet. The containing block (the rectangle their `top/left/right/bottom`
// resolve against) is THIS Box's content area. Real CSS uses the nearest
// positioned ancestor — for the renderer's needs we treat the immediate
// parent as the containing block, which covers the common cases (badge in
// corner of a card, tooltip pinned to button) and stays explicit.
//
// Called from LayoutBlock and LayoutFlex after the in-flow cursor has
// settled and ContentHeight is finalised, so left+right / top+bottom can
// resolve against a known containing-block size.
//
// Fast-out when no child is positioned absolute/fixed — most boxes have
// none, so the previous unconditional iteration was pure overhead per
// every container in the tree.
var
  CW, CH: Single;
  HasPositioned: Boolean;
begin
  HasPositioned := False;
  for var Child in Box.Children do
    if (Child.Style.CSSPosition = 'absolute') or
       (Child.Style.CSSPosition = 'fixed') then
    begin
      HasPositioned := True;
      Break;
    end;
  if not HasPositioned then Exit;

  CW := Box.ContentWidth;
  CH := Box.ContentHeight;
  for var Child in Box.Children do
  begin
    if (Child.Style.CSSPosition <> 'absolute') and
       (Child.Style.CSSPosition <> 'fixed') then Continue;

    // If both `left` and `right` are set the width is derived (CSS spec).
    if (Child.Style.CSSLeft > -9990) and (Child.Style.CSSRight > -9990) and
       (Child.Style.ExplicitWidth <= 0) then
    begin
      var DerivedW: Single := CW - Child.Style.CSSLeft - Child.Style.CSSRight;
      if DerivedW < 0 then DerivedW := 0;
      Child.Style.ExplicitWidth := DerivedW;
    end;

    // Likewise if both `top` and `bottom` are set the height is derived.
    // Without this, `inset:0` stretches width but the child still sits at
    // its natural content height — so a `<span style="position:absolute;
    // inset:0; background:red">` only paints red across the top portion
    // of its container, not the full box. That's the difference between
    // "absolute works" and "absolute works the way every author expects".
    if (Child.Style.CSSTop > -9990) and (Child.Style.CSSBottom > -9990) and
       (Child.Style.ExplicitHeight <= 0) then
    begin
      var DerivedH := CH - Child.Style.CSSTop - Child.Style.CSSBottom;
      if DerivedH < 0 then DerivedH := 0;
      Child.Style.ExplicitHeight := DerivedH;
    end;

    // Lay out the child at the containing-block width.
    case Child.Kind of
      lbkBlock, lbkInlineBlock: LayoutBlock(Child, CW);
      lbkTable: LayoutTable(Child, CW);
      lbkImage: LayoutImage(Child, CW);
      lbkListItem: LayoutListItem(Child, CW);
      lbkFormControl: LayoutFormControl(Child, CW);
      lbkHR: LayoutHR(Child, CW);
    else
      LayoutBlock(Child, CW);
    end;

    // Resolve X.
    if Child.Style.CSSLeft > -9990 then
      Child.X := Child.Style.CSSLeft
    else if Child.Style.CSSRight > -9990 then
      Child.X := CW - Child.MarginBoxWidth - Child.Style.CSSRight
    else
      Child.X := 0;

    // Resolve Y. left+bottom-anchored boxes count from the containing
    // block's height; if no anchor is set, sit at top of containing block.
    if Child.Style.CSSTop > -9990 then
      Child.Y := Child.Style.CSSTop
    else if Child.Style.CSSBottom > -9990 then
      Child.Y := CH - Child.MarginBoxHeight - Child.Style.CSSBottom
    else
      Child.Y := 0;

    // Recurse into descendants so a nested absolute element inside our
    // absolute child also gets resolved against its own parent.
    LayoutAbsoluteChildren(Child);
  end;
end;

procedure TLayoutEngine.LayoutListItem(Box: TLayoutBox; AvailWidth: Single);
var
  ContentW: Single;
begin
  ContentW := AvailWidth - ResolveMargin(Box.Style.Margin.Left) -
    ResolveMargin(Box.Style.Margin.Right) -
    Box.Style.BorderWidths.Horz - Box.Style.Padding.Left - Box.Style.Padding.Right;
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
    if (Child.Kind = lbkText) or (Child.Kind = lbkInline) or
       (Child.Kind = lbkInlineBlock) or (Child.Kind = lbkBR) then
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

  // Defend against a TBitmap that reports zero/negative dimensions for
  // some pathological PNG. Anything <= 0 falls back to the 100px default
  // so we don't divide by zero below or end up with an Infinity rect.
  if W <= 0 then W := 100;
  if H <= 0 then H := 100;

  // Resolve explicit dimensions (may be percentages)
  ExplW := Box.Style.ExplicitWidth;
  ExplH := Box.Style.ExplicitHeight;
  if IsPercentageValue(ExplW) then
    ExplW := ResolvePercentage(ExplW, AvailWidth);
  if IsPercentageValue(ExplH) then
    ExplH := 0; // Percentage height on images is not meaningful without container height

  // FAST PATH: both dimensions explicitly declared (the common case for
  // `<img width="80" height="80">`, `<img style="width:80px;height:80px">`,
  // and the class-CSS `.foo img { width:80; height:80 }` pattern). No
  // bitmap-natural-size math involved — the declared values are
  // authoritative regardless of what TBitmap.Width / Height happen to
  // report for the source PNG. Eliminates any chance of source-size
  // pollution in the result.
  if (ExplW > 0) and (ExplH > 0) then
  begin
    W := ExplW;
    H := ExplH;
  end
  else if ExplW > 0 then
  begin
    var Ratio := ExplW / W;
    W := ExplW;
    H := H * Ratio;
  end
  else if ExplH > 0 then
  begin
    var Ratio := ExplH / H;
    H := ExplH;
    W := W * Ratio;
  end;

  // Apply max-width / max-height / min-width / min-height. The previous
  // implementation honoured only `width` / `height` and silently ignored
  // max-* / min-*, so a `<img style="max-width:64px">` against a 1000px
  // PNG would paint at the natural 1000px. Both axes scale together so
  // the image keeps its aspect ratio.
  if (Box.Style.MaxWidth >= 0) and (W > Box.Style.MaxWidth) then
  begin
    var Ratio := Box.Style.MaxWidth / W;
    W := Box.Style.MaxWidth;
    H := H * Ratio;
  end;
  if (Box.Style.MaxHeight >= 0) and (H > Box.Style.MaxHeight) then
  begin
    var Ratio := Box.Style.MaxHeight / H;
    H := Box.Style.MaxHeight;
    W := W * Ratio;
  end;
  if (Box.Style.MinWidth >= 0) and (W < Box.Style.MinWidth) then
  begin
    var Ratio := Box.Style.MinWidth / W;
    W := Box.Style.MinWidth;
    H := H * Ratio;
  end;
  if (Box.Style.MinHeight >= 0) and (H < Box.Style.MinHeight) then
  begin
    var Ratio := Box.Style.MinHeight / H;
    H := Box.Style.MinHeight;
    W := W * Ratio;
  end;

  // Clamp to available width as a last resort (so an image declared
  // larger than its container doesn't overflow).
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

  // box-sizing: border-box means ExplW includes padding and border
  if (ExplW > 0) and SameText(Box.Style.BoxSizing, 'border-box') then
    ExplW := ExplW - Box.Style.Padding.Left - Box.Style.Padding.Right
             - Box.Style.BorderWidths.Horz;
  if ExplW < 0 then ExplW := 0;

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
    Box.ContentHeight := Max(24, Box.Style.FontSize * Box.Style.LineHeight);
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
    else if InputType = 'file' then
    begin
      // "Choose File" button + filename label
      Box.ContentWidth := Min(250, AvailWidth);
      Box.ContentHeight := Max(24, Box.Style.FontSize * Box.Style.LineHeight);
    end
    else if (InputType = 'button') or (InputType = 'submit') or (InputType = 'reset') then
    begin
      var BtnText := '';
      if Assigned(Box.Tag) then
        BtnText := Box.Tag.GetAttribute('value', '');
      if BtnText = '' then
      begin
        if InputType = 'submit' then BtnText := 'Submit'
        else if InputType = 'reset' then BtnText := 'Reset'
        else BtnText := 'Button';
      end;
      Box.ContentWidth := Max(60, MeasureTextWidth(BtnText, Box.Style) + 20);
      Box.ContentHeight := Max(24, Box.Style.FontSize * Box.Style.LineHeight);
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
  {$IFDEF IOS}
  // 2026-06-08 — Permanently suppress the FMX iOS virtual-keyboard accessory
  // toolbar (the blue "Done" bar). Switching iOS inputs to Styled (the native-
  // peer use-after-free fix) makes FMX.VirtualKeyboard.iOS attach a UIToolbar
  // + Done above the keyboard. It has no value AND its height covers the input
  // we just scrolled to the keyboard's top edge (the "input hidden behind the
  // keyboard" report). IFMXVirtualKeyboardToolbarService disables it app-wide.
  // Idempotent; safe to call on every renderer construction.
  var TbSvc: IFMXVirtualKeyboardToolbarService;
  if TPlatformServices.Current.SupportsPlatformService(
       IFMXVirtualKeyboardToolbarService, IInterface(TbSvc)) and (TbSvc <> nil) then
    TbSvc.SetToolbarEnabled(False);
  {$ENDIF}
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
  FStyleSheet.OnParseError := CssParseErrorRelay;
  FHTML.OnChange := FHTMLChange;
  FFrond := TStringList.Create;
  FFrond.OnChange := FFrondChange;
  FFrondEngine := TTina4Frond.Create('');
  FScrollX := 0;
  FScrollY := 0;
  FContentWidth := 0;
  FContentHeight := 0;
  FNeedRelayout := True;
  FParserDirty := True;
  FScrollBarWidth := 12;
  FIsLayoutting := False;
  FMouseDownOnScroll := False;
  Width := 320;
  Height := 240;
  FFormControls := TList<TNativeFormControl>.Create;
  FReusePool := TDictionary<string, TControl>.Create;
  // RerenderOnFocus default = False now that ControlType stays
  // Styled on Android. The rebuild was a workaround for the Platform
  // presenter refocus AV, which no longer exists.
  FRerenderOnFocus := False;
  FPendingRerender := False;
  FClickableRegions := TList<TClickableRegion>.Create;
  FRegisteredObjects := TDictionary<string, TObject>.Create;
  // Acquire the RTTI pool once; one ref count for the renderer's
  // entire lifetime. Every onclick dispatch uses this shared context
  // instead of creating a temporary one — see FRttiCtx declaration
  // for the bug pattern this prevents.
  FRttiCtx := TRttiContext.Create;
  FHoverChain := TList<THTMLTag>.Create;
  FActiveChain := TList<THTMLTag>.Create;
  // Per-box scroll state — keyed by DOM tag so it survives relayouts that
  // rebuild the TLayoutBox tree from scratch.
  FBoxScrollState := TDictionary<THTMLTag, TPointF>.Create;
  FDragScrollBox := nil;
  FDragScrollAxis := 0;
  FHoverScrollBox := nil;
  FPanBox := nil;
  FPanIsViewport := False;
  FPanActive := False;
  FPanVelocityX := 0;
  FPanVelocityY := 0;
  FInertiaTimer := TTimer.Create(Self);
  FInertiaTimer.Interval := 16;  // ~60 fps
  FInertiaTimer.Enabled := False;
  FInertiaTimer.OnTimer := InertiaTimerTick;
  // Resize-relayout coalescing — see FResizeTimer declaration.
  FResizeTimer := TTimer.Create(Self);
  FResizeTimer.Interval := 90;
  FResizeTimer.Enabled := False;
  FResizeTimer.OnTimer := ResizeSettleTick;
  FInertiaBox := nil;
  FScrollBarsVisible := True;
  FScrollBarOverlay := False;
  FDebugOverlay := False;
  FDebugBoxOverlay := False;
  FScrollbarLastActivity := 0;
  FScrollbarFadeTimer := TTimer.Create(Self);
  FScrollbarFadeTimer.Interval := 33;  // ~30 fps while fading
  FScrollbarFadeTimer.Enabled := False;
  FScrollbarFadeTimer.OnTimer := ScrollbarFadeTimerTick;
  ClipChildren := True;
  HitTest := True;
  // Keep receiving mouse/touch events while a drag is in progress even when
  // the cursor leaves the control's bounds. Without this, the scrollbar drag
  // state gets "stuck" because MouseUp never fires when released outside.
  AutoCapture := True;
  // On mobile (Android/iOS), FMX routes touch events through its gesture
  // system. We handle pan via CMGesture override — no need to set
  // InteractiveGestures here as it can trigger unwanted keyboard overlays.

  // Subscribe to virtual-keyboard state changes so we can scroll the
  // focused input above the keyboard. Returns a subscription id that
  // we unsubscribe from in the destructor.
  FKeyboardVisible := False;
  FKeyboardBounds := TRect.Empty;
  FVKSubscriptionId := TMessageManager.DefaultManager.SubscribeToMessage(
    TVKStateChangeMessage, VKStateChangeHandler);
end;

procedure TTina4HTMLRender.BumpScrollbarVisibility;
begin
  FScrollbarLastActivity := TThread.GetTickCount;
  if Assigned(FScrollbarFadeTimer) and (not FScrollbarFadeTimer.Enabled) then
    FScrollbarFadeTimer.Enabled := True;
end;

function TTina4HTMLRender.GetScrollbarOpacity: Single;
const
  VISIBLE_MS = 900;   // fully visible for this long after any activity
  FADE_MS    = 500;   // fade out over this long
var
  Elapsed: Cardinal;
begin
  if FScrollbarLastActivity = 0 then
    Exit(0.0);  // never been active -> hidden
  Elapsed := TThread.GetTickCount - FScrollbarLastActivity;
  if Elapsed < VISIBLE_MS then
    Result := 1.0
  else if Elapsed < VISIBLE_MS + FADE_MS then
    Result := 1.0 - ((Elapsed - VISIBLE_MS) / FADE_MS)
  else
    Result := 0.0;
  if Result < 0 then Result := 0;
  if Result > 1 then Result := 1;
end;

procedure TTina4HTMLRender.ScrollbarFadeTimerTick(Sender: TObject);
begin
  if GetScrollbarOpacity <= 0 then
  begin
    FScrollbarFadeTimer.Enabled := False;
    Repaint;
    Exit;
  end;
  Repaint;
end;

procedure TTina4HTMLRender.InertiaTimerTick(Sender: TObject);
const
  FRICTION = 0.92;      // velocity multiplier per tick (~60fps)
  MIN_VELOCITY = 0.5;   // stop when velocity drops below this
begin
  FInertiaVX := FInertiaVX * FRICTION;
  FInertiaVY := FInertiaVY * FRICTION;

  if (Abs(FInertiaVX) < MIN_VELOCITY) and (Abs(FInertiaVY) < MIN_VELOCITY) then
  begin
    FInertiaTimer.Enabled := False;
    FInertiaBox := nil;
    Exit;
  end;

  if Assigned(FInertiaBox) then
  begin
    // Inner box inertia
    if FInertiaBox.IsScrollableX and (FInertiaBox.ScrollWidth > FInertiaBox.ContentWidth + 0.5) then
      FInertiaBox.ScrollX := FInertiaBox.ScrollX + FInertiaVX;
    if FInertiaBox.IsScrollableY and (FInertiaBox.ScrollHeight > FInertiaBox.ContentHeight + 0.5) then
      FInertiaBox.ScrollY := FInertiaBox.ScrollY + FInertiaVY;
    FInertiaBox.ClampOwnScroll;
    BumpScrollbarVisibility;
    Repaint;
  end
  else
  begin
    // Viewport inertia
    if Abs(FInertiaVY) >= MIN_VELOCITY then
      SetScrollY(FScrollY + FInertiaVY);
    if Abs(FInertiaVX) >= MIN_VELOCITY then
      SetScrollX(FScrollX + FInertiaVX);
  end;
end;

procedure TTina4HTMLRender.SetScrollBarOverlay(const Value: Boolean);
begin
  if FScrollBarOverlay = Value then Exit;
  FScrollBarOverlay := Value;
  if Value then
    FScrollBarWidth := 4   // thin overlay indicator
  else
    FScrollBarWidth := 12; // classic desktop scrollbar
  FNeedRelayout := True;
  Repaint;
end;

destructor TTina4HTMLRender.Destroy;
begin
  // Unsubscribe from the VK message bus before anything else — if a
  // keyboard event fires between here and inherited Destroy we must
  // not touch half-freed state.
  if FVKSubscriptionId <> 0 then
    TMessageManager.DefaultManager.Unsubscribe(
      TVKStateChangeMessage, FVKSubscriptionId);
  if Assigned(FScrollbarFadeTimer) then
    FScrollbarFadeTimer.Enabled := False;
  if Assigned(FResizeTimer) then
    FResizeTimer.Enabled := False;
  ClearFormControls;
  DrainPendingDispose;  // free any control still queued for keyboard-down
  FFormControls.Free;
  FReusePool.Free;
  FClickableRegions.Free;
  FRegisteredObjects.Free;
  // Release the RTTI pool ref count. Symmetric with the Create in
  // the constructor; no Frees of TRttiType/Method ever happen here.
  FRttiCtx.Free;
  FHoverChain.Free;
  FPaintLayout.Free;
  FActiveChain.Free;
  FBoxScrollState.Free;
  FStyleSheet.Free;
  FLayoutEngine.Free;
  FParser.Free;
  FImageCache.Free;
  FFileCache.Free;
  FHTML.Free;
  FDebug.Free;
  FFrondEngine.Free;
  FFrond.Free;
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

function TTina4HTMLRender.GetFrond: TStringList;
begin
  Result := FFrond;
end;

procedure TTina4HTMLRender.SetFrond(const Value: TStringList);
begin
  FFrond.Assign(Value);
  // OnChange handler fires automatically via Assign
end;

procedure TTina4HTMLRender.SetFrondTemplatePath(const Value: string);
begin
  if FFrondTemplatePath <> Value then
  begin
    FFrondTemplatePath := Value;
    FFrondEngine.Free;
    FFrondEngine := TTina4Frond.Create(Value);
  end;
end;

procedure TTina4HTMLRender.RenderFrond;
var
  RenderedHTML: string;
begin
  if FFrond.Text.Trim = '' then Exit;
  // Render Frond template to HTML
  RenderedHTML := TTina4Frond(FFrondEngine).Render(FFrond.Text);
  // Set HTML without triggering FHTMLChange (which would recurse into Frond).
  // We must still mark the parser dirty manually since we're bypassing the
  // normal change-notification path.
  FHTML.OnChange := nil;
  try
    FHTML.Text := RenderedHTML;
  finally
    FHTML.OnChange := FHTMLChange;
  end;
  // Trigger reparse + relayout and repaint
  FParserDirty := True;
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.FFrondChange(Sender: TObject);
begin
  RenderFrond;
end;

procedure TTina4HTMLRender.CssParseErrorRelay(Sender: TObject;
  const Selector, Reason: string);
begin
  if Assigned(FOnCssParseError) then
    FOnCssParseError(Self, Selector, Reason);
end;

procedure TTina4HTMLRender.SetFrondVariable(const AName: string; const AValue: string);
begin
  TTina4Frond(FFrondEngine).SetVariable(AName, AValue);
  // Re-render the Frond template so the new variable value takes effect
  RenderFrond;
end;

procedure TTina4HTMLRender.SetTwigVariable(const AName: string; const AValue: string);
begin
  // Compat alias — delegates to SetFrondVariable
  SetFrondVariable(AName, AValue);
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
    FFileCache.CacheDir := TPath.GetTempPath + 'Tina4Cache';
end;

procedure TTina4HTMLRender.ClearCache;
begin
  FFileCache.ClearCache;
end;

procedure TTina4HTMLRender.RegisterObject(const Name: string; Obj: TObject);
begin
  FRegisteredObjects.AddOrSetValue(Name.ToLower, Obj);
end;

procedure TTina4HTMLRender.UnregisterObject(const Name: string);
begin
  FRegisteredObjects.Remove(Name.ToLower);
end;

procedure TTina4HTMLRender.InvalidateAllCaches;
begin
  // Drop any cached parsed DOM / stylesheet so the next paint rebuilds
  // from scratch. Useful when a CSS class rule with an interpolated
  // value (e.g. brand colour) is supposed to change between renders
  // but somehow stayed at the previous render's value — defensively
  // calling this guarantees a full re-cascade.
  FStyleSheet.Clear;
  if Assigned(FFileCache) then
    FFileCache.ClearCache;
  FParserDirty := True;
  FNeedRelayout := True;
  // Clear any tracked pseudo-class state too — the new DOM will have
  // fresh THTMLTag pointers, so the old ones in the chains are stale.
  FHoverChain.Clear;
  FActiveChain.Clear;
  Repaint;
end;

function TTina4HTMLRender.GetElementById(const Id: string): THTMLTag;

  function FindById(Tag: THTMLTag; const AId: string): THTMLTag;
  begin
    Result := nil;
    if not Assigned(Tag) then Exit;
    if SameText(Tag.GetAttribute('id', ''), AId) then
      Exit(Tag);
    for var C in Tag.Children do
    begin
      Result := FindById(C, AId);
      if Result <> nil then Exit;
    end;
  end;

begin
  Result := nil;
  // Ensure the DOM reflects the current HTML.Text. Parsing is normally
  // deferred to DoLayout at paint time, which means a consumer that
  // queries GetElementById before the first paint (or in a headless
  // test) would see a stale / empty tree. Parse on demand when dirty —
  // cheap (HTML to DOM only; stylesheet loading still happens in
  // DoLayout).
  if FParserDirty and Assigned(FParser) then
  begin
    FParser.Parse(FHTML.Text);
    FParserDirty := False;
  end;
  if Assigned(FParser) and Assigned(FParser.Root) then
    Result := FindById(FParser.Root, Id);
end;

function TTina4HTMLRender.GetElementValue(const Id: string): string;
begin
  Result := '';
  // First check native form controls for live value
  for var Rec in FFormControls do
  begin
    if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) and
       SameText(Rec.Box.Tag.GetAttribute('id', ''), Id) then
    begin
      var N: string;
      GetFormControlNameValue(Rec.Control, N, Result);
      Exit;
    end;
  end;
  // Fall back to DOM attribute
  var Tag := GetElementById(Id);
  if Assigned(Tag) then
    Result := Tag.GetAttribute('value', '');
end;

procedure TTina4HTMLRender.SetElementValue(const Id: string; const Value: string);
var
  BoxId: string;
  Matched: Boolean;
begin
  // Update native form control if it exists. Each deref is guarded: with
  // several live renderers a control (or its layout box, which is NOT a
  // TComponent so FreeNotification cannot purge it) can be freed out from under
  // a stale FFormControls entry, and reading it back as a live TEdit AVs
  // (the multi-renderer use-after-free that surfaces as the on-screen
  // "Access violation ... OK" dialog when it lands in an FMX callback).
  for var Rec in FFormControls do
  begin
    if Rec.Control = nil then Continue;
    BoxId := '';
    try
      if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) then
        BoxId := Rec.Box.Tag.GetAttribute('id', '');
    except
      TraceLog('SetElementValue: STALE BOX skipped');
      Continue;
    end;
    if not SameText(BoxId, Id) then Continue;

    Matched := False;
    try
      // Only assign when the value actually differs — assigning .Text fires
      // the control's OnChange (and on Android can disturb a live IME bind),
      // so re-setting an already-correct value (e.g. clearing an
      // already-empty input on every screen show) must be a true no-op.
      if Rec.Control is TEdit then
      begin
        if TEdit(Rec.Control).Text <> Value then
          TEdit(Rec.Control).Text := Value;
      end
      else if Rec.Control is TMemo then
      begin
        if TMemo(Rec.Control).Lines.Text <> Value then
          TMemo(Rec.Control).Lines.Text := Value;
      end
      else if Rec.Control is TCheckBox then
        TCheckBox(Rec.Control).IsChecked := SameText(Value, 'true') or (Value = '1')
      else if Rec.Control is TRadioButton then
        TRadioButton(Rec.Control).IsChecked := SameText(Value, 'true') or (Value = '1');
      Matched := True;
    except
      TraceLog('SetElementValue: STALE CONTROL skipped');
    end;
    try
      if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) and
         Assigned(Rec.Box.Tag.Attributes) then
        Rec.Box.Tag.Attributes.AddOrSetValue('value', Value);
    except
    end;
    if Matched then Exit;
  end;
  // Update DOM attribute directly
  var Tag := GetElementById(Id);
  if Assigned(Tag) and Assigned(Tag.Attributes) then
    Tag.Attributes.AddOrSetValue('value', Value);
end;

procedure TTina4HTMLRender.SetElementAttribute(const Id, AttrName, AttrValue: string);
begin
  var Tag := GetElementById(Id);
  if Assigned(Tag) and Assigned(Tag.Attributes) then
  begin
    Tag.Attributes.AddOrSetValue(AttrName, AttrValue);
    // If changing class or style, trigger relayout
    if SameText(AttrName, 'class') or SameText(AttrName, 'style') then
    begin
      FNeedRelayout := True;
      Repaint;
    end;
  end;
end;

{ ─── Class-list helpers ───────────────────────────────────────────
  SetElementAttribute('class', ...) replaces the whole class list,
  which destroys any pre-existing classes (striped, even, etc.). The
  helpers below mutate the list token-by-token using HTML's standard
  whitespace-delimited semantics. Class names are case-sensitive to
  match browser behaviour. }

type
  TClassListOp = (cloAdd, cloRemove, cloToggle);

function SplitClassList(const S: string): TArray<string>;
var
  L: TList<string>;
  Token: string;
  I: Integer;
  InToken: Boolean;
begin
  // Whitespace-separated tokens per HTML/DOM spec. Empty runs and
  // trailing whitespace collapse.
  L := TList<string>.Create;
  try
    Token := '';
    InToken := False;
    for I := 1 to Length(S) do
    begin
      if CharInSet(S[I], [' ', #9, #10, #13]) then
      begin
        if InToken then
        begin
          L.Add(Token);
          Token := '';
          InToken := False;
        end;
      end
      else
      begin
        Token := Token + S[I];
        InToken := True;
      end;
    end;
    if InToken then L.Add(Token);
    Result := L.ToArray;
  finally
    L.Free;
  end;
end;

function JoinClassList(const Tokens: TArray<string>): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to High(Tokens) do
  begin
    if I > 0 then Result := Result + ' ';
    Result := Result + Tokens[I];
  end;
end;

// Returns the index of ClassName in Tokens, or -1 if absent.
// Case-sensitive — matches how browsers match CSS selectors.
function IndexOfClass(const Tokens: TArray<string>;
  const ClassName: string): Integer;
var
  I: Integer;
begin
  for I := 0 to High(Tokens) do
    if Tokens[I] = ClassName then Exit(I);
  Result := -1;
end;

// Performs Op on Tag's class attribute. Returns True if the class
// is PRESENT afterwards (useful for Toggle, informational for the
// others). Tag.Attributes must not be nil.
function MutateTagClass(Tag: THTMLTag; const ClassName: string;
  Op: TClassListOp): Boolean;
var
  Tokens: TArray<string>;
  Idx: Integer;
  Changed: Boolean;
begin
  Tokens := SplitClassList(Tag.GetAttribute('class', ''));
  Idx := IndexOfClass(Tokens, ClassName);
  Changed := False;

  case Op of
    cloAdd:
      if Idx < 0 then
      begin
        SetLength(Tokens, Length(Tokens) + 1);
        Tokens[High(Tokens)] := ClassName;
        Changed := True;
      end;
    cloRemove:
      if Idx >= 0 then
      begin
        // Shift tail down over the removed slot.
        for var I := Idx to Length(Tokens) - 2 do
          Tokens[I] := Tokens[I + 1];
        SetLength(Tokens, Length(Tokens) - 1);
        Changed := True;
      end;
    cloToggle:
      begin
        if Idx < 0 then
        begin
          SetLength(Tokens, Length(Tokens) + 1);
          Tokens[High(Tokens)] := ClassName;
        end
        else
        begin
          for var I := Idx to Length(Tokens) - 2 do
            Tokens[I] := Tokens[I + 1];
          SetLength(Tokens, Length(Tokens) - 1);
        end;
        Changed := True;
      end;
  end;

  if Changed then
    Tag.Attributes.AddOrSetValue('class', JoinClassList(Tokens));
  Result := IndexOfClass(Tokens, ClassName) >= 0;
end;

function TTina4HTMLRender.HasElementClass(const Id, ClassName: string): Boolean;
var
  Tag: THTMLTag;
begin
  Result := False;
  Tag := GetElementById(Id);
  if (Tag = nil) or (Tag.Attributes = nil) then Exit;
  Result := IndexOfClass(
    SplitClassList(Tag.GetAttribute('class', '')), ClassName) >= 0;
end;

procedure TTina4HTMLRender.AddElementClass(const Id, ClassName: string);
var
  Tag: THTMLTag;
begin
  if ClassName = '' then Exit;
  Tag := GetElementById(Id);
  if (Tag = nil) or (Tag.Attributes = nil) then Exit;
  MutateTagClass(Tag, ClassName, cloAdd);
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.RemoveElementClass(const Id, ClassName: string);
var
  Tag: THTMLTag;
begin
  if ClassName = '' then Exit;
  Tag := GetElementById(Id);
  if (Tag = nil) or (Tag.Attributes = nil) then Exit;
  MutateTagClass(Tag, ClassName, cloRemove);
  FNeedRelayout := True;
  Repaint;
end;

function TTina4HTMLRender.ToggleElementClass(const Id, ClassName: string): Boolean;
var
  Tag: THTMLTag;
begin
  Result := False;
  if ClassName = '' then Exit;
  Tag := GetElementById(Id);
  if (Tag = nil) or (Tag.Attributes = nil) then Exit;
  Result := MutateTagClass(Tag, ClassName, cloToggle);
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.SetExclusiveClass(
  const Id, ClassName, TagName: string);

  // Walk the DOM, stripping ClassName from every tag whose name
  // matches TagName. Case-insensitive on TagName, case-sensitive on
  // ClassName (HTML tag names are case-insensitive; class names aren't).
  procedure StripFromMatching(Tag: THTMLTag);
  begin
    if Tag = nil then Exit;
    if SameText(Tag.TagName, TagName) and (Tag.Attributes <> nil) then
      MutateTagClass(Tag, ClassName, cloRemove);
    for var C in Tag.Children do
      StripFromMatching(C);
  end;

var
  Target: THTMLTag;
begin
  if (ClassName = '') or (TagName = '') then Exit;

  // Force the lazy parse BEFORE we walk FParser.Root. GetElementById
  // is what normally flushes FParserDirty — calling it first ensures
  // StripFromMatching sees the up-to-date tree. Otherwise we'd mutate
  // a stale DOM and the next parse would discard those mutations.
  Target := GetElementById(Id);  // also primes the parse
  if not Assigned(FParser) or not Assigned(FParser.Root) then Exit;

  // One pass to clear the class everywhere matching TagName...
  StripFromMatching(FParser.Root);

  // ...then set it on the chosen element. If Id wasn't found we still
  // de-selected everyone else — that's correct "select nothing"
  // behaviour for a click-elsewhere.
  if (Target <> nil) and (Target.Attributes <> nil) then
    MutateTagClass(Target, ClassName, cloAdd);

  // Single relayout for the whole batch of mutations.
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.SetElementEnabled(const Id: string; Enabled: Boolean);
begin
  // Update native control
  for var Rec in FFormControls do
  begin
    if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) and
       SameText(Rec.Box.Tag.GetAttribute('id', ''), Id) then
    begin
      Rec.Control.Enabled := Enabled;
      Rec.Control.Opacity := IfThen(Enabled, 1.0, 0.5);
      Exit;
    end;
  end;
  // For non-form elements, set a disabled attribute and repaint
  var Tag := GetElementById(Id);
  if Assigned(Tag) and Assigned(Tag.Attributes) then
  begin
    if Enabled then
      Tag.Attributes.Remove('disabled')
    else
      Tag.Attributes.AddOrSetValue('disabled', 'disabled');
  end;
end;

procedure TTina4HTMLRender.SetElementVisible(const Id: string; Visible: Boolean);

  // True if the tag's inline display already reflects the requested
  // visibility. A no-op SetElementVisible (the common case on a repeat
  // screen show — e.g. re-hiding an already-hidden error banner or
  // re-toggling an unchanged pinned/pinless wrap) must NOT tear down and
  // rebuild every native TEdit and re-fire autofocus. So skip ALL work
  // (no FNeedRelayout, no Repaint) when nothing actually changes.
  function AlreadyAt(Tag: THTMLTag; AVisible: Boolean): Boolean;
  var Disp: string;
  begin
    if not Assigned(Tag) or not Assigned(Tag.Style) then Exit(False);
    if not Tag.Style.TryGetValue('display', Disp) then Disp := '';
    if AVisible then Result := not SameText(Disp, 'none')
    else Result := SameText(Disp, 'none');
  end;

begin
  // Update native control visibility. EVERY use of Rec.Box.Tag / the DOM tag
  // is wrapped: a relayout or a lazy reparse can free the TLayoutBox (not a
  // TComponent, so FreeNotification can't purge it) or the THTMLTag tree while
  // this list / GetElementById still reference them — dereffing the dangling
  // tag (GetAttribute / .Style / AlreadyAt) is a use-after-free SIGSEGV.
  // Skip stale rows instead of faulting.
  for var Rec in FFormControls do
  begin
    try
      if not Assigned(Rec.Box) then Continue;
      var BoxTag := Rec.Box.Tag;
      if not (Assigned(BoxTag) and SameText(BoxTag.GetAttribute('id', ''), Id)) then
        Continue;
      // Matched this element.
      if (Rec.Control <> nil) and (Rec.Control.Visible = Visible) and
         AlreadyAt(BoxTag, Visible) then
        Exit;  // already in the requested state — do nothing
      if Rec.Control <> nil then
        Rec.Control.Visible := Visible;
      if Assigned(BoxTag.Style) then
      begin
        if Visible then BoxTag.Style.Remove('display')
        else BoxTag.Style.AddOrSetValue('display', 'none');
      end;
      FNeedRelayout := True;
      Repaint;
      Exit;
    except
      TraceLog('SetElementVisible: stale row skipped'); Continue;
    end;
  end;
  // For non-form elements (divs like the error banner / wrap rows) — same
  // guard around the GetElementById DOM-tree walk + the Tag.Style deref.
  try
    var Tag := GetElementById(Id);
    if Assigned(Tag) and Assigned(Tag.Style) then
    begin
      if AlreadyAt(Tag, Visible) then Exit;  // unchanged — do nothing
      if Visible then Tag.Style.Remove('display')
      else Tag.Style.AddOrSetValue('display', 'none');
      FNeedRelayout := True;
      Repaint;
    end;
  except
    TraceLog('SetElementVisible: non-form stale skipped');
  end;
end;

procedure TTina4HTMLRender.SetElementText(const Id: string; const Text: string);
var
  AnyFocused: Boolean;
begin
  var Tag := GetElementById(Id);
  if not Assigned(Tag) then Exit;

  // No-op guard: if the element's text is already exactly this, do nothing.
  // Covers BOTH cases: an existing #text node that already matches, AND no
  // #text node yet with an empty target (e.g. clearing an already-empty error
  // banner on every screen show — gaErrorBanner has no #text child, so the
  // naive "find #text" check would miss it and still relayout). A relayout
  // here rebuilds every native TEdit and re-fires autofocus — the
  // double-keyboard bug.
  var ExistingText: THTMLTag := nil;
  for var C0 in Tag.Children do
    if C0.TagName = '#text' then begin ExistingText := C0; Break; end;
  if (Assigned(ExistingText) and (ExistingText.Text = Text)) or
     ((ExistingText = nil) and (Text = '')) then Exit;

  // CRITICAL (2026-06-06): detect whether any native form control in
  // this renderer currently holds focus (IME bound on Android). If so,
  // a full relayout — which runs ClearFormControls and disposes EVERY
  // TEdit, then recreates them — would destroy the focused control out
  // from under the IME's active InputConnection. The IME's next
  // getTextAfterCursor() then hangs (logcat: "InputConnection didn't
  // respond in 2000 msec"), the main thread deadlocks, and the process
  // dies with no crash trace. This was the Transfer-screen crash: the
  // live closing-balance preview called SetElementText on every
  // keystroke, each one rebuilding the form controls while the amount
  // TEdit was IME-bound. When a control is focused we therefore do an
  // IN-PLACE text update (DOM text + laid-out fragment) and SKIP the
  // relayout entirely.
  AnyFocused := False;
  {$IF defined(ANDROID) or defined(IOS)}
  for var Rec in FFormControls do
    if (Rec.Control <> nil) and Rec.Control.IsFocused then
    begin AnyFocused := True; Break; end;
  {$ENDIF}

  // Update the DOM #text child (create if missing).
  var TextNode: THTMLTag := nil;
  for var C in Tag.Children do
    if C.TagName = '#text' then begin TextNode := C; Break; end;
  if TextNode = nil then
  begin
    TextNode := THTMLTag.Create;
    TextNode.TagName := '#text';
    TextNode.Parent := Tag;
    Tag.Children.Add(TextNode);
  end;
  TextNode.Text := Text;

  // Update a styled-button label if applicable (TRectangle + TLabel).
  // Guarded Rec.Box.Tag read: a freed TLayoutBox (use-after-free during a
  // re-entrant relayout) must not fault here.
  for var Rec in FFormControls do
  begin
    var BoxTag2: THTMLTag := nil;
    try
      if Assigned(Rec.Box) then BoxTag2 := Rec.Box.Tag;
    except
      Continue;
    end;
    if Assigned(BoxTag2) and (BoxTag2 = Tag) then
    begin
      if Rec.Control is TRectangle then
        for var I := 0 to TRectangle(Rec.Control).ChildrenCount - 1 do
          if TRectangle(Rec.Control).Children[I] is TLabel then
          begin
            TLabel(TRectangle(Rec.Control).Children[I]).Text := Text;
            Break;
          end;
      Break;
    end;
  end;

  if AnyFocused then
  begin
    // In-place update — no relayout, so the focused TEdit and its IME
    // binding survive. Guarded: if the in-place update fails for any
    // reason, fall back to a plain repaint (text reflows on the next
    // natural relayout, e.g. when the field blurs) rather than risk
    // the destructive rebuild.
    try
      if Assigned(FLayoutEngine) and Assigned(FLayoutEngine.Root) then
      begin
        var BoxForTag := FindLayoutBoxByTag(FLayoutEngine.Root, Tag);
        if Assigned(BoxForTag) then
          UpdateBoxTextInPlace(BoxForTag, Text);
      end;
    except
    end;
    Repaint;
    Exit;
  end;

  // No control focused — safe to do the normal full relayout.
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.UpdateBoxTextInPlace(Box: TLayoutBox;
  const NewText: string);

  // AvailW is the width available to B's fragment, measured from B's own X to
  // the right edge of its formatting context. We re-apply text-align WITHIN
  // that width so a right-aligned / centred value stays put as its width
  // changes — without a full relayout (which we can't do here: the amount
  // input is focused). The layout engine right-aligns the same way (shift =
  // AvailWidth - lineRight); computing it from the box geometry directly is
  // robust, where preserving the old fragment's edge drifted.
  procedure ReplaceFragments(B: TLayoutBox; const Txt: string; AvailW: Single);
  begin
    if not Assigned(B) or not Assigned(B.Fragments) then Exit;
    B.Fragments.Clear;
    var Frag: TTextFragment;
    Frag.Text := Txt;
    Frag.Y := 0;
    Frag.W := FLayoutEngine.MeasureTextWidth(Txt, B.Style);
    Frag.H := FLayoutEngine.GetLineHeight(B.Style);
    Frag.X := 0;
    if (AvailW > 0) and (Frag.W < AvailW) then
      case B.Style.TextAlign of
        TTextAlign.Trailing: Frag.X := AvailW - Frag.W;
        TTextAlign.Center:   Frag.X := (AvailW - Frag.W) / 2;
      end;
    if Frag.X < 0 then Frag.X := 0;
    B.Fragments.Add(Frag);
  end;

begin
  if not Assigned(Box) then Exit;
  // The visible text of an element lives in its #text child box's fragments.
  // The child's fragment X is relative to the child's own X, so the width
  // available for right/centre alignment is the parent's content width minus
  // where the child starts.
  for var Child in Box.Children do
    if (Child.Tag <> nil) and (Child.Tag.TagName = '#text') then
    begin
      Child.Tag.Text := NewText;
      ReplaceFragments(Child, NewText, Box.ContentWidth - Child.X);
      Exit;
    end;
  // No #text child — the box carries its own fragments directly.
  ReplaceFragments(Box, NewText, Box.ContentWidth);
end;

procedure TTina4HTMLRender.SetElementStyle(const Id, StyleProp, StyleValue: string);
begin
  // Guard the DOM-tree deref: a relayout / lazy reparse can free the THTMLTag
  // tree while GetElementById still references it — a use-after-free SIGSEGV.
  try
    var Tag := GetElementById(Id);
    if Assigned(Tag) and Assigned(Tag.Style) then
    begin
      // No-op guard: if the inline style already holds this exact value, do
      // nothing — no relayout, no rebuild of native peers, no autofocus
      // re-fire. (A repeat screen show that re-sets an unchanged
      // display/colour must be free.)
      var CurVal: string;
      if not Tag.Style.TryGetValue(StyleProp, CurVal) then CurVal := '';
      if CurVal = StyleValue then Exit;
      Tag.Style.AddOrSetValue(StyleProp, StyleValue);
      FNeedRelayout := True;
      Repaint;
    end;
  except
    TraceLog('SetElementStyle: stale DOM skipped');
  end;
end;

procedure TTina4HTMLRender.RefreshElement(const Id: string);
begin
  // Force a full re-layout and repaint
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.FHTMLChange(Sender: TObject);
begin
  FParserDirty := True;
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.OnImageLoaded(Sender: TObject);
begin
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.DoLayout;

  // Save all current per-box scroll positions into FBoxScrollState before
  // we throw away the old layout tree. Keyed by the DOM tag, which is
  // persistent across relayouts (only the layout boxes get rebuilt).
  procedure SaveScrollState(Box: TLayoutBox);
  begin
    if not Assigned(Box) then Exit;
    if Assigned(Box.Tag) and (Box.IsScrollableX or Box.IsScrollableY) and
       ((Box.ScrollX <> 0) or (Box.ScrollY <> 0)) then
      FBoxScrollState.AddOrSetValue(Box.Tag, PointF(Box.ScrollX, Box.ScrollY));
    for var Child in Box.Children do
      SaveScrollState(Child);
  end;

  // After layout, copy scroll positions back into the rebuilt boxes.
  // Clamp immediately so positions beyond the new content size are trimmed.
  procedure RestoreScrollState(Box: TLayoutBox);
  var
    P: TPointF;
  begin
    if not Assigned(Box) then Exit;
    if Assigned(Box.Tag) and (Box.IsScrollableX or Box.IsScrollableY) then
      if FBoxScrollState.TryGetValue(Box.Tag, P) then
      begin
        Box.ScrollX := P.X;
        Box.ScrollY := P.Y;
        Box.ClampOwnScroll;
      end;
    for var Child in Box.Children do
      RestoreScrollState(Child);
  end;

  // Re-parse + lay out ARBITRARY markup with a FRESH parser, swallowing any
  // fault and reporting success. The recovery ladder below uses it to render
  // the current screen, then the last-good screen, before ever falling back to
  // an empty layout. A fresh parser each call also discards the corrupted
  // parser internals that otherwise escalate the next render into a hard exit.
  function RecoverRender(const AHtml: string; AWidth: Single): Boolean;
  begin
    Result := False;
    try
      try FreeAndNil(FParser); FParser := THTMLParser.Create; except end;
      FParser.Parse(AHtml);
      FStyleSheet.Clear;
      for var I := 0 to FParser.StyleBlocks.Count - 1 do
        FStyleSheet.AddCSS(FParser.StyleBlocks[I]);
      for var I := 0 to FParser.LinkHrefs.Count - 1 do
        FStyleSheet.LoadFromURL(FParser.LinkHrefs[I]);
      FParserDirty := False;
      FLayoutEngine.Layout(FParser.Root, AWidth, FStyleSheet);
      Result := True;
    except
      Result := False;
    end;
  end;

begin
  if FIsLayoutting then Exit;
  FIsLayoutting := True;
  // Snapshot inner scroll state before the layout tree is rebuilt, then
  // invalidate cached TLayoutBox pointers — the relayout replaces them.
  if Assigned(FLayoutEngine) and Assigned(FLayoutEngine.Root) then
    SaveScrollState(FLayoutEngine.Root);
  FDragScrollBox := nil;
  FDragScrollAxis := 0;
  FHoverScrollBox := nil;
  FPanBox := nil;
  FPanIsViewport := False;
  FPanActive := False;
  try
    // ── Capture reuse target + invalidate stale box pointers FIRST ──────────
    // This MUST be the very first thing in DoLayout, because BOTH operations
    // below destroy the structures these records point at:
    //   • FParser.Parse (reparse, when FParserDirty) frees the old DOM THTMLTag
    //     tree — so RRec.Box.Tag would dangle.
    //   • FLayoutEngine.Layout does `FRoot.Free` — so RRec.Box itself dangles.
    // The reuse loop reads RRec.Box.Tag to recover the focused control's stable
    // DOM id, so it can only run while BOTH the boxes and the DOM are still
    // alive — i.e. right here, before either is touched. Running it later (after
    // the reparse or after Layout) dereferences freed-and-recycled memory and
    // returns garbage string pointers → the SIGSEGV crash family (faults at
    // 006C0072 / 4C542821 etc.) that killed the app on focus/re-render.
    //
    // REUSE rationale: disposing a TEdit the Android IME has an active
    // InputConnection to corrupts the IME for the next screen (the transfer ->
    // Global Airtime crash). Capturing the focused/IME-bound control here,
    // having ClearFormControls leave it alone, and CreateFormControls re-adopt
    // it (matched by stable DOM id) keeps the IME bound to ONE live control
    // across the whole relayout.
    FReuseCtl := nil;
    FReuseId := '';
    {$IF defined(ANDROID) or defined(IOS)}
    for var RRec in FFormControls do
      if (RRec.Control <> nil) and RRec.Control.IsFocused and
         Assigned(RRec.Box) and Assigned(RRec.Box.Tag) then
      begin
        var Rid := RRec.Box.Tag.GetAttribute('id', '');
        if Rid <> '' then
        begin
          FReuseCtl := RRec.Control;
          FReuseId := Rid;
        end;
        Break;
      end;
    // CRITICAL (2026-06-06, Sunmi V2s mid-bind dispose crash): if nothing is
    // focused right now but the IME is still bound to a control we own
    // (FImeBoundCtl — set on the focus tap, held until keyboard-down), reuse
    // THAT control too. The keyboard slide-up briefly drops focus from the
    // just-tapped input (OnExit) a few ms before a relayout storm; without
    // this, ClearFormControls would detach (Parent:=nil) and free a control
    // the Android IME's InputConnection is still bound to -> silent process
    // death with no tombstone.
    if (FReuseCtl = nil) and Assigned(FImeBoundCtl) then
      for var RRec in FFormControls do
        if (RRec.Control = FImeBoundCtl) and
           Assigned(RRec.Box) and Assigned(RRec.Box.Tag) then
        begin
          var Rid := RRec.Box.Tag.GetAttribute('id', '');
          if Rid <> '' then
          begin
            FReuseCtl := RRec.Control;
            FReuseId := Rid;
            TraceLog('DoLayout: reusing IME-bound (blurred) ctl id=' + Rid);
          end;
          Break;
        end;
    TraceLog(Format('DoLayout pre-clear: reuse=%p reuseId=%s imebound=%p fcount=%d',
      [Pointer(FReuseCtl), FReuseId, Pointer(FImeBoundCtl), FFormControls.Count]));
    {$ENDIF}

    // ── Snapshot the reuse pool: id -> existing TEdit/TMemo (NOT FReuseCtl) ──
    // CreateFormControls re-adopts these by id instead of dispose+recreate, so
    // no native control (or its IME binding) churns across this relayout — the
    // MT6761 compositor-stall fix. Captured here while the boxes/tags are alive;
    // ClearFormControls keeps pooled controls parented; any pooled control whose
    // id is gone from the new DOM is deferred-disposed after CreateFormControls.
    {$IF defined(ANDROID) or defined(IOS)}
    FReusePool.Clear;
    for var QRec in FFormControls do
      if Assigned(QRec.Control) and (QRec.Control <> FReuseCtl) and
         Assigned(QRec.Box) and Assigned(QRec.Box.Tag) and
         ((QRec.Control is TEdit) or (QRec.Control is TMemo)) then
      begin
        var Qid := QRec.Box.Tag.GetAttribute('id', '');
        if Qid <> '' then FReusePool.AddOrSetValue(Qid, QRec.Control);
      end;
    {$ENDIF}

    // ── Preserve user-typed input values across this relayout ───────────────
    // A DOM-mutation relayout (showing an inline validation error via
    // SetInnerHTML / SetElementVisible, toggling a row, etc.) rebuilds the
    // native TEdits in CreateFormControls, which re-seeds each input's text
    // from its DOM `value` attribute. Typing only updates the live TEdit.Text —
    // it never writes back to the DOM — so without this the rebuilt control
    // comes back BLANK, wiping fields the user already filled in (reported: the
    // Electricity meter number is cleared when Process is pressed with no
    // amount, because showing the error relays out). Sync each text input's
    // current value into its DOM `value` NOW, while the boxes/tags are still
    // alive (before the null-loop + reparse below), so CreateFormControls
    // restores it. On a full reparse the DOM is rebuilt from FHTML.Text and
    // these writes are harmlessly discarded — a deliberate fresh screen. An
    // intentional clear via SetElementValue already set TEdit.Text := '', so
    // this preserves that clear too. This is the framework-level version of the
    // per-screen "pin the value before relayout" workaround host code used to
    // need — every screen now retains its values on error automatically.
    for var VRec in FFormControls do
      if Assigned(VRec.Control) and Assigned(VRec.Box) and
         Assigned(VRec.Box.Tag) and Assigned(VRec.Box.Tag.Attributes) then
      try
        if VRec.Control is TEdit then
          VRec.Box.Tag.Attributes.AddOrSetValue('value', TEdit(VRec.Control).Text)
        else if VRec.Control is TMemo then
          VRec.Box.Tag.Attributes.AddOrSetValue('value', TMemo(VRec.Control).Lines.Text);
      except
      end;

    // Now that the reuse id is captured, null every FFormControls[].Box. The
    // reparse and the Layout below will free the DOM and the box tree; nulling
    // here means no later code can deref a dangling box — the OnExit/OnChange
    // handlers fired synchronously during ClearFormControls' DisposeOf, any
    // async ForceQueue closures, GetFormControlNameValue, etc. all check
    // `Assigned(Rec.Box)` and will correctly see nil and fall back to the
    // control's own .Text. The .Control is left intact; ClearFormControls and
    // CreateFormControls operate off Control + stable DOM id, never the box.
    for var I := 0 to FFormControls.Count - 1 do
    begin
      var Tmp := FFormControls[I];
      Tmp.Box := nil;
      FFormControls[I] := Tmp;
    end;

    var AvailW := Width;
    if ScrollBarVisible and (not FScrollBarOverlay) then
      AvailW := AvailW - FScrollBarWidth;

    // RESILIENT REPARSE + LAYOUT.
    // A fault inside FParser.Parse / FLayoutEngine.Layout (a malformed or
    // pathological DOM, a stale style ref, etc.) used to propagate straight
    // out of DoLayout. The `finally` reset FIsLayoutting, but FParserDirty
    // was left True with the parse/layout tree half-built — so the NEXT
    // relayout re-ran the SAME faulting reparse and faulted again, every
    // pass, poisoning the screen with a storm of swallowed AVs (johnny,
    // Statement search, 2026-06-11: "DoLayout pre-clear ... EAccessViolation"
    // repeating). Contain it here: on a fault, clear FParserDirty so we never
    // retry the bad input, drop to a clean EMPTY layout, and carry on. The
    // screen renders blank (recoverable by navigating away / re-searching)
    // instead of cascading. The host's global handler still sees nothing
    // because we recover locally; the cause is logged via TraceLog.
    // LFaultStage names the exact phase for the fault log below — this AV is a
    // use-after-free/heap-corruption family that only reproduces in the wild,
    // so the recovery log MUST say whether parse, stylesheet, or layout faulted
    // (and the input size) to be actionable (DoLayout AV root-cause, 2026-06-12).
    var LFaultStage := 'enter';
    try
      // Only re-parse the source HTML when the text has actually changed.
      // Direct DOM mutations (PrependHTML, SetElementText, SetElementStyle,
      // etc.) operate on the in-memory tree and only need a re-layout —
      // re-parsing would wipe their changes by rebuilding from FHTML.Text.
      if FParserDirty then
      begin
        LFaultStage := 'parse';
        FParser.Parse(FHTML.Text);

        // Build stylesheet from <style> blocks and <link rel="stylesheet"> hrefs
        LFaultStage := 'stylesheet';
        FStyleSheet.Clear;
        for var I := 0 to FParser.StyleBlocks.Count - 1 do
          FStyleSheet.AddCSS(FParser.StyleBlocks[I]);
        for var I := 0 to FParser.LinkHrefs.Count - 1 do
          FStyleSheet.LoadFromURL(FParser.LinkHrefs[I]);

        FParserDirty := False;
      end;

      LFaultStage := 'layout';
      FLayoutEngine.Layout(FParser.Root, AvailW, FStyleSheet);
      // Reached only when the WHOLE render succeeded — remember the markup so
      // the recovery ladder can restore this screen if a later one faults.
      FLastGoodHTML := FHTML.Text;
    except
      on E: Exception do
      begin
        TraceLog(Format('DoLayout FAULT @%s (%s: %s) htmlLen=%d styleBlocks=%d',
          [LFaultStage, E.ClassName, E.Message, Length(FHTML.Text),
           FParser.StyleBlocks.Count]));
        // RECOVERY LADDER — never leave the screen blank if we can help it
        // (customer: "no blank screens", 2026-06-12). Each rung uses a FRESH
        // parser (RecoverRender), which also clears the corrupted internals that
        // otherwise turn the NEXT render into a hard process exit.
        //   1. Re-render the SAME markup — this AV family is mostly transient,
        //      so a clean-parser retry usually just succeeds and the user gets
        //      the screen they asked for.
        //   2. Else re-render the LAST-GOOD markup — the previous screen stays
        //      up instead of going blank.
        //   3. Else, and only then, drop to an empty layout (last resort).
        if RecoverRender(FHTML.Text, AvailW) then
          TraceLog('DoLayout recovered — re-rendered current screen')
        else if (FLastGoodHTML <> '') and (FLastGoodHTML <> FHTML.Text) and
                RecoverRender(FLastGoodHTML, AvailW) then
          TraceLog('DoLayout recovered — restored last-good screen')
        else
        begin
          TraceLog('DoLayout recovery exhausted — empty layout');
          FParserDirty := False;
          try FreeAndNil(FParser); FParser := THTMLParser.Create; except end;
          try FLayoutEngine.Layout(nil, AvailW, FStyleSheet); except end;
        end;
      end;
    end;

    FContentHeight := FLayoutEngine.TotalHeight;
    if Assigned(FLayoutEngine.Root) then
      FContentWidth := FLayoutEngine.Root.MarginBoxWidth
    else
      FContentWidth := 0;
    // Restore per-box scroll positions onto the rebuilt layout tree.
    if Assigned(FLayoutEngine.Root) then
      RestoreScrollState(FLayoutEngine.Root);
    ClampScroll;
    FNeedRelayout := False;

    // Create native FMX controls for form elements.
    ClearFormControls;
    if Assigned(FLayoutEngine.Root) then
      CreateFormControls(FLayoutEngine.Root, 0, 0);

    {$IF defined(ANDROID) or defined(IOS)}
    // If CreateFormControls did NOT re-adopt the preserved control (its
    // element is gone from the new layout — e.g. a transfer step was
    // hidden), it's now orphaned and possibly still IME-bound. Detach it and
    // hand it to the keyboard-down deferral so it's freed only once the IME
    // has released (never synchronously here).
    if Assigned(FReuseCtl) then
    begin
      FReuseCtl.Parent := nil;
      if FReuseCtl.Owner = Self then
        RemoveComponent(FReuseCtl);
      FPendingDispose := FPendingDispose + [FReuseCtl];
      FReuseCtl := nil;
      FReuseId := '';
    end;
    // Any pooled control NOT re-adopted by CreateFormControls (its element was
    // removed from the new DOM) is now orphaned — detach + defer-dispose it on
    // the same keyboard-down path, never synchronously here. Whatever remains in
    // the pool was, by definition, not matched by id during this rebuild.
    if (FReusePool <> nil) and (FReusePool.Count > 0) then
    begin
      for var Leftover in FReusePool.Values do
        if Assigned(Leftover) then
        begin
          try Leftover.Parent := nil; except end;
          if Leftover.Owner = Self then RemoveComponent(Leftover);
          FPendingDispose := FPendingDispose + [Leftover];
        end;
      FReusePool.Clear;
    end;
    {$ENDIF}

    // Flash scrollbars briefly on load so the user sees what's scrollable,
    // then let them fade out.
    BumpScrollbarVisibility;

    // Handle autofocus attribute — focus the first input with autofocus.
    // SetFocus alone fires OnEnter on Styled TEdits, which in turn calls
    // RequestKeyboardShow → ForceShowSoftKeyboard (JNI SHOW_FORCED) so
    // the soft keyboard appears automatically on mobile. This is the
    // canonical web-style "autofocus pops the keyboard" behaviour —
    // host apps must NOT also call FocusElement programmatically after
    // setting HTML with autofocus, or the IME will be requested twice
    // and the second request can collide with the first's in-flight
    // state and visibly toggle the keyboard off.
    //
    // CRITICAL: skip the entire autofocus path if the soft keyboard is
    // already up (FKbdShowAsked / FKeyboardVisible). BuildLayout runs
    // multiple times per render (initial layout, post-font-load
    // relayout, etc.); each call destroys + recreates form controls,
    // and a fresh SetFocus on a freshly-created TEdit fires OnEnter →
    // RequestKeyboardShow. The second call sets FKbdResummonPending,
    // which causes a re-summon on the next VK dismiss — visibly
    // bouncing the keyboard. Once we've successfully popped the IME
    // we have nothing to gain by re-focusing on subsequent layout
    // passes — the user's already typing into a focused field.
    {$IF defined(ANDROID) or defined(IOS)}
    if FKbdShowAsked or FKeyboardVisible then
    begin
      // 2026-06-08 - keyboard is up from the previous screen. If THIS freshly
      // rendered screen has NO focusable inputs (e.g. Transfer "Confirm" -> the
      // read-only confirmation screen), the IME has nothing to bind to, so
      // dismiss it instead of leaving it floating over an input-less screen.
      if FFormControls.Count = 0 then
        HideVirtualKeyboardIfAny
      else
        TraceLog('autofocus: keyboard already up — skip SetFocus');
    end
    else
    {$ENDIF}
    for var Rec in FFormControls do
    try
      // HasAttribute/GetAttribute hash into the tag's attributes dictionary;
      // on a stale tag that faults inside TDictionary.Hash. This loop runs in
      // the Paint/relayout path (no enclosing try/except), so an uncaught fault
      // here would propagate out of DoLayout. Per-iteration guard: skip a bad
      // entry, never crash the paint. (Boxes are normally fresh here, but a
      // rapid flip-storm can leave a transient stale entry.)
      if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) and Rec.Box.Tag.HasAttribute('autofocus') then
      begin
        var AutoId := Rec.Box.Tag.GetAttribute('id', '');
        if AutoId <> '' then
          ScrollToElement(AutoId);
        Rec.Control.SetFocus;
        Break;
      end;
    except
      Continue;
    end;

  finally
    FIsLayoutting := False;
  end;
end;

function TTina4HTMLRender.ScrollBarVisible: Boolean;
begin
  Result := FScrollBarsVisible and (FContentHeight > Height);
end;

procedure TTina4HTMLRender.ClampScroll;
var
  VW, VH: Single;
begin
  VW := GetViewportWidth;
  VH := GetViewportHeight;
  if FContentHeight <= VH then
    FScrollY := 0
  else
    FScrollY := Max(0, Min(FScrollY, FContentHeight - VH));
  if FContentWidth <= VW then
    FScrollX := 0
  else
    FScrollX := Max(0, Min(FScrollX, FContentWidth - VW));
end;

function TTina4HTMLRender.GetViewportWidth: Single;
begin
  Result := Width;
  // Overlay scrollbars don't reserve layout width
  if ScrollBarVisible and (not FScrollBarOverlay) then
    Result := Result - FScrollBarWidth;
  if Result < 0 then Result := 0;
end;

function TTina4HTMLRender.GetViewportHeight: Single;
begin
  Result := Height;
  if Result < 0 then Result := 0;
end;

procedure TTina4HTMLRender.DoScrollChanged;
begin
  if Assigned(FOnScroll) then
    FOnScroll(Self, FScrollX, FScrollY);
end;

procedure TTina4HTMLRender.SetScrollX(const Value: Single);
var
  Old: Single;
begin
  Old := FScrollX;
  FScrollX := Value;
  ClampScroll;
  if SameValue(Old, FScrollX) then Exit;
  BumpScrollbarVisibility;
  PositionFormControls;
  Repaint;
  DoScrollChanged;
end;

procedure TTina4HTMLRender.SetScrollY(const Value: Single);
var
  Old: Single;
begin
  Old := FScrollY;
  FScrollY := Value;
  ClampScroll;
  if SameValue(Old, FScrollY) then Exit;
  BumpScrollbarVisibility;
  PositionFormControls;
  Repaint;
  DoScrollChanged;
end;

procedure TTina4HTMLRender.ScrollTo(X, Y: Single);
var
  OldX, OldY: Single;
begin
  OldX := FScrollX;
  OldY := FScrollY;
  FScrollX := X;
  FScrollY := Y;
  ClampScroll;
  if SameValue(OldX, FScrollX) and SameValue(OldY, FScrollY) then Exit;
  PositionFormControls;
  Repaint;
  DoScrollChanged;
end;

procedure TTina4HTMLRender.ScrollBy(DX, DY: Single);
begin
  ScrollTo(FScrollX + DX, FScrollY + DY);
end;

procedure TTina4HTMLRender.ScrollToTop;
begin
  ScrollTo(0, 0);
end;

procedure TTina4HTMLRender.ScrollToBottom;
begin
  ScrollTo(FScrollX, FContentHeight);
end;

function TTina4HTMLRender.FindLayoutBoxByTag(Box: TLayoutBox;
  Target: THTMLTag): TLayoutBox;
begin
  Result := nil;
  if not Assigned(Box) then Exit;
  if Box.Tag = Target then Exit(Box);
  for var Child in Box.Children do
  begin
    Result := FindLayoutBoxByTag(Child, Target);
    if Assigned(Result) then Exit;
  end;
end;

function TTina4HTMLRender.HitTestTagAt(Box: TLayoutBox;
  OffX, OffY, X, Y: Single): THTMLTag;
// Walk the layout tree depth-first looking for the deepest box whose
// margin-box rectangle contains (X, Y). Returns its Tag, or nil if none.
// Used by mouse-tracking to update :hover / :active state without a
// full repaint pass — all we need is the tag, then we mark it.
var
  AbsX, AbsY, CX, CY: Single;
  Hit: THTMLTag;
begin
  Result := nil;
  if not Assigned(Box) then Exit;
  AbsX := OffX + Box.X;
  AbsY := OffY + Box.Y;
  if (X < AbsX) or (X > AbsX + Box.MarginBoxWidth) or
     (Y < AbsY) or (Y > AbsY + Box.MarginBoxHeight) then
    Exit;
  // Box contains the point — record it and try to find a deeper match
  // among children. Children are positioned relative to ContentLeft/Top.
  if Assigned(Box.Tag) and (Box.Tag.TagName <> '#text') then
    Result := Box.Tag;
  CX := AbsX + Box.ContentLeft;
  CY := AbsY + Box.ContentTop;
  for var Child in Box.Children do
  begin
    Hit := HitTestTagAt(Child, CX, CY, X, Y);
    if Assigned(Hit) then Exit(Hit);
  end;
end;

procedure TTina4HTMLRender.UpdatePseudoChain(Chain: TList<THTMLTag>;
  NewLeaf: THTMLTag; const FlagName: string);
// Re-build the ancestor chain `:hover` / `:active` flag-set so it matches
// the current leaf. Tags that drop out of the chain have their flag
// cleared; new ones get it set. Triggers Repaint when anything changed.
var
  NewChain: TList<THTMLTag>;
  Walker: THTMLTag;
  Changed: Boolean;
begin
  NewChain := TList<THTMLTag>.Create;
  try
    Walker := NewLeaf;
    while Assigned(Walker) do
    begin
      NewChain.Add(Walker);
      Walker := Walker.Parent;
    end;

    // Compare to existing chain
    Changed := NewChain.Count <> Chain.Count;
    if not Changed then
      for var I := 0 to NewChain.Count - 1 do
        if NewChain[I] <> Chain[I] then
        begin
          Changed := True;
          Break;
        end;
    if not Changed then Exit;

    // Clear flags from tags no longer in the chain
    for var T in Chain do
      if NewChain.IndexOf(T) < 0 then
      begin
        if FlagName = 'hover' then T.IsHovered := False
        else if FlagName = 'active' then T.IsActive := False
        else if FlagName = 'focus' then T.IsFocused := False;
      end;
    // Set flags on newly-active tags
    for var T in NewChain do
      if Chain.IndexOf(T) < 0 then
      begin
        if FlagName = 'hover' then T.IsHovered := True
        else if FlagName = 'active' then T.IsActive := True
        else if FlagName = 'focus' then T.IsFocused := True;
      end;

    // Replace chain
    Chain.Clear;
    for var T in NewChain do Chain.Add(T);

    // We deliberately do NOT set FNeedRelayout here. Setting it on every
    // hover/active change caused a full relayout per MouseMove, which
    // visibly broke scroll/pan gestures (each cursor move while panning
    // would tear down + rebuild the layout tree). The trade-off: :hover/
    // :active styles only re-cascade on the next external relayout —
    // i.e. when HTML.Text changes, when a class is toggled, or when the
    // host calls Repaint after manually clearing FNeedRelayout. Most
    // apps don't need real-time hover feedback during a pan, and the
    // tag's IsHovered/IsActive flag is still correct so the selector
    // matches when the layout DOES rebuild.
    Repaint;
  finally
    NewChain.Free;
  end;
end;

function TTina4HTMLRender.GetBoxAbsolutePosition(Target: TLayoutBox;
  out AX, AY: Single): Boolean;

  function Walk(Box: TLayoutBox; OffX, OffY: Single): Boolean;
  var
    AbsX, AbsY, CX, CY: Single;
  begin
    AbsX := OffX + Box.X;
    AbsY := OffY + Box.Y;
    if Box = Target then
    begin
      AX := AbsX;
      AY := AbsY;
      Exit(True);
    end;
    CX := AbsX + Box.ContentLeft;
    CY := AbsY + Box.ContentTop;
    for var C in Box.Children do
      if Walk(C, CX, CY) then Exit(True);
    Result := False;
  end;

begin
  AX := 0;
  AY := 0;
  Result := False;
  if not Assigned(FLayoutEngine) or not Assigned(FLayoutEngine.Root) or
     not Assigned(Target) then Exit;
  Result := Walk(FLayoutEngine.Root, 0, 0);
end;

function TTina4HTMLRender.ScrollToElement(const Id: string;
  BottomInset: Single): Boolean;

  // Walk from Root, produce the path of boxes from root down to Target.
  function FindPath(Box, Target: TLayoutBox; Path: TList<TLayoutBox>): Boolean;
  begin
    if not Assigned(Box) then Exit(False);
    if Box = Target then
    begin
      Path.Add(Box);
      Exit(True);
    end;
    for var C in Box.Children do
      if FindPath(C, Target, Path) then
      begin
        Path.Insert(0, Box);
        Exit(True);
      end;
    Result := False;
  end;

var
  Tag: THTMLTag;
  Target: TLayoutBox;
  Path: TList<TLayoutBox>;
  I: Integer;
  PX, PY: Single;
  TargetW, TargetH: Single;
  AX, AY, NewX, NewY, VW, VH: Single;
begin
  Result := False;
  Tag := GetElementById(Id);
  if not Assigned(Tag) then Exit;
  if not Assigned(FLayoutEngine) or not Assigned(FLayoutEngine.Root) then Exit;
  Target := FindLayoutBoxByTag(FLayoutEngine.Root, Tag);
  if not Assigned(Target) then Exit;

  Path := TList<TLayoutBox>.Create;
  try
    if not FindPath(FLayoutEngine.Root, Target, Path) then Exit;

    TargetW := Target.MarginBoxWidth;
    TargetH := Target.MarginBoxHeight;

    // Walk from the target outward (inner scroll ancestors first). Track
    // PX/PY as the target's position relative to the current ancestor's
    // content box. At each scrollable ancestor, adjust ScrollX/Y so the
    // target is inside its viewport, then translate PX/PY back into the
    // ancestor's own parent-relative coordinates for the next iteration.
    PX := 0;
    PY := 0;
    for I := Path.Count - 1 downto 1 do
    begin
      // Path[I] is the current box (target or an ancestor). Accumulate
      // its position inside Path[I-1]'s content box into PX/PY. Path[I].X/Y
      // are relative to the content box of their parent.
      PX := PX + Path[I].X;
      PY := PY + Path[I].Y;
      // Now PX/PY is where the target lives inside Path[I-1]'s content box.
      var Anc := Path[I - 1];
      if Anc.IsScrollableY and (Anc.ScrollHeight > Anc.ContentHeight + 0.5) then
      begin
        if PY < Anc.ScrollY then
          Anc.ScrollY := PY
        else if (PY + TargetH) > (Anc.ScrollY + Anc.ContentHeight) then
          Anc.ScrollY := (PY + TargetH) - Anc.ContentHeight;
      end;
      if Anc.IsScrollableX and (Anc.ScrollWidth > Anc.ContentWidth + 0.5) then
      begin
        if PX < Anc.ScrollX then
          Anc.ScrollX := PX
      else if (PX + TargetW) > (Anc.ScrollX + Anc.ContentWidth) then
          Anc.ScrollX := (PX + TargetW) - Anc.ContentWidth;
      end;
      Anc.ClampOwnScroll;
      // Now PX/PY changes perspective: the target's visible position inside
      // Anc's content box is (PX - Anc.ScrollX, PY - Anc.ScrollY). For the
      // NEXT outer iteration, we need PX/PY relative to Anc's position in
      // its parent, so subtract the scroll we just applied.
      PX := PX - Anc.ScrollX;
      PY := PY - Anc.ScrollY;
    end;

    // Finally scroll the outer viewport. Use the full absolute position
    // (ignoring inner scrolls) so the box's layout cell is visible — the
    // inner scrolls above already made the target visible within each
    // intermediate container.
    if GetBoxAbsolutePosition(Target, AX, AY) then
    begin
      VW := GetViewportWidth;
      VH := GetViewportHeight;
      // BottomInset reduces the usable bottom of the viewport — lets
      // callers reserve space for an on-screen keyboard or a pinned
      // footer without needing a follow-up ScrollBy. Clamp to ≥ 1 so a
      // pathological inset (bigger than the viewport) doesn't produce
      // a negative effective height.
      if BottomInset > 0 then
      begin
        if BottomInset >= VH - 1 then
          VH := 1
        else
          VH := VH - BottomInset;
      end;
      NewX := FScrollX;
      NewY := FScrollY;
      if AY < FScrollY then
        NewY := AY
      else if (AY + TargetH) > (FScrollY + VH) then
        NewY := (AY + TargetH) - VH;
      if AX < FScrollX then
        NewX := AX
      else if (AX + TargetW) > (FScrollX + VW) then
        NewX := (AX + TargetW) - VW;
      ScrollTo(NewX, NewY);
    end
    else
      Repaint;
    Result := True;
  finally
    Path.Free;
  end;
end;

function TTina4HTMLRender.FocusElement(const Id: string): Boolean;
var
  Tag: THTMLTag;
begin
  Result := False;
  Tag := GetElementById(Id);
  TraceLog('FocusElement: id=' + Id + ' tag=' +
    BoolToStr(Assigned(Tag), True) +
    ' fformctlcount=' + IntToStr(FFormControls.Count));
  if not Assigned(Tag) then Exit;

  // Find the native FMX control associated with this element.
  // Guarded Rec.Box.Tag read: a freed TLayoutBox must not fault here.
  for var Rec in FFormControls do
  begin
    var FBoxTag: THTMLTag := nil;
    try
      if Assigned(Rec.Box) then FBoxTag := Rec.Box.Tag;
    except
      Continue;
    end;
    if Assigned(FBoxTag) and (FBoxTag = Tag) then
    begin
      TraceLog(Format('FocusElement: matched ctl=%p cls=%s focused-before=%s',
        [Pointer(Rec.Control), Rec.Control.ClassName,
         BoolToStr(Rec.Control.IsFocused, True)]));
      // Scroll the element into view first
      ScrollToElement(Id);
      // Set focus to the native control
      Rec.Control.SetFocus;
      TraceLog(Format('FocusElement: post-SetFocus focused-after=%s',
        [BoolToStr(Rec.Control.IsFocused, True)]));
      // Bring the IME up for text inputs. RequestKeyboardShow is
      // gated by FKbdShowAsked: if we've already asked the platform
      // to show the keyboard during this focus session, it's a no-op
      // and we don't redundantly poke the IMM. The flag is cleared
      // by VKStateChangeHandler when the platform reports the
      // keyboard has gone down.
      try
        if (Rec.Control is TEdit) or (Rec.Control is TMemo) then
          RequestKeyboardShow(Rec.Control as TControl);
      except
      end;
      Result := True;
      Exit;
    end;
  end;
end;

procedure TTina4HTMLRender.InsertHTMLFragment(Target: THTMLTag;
  const Html: string; AtFront: Boolean);
var
  TempParser: THTMLParser;
  Child: THTMLTag;
  InsertIdx: Integer;
begin
  if not Assigned(Target) or (Html = '') then Exit;
  TempParser := THTMLParser.Create;
  try
    TempParser.Parse(Html);
    InsertIdx := 0;
    for Child in TempParser.Root.Children do
    begin
      Child.Parent := Target;
      if AtFront then
      begin
        Target.Children.Insert(InsertIdx, Child);
        Inc(InsertIdx);
      end
      else
        Target.Children.Add(Child);
    end;
    // Detach moved children from the temp root so its destructor doesn't
    // free them — they now live under Target.
    TempParser.Root.Children.Clear;
  finally
    TempParser.Free;
  end;
end;

function TTina4HTMLRender.PrependHTML(const Id, Html: string;
  PreserveScrollPosition: Boolean): Boolean;
var
  Tag: THTMLTag;
  OldHeight, NewY: Single;
begin
  Result := False;
  Tag := GetElementById(Id);
  if not Assigned(Tag) then Exit;

  OldHeight := FContentHeight;
  InsertHTMLFragment(Tag, Html, True);

  // Force synchronous relayout so FContentHeight is fresh before we
  // adjust the scroll anchor.
  FNeedRelayout := True;
  DoLayout;

  if PreserveScrollPosition and (OldHeight > 0) then
  begin
    NewY := FScrollY + (FContentHeight - OldHeight);
    FScrollY := NewY;
    ClampScroll;
    PositionFormControls;
    // Intentionally do NOT fire OnScroll: from the user's perspective the
    // visible content has not moved, only the coordinate space has shifted.
    // Firing here would re-trigger lazy-load handlers and cause recursion.
  end;

  Repaint;
  Result := True;
end;

function TTina4HTMLRender.AppendHTML(const Id, Html: string): Boolean;
var
  Tag: THTMLTag;
begin
  Result := False;
  Tag := GetElementById(Id);
  if not Assigned(Tag) then Exit;

  InsertHTMLFragment(Tag, Html, False);
  FNeedRelayout := True;
  Repaint;
  Result := True;
end;

function TTina4HTMLRender.SetInnerHTML(const Id, Html: string): Boolean;
var
  Tag: THTMLTag;
  I: Integer;
begin
  Result := False;
  Tag := GetElementById(Id);
  if not Assigned(Tag) then Exit;

  // Free existing children
  for I := Tag.Children.Count - 1 downto 0 do
    Tag.Children[I].Free;
  Tag.Children.Clear;

  InsertHTMLFragment(Tag, Html, False);
  FNeedRelayout := True;
  Repaint;
  Result := True;
end;

// Rebuilds every native form control from scratch — used by the
// RerenderOnFocus path to defeat the Sunmi Android 11 refocus AV at
// SetControlType+0x0C. Snapshots id→value before disposal, blows
// away the entire form-control set (which DisposeOfs each TEdit
// AND its FMX presenter), then triggers a relayout + restores the
// captured values into the fresh TEdits.
procedure TTina4HTMLRender.RebuildFormControlsPreservingValues;
var
  Snapshot: TDictionary<string, string>;
  Id, Val: string;
begin
  TraceLog(Format('RebuildFormControlsPreservingValues count=%d',
    [FFormControls.Count]));

  // 1. Snapshot id → current value for every form control with an id.
  Snapshot := TDictionary<string, string>.Create;
  try
    for var Rec in FFormControls do
    begin
      if (Rec.Box = nil) or (Rec.Box.Tag = nil) then Continue;
      Id := Rec.Box.Tag.GetAttribute('id', '');
      if Id = '' then Continue;
      try
        if Rec.Control is TEdit then
          Snapshot.AddOrSetValue(Id, TEdit(Rec.Control).Text)
        else if Rec.Control is TMemo then
          Snapshot.AddOrSetValue(Id, TMemo(Rec.Control).Text);
      except
      end;
    end;

    // 2. Force a full relayout — clears + re-creates the form
    // controls inside DoLayout (which calls ClearFormControls then
    // CreateFormControls). FNeedRelayout := True signals the next
    // paint pass to rebuild from the cached parsed DOM.
    FNeedRelayout := True;
    Repaint;

    // 3. Restore values into the freshly-built TEdits. The new
    // FFormControls list now references brand-new controls. Walk it
    // and match by id.
    for var Rec in FFormControls do
    begin
      if (Rec.Box = nil) or (Rec.Box.Tag = nil) then Continue;
      Id := Rec.Box.Tag.GetAttribute('id', '');
      if Id = '' then Continue;
      if not Snapshot.TryGetValue(Id, Val) then Continue;
      try
        if Rec.Control is TEdit then
          TEdit(Rec.Control).Text := Val
        else if Rec.Control is TMemo then
          TMemo(Rec.Control).Text := Val;
      except
      end;
    end;
  finally
    Snapshot.Free;
  end;
end;

procedure TTina4HTMLRender.DeactivateNativePeers;
begin
  // 2026-05-27 — body removed. This used to swap TEdit ControlType to
  // Styled before a Visible:=False, when we were trying to keep
  // ControlType=Platform for the native Android EditText (autofill,
  // native password mask). That whole design lost: Platform produced
  // the bleed-through bug AND the offset-0x0C refocus AV. We now
  // leave ControlType at FMX default (Styled) for the entire
  // lifetime of every TEdit. Method kept on the public surface so
  // existing host call sites compile unchanged; on Android/iOS
  // it's now a no-op.
  TraceLog(Format('DeactivateNativePeers count=%d (no-op)',
    [FFormControls.Count]));
end;

procedure TTina4HTMLRender.ActivateNativePeers;
begin
  // 2026-05-27 — body removed. See DeactivateNativePeers comment.
  // PREVIOUSLY this promoted every TEdit back to ControlType.Platform
  // after a Visible:=True. On the SECOND show of a renderer (when
  // FFormControls already holds the existing TEdit instances), that
  // swap was flipping our Styled TEdits back to Platform — which
  // brought the bleed-through bug back. Tester repro:
  //   Login → Global → Menu (no bleed) → Tap Out → Airtime → Global →
  //   Menu (BLEEDS)
  // First show: count=0, loop no-ops, TEdit created Styled by
  //             ApplyHtmlInputAttrsToEdit, no bleed.
  // Second show: count=1, loop promotes existing Styled TEdit to
  //              Platform, native EditText created, bleeds.
  // Fix: leave ControlType alone, always Styled.
  TraceLog(Format('ActivateNativePeers count=%d (no-op)',
    [FFormControls.Count]));
end;

procedure TTina4HTMLRender.DrainPendingDispose;
var
  Old: TArray<TControl>;
begin
  if Length(FPendingDispose) = 0 then Exit;
  // Snapshot + clear first, so a re-entrant ClearFormControls during disposal
  // doesn't see the same controls twice.
  Old := FPendingDispose;
  FPendingDispose := nil;
  // Same re-entrancy guard as ClearFormControls: disposing these (deferred,
  // IME-bound) controls fires OnExit/OnChange synchronously, and FFormControls
  // may still hold freed-box entries — handlers must bail, not walk the list.
  FDisposingControls := True;
  try
    for var C in Old do
      if C <> nil then
        try C.Free; except end;
  finally
    FDisposingControls := False;
  end;
end;

procedure TTina4HTMLRender.Notification(AComponent: TComponent;
  Operation: TOperation);
var
  I: Integer;
  Keep: TArray<TControl>;
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) or (csDestroying in ComponentState) then Exit;
  // A native form control is being freed. Drop every reference to it so a
  // freed control can never be read back as a live TEdit (the multi-renderer
  // SetElementValue/FocusElement use-after-free AV at offset 0x0D).
  if Assigned(FFormControls) then
    for I := FFormControls.Count - 1 downto 0 do
      if FFormControls[I].Control = AComponent then
        FFormControls.Delete(I);
  if FReuseCtl = AComponent then FReuseCtl := nil;
  if FImeBoundCtl = AComponent then FImeBoundCtl := nil;
  // Purge it from the reuse pool too, so a freed control can never be re-adopted
  // by id in a later CreateFormControls.
  if (FReusePool <> nil) and (AComponent is TControl) then
  begin
    var PoolKey: string := '';
    for var Pair in FReusePool do
      if Pair.Value = AComponent then begin PoolKey := Pair.Key; Break; end;
    if PoolKey <> '' then FReusePool.Remove(PoolKey);
  end;
  // NOTE: we deliberately do NOT touch TCommonCustomForm.Focused here.
  // Reading Frm.Focused.GetObject during a multi-renderer teardown cascade is
  // a use-after-free (the focused control may already have been freed by a
  // prior ClearFormControls), and even the setter path is risky mid-cascade.
  // Form-focus clearing is handled safely in ClearFormControls, which detects
  // the focused control via OUR controls' own IsFocused flag (never the form
  // getter) and clears it with the setter before disposal.
  if Length(FPendingDispose) > 0 then
  begin
    Keep := nil;
    for var C in FPendingDispose do
      if C <> AComponent then Keep := Keep + [C];
    FPendingDispose := Keep;
  end;
end;

procedure TTina4HTMLRender.ClearFormControls;
begin
  TraceLog(Format('ClearFormControls count=%d gen=%d',
    [FFormControls.Count, FFormControlsGen]));
  // Advance the generation BEFORE we DisposeOf anything. Any deferred
  // action that captured the old gen will now skip its dereference of
  // the (about-to-be-freed) control — see HandleFormControlExit's
  // ForceQueue closure.
  Inc(FFormControlsGen);

  // Re-entrancy guard (try/finally so an exception can't leave it stuck): the
  // DisposeOf calls below fire OnExit/OnChange synchronously while FFormControls
  // still holds entries whose boxes the reparse already freed. The handlers
  // bail while this is set so none derefs a dangling box.
  FDisposingControls := True;
  try

  // CRITICAL: defocus any focused TEdit before disposing it. FMX's
  // form-level focus tracker (Self.Root.SetFocused) holds a pointer
  // to the currently-focused control; if we DisposeOf that control
  // without clearing the focus tracker, the pointer becomes dangling.
  // The very next focus change anywhere in the application — e.g. a
  // different renderer's TEdit getting focus on a downstream screen
  // — walks into the dead presenter and AVs at offset 0x0C.
  //
  // Documented as the "Transfer screen twice → 1Voucher refocus AV"
  // crash. The fix used to be DeactivateNativePeers in host code; that
  // method's body has since been gutted to a no-op.
  //
  // 2026-06-06 — TWO things must happen before we dispose a TEdit that
  // currently has focus, or the process dies on teardown (especially
  // on the Transfer screen, whose step transitions rebuild controls
  // while an input is IME-bound):
  //
  //   1. HIDE THE SOFT KEYBOARD. Disposing a TEdit while the Android
  //      IME holds an active InputConnection to it leaves the IME
  //      querying a dead native control — getTextAfterCursor() hangs
  //      ("didn't respond in 2000 msec") or the InputConnection
  //      teardown faults. Hiding the keyboard first releases the
  //      InputConnection cleanly.
  //
  //   2. CLEAR THE FORM FOCUS TRACKER. FMX's TCustomForm.Focused holds
  //      a pointer to the focused control; disposing it without
  //      clearing leaves a dangling pointer (the offset-0x0C refocus
  //      AV). We clear it with the SETTER only (Focused := nil) — we
  //      NEVER read Frm.Focused.GetObject, because in a multi-renderer
  //      teardown cascade the focused control may already have been
  //      freed by a prior ClearFormControls, making the getter a
  //      use-after-free. Instead we detect focus via OUR OWN controls'
  //      IsFocused flag (always safe — reads the control's own field).
  var FocusedCtl: TControl := nil;
  {$IF defined(ANDROID) or defined(IOS)}
  for var I := 0 to FFormControls.Count - 1 do
    if (FFormControls[I].Control <> nil) and
       FFormControls[I].Control.IsFocused then
    begin FocusedCtl := FFormControls[I].Control; Break; end;
  // Leave FReuseCtl untouched (kept focused + IME-bound for reuse this pass).
  if (FocusedCtl <> nil) and (FocusedCtl <> FReuseCtl) then
  begin
    TraceLog('ClearFormControls: focused ctl present — hide IME + clear focus');
    try
      var KbSvc: IFMXVirtualKeyboardService;
      if TPlatformServices.Current.SupportsPlatformService(
           IFMXVirtualKeyboardService, IInterface(KbSvc)) and (KbSvc <> nil) then
        KbSvc.HideVirtualKeyboard;
    except
    end;
    try
      if (Root <> nil) and (Root is TCustomForm) then
        TCustomForm(Root).Focused := nil;
    except
    end;
  end;
  // If the keyboard is already DOWN, anything deferred earlier is safe now.
  if (not FKeyboardVisible) and (Length(FPendingDispose) > 0) then
    DrainPendingDispose;
  {$ENDIF}

  // Dispose all tracked controls synchronously, EXCEPT the focused one —
  // it is detached now and freed later (FPendingDispose, below).
  for var I := FFormControls.Count - 1 downto 0 do
  begin
    var C := FFormControls[I].Control;
    if C = nil then Continue;
    if C = FReuseCtl then Continue;  // preserved for reuse: keep parented + bound
    {$IF defined(ANDROID) or defined(IOS)}
    // Reuse pool: a TEdit/TMemo that the impending CreateFormControls will
    // re-adopt by id. Keep it parented + bound — do NOT detach/dispose it, so
    // its native control and IME InputConnection survive the relayout untouched.
    if (FReusePool <> nil) and FReusePool.ContainsValue(C) then Continue;
    {$ENDIF}
    C.Parent := nil;
    if C = FocusedCtl then Continue;
    {$IF defined(ANDROID) or defined(IOS)}
    // CRITICAL (2026-06-06, Sunmi V2s silent crash entering an input screen):
    // While the soft keyboard is UP, the Android IME may still hold a live
    // InputConnection to a TEdit that only JUST lost focus — focus leaves the
    // old input the instant the keyboard pops / the next screen autofocuses,
    // BEFORE the IME rebinds. That control is no longer IsFocused, so it is
    // not the FocusedCtl captured above, yet DisposeOf-ing it out from under
    // the bound IME kills the process with no exception and no tombstone
    // (debuggerd locked down). Observed as: POS -> 1Voucher (or Global
    // Airtime), its autofocus input pops the keyboard, a relayout storm runs
    // ClearFormControls, and a just-unfocused IME-bound TEdit is freed -> die.
    // So while the keyboard is up — OR is mid-bind to this control (tapped but
    // VKStateChange not yet fired: FImeBoundCtl) — NEVER free an IME-capable
    // control inline; detach it, take it out of Self's ownership, and defer to
    // FPendingDispose (drained on keyboard-down, the definite IME-release
    // point). The FImeBoundCtl clause closes the slide-up window that
    // FKeyboardVisible alone misses.
    // Defer when the keyboard is up OR ANY input in this renderer is IME-bound /
    // binding (FImeBoundCtl set, held from the focus tap until keyboard-down).
    // It is not enough to spare only the bound control: freeing a SIBLING
    // input during the focus transition disturbs the FMX focus / Android IME
    // InputConnection chain and kills the process just the same (observed:
    // tapping txAmount, then a relayout frees lookupNo -> die). So while any
    // input here is IME-active, defer EVERY IME-capable control to keyboard-down.
    if ((C is TEdit) or (C is TMemo)) and (FKeyboardVisible or Assigned(FImeBoundCtl)) then
    begin
      if C.Owner = Self then RemoveComponent(C);
      FPendingDispose := FPendingDispose + [C];
      Continue;
    end;
    if (C is TEdit) or (C is TMemo) then
      TraceLog(Format('ClearFormControls: INLINE FREE edit=%p imebound=%p reuse=%p kbd=%s',
        [Pointer(C), Pointer(FImeBoundCtl), Pointer(FReuseCtl),
         BoolToStr(FKeyboardVisible, True)]));
    {$ENDIF}
    C.Free;
  end;
  FFormControls.Clear;

  // Safety sweep: remove any lingering native controls parented to Self
  // that may not be tracked (e.g. from a previous render cycle)
  for var I := ControlsCount - 1 downto 0 do
  begin
    var C := Controls[I];
    if C = FReuseCtl then Continue;  // preserved for reuse
    if C = FocusedCtl then Continue;
    {$IF defined(ANDROID) or defined(IOS)}
    if (FReusePool <> nil) and FReusePool.ContainsValue(C) then Continue;  // reuse pool: keep parented
    {$ENDIF}
    if (C is TEdit) or (C is TButton) or (C is TMemo) or (C is TComboBox)
      or (C is TCheckBox) or (C is TRadioButton) or (C is TRectangle)
      or (C is TLayout) then
    begin
      C.Parent := nil;
      {$IF defined(ANDROID) or defined(IOS)}
      // Same keyboard-up / IME-active deferral as the tracked loop: while any
      // input here is IME-bound/binding, freeing ANY IME-capable control (even
      // an untracked lingering one) can disturb the IME chain. Defer to kbd-down.
      if ((C is TEdit) or (C is TMemo)) and (FKeyboardVisible or Assigned(FImeBoundCtl)) then
      begin
        if C.Owner = Self then RemoveComponent(C);
        FPendingDispose := FPendingDispose + [C];
        Continue;
      end;
      {$ENDIF}
      C.Free;
    end;
  end;

  {$IF defined(ANDROID) or defined(IOS)}
  // Defer the focused (IME-bound) control: detach from view now, transfer
  // ownership out of Self (so the destructor can't double-free it), and hold
  // it in FPendingDispose. It is freed only when the keyboard is confirmed
  // DOWN (VKStateChangeHandler -> DrainPendingDispose) — the definite IME
  // release point. Freeing it while the IME is still bound crashes the
  // process (sync) or hangs the IME on the next focus (early defer); waiting
  // for keyboard-down avoids both. This is what makes the Transfer screen's
  // step transitions (which dispose focused inputs) stop corrupting the IME
  // for the next screen (the transfer -> Global Airtime crash). FReuseCtl is
  // excluded: it is being preserved for reuse, not removed.
  if (FocusedCtl <> nil) and (FocusedCtl <> FReuseCtl) then
  begin
    FocusedCtl.Parent := nil;
    if FocusedCtl.Owner = Self then
      RemoveComponent(FocusedCtl);
    FPendingDispose := FPendingDispose + [FocusedCtl];
  end;
  {$ENDIF}
  finally
    FDisposingControls := False;
  end;
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
      // Guard the Rec.Box.Tag deref: this runs from OnEnter/OnExit, which fire
      // while ClearFormControls disposes a focused TEdit — at that point the
      // box (and its tag) are already freed by the reparse. A dangling deref
      // here was the async use-after-free SIGSEGV. On a stale box, leave AName
      // empty and fall through to the control's own .Text below.
      try
        if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) then
        begin
          AName := Rec.Box.Tag.GetAttribute('name', '').Trim;
          // For radio/checkbox, return the element's value attribute
          if (Control is TCheckBox) or (Control is TRadioButton) then
            AValue := Rec.Box.Tag.GetAttribute('value', '').Trim;
        end;
      except
        TraceLog('GetFormControlNameValue: stale box skipped');
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
    else if Control is TLayout then
      AValue := TLayout(Control).TagString
    else if Control is TRectangle then
    begin
      for var I := 0 to TRectangle(Control).ChildrenCount - 1 do
        if TRectangle(Control).Children[I] is TLabel then
        begin
          AValue := TLabel(TRectangle(Control).Children[I]).Text;
          Break;
        end;
    end;
  end;
  AName := AName.Trim;
  AValue := AValue.Trim;
  Result := AName <> '';
end;

procedure TTina4HTMLRender.HandleFormControlChange(Sender: TObject);
var N, V: string;
begin
  if FDisposingControls then Exit;  // mid-dispose: FFormControls boxes are freed
  if Assigned(FOnChange) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnChange(Sender, N, V);
end;

// Collects name=value pairs for every form control whose nearest
// <form> ancestor is AFormTag. Skips submit/button/reset triggers and
// unchecked checkbox/radio. Caller owns the returned TStringList.
function TTina4HTMLRender.CollectFormData(FormTag: THTMLTag): TStringList;
begin
  Result := TStringList.Create;
  for var FRec in FFormControls do
  begin
    if (FRec.Box = nil) or (FRec.Box.Tag = nil) then Continue;
    var CtlName := FRec.Box.Tag.GetAttribute('name', '').Trim;
    if CtlName = '' then Continue;

    // Skip submit/button/reset inputs — they are triggers, not data
    var CtlTagName := FRec.Box.Tag.TagName.ToLower;
    if CtlTagName = 'button' then Continue;
    if CtlTagName = 'input' then
    begin
      var CtlType := FRec.Box.Tag.GetAttribute('type', 'text').ToLower.Trim;
      if (CtlType = 'submit') or (CtlType = 'button') or (CtlType = 'reset') then
        Continue;
    end;

    // Check this control belongs to the same form
    var CtlForm: THTMLTag := FRec.Box.Tag.Parent;
    while Assigned(CtlForm) and not SameText(CtlForm.TagName, 'form') do
      CtlForm := CtlForm.Parent;
    if CtlForm <> FormTag then Continue;

    // Get the value
    var CtlValue := '';
    if FRec.Control is TEdit then
      CtlValue := TEdit(FRec.Control).Text.Trim
    else if FRec.Control is TMemo then
      CtlValue := TMemo(FRec.Control).Lines.Text.Trim
    else if FRec.Control is TCheckBox then
    begin
      if not TCheckBox(FRec.Control).IsChecked then Continue;
      CtlValue := FRec.Box.Tag.GetAttribute('value', 'on').Trim;
    end
    else if FRec.Control is TRadioButton then
    begin
      if not TRadioButton(FRec.Control).IsChecked then Continue;
      CtlValue := FRec.Box.Tag.GetAttribute('value', 'on').Trim;
    end
    else if FRec.Control is TComboBox then
    begin
      if TComboBox(FRec.Control).Selected <> nil then
        CtlValue := TComboBox(FRec.Control).Selected.Text.Trim;
    end
    else if FRec.Control is TLayout then
    begin
      // File input: selected filename stored in TagString
      CtlValue := TLayout(FRec.Control).TagString.Trim;
    end;

    Result.Add(CtlName + '=' + CtlValue);
  end;
end;

// Walks up the DOM from Ctl's element to find the enclosing <form>,
// then fires OnFormSubmit with that form's data. No-op if Ctl is not
// a form control, isn't inside a <form>, or no OnFormSubmit is wired.
procedure TTina4HTMLRender.SubmitFormFor(Ctl: TControl);
var
  SrcTag, FormTag: THTMLTag;
  FormName: string;
  FormData: TStringList;
begin
  if not Assigned(FOnSubmit) then Exit;
  if Ctl = nil then Exit;

  SrcTag := nil;
  for var Rec in FFormControls do
    if Rec.Control = Ctl then
    begin
      if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) then SrcTag := Rec.Box.Tag;
      Break;
    end;
  if SrcTag = nil then Exit;

  FormTag := SrcTag.Parent;
  while Assigned(FormTag) and not SameText(FormTag.TagName, 'form') do
    FormTag := FormTag.Parent;
  if not Assigned(FormTag) then Exit;

  FormName := FormTag.GetAttribute('name', FormTag.GetAttribute('id', '')).Trim;
  FormData := CollectFormData(FormTag);
  try
    FOnSubmit(Ctl, FormName, FormData);
  finally
    FormData.Free;
  end;
end;

// Returns the next TEdit / TMemo / TComboBox in FFormControls after
// the one currently holding focus. FFormControls is built by walking
// the layout tree top-down during CreateFormControls, so the list
// order matches DOM order — good enough for "Next" traversal.
function TTina4HTMLRender.FindNextFocusableFormControl(
  Ctl: TControl): TControl;
var
  I, StartIdx: Integer;
  C: TControl;
begin
  Result := nil;
  StartIdx := -1;
  for I := 0 to FFormControls.Count - 1 do
    if FFormControls[I].Control = Ctl then begin StartIdx := I; Break; end;
  if StartIdx < 0 then Exit;

  for I := StartIdx + 1 to FFormControls.Count - 1 do
  begin
    C := FFormControls[I].Control;
    if (C is TEdit) or (C is TMemo) or (C is TComboBox) then
    begin
      if C.Visible and C.Enabled then Exit(C);
    end;
  end;
end;

// Asks the platform to dismiss the virtual keyboard. No-op on desktop
// or when the service isn't available.
procedure TTina4HTMLRender.HideVirtualKeyboardIfAny;
var
  Svc: IFMXVirtualKeyboardService;
begin
  if TPlatformServices.Current.SupportsPlatformService(
       IFMXVirtualKeyboardService, IInterface(Svc)) and (Svc <> nil) then
    Svc.HideVirtualKeyboard;
end;

// Dispatcher for the Enter/Return key on text inputs. The return-key
// action is driven by the control's ReturnKeyType, which
// ApplyHtmlInputAttrsToEdit sets from the HTML `enterkeyhint`
// attribute. "Default" is left alone — TMemo inserts a newline,
// TEdit does nothing, which matches standard form behaviour.
procedure TTina4HTMLRender.HandleFormControlKeyDown(Sender: TObject;
  var Key: Word; var KeyChar: WideChar; Shift: TShiftState);
var
  RK: TReturnKeyType;
  Ctl, NextCtl: TControl;
begin
  // vkReturn fires for Enter on hardware keyboards AND for the "done"
  // style button on the soft keyboard. Only act on it.
  if Key <> vkReturn then Exit;
  if not (Sender is TControl) then Exit;
  Ctl := TControl(Sender);

  RK := TReturnKeyType.Default;
  if Ctl is TEdit then
    RK := TEdit(Ctl).ReturnKeyType;

  case RK of
    TReturnKeyType.Next:
      begin
        NextCtl := FindNextFocusableFormControl(Ctl);
        if NextCtl <> nil then
        begin
          NextCtl.SetFocus;
          // Suppress the key so TMemo doesn't also insert a newline.
          Key := 0;
          KeyChar := #0;
        end;
      end;

    TReturnKeyType.Done:
      begin
        HideVirtualKeyboardIfAny;
        Key := 0;
        KeyChar := #0;
      end;

    TReturnKeyType.Go, TReturnKeyType.Send, TReturnKeyType.Search:
      begin
        // "Go", "Send" and "Search" are the soft-keyboard equivalents
        // of pressing a submit button. Fire the form submission.
        SubmitFormFor(Ctl);
        HideVirtualKeyboardIfAny;
        Key := 0;
        KeyChar := #0;
      end;
    // TReturnKeyType.Default — let the control do its native thing
    // (newline in memo, no-op in edit).
  end;
end;

// Amount of the render's visible area covered by the soft keyboard,
// in screen pixels. On Android with adjustResize the keyboard never
// overlaps because the activity has shrunk; on iOS the activity keeps
// its full size, so we compute the geometric overlap of our screen
// rect with the keyboard's screen rect.
function TTina4HTMLRender.GetKeyboardOverlapHeight: Single;
var
  MyAbsRect, KbRect: TRectF;
begin
  Result := 0;
  if not FKeyboardVisible then Exit;
  if (FKeyboardBounds.Width = 0) or (FKeyboardBounds.Height = 0) then Exit;

  try
    // AbsoluteRect is the render's rect in the parent form's coordinate
    // space. On a full-screen mobile app the form fills the screen, so
    // this is effectively screen coordinates — the same frame of reference
    // as FKeyboardBounds, which FMX reports in form/screen coords on
    // Android and iOS. On desktop there's no real VK so we never reach
    // here; the (0,0)-origin fallback used before was mathematically
    // always outside the keyboard rect, so the overlap calc was a no-op.
    MyAbsRect := AbsoluteRect;
  except
    Exit;
  end;

  KbRect := TRectF.Create(FKeyboardBounds);
  if KbRect.Top >= MyAbsRect.Bottom then Exit;      // keyboard below us
  if KbRect.Bottom <= MyAbsRect.Top then Exit;      // keyboard above us

  if KbRect.Top < MyAbsRect.Top then
    Result := MyAbsRect.Height
  else
    Result := MyAbsRect.Bottom - KbRect.Top;

  if Result < 0 then Result := 0;
end;

// After the soft keyboard appears, make sure the currently focused
// input is inside the remaining visible area. Walks the form-controls
// list to find which one is focused (Screen.FocusControl points at it),
// looks up its DOM id, then reuses ScrollToElement.
procedure TTina4HTMLRender.ScrollFocusedControlAboveKeyboard;
const
  KEYBOARD_PADDING_PX  = 8;    // absolute floor below the native control
  MIN_CLEARANCE_PX     = 48;   // Material touch-target min
var
  FocusedCtl: TControl;
  Overlap, Clearance, CtlBottom, KbTop: Single;
  TargetId: string;
  Scr: TCommonCustomForm;
begin
  if not FKeyboardVisible then Exit;
  Overlap := GetKeyboardOverlapHeight;
  if Overlap <= 0 then Exit;  // nothing to do — kb doesn't cover us

  FocusedCtl := nil;
  Scr := nil;
  if (Root <> nil) and (Root.GetObject is TCommonCustomForm) then
    Scr := TCommonCustomForm(Root.GetObject);
  if Scr <> nil then
    FocusedCtl := TControl(Scr.Focused);  // may be nil
  if FocusedCtl = nil then Exit;

  // GetKeyboardOverlapHeight above only tells us the keyboard covers the
  // RENDERER's rect (the full-screen frame is always covered at the bottom).
  // That is NOT the same as the focused INPUT being occluded. Measure the
  // focused control's own on-screen bottom against the keyboard top: if the
  // input already sits entirely above the keyboard there is nothing to
  // scroll. Crucially this avoids a spurious ScrollToElement ->
  // PositionFormControls + Repaint firing DURING the keyboard's window-surface
  // transaction — the exact moment the MTK compositor stalls on. On Android
  // (adjustResize) the window shrinks when the IME appears, so a focused input
  // is almost never truly occluded and this gate skips the scroll entirely.
  try
    CtlBottom := FocusedCtl.AbsoluteRect.Bottom;
  except
    CtlBottom := 0;
  end;
  KbTop := TRectF.Create(FKeyboardBounds).Top;
  if (CtlBottom > 0) and (KbTop > 0) and (CtlBottom <= KbTop + 1) then
  begin
    TraceLog(Format('ScrollAboveKb: focused ctl already above kb ' +
      '(ctlBottom=%.0f kbTop=%.0f) — skip scroll', [CtlBottom, KbTop]));
    Exit;
  end;

  // Walk our form-control list to find the focused one and grab its id.
  // If the author didn't give the input an id we can't address it in
  // ScrollToElement; the keyboard will still come up, just without the
  // scroll-above-kb assist. Document authors should set id="" on
  // focusable inputs to get this behaviour.
  TargetId := '';
  for var Rec in FFormControls do
    if Rec.Control = FocusedCtl then
    begin
      if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) then
        TargetId := Rec.Box.Tag.GetAttribute('id', '');
      Break;
    end;
  if TargetId = '' then Exit;

  // Reserve enough bottom space that the ENTIRE focused control stays
  // above the keyboard, not just the top edge of its HTML layout box.
  // Android's native EditText has internal padding / min-height that
  // can make the platform control taller than the HTML margin box,
  // and some OEM keyboards report a slightly smaller height than they
  // actually occupy. Use max(control height, MIN_CLEARANCE_PX) plus
  // an 8px breathing gap.
  Clearance := FocusedCtl.Height;
  if Clearance < MIN_CLEARANCE_PX then Clearance := MIN_CLEARANCE_PX;

  // Single-pass scroll: tell ScrollToElement to treat the bottom
  // portion of the viewport as "reserved for the keyboard + input".
  // No follow-up ScrollBy — the old version layered a ScrollBy on
  // top of an already-valid scroll position and over-shot into the
  // gutter, which is why the keyboard kept dismissing itself.
  TraceLog(Format('ScrollAboveKb: scrolling id=%s (overlap=%.0f clearance=%.0f)',
    [TargetId, Overlap, Clearance]));
  ScrollToElement(TargetId, Overlap + Clearance + KEYBOARD_PADDING_PX);
end;

// Invoked whenever FMX posts a virtual-keyboard state change.
procedure TTina4HTMLRender.VKStateChangeHandler(const Sender: TObject;
  const M: System.Messaging.TMessage);
var
  VKMsg: TVKStateChangeMessage;
begin
  if not (M is TVKStateChangeMessage) then Exit;
  VKMsg := TVKStateChangeMessage(M);
  FKeyboardVisible := VKMsg.KeyboardVisible;
  if FKeyboardVisible then
    FKeyboardBounds := VKMsg.KeyboardBounds
  else
  begin
    FKeyboardBounds := TRect.Empty;
    // Keyboard is fully DOWN -> the IME has released its InputConnection, so
    // the control it was bound to is safe to free inline again. Clear the
    // IME-target pointer (its disposal will be drained below via
    // DrainPendingDispose if it was deferred).
    FImeBoundCtl := nil;
    // Keyboard went down — clear the "we asked" flag so the next
    // focus event is free to fire ShowVirtualKeyboard again.
    FKbdShowAsked := False;
    // Also clear resummon so a stale True from earlier doesn't
    // accidentally re-summon when a focused TEdit still exists on
    // the new screen.
    FKbdResummonPending := False;
    // RESUMMON PATH REMOVED — was causing "permanent keyboard"
    // perception. With the resummon firing whenever a focused
    // TEdit existed and visible=False arrived, every navigation
    // between input screens kept re-popping the IME (every screen
    // with autofocus has a focused TEdit). The original use case
    // — typing → tapping Lookup → error re-stamp → keyboard back
    // — is now handled by the user re-tapping the input. One tap
    // is cheaper than the IME-stuck-up bug we introduced.

    // Keyboard is fully DOWN now -> the Android IME has released its
    // InputConnection. Free any focused TEdit we detached during a relayout
    // while the keyboard was up (held in FPendingDispose to avoid freeing it
    // mid-IME-bind, which crashes/hangs on the Sunmi V2s). Deferred a tick so
    // the current message completes first. Runs for every renderer, so each
    // drains its OWN pending list (e.g. the Transfer renderer frees the
    // inputs it disposed across its step transitions, leaving the IME clean
    // for the next screen -> the transfer -> Global Airtime crash fix).
    if Length(FPendingDispose) > 0 then
      TThread.ForceQueue(nil, procedure begin DrainPendingDispose; end);

    // Service any relayout that ResizeSettleTick deferred while the keyboard
    // was up. The keyboard is fully down now: the window is back to its
    // pre-keyboard size, the IME has released, and nothing is focused — so a
    // DoLayout here is safe and reflects any genuine geometry change that
    // landed during the keyboard window. Deferred a tick so the current VK
    // message finishes first. ParentedVisible-gated inside Paint/DoLayout.
    if FRelayoutAfterKbd then
    begin
      FRelayoutAfterKbd := False;
      TThread.ForceQueue(nil,
        procedure
        begin
          if csDestroying in ComponentState then Exit;
          FNeedRelayout := True;
          Repaint;
        end);
    end;
  end;
  // CRITICAL (2026-06-06, Sunmi V2s keyboard-frame ANR):
  // TVKStateChangeMessage is a GLOBAL broadcast — EVERY live
  // TTina4HTMLRender on the form receives it. A host can keep several
  // renderers parented at once (overlay pattern: Voucher / Electricity /
  // DStv / Global Airtime / POS grid / Transfer), so one keyboard show
  // fans out into N handler runs. Worse, FMX re-fires
  // onVirtualKeyboardFrameChanged on EVERY decor-view layout change —
  // i.e. on every frame of the keyboard slide-in animation. The product
  // N renderers x M animation frames x (file-trace + ForceQueue(scroll) +
  // scroll-repaint) saturates the UI thread and starves the input queue:
  //   "Input dispatching timed out ... Waited 5000ms for MotionEvent"
  // with the main thread caught spinning in dispatchToNative under
  // onVirtualKeyboardFrameChanged. Reproduced as: do a transfer, open
  // Global Airtime, its autofocus pops the keyboard, app freezes -> ANR.
  //
  // The keyboard state (FKeyboardVisible / FKeyboardBounds, set above) is
  // cheap and worth keeping current on every renderer. But the expensive
  // reaction — tracing and the scroll-above-keyboard pass — only matters
  // for the renderer the user can actually see. Off-screen renderers bail
  // here, collapsing the fan-out from N to 1. ParentedVisible (not Visible)
  // so a renderer on a hidden parent frame is correctly treated as hidden.
  if not ParentedVisible then Exit;

  TraceLog(Format('VKStateChange visible=%s bounds=(%d,%d %dx%d)',
    [BoolToStr(FKeyboardVisible, True),
     FKeyboardBounds.Left, FKeyboardBounds.Top,
     FKeyboardBounds.Width, FKeyboardBounds.Height]));

  // Re-enabled now that ControlType is Styled (no presenter chain
  // to deref). Scrolls the focused input above the IME if it lands
  // below the keyboard bounds. COALESCED: the frame-change message
  // arrives many times during the keyboard animation; queue at most one
  // scroll at a time (FScrollAboveKbQueued) so we don't flood the loop.
  if FKeyboardVisible and (not FScrollAboveKbQueued) then
  begin
    FScrollAboveKbQueued := True;
    TThread.ForceQueue(nil,
      procedure
      begin
        FScrollAboveKbQueued := False;
        try
          ScrollFocusedControlAboveKeyboard;
        except
        end;
      end);
  end;
end;

procedure TTina4HTMLRender.HandleFileInputClick(Sender: TObject);
var
  Dlg: TOpenDialog;
begin
  Dlg := TOpenDialog.Create(nil);
  try
    Dlg.Title := 'Choose File';
    // Use the accept attribute to set file filters if available
    if (Sender is TRectangle) and (TRectangle(Sender).TagString <> '') then
    begin
      var Accept := TRectangle(Sender).TagString;
      // Convert HTML accept patterns to dialog filters
      if Accept.Contains('image/') or Accept.Contains('.png') or
         Accept.Contains('.jpg') or Accept.Contains('.gif') then
        Dlg.Filter := 'Image files|*.png;*.jpg;*.jpeg;*.gif;*.bmp;*.webp|All files|*.*'
      else if Accept.Contains('.pdf') then
        Dlg.Filter := 'PDF files|*.pdf|All files|*.*'
      else
        Dlg.Filter := 'All files|*.*';
    end
    else
      Dlg.Filter := 'All files|*.*';

    if Dlg.Execute then
    begin
      // Update the filename label — it's a sibling of the button inside the TLayout
      if (Sender is TControl) and (TControl(Sender).Parent is TLayout) then
      begin
        var Container := TLayout(TControl(Sender).Parent);
        for var I := 0 to Container.ChildrenCount - 1 do
          if (Container.Children[I] is TLabel) and
             (Container.Children[I] <> TControl(Sender)) and
             not (Container.Children[I].Parent is TRectangle) then
          begin
            TLabel(Container.Children[I]).Text := ExtractFileName(Dlg.FileName);
            TLabel(Container.Children[I]).FontColor := TAlphaColors.Black;
            Break;
          end;
        // Store the full path on the container's TagString for form submission
        Container.TagString := Dlg.FileName;
      end;

      // Fire OnChange
      if Assigned(FOnChange) and (Sender is TControl) then
      begin
        // Find the Box for the parent container
        for var Rec in FFormControls do
        begin
          if Rec.Control = TControl(Sender).Parent then
          begin
            if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) then
              FOnChange(Sender, Rec.Box.Tag.GetAttribute('name', ''),
                Dlg.FileName);
            Break;
          end;
        end;
      end;
    end;
  finally
    Dlg.Free;
  end;
end;

// Translate HTML input/textarea attributes into the native FMX edit's
// keyboard, capitalization, return-key, length and password properties.
// Called once per control at creation time. The platform reads these
// when the virtual keyboard is summoned, so emails get '@' keys,
// numeric inputs get a numpad, passwords disable predictive text, etc.
procedure TTina4HTMLRender.ApplyHtmlInputAttrsToEdit(Box: TLayoutBox;
  Ed: TEdit);
var
  InputType, InputMode, EnterKeyHint, AutoCap, MaxLenStr: string;
  MaxLen: Integer;
begin
  if (Box = nil) or (Box.Tag = nil) or (Ed = nil) then Exit;
  TraceLog(Format('ApplyHtmlInputAttrsToEdit id=%s ed=%p',
    [Box.Tag.GetAttribute('id', ''), Pointer(Ed)]));

  InputType    := Box.Tag.GetAttribute('type', 'text').ToLower;
  InputMode    := Box.Tag.GetAttribute('inputmode', '').ToLower;
  EnterKeyHint := Box.Tag.GetAttribute('enterkeyhint', '').ToLower;
  AutoCap      := Box.Tag.GetAttribute('autocapitalize', '').ToLower;
  MaxLenStr    := Box.Tag.GetAttribute('maxlength', '');

  // Keyboard layout: prefer explicit inputmode (HTML spec's override)
  // over the type attribute. E.g. type=text inputmode=numeric should
  // get a numpad, which a bare type=text can't express.
  if InputMode <> '' then
  begin
    if      InputMode = 'numeric' then Ed.KeyboardType := TVirtualKeyboardType.NumberPad
    else if InputMode = 'decimal' then Ed.KeyboardType := TVirtualKeyboardType.NumbersAndPunctuation
    else if InputMode = 'tel'     then Ed.KeyboardType := TVirtualKeyboardType.PhonePad
    else if InputMode = 'email'   then Ed.KeyboardType := TVirtualKeyboardType.EmailAddress
    else if InputMode = 'url'     then Ed.KeyboardType := TVirtualKeyboardType.URL
    else if InputMode = 'search'  then Ed.KeyboardType := TVirtualKeyboardType.Alphabet
    else if InputMode = 'none'    then Ed.ReadOnly := True  // suppress keyboard entirely
    else                               Ed.KeyboardType := TVirtualKeyboardType.Default;
  end
  else
  begin
    if      InputType = 'number'   then Ed.KeyboardType := TVirtualKeyboardType.NumberPad
    else if InputType = 'tel'      then Ed.KeyboardType := TVirtualKeyboardType.PhonePad
    else if InputType = 'email'    then Ed.KeyboardType := TVirtualKeyboardType.EmailAddress
    else if InputType = 'url'      then Ed.KeyboardType := TVirtualKeyboardType.URL
    else if InputType = 'search'   then Ed.KeyboardType := TVirtualKeyboardType.Alphabet
    else if InputType = 'password' then Ed.KeyboardType := TVirtualKeyboardType.Default
    else                                Ed.KeyboardType := TVirtualKeyboardType.Default;
  end;

//  // Capitalization. Default for a text field on mobile is Sentences;
//  // sensitive / structured fields should never auto-cap.
//  if (InputType = 'password') or (InputType = 'email') or
//     (InputType = 'url') or (InputType = 'tel') or
//     (InputMode = 'numeric') or (InputMode = 'decimal') then
//    Ed.KeyboardAutoCap := TAutoCapitalizationType.None
//  else if AutoCap = 'off'        then Ed.KeyboardAutoCap := TAutoCapitalizationType.None
//  else if AutoCap = 'none'       then Ed.KeyboardAutoCap := TAutoCapitalizationType.None
//  else if AutoCap = 'sentences'  then Ed.KeyboardAutoCap := TAutoCapitalizationType.Sentences
//  else if AutoCap = 'words'      then Ed.KeyboardAutoCap := TAutoCapitalizationType.Words
//  else if AutoCap = 'characters' then Ed.KeyboardAutoCap := TAutoCapitalizationType.AllCharacters
//  else                                Ed.KeyboardAutoCap := TAutoCapitalizationType.Sentences;

  // Return-key label on the soft keyboard. HTML 'enterkeyhint' maps
  // cleanly onto FMX's TReturnKeyType.
  if      EnterKeyHint = 'done'     then Ed.ReturnKeyType := TReturnKeyType.Done
  else if EnterKeyHint = 'go'       then Ed.ReturnKeyType := TReturnKeyType.Go
  else if EnterKeyHint = 'next'     then Ed.ReturnKeyType := TReturnKeyType.Next
  else if EnterKeyHint = 'search'   then Ed.ReturnKeyType := TReturnKeyType.Search
  else if EnterKeyHint = 'send'     then Ed.ReturnKeyType := TReturnKeyType.Send
  else if EnterKeyHint = 'previous' then Ed.ReturnKeyType := TReturnKeyType.Default
  else                                   Ed.ReturnKeyType := TReturnKeyType.Default;

  if (MaxLenStr <> '') and TryStrToInt(MaxLenStr, MaxLen) and (MaxLen > 0) then
    Ed.MaxLength := MaxLen;

  // ControlType decision is platform-specific. Android: stay Styled (the
  // Sunmi V2s/Android 11 native EditText causes three unfixable bugs —
  // bleed-through, refocus AV at SetControlType+0x0C, Java GestureDetector
  // proxy crash; see the full write-up below for history). iOS: go
  // Platform. With Styled on iOS, FMX.VirtualKeyboard.iOS attaches a
  // UIToolbar with a blue "Done" UIBarButtonItem to the offscreen
  // UITextField it uses as the keyboard responder — which surfaced as
  // unwanted chrome above the keyboard for TestFlight users. The native
  // UITextField that ControlType.Platform produces gets no automatic
  // accessory bar, so the Done button doesn't appear. The iOS-specific
  // Sunmi bugs don't exist on iOS so there's no downside to Platform
  // mode there.
  {$IFDEF IOS}
  // 2026-06-08 — DISABLED native UITextField on iOS (was: ControlType.Platform).
  // The native peer keeps async UIKit callbacks (paint/layout/VK) that fire a
  // tick AFTER a re-render has already freed the control — a use-after-free
  // INSIDE FMX/UIKit, below any Pascal try/except. CrashSimTest on iOS proved
  // it: AVcaught=0, UNCAUGHT climbing on every flip, constant fault address,
  // the freed slot reused by a UTF-16 banner string. Mirror Android (which is
  // already Styled, see the note above): Styled = FMX-managed, synchronous
  // dispose, NO native async peer -> the UAF can't happen. Trade-off:
  // FMX.VirtualKeyboard.iOS re-adds a "Done" accessory bar above the keyboard
  // (cosmetic). Stability wins — same call we made for Android.
  // Ed.ControlType := TControlType.Platform;
  {$ENDIF}
end;

procedure TTina4HTMLRender.RequestKeyboardShow(ACtl: TControl);
{$IF defined(ANDROID) or defined(IOS)}
var
  TargetCtl: TControl;
{$ENDIF}
begin
{$IFDEF ANDROID}
  // 2026-06-06 — PROGRAMMATIC KEYBOARD SHOW DISABLED ON ANDROID.
  //
  // Driving the IME up programmatically (JNI showSoftInput) forces an
  // InputConnection binding to a Styled TEdit. On the Sunmi V2s this
  // destabilises the IME: the InputConnection's getTextAfterCursor()
  // query blocks the main thread for >1s, the IME watchdog times out
  // ("didn't respond in 2000 msec"), and the process is killed — with
  // NO crash trace (debuggerd is locked down on this device). The
  // crash was reproducible specifically on the Transfer screen and the
  // customer confirmed: "we never crashed before the keyboard work."
  //
  // Reverting to FMX's NATIVE behaviour: the soft keyboard comes up
  // when the user TAPS a field (FMX wires the tap→focus→IME path
  // itself, with VKAutoShowMode := DefinedBySystem set in the host's
  // FormShow). We no longer poke the IME programmatically at all. The
  // only UX change: the keyboard does not auto-pop on programmatic
  // screen-entry focus — the cashier taps the field, which they do
  // anyway. Stability over a minor convenience.
  TraceLog('ReqKbd: programmatic show disabled on Android (native tap only)');
  Exit;
{$ENDIF}
{$IF defined(ANDROID) or defined(IOS)}
  if ACtl = nil then Exit;

  // Gate: if we've already asked the platform to show the keyboard
  // for this focus session, don't ask again. FKbdShowAsked stays True
  // until the platform reports the keyboard has gone down
  // (VKStateChangeHandler clears it on visible=False). This makes
  // back-to-back focus events (tap A → tap B with IME up, or
  // programmatic re-focus on re-render) a no-op — Android keeps the
  // IME up and re-binds it to the newly-focused control automatically.
  if FKbdShowAsked then
  begin
    // We've already asked. Record that the caller wanted the keyboard
    // up — if a subsequent dismiss is triggered by a button tap (rather
    // than the user deliberately closing the IME), we'll re-summon in
    // VKStateChangeHandler when visible=False arrives.
    FKbdResummonPending := True;
    TraceLog('ReqKbd: already asked — skip, resummon-pending=True');
    Exit;
  end;
  FKbdShowAsked := True;
  FKbdResummonPending := False;
  TargetCtl := ACtl;
  TraceLog(Format('ReqKbd: asking ctl=%p cls=%s',
    [Pointer(TargetCtl), TargetCtl.ClassName]));

  // Queue the show on the next idle tick so Android's focus chain
  // settles first.
  TThread.ForceQueue(nil, procedure
    begin
      {$IFDEF ANDROID}
      try
        ForceShowSoftKeyboard;
      except
        on E: Exception do TraceLog('ReqKbd ForceShow EX: ' + E.Message);
      end;
      {$ELSE}
      // iOS path: fall back to FMX's keyboard service. The JNI
      // helper is Android-only; iOS doesn't have an equivalent
      // anti-spawn problem to work around.
      var Svc: IFMXVirtualKeyboardService;
      try
        if TPlatformServices.Current.SupportsPlatformService(
             IFMXVirtualKeyboardService, IInterface(Svc)) and (Svc <> nil) then
          Svc.ShowVirtualKeyboard(TargetCtl);
      except
        on E: Exception do TraceLog('ReqKbd EX: ' + E.Message);
      end;
      {$ENDIF}
    end);
{$ENDIF}
end;

{$IFDEF ANDROID}
procedure TTina4HTMLRender.ForceShowSoftKeyboard;
begin
  // Delegate to Tina4AndroidIME — keeps the JNI imports out of this
  // unit's compilation context (where they shadow TThreadProcedure
  // and break every TThread.ForceQueue call site).
  Tina4AndroidIME.ForceShowSoftKeyboard(
    procedure (const M: string) begin TraceLog(M) end);
end;
{$ENDIF}

procedure TTina4HTMLRender.HandleFormControlEnter(Sender: TObject);
var
  N, V: string;
begin
  if FDisposingControls then Exit;  // mid-dispose: FFormControls boxes are freed
  TraceLog(Format('OnEnter ENTRY sender=%p class=%s',
    [Pointer(Sender), Sender.ClassName]));
  {$IF defined(ANDROID) or defined(IOS)}
  // Remember which control the IME is now binding to. The bind starts HERE
  // (the focus tap), well before VKStateChangeHandler reports the keyboard
  // visible. Held until keyboard-down so ClearFormControls won't free this
  // control inline during the slide-up window (the Transfer/1Voucher/Global
  // Airtime mid-bind dispose crash).
  if (Sender is TEdit) or (Sender is TMemo) then
    FImeBoundCtl := TControl(Sender);
  {$ENDIF}
  if Assigned(FOnEnter) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnEnter(Sender, N, V);
  TraceLog('OnEnter after-user-cb');

  // Re-promote to ControlType.Platform — but DEFERRED via ForceQueue.
  //
  // Doing the swap synchronously inside the OnEnter event chain is
  // unsafe: the property setter rebuilds the native presenter, which
  // tears down the very focus state that fired the event. On Sunmi
  // Android 11 this AVs inside SetControlType at presenter offset 0x0C
  // (the cached focus reference is dereferenced while nil). Queuing
  // the swap lets the focus event finish, the IME bind, and only then
  // do we re-spin the presenter to Platform. Belt-and-braces: gen
  // snapshot + still-owned check, same as the OnExit path.
  {$IF defined(ANDROID) or defined(IOS)}
  // Styled inputs don't auto-show the IME from a native onFocusChange
  // (there's no native EditText). Ask FMX's keyboard service to
  // bring up the on-screen keyboard for whichever TControl just
  // gained focus. The KeyboardType set in ApplyHtmlInputAttrsToEdit
  // is read by the IME hint at this point, so numeric / tel / email
  // keyboards still come up correctly.
  //
  // DEFERRED via ForceQueue: calling ShowVirtualKeyboard inline
  // here is a no-op on Sunmi V2s — the OnEnter event fires before
  // the platform finishes binding focus to the Styled TEdit's
  // text-input surface. The IME service queries the focused
  // control, finds it not-yet-active, and silently skips the show.
  // Queuing the call to the main thread runs it AFTER the focus
  // chain settles, so the IME has a valid target to bind to. We
  // also DROP the "Visible in state" guard — the service's state
  // flag goes stale after a programmatic dismiss, and we'd rather
  // re-issue an idempotent show than wrongly skip when the IME is
  // actually down. Capture the sender into a local for the closure.
  if Sender is TControl then
  begin
    var TargetCtl: TControl := TControl(Sender);
    // Never toggle (Hide+Show) — that visibly bounces the IME.
    // Just request Show, idempotently. If the IME is already up,
    // ShowVirtualKeyboard is a no-op and Android re-binds the IME
    // to TargetCtl automatically (the canonical "tap a different
    // input while keyboard up" path). If the IME is down or being
    // dismissed by an in-flight Binder message, we re-fire Show
    // at multiple ticks to outlast the dismiss without anyone
    // observing a flicker — each later Show is a no-op once the
    // first one lands.
    RequestKeyboardShow(TargetCtl);
  end;

  // After the IME is up, the focused input may be below the keyboard.
  // Defer the scroll a tick so any layout settle on Android finishes
  // first. Safe with Styled controls (no presenter chain). COALESCED
  // through the same FScrollAboveKbQueued flag VKStateChangeHandler
  // uses, so a focus-in and the subsequent keyboard-show don't each
  // queue their own scroll (and a burst of focus changes can't pile up).
  if not FScrollAboveKbQueued then
  begin
    FScrollAboveKbQueued := True;
    TThread.ForceQueue(nil,
      procedure
      begin
        FScrollAboveKbQueued := False;
        try
          ScrollFocusedControlAboveKeyboard;
        except
        end;
      end);
  end;
  {$ENDIF}
  TraceLog('OnEnter EXIT (handler complete)');
end;

procedure TTina4HTMLRender.HandleFormControlExit(Sender: TObject);
var
  N, V: string;
  {$IF defined(ANDROID) or defined(IOS)}
  KbSvc: IFMXVirtualKeyboardService;
  {$ENDIF}
begin
  if FDisposingControls then Exit;  // mid-dispose: FFormControls boxes are freed
  TraceLog(Format('OnExit ENTRY sender=%p class=%s',
    [Pointer(Sender), Sender.ClassName]));
  if Assigned(FOnExit) and (Sender is TControl) and
     GetFormControlNameValue(TControl(Sender), N, V) then
    FOnExit(Sender, N, V);

  // Demote the just-defocused edit to ControlType.Styled so the
  // native widget stops rendering above the FMX surface — overlays
  // (side menus, modals) can paint cleanly over it. Deferred via
  // ForceQueue so it runs AFTER the current focus event chain
  // finishes (changing ControlType mid-event tears down the peer
  // while there are live messages and FMX throws). Re-check focus
  // inside the queued action: if a sibling control grabbed focus,
  // skip the demote so the new edit doesn't get stuck Styled.
  {$IF defined(ANDROID) or defined(IOS)}
  // 2026-05-27 DIAG — focus-driven ControlType demote removed
  // entirely. See HandleFormControlEnter comment.
  if False and (Sender is TEdit) and
     (TEdit(Sender).ControlType <> TControlType.Styled) then
  begin
    var EdRef := TEdit(Sender);
    var GenSnap := FFormControlsGen;
    TThread.ForceQueue(nil,
      procedure
      begin
        try
          if (FFormControlsGen <> GenSnap) then Exit; // control disposed
          // Belt-and-braces: only proceed if the renderer still owns
          // this control via FFormControls. A re-entrant code path
          // could remove the control without bumping the gen.
          var StillOwned := False;
          for var Rec in FFormControls do
            if Rec.Control = EdRef then
            begin StillOwned := True; Break; end;
          if not StillOwned then Exit;
          if (not EdRef.IsFocused) and
             (EdRef.ControlType <> TControlType.Styled) then
            EdRef.ControlType := TControlType.Styled;
        except
        end;
      end);
  end
  else if False and (Sender is TMemo) and
          (TMemo(Sender).ControlType <> TControlType.Styled) then
  begin
    var MmRef := TMemo(Sender);
    var GenSnap := FFormControlsGen;
    TThread.ForceQueue(nil,
      procedure
      begin
        try
          if (FFormControlsGen <> GenSnap) then Exit;
          var StillOwned := False;
          for var Rec in FFormControls do
            if Rec.Control = MmRef then
            begin StillOwned := True; Break; end;
          if not StillOwned then Exit;
          if (not MmRef.IsFocused) and
             (MmRef.ControlType <> TControlType.Styled) then
            MmRef.ControlType := TControlType.Styled;
        except
        end;
      end);
  end;
  {$ENDIF}

  // RerenderOnFocus — when enabled, rebuild the entire form-control
  // set if focus has truly left this renderer (i.e. went to a control
  // outside our child tree, e.g. side menu, a button on the host
  // frame, or nil). This dodges the Sunmi Android 11 refocus AV at
  // SetControlType+0x0C: we replace every TEdit + presenter with
  // brand-new instances before the user has a chance to tap back in.
  // Deferred via ForceQueue so the focus event chain finishes first
  // and Screen.FocusControl reflects the new focused control.
  // FPendingRerender prevents reentrancy if multiple OnExit fires
  // collapse onto the same queue tick.
  if FRerenderOnFocus and (not FPendingRerender) then
  begin
    FPendingRerender := True;
    TraceLog('OnExit queueing rerender-on-focus check');
    TThread.ForceQueue(nil,
      procedure
      var
        FocusedNow: TControl;
        StillInRenderer: Boolean;
      begin
        try
          FPendingRerender := False;
          FocusedNow := nil;
          if (Screen <> nil) then
            FocusedNow := TControl(Screen.FocusControl);
          // If focus landed on another control that we manage,
          // skip — user just tabbed between fields.
          StillInRenderer := False;
          if Assigned(FocusedNow) then
          begin
            for var Rec in FFormControls do
              if Rec.Control = FocusedNow then
              begin StillInRenderer := True; Break; end;
          end;
          TraceLog(Format('OnExit deferred check focusedNow=%p stillIn=%s',
            [Pointer(FocusedNow), BoolToStr(StillInRenderer, True)]));
          if StillInRenderer then Exit;
          // Focus has left the renderer — rebuild.
          RebuildFormControlsPreservingValues;
        except
          on E: Exception do
            TraceLog('OnExit deferred rerender EXCEPT: ' + E.ClassName +
              ' ' + E.Message);
        end;
      end);
  end;

  // Hide the VK when focus leaves an input and isn't landing on
  // another form control. Without this, tapping outside the render
  // leaves a stranded keyboard on Android.
  {$IF defined(ANDROID) or defined(IOS)}
  if TPlatformServices.Current.SupportsPlatformService(
       IFMXVirtualKeyboardService, IInterface(KbSvc)) and (KbSvc <> nil) then
  begin
    // Give the next control's OnEnter a chance to run first; if it did,
    // the keyboard is still needed and the service is a no-op.
    TThread.ForceQueue(nil,
      procedure
      var
        Svc: IFMXVirtualKeyboardService;
      begin
        if TPlatformServices.Current.SupportsPlatformService(
             IFMXVirtualKeyboardService, IInterface(Svc)) and (Svc <> nil) then
        begin
          // Only hide if no native control currently has keyboard focus.
          if (TVirtualKeyboardState.Visible in Svc.VirtualKeyBoardState) and
             (Screen <> nil) and (Screen.FocusControl = nil) then
            Svc.HideVirtualKeyboard;
        end;
      end);
  end;
  {$ENDIF}
end;

procedure TTina4HTMLRender.CreateFormControls(Box: TLayoutBox; OffX, OffY: Single);
var
  AbsX, AbsY, CX, CY: Single;
  Ctl: TControl;
  Rec: TNativeFormControl;
  TN, InputType, Placeholder, Val: string;
begin
  if Box.Style.Display = 'none' then
    Exit;

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
      else if InputType = 'file' then
      begin
        // Container layout for "Choose File" button + filename label
        var Container := TLayout.Create(Self);
        Container.HitTest := False;

        var FileBtn := TRectangle.Create(Container);
        FileBtn.Parent := Container;
        FileBtn.Fill.Kind := TBrushKind.Solid;
        FileBtn.Fill.Color := $FFE0E0E0;
        FileBtn.Stroke.Kind := TBrushKind.Solid;
        FileBtn.Stroke.Color := $FFB0B0B0;
        FileBtn.XRadius := 4;
        FileBtn.YRadius := 4;
        FileBtn.Width := 90;
        FileBtn.Align := TAlignLayout.Left;
        FileBtn.HitTest := True;
        FileBtn.Cursor := crHandPoint;
        FileBtn.OnClick := HandleFileInputClick;
        FileBtn.TagString := Box.Tag.GetAttribute('accept', '');

        var BtnLbl := TLabel.Create(FileBtn);
        BtnLbl.Parent := FileBtn;
        BtnLbl.Align := TAlignLayout.Client;
        BtnLbl.Text := 'Choose File';
        BtnLbl.HitTest := False;
        BtnLbl.StyledSettings := BtnLbl.StyledSettings - [TStyledSetting.FontColor,
          TStyledSetting.Size, TStyledSetting.Family];
        BtnLbl.FontColor := TAlphaColors.Black;
        BtnLbl.Font.Size := Box.Style.FontSize;
        BtnLbl.Font.Family := Box.Style.FontFamily;
        BtnLbl.TextSettings.HorzAlign := TTextAlign.Center;

        var FileLbl := TLabel.Create(Container);
        FileLbl.Parent := Container;
        FileLbl.Align := TAlignLayout.Client;
        FileLbl.Text := 'No file chosen';
        FileLbl.HitTest := False;
        FileLbl.StyledSettings := FileLbl.StyledSettings - [TStyledSetting.FontColor,
          TStyledSetting.Size, TStyledSetting.Family];
        FileLbl.FontColor := $FF6C757D;
        FileLbl.Font.Size := Box.Style.FontSize;
        FileLbl.Font.Family := Box.Style.FontFamily;
        FileLbl.Margins.Left := 8;

        Ctl := Container;
      end
      else if (InputType = 'submit') or (InputType = 'button') or (InputType = 'reset') then
      begin
        // Do NOT create native FMX controls for button-type inputs.
        // They are painted on canvas and clicks handled via FClickableRegions.
      end
      else
      begin
        var Ed: TEdit := nil;
        {$IF defined(ANDROID) or defined(IOS)}
        // REUSE the preserved focused control if this is its element (same
        // DOM id). Re-adopting the SAME live TEdit means the Android IME's
        // InputConnection is never broken across this relayout — the fix for
        // the "in-render change disposes the IME-bound input -> next screen
        // crashes" bug. Keep its current Text (what the user has typed) and
        // its already-wired handlers; just clear the reuse slot so it's not
        // double-adopted, and skip ApplyHtmlInputAttrsToEdit (unchanged).
        var ElId: string := '';
        if Assigned(Box.Tag) then ElId := Box.Tag.GetAttribute('id', '');
        if Assigned(FReuseCtl) and (FReuseCtl is TEdit) and (FReuseId <> '') and
           (ElId = FReuseId) then
        begin
          Ed := TEdit(FReuseCtl);
          FReuseCtl := nil;
          FReuseId := '';
        end
        // Otherwise re-adopt any POOLED TEdit with this id (every non-focused
        // input from the previous layout). Same benefit as FReuseCtl, applied to
        // ALL inputs: the native control + its IME binding survive untouched,
        // so nothing churns during a keyboard transition (the compositor-stall
        // fix), and typed text is kept (it's the same live control).
        else if (ElId <> '') and (FReusePool <> nil) then
        begin
          var PooledEd: TControl;
          if FReusePool.TryGetValue(ElId, PooledEd) and (PooledEd is TEdit) then
          begin
            Ed := TEdit(PooledEd);
            FReusePool.Remove(ElId);
            // The reused control keeps its live text by design (no native /
            // IME churn). It is deliberately NOT re-seeded from the new DOM
            // value here: doing a .Text assignment mid-CreateFormControls
            // proved fragile under the relayout stress harness (it fired
            // async work / change handlers against half-built state -> AVs).
            // A host that wants a fresh-screen reset (e.g. DStv on Cancel)
            // clears the field explicitly via SetElementValue after it
            // re-stamps the form — a safe, post-layout path.
          end;
        end;
        {$ENDIF}
        if Ed = nil then
        begin
          Ed := TEdit.Create(Self);
          if InputType = 'password' then Ed.Password := True;
          Ed.TextPrompt := Placeholder;
          if Val <> '' then Ed.Text := Val;
          Ed.OnChange  := HandleFormControlChange;
          Ed.OnEnter   := HandleFormControlEnter;
          Ed.OnExit    := HandleFormControlExit;
          Ed.OnKeyDown := HandleFormControlKeyDown;
          // Translate HTML attributes (type / inputmode / enterkeyhint /
          // autocapitalize / maxlength) into FMX keyboard properties so
          // the mobile soft keyboard comes up with the right layout.
          ApplyHtmlInputAttrsToEdit(Box, Ed);
        end;
        Ctl := Ed;
      end;
    end
    else if TN = 'textarea' then
    begin
      var Mem: TMemo := nil;
      {$IF defined(ANDROID) or defined(IOS)}
      // Re-adopt the focused control, or a pooled TMemo with this id — same
      // no-churn reuse as the TEdit branch above.
      var TaId: string := '';
      if Assigned(Box.Tag) then TaId := Box.Tag.GetAttribute('id', '');
      if Assigned(FReuseCtl) and (FReuseCtl is TMemo) and (FReuseId <> '') and
         (TaId = FReuseId) then
      begin
        Mem := TMemo(FReuseCtl); FReuseCtl := nil; FReuseId := '';
      end
      else if (TaId <> '') and (FReusePool <> nil) then
      begin
        var PooledMem: TControl;
        if FReusePool.TryGetValue(TaId, PooledMem) and (PooledMem is TMemo) then
        begin
          Mem := TMemo(PooledMem);
          FReusePool.Remove(TaId);
        end;
      end;
      {$ENDIF}
      if Mem = nil then
      begin
        Mem := TMemo.Create(Self);
        Mem.OnChange  := HandleFormControlChange;
        Mem.OnEnter   := HandleFormControlEnter;
        Mem.OnExit    := HandleFormControlExit;
        Mem.OnKeyDown := HandleFormControlKeyDown;
      end;
      // TMemo shares keyboard properties with TEdit on mobile. Default
      // to sentence-case + regular alphabet; enterkeyhint still applies
      // even though Enter on a textarea usually inserts a newline.
      //Mem.KeyboardAutoCap := TAutoCapitalizationType.Sentences;
      // ControlType: see the TEdit branch above for full reasoning.
      // Android: stay Styled (the Sunmi V2s Platform-EditText bugs).
      // iOS: Platform — avoids FMX's auto-attached keyboard accessory
      // toolbar (the blue "Done" button TestFlight users were seeing).
      {$IFDEF IOS}
      Mem.ControlType := TControlType.Platform;
      {$ENDIF}
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
      // Do NOT create a native FMX control for <button> elements.
      // They are painted on canvas via CSS styling and clicks are handled
      // via FClickableRegions in MouseUp. Creating a native TRectangle
      // with HitTest=True would intercept touch events and break
      // pan-to-scroll inside scrollable containers.
    end;

    if Assigned(Ctl) then
    begin
      Ctl.Parent := Self;
      // Checkbox/radio use fixed content size — don't inflate with CSS padding
      if (Ctl is TCheckBox) or (Ctl is TRadioButton) then
      begin
        Ctl.Width := Box.ContentWidth;
        Ctl.Height := Box.ContentHeight;
      end
      else
      begin
        Ctl.Width := Max(20, Box.ContentWidth + Box.Style.Padding.Left + Box.Style.Padding.Right);
        Ctl.Height := Max(20, Box.ContentHeight + Box.Style.Padding.Top + Box.Style.Padding.Bottom);
      end;

      // Apply CSS styles via ITextSettings (works for TEdit, TMemo, etc.)
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
      // Get an opRemove callback when this control is freed — by us, by the
      // keyboard-down deferral drain (which RemoveComponent's it off Self), or
      // by any other path — so Notification() can purge the stale FFormControls
      // entry before SetElementValue/FocusElement dereference a freed control.
      Ctl.FreeNotification(Self);
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

  function FindBoxAbsPos(Box, Target: TLayoutBox; OffX, OffY: Single;
    out AX, AY: Single): Boolean;
  var
    AbsX, AbsY, CX, CY: Single;
  begin
    AbsX := OffX + Box.X;
    AbsY := OffY + Box.Y;
    if Box = Target then
    begin
      AX := AbsX;
      AY := AbsY;
      Exit(True);
    end;
    CX := AbsX + Box.ContentLeft;
    CY := AbsY + Box.ContentTop;
    for var C in Box.Children do
      if FindBoxAbsPos(C, Target, CX, CY, AX, AY) then
        Exit(True);
    Result := False;
  end;

var
  AX, AY: Single;
begin
  if not Assigned(FLayoutEngine.Root) then Exit;
  for var I := 0 to FFormControls.Count - 1 do
  begin
    var Rec := FFormControls[I];
    AX := 0;
    AY := 0;
    FindBoxAbsPos(FLayoutEngine.Root, Rec.Box, 0, 0, AX, AY);
    // Checkbox/radio: position at content area (includes negative margin offset)
    if (Rec.Control is TCheckBox) or (Rec.Control is TRadioButton) then
    begin
      Rec.Control.Position.X := AX + Rec.Box.ContentLeft - FScrollX;
      Rec.Control.Position.Y := AY + Rec.Box.ContentTop - FScrollY;
      Rec.Control.Width := Rec.Box.ContentWidth;
      Rec.Control.Height := Rec.Box.ContentHeight;
    end
    else
    begin
      Rec.Control.Position.X := AX - FScrollX;
      Rec.Control.Position.Y := AY - FScrollY;
      Rec.Control.Width := Rec.Box.ContentWidth + Rec.Box.Style.Padding.Left + Rec.Box.Style.Padding.Right;
      Rec.Control.Height := Rec.Box.ContentHeight + Rec.Box.Style.Padding.Top + Rec.Box.Style.Padding.Bottom;
    end;
    Rec.Control.Visible := (Rec.Control.Position.Y + Rec.Control.Height > 0) and
      (Rec.Control.Position.Y < Height);
  end;
end;

procedure TTina4HTMLRender.Paint;
begin
  inherited;
  if Canvas = nil then Exit;
  // Guard against zero-sized control (e.g. during design-time Align changes)
  if (Width < 1) or (Height < 1) then Exit;

  if FNeedRelayout then
    DoLayout;

  FClickableRegions.Clear;

  Canvas.BeginScene;
  try
    // Background
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := TAlphaColors.White;
    Canvas.FillRect(LocalRect, 1.0);

    // Reset the sticky anchors to the viewport edges before each paint
    // pass — they get pushed/popped per scroll container during recursion,
    // so a crash or early-exit could otherwise leave them pointing at a
    // freed box.
    FStickyAnchorY := 0;
    FStickyAnchorX := 0;
    // Bottom/right anchors default to "no clamp" (negative infinity-ish).
    // They get populated only when descending into a scroll container.
    // Sticky elements with `bottom:` / `right:` set outside any scroll
    // container have no meaningful pin target, so we leave them
    // unconstrained on those axes.
    FStickyAnchorBottom := -1e30;
    FStickyAnchorRight  := -1e30;

    // Paint layout tree
    if Assigned(FLayoutEngine.Root) then
      PaintBox(Canvas, FLayoutEngine.Root, -FScrollX, -FScrollY);

    // Box-model overlay — orange margin band, green padding band, blue
    // content outline. Useful for "why is this box 122px instead of 100"
    // diagnoses without firing up a Delphi debugger.
    if FDebugBoxOverlay and Assigned(FLayoutEngine.Root) then
      PaintBoxOverlay(Canvas, FLayoutEngine.Root, -FScrollX, -FScrollY);

    // Scrollbar
    if ScrollBarVisible then
      PaintScrollBar(Canvas);

    // Debug overlay — red dot + info where MouseDown last fired
    if FDebugOverlay and FDebugMouseHit then
    begin
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := TAlphaColors.Red;
      Canvas.FillEllipse(RectF(FDebugLastMouseX - 10, FDebugLastMouseY - 10,
        FDebugLastMouseX + 10, FDebugLastMouseY + 10), 1.0);
      // Show key values as text
      var Info := Format('W=%.0f H=%.0f CH=%.0f VP=%s BOX=%s',
        [Width, Height, FContentHeight,
         BoolToStr(FPanIsViewport, True), BoolToStr(Assigned(FPanBox), True)]);
      var TL := TTextLayoutManager.DefaultTextLayout.Create;
      try
        TL.BeginUpdate;
        TL.Font.Size := 14;
        TL.Font.Family := 'Arial';
        TL.Color := TAlphaColors.Red;
        TL.Text := Info;
        TL.MaxSize := PointF(Width, 30);
        TL.EndUpdate;
        TL.RenderLayout(Canvas);
      finally
        TL.Free;
      end;
    end;
  finally
    Canvas.EndScene;
  end;

  // Position native form controls after painting (accounts for scroll)
  PositionFormControls;
end;

procedure TTina4HTMLRender.PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single;
  AStickyMode: Integer);
var
  AbsX, AbsY, CX, CY: Single;
  IsSticky: Boolean;
  ChildStickyMode: Integer;
begin
  if Box.Style.Display = 'none' then Exit;
  if Box.Style.Visibility = 'hidden' then Exit;

  // Sticky on ANY of the four edges qualifies — `top` (header), `left`
  // (freeze column), `bottom` (sticky tfoot / action bar), `right`
  // (right-side freeze column), or any combination.
  IsSticky := (Box.Style.CSSPosition = 'sticky') and
    ((Box.Style.CSSTop > -9990) or (Box.Style.CSSLeft > -9990) or
     (Box.Style.CSSBottom > -9990) or (Box.Style.CSSRight > -9990));

  // Mode 1 (non-sticky pass): a sticky element and its entire subtree are
  // skipped — they get painted in mode 2 on top of the background pass.
  if (AStickyMode = 1) and IsSticky then Exit;

  // Apply opacity by modifying alpha channels on background and border.
  // Text color keeps full alpha so it remains legible against the faded
  // background (true CSS opacity requires offscreen compositing which
  // FMX canvas does not support directly).
  if Box.Style.Opacity < 1.0 then
  begin
    var OpacityByte := Round(Box.Style.Opacity * 255);
    var BgRec := TAlphaColorRec(Box.Style.BackgroundColor);
    if Box.Style.BackgroundColor <> TAlphaColors.Null then
    begin
      BgRec.A := (BgRec.A * OpacityByte) div 255;
      Box.Style.BackgroundColor := BgRec.Color;
    end;
    for var BSide := 0 to 3 do
    begin
      var BrRec := TAlphaColorRec(Box.Style.BorderColors[BSide]);
      BrRec.A := (BrRec.A * OpacityByte) div 255;
      Box.Style.BorderColors[BSide] := BrRec.Color;
    end;
  end;

  // Skip form control boxes — they are rendered as native FMX controls.
  // <button> and button-type <input> are NOT skipped: they're painted on
  // canvas so they participate in clickable region recording and don't
  // block pan-to-scroll with native HitTest interception.
  if Assigned(Box.Tag) then
  begin
    var PaintTN := Box.Tag.TagName.ToLower;
    if (PaintTN = 'textarea') or (PaintTN = 'select') then
      Exit;
    if PaintTN = 'input' then
    begin
      var PaintIT := Box.Tag.GetAttribute('type', 'text').ToLower;
      if (PaintIT <> 'submit') and (PaintIT <> 'button') and (PaintIT <> 'reset') then
        Exit;
    end;
  end;

  AbsX := OffX + Box.X;
  AbsY := OffY + Box.Y;

  // position: relative — shift the element by top/left (or bottom/right)
  // without removing it from normal flow. Siblings still see it at its
  // pre-shift position; only the painted location changes.
  if Box.Style.CSSPosition = 'relative' then
  begin
    if Box.Style.CSSLeft > -9990 then AbsX := AbsX + Box.Style.CSSLeft
    else if Box.Style.CSSRight > -9990 then AbsX := AbsX - Box.Style.CSSRight;
    if Box.Style.CSSTop > -9990 then AbsY := AbsY + Box.Style.CSSTop
    else if Box.Style.CSSBottom > -9990 then AbsY := AbsY - Box.Style.CSSBottom;
  end;

  // position: fixed — pin to the viewport regardless of any ancestor
  // scroll. The very first PaintBox call shifts by -FScrollX/-FScrollY
  // so we cancel that out by using Box.X/Y directly (which were already
  // resolved against the containing block during LayoutAbsoluteChildren).
  if Box.Style.CSSPosition = 'fixed' then
  begin
    AbsX := Box.X;
    AbsY := Box.Y;
  end;

  // Sticky positioning on all four edges. The element pins to whichever
  // edge of the nearest scroll-ancestor's content area it's declared
  // against:
  //   * `top: N`    — when the box would scroll above the ancestor's
  //                   top edge, hold it at AnchorTop + N
  //   * `bottom: N` — when the box would scroll below the ancestor's
  //                   bottom edge, hold it at AnchorBottom - N - height
  //   * `left: N`   — horizontal mirror of top
  //   * `right: N`  — horizontal mirror of bottom
  // The four axes are independent — sticky corners (top+left), sticky
  // footers (bottom-only), sticky headers (top-only), and sticky
  // freeze-columns (left-only) all work.
  if Box.Style.CSSPosition = 'sticky' then
  begin
    if Box.Style.CSSTop > -9990 then
    begin
      var StickyAnchorY := FStickyAnchorY + Box.Style.CSSTop;
      if AbsY < StickyAnchorY then
        AbsY := StickyAnchorY;
    end;
    if Box.Style.CSSBottom > -9990 then
    begin
      // Pin the bottom edge of the margin box at AnchorBottom - CSSBottom.
      // FStickyAnchorBottom = the scroll-ancestor's content-bottom in abs
      // paint coords. If outside any scroll ancestor it stays at -1e30
      // (effectively no clamp).
      if FStickyAnchorBottom > -1e29 then
      begin
        var BoxBottom := AbsY + Box.MarginBoxHeight;
        var StickyAnchorBottom := FStickyAnchorBottom - Box.Style.CSSBottom;
        if BoxBottom > StickyAnchorBottom then
          AbsY := StickyAnchorBottom - Box.MarginBoxHeight;
      end;
    end;
    if Box.Style.CSSLeft > -9990 then
    begin
      var StickyAnchorX := FStickyAnchorX + Box.Style.CSSLeft;
      if AbsX < StickyAnchorX then
        AbsX := StickyAnchorX;
    end;
    if Box.Style.CSSRight > -9990 then
    begin
      if FStickyAnchorRight > -1e29 then
      begin
        var BoxRight := AbsX + Box.MarginBoxWidth;
        var StickyAnchorRight := FStickyAnchorRight - Box.Style.CSSRight;
        if BoxRight > StickyAnchorRight then
          AbsX := StickyAnchorRight - Box.MarginBoxWidth;
      end;
    end;
  end;

  // Viewport culling
  if (AbsY + Box.MarginBoxHeight < 0) or (AbsY > Height) then Exit;

  // CSS `transform` is paint-only — apply it as a canvas matrix around
  // the box's centre (CSS transform-origin defaults to 50% 50%) and
  // restore at the end. Affects both self-paint and children paint.
  // We rely on the lack of further `Exit` after this point — the
  // closing `end;` of PaintBox is the only return path.
  //
  // Important perf note: we ONLY save/restore the canvas state when a
  // transform is actually present. Per-box save/restore on every paint
  // (one for every <div>) showed up under profiling — and meant every
  // mouse-move-driven repaint did O(N) extra canvas work even though
  // 99% of boxes never have a transform.
  var TransformActive := Box.Style.TransformActive;
  var TransformSaveState: TCanvasSaveState := nil;
  if TransformActive then
    TransformSaveState := Canvas.SaveState;
  try
  if TransformActive then
  begin
    var CTX := AbsX + Box.MarginBoxWidth / 2;
    var CTY := AbsY + Box.MarginBoxHeight / 2;
    var M := Canvas.Matrix;
    M := TMatrix.CreateTranslation(-CTX, -CTY) * M;
    if (Box.Style.TransformScaleX <> 1) or (Box.Style.TransformScaleY <> 1) then
      M := TMatrix.CreateScaling(Box.Style.TransformScaleX, Box.Style.TransformScaleY) * M;
    if Box.Style.TransformRotate <> 0 then
      M := TMatrix.CreateRotation(DegToRad(Box.Style.TransformRotate)) * M;
    M := TMatrix.CreateTranslation(
      CTX + Box.Style.TransformTranslateX,
      CTY + Box.Style.TransformTranslateY) * M;
    Canvas.SetMatrix(M);
  end;

  // Sticky-paint mode gating:
  //   mode 2 (sticky-only pass) paints box content only when this box is
  //   sticky; non-sticky boxes are walked purely to reach sticky descendants.
  //   Mode 0 / 1 always paint self (mode 1 already returned for sticky).
  var ShouldPaintSelf := (AStickyMode <> 2) or IsSticky;

  if ShouldPaintSelf then
  begin
    // Box shadow (painted before background so it appears behind)
    if Box.Style.BoxShadow.Active then
      PaintBoxShadow(Canvas, Box, AbsX, AbsY);

    // Background
    PaintBackground(Canvas, Box, AbsX, AbsY);

    // Border
    PaintBorder(Canvas, Box, AbsX, AbsY);

    // Outline (drawn on top of the border edge; doesn't affect layout)
    PaintOutline(Canvas, Box, AbsX, AbsY);

    // Record clickable regions for elements with onclick attribute or <a> with href
    if Assigned(Box.Tag) and (Box.Tag.TagName <> '#text') and
       ((Box.Tag.GetAttribute('onclick', '') <> '') or
        ((Box.Tag.TagName = 'a') and (Box.Tag.GetAttribute('href', '') <> ''))) then
    begin
      var ML := ResolveAutoMargin(Box.Style.Margin.Left);
      var MT := ResolveAutoMargin(Box.Style.Margin.Top);
      var Region: TClickableRegion;
      Region.Tag := Box.Tag;
      Region.Rect := RectF(
        AbsX + ML,
        AbsY + MT,
        AbsX + ML + Box.Style.BorderWidths.Horz +
          Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right,
        AbsY + MT + Box.Style.BorderWidths.Vert +
          Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom);
      FClickableRegions.Add(Region);
    end;

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
        if Box.Style.BorderWidths.Any then
          PaintTableCellBorders(Canvas, Box, AbsX + Box.ContentLeft, AbsY + Box.ContentTop);
    end;
  end;

  // Mode the recursion uses for *this* box's children. Sticky subtrees
  // paint normally inside themselves (so their text/icons render once).
  ChildStickyMode := AStickyMode;
  if (AStickyMode = 2) and IsSticky then
    ChildStickyMode := 0;

  // Recurse children
  CX := AbsX + Box.ContentLeft;
  CY := AbsY + Box.ContentTop;

  var HasAnyOverflow := (Box.Style.OverflowX <> 'visible') or
                        (Box.Style.OverflowY <> 'visible') or
                        (Box.Style.Overflow = 'hidden') or
                        (Box.Style.Overflow = 'scroll') or
                        (Box.Style.Overflow = 'auto');
  if HasAnyOverflow then
  begin
    // In the outer sticky-only pass we don't recurse into nested scroll
    // containers — each container handles its own sticky descendants
    // internally via the same two-pass below, and we'd otherwise paint
    // them twice (the second time outside this container's clip).
    if (AStickyMode = 2) and (not IsSticky) then Exit;

    // If the box is scrollable (auto/scroll), apply its ScrollX/ScrollY
    // offset to the painting of its children. ClampOwnScroll first, so a
    // relayout that shrinks content doesn't leave the scroll past the end.
    Box.ClampOwnScroll;
    var SaveState := Canvas.SaveState;
    // While painting *inside* this scroll container, sticky descendants
    // anchor to its visible top/left edge (CX, CY) instead of the outer
    // viewport. Save and restore around the recursion so sibling subtrees
    // don't see a stale anchor.
    var SavedAnchorY := FStickyAnchorY;
    var SavedAnchorX := FStickyAnchorX;
    var SavedAnchorBottom := FStickyAnchorBottom;
    var SavedAnchorRight  := FStickyAnchorRight;
    // The sticky anchor is the VISIBLE top/left of the scroll container —
    // i.e. its content-edge clamped to the viewport (0..Width / 0..Height).
    // If the container has scrolled above the viewport top (CY < 0 — which
    // happens when an outer FScrollY moves the whole page up), the visible
    // top of the container is still Y=0, so sticky should pin at the
    // viewport edge. Without this clamp, an outer-scrolling page leaves
    // FStickyAnchorY at -FScrollY and the pin target ends up off-screen,
    // making the sticky element invisible — which is exactly the
    // "sticky header doesn't pin" symptom for body{overflow:auto;
    // height:100%} where percentage height doesn't constrain body and
    // the OUTER render scroll handles overflow.
    if (Box.Style.OverflowY = 'auto') or (Box.Style.OverflowY = 'scroll') or
       (Box.Style.Overflow  = 'auto') or (Box.Style.Overflow  = 'scroll') then
    begin
      FStickyAnchorY      := Max(0, CY);
      FStickyAnchorBottom := Min(Height, CY + Box.ContentHeight);
    end;
    if (Box.Style.OverflowX = 'auto') or (Box.Style.OverflowX = 'scroll') or
       (Box.Style.Overflow  = 'auto') or (Box.Style.Overflow  = 'scroll') then
    begin
      FStickyAnchorX     := Max(0, CX);
      FStickyAnchorRight := Min(Width, CX + Box.ContentWidth);
    end;
    try
      Canvas.IntersectClipRect(RectF(CX, CY, CX + Box.ContentWidth, CY + Box.ContentHeight));
      // Two-pass deep paint when there's a sticky descendant inside this
      // scroll container — pass 1 paints non-sticky, pass 2 paints sticky
      // on top. When the cached HasStickyDescendant flag is False (the
      // common case — most scroll containers contain plain content) we
      // skip the second walk entirely, halving the recursion cost.
      if Box.HasStickyDescendant then
      begin
        for var Child in Box.Children do
          PaintBox(Canvas, Child, CX - Box.ScrollX, CY - Box.ScrollY, 1);
        for var Child in Box.Children do
          PaintBox(Canvas, Child, CX - Box.ScrollX, CY - Box.ScrollY, 2);
      end
      else
      begin
        for var Child in Box.Children do
          PaintBox(Canvas, Child, CX - Box.ScrollX, CY - Box.ScrollY, 0);
      end;

      // text-overflow: ellipsis — paint "..." at right edge when content overflows
      if (Box.Style.TextOverflow = 'ellipsis') and (Box.Style.WhiteSpace = 'nowrap') then
      begin
        // Check if any child overflows
        var ChildOverflows := False;
        for var Child in Box.Children do
          if Child.X + Child.ContentWidth > Box.ContentWidth then
          begin
            ChildOverflows := True;
            Break;
          end;
        if ChildOverflows then
        begin
          var EllipsisLayout := TTextLayoutManager.DefaultTextLayout.Create;
          try
            EllipsisLayout.BeginUpdate;
            EllipsisLayout.Text := '...';
            EllipsisLayout.Font.Family := Box.Style.FontFamily;
            EllipsisLayout.Font.Size := Box.Style.FontSize;
            if Box.Style.Bold then
              EllipsisLayout.Font.Style := [TFontStyle.fsBold];
            EllipsisLayout.Color := Box.Style.Color;
            EllipsisLayout.WordWrap := False;
            var EW := Box.Style.FontSize * 1.5;  // approximate "..." width
            // Paint a background rect to cover clipped text, then the ellipsis
            EllipsisLayout.TopLeft := PointF(CX + Box.ContentWidth - EW, CY);
            EllipsisLayout.MaxSize := PointF(EW, Box.Style.FontSize * Box.Style.LineHeight);
            EllipsisLayout.HorizontalAlign := TTextAlign.Trailing;
            EllipsisLayout.EndUpdate;
            // Paint background to cover text underneath
            Canvas.Fill.Kind := TBrushKind.Solid;
            if Box.Style.BackgroundColor <> TAlphaColors.Null then
              Canvas.Fill.Color := Box.Style.BackgroundColor
            else
              Canvas.Fill.Color := TAlphaColors.White;
            Canvas.FillRect(RectF(CX + Box.ContentWidth - EW, CY,
              CX + Box.ContentWidth, CY + Box.Style.FontSize * Box.Style.LineHeight), 0, 0, [], 1.0);
            EllipsisLayout.RenderLayout(Canvas);
          finally
            EllipsisLayout.Free;
          end;
        end;
      end;
    finally
      Canvas.RestoreState(SaveState);
      FStickyAnchorY := SavedAnchorY;
      FStickyAnchorX := SavedAnchorX;
      FStickyAnchorBottom := SavedAnchorBottom;
      FStickyAnchorRight  := SavedAnchorRight;
    end;
    // Paint scrollbars OUTSIDE the clip so they're always visible regardless
    // of how far the content has been scrolled.
    PaintBoxScrollBars(Canvas, Box, CX, CY);
  end
  else
  begin
    // Non-overflow box: propagate the sticky mode unchanged. Local
    // sticky-last segregation among direct children is still applied for
    // mode 0 (the default outer-viewport case), so a sticky child painted
    // alongside non-sticky siblings stays on top.
    if ChildStickyMode = 0 then
    begin
      // Position-aware segregation only matters when SOMETHING in the
      // subtree is positioned. The common case (vanilla div/span tree)
      // hits a single-pass walk — half the iteration cost.
      if Box.HasPositionedDescendant then
      begin
        // Pass 1: in-flow / static children only.
        for var Child in Box.Children do
        begin
          var P := Child.Style.CSSPosition;
          if (P = '') or (P = 'static') then
            PaintBox(Canvas, Child, CX, CY, 0);
        end;
        // Pass 2: positioned child paints on top — implicit z-index lift.
        for var Child in Box.Children do
        begin
          var P := Child.Style.CSSPosition;
          if (P = 'relative') or (P = 'absolute') or
             (P = 'fixed') or (P = 'sticky') then
            PaintBox(Canvas, Child, CX, CY, 0);
        end;
      end
      else
      begin
        // No positioned children anywhere in subtree — single pass.
        for var Child in Box.Children do
          PaintBox(Canvas, Child, CX, CY, 0);
      end;
    end
    else
    begin
      // Mode 1 / 2: just walk children with the same mode — the gating at
      // the top of PaintBox decides what actually paints.
      for var Child in Box.Children do
        PaintBox(Canvas, Child, CX, CY, ChildStickyMode);
    end;
  end;
  finally
    // Restore the canvas matrix saved before the transform (if any).
    if TransformActive then
      Canvas.RestoreState(TransformSaveState);
  end;
end;

procedure TTina4HTMLRender.GetBoxScrollBarRects(Box: TLayoutBox;
  CX, CY: Single;
  out VTrack, VThumb, HTrack, HThumb: TRectF;
  out HasV, HasH: Boolean);
var
  SB: Single;
  RX, RY: Single;
  VisW, VisH: Single;
  ThumbH, ThumbW, ThumbY, ThumbX: Single;
  RangeY, RangeX: Single;
begin
  SB := FScrollBarWidth;
  HasV := Box.NeedsScrollBarY;
  HasH := Box.NeedsScrollBarX;
  VTrack := TRectF.Empty;
  VThumb := TRectF.Empty;
  HTrack := TRectF.Empty;
  HThumb := TRectF.Empty;

  // Visible viewport reduces by the opposite scrollbar if that one is present.
  VisW := Box.ContentWidth;
  VisH := Box.ContentHeight;
  if HasV then VisW := VisW - SB;
  if HasH then VisH := VisH - SB;
  if VisW < 0 then VisW := 0;
  if VisH < 0 then VisH := 0;

  if HasV then
  begin
    VTrack := RectF(CX + Box.ContentWidth - SB, CY,
                    CX + Box.ContentWidth,
                    CY + VisH);
    RY := Box.ScrollHeight - VisH;
    if RY <= 0 then
    begin
      VThumb := VTrack;
    end
    else
    begin
      ThumbH := Max(20, VisH * (VisH / Box.ScrollHeight));
      if ThumbH > VisH then ThumbH := VisH;
      ThumbY := 0;
      RangeY := VisH - ThumbH;
      if RangeY > 0 then
        ThumbY := (Box.ScrollY / RY) * RangeY;
      VThumb := RectF(VTrack.Left + 2, VTrack.Top + ThumbY,
                      VTrack.Right - 2, VTrack.Top + ThumbY + ThumbH);
    end;
  end;

  if HasH then
  begin
    HTrack := RectF(CX, CY + Box.ContentHeight - SB,
                    CX + VisW,
                    CY + Box.ContentHeight);
    RX := Box.ScrollWidth - VisW;
    if RX <= 0 then
    begin
      HThumb := HTrack;
    end
    else
    begin
      ThumbW := Max(20, VisW * (VisW / Box.ScrollWidth));
      if ThumbW > VisW then ThumbW := VisW;
      ThumbX := 0;
      RangeX := VisW - ThumbW;
      if RangeX > 0 then
        ThumbX := (Box.ScrollX / RX) * RangeX;
      HThumb := RectF(HTrack.Left + ThumbX, HTrack.Top + 2,
                      HTrack.Left + ThumbX + ThumbW, HTrack.Bottom - 2);
    end;
  end;
end;

procedure TTina4HTMLRender.PaintBoxScrollBars(Canvas: TCanvas;
  Box: TLayoutBox; CX, CY: Single);
var
  VTrack, VThumb, HTrack, HThumb: TRectF;
  HasV, HasH: Boolean;
  SB, Op: Single;
begin
  if not FScrollBarsVisible then Exit;
  Op := GetScrollbarOpacity;
  if Op <= 0.001 then Exit;
  GetBoxScrollBarRects(Box, CX, CY, VTrack, VThumb, HTrack, HThumb, HasV, HasH);
  // Seed SB up front. The overlay branch uses SB/2 as the thumb corner radius
  // (W1036 "might not have been initialized") — the corner-fill branch at the
  // bottom reassigns it, but by then the overlay paint has already used a
  // garbage radius from uninitialized stack memory.
  SB := FScrollBarWidth;
  Canvas.Fill.Kind := TBrushKind.Solid;

  if FScrollBarOverlay then
  begin
    // Overlay style: thin thumb only, no track background
    if HasV then
    begin
      Canvas.Fill.Color := $80000000;
      Canvas.FillRect(VThumb, SB / 2, SB / 2, AllCorners, Op);
    end;
    if HasH then
    begin
      Canvas.Fill.Color := $80000000;
      Canvas.FillRect(HThumb, SB / 2, SB / 2, AllCorners, Op);
    end;
  end
  else
  begin
    if HasV then
    begin
      Canvas.Fill.Color := $FFF0F0F0;
      Canvas.FillRect(VTrack, Op);
      Canvas.Fill.Color := $FF999999;
      Canvas.FillRect(VThumb, 4, 4, AllCorners, Op);
    end;
    if HasH then
    begin
      Canvas.Fill.Color := $FFF0F0F0;
      Canvas.FillRect(HTrack, Op);
      Canvas.Fill.Color := $FF999999;
      Canvas.FillRect(HThumb, 4, 4, AllCorners, Op);
    end;
  end;
  // Fill the bottom-right corner square when both bars are showing.
  // SB was seeded at function entry — no re-init needed.
  if HasV and HasH then
  begin
    Canvas.Fill.Color := $FFF0F0F0;
    Canvas.FillRect(RectF(CX + Box.ContentWidth - SB, CY + Box.ContentHeight - SB,
                          CX + Box.ContentWidth, CY + Box.ContentHeight), Op);
  end;
end;

function TTina4HTMLRender.HitTestBoxScrollBar(Box: TLayoutBox; CX, CY: Single;
  HX, HY: Single; out Axis: Integer; out OnThumb: Boolean): Boolean;
var
  VTrack, VThumb, HTrack, HThumb: TRectF;
  HasV, HasH: Boolean;
  P: TPointF;
begin
  Result := False;
  Axis := 0;
  OnThumb := False;
  GetBoxScrollBarRects(Box, CX, CY, VTrack, VThumb, HTrack, HThumb, HasV, HasH);
  P := PointF(HX, HY);
  if HasV and VTrack.Contains(P) then
  begin
    Axis := 1;
    OnThumb := VThumb.Contains(P);
    Exit(True);
  end;
  if HasH and HTrack.Contains(P) then
  begin
    Axis := 2;
    OnThumb := HThumb.Contains(P);
    Exit(True);
  end;
end;

function TTina4HTMLRender.FindScrollableAncestor(HX, HY: Single;
  out OutCX, OutCY: Single): TLayoutBox;

  // Recursive walk: pass in the absolute origin of the parent's content box.
  // At each box we compute its own AbsX/AbsY and check whether the point
  // is inside its padding box; if so, recurse into children (with its
  // content origin) and remember this box as the latest scrollable seen.
  function Walk(Box: TLayoutBox; POffX, POffY: Single;
    ParentScrollX, ParentScrollY: Single): TLayoutBox;
  var
    AbsX, AbsY, CX, CY: Single;
    Left, Top, Right, Bottom: Single;
    Inside: Boolean;
    Deeper: TLayoutBox;
  begin
    Result := nil;
    if not Assigned(Box) then Exit;
    if Box.Style.Display = 'none' then Exit;
    // POffX/POffY already include the parent's scroll translation.
    AbsX := POffX + Box.X - ParentScrollX;
    AbsY := POffY + Box.Y - ParentScrollY;
    // Apply sticky pinning — same logic as PaintBox so hit-test matches paint
    if (Box.Style.CSSPosition = 'sticky') and (Box.Style.CSSTop > -9990) then
      if AbsY < Box.Style.CSSTop then
        AbsY := Box.Style.CSSTop;
    Left := AbsX + Box.ContentLeft;
    Top := AbsY + Box.ContentTop;
    Right := Left + Box.ContentWidth;
    Bottom := Top + Box.ContentHeight;
    Inside := (HX >= Left) and (HX <= Right) and (HY >= Top) and (HY <= Bottom);
    if not Inside then Exit;

    // Remember this box if it's scrollable on either axis.
    if Box.IsScrollableX or Box.IsScrollableY then
    begin
      Result := Box;
      OutCX := Left;
      OutCY := Top;
    end;

    // Recurse into children. When the current box is itself a scroll
    // container we pass its own ScrollX/Y as the "parent" offset for
    // its children (they're translated by the box's current scroll).
    CX := Left;
    CY := Top;
    var UseScrollX: Single := 0;
    var UseScrollY: Single := 0;
    if Box.IsScrollableX then UseScrollX := Box.ScrollX;
    if Box.IsScrollableY then UseScrollY := Box.ScrollY;
    for var Child in Box.Children do
    begin
      Deeper := Walk(Child, CX, CY, UseScrollX, UseScrollY);
      if Assigned(Deeper) then
        Result := Deeper;
    end;
  end;

begin
  Result := nil;
  OutCX := 0;
  OutCY := 0;
  if not Assigned(FLayoutEngine) or not Assigned(FLayoutEngine.Root) then Exit;
  // The viewport's own scroll shifts the whole layout.
  Result := Walk(FLayoutEngine.Root, -FScrollX, -FScrollY, 0, 0);
end;

procedure TTina4HTMLRender.BuildRoundedRectPath(Path: TPathData; const R: TRectF;
  RTL, RTR, RBR, RBL: Single);
var
  W, H, MaxR: Single;
begin
  Path.Clear;
  W := R.Width;
  H := R.Height;
  // Clamp each radius to half of the smaller side
  MaxR := Min(W, H) / 2;
  if RTL < 0 then RTL := 0;
  if RTR < 0 then RTR := 0;
  if RBR < 0 then RBR := 0;
  if RBL < 0 then RBL := 0;
  if RTL > MaxR then RTL := MaxR;
  if RTR > MaxR then RTR := MaxR;
  if RBR > MaxR then RBR := MaxR;
  if RBL > MaxR then RBL := MaxR;

  // Start at top of left edge (after top-left corner)
  Path.MoveTo(PointF(R.Left, R.Top + RTL));

  // Top-left corner arc
  if RTL > 0 then
    Path.AddArc(PointF(R.Left + RTL, R.Top + RTL), PointF(RTL, RTL), 180, 90)
  else
    Path.LineTo(PointF(R.Left, R.Top));

  // Top edge
  Path.LineTo(PointF(R.Right - RTR, R.Top));

  // Top-right corner arc
  if RTR > 0 then
    Path.AddArc(PointF(R.Right - RTR, R.Top + RTR), PointF(RTR, RTR), 270, 90)
  else
    Path.LineTo(PointF(R.Right, R.Top));

  // Right edge
  Path.LineTo(PointF(R.Right, R.Bottom - RBR));

  // Bottom-right corner arc
  if RBR > 0 then
    Path.AddArc(PointF(R.Right - RBR, R.Bottom - RBR), PointF(RBR, RBR), 0, 90)
  else
    Path.LineTo(PointF(R.Right, R.Bottom));

  // Bottom edge
  Path.LineTo(PointF(R.Left + RBL, R.Bottom));

  // Bottom-left corner arc
  if RBL > 0 then
    Path.AddArc(PointF(R.Left + RBL, R.Bottom - RBL), PointF(RBL, RBL), 90, 90)
  else
    Path.LineTo(PointF(R.Left, R.Bottom));

  // Left edge
  Path.LineTo(PointF(R.Left, R.Top + RTL));

  Path.ClosePath;
end;

procedure TTina4HTMLRender.FillRoundedRect(Canvas: TCanvas; const R: TRectF;
  RTL, RTR, RBR, RBL: Single; AOpacity: Single);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    BuildRoundedRectPath(Path, R, RTL, RTR, RBR, RBL);
    Canvas.FillPath(Path, AOpacity);
  finally
    Path.Free;
  end;
end;

procedure TTina4HTMLRender.StrokeRoundedRect(Canvas: TCanvas; const R: TRectF;
  RTL, RTR, RBR, RBL: Single; AOpacity: Single);
var
  Path: TPathData;
begin
  Path := TPathData.Create;
  try
    BuildRoundedRectPath(Path, R, RTL, RTR, RBR, RBL);
    Canvas.DrawPath(Path, AOpacity);
  finally
    Path.Free;
  end;
end;

procedure TTina4HTMLRender.PaintBoxShadow(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT: Single;
  Shadow: TBoxShadow;
  Layers: Integer;
  LayerAlpha: Byte;
  ShadowColor: TAlphaColorRec;
begin
  Shadow := Box.Style.BoxShadow;
  if not Shadow.Active then Exit;
  if Shadow.Inset then Exit;  // inset shadows not supported yet
  // Guard against zero/negative dimensions (e.g. design-time with empty control)
  if (Box.ContentWidth <= 0) or (Box.ContentHeight <= 0) then Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);

  // Base rect (same as border box)
  R := RectF(
    X + ML + Shadow.OffsetX,
    Y + MT + Shadow.OffsetY,
    X + ML + Box.Style.BorderWidths.Horz +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right + Shadow.OffsetX,
    Y + MT + Box.Style.BorderWidths.Vert +
      Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom + Shadow.OffsetY
  );

  // Apply spread (expand the shadow rect)
  if Shadow.SpreadRadius <> 0 then
    R.Inflate(Shadow.SpreadRadius, Shadow.SpreadRadius);

  ShadowColor := TAlphaColorRec(Shadow.Color);
  Canvas.Fill.Kind := TBrushKind.Solid;

  if Shadow.BlurRadius <= 0 then
  begin
    // No blur — paint a single solid rect
    Canvas.Fill.Color := Shadow.Color;
    if Box.Style.MaxCornerRadius > 0 then
    begin
      if Box.Style.HasUniformRadius then
        Canvas.FillRect(R, Box.Style.CornerRadius(0), Box.Style.CornerRadius(0), AllCorners, 1.0)
      else
        FillRoundedRect(Canvas, R,
          Box.Style.CornerRadius(0), Box.Style.CornerRadius(1),
          Box.Style.CornerRadius(2), Box.Style.CornerRadius(3), 1.0);
    end
    else
      Canvas.FillRect(R, 1.0);
  end
  else
  begin
    // Simulate blur with multiple expanding layers of decreasing opacity
    Layers := Round(Shadow.BlurRadius);
    if Layers < 1 then Layers := 1;
    if Layers > 20 then Layers := 20;  // cap for performance
    for var L := Layers downto 0 do
    begin
      var Expand := Shadow.BlurRadius * (L / Layers);
      var LayerRect := R;
      LayerRect.Inflate(Expand, Expand);
      // Alpha decreases for outer layers (gaussian approximation)
      var Frac := 1.0 - (L / (Layers + 1));
      LayerAlpha := Round(ShadowColor.A * Frac / (Layers + 1));
      if LayerAlpha = 0 then Continue;
      var C: TAlphaColorRec;
      C.R := ShadowColor.R;
      C.G := ShadowColor.G;
      C.B := ShadowColor.B;
      C.A := LayerAlpha;
      Canvas.Fill.Color := C.Color;
      if Box.Style.MaxCornerRadius > 0 then
      begin
        if Box.Style.HasUniformRadius then
        begin
          var Rad := Box.Style.CornerRadius(0) + Expand;
          Canvas.FillRect(LayerRect, Rad, Rad, AllCorners, 1.0);
        end
        else
          FillRoundedRect(Canvas, LayerRect,
            Box.Style.CornerRadius(0) + Expand, Box.Style.CornerRadius(1) + Expand,
            Box.Style.CornerRadius(2) + Expand, Box.Style.CornerRadius(3) + Expand, 1.0);
      end
      else
        Canvas.FillRect(LayerRect, 1.0);
    end;
  end;
end;

procedure TTina4HTMLRender.PaintBackground(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT: Single;
  HasBgColor, HasBgImage: Boolean;
begin
  HasBgColor := Box.Style.BackgroundColor <> TAlphaColors.Null;
  HasBgImage := Box.Style.BackgroundImage <> '';
  if (not HasBgColor) and (not HasBgImage) then Exit;

  // Form controls are native FMX controls — skip canvas background
  if Assigned(Box.Tag) and
     (SameText(Box.Tag.TagName, 'input') or
      SameText(Box.Tag.TagName, 'textarea') or SameText(Box.Tag.TagName, 'select')) then
    Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);

  R := RectF(
    X + ML,
    Y + MT,
    X + ML + Box.Style.BorderWidths.Horz +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right,
    Y + MT + Box.Style.BorderWidths.Vert +
      Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom
  );

  // Paint background color
  if HasBgColor then
  begin
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := Box.Style.BackgroundColor;
    if Box.Style.MaxCornerRadius > 0 then
    begin
      if Box.Style.HasUniformRadius then
        Canvas.FillRect(R, Box.Style.CornerRadius(0), Box.Style.CornerRadius(0),
          AllCorners, 1.0)
      else
        FillRoundedRect(Canvas, R,
          Box.Style.CornerRadius(0), Box.Style.CornerRadius(1),
          Box.Style.CornerRadius(2), Box.Style.CornerRadius(3), 1.0);
    end
    else
      Canvas.FillRect(R, 1.0);
  end;

  // Paint linear-gradient (drawn between solid bg-color and image, so the
  // gradient sits over the bg-color and under the image).
  if Box.Style.BgGradientActive then
  begin
    Canvas.Fill.Kind := TBrushKind.Gradient;
    Canvas.Fill.Gradient.Style := TGradientStyle.Linear;
    Canvas.Fill.Gradient.Color  := Box.Style.BgGradientStart;
    Canvas.Fill.Gradient.Color1 := Box.Style.BgGradientEnd;
    // Convert CSS angle (0=top, 90=right, clockwise) to start/stop unit
    // coordinates. CSS `to top` puts the gradient origin at the bottom
    // of the box and ends at the top — i.e. start=bottom, end=top.
    var AngleRad := DegToRad(Box.Style.BgGradientAngle);
    var DX := Sin(AngleRad);
    var DY := -Cos(AngleRad);
    Canvas.Fill.Gradient.StartPosition.X := 0.5 - DX * 0.5;
    Canvas.Fill.Gradient.StartPosition.Y := 0.5 - DY * 0.5;
    Canvas.Fill.Gradient.StopPosition.X  := 0.5 + DX * 0.5;
    Canvas.Fill.Gradient.StopPosition.Y  := 0.5 + DY * 0.5;
    if Box.Style.MaxCornerRadius > 0 then
    begin
      if Box.Style.HasUniformRadius then
        Canvas.FillRect(R, Box.Style.CornerRadius(0), Box.Style.CornerRadius(0),
          AllCorners, 1.0)
      else
        FillRoundedRect(Canvas, R,
          Box.Style.CornerRadius(0), Box.Style.CornerRadius(1),
          Box.Style.CornerRadius(2), Box.Style.CornerRadius(3), 1.0);
    end
    else
      Canvas.FillRect(R, 1.0);
    // Restore solid brush for subsequent fills.
    Canvas.Fill.Kind := TBrushKind.Solid;
  end;

  // Paint background image
  if HasBgImage then
  begin
    // Ensure image is requested (safety net for styles parsed after layout)
    FImageCache.RequestImage(Box.Style.BackgroundImage);
    var Bmp := FImageCache.GetImage(Box.Style.BackgroundImage);
    if Assigned(Bmp) and (Bmp.Width > 0) and (Bmp.Height > 0) then
    begin
      var BoxW := R.Width;
      var BoxH := R.Height;
      var BmpW: Single := Bmp.Width;
      var BmpH: Single := Bmp.Height;
      var SrcRect, DstRect: TRectF;

      // background-position resolution rule (kept inline since Delphi
      // doesn't allow nested function declarations after a `begin`):
      //   value < -1   -> percentage of the slack (Reference - BmpDim)
      //   value >= 0   -> pixel offset

      var SaveState := Canvas.SaveState;
      try
        // Clip to box bounds (respecting border-radius)
        if Box.Style.MaxCornerRadius > 0 then
          Canvas.IntersectClipRect(R)
        else
          Canvas.IntersectClipRect(R);

        if Box.Style.BackgroundSize = 'cover' then
        begin
          var Scale := Max(BoxW / BmpW, BoxH / BmpH);
          var FitW := BoxW / Scale;
          var FitH := BoxH / Scale;
          // Position the SOURCE crop. Default centred (50% / 50%); top-left
          // and bottom-right keywords shift the crop window.
          var SrcX: Single := (BmpW - FitW) / 2;
          var SrcY: Single := (BmpH - FitH) / 2;
          if Box.Style.BgPosX < -1 then
            SrcX := -Box.Style.BgPosX / 100 * (BmpW - FitW);
          if Box.Style.BgPosY < -1 then
            SrcY := -Box.Style.BgPosY / 100 * (BmpH - FitH);
          SrcRect := RectF(SrcX, SrcY, SrcX + FitW, SrcY + FitH);
          DstRect := R;
          Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
        end
        else if Box.Style.BackgroundSize = 'contain' then
        begin
          var Scale := Min(BoxW / BmpW, BoxH / BmpH);
          var FitW := BmpW * Scale;
          var FitH := BmpH * Scale;
          var DstX: Single := R.Left;
          var DstY: Single := R.Top;
          if Box.Style.BgPosX < -1 then DstX := DstX + (-Box.Style.BgPosX / 100) * (BoxW - FitW)
          else if Box.Style.BgPosX > 0 then DstX := DstX + Box.Style.BgPosX
          else DstX := DstX + (BoxW - FitW) / 2;  // default centre
          if Box.Style.BgPosY < -1 then DstY := DstY + (-Box.Style.BgPosY / 100) * (BoxH - FitH)
          else if Box.Style.BgPosY > 0 then DstY := DstY + Box.Style.BgPosY
          else DstY := DstY + (BoxH - FitH) / 2;
          SrcRect := RectF(0, 0, BmpW, BmpH);
          DstRect := RectF(DstX, DstY, DstX + FitW, DstY + FitH);
          Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
        end
        else if (Box.Style.BgRepeat = 'repeat') or
                (Box.Style.BgRepeat = 'repeat-x') or
                (Box.Style.BgRepeat = 'repeat-y') then
        begin
          // Tile the image at its natural size across the box. Origin is
          // bg-position (default 0,0 = top-left). Skip the other axis if
          // repeat-x or repeat-y restricts it.
          var OrigX: Single := R.Left;
          var OrigY: Single := R.Top;
          if Box.Style.BgPosX < -1 then OrigX := OrigX + (-Box.Style.BgPosX / 100) * (BoxW - BmpW)
          else if Box.Style.BgPosX > 0 then OrigX := OrigX + Box.Style.BgPosX;
          if Box.Style.BgPosY < -1 then OrigY := OrigY + (-Box.Style.BgPosY / 100) * (BoxH - BmpH)
          else if Box.Style.BgPosY > 0 then OrigY := OrigY + Box.Style.BgPosY;
          // Walk back so we cover the box from its top-left edge.
          while OrigX > R.Left do OrigX := OrigX - BmpW;
          while OrigY > R.Top do OrigY := OrigY - BmpH;
          var TileX := OrigX;
          while TileX < R.Right do
          begin
            var TileY := OrigY;
            while TileY < R.Bottom do
            begin
              SrcRect := RectF(0, 0, BmpW, BmpH);
              DstRect := RectF(TileX, TileY, TileX + BmpW, TileY + BmpH);
              Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
              if Box.Style.BgRepeat = 'repeat-x' then Break;
              TileY := TileY + BmpH;
            end;
            if Box.Style.BgRepeat = 'repeat-y' then Break;
            TileX := TileX + BmpW;
          end;
        end
        else
        begin
          // 'auto' or explicit — stretch to fill
          SrcRect := RectF(0, 0, BmpW, BmpH);
          DstRect := R;
          Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
        end;
      finally
        Canvas.RestoreState(SaveState);
      end;
    end;
  end;
end;

procedure TTina4HTMLRender.PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT: Single;
begin
  if not Box.Style.BorderWidths.Any then Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);

  // For blockquote-style left border only
  if Assigned(Box.Tag) and SameText(Box.Tag.TagName, 'blockquote') then
  begin
    var LX := X + ML;
    var TY := Y + MT;
    var BY := TY + Box.Style.BorderWidths.Vert + Box.Style.Padding.Top +
      Box.ContentHeight + Box.Style.Padding.Bottom;
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := Box.Style.BorderColors[3];
    Canvas.Stroke.Thickness := Box.Style.BorderWidths.Left;
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

  // General border — draw per-side
  var BW := Box.Style.BorderWidths;
  var AllSame := (BW.Top = BW.Right) and (BW.Right = BW.Bottom) and (BW.Bottom = BW.Left);

  if AllSame and (BW.Top > 0) and (Box.Style.MaxCornerRadius > 0) then
  begin
    // Uniform border with radius — use DrawRect for rounded corners
    R := RectF(
      X + ML + BW.Left / 2,
      Y + MT + BW.Top / 2,
      X + ML + BW.Horz + Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right - BW.Right / 2,
      Y + MT + BW.Vert + Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom - BW.Bottom / 2
    );
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := Box.Style.BorderColors[0];
    Canvas.Stroke.Thickness := BW.Top;
    if Box.Style.HasUniformRadius then
      Canvas.DrawRect(R, Box.Style.CornerRadius(0), Box.Style.CornerRadius(0), AllCorners, 1.0)
    else
      StrokeRoundedRect(Canvas, R,
        Box.Style.CornerRadius(0), Box.Style.CornerRadius(1),
        Box.Style.CornerRadius(2), Box.Style.CornerRadius(3), 1.0);
  end
  else
  begin
    // Per-side borders — draw individual lines
    var LX := X + ML;
    var TY := Y + MT;
    var RX := LX + BW.Horz + Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right;
    var BY := TY + BW.Vert + Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom;
    Canvas.Stroke.Kind := TBrushKind.Solid;

    // Top border
    if BW.Top > 0 then
    begin
      Canvas.Stroke.Color := Box.Style.BorderColors[0];
      Canvas.Stroke.Thickness := BW.Top;
      Canvas.DrawLine(PointF(LX, TY + BW.Top / 2), PointF(RX, TY + BW.Top / 2), 1.0);
    end;
    // Right border
    if BW.Right > 0 then
    begin
      Canvas.Stroke.Color := Box.Style.BorderColors[1];
      Canvas.Stroke.Thickness := BW.Right;
      Canvas.DrawLine(PointF(RX - BW.Right / 2, TY), PointF(RX - BW.Right / 2, BY), 1.0);
    end;
    // Bottom border
    if BW.Bottom > 0 then
    begin
      Canvas.Stroke.Color := Box.Style.BorderColors[2];
      Canvas.Stroke.Thickness := BW.Bottom;
      Canvas.DrawLine(PointF(LX, BY - BW.Bottom / 2), PointF(RX, BY - BW.Bottom / 2), 1.0);
    end;
    // Left border
    if BW.Left > 0 then
    begin
      Canvas.Stroke.Color := Box.Style.BorderColors[3];
      Canvas.Stroke.Thickness := BW.Left;
      Canvas.DrawLine(PointF(LX + BW.Left / 2, TY), PointF(LX + BW.Left / 2, BY), 1.0);
    end;
  end;
end;

procedure TTina4HTMLRender.PaintBoxOverlay(Canvas: TCanvas; Box: TLayoutBox;
  OffX, OffY: Single);
// Translucent box-model overlay. Walks the same tree as PaintBox but paints
// only diagnostic strokes. Margin = orange band, padding = green band,
// content = thin blue rectangle. Skips display:none and zero-size boxes.
var
  AbsX, AbsY: Single;
  ML, MT: Single;
  BorderL, BorderT, BorderR, BorderB: Single;
  PadL, PadT, PadR, PadB: Single;
  CW, CH: Single;
begin
  if Box.Style.Display = 'none' then Exit;
  if Box.Style.Visibility = 'hidden' then Exit;

  AbsX := OffX + Box.X;
  AbsY := OffY + Box.Y;
  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);
  BorderL := Box.Style.BorderWidths.Left;
  BorderT := Box.Style.BorderWidths.Top;
  BorderR := Box.Style.BorderWidths.Right;
  BorderB := Box.Style.BorderWidths.Bottom;
  PadL := Box.Style.Padding.Left;
  PadT := Box.Style.Padding.Top;
  PadR := Box.Style.Padding.Right;
  PadB := Box.Style.Padding.Bottom;
  CW := Box.ContentWidth;
  CH := Box.ContentHeight;

  if (CW > 0) or (CH > 0) then
  begin
    // Margin band — orange, very translucent
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := $30FFA500;  // alpha=0x30 over orange
    Canvas.FillRect(RectF(AbsX, AbsY,
      AbsX + ML + BorderL + PadL + CW + PadR + BorderR + ResolveAutoMargin(Box.Style.Margin.Right),
      AbsY + MT + BorderT + PadT + CH + PadB + BorderB + ResolveAutoMargin(Box.Style.Margin.Bottom)),
      1.0);

    // Padding band — green
    Canvas.Fill.Color := $3000FF00;
    Canvas.FillRect(RectF(
      AbsX + ML + BorderL,
      AbsY + MT + BorderT,
      AbsX + ML + BorderL + PadL + CW + PadR,
      AbsY + MT + BorderT + PadT + CH + PadB), 1.0);

    // Content outline — solid blue 1px stroke
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColors.Blue;
    Canvas.Stroke.Thickness := 1;
    Canvas.Stroke.Dash := TStrokeDash.Solid;
    Canvas.DrawRect(RectF(
      AbsX + ML + BorderL + PadL,
      AbsY + MT + BorderT + PadT,
      AbsX + ML + BorderL + PadL + CW,
      AbsY + MT + BorderT + PadT + CH), 0, 0, AllCorners, 1.0);
  end;

  // Recurse into children, applying scroll offsets the same way PaintBox does.
  var CX := AbsX + Box.ContentLeft;
  var CY := AbsY + Box.ContentTop;
  var ScrX: Single := 0; var ScrY: Single := 0;
  if (Box.Style.OverflowY = 'auto') or (Box.Style.OverflowY = 'scroll') or
     (Box.Style.Overflow  = 'auto') or (Box.Style.Overflow  = 'scroll') then
  begin
    ScrX := Box.ScrollX; ScrY := Box.ScrollY;
  end;
  for var Child in Box.Children do
    PaintBoxOverlay(Canvas, Child, CX - ScrX, CY - ScrY);
end;

procedure TTina4HTMLRender.PaintOutline(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  ML, MT, OW, OO: Single;
  BW: TEdgeValues;
  RT, RB: Single;
begin
  OW := Box.Style.OutlineWidth;
  if (OW <= 0) or (Box.Style.OutlineStyle = 'none') then Exit;
  if Box.Style.OutlineColor = TAlphaColors.Null then Exit;

  ML := ResolveAutoMargin(Box.Style.Margin.Left);
  MT := ResolveAutoMargin(Box.Style.Margin.Top);
  BW := Box.Style.BorderWidths;
  OO := Box.Style.OutlineOffset;

  // Outline sits on the border-box edge, expanded outward by OutlineOffset
  // (positive = away from the box, negative = inward — pulls the outline
  // inside the border for status indicators on rounded cards).
  R := RectF(
    X + ML - OO,
    Y + MT - OO,
    X + ML + BW.Horz + Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right + OO,
    Y + MT + BW.Vert + Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom + OO
  );
  // Inflate by half the outline width so DrawRect's centred stroke ends up
  // flush against the desired edge (matches PaintBorder convention).
  R.Inflate(-OW / 2, -OW / 2);

  // Negative offset can collapse the rectangle — bail rather than draw garbage.
  if (R.Width <= 0) or (R.Height <= 0) then Exit;

  Canvas.Stroke.Kind := TBrushKind.Solid;
  if Box.Style.OutlineStyle = 'dashed' then
    Canvas.Stroke.Dash := TStrokeDash.Dash
  else if Box.Style.OutlineStyle = 'dotted' then
    Canvas.Stroke.Dash := TStrokeDash.Dot
  else
    Canvas.Stroke.Dash := TStrokeDash.Solid;
  Canvas.Stroke.Color := Box.Style.OutlineColor;
  Canvas.Stroke.Thickness := OW;

  // Outlines follow the border-radius. With negative offset (inset look) the
  // effective radius shrinks by the offset; with positive offset it grows.
  if Box.Style.HasUniformRadius and (Box.Style.CornerRadius(0) > 0) then
  begin
    RT := Box.Style.CornerRadius(0) - OO;
    if RT < 0 then RT := 0;
    Canvas.DrawRect(R, RT, RT, AllCorners, 1.0);
  end
  else if Box.Style.MaxCornerRadius > 0 then
  begin
    // Per-corner radii — shrink each by the offset. PaintBorder uses the
    // same StrokeRoundedRect helper so behaviour matches.
    RT := Box.Style.CornerRadius(0) - OO;  if RT < 0 then RT := 0;
    var RTR := Box.Style.CornerRadius(1) - OO; if RTR < 0 then RTR := 0;
    var RBR := Box.Style.CornerRadius(2) - OO; if RBR < 0 then RBR := 0;
    RB := Box.Style.CornerRadius(3) - OO;  if RB < 0 then RB := 0;
    StrokeRoundedRect(Canvas, R, RT, RTR, RBR, RB, 1.0);
  end
  else
  begin
    Canvas.DrawRect(R, 0, 0, AllCorners, 1.0);
  end;
  // Restore solid for any subsequent stroke users.
  Canvas.Stroke.Dash := TStrokeDash.Solid;
end;

function TTina4HTMLRender.GetPaintLayout: TTextLayout;
// Lazy-create-and-reuse the paint TTextLayout. Mirrors the engine's
// FMeasureLayout pattern. Callers must reconfigure via BeginUpdate /
// EndUpdate — properties carry over. Constructing TTextLayout is the
// single most expensive step in paint when many text fragments are
// drawn (every fragment, every tile, every paint pass).
begin
  if not Assigned(FPaintLayout) then
    FPaintLayout := TTextLayoutManager.DefaultTextLayout.Create;
  Result := FPaintLayout;
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

  // Hoist the pooled paint layout once for the whole fragment list.
  // Shadow + main use the same instance — they're sequential per fragment.
  Layout := GetPaintLayout;
  for var I := 0 to Box.Fragments.Count - 1 do
  begin
    Frag := Box.Fragments[I];

    begin  // (former try block kept as bare block — no allocation to free)
      if (Box.Style.LetterSpacing <> 0) and (Frag.Text.Length > 1) then
      begin
        // Render character-by-character with spacing
        var CharX := X + Box.ContentLeft + Frag.X;
        for var CI := 1 to Frag.Text.Length do
        begin
          Layout.BeginUpdate;
          Layout.Text := string(Frag.Text[CI]);
          Layout.Font.Family := Box.Style.FontFamily;
          Layout.Font.Size := Box.Style.FontSize;
          Layout.Font.Style := FontStyles;
          Layout.Color := Box.Style.Color;
          Layout.WordWrap := False;
          Layout.HorizontalAlign := TTextAlign.Leading;
          Layout.VerticalAlign := TTextAlign.Leading;
          Layout.MaxSize := PointF(Box.Style.FontSize * 2, Frag.H + 2);
          Layout.EndUpdate;
          // Explicit centering — see main paint site below for rationale.
          var TextHc: Single := Layout.TextHeight;
          var YOffc: Single := (Frag.H - TextHc) / 2;
          if YOffc < 0 then YOffc := 0;
          Layout.TopLeft := PointF(CharX,
            Y + Box.ContentTop + Frag.Y + YOffc);
          Layout.RenderLayout(Canvas);
          CharX := CharX + Layout.Width + Box.Style.LetterSpacing;
        end;
      end
      else
      begin
        // Optional text-shadow: paint a tinted, offset copy of the text
        // BEFORE the main layer so the regular colour sits on top. We
        // approximate the CSS blur with a "ring" of repeats (4 cardinal
        // directions, opacity proportional to blur radius) — enough for
        // legibility on busy backgrounds without a full Gaussian. Uses
        // the same pooled Layout — we render the shadow first, then
        // reconfigure for the main pass below.
        if Box.Style.TextShadowActive then
        begin
          Layout.BeginUpdate;
          Layout.Text := Frag.Text;
          Layout.Font.Family := Box.Style.FontFamily;
          Layout.Font.Size := Box.Style.FontSize;
          Layout.Font.Style := FontStyles;
          Layout.Color := Box.Style.TextShadowColor;
          Layout.WordWrap := Box.Style.WhiteSpace <> 'pre';
          Layout.HorizontalAlign := TTextAlign.Leading;
          Layout.VerticalAlign := TTextAlign.Leading;
          Layout.MaxSize := PointF(Frag.W + 2, Frag.H + 2);
          Layout.EndUpdate;
          // Explicit centering — see main paint site below for rationale.
          var TextHs: Single := Layout.TextHeight;
          var YOffs: Single := (Frag.H - TextHs) / 2;
          if YOffs < 0 then YOffs := 0;
          Layout.TopLeft := PointF(
            X + Box.ContentLeft + Frag.X + Box.Style.TextShadowOffsetX,
            Y + Box.ContentTop  + Frag.Y + Box.Style.TextShadowOffsetY
              + YOffs);
          Layout.RenderLayout(Canvas);
        end;

        Layout.BeginUpdate;
        Layout.Text := Frag.Text;
        Layout.Font.Family := Box.Style.FontFamily;
        Layout.Font.Size := Box.Style.FontSize;
        Layout.Font.Style := FontStyles;
        Layout.Color := Box.Style.Color;
        Layout.WordWrap := Box.Style.WhiteSpace <> 'pre';
        Layout.HorizontalAlign := TTextAlign.Leading;
        // Explicit centering: paint at the top of the line box,
        // measure the actual text height after EndUpdate, then shift
        // TopLeft.Y by (LineBoxH - TextH) / 2 to put the text bbox
        // dead-center vertically. This bypasses FMX's opaque
        // VerticalAlign := Center (which depends on what FMX
        // internally considers the text bbox) and gives pixel-exact
        // control over where the glyph ends up.
        Layout.VerticalAlign := TTextAlign.Leading;
        Layout.MaxSize := PointF(Frag.W + 2, Frag.H + 2);
        Layout.EndUpdate;
        var TextH: Single := Layout.TextHeight;
        var YCenterOffset: Single := (Frag.H - TextH) / 2;
        if YCenterOffset < 0 then YCenterOffset := 0;
        Layout.TopLeft := PointF(X + Box.ContentLeft + Frag.X,
                                 Y + Box.ContentTop + Frag.Y + YCenterOffset);
        Layout.RenderLayout(Canvas);
      end;

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
    end;  // (former finally Layout.Free was here — Layout is pooled now)
  end;
end;

procedure TTina4HTMLRender.PaintImage(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  Bmp: TBitmap;
  SrcRect, DstRect: TRectF;
  BmpW, BmpH, BoxW, BoxH: Single;
  ScaleX, ScaleY, Scale: Single;
  FitW, FitH: Single;
begin
  if not Assigned(Box.Tag) then Exit;
  var Src := Box.Tag.GetAttribute('src');

  Bmp := FImageCache.GetImage(Src);
  if Assigned(Bmp) then
  begin
    BmpW := Bmp.Width;
    BmpH := Bmp.Height;
    BoxW := Box.ContentWidth;
    BoxH := Box.ContentHeight;

    if (BmpW <= 0) or (BmpH <= 0) or (BoxW <= 0) or (BoxH <= 0) then Exit;

    // BELT-AND-BRACES CLAMP: enforce the CSS-declared / HTML-attribute
    // dimensions at paint time, regardless of what Box.ContentWidth/Height
    // ended up at. This protects against any layout-side path where a
    // <img>'s explicit width/height didn't make it into ContentWidth (eg
    // a code path that doesn't read max-width, or an upstream cache that
    // held a pre-bitmap-load dimension). If we have an ExplicitWidth/Height
    // on the style, that's an absolute upper bound; same for MaxWidth/
    // MaxHeight. The image will paint into the SMALLER box even if the
    // layout box reports something larger.
    if (Box.Style.ExplicitWidth > 0) and (BoxW > Box.Style.ExplicitWidth) then
      BoxW := Box.Style.ExplicitWidth;
    if (Box.Style.ExplicitHeight > 0) and (BoxH > Box.Style.ExplicitHeight) then
      BoxH := Box.Style.ExplicitHeight;
    if (Box.Style.MaxWidth >= 0) and (BoxW > Box.Style.MaxWidth) then
      BoxW := Box.Style.MaxWidth;
    if (Box.Style.MaxHeight >= 0) and (BoxH > Box.Style.MaxHeight) then
      BoxH := Box.Style.MaxHeight;

    if Box.Style.ObjectFit = 'cover' then
    begin
      // Scale to cover the entire box, crop overflow
      ScaleX := BoxW / BmpW;
      ScaleY := BoxH / BmpH;
      Scale := Max(ScaleX, ScaleY);
      FitW := BoxW / Scale;
      FitH := BoxH / Scale;
      // Center the crop within the source image
      SrcRect := RectF((BmpW - FitW) / 2, (BmpH - FitH) / 2,
                        (BmpW + FitW) / 2, (BmpH + FitH) / 2);
      DstRect := RectF(X, Y, X + BoxW, Y + BoxH);
      // Clip to box bounds to prevent bleed
      var SaveState := Canvas.SaveState;
      try
        Canvas.IntersectClipRect(DstRect);
        Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
      finally
        Canvas.RestoreState(SaveState);
      end;
    end
    else if Box.Style.ObjectFit = 'contain' then
    begin
      // Scale to fit inside the box, preserving aspect ratio
      ScaleX := BoxW / BmpW;
      ScaleY := BoxH / BmpH;
      Scale := Min(ScaleX, ScaleY);
      FitW := BmpW * Scale;
      FitH := BmpH * Scale;
      DstRect := RectF(X + (BoxW - FitW) / 2, Y + (BoxH - FitH) / 2,
                        X + (BoxW + FitW) / 2, Y + (BoxH + FitH) / 2);
      SrcRect := RectF(0, 0, BmpW, BmpH);
      Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
    end
    else if Box.Style.ObjectFit = 'none' then
    begin
      // Original size, centered, no scaling
      DstRect := RectF(X + (BoxW - BmpW) / 2, Y + (BoxH - BmpH) / 2,
                        X + (BoxW + BmpW) / 2, Y + (BoxH + BmpH) / 2);
      SrcRect := RectF(0, 0, BmpW, BmpH);
      var SaveState := Canvas.SaveState;
      try
        Canvas.IntersectClipRect(RectF(X, Y, X + BoxW, Y + BoxH));
        Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
      finally
        Canvas.RestoreState(SaveState);
      end;
    end
    else if Box.Style.ObjectFit = 'scale-down' then
    begin
      // Like contain but never enlarges
      ScaleX := BoxW / BmpW;
      ScaleY := BoxH / BmpH;
      Scale := Min(ScaleX, ScaleY);
      if Scale > 1 then Scale := 1; // never enlarge
      FitW := BmpW * Scale;
      FitH := BmpH * Scale;
      DstRect := RectF(X + (BoxW - FitW) / 2, Y + (BoxH - FitH) / 2,
                        X + (BoxW + FitW) / 2, Y + (BoxH + FitH) / 2);
      SrcRect := RectF(0, 0, BmpW, BmpH);
      Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
    end
    else
    begin
      // 'fill' (default): stretch to fill the box
      SrcRect := RectF(0, 0, BmpW, BmpH);
      DstRect := RectF(X, Y, X + BoxW, Y + BoxH);
      Canvas.DrawBitmap(Bmp, SrcRect, DstRect, 1.0);
    end;
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
  LST: string;

  function ToRoman(N: Integer): string;
  const
    Values: array[0..12] of Integer = (1000,900,500,400,100,90,50,40,10,9,5,4,1);
    Numerals: array[0..12] of string = ('m','cm','d','cd','c','xc','l','xl','x','ix','v','iv','i');
  var
    I: Integer;
  begin
    Result := '';
    for I := 0 to High(Values) do
      while N >= Values[I] do
      begin
        Result := Result + Numerals[I];
        Dec(N, Values[I]);
      end;
  end;

begin
  MarkerY := Y + Box.ContentTop;
  LineH := Box.Style.FontSize * Box.Style.LineHeight;

  LST := Box.Style.ListStyleType;
  if LST = 'none' then Exit;

  // Determine marker text for ordered types
  if (LST = 'decimal') or (LST = 'lower-alpha') or (LST = 'upper-alpha') or
     (LST = 'lower-roman') or (LST = 'upper-roman') or Box.IsOrdered then
  begin
    if (LST = 'lower-alpha') and (Box.ListIndex >= 1) and (Box.ListIndex <= 26) then
      MarkerText := Chr(Ord('a') + Box.ListIndex - 1) + '.'
    else if (LST = 'upper-alpha') and (Box.ListIndex >= 1) and (Box.ListIndex <= 26) then
      MarkerText := Chr(Ord('A') + Box.ListIndex - 1) + '.'
    else if LST = 'lower-roman' then
      MarkerText := ToRoman(Box.ListIndex) + '.'
    else if LST = 'upper-roman' then
      MarkerText := ToRoman(Box.ListIndex).ToUpper + '.'
    else
      MarkerText := IntToStr(Box.ListIndex) + '.';

    Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      var MarkerW: Single := 20;
      // Measure the actual marker text width so the box is large enough
      Layout.BeginUpdate;
      Layout.Text := MarkerText;
      Layout.Font.Family := Box.Style.FontFamily;
      Layout.Font.Size := Box.Style.FontSize;
      Layout.WordWrap := False;
      Layout.MaxSize := PointF(200, LineH);
      Layout.EndUpdate;
      if Layout.Width + 2 > MarkerW then
        MarkerW := Layout.Width + 2;

      Layout.BeginUpdate;
      Layout.Text := MarkerText;
      Layout.Font.Family := Box.Style.FontFamily;
      Layout.Font.Size := Box.Style.FontSize;
      Layout.Color := Box.Style.Color;
      Layout.HorizontalAlign := TTextAlign.Trailing;
      // Position so right edge is at ContentLeft - 4px gap
      Layout.TopLeft := PointF(X + Box.ContentLeft - MarkerW - 4, MarkerY);
      Layout.MaxSize := PointF(MarkerW, LineH);
      Layout.EndUpdate;
      Layout.RenderLayout(Canvas);
    finally
      Layout.Free;
    end;
  end
  else
  begin
    // Draw bullet markers — center in the padding area left of content
    BulletR := Box.Style.FontSize * 0.18;
    if BulletR < 2.5 then BulletR := 2.5;
    BulletCX := X + Box.ContentLeft - BulletR - 6;
    BulletCY := MarkerY + LineH * 0.5;

    if LST = 'square' then
    begin
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := Box.Style.Color;
      Canvas.FillRect(RectF(BulletCX - BulletR, BulletCY - BulletR,
        BulletCX + BulletR, BulletCY + BulletR), 0, 0, [], 1.0);
    end
    else if LST = 'circle' then
    begin
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := Box.Style.Color;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawEllipse(RectF(BulletCX - BulletR, BulletCY - BulletR,
        BulletCX + BulletR, BulletCY + BulletR), 1.0);
    end
    else // disc (default)
    begin
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := Box.Style.Color;
      Canvas.FillEllipse(RectF(BulletCX - BulletR, BulletCY - BulletR,
        BulletCX + BulletR, BulletCY + BulletR), 1.0);
    end;
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
  BW := Box.Style.BorderWidths.Top;
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
  Ratio, ThumbH, ThumbY, Op: Single;
begin
  if not FScrollBarsVisible then Exit;
  if FContentHeight <= Height then Exit;
  Op := GetScrollbarOpacity;
  if Op <= 0.001 then Exit;

  Ratio := Height / FContentHeight;
  ThumbH := Max(20, Height * Ratio);
  ThumbY := (FScrollY / (FContentHeight - Height)) * (Height - ThumbH);

  Canvas.Fill.Kind := TBrushKind.Solid;

  if FScrollBarOverlay then
  begin
    // Overlay style: thin rounded thumb, no track background
    ThumbRect := RectF(Width - FScrollBarWidth, ThumbY,
      Width, ThumbY + ThumbH);
    Canvas.Fill.Color := $80000000;  // semi-transparent black
    Canvas.FillRect(ThumbRect, FScrollBarWidth / 2, FScrollBarWidth / 2, AllCorners, Op);
  end
  else
  begin
    // Classic style: track background + thumb
    TrackRect := RectF(Width - FScrollBarWidth, 0, Width, Height);
    ThumbRect := RectF(Width - FScrollBarWidth + 2, ThumbY,
      Width - 2, ThumbY + ThumbH);
    Canvas.Fill.Color := $FFF0F0F0;
    Canvas.FillRect(TrackRect, Op);
    Canvas.Fill.Color := $FF999999;
    Canvas.FillRect(ThumbRect, 4, 4, AllCorners, Op);
  end;
end;

procedure TTina4HTMLRender.MouseWheel(Shift: TShiftState; WheelDelta: Integer;
  var Handled: Boolean);
var
  Target: TLayoutBox;
  Horizontal: Boolean;
  Delta: Single;
begin
  Horizontal := ssShift in Shift;
  Delta := -WheelDelta;
  // Prefer the box currently under the mouse if it's scrollable on the
  // requested axis — this is what browsers do. Fall back to the viewport.
  Target := FHoverScrollBox;
  if Assigned(Target) then
  begin
    if Horizontal then
    begin
      if Target.IsScrollableX and (Target.ScrollWidth > Target.ContentWidth + 0.5) then
      begin
        Target.ScrollX := Target.ScrollX + Delta;
        Target.ClampOwnScroll;
        Repaint;
        Handled := True;
        Exit;
      end;
    end
    else
    begin
      if Target.IsScrollableY and (Target.ScrollHeight > Target.ContentHeight + 0.5) then
      begin
        Target.ScrollY := Target.ScrollY + Delta;
        Target.ClampOwnScroll;
        Repaint;
        Handled := True;
        Exit;
      end;
    end;
  end;
  // No inner scrollable consumed the wheel — scroll the viewport.
  if Horizontal then
    SetScrollX(FScrollX + Delta)
  else
    SetScrollY(FScrollY + Delta);
  Handled := True;
end;

function TTina4HTMLRender.ResolveOnClickParam(const Expr: string;
  ClickedTag: THTMLTag): string;

  function FindTagById(Tag: THTMLTag; const Id: string): THTMLTag;
  begin
    Result := nil;
    if not Assigned(Tag) then Exit;
    if SameText(Tag.GetAttribute('id', ''), Id) then
      Exit(Tag);
    for var C in Tag.Children do
    begin
      Result := FindTagById(C, Id);
      if Result <> nil then Exit;
    end;
  end;

  function GetTagValue(Tag: THTMLTag): string;
  begin
    Result := '';
    if not Assigned(Tag) then Exit;
    // For input elements, get the value attribute or current control value
    var TN := Tag.TagName.ToLower;
    if (TN = 'input') or (TN = 'textarea') or (TN = 'select') or (TN = 'button') then
    begin
      // Try to find the native control and get its live value
      for var Rec in FFormControls do
      begin
        if Assigned(Rec.Box) and (Rec.Box.Tag = Tag) then
        begin
          var N, V: string;
          GetFormControlNameValue(Rec.Control, N, V);
          Exit(V);
        end;
      end;
      // Fallback to HTML attribute
      Result := Tag.GetAttribute('value', '');
    end
    else
    begin
      // For other elements, get inner text
      for var C in Tag.Children do
        if C.TagName = '#text' then
          Result := Result + C.Text;
    end;
  end;

  function GetTagAttribute(Tag: THTMLTag; const AttrName: string): string;
  begin
    Result := '';
    if Assigned(Tag) then
      Result := Tag.GetAttribute(AttrName, '');
  end;

var
  S: string;
begin
  S := Expr.Trim;

  // this.value — value of the clicked element
  if SameText(S, 'this.value') then
    Exit(GetTagValue(ClickedTag));

  // this.id — id of the clicked element
  if SameText(S, 'this.id') then
    Exit(GetTagAttribute(ClickedTag, 'id'));

  // this.name — name of the clicked element
  if SameText(S, 'this.name') then
    Exit(GetTagAttribute(ClickedTag, 'name'));

  // this.className — class attribute
  if SameText(S, 'this.className') or SameText(S, 'this.classname') then
    Exit(GetTagAttribute(ClickedTag, 'class'));

  // this.<attr> — any attribute of clicked element
  if S.ToLower.StartsWith('this.') then
  begin
    var AttrName := Copy(S, 6, Length(S));
    Exit(GetTagAttribute(ClickedTag, AttrName));
  end;

  // document.getElementById('id').value
  if S.ToLower.StartsWith('document.getelementbyid(') then
  begin
    var P1 := Pos('(', S);
    var P2 := Pos(')', S);
    if (P1 > 0) and (P2 > P1) then
    begin
      var IdExpr := Copy(S, P1 + 1, P2 - P1 - 1).Trim;
      // Remove quotes
      if (Length(IdExpr) >= 2) and
         ((IdExpr[1] = '''') or (IdExpr[1] = '"')) then
        IdExpr := Copy(IdExpr, 2, Length(IdExpr) - 2);
      var FoundTag := FindTagById(FParser.Root, IdExpr);
      // Check what property is being accessed after the closing paren
      var Rest := Copy(S, P2 + 1, Length(S)).Trim;
      if Rest.StartsWith('.') then
        Rest := Copy(Rest, 2, Length(Rest));
      if SameText(Rest, 'value') then
        Exit(GetTagValue(FoundTag))
      else if SameText(Rest, 'id') then
        Exit(GetTagAttribute(FoundTag, 'id'))
      else if SameText(Rest, 'name') then
        Exit(GetTagAttribute(FoundTag, 'name'))
      else if Rest <> '' then
        Exit(GetTagAttribute(FoundTag, Rest))
      else
        Exit(GetTagValue(FoundTag));
    end;
  end;

  // String literal: 'text' or "text"
  if (Length(S) >= 2) and ((S[1] = '''') or (S[1] = '"')) and
     (S[Length(S)] = S[1]) then
    Exit(Copy(S, 2, Length(S) - 2));

  // Numeric literal
  var DummyInt: Integer;
  if TryStrToInt(S, DummyInt) then
    Exit(S);
  var DummyFloat: Double;
  if TryStrToFloat(S, DummyFloat) then
    Exit(S);

  // Unrecognized expression — pass through as-is
  Result := S;
end;

procedure TTina4HTMLRender.FireOnClick(ClickedTag: THTMLTag);
var
  OnClickAttr, ObjName, MethodName, ParamStr: string;
  P1, P2, ColonPos: Integer;
  Params: TStringList;
begin
  if not Assigned(ClickedTag) then Exit;

  OnClickAttr := ClickedTag.GetAttribute('onclick', '');
  if OnClickAttr = '' then Exit;

  // Parse format: "ObjectName:MethodName(param1, param2, ...)"
  // or just: "MethodName(param1, param2, ...)"
  P1 := Pos('(', OnClickAttr);
  P2 := LastDelimiter(')', OnClickAttr);

  if P1 > 0 then
  begin
    var Prefix := Copy(OnClickAttr, 1, P1 - 1).Trim;
    ColonPos := Pos(':', Prefix);
    if ColonPos > 0 then
    begin
      ObjName := Copy(Prefix, 1, ColonPos - 1).Trim;
      MethodName := Copy(Prefix, ColonPos + 1, Length(Prefix)).Trim;
    end
    else
    begin
      ObjName := '';
      MethodName := Prefix;
    end;

    // Extract parameters between ( and )
    if (P2 > P1) then
      ParamStr := Copy(OnClickAttr, P1 + 1, P2 - P1 - 1).Trim
    else
      ParamStr := '';
  end
  else
  begin
    // No parentheses — treat entire string as method call with no params
    ColonPos := Pos(':', OnClickAttr);
    if ColonPos > 0 then
    begin
      ObjName := Copy(OnClickAttr, 1, ColonPos - 1).Trim;
      MethodName := Copy(OnClickAttr, ColonPos + 1, Length(OnClickAttr)).Trim;
    end
    else
    begin
      ObjName := '';
      MethodName := OnClickAttr.Trim;
    end;
    ParamStr := '';
  end;

  // Parse and resolve parameters
  Params := TStringList.Create;
  try
    if ParamStr <> '' then
    begin
      // Split by comma, respecting quoted strings and parentheses
      var Depth := 0;
      var InQuote: Char := #0;
      var Start := 1;
      for var I := 1 to Length(ParamStr) do
      begin
        var Ch := ParamStr[I];
        if InQuote <> #0 then
        begin
          if Ch = InQuote then InQuote := #0;
        end
        else if (Ch = '''') or (Ch = '"') then
          InQuote := Ch
        else if Ch = '(' then Inc(Depth)
        else if Ch = ')' then Dec(Depth)
        else if (Ch = ',') and (Depth = 0) then
        begin
          var Param := Copy(ParamStr, Start, I - Start).Trim;
          Params.Add(ResolveOnClickParam(Param, ClickedTag));
          Start := I + 1;
        end;
      end;
      // Last parameter
      var LastParam := Copy(ParamStr, Start, Length(ParamStr) - Start + 1).Trim;
      if LastParam <> '' then
        Params.Add(ResolveOnClickParam(LastParam, ClickedTag));
    end;

    // Try direct RTTI invocation on registered objects. Track the failure
    // reason at each branch so OnUnresolvedClick can report something
    // useful instead of just "didn't fire". RTTI sees only `published` and
    // `public` members by default; a `private` method is the most common
    // cause of "method not found".
    var Handled := False;
    var UnresolvedReason: string := '';
    if ObjName = '' then
      UnresolvedReason := 'onclick has no Object: prefix'
    else if not FRegisteredObjects.ContainsKey(ObjName.ToLower) then
      UnresolvedReason := Format('object "%s" is not registered (use RegisterObject)', [ObjName])
    else
    begin
      var TargetObj := FRegisteredObjects[ObjName.ToLower];
      // Use the renderer-owned FRttiCtx — DO NOT Create/Free a local
      // TRttiContext here. The Method.Invoke below may call into host
      // code that itself uses RTTI (e.g. nested click dispatch, sale-
      // processing helpers, anything that touches TValue/TVarRec), and
      // a Create/Free pair around the invoke can drop the pool ref
      // count to zero mid-call, invalidating RttiType + Method. The
      // EAccessViolation + "RTTI objects cannot be manually destroyed"
      // cascade is the documented symptom of that. See FRttiCtx
      // declaration for the full rationale.
      try
        var RttiType := FRttiCtx.GetType(TargetObj.ClassType);
        if not Assigned(RttiType) then
          UnresolvedReason := Format('RTTI type info missing for %s', [TargetObj.ClassName])
        else
        begin
          var Method := RttiType.GetMethod(MethodName);
          if not Assigned(Method) then
            UnresolvedReason := Format(
              '%s.%s not found by RTTI - must be `public` or `published` (currently `private`?)',
              [TargetObj.ClassName, MethodName])
          else
          begin
            var RttiParams := Method.GetParameters;
            if Length(RttiParams) <> Params.Count then
              UnresolvedReason := Format(
                '%s.%s expects %d args but onclick passed %d',
                [TargetObj.ClassName, MethodName, Length(RttiParams), Params.Count])
            else
            begin
              try
                var Args: TArray<TValue>;
                SetLength(Args, Params.Count);
                for var I := 0 to Params.Count - 1 do
                  Args[I] := TValue.From<string>(Params[I]);
                Method.Invoke(TargetObj, Args);
                Handled := True;
              except
                on E: Exception do
                  UnresolvedReason := Format(
                    '%s.%s raised %s: %s',
                    [TargetObj.ClassName, MethodName, E.ClassName, E.Message]);
              end;
            end;
          end;
        end;
      except
        on E: Exception do
          UnresolvedReason := Format('RTTI lookup raised %s: %s',
            [E.ClassName, E.Message]);
      end;
    end;

    // Fall back to OnElementClick event if not handled via RTTI
    if (not Handled) and Assigned(FOnElementClick) then
    begin
      FOnElementClick(Self, ObjName, MethodName, Params);
      Handled := True;
    end;

    // Still nothing? Fire the diagnostic hook so the host app can surface
    // a typo or visibility mistake during development.
    if (not Handled) and Assigned(FOnUnresolvedClick) then
      FOnUnresolvedClick(Self, ObjName, MethodName, Params, UnresolvedReason);
  finally
    Params.Free;
  end;
end;

procedure TTina4HTMLRender.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
var
  Target: TLayoutBox;
  ACX, ACY: Single;
  Axis: Integer;
  OnThumb: Boolean;
begin
  inherited;
  if FDebugOverlay then
  begin
    FDebugMouseHit := True;
    FDebugLastMouseX := X;
    FDebugLastMouseY := Y;
    Repaint;
  end;

  // Stop any running inertia
  FInertiaTimer.Enabled := False;
  FInertiaBox := nil;
  // Reset pan state for new touch.
  FPanBox := nil;
  FPanIsViewport := False;
  FPanActive := False;
  FPanLockedAxis := 0;
  FPanLastX := X;
  FPanLastY := Y;
  FPanLastTick := TThread.GetTickCount;
  FPanVelocityX := 0;
  FPanVelocityY := 0;

  // Update :active state — set on the element under the press point and
  // its ancestor chain. Cleared in MouseUp.
  if (Button = TMouseButton.mbLeft) and Assigned(FLayoutEngine) and
     Assigned(FLayoutEngine.Root) then
  begin
    var ActiveTag := HitTestTagAt(FLayoutEngine.Root, -FScrollX, -FScrollY, X, Y);
    UpdatePseudoChain(FActiveChain, ActiveTag, 'active');
  end;

  // First check viewport scrollbar (outer)
  if ScrollBarVisible and (X >= Width - FScrollBarWidth) then
  begin
    FMouseDownOnScroll := True;
    FScrollDragStart := Y;
    FScrollDragThumbStart := FScrollY;
    Exit;
  end;
  // Then check any inner scrollable box's scrollbars.
  Target := FindScrollableAncestor(X, Y, ACX, ACY);
  if Assigned(Target) then
  begin
    if HitTestBoxScrollBar(Target, ACX, ACY, X, Y, Axis, OnThumb) then
    begin
      FDragScrollBox := Target;
      FDragScrollAxis := Axis;
      FDragScrollBoxCX := ACX;
      FDragScrollBoxCY := ACY;
      if Axis = 1 then
      begin
        FDragStartPos := Y;
        FDragStartScroll := Target.ScrollY;
      end
      else
      begin
        FDragStartPos := X;
        FDragStartScroll := Target.ScrollX;
      end;
      Exit;
    end;
  end;
  // Neither scrollbar was hit. Set up a pan candidate so a subsequent drag
  // can scroll via touch/swipe (primary gesture on mobile) or mouse drag.
  // Prefer the innermost scrollable ancestor; always fall back to the
  // viewport so the page can be scrolled by dragging anywhere — this is
  // the primary scroll gesture on mobile where there is no mouse wheel.
  // Always capture viewport scroll start — if the swipe turns out to be
  // vertical while over an inner horizontal-only scroller, we fall back
  // to scrolling the viewport vertically.
  FPanViewportStartScrollX := FScrollX;
  FPanViewportStartScrollY := FScrollY;

  if Assigned(Target) then
  begin
    FPanBox := Target;
    FPanIsViewport := False;
    FPanStartX := X;
    FPanStartY := Y;
    FPanStartScrollX := Target.ScrollX;
    FPanStartScrollY := Target.ScrollY;
  end
  else
  begin
    FPanBox := nil;
    FPanIsViewport := True;
    FPanStartX := X;
    FPanStartY := Y;
    FPanStartScrollX := FScrollX;
    FPanStartScrollY := FScrollY;
  end;
end;

procedure TTina4HTMLRender.MouseMove(Shift: TShiftState; X, Y: Single);
var
  Ratio, ThumbH, Delta: Single;
  Target: TLayoutBox;
  ACX, ACY: Single;
  VisW, VisH, TrackRange, ScrollRange: Single;
  SB: Single;
  HoverTag: THTMLTag;
begin
  inherited;

  // Update :hover state. Hit-test against the layout tree to find the
  // deepest element under the cursor, then promote/demote the ancestor
  // chain. UpdatePseudoChain triggers Repaint only when the chain
  // actually changed. We skip the update entirely during an active
  // pan/scroll gesture, AND when the loaded stylesheet doesn't have
  // any :hover/:active/:focus rule — the latter is the common case
  // for tap-driven UX where mouse-tracking would just burn CPU per
  // move with no visible effect.
  if Assigned(FLayoutEngine) and Assigned(FLayoutEngine.Root) and
     (not FPanActive) and (not FMouseDownOnScroll) and
     (not Assigned(FDragScrollBox)) and
     Assigned(FStyleSheet) and FStyleSheet.HasInteractiveSelectors then
  begin
    HoverTag := HitTestTagAt(FLayoutEngine.Root, -FScrollX, -FScrollY, X, Y);
    UpdatePseudoChain(FHoverChain, HoverTag, 'hover');
  end;
  if FMouseDownOnScroll and ScrollBarVisible then
  begin
    Ratio := Height / FContentHeight;
    ThumbH := Max(20, Height * Ratio);
    Delta := Y - FScrollDragStart;
    var TrackRange2 := Height - ThumbH;
    if TrackRange2 > 0 then
    begin
      var ScrollRange2 := FContentHeight - Height;
      SetScrollY(FScrollDragThumbStart + (Delta / TrackRange2) * ScrollRange2);
    end;
    Exit;
  end;

  // Inner-box scrollbar drag in progress
  if Assigned(FDragScrollBox) and (FDragScrollAxis <> 0) then
  begin
    SB := FScrollBarWidth;
    VisW := FDragScrollBox.ContentWidth;
    VisH := FDragScrollBox.ContentHeight;
    if FDragScrollBox.NeedsScrollBarY then VisW := VisW - SB;
    if FDragScrollBox.NeedsScrollBarX then VisH := VisH - SB;
    if VisW < 0 then VisW := 0;
    if VisH < 0 then VisH := 0;

    if FDragScrollAxis = 1 then
    begin
      if FDragScrollBox.ScrollHeight <= VisH then Exit;
      ThumbH := Max(20, VisH * (VisH / FDragScrollBox.ScrollHeight));
      if ThumbH > VisH then ThumbH := VisH;
      TrackRange := VisH - ThumbH;
      ScrollRange := FDragScrollBox.ScrollHeight - VisH;
      if TrackRange > 0 then
      begin
        FDragScrollBox.ScrollY := FDragStartScroll +
          ((Y - FDragStartPos) / TrackRange) * ScrollRange;
        FDragScrollBox.ClampOwnScroll;
        BumpScrollbarVisibility;
        Repaint;
      end;
    end
    else if FDragScrollAxis = 2 then
    begin
      if FDragScrollBox.ScrollWidth <= VisW then Exit;
      var ThumbW := Max(20, VisW * (VisW / FDragScrollBox.ScrollWidth));
      if ThumbW > VisW then ThumbW := VisW;
      TrackRange := VisW - ThumbW;
      ScrollRange := FDragScrollBox.ScrollWidth - VisW;
      if TrackRange > 0 then
      begin
        FDragScrollBox.ScrollX := FDragStartScroll +
          ((X - FDragStartPos) / TrackRange) * ScrollRange;
        FDragScrollBox.ClampOwnScroll;
        BumpScrollbarVisibility;
        Repaint;
      end;
    end;
    Exit;
  end;


  // Pan-to-scroll. When over an inner scrollable container, only scroll
  // that container on the axes it supports — never mix with viewport scroll.
  // When over plain content (viewport pan), use simple dominant-axis locking.
  if (FPanIsViewport or Assigned(FPanBox)) then
  begin
    var DX := X - FPanStartX;
    var DY := Y - FPanStartY;
    if (not FPanActive) and (Abs(DX) + Abs(DY) > 5) then
    begin
      FPanActive := True;
      if Abs(DX) > Abs(DY) then
        FPanLockedAxis := 2
      else
        FPanLockedAxis := 1;
    end;
    if FPanActive then
    begin
      // Track velocity for inertia
      var Now := TThread.GetTickCount;
      var Elapsed := Now - FPanLastTick;
      if Elapsed > 0 then
      begin
        FPanVelocityX := -(X - FPanLastX) / Elapsed * 16; // normalize to ~16ms frame
        FPanVelocityY := -(Y - FPanLastY) / Elapsed * 16;
      end;
      FPanLastX := X;
      FPanLastY := Y;
      FPanLastTick := Now;

      if FPanIsViewport then
      begin
        // Viewport pan: lock to dominant axis
        if FPanLockedAxis = 1 then
          SetScrollY(FPanStartScrollY - DY)
        else
          SetScrollX(FPanStartScrollX - DX);
      end
      else
      begin
        // Inner box: scroll only the axes the box supports, nothing else
        if FPanBox.IsScrollableX and (FPanBox.ScrollWidth > FPanBox.ContentWidth + 0.5) then
          FPanBox.ScrollX := FPanStartScrollX - DX;
        if FPanBox.IsScrollableY and (FPanBox.ScrollHeight > FPanBox.ContentHeight + 0.5) then
          FPanBox.ScrollY := FPanStartScrollY - DY;
        FPanBox.ClampOwnScroll;
        BumpScrollbarVisibility;
        Repaint;
      end;
    end;
    Exit;
  end;

  // Passive hover tracking: remember the innermost scrollable box under
  // the mouse so mousewheel can be routed to it.
  Target := FindScrollableAncestor(X, Y, ACX, ACY);
  if Target <> FHoverScrollBox then
  begin
    FHoverScrollBox := Target;
    FHoverScrollBoxCX := ACX;
    FHoverScrollBoxCY := ACY;
  end
  else if Assigned(Target) then
  begin
    FHoverScrollBoxCX := ACX;
    FHoverScrollBoxCY := ACY;
  end;
end;

procedure TTina4HTMLRender.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);

  // General hit-test: find the deepest element at (HitX, HitY).
  // Returns the THTMLTag of the innermost element hit. HitX/HitY are in
  // the coordinate system of Box's parent (so Box.X/Y are added). When
  // recursing into a scrollable box we subtract its ScrollX/Y so the
  // children are tested against their scrolled positions.
  function HitTestElement(Box: TLayoutBox; OffX, OffY: Single;
    HitX, HitY: Single): THTMLTag;
  var
    AbsX, AbsY, CX, CY: Single;
    Left, Top, Right, Bottom: Single;
    ChildResult: THTMLTag;
  begin
    Result := nil;
    if Box.Style.Display = 'none' then Exit;
    AbsX := OffX + Box.X;
    AbsY := OffY + Box.Y;
    // Apply sticky pinning for hit-test
    if (Box.Style.CSSPosition = 'sticky') and (Box.Style.CSSTop > -9990) then
      if AbsY < Box.Style.CSSTop then
        AbsY := Box.Style.CSSTop;

    // Check if click is inside this box
    if Assigned(Box.Tag) and (Box.Tag.TagName <> '#text') then
    begin
      Left := AbsX + ResolveAutoMargin(Box.Style.Margin.Left);
      Top := AbsY + ResolveAutoMargin(Box.Style.Margin.Top);
      Right := Left + Box.Style.BorderWidths.Horz +
        Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right;
      Bottom := Top + Box.Style.BorderWidths.Vert +
        Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom;
      if (HitX >= Left) and (HitX <= Right) and
         (HitY >= Top) and (HitY <= Bottom) then
        Result := Box.Tag;  // Candidate — may be overridden by a deeper child
    end;

    // Recurse children — deepest match wins. When Box is scrollable, its
    // children were painted at (CX - ScrollX, CY - ScrollY), so we mirror
    // that shift here when hit-testing. Also, only test children if the
    // hit point is actually inside the box's padding box (prevents picking
    // up children that are clipped out of view).
    CX := AbsX + Box.ContentLeft;
    CY := AbsY + Box.ContentTop;
    if Box.IsScrollableX or Box.IsScrollableY then
    begin
      if (HitX < CX) or (HitX > CX + Box.ContentWidth) or
         (HitY < CY) or (HitY > CY + Box.ContentHeight) then
        Exit;
      for var Child in Box.Children do
      begin
        ChildResult := HitTestElement(Child, CX - Box.ScrollX, CY - Box.ScrollY, HitX, HitY);
        if ChildResult <> nil then
          Result := ChildResult;
      end;
    end
    else
    begin
      for var Child in Box.Children do
      begin
        ChildResult := HitTestElement(Child, CX, CY, HitX, HitY);
        if ChildResult <> nil then
          Result := ChildResult;
      end;
    end;
  end;

var
  PanWasActive: Boolean;
begin
  inherited;
  if FMouseDownOnScroll then
  begin
    FMouseDownOnScroll := False;
    Exit;
  end;
  FMouseDownOnScroll := False;
  if Assigned(FDragScrollBox) and (FDragScrollAxis <> 0) then
  begin
    FDragScrollBox := nil;
    FDragScrollAxis := 0;
    Exit;
  end;

  // If a pan was active, start inertia and swallow the click.
  PanWasActive := FPanActive;
  if PanWasActive then
  begin
    // Launch inertia if velocity is significant
    if (Abs(FPanVelocityX) > 0.5) or (Abs(FPanVelocityY) > 0.5) then
    begin
      FInertiaBox := FPanBox;  // nil = viewport
      FInertiaVX := FPanVelocityX;
      FInertiaVY := FPanVelocityY;
      // For viewport, only apply on the locked axis
      if FPanIsViewport then
      begin
        if FPanLockedAxis = 1 then FInertiaVX := 0
        else FInertiaVY := 0;
      end;
      FInertiaTimer.Enabled := True;
    end;
  end;
  FPanBox := nil;
  FPanIsViewport := False;
  FPanActive := False;
  FPanLockedAxis := 0;
  if PanWasActive then
    Exit;

  if (Button = TMouseButton.mbLeft) and Assigned(FLayoutEngine) and
     Assigned(FLayoutEngine.Root) then
  begin
    var HitTag := HitTestElement(FLayoutEngine.Root, 0, 0, X + FScrollX, Y + FScrollY);

    // Check if a <label> was clicked — toggle associated checkbox/radio
    if Assigned(HitTag) then
    begin
      // Walk up to find a <label> (the hit might be on a child of the label)
      var LabelTag := HitTag;
      while Assigned(LabelTag) and not SameText(LabelTag.TagName, 'label') do
        LabelTag := LabelTag.Parent;
      if Assigned(LabelTag) then
      begin
        var ForId := LabelTag.GetAttribute('for', '');
        if ForId <> '' then
          for var Rec in FFormControls do
            if Assigned(Rec.Box) and Assigned(Rec.Box.Tag) and
               SameText(Rec.Box.Tag.GetAttribute('id', ''), ForId) then
            begin
              if Rec.Control is TCheckBox then
                TCheckBox(Rec.Control).IsChecked := not TCheckBox(Rec.Control).IsChecked
              else if Rec.Control is TRadioButton then
                TRadioButton(Rec.Control).IsChecked := True;
              Break;
            end;
      end;

    end;
  end;

  // Clear :active — chain empty, all flags off.
  if (Button = TMouseButton.mbLeft) and (FActiveChain.Count > 0) then
    UpdatePseudoChain(FActiveChain, nil, 'active');

  // Check pre-recorded clickable regions for onclick attribute handling.
  // Regions are in screen coordinates, recorded during Paint.
  // Search in reverse order so deeper (later-painted) elements are found first.
  if (Button = TMouseButton.mbLeft) and
     (Assigned(FOnElementClick) or (FRegisteredObjects.Count > 0)) then
  begin
    for var I := FClickableRegions.Count - 1 downto 0 do
    begin
      var Region := FClickableRegions[I];
      if Region.Rect.Contains(PointF(X, Y)) then
      begin
        FireOnClick(Region.Tag);
        Break;
      end;
    end;
  end;

  // Check for anchor link clicks — walk up the DOM tree from the hit element
  // to find the nearest <a> ancestor with href attribute
  if (Button = TMouseButton.mbLeft) and Assigned(FOnLinkClick) and
     Assigned(FLayoutEngine) and Assigned(FLayoutEngine.Root) then
  begin
    var HitTag2 := HitTestElement(FLayoutEngine.Root, 0, 0, X + FScrollX, Y + FScrollY);
    if Assigned(HitTag2) then
    begin
      var WalkTag := HitTag2;
      while Assigned(WalkTag) do
      begin
        if SameText(WalkTag.TagName, 'a') and
           (WalkTag.GetAttribute('href', '') <> '') then
        begin
          var LinkURL := WalkTag.GetAttribute('href', '');
          var LinkHandled := False;
          FOnLinkClick(Self, LinkURL, LinkHandled);
          Break;
        end;
        WalkTag := WalkTag.Parent;
      end;
    end;
  end;
end;

// CMGesture removed — MouseDown/Move/Up handle pan on all platforms.
// Keeping the override stub so the class compiles if InteractiveGestures
// were ever re-enabled, but it just calls inherited.

procedure TTina4HTMLRender.ResizeSettleTick(Sender: TObject);
begin
  FResizeTimer.Enabled := False;
  if csDestroying in ComponentState then Exit;
  {$IF defined(ANDROID) or defined(IOS)}
  // CRITICAL (2026-06-06, Sunmi V2s multi-renderer relayout storm crash):
  // If the soft keyboard is up, the resize that armed this timer was the
  // keyboard's window-surface shrink (adjustResize). Relaying out NOW runs a
  // full DoLayout (ClearFormControls + CreateFormControls) on EVERY
  // ParentedVisible renderer at once — the heavy POS grid still visible under
  // an input overlay, plus any sibling overlays. On a slow MTK GPU that N-way
  // storm, fired during the keyboard's in-flight surface transaction, either
  // stalls the compositor (sync-point timeout -> process killed, no tombstone)
  // or briefly steals focus from the input that just popped the keyboard,
  // leaving its IME-bound TEdit unguarded and disposed -> silent native crash.
  // Reproduced: POS -> 1Voucher, its autofocus pops the keyboard, ~70ms later
  // 5+ ClearFormControls fire across renderers -> crash.
  //
  // A keyboard overlay does NOT change the HTML layout (the content just gets
  // covered / scrolled), so this relayout buys nothing. Defer it: mark
  // FRelayoutAfterKbd and do it ONCE when the keyboard goes back down
  // (VKStateChangeHandler), when the IME has released and no input is focused.
  if FKeyboardVisible then
  begin
    TraceLog('ResizeSettleTick: kbd up — defer relayout to kbd-down');
    FRelayoutAfterKbd := True;
    Exit;
  end;
  {$ENDIF}
  TraceLog('ResizeSettleTick: relayout now');
  FNeedRelayout := True;
  Repaint;
end;

procedure TTina4HTMLRender.Resize;
begin
  inherited;
  if FIsLayoutting then Exit;

  // CRITICAL (2026-06-06, Sunmi V2s relayout storm + focus-theft):
  // A host can keep several TTina4HTMLRender instances parented to one form
  // (Voucher / Electricity / DStv / Global Airtime / POS / Transfer),
  // switching between them with Visible. FMX delivers Resize to EVERY
  // aligned child on a form resize regardless of Visible, and the soft
  // keyboard opening IS a form resize. If the OFF-SCREEN renderers relayout
  // too, two bad things happen: (1) an N-way ClearFormControls storm on a
  // slow GPU, and (2) any off-screen renderer that still has an autofocus
  // input runs SetFocus during its relayout and STEALS focus from the
  // on-screen input that just popped the keyboard — which then defeats the
  // focus-guard below and lets that input be disposed mid-IME-bind -> the
  // silent native crash seen entering Global Airtime after a transfer.
  //
  // So an off-screen renderer must NOT relayout here. Mark FNeedRelayout so
  // it still relayouts lazily the next time it is actually painted (Paint ->
  // DoLayout when shown again), but do no work now.
  //
  // Use ParentedVisible, NOT Visible: a renderer hosted on a hidden parent
  // frame (e.g. renderTransfer on frameTransfer1 after we navigate away)
  // still has its OWN Visible = True — only the parent frame is hidden. A
  // plain `Visible` check misses it, so on the keyboard resize it relayouts,
  // re-runs ITS autofocus SetFocus, and steals focus from the on-screen
  // input that just popped the keyboard. ParentedVisible is False whenever
  // any ancestor is hidden, which is exactly the set we must not touch.
  if not ParentedVisible then
  begin
    FNeedRelayout := True;
    Exit;
  end;

  {$IF defined(ANDROID) or defined(IOS)}
  // CRITICAL (2026-06-06, Sunmi V2s focused-input dispose crash):
  // If one of THIS renderer's own inputs is focused, this resize is the
  // soft keyboard opening/closing. Do NOT relayout — a relayout runs
  // ClearFormControls + CreateFormControls (in DoLayout), which DISPOSES
  // the focused native TEdit out from under Android's live IME
  // InputConnection. The process then dies with no exception and no
  // tombstone (debuggerd is locked down on this device). Reproduced as:
  // enter Global Airtime after a transfer, its autofocused input pops the
  // keyboard, the form shrinks -> Resize -> relayout -> dispose -> crash.
  //
  // The visible content does not change when the keyboard appears (it just
  // overlays the bottom of the screen), so this relayout buys nothing;
  // ScrollFocusedControlAboveKeyboard handles lifting the input above the
  // keyboard. Once focus leaves (keyboard down / navigation away) the next
  // resize relays out normally. Scoped to Resize ONLY: explicit DOM
  // mutations (SetElementText / SetElementStyle / SetElementVisible /
  // ShowStep) still drive a normal DoLayout so their content shows — that
  // is why Search results and the OTP step still render while typing.
  // Assigned() guard is REQUIRED: the constructor sets Width/Height (which
  // fires Resize) BEFORE FFormControls is created, so this runs once with a
  // nil list during construction. Iterating a nil list AVs and crash-loops
  // the app at startup. Nil => no controls => none focused => fall through.
  if Assigned(FFormControls) then
    for var FRec in FFormControls do
      if (FRec.Control <> nil) and FRec.Control.IsFocused then
        Exit;
  {$ENDIF}

  // CRITICAL: do NOT set FNeedRelayout here. It would make any Paint during
  // the keyboard animation run a full DoLayout, whose bounds change triggers
  // View.layout -> onLayoutChange -> onVirtualKeyboardFrameChanged AGAIN,
  // re-entrant -> infinite recursion -> ANR. Only ResizeSettleTick marks the
  // relayout, after the size stops changing. Taller keyboards expose this.
  // Coalesce: restart the settle timer instead of relaying out synchronously.
  // During the keyboard slide animation FMX fires many resize events; this
  // collapses them into a single relayout once the size settles, keeping the
  // UI thread free for the keyboard's window-surface transaction (the MTK
  // sync-point-timeout stall fix). The active focused renderer never gets
  // here (focus guard above); this mainly spares the heavy POS grid that is
  // still visible underneath an input overlay.
  if Assigned(FResizeTimer) then
  begin
    FResizeTimer.Enabled := False;
    FResizeTimer.Enabled := True;
  end
  else
  begin
    FNeedRelayout := True;
    Repaint;
  end;
end;

end.
