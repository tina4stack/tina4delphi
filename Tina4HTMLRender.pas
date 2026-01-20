unit Tina4HtmlRender;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.Types, FMX.Types, FMX.Controls, FMX.Graphics, FMX.TextLayout,
  System.UITypes, System.Math;

type
  THTMLTag = class
  public
    TagName: string;
    Text: string;
    Style: TDictionary<string, string>;
    Attributes: TDictionary<string, string>;
    Children: TList<THTMLTag>;
    constructor Create;
    destructor Destroy; override;
  end;

  THTMLParser = class
  private
    FRoot: THTMLTag;
    FDebug: string;
    procedure ParseStyleAttribute(const StyleAttr: string; StyleDict: TDictionary<string, string>);
    procedure ParseTagAttributes(const TagStr: string; StyleDict, AttrDict: TDictionary<string, string>);
    function ParseRecursive(const HTML: string; var Pos: Integer; const ExpectedCloseTag: string = ''): THTMLTag;
    function ExtractTagName(const TagStr: string): string;
    function IsVoidTag(const TagName: string): Boolean;
    procedure DebugMsg(const Msg: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const HTML: string);
    property Root: THTMLTag read FRoot;
    property Debug: string read FDebug;
  end;

  TTina4HTMLRender = class(TControl)
  private
    FHTML: TStringList;
    FDebug: TStringList;
    procedure SetHTML(const Value: TStringList);
    function GetHTML: TStringList;
    function ParseCSSColor(const ColorStr: string): TAlphaColor;
    procedure FHTMLChange(Sender: TObject);
    procedure RenderTag(Canvas: TCanvas; Tag: THTMLTag;
  var YPos, XPos: Single; ParentStyle: TDictionary<string, string>;
  IsInlineContext: Boolean = False; Indent: Single = 0);
    procedure DebugMsg(const Msg: string);
  protected
    procedure Paint; override;
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
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TTina4HTMLRender]);
end;

function IsBlockLevelTag(const ATag: string): Boolean;
begin
  Result :=
    SameText(ATag, 'p') or SameText(ATag, 'div') or
    SameText(ATag, 'h1') or SameText(ATag, 'h2') or SameText(ATag, 'h3') or
    SameText(ATag, 'h4') or SameText(ATag, 'h5') or SameText(ATag, 'h6') or
    SameText(ATag, 'ul') or SameText(ATag, 'ol') or
    SameText(ATag, 'li') or SameText(ATag, 'hr') or
    SameText(ATag, 'blockquote') or SameText(ATag, 'pre');
end;

// ────────────────────────────────────────────────
// THTMLTag
// ────────────────────────────────────────────────

constructor THTMLTag.Create;
begin
  Style := TDictionary<string, string>.Create;
  Attributes := TDictionary<string, string>.Create;
  Children := TList<THTMLTag>.Create;
end;

destructor THTMLTag.Destroy;
begin
  for var Child in Children do Child.Free;
  Children.Free;
  Style.Free;
  Attributes.Free;
  inherited;
end;

// ────────────────────────────────────────────────
// THTMLParser
// ────────────────────────────────────────────────

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

procedure THTMLParser.DebugMsg(const Msg: string);
begin
  FDebug := FDebug + Msg + sLineBreak;
end;

function THTMLParser.ExtractTagName(const TagStr: string): string;
var
  i: Integer;
begin
  Result := '';
  if (Length(TagStr) < 2) or (TagStr[1] <> '<') then Exit;
  i := 2;
  while (i <= Length(TagStr)) and not CharInSet(TagStr[i], [' ', '/', '>']) do
    Inc(i);
  Result := Copy(TagStr, 2, i - 2).Trim.ToLower;
end;

function THTMLParser.IsVoidTag(const TagName: string): Boolean;
begin
  Result := SameText(TagName, 'br') or SameText(TagName, 'hr') or
            SameText(TagName, 'img') or SameText(TagName, 'input') or
            SameText(TagName, 'meta') or SameText(TagName, 'link');
end;

procedure THTMLParser.ParseStyleAttribute(const StyleAttr: string; StyleDict: TDictionary<string, string>);
var
  Pairs: TArray<string>;
  Pair: string;
  KeyValue: TArray<string>;
begin
  Pairs := StyleAttr.Split([';']);
  for Pair in Pairs do
  begin
    var APair := Pair.Trim;
    if APair = '' then Continue;
    KeyValue := APair.Split([':'], 2);
    if Length(KeyValue) = 2 then
      StyleDict.AddOrSetValue(KeyValue[0].Trim.ToLower, KeyValue[1].Trim);
  end;
