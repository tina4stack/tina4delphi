unit Tina4HtmlRender;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Math,
  System.Generics.Collections, System.UITypes, System.UIConsts,
  System.NetEncoding, System.Net.HttpClient,
  FMX.Types, FMX.Controls, FMX.Graphics, FMX.TextLayout;

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
    function Peek: Char;
    function PeekAt(Offset: Integer): Char;
    procedure Advance(Count: Integer = 1);
    function AtEnd: Boolean;
    procedure SkipWhitespace;
    procedure SkipComment;
    procedure SkipDoctype;
    procedure SkipRawContent(const TagName: string);
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
    class function DecodeEntities(const S: string): string; static;
    class function IsBlockTag(const Name: string): Boolean; static;
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
    class function Default: TComputedStyle; static;
    class function ForTag(Tag: THTMLTag; const ParentStyle: TComputedStyle): TComputedStyle; static;
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
  public
    constructor Create;
    destructor Destroy; override;
    function GetImage(const Src: string): TBitmap;
    procedure RequestImage(const Src: string);
    procedure Clear;
    property OnImageLoaded: TNotifyEvent read FOnImageLoaded write FOnImageLoaded;
  end;

  // ─────────────────────────────────────────────────────────────────────────
  // Layout Engine
  // ─────────────────────────────────────────────────────────────────────────

  TLayoutEngine = class
  private
    FRoot: TLayoutBox;
    FImageCache: TImageCache;
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
    procedure Layout(DOMRoot: THTMLTag; AvailWidth: Single);
    property Root: TLayoutBox read FRoot;
    property TotalHeight: Single read FTotalHeight;
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
    FScrollY: Single;
    FContentHeight: Single;
    FNeedRelayout: Boolean;
    FScrollBarWidth: Single;
    FIsLayoutting: Boolean;
    FMouseDownOnScroll: Boolean;
    FScrollDragStart: Single;
    FScrollDragThumbStart: Single;
    procedure SetHTML(const Value: TStringList);
    function GetHTML: TStringList;
    procedure FHTMLChange(Sender: TObject);
    procedure OnImageLoaded(Sender: TObject);
    procedure DoLayout;
    procedure PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single);
    procedure PaintBackground(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintText(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintImage(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintFormControl(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintHR(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
    procedure PaintListMarker(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
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
  published
    property HTML: TStringList read GetHTML write SetHTML;
    property Debug: TStringList read FDebug write FDebug;
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
// THTMLParser
// ═══════════════════════════════════════════════════════════════════════════

constructor THTMLParser.Create;
begin
  inherited;
  FRoot := THTMLTag.Create;
  FRoot.TagName := 'root';
end;

destructor THTMLParser.Destroy;
begin
  FRoot.Free;
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
  Result := SameText(Name, 'div') or SameText(Name, 'p') or
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
    SameText(Name, 'link') or SameText(Name, 'title') or
    SameText(Name, 'script') or SameText(Name, 'style');
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

        // Raw content tags (script, style) — skip content
        if IsRawTag(TagName) and not SelfClose then
        begin
          SkipRawContent(TagName);
          ChildTag.Free;
          Continue;
        end;

        // Ignored tags — skip the tag node but parse children for body-like containers
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
begin
  Str := S.Trim.ToLower;
  if Str = '' then Exit(0);
  if Str = 'auto' then Exit(-1);

  if Str.EndsWith('em') then
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

class function TComputedStyle.ForTag(Tag: THTMLTag; const ParentStyle: TComputedStyle): TComputedStyle;
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
    Result.Padding.Left := 20;
  end
  else if TN = 'ol' then
  begin
    Result.Margin.Top := ParentStyle.FontSize * 0.5;
    Result.Margin.Bottom := ParentStyle.FontSize * 0.5;
    Result.Padding.Left := 20;
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

  // Inline style overrides
  if Tag.Style.TryGetValue('color', Temp) then
    Result.Color := ParseColor(Temp);
  if Tag.Style.TryGetValue('background-color', Temp) then
    Result.BackgroundColor := ParseColor(Temp);
  if Tag.Style.TryGetValue('background', Temp) then
  begin
    // Simple background — just color
    if not Temp.Contains('url') then
      Result.BackgroundColor := ParseColor(Temp);
  end;
  if Tag.Style.TryGetValue('font-family', Temp) then
    Result.FontFamily := Temp.DeQuotedString('''').DeQuotedString('"');
  if Tag.Style.TryGetValue('font-size', Temp) then
    Result.FontSize := ParseLength(Temp, ParentStyle.FontSize);
  if Tag.Style.TryGetValue('font-weight', Temp) then
    Result.Bold := SameText(Temp, 'bold') or (StrToIntDef(Temp, 400) >= 700);
  if Tag.Style.TryGetValue('font-style', Temp) then
    Result.Italic := SameText(Temp, 'italic') or SameText(Temp, 'oblique');
  if Tag.Style.TryGetValue('text-decoration', Temp) then
    Result.TextDecoration := Temp.ToLower;
  if Tag.Style.TryGetValue('text-align', Temp) then
  begin
    Temp := Temp.ToLower;
    if Temp = 'center' then Result.TextAlign := TTextAlign.Center
    else if Temp = 'right' then Result.TextAlign := TTextAlign.Trailing
    else if Temp = 'justify' then Result.TextAlign := TTextAlign.Leading
    else Result.TextAlign := TTextAlign.Leading;
  end;
  if Tag.Style.TryGetValue('line-height', Temp) then
  begin
    var LH := StrToFloatDef(Temp.Replace('px', '').Replace('em', ''), 0);
    if LH > 0 then
    begin
      if Temp.Contains('px') then
        Result.LineHeight := LH / Result.FontSize
      else
        Result.LineHeight := LH;
    end;
  end;
  if Tag.Style.TryGetValue('margin', Temp) then
    ParseEdgeShorthand(Temp, Result.Margin, Result.FontSize);
  if Tag.Style.TryGetValue('margin-top', Temp) then
    Result.Margin.Top := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('margin-right', Temp) then
    Result.Margin.Right := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('margin-bottom', Temp) then
    Result.Margin.Bottom := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('margin-left', Temp) then
    Result.Margin.Left := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('padding', Temp) then
    ParseEdgeShorthand(Temp, Result.Padding, Result.FontSize);
  if Tag.Style.TryGetValue('padding-top', Temp) then
    Result.Padding.Top := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('padding-right', Temp) then
    Result.Padding.Right := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('padding-bottom', Temp) then
    Result.Padding.Bottom := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('padding-left', Temp) then
    Result.Padding.Left := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('border', Temp) then
  begin
    var BParts := Temp.Split([' ']);
    for var BP in BParts do
    begin
      var BT := BP.Trim.ToLower;
      if (BT.EndsWith('px')) or (StrToFloatDef(BT, -1) >= 0) then
        Result.BorderWidth := StrToFloatDef(BT.Replace('px', ''), 1)
      else if BT = 'solid' then
        // border style is solid, default
      else if BT <> 'none' then
        Result.BorderColor := ParseColor(BT);
    end;
  end;
  if Tag.Style.TryGetValue('border-color', Temp) then
    Result.BorderColor := ParseColor(Temp);
  if Tag.Style.TryGetValue('border-width', Temp) then
    Result.BorderWidth := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('width', Temp) then
    Result.ExplicitWidth := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('height', Temp) then
    Result.ExplicitHeight := ParseLength(Temp, Result.FontSize);
  if Tag.Style.TryGetValue('display', Temp) then
    Result.Display := Temp.ToLower;
  if Tag.Style.TryGetValue('vertical-align', Temp) then
    Result.VerticalAlign := Temp.ToLower;
  if Tag.Style.TryGetValue('white-space', Temp) then
    Result.WhiteSpace := Temp.ToLower;
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

function TLayoutBox.MarginBoxWidth: Single;
begin
  Result := Style.Margin.Left + Style.BorderWidth + Style.Padding.Left +
    ContentWidth + Style.Padding.Right + Style.BorderWidth + Style.Margin.Right;
end;

function TLayoutBox.MarginBoxHeight: Single;
begin
  Result := Style.Margin.Top + Style.BorderWidth + Style.Padding.Top +
    ContentHeight + Style.Padding.Bottom + Style.BorderWidth + Style.Margin.Bottom;
end;

function TLayoutBox.ContentLeft: Single;
begin
  Result := Style.Margin.Left + Style.BorderWidth + Style.Padding.Left;
end;

function TLayoutBox.ContentTop: Single;
begin
  Result := Style.Margin.Top + Style.BorderWidth + Style.Padding.Top;
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

  // HTTP URL — async load
  if Src.ToLower.StartsWith('http') then
  begin
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
  Style := TComputedStyle.ForTag(Tag, ParentStyle);

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
    Kind := lbkFormControl
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

procedure TLayoutEngine.LayoutBlock(Box: TLayoutBox; AvailWidth: Single);
var
  ContentW, CursorY: Single;
  HasInline: Boolean;
begin
  // Calculate content width
  ContentW := AvailWidth - Box.Style.Margin.Left - Box.Style.Margin.Right -
    Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
  if Box.Style.ExplicitWidth > 0 then
    ContentW := Box.Style.ExplicitWidth;
  if ContentW < 0 then ContentW := 0;

  Box.ContentWidth := ContentW;
  CursorY := 0;

  // Check if we have any inline children
  HasInline := False;
  for var Child in Box.Children do
  begin
    if (Child.Kind = lbkText) or (Child.Kind = lbkInline) or
       (Child.Kind = lbkBR) or (Child.Kind = lbkImage) or
       (Child.Kind = lbkFormControl) then
    begin
      HasInline := True;
      Break;
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
    Box.ContentHeight := Box.Style.ExplicitHeight;
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
        Frag.X := CursorX;
        Frag.Y := CursorY;
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
        Frag.X := CursorX;
        Frag.Y := CursorY;
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
        Child.ContentWidth := AvailWidth;
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
      Child.X := CursorX;
      Child.Y := CursorY;
      for var GrandChild in Child.Children do
        ProcessInlineBox(GrandChild);
      // Update child bounds
      Child.ContentHeight := (CursorY + LineH) - Child.Y;
      Child.ContentWidth := AvailWidth;
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
    var TableContentW := AvailWidth - Box.Style.Margin.Left - Box.Style.Margin.Right -
      Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
    if Box.Style.ExplicitWidth > 0 then
      TableContentW := Box.Style.ExplicitWidth;

    // Equal column widths (simple approach)
    var CellBorderW := BorderW;
    var TotalBorder := CellBorderW * (NumCols + 1);
    var AvailForCols := TableContentW - TotalBorder;
    if AvailForCols < 0 then AvailForCols := 0;

    SetLength(ColWidths, NumCols);
    for var I := 0 to NumCols - 1 do
      ColWidths[I] := AvailForCols / NumCols;

    // Layout rows
    CursorY := BorderW;
    for var Row in Rows do
    begin
      RowH := 0;
      ColIdx := 0;
      var CellX := BorderW;

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

        // Layout cell children as block
        var CellCursorY: Single := 0;
        for var CellChild in Cell.Children do
        begin
          if (CellChild.Kind = lbkText) or (CellChild.Kind = lbkInline) then
          begin
            // Wrap in anonymous block for layout
            LayoutInlineChildren(Cell, CellContentW);
            CellCursorY := Cell.ContentHeight;
            Break; // InlineChildren handles all children
          end
          else
          begin
            LayoutBlock(CellChild, CellContentW);
            CellChild.X := 0;
            CellChild.Y := CellCursorY;
            CellCursorY := CellCursorY + CellChild.MarginBoxHeight;
          end;
        end;
        if CellCursorY > Cell.ContentHeight then
          Cell.ContentHeight := CellCursorY;

        Cell.X := CellX;
        Cell.Y := CursorY;
        Cell.ContentWidth := CellW;

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
  ContentW := AvailWidth - Box.Style.Margin.Left - Box.Style.Margin.Right -
    Box.Style.BorderWidth * 2 - Box.Style.Padding.Left - Box.Style.Padding.Right;
  if ContentW < 0 then ContentW := 0;

  // Leave space for bullet/number marker
  var MarkerW: Single := 20;
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
    // Offset all fragments by MarkerW
    for var Child in Box.Children do
    begin
      Child.X := Child.X + MarkerW;
      for var I := 0 to Child.Fragments.Count - 1 do
      begin
        var F := Child.Fragments[I];
        F.X := F.X + MarkerW;
        Child.Fragments[I] := F;
      end;
    end;
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
  W, H: Single;
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

  if Box.Style.ExplicitWidth > 0 then
  begin
    var Ratio := Box.Style.ExplicitWidth / W;
    W := Box.Style.ExplicitWidth;
    if Box.Style.ExplicitHeight <= 0 then
      H := H * Ratio;
  end;
  if Box.Style.ExplicitHeight > 0 then
  begin
    var Ratio := Box.Style.ExplicitHeight / H;
    H := Box.Style.ExplicitHeight;
    if Box.Style.ExplicitWidth <= 0 then
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
begin
  TN := '';
  if Assigned(Box.Tag) then
    TN := Box.Tag.TagName.ToLower;

  if TN = 'textarea' then
  begin
    Box.ContentWidth := Min(300, AvailWidth);
    Box.ContentHeight := 60;
  end
  else if TN = 'select' then
  begin
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
    Box.ContentHeight := 28;
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
      Box.ContentWidth := Min(200, AvailWidth);
      Box.ContentHeight := 24;
    end;
  end;
end;

procedure TLayoutEngine.LayoutHR(Box: TLayoutBox; AvailWidth: Single);
begin
  Box.ContentWidth := AvailWidth - Box.Style.Margin.Left - Box.Style.Margin.Right;
  Box.ContentHeight := 2;
end;

procedure TLayoutEngine.Layout(DOMRoot: THTMLTag; AvailWidth: Single);
begin
  FRoot.Free;
  FRoot := nil;

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
  FImageCache := TImageCache.Create;
  FImageCache.OnImageLoaded := OnImageLoaded;
  FParser := THTMLParser.Create;
  FLayoutEngine := TLayoutEngine.Create(FImageCache);
  FHTML.OnChange := FHTMLChange;
  FScrollY := 0;
  FContentHeight := 0;
  FNeedRelayout := True;
  FScrollBarWidth := 12;
  FIsLayoutting := False;
  FMouseDownOnScroll := False;
  Width := 320;
  Height := 240;
  ClipChildren := True;
  HitTest := True;
end;

destructor TTina4HTMLRender.Destroy;
begin
  FLayoutEngine.Free;
  FParser.Free;
  FImageCache.Free;
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
    var AvailW := Width;
    if ScrollBarVisible then
      AvailW := AvailW - FScrollBarWidth;
    FLayoutEngine.Layout(FParser.Root, AvailW);
    FContentHeight := FLayoutEngine.TotalHeight;
    ClampScroll;
    FNeedRelayout := False;
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
end;

procedure TTina4HTMLRender.PaintBox(Canvas: TCanvas; Box: TLayoutBox; OffX, OffY: Single);
var
  AbsX, AbsY, CX, CY: Single;
begin
  if Box.Style.Display = 'none' then Exit;

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
    lbkFormControl:
      PaintFormControl(Canvas, Box, AbsX + Box.ContentLeft, AbsY + Box.ContentTop);
    lbkHR:
      PaintHR(Canvas, Box, AbsX, AbsY);
    lbkListItem:
      PaintListMarker(Canvas, Box, AbsX, AbsY);
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
begin
  if Box.Style.BackgroundColor = TAlphaColors.Null then Exit;

  R := RectF(
    X + Box.Style.Margin.Left,
    Y + Box.Style.Margin.Top,
    X + Box.Style.Margin.Left + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right,
    Y + Box.Style.Margin.Top + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Top + Box.ContentHeight + Box.Style.Padding.Bottom
  );

  Canvas.Fill.Kind := TBrushKind.Solid;
  Canvas.Fill.Color := Box.Style.BackgroundColor;
  Canvas.FillRect(R, 1.0);
end;

procedure TTina4HTMLRender.PaintBorder(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
begin
  if Box.Style.BorderWidth <= 0 then Exit;

  // For blockquote-style left border only
  if Assigned(Box.Tag) and SameText(Box.Tag.TagName, 'blockquote') then
  begin
    var LX := X + Box.Style.Margin.Left;
    var TY := Y + Box.Style.Margin.Top;
    var BY := TY + Box.Style.BorderWidth * 2 + Box.Style.Padding.Top +
      Box.ContentHeight + Box.Style.Padding.Bottom;
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := Box.Style.BorderColor;
    Canvas.Stroke.Thickness := Box.Style.BorderWidth;
    Canvas.DrawLine(PointF(LX, TY), PointF(LX, BY), 1.0);
    Exit;
  end;

  // Table cell borders
  if (Box.Kind = lbkTableCell) or (Box.Kind = lbkTable) then
  begin
    R := RectF(
      X + Box.Style.Margin.Left,
      Y + Box.Style.Margin.Top,
      X + Box.Style.Margin.Left + Box.ContentWidth + Box.Style.Padding.Left + Box.Style.Padding.Right,
      Y + Box.Style.Margin.Top + Box.ContentHeight + Box.Style.Padding.Top + Box.Style.Padding.Bottom
    );
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := Box.Style.BorderColor;
    Canvas.Stroke.Thickness := Box.Style.BorderWidth;
    Canvas.DrawRect(R, 1.0);
    Exit;
  end;

  // General border
  R := RectF(
    X + Box.Style.Margin.Left + Box.Style.BorderWidth / 2,
    Y + Box.Style.Margin.Top + Box.Style.BorderWidth / 2,
    X + Box.Style.Margin.Left + Box.Style.BorderWidth * 2 +
      Box.Style.Padding.Left + Box.ContentWidth + Box.Style.Padding.Right - Box.Style.BorderWidth / 2,
    Y + Box.Style.Margin.Top + Box.Style.BorderWidth * 2 +
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
      Layout.WordWrap := Box.Style.WhiteSpace = 'pre';
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

procedure TTina4HTMLRender.PaintFormControl(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  R: TRectF;
  InputType, Val: string;
begin
  if not Assigned(Box.Tag) then Exit;
  var TN := Box.Tag.TagName.ToLower;

  if TN = 'textarea' then
  begin
    R := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := TAlphaColors.White;
    Canvas.FillRect(R, 1.0);
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColors.Gray;
    Canvas.Stroke.Thickness := 1;
    Canvas.DrawRect(R, 1.0);
  end
  else if TN = 'select' then
  begin
    R := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := TAlphaColors.White;
    Canvas.FillRect(R, 1.0);
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColors.Gray;
    Canvas.Stroke.Thickness := 1;
    Canvas.DrawRect(R, 1.0);
    // Draw dropdown arrow
    var AX := X + Box.ContentWidth - 12;
    var AY := Y + Box.ContentHeight / 2;
    Canvas.Fill.Color := TAlphaColors.Gray;
    // Simple triangle
    var Path := TPathData.Create;
    try
      Path.MoveTo(PointF(AX, AY - 3));
      Path.LineTo(PointF(AX + 6, AY - 3));
      Path.LineTo(PointF(AX + 3, AY + 3));
      Path.ClosePath;
      Canvas.FillPath(Path, 1.0);
    finally
      Path.Free;
    end;
  end
  else if TN = 'button' then
  begin
    R := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
    Canvas.Fill.Kind := TBrushKind.Solid;
    Canvas.Fill.Color := $FFE0E0E0;
    Canvas.FillRect(R, 3, 3, AllCorners, 1.0);
    Canvas.Stroke.Kind := TBrushKind.Solid;
    Canvas.Stroke.Color := TAlphaColors.Gray;
    Canvas.Stroke.Thickness := 1;
    Canvas.DrawRect(R, 3, 3, AllCorners, 1.0);

    Val := '';
    for var C in Box.Tag.Children do
      if C.TagName = '#text' then Val := Val + C.Text;
    if Val = '' then Val := Box.Tag.GetAttribute('value', 'Button');
    var Layout := TTextLayoutManager.DefaultTextLayout.Create;
    try
      Layout.BeginUpdate;
      Layout.Text := Val;
      Layout.Font.Size := Box.Style.FontSize;
      Layout.Color := TAlphaColors.Black;
      Layout.HorizontalAlign := TTextAlign.Center;
      Layout.TopLeft := PointF(X, Y + 4);
      Layout.MaxSize := PointF(Box.ContentWidth, Box.ContentHeight - 8);
      Layout.EndUpdate;
      Layout.RenderLayout(Canvas);
    finally
      Layout.Free;
    end;
  end
  else
  begin
    // input element
    InputType := Box.Tag.GetAttribute('type', 'text').ToLower;

    if InputType = 'checkbox' then
    begin
      R := RectF(X, Y, X + 16, Y + 16);
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := TAlphaColors.White;
      Canvas.FillRect(R, 1.0);
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Gray;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawRect(R, 1.0);
      if Box.Tag.HasAttribute('checked') then
      begin
        Canvas.Stroke.Color := TAlphaColors.Black;
        Canvas.Stroke.Thickness := 2;
        Canvas.DrawLine(PointF(X + 3, Y + 8), PointF(X + 6, Y + 12), 1.0);
        Canvas.DrawLine(PointF(X + 6, Y + 12), PointF(X + 13, Y + 3), 1.0);
      end;
    end
    else if InputType = 'radio' then
    begin
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := TAlphaColors.White;
      Canvas.FillEllipse(RectF(X, Y, X + 16, Y + 16), 1.0);
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Gray;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawEllipse(RectF(X, Y, X + 16, Y + 16), 1.0);
      if Box.Tag.HasAttribute('checked') then
      begin
        Canvas.Fill.Color := TAlphaColors.Black;
        Canvas.FillEllipse(RectF(X + 4, Y + 4, X + 12, Y + 12), 1.0);
      end;
    end
    else if InputType = 'button' then
    begin
      R := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := $FFE0E0E0;
      Canvas.FillRect(R, 3, 3, AllCorners, 1.0);
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Gray;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawRect(R, 3, 3, AllCorners, 1.0);
      Val := Box.Tag.GetAttribute('value', 'Button');
      var Layout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        Layout.BeginUpdate;
        Layout.Text := Val;
        Layout.Font.Size := Box.Style.FontSize;
        Layout.Color := TAlphaColors.Black;
        Layout.HorizontalAlign := TTextAlign.Center;
        Layout.TopLeft := PointF(X, Y + 4);
        Layout.MaxSize := PointF(Box.ContentWidth, Box.ContentHeight - 8);
        Layout.EndUpdate;
        Layout.RenderLayout(Canvas);
      finally
        Layout.Free;
      end;
    end
    else
    begin
      // text input
      R := RectF(X, Y, X + Box.ContentWidth, Y + Box.ContentHeight);
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := TAlphaColors.White;
      Canvas.FillRect(R, 1.0);
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Gray;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawRect(R, 1.0);

      Val := Box.Tag.GetAttribute('value', Box.Tag.GetAttribute('placeholder', ''));
      if Val <> '' then
      begin
        var Layout := TTextLayoutManager.DefaultTextLayout.Create;
        try
          Layout.BeginUpdate;
          Layout.Text := Val;
          Layout.Font.Size := 12;
          if Box.Tag.HasAttribute('placeholder') and not Box.Tag.HasAttribute('value') then
            Layout.Color := TAlphaColors.Gray
          else
            Layout.Color := TAlphaColors.Black;
          Layout.TopLeft := PointF(X + 4, Y + 4);
          Layout.MaxSize := PointF(Box.ContentWidth - 8, Box.ContentHeight - 8);
          Layout.EndUpdate;
          Layout.RenderLayout(Canvas);
        finally
          Layout.Free;
        end;
      end;
    end;
  end;
end;

procedure TTina4HTMLRender.PaintHR(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  LY: Single;
begin
  LY := Y + Box.Style.Margin.Top + 1;
  Canvas.Stroke.Kind := TBrushKind.Solid;
  Canvas.Stroke.Color := TAlphaColors.Lightgray;
  Canvas.Stroke.Thickness := 1;
  Canvas.DrawLine(
    PointF(X + Box.Style.Margin.Left, LY),
    PointF(X + Box.Style.Margin.Left + Box.ContentWidth, LY),
    1.0);
end;

procedure TTina4HTMLRender.PaintListMarker(Canvas: TCanvas; Box: TLayoutBox; X, Y: Single);
var
  Layout: TTextLayout;
  MarkerText: string;
  MarkerY: Single;
begin
  MarkerY := Y + Box.ContentTop;

  if Box.IsOrdered then
    MarkerText := IntToStr(Box.ListIndex) + '.'
  else
    MarkerText := #8226; // bullet

  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    Layout.Text := MarkerText;
    Layout.Font.Family := Box.Style.FontFamily;
    Layout.Font.Size := Box.Style.FontSize;
    Layout.Color := Box.Style.Color;
    Layout.HorizontalAlign := TTextAlign.Trailing;
    Layout.TopLeft := PointF(X + Box.ContentLeft, MarkerY);
    Layout.MaxSize := PointF(18, GetLineHeight(Box.Style));
    Layout.EndUpdate;
    Layout.RenderLayout(Canvas);
  finally
    Layout.Free;
  end;
end;

function GetLineHeight(const Style: TComputedStyle): Single;
begin
  Result := Style.FontSize * Style.LineHeight;
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

// ── Scrolling ──

procedure TTina4HTMLRender.MouseWheel(Shift: TShiftState; WheelDelta: Integer;
  var Handled: Boolean);
begin
  FScrollY := FScrollY - WheelDelta;
  ClampScroll;
  Repaint;
  Handled := True;
end;

procedure TTina4HTMLRender.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;
  if ScrollBarVisible and (X >= Width - FScrollBarWidth) then
  begin
    FMouseDownOnScroll := True;
    FScrollDragStart := Y;
    FScrollDragThumbStart := FScrollY;
  end;
end;

procedure TTina4HTMLRender.MouseMove(Shift: TShiftState; X, Y: Single);
var
  Ratio, ThumbH, Delta: Single;
begin
  inherited;
  if FMouseDownOnScroll and ScrollBarVisible then
  begin
    Ratio := Height / FContentHeight;
    ThumbH := Max(20, Height * Ratio);
    Delta := Y - FScrollDragStart;
    var TrackRange := Height - ThumbH;
    if TrackRange > 0 then
    begin
      var ScrollRange := FContentHeight - Height;
      FScrollY := FScrollDragThumbStart + (Delta / TrackRange) * ScrollRange;
      ClampScroll;
      Repaint;
    end;
  end;
end;

procedure TTina4HTMLRender.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Single);
begin
  inherited;
  FMouseDownOnScroll := False;
end;

procedure TTina4HTMLRender.Resize;
begin
  inherited;
  FNeedRelayout := True;
  Repaint;
end;

end.
