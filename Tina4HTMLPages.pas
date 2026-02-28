unit Tina4HTMLPages;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  Tina4HTMLRender;

type
  // Forward declaration
  TTina4HTMLPages = class;

  // ─────────────────────────────────────────────────────────────────────────
  // TTina4Page — a single page in the collection
  // ─────────────────────────────────────────────────────────────────────────

  /// <summary>
  /// Represents a single page in a TTina4HTMLPages navigation component.
  /// Each page has a unique PageName and can contain either Twig template
  /// content or raw HTML content. When navigated to, the content is rendered
  /// by the linked TTina4HTMLRender component.
  /// </summary>
  TTina4Page = class(TCollectionItem)
  private
    FPageName: string;
    FTwigContent: TStringList;
    FHTMLContent: TStringList;
    FIsDefault: Boolean;
    procedure SetTwigContent(const Value: TStringList);
    procedure SetHTMLContent(const Value: TStringList);
  protected
    function GetDisplayName: string; override;
  public
    /// <summary>Creates a new page item in the collection.</summary>
    constructor Create(Collection: TCollection); override;
    /// <summary>Frees the page and its content string lists.</summary>
    destructor Destroy; override;
  published
    /// <summary>Unique name used as the navigation target (e.g. 'home', 'dashboard').</summary>
    property PageName: string read FPageName write FPageName;
    /// <summary>Twig template source. When non-empty, rendered via TTina4Twig on navigation.</summary>
    property TwigContent: TStringList read FTwigContent write SetTwigContent;
    /// <summary>Raw HTML content. Used when TwigContent is empty.</summary>
    property HTMLContent: TStringList read FHTMLContent write SetHTMLContent;
    /// <summary>When True, this page is automatically displayed on component startup.</summary>
    property IsDefault: Boolean read FIsDefault write FIsDefault default False;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // TTina4PageCollection — owned collection of pages
  // ─────────────────────────────────────────────────────────────────────────

  /// <summary>
  /// Owned collection of TTina4Page items. Provides lookup by page name
  /// and a typed Add method for creating new pages.
  /// </summary>
  TTina4PageCollection = class(TOwnedCollection)
  public
    /// <summary>Finds a page by name (case-insensitive). Returns nil if not found.</summary>
    function FindPage(const AName: string): TTina4Page;
    /// <summary>Adds a new empty TTina4Page to the collection.</summary>
    function Add: TTina4Page;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation event types
  // ─────────────────────────────────────────────────────────────────────────

  TPageNavigateEvent = procedure(Sender: TObject; const FromPage, ToPage: string;
    var Allow: Boolean) of object;

  // ─────────────────────────────────────────────────────────────────────────
  // TTina4HTMLPages — design-time page navigation component
  // ─────────────────────────────────────────────────────────────────────────

  /// <summary>
  /// Design-time page navigation component that provides SPA-style navigation
  /// using TTina4HTMLRender. Pages are defined as a collection (editable in the
  /// Object Inspector). Navigation is triggered by anchor href clicks in the
  /// rendered HTML or programmatically via NavigateTo. Supports both Twig
  /// templates and raw HTML content per page.
  /// </summary>
  TTina4HTMLPages = class(TComponent)
  private
    FPages: TTina4PageCollection;
    FRenderer: TTina4HTMLRender;
    FActivePage: string;
    FTwigEngine: TObject;  // TTina4Twig (declared in implementation uses)
    FTwigTemplatePath: string;
    FOnBeforeNavigate: TPageNavigateEvent;
    FOnAfterNavigate: TNotifyEvent;
    procedure SetRenderer(const Value: TTina4HTMLRender);
    procedure SetActivePage(const Value: string);
    procedure SetTwigTemplatePath(const Value: string);
    procedure SetPages(const Value: TTina4PageCollection);
    procedure HandleLinkClick(Sender: TObject; const AURL: string;
      var Handled: Boolean);
  protected
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Loaded; override;
  public
    /// <summary>Creates the component with an empty page collection and Twig engine.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Unhooks from the renderer and frees the page collection and Twig engine.</summary>
    destructor Destroy; override;
    /// <summary>
    /// Navigates to the page with the given name. Fires OnBeforeNavigate
    /// (which can cancel), renders the page content to the linked Renderer,
    /// then fires OnAfterNavigate.
    /// </summary>
    /// <param name="APageName">The PageName of the target page.</param>
    procedure NavigateTo(const APageName: string);
    /// <summary>
    /// Sets a variable in the Twig rendering context. Call before NavigateTo
    /// to make variables available in Twig templates.
    /// </summary>
    /// <param name="AName">Variable name (used as {{ name }} in templates).</param>
    /// <param name="AValue">Variable value.</param>
    procedure SetTwigVariable(const AName: string; const AValue: string);
  published
    /// <summary>Collection of pages (design-time editable via Object Inspector).</summary>
    property Pages: TTina4PageCollection read FPages write SetPages;
    /// <summary>The TTina4HTMLRender component that displays the active page.</summary>
    property Renderer: TTina4HTMLRender read FRenderer write SetRenderer;
    /// <summary>Name of the currently displayed page. Setting this calls NavigateTo.</summary>
    property ActivePage: string read FActivePage write SetActivePage;
    /// <summary>Base path for Twig {% include %} and {% extends %} resolution.</summary>
    property TwigTemplatePath: string read FTwigTemplatePath write SetTwigTemplatePath;
    /// <summary>Fires before navigation. Set Allow := False to cancel.</summary>
    property OnBeforeNavigate: TPageNavigateEvent read FOnBeforeNavigate write FOnBeforeNavigate;
    /// <summary>Fires after the new page has been rendered.</summary>
    property OnAfterNavigate: TNotifyEvent read FOnAfterNavigate write FOnAfterNavigate;
  end;