end;

procedure THTMLParser.ParseTagAttributes(const TagStr: string; StyleDict, AttrDict: TDictionary<string, string>);
var
  Start: Integer;
  AttrPart: string;
begin
  StyleDict.Clear;
  AttrDict.Clear;
  Start := Pos(' ', TagStr) + 1;
  if Start <= 1 then Exit;
  AttrPart := Copy(TagStr, Start, MaxInt);

  // Very basic attribute parser – improve later if needed
  var Parts := AttrPart.Split([' ']);
  for var Part in Parts do
  begin
    var EqPos := Part.IndexOf('=');
    if EqPos <= 0 then Continue;
    var Key := Part.Substring(0, EqPos).Trim.ToLower;
    var Value := Part.Substring(EqPos + 1).DequotedString('"').Trim;
    if Key = 'style' then
      ParseStyleAttribute(Value, StyleDict)
    else
      AttrDict.AddOrSetValue(Key, Value);
  end;
end;

function THTMLParser.ParseRecursive(const HTML: string; var Pos: Integer; const ExpectedCloseTag: string = ''): THTMLTag;
var
  Tag: THTMLTag;
  TextBuilder: TStringBuilder;
  TagName: string;
  FullTag: string;
  IsVoid: Boolean;
  Child: THTMLTag;
  NameStart, NameLength: Integer;
  CloseEnd: Integer;
  FullClose: string;
  CloseNameRaw: string;
  CloseName: string;
  TagEnd: Integer;
  idx: Integer;
begin
  Result := nil;
  TextBuilder := TStringBuilder.Create;
  Tag := nil;
  DebugMsg('ParseRecursive entered at pos ' + IntToStr(Pos));
  try
    while Pos <= Length(HTML) do
    begin
      // Plain text
      if HTML[Pos] <> '<' then
      begin
        TextBuilder.Append(HTML[Pos]);
        Inc(Pos);
        Continue;
      end;
      // Flush text before tag
      if TextBuilder.Length > 0 then
      begin
        var TextStr := TextBuilder.ToString;
        TextBuilder.Clear;
        if Trim(TextStr) <> '' then  // Skip whitespace-only nodes
        begin
          var TextNode := THTMLTag.Create;
          TextNode.TagName := '#text';
          TextNode.Text := TextStr;
          if Tag = nil then
          begin
            Result := TextNode;
            DebugMsg('Top-level text node created');
            Exit;
          end
          else
            Tag.Children.Add(TextNode);
        end;
      end;
      // Closing tag handling
      if (Pos + 1 <= Length(HTML)) and (HTML[Pos + 1] = '/') then
      begin
        idx := HTML.IndexOf('>', Pos - 1);
        if idx = -1 then
        begin
          DebugMsg('Invalid closing tag - no > found');
          Inc(Pos);  // Skip the '<'
          Continue;
        end;
        CloseEnd := idx + 1;  // Convert to 1-based
        if CloseEnd <= Pos then
        begin
          DebugMsg('Invalid closing tag length <=0 - skipping');
          Pos := CloseEnd + 1;
          Continue;
        end;
        FullClose := Copy(HTML, Pos, CloseEnd - Pos + 1);
        NameStart := Pos + 2;
        NameLength := CloseEnd - NameStart;
        if NameLength <= 0 then
        begin
          DebugMsg('Invalid closing tag length <=0 - skipping');
          Pos := CloseEnd + 1;
          Continue;
        end;
        CloseNameRaw := Copy(HTML, NameStart, NameLength);
        CloseName := Trim(CloseNameRaw).ToLower;
        DebugMsg('Closing tag: [' + FullClose + '] → name: [' + CloseName + ']');
        if (ExpectedCloseTag <> '') and SameText(CloseName, ExpectedCloseTag) then
        begin
          Pos := CloseEnd + 1;
          DebugMsg('Matching close found for ' + ExpectedCloseTag);
          Result := Tag;
          Exit;
        end
        else
        begin
          DebugMsg('Mismatched closing - skipping');
          Pos := CloseEnd + 1;
          Continue;
        end;
      end;
      // Opening tag
      idx := HTML.IndexOf('>', Pos - 1);
      if idx = -1 then
      begin
        DebugMsg('Invalid opening tag - no > found');
        Inc(Pos);  // Skip the '<' to avoid infinite loop
        Continue;
      end;
      TagEnd := idx + 1;  // Convert to 1-based
      if TagEnd <= Pos then
      begin
        DebugMsg('Invalid opening tag - > before or at Pos');
        Inc(Pos);
        Continue;
      end;
      FullTag := Copy(HTML, Pos, TagEnd - Pos + 1);
      Pos := TagEnd + 1;
      TagName := ExtractTagName(FullTag).ToLower;
      if TagName = '' then Continue;
      DebugMsg('Opening tag found: ' + TagName);
      if Tag = nil then
      begin
        Tag := THTMLTag.Create;
        Tag.TagName := TagName;
        ParseTagAttributes(FullTag, Tag.Style, Tag.Attributes);
      end;
      IsVoid := IsVoidTag(TagName);
      if IsVoid then
      begin
        Result := Tag;
        Exit;
      end;
      // Immediate text after opening tag
      TextBuilder.Clear;
      while (Pos <= Length(HTML)) and (HTML[Pos] <> '<') do
      begin
        TextBuilder.Append(HTML[Pos]);
        Inc(Pos);
      end;
      if TextBuilder.Length > 0 then
      begin
        var TextStr := TextBuilder.ToString;
        TextBuilder.Clear;
        if Trim(TextStr) <> '' then  // Skip whitespace-only
        begin
          var TextNode := THTMLTag.Create;
          TextNode.TagName := '#text';
          TextNode.Text := TextStr;
          Tag.Children.Add(TextNode);
          DebugMsg('Immediate text captured after <' + TagName + '>');
        end;
      end;
      // Recurse children
      repeat
        Child := ParseRecursive(HTML, Pos, TagName);
        if Assigned(Child) then
          Tag.Children.Add(Child);
      until not Assigned(Child) or (Pos > Length(HTML));
      Result := Tag;
      Exit;
    end;
    // Leftover text
    if TextBuilder.Length > 0 then
    begin
      var TextStr := TextBuilder.ToString;
      TextBuilder.Clear;
      if Trim(TextStr) <> '' then  // Skip whitespace-only
      begin
        var TextNode := THTMLTag.Create;
        TextNode.TagName := '#text';
        TextNode.Text := TextStr;
        if Tag <> nil then
          Tag.Children.Add(TextNode)
        else
          Result := TextNode;
      end;
    end;
  finally
    TextBuilder.Free;
    DebugMsg('ParseRecursive exiting at pos ' + IntToStr(Pos));
  end;
end;
procedure THTMLParser.Parse(const HTML: string);
var
  Pos: Integer;
  Clean: string;
begin
  FDebug := '';
  FRoot.Children.Clear;
  Clean := HTML.Trim;
  if Clean = '' then
  begin
    DebugMsg('Empty HTML - nothing to parse');
    Exit;
  end;

  DebugMsg('Starting parse of length ' + IntToStr(Length(Clean)));
  Pos := 1;
  var Child := ParseRecursive(Clean, Pos);
  while Assigned(Child) do
  begin
    FRoot.Children.Add(Child);
    Child := ParseRecursive(Clean, Pos);
  end;
  DebugMsg('Parse finished - root has ' + IntToStr(FRoot.Children.Count) + ' children');
end;

// ────────────────────────────────────────────────
// TTina4HTMLRender
// ────────────────────────────────────────────────

constructor TTina4HTMLRender.Create(AOwner: TComponent);
begin
  inherited;
  FHTML := TStringList.Create;
  FDebug := TStringList.Create;
  FHTML.OnChange := FHTMLChange;
  Width := 320;
  Height := 240;
end;

destructor TTina4HTMLRender.Destroy;
begin
  FHTML.Free;
  FDebug.Free;
  inherited;
end;

procedure TTina4HTMLRender.FHTMLChange(Sender: TObject);
begin
  Repaint;
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

procedure TTina4HTMLRender.DebugMsg(const Msg: string);
begin
  FDebug.Add(Msg);
end;

function TTina4HTMLRender.ParseCSSColor(const ColorStr: string): TAlphaColor;
var
  s: string;
  r,g,b: Byte;
  Rec: TAlphaColorRec;