procedure Register;

implementation

uses
  Tina4Twig;

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4HTMLPages]);
end;

// ═══════════════════════════════════════════════════════════════════════════
// TTina4Page
// ═══════════════════════════════════════════════════════════════════════════

constructor TTina4Page.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTwigContent := TStringList.Create;
  FHTMLContent := TStringList.Create;
  FIsDefault := False;
end;

destructor TTina4Page.Destroy;
begin
  FHTMLContent.Free;
  FTwigContent.Free;
  inherited;
end;

function TTina4Page.GetDisplayName: string;
begin
  if FPageName <> '' then
    Result := FPageName
  else
    Result := inherited GetDisplayName;
end;

procedure TTina4Page.SetTwigContent(const Value: TStringList);
begin
  FTwigContent.Assign(Value);
end;

procedure TTina4Page.SetHTMLContent(const Value: TStringList);
begin
  FHTMLContent.Assign(Value);
end;

// ═══════════════════════════════════════════════════════════════════════════
// TTina4PageCollection
// ═══════════════════════════════════════════════════════════════════════════

function TTina4PageCollection.FindPage(const AName: string): TTina4Page;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
    if SameText(TTina4Page(Items[I]).PageName, AName) then
      Exit(TTina4Page(Items[I]));
end;

function TTina4PageCollection.Add: TTina4Page;
begin
  Result := TTina4Page(inherited Add);
end;

// ═══════════════════════════════════════════════════════════════════════════
// TTina4HTMLPages
// ═══════════════════════════════════════════════════════════════════════════

constructor TTina4HTMLPages.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TTina4PageCollection.Create(Self, TTina4Page);
  FTwigEngine := TTina4Twig.Create('');
end;

destructor TTina4HTMLPages.Destroy;
begin
  // Unhook from renderer before freeing
  if FRenderer <> nil then
  begin
    FRenderer.OnLinkClick := nil;
    FRenderer.RemoveFreeNotification(Self);
  end;
  FTwigEngine.Free;
  FPages.Free;
  inherited;
end;

procedure TTina4HTMLPages.SetPages(const Value: TTina4PageCollection);
begin
  FPages.Assign(Value);
end;

procedure TTina4HTMLPages.SetRenderer(const Value: TTina4HTMLRender);
begin
  if FRenderer = Value then Exit;
  // Unhook from old renderer
  if FRenderer <> nil then
  begin
    FRenderer.OnLinkClick := nil;
    FRenderer.RemoveFreeNotification(Self);
  end;
  FRenderer := Value;
  // Hook into new renderer
  if FRenderer <> nil then
  begin
    FRenderer.FreeNotification(Self);
    FRenderer.OnLinkClick := HandleLinkClick;
  end;
end;

procedure TTina4HTMLPages.SetActivePage(const Value: string);
begin
  if FActivePage <> Value then
    NavigateTo(Value);
end;

procedure TTina4HTMLPages.SetTwigTemplatePath(const Value: string);
begin
  if FTwigTemplatePath <> Value then
  begin
    FTwigTemplatePath := Value;
    FTwigEngine.Free;
    FTwigEngine := TTina4Twig.Create(Value);
  end;
end;

procedure TTina4HTMLPages.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (AComponent = FRenderer) then
    FRenderer := nil;
end;

procedure TTina4HTMLPages.Loaded;
var
  I: Integer;
begin
  inherited;
  // Navigate to the default page after component streaming is complete
  for I := 0 to FPages.Count - 1 do
    if TTina4Page(FPages.Items[I]).IsDefault then
    begin
      NavigateTo(TTina4Page(FPages.Items[I]).PageName);
      Break;
    end;
end;

procedure TTina4HTMLPages.NavigateTo(const APageName: string);
var
  Page: TTina4Page;
  Allow: Boolean;
  RenderedHTML: string;
begin
  Page := FPages.FindPage(APageName);
  if Page = nil then Exit;

  // Fire OnBeforeNavigate — caller can cancel
  Allow := True;
  if Assigned(FOnBeforeNavigate) then
    FOnBeforeNavigate(Self, FActivePage, APageName, Allow);
  if not Allow then Exit;

  FActivePage := APageName;

  if Assigned(FRenderer) then
  begin
    if Page.TwigContent.Text.Trim <> '' then
    begin
      // Render Twig content through our own engine and set as HTML
      RenderedHTML := TTina4Twig(FTwigEngine).Render(Page.TwigContent.Text);
      FRenderer.HTML.Text := RenderedHTML;
    end
    else if Page.HTMLContent.Text.Trim <> '' then
      FRenderer.HTML.Text := Page.HTMLContent.Text;
  end;

  if Assigned(FOnAfterNavigate) then
    FOnAfterNavigate(Self);
end;

procedure TTina4HTMLPages.HandleLinkClick(Sender: TObject; const AURL: string;
  var Handled: Boolean);
var
  PageName: string;
begin
  // Strip leading # or / for convention: href="#dashboard" or href="/dashboard"
  PageName := AURL;
  if (PageName <> '') and ((PageName[1] = '#') or (PageName[1] = '/')) then
    PageName := Copy(PageName, 2, Length(PageName) - 1);

  if FPages.FindPage(PageName) <> nil then
  begin
    NavigateTo(PageName);
    Handled := True;
  end;
  // If page not found, Handled stays False — link not consumed
end;

procedure TTina4HTMLPages.SetTwigVariable(const AName: string; const AValue: string);
begin
  TTina4Twig(FTwigEngine).SetVariable(AName, AValue);
end;

end.