begin
  Result := TAlphaColors.Black;
  s := ColorStr.Trim.ToLower;

  if s = 'red' then Exit(TAlphaColors.Red);
  if s = 'blue' then Exit(TAlphaColors.Blue);
  if s = 'green' then Exit(TAlphaColors.Green);
  if s = 'black' then Exit(TAlphaColors.Black);
  if s = 'white' then Exit(TAlphaColors.White);

  if s.StartsWith('#') then
  begin
    s := s.Substring(1);
    if Length(s) = 3 then
      s := s[Low(s)]+s[Low(s)] + s[Low(s)+1]+s[Low(s)+1] + s[Low(s)+2]+s[Low(s)+2];
    if Length(s) <> 6 then Exit;

    try
      r := StrToInt('$' + s.Substring(0,2));
      g := StrToInt('$' + s.Substring(2,2));
      b := StrToInt('$' + s.Substring(4,2));
      Rec.A := 255;
      Rec.R := r;
      Rec.G := g;
      Rec.B := b;
      Result := TAlphaColor(Rec);
    except
    end;
  end;
end;

procedure TTina4HTMLRender.RenderTag(Canvas: TCanvas; Tag: THTMLTag;
  var YPos, XPos: Single; ParentStyle: TDictionary<string, string>;
  IsInlineContext: Boolean = False; Indent: Single = 0);
var
  Combined: TDictionary<string, string>;
  Layout: TTextLayout;
  fs: Single;
  col: TAlphaColor;
  fam, temp: string;
  fstyle: TFontStyles;
  isBlock: Boolean;
  localX, localY: Single;
  lh, lh_single: Single;
begin
  if not Assigned(Tag) or not Assigned(Canvas) then Exit;
  Combined := TDictionary<string, string>.Create;
  try
    for var p in ParentStyle do Combined.AddOrSetValue(p.Key, p.Value);
    for var p in Tag.Style do Combined.AddOrSetValue(p.Key, p.Value);
    isBlock := IsBlockLevelTag(Tag.TagName);
    localX := XPos;
    localY := YPos;
    if isBlock and not IsInlineContext then
    begin
      localY := localY + 8;
      localX := Indent;
    end;
    if Tag.TagName = '#text' then
    begin
      var CleanText := Tag.Text;
      if CleanText = '' then Exit;
      DebugMsg('Rendering text: "' + Copy(CleanText, 1, 40) + '..."');
      Layout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        Layout.BeginUpdate;
        Layout.Text := CleanText;
        if not Combined.TryGetValue('font-family', fam) then fam := 'Segoe UI';
        Layout.Font.Family := fam;
        if not Combined.TryGetValue('font-size', temp) then temp := '14';
        fs := StrToFloatDef(temp.Replace('px', '').Replace('pt', ''), 14);
        Layout.Font.Size := fs;
        if not Combined.TryGetValue('color', temp) then temp := 'black';
        col := ParseCSSColor(temp);
        Layout.Color := col;
        fstyle := [];
        if Combined.TryGetValue('font-weight', temp) and SameText(temp, 'bold') then
          Include(fstyle, TFontStyle.fsBold);
        if Combined.TryGetValue('font-style', temp) and SameText(temp, 'italic') then
          Include(fstyle, TFontStyle.fsItalic);
        Layout.Font.Style := fstyle;
        Layout.HorizontalAlign := TTextAlign.Leading;
        Layout.TopLeft := PointF(localX, localY);
        Layout.Trimming := TTextTrimming.None;
        Layout.MaxSize := PointF(Width - localX - 10, Height - localY + fs * 20);
        Layout.WordWrap := False;  // Calculate single-line height
        Layout.EndUpdate;
        lh_single := Layout.Height;
        Layout.BeginUpdate;
        Layout.WordWrap := True;
        Layout.EndUpdate;
        lh := Layout.Height;
        Layout.RenderLayout(Canvas);
        localX := localX + Layout.Width;
        if lh > lh_single + 1 then  // Adjusted for FMX font metrics
          localY := localY + lh;
        if not IsInlineContext then
          localY := localY + lh + 2;
      finally
        Layout.Free;
      end;
    end
    else if SameText(Tag.TagName, 'br') then
    begin
      localY := localY + fs * 1.2;
      localX := Indent;
    end
    else if SameText(Tag.TagName, 'hr') then
    begin
      localY := localY + 10;
      Canvas.Stroke.Kind := TBrushKind.Solid;
      Canvas.Stroke.Color := TAlphaColors.Black;
      Canvas.Stroke.Thickness := 1;
      Canvas.DrawLine(PointF(Indent + 10, localY), PointF(Width - 10, localY), 1);
      localY := localY + 12;
      localX := Indent;
    end
    else if Tag.TagName.StartsWith('h') and (Length(Tag.TagName) = 2) then
    begin
      var lvl := StrToIntDef(Tag.TagName[2], 3);
      fs := 28 - (lvl * 4);
      Combined.AddOrSetValue('font-size', FloatToStr(fs));
      Combined.AddOrSetValue('font-weight', 'bold');
      localY := localY + 12;
      localX := Indent;
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, Indent);
      localY := localY + 16;
      localX := Indent;
    end
    else if (Tag.TagName = 'b') or (Tag.TagName = 'strong') then
    begin
      Combined.AddOrSetValue('font-weight', 'bold');
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, Indent);
    end
    else if (Tag.TagName = 'i') or (Tag.TagName = 'em') then
    begin
      Combined.AddOrSetValue('font-style', 'italic');
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, Indent);
    end
    else if Tag.TagName = 'a' then
    begin
      Combined.AddOrSetValue('color', '#0000EE');
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, Indent);
    end
    else if Tag.TagName = 'li' then
    begin
      localX := Indent + 20;
      var blt := TTextLayoutManager.DefaultTextLayout.Create;
      try
        blt.Text := '• ';
        blt.Font.Size := 14;
        blt.TopLeft := PointF(localX - 20, localY);
        blt.RenderLayout(Canvas);
      finally
        blt.Free;
      end;
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, localX);
      localY := localY + 18;
      localX := Indent;
    end
    else if (Tag.TagName = 'ul') or (Tag.TagName = 'ol') then
    begin
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, False, Indent + 20);
      localX := Indent;
    end
    else if SameText(Tag.TagName, 'pre') then
    begin
      Combined.AddOrSetValue('font-family', 'Courier New');
      for var ch in Tag.Children do
      begin
        RenderTag(Canvas, ch, localY, localX, Combined, True, Indent);
        if Pos(sLineBreak, ch.Text) > 0 then localY := localY + fs * 1.2;
      end;
      localY := localY + 10;
    end
    else if SameText(Tag.TagName, 'blockquote') then
    begin
      localX := Indent + 40;
      Canvas.Fill.Kind := TBrushKind.Solid;
      Canvas.Fill.Color := TAlphaColors.Lightgray;
      Canvas.FillRect(RectF(localX - 10, localY, Width - 10, localY + 100), 0, 0, AllCorners, 0.5);
      for var ch in Tag.Children do
        RenderTag(Canvas, ch, localY, localX, Combined, True, localX);
      localY := localY + 10;
    end
    else if SameText(Tag.TagName, 'img') then
    begin
      var alt: string;
      if not Tag.Attributes.TryGetValue('alt', alt) then alt := '';
      Layout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        Layout.Text := '[Image: ' + alt + ']';
        Layout.Font.Size := 14;
        Layout.Color := TAlphaColors.Gray;
        Layout.TopLeft := PointF(localX, localY);
        Layout.MaxSize := PointF(Width - localX - 10, 9999);
        Layout.RenderLayout(Canvas);
        localY := localY + 100;
      finally
        Layout.Free;
      end;
    end
    else
    begin
      for var ch in Tag.Children do
      begin
        var childBlock := IsBlockLevelTag(ch.TagName);
        RenderTag(Canvas, ch, localY, localX, Combined, not childBlock, Indent);
        if childBlock then
        begin
          localY := YPos + 10;
          localX := Indent;
        end;
      end;
      if isBlock then localY := localY + 10;
    end;
    YPos := localY;
    XPos := localX;
  finally
    Combined.Free;
  end;
end;

procedure TTina4HTMLRender.Paint;
var
  Parser: THTMLParser;
  y, x: Single;
  baseStyle: TDictionary<string, string>;
begin
  inherited;

  if Canvas = nil then
  begin
    DebugMsg('Paint: Canvas is nil');
    Exit;
  end;

  DebugMsg('Paint called - HTML length: ' + IntToStr(FHTML.Text.Length));

  Parser := THTMLParser.Create;
  baseStyle := TDictionary<string, string>.Create;
  try
    Parser.Parse(FHTML.Text);
    FDebug.Text := FDebug.Text + Parser.Debug;

    y := 8;
    x := 8;

    Canvas.BeginScene;
    try
      // Draw background so we see if nothing renders
      Canvas.Fill.Color := TAlphaColors.White;
      Canvas.FillRect(LocalRect, 1.0);

      for var child in Parser.Root.Children do
        RenderTag(Canvas, child, y, x, baseStyle, False);
    finally
      Canvas.EndScene;
    end;
  finally
    Parser.Free;
    baseStyle.Free;
  end;
end;

end.
