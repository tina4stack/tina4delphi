unit Tina4HtmlRender;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.Types, FMX.Types, FMX.Controls, FMX.Graphics, FMX.TextLayout, System.UITypes, System.Math;

type
  THTMLTag = class
  public
    TagName: string;
    Text: string;
    Style: TDictionary<string, string>;
    Children: TList<THTMLTag>;
    constructor Create;
    destructor Destroy; override;
  end;

  THTMLParser = class
  private
    FRoot: THTMLTag;
    FDebug: String;
    procedure ParseStyleAttribute(const StyleAttr: string; StyleDict: TDictionary<string, string>);
    function ParseRecursive(const HTML: string; var Pos: Integer): THTMLTag;
    procedure OutputDebugString(AMessage: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Parse(const HTML: string);
    property Root: THTMLTag read FRoot;
    property Debug: String read FDebug write FDebug;
  end;

  TTina4HTMLRender = class(TControl)
  private
    FHTML: TStringList;
    FDebug: TStringList;
    procedure SetHTML(const Value: TStringList);
    function GetHTML: TStringList;
    function ParseCSSColor(const ColorStr: string): TAlphaColor;
    procedure FHTMLChange(Sender: TObject);
    procedure RenderTag(Canvas: TCanvas; Tag: THTMLTag; var YPos: Single;
      ParentStyle: TDictionary<string, string>);
    procedure OutputDebugString(AMessage: String);
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
  RegisterComponents('Tina4Delphi', [TTina4HTMLRender]);
end;

// THTMLTag implementation
constructor THTMLTag.Create;
begin
  Style := TDictionary<string, string>.Create;
  Children := TList<THTMLTag>.Create;
end;

destructor THTMLTag.Destroy;
begin
  for var Child in Children do
    Child.Free;
  Children.Free;
  Style.Free;
  inherited;
end;

// THTMLParser implementation

constructor THTMLParser.Create;
begin
  FRoot := THTMLTag.Create;
  FRoot.TagName := 'root';
end;

destructor THTMLParser.Destroy;
begin
  FRoot.Free;
  inherited;
end;

procedure THTMLParser.OutputDebugString(AMessage: String);
begin
  FDebug := FDebug + AMessage+ #10#13;
end;

procedure THTMLParser.ParseStyleAttribute(const StyleAttr: string; StyleDict: TDictionary<string, string>);
var
  StylePairs: TArray<string>;
  Pair: string;
  KeyValue: TArray<string>;
begin
  StylePairs := StyleAttr.Split([';']);
  for Pair in StylePairs do
  begin

    if Pair.Trim <> '' then
    begin
      KeyValue := Pair.Trim.Split([':']);
      if Length(KeyValue) = 2 then
        StyleDict.AddOrSetValue(KeyValue[0].Trim.ToLower, KeyValue[1].Trim);
    end;
  end;
end;

function THTMLParser.ParseRecursive(const HTML: string; var Pos: Integer): THTMLTag;
var
  Tag: THTMLTag;
  TagStart, TagEnd: string;
  TagName, StyleAttr: string;
  StartIdx, EndIdx: Integer;
  TextBuilder: TStringBuilder;
begin
  Result := nil;
  Tag := THTMLTag.Create;
  TextBuilder := TStringBuilder.Create;
  try
    while Pos <= Length(HTML) do
    begin
      if (Pos < Length(HTML)) and (HTML[Pos] = '<') then
      begin
        if HTML[Pos + 1] = '/' then
        begin
          // Closing tag
          EndIdx := HTML.IndexOf('>', Pos);
          if EndIdx = -1 then
          begin
            {$IFDEF DEBUG}
            OutputDebugString('ParseRecursive: Missing > in closing tag');
            {$ENDIF}
            Break;
          end;
          TagEnd := Copy(HTML, Pos, EndIdx - Pos + 1);
          TagName := TagEnd.Substring(2, TagEnd.Length - 3).ToLower;
          if TagName = Tag.TagName then
          begin
            Pos := EndIdx + 1;
            Tag.Text := TextBuilder.ToString.Trim;
            if (Tag.Text <> '') or (Tag.Children.Count > 0) then
              Result := Tag
            else
              Tag.Free;
            Exit;
          end
          else
          begin
            {$IFDEF DEBUG}
            OutputDebugString(PChar('ParseRecursive: Mismatched closing tag: ' + TagName));
            {$ENDIF}
            Pos := EndIdx + 1;
          end;
        end
        else
        begin
          // Opening tag
          StartIdx := Pos;
          EndIdx := HTML.IndexOf('>', Pos);
          if EndIdx = -1 then
          begin
            {$IFDEF DEBUG}
            OutputDebugString('ParseRecursive: Missing > in opening tag');
            {$ENDIF}
            Break;
          end;
          TagStart := Copy(HTML, StartIdx, EndIdx - StartIdx + 1);
          Pos := EndIdx + 1;

          // Extract tag name
          var SpaceIdx := TagStart.IndexOfAny([' ', '>']);
          TagName := TagStart.Substring(1, SpaceIdx - 1).ToLower;
          if TagName.IsEmpty then
            TagName := TagStart.Substring(1, TagStart.Length - 2).ToLower;

          {$IFDEF DEBUG}
          OutputDebugString(PChar('ParseRecursive: Found tag: ' + TagName));
          {$ENDIF}

          if (TagName = 'p') or (TagName = 'span') or (TagName = 'b') or (TagName = 'i') then
          begin
            Tag.TagName := TagName;

            // Extract style attribute
            if TagStart.Contains('style=') then
            begin
              StartIdx := TagStart.IndexOf('style="') + 7;
              EndIdx := TagStart.IndexOf('"', StartIdx);
              if EndIdx > StartIdx then
              begin
                StyleAttr := Copy(TagStart, StartIdx + 1, EndIdx - StartIdx);
                ParseStyleAttribute(StyleAttr, Tag.Style);
                {$IFDEF DEBUG}
                OutputDebugString(PChar('ParseRecursive: Style parsed: ' + StyleAttr));
                {$ENDIF}
              end;
            end;

            // Implicit styles for b and i
            if TagName = 'b' then
              Tag.Style.AddOrSetValue('font-weight', 'bold');
            if TagName = 'i' then
              Tag.Style.AddOrSetValue('font-style', 'italic');

            // Recursively parse children
            var Child: THTMLTag;
            while Pos <= Length(HTML) do
            begin
              Child := ParseRecursive(HTML, Pos);
              if Assigned(Child) then
              begin
                if Child.TagName = Tag.TagName then
                begin
                  // Found closing tag, return Tag
                  Tag.Text := TextBuilder.ToString.Trim;
                  TextBuilder.Clear;
                  if (Tag.Text <> '') or (Tag.Children.Count > 0) then
                    Result := Tag
                  else
                    Tag.Free;
                  Exit;
                end
                else
                  Tag.Children.Add(Child);
              end
              else
                Break;
            end;
          end
          else
          begin
            {$IFDEF DEBUG}
            OutputDebugString(PChar('ParseRecursive: Skipping unsupported tag: ' + TagName));
            {$ENDIF}
            Pos := EndIdx + 1;
          end;
        end;
      end
      else
      begin
        TextBuilder.Append(HTML[Pos]);
        Inc(Pos);
      end;
    end;

    // Handle unclosed tags
    Tag.Text := TextBuilder.ToString.Trim;
    if (Tag.Text <> '') or (Tag.Children.Count > 0) then
      Result := Tag
    else
      Tag.Free;
  finally
    TextBuilder.Free;
  end;
end;

procedure THTMLParser.Parse(const HTML: string);
var
  Pos: Integer;
  CleanHTML: string;
begin
  FRoot.Children.Clear;
  CleanHTML := HTML.Trim;
  if CleanHTML = '' then
  begin
    {$IFDEF DEBUG}
    OutputDebugString('Parse: Empty HTML input');
    {$ENDIF}
    Exit;
  end;

  Pos := 1;
  while Pos <= Length(CleanHTML) do
  begin
    var Child := ParseRecursive(CleanHTML, Pos);
    if Assigned(Child) and (Child.TagName <> '') then
    begin
      FRoot.Children.Add(Child);
      {$IFDEF DEBUG}
      OutputDebugString(PChar('Parse: Added tag: ' + Child.TagName));
      {$ENDIF}
    end;
    Inc(Pos);
  end;

  {$IFDEF DEBUG}
  OutputDebugString(PChar('Parse: Total tags parsed: ' + IntToStr(FRoot.Children.Count)));
  {$ENDIF}
end;

// TTina4HTMLRender implementation
constructor TTina4HTMLRender.Create(AOwner: TComponent);
begin
  inherited;
  FHTML := TStringList.Create;
  FDebug := TStringList.Create;
  FHTML.OnChange := FHTMLChange;
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

procedure TTina4HTMLRender.OutputDebugString(AMessage: String);
begin
  FDebug.Add(AMessage);
end;

procedure TTina4HTMLRender.SetHTML(const Value: TStringList);
begin
  FHTML.Assign(Value);
  FHTML.OnChange := FHTMLChange; // Ensure new TStringList has OnChange handler
  Repaint;
end;

function TTina4HTMLRender.ParseCSSColor(const ColorStr: string): TAlphaColor;
var
  CleanColor: string;
  R, G, B: Byte;
  Hex: string;
  Color: TAlphaColor;
begin
  Result := TAlphaColors.Black; // Default
  CleanColor := ColorStr.Trim.ToLower;

  if CleanColor = 'red' then
    Result := TAlphaColors.Red
  else if CleanColor = 'blue' then
    Result := TAlphaColors.Blue
  else if CleanColor = 'black' then
    Result := TAlphaColors.Black
  else if CleanColor = 'white' then
    Result := TAlphaColors.White
  else if CleanColor = 'green' then
    Result := TAlphaColors.Green
  else if CleanColor.StartsWith('#') then
  begin
    Hex := CleanColor.Substring(1);
    if (Length(Hex) = 6) or (Length(Hex) = 3) then
    try
      if Length(Hex) = 3 then
        Hex := Hex[1] + Hex[1] + Hex[2] + Hex[2] + Hex[3] + Hex[3];
      R := StrToIntDef('$' + Hex.Substring(0, 2), 0);
      G := StrToIntDef('$' + Hex.Substring(2, 2), 0);
      B := StrToIntDef('$' + Hex.Substring(4, 2), 0);
      TAlphaColorRec(Color).A := 255;
      TAlphaColorRec(Color).R := R;
      TAlphaColorRec(Color).G := G;
      TAlphaColorRec(Color).B := B;
      Result := Color;
    except
      Result := TAlphaColors.Black;
    end;
  end
  else if CleanColor.StartsWith('rgb(') and CleanColor.EndsWith(')') then
  begin
    try
      CleanColor := CleanColor.Substring(4, CleanColor.Length - 5);
      var RGBValues := CleanColor.Split([',']);
      if Length(RGBValues) = 3 then
      begin
        R := StrToIntDef(RGBValues[0].Trim, 0);
        G := StrToIntDef(RGBValues[1].Trim, 0);
        B := StrToIntDef(RGBValues[2].Trim, 0);
        if (R >= 0) and (R <= 255) and (G >= 0) and (G <= 255) and (B >= 0) and (B <= 255) then
        begin
          TAlphaColorRec(Color).A := 255;
          TAlphaColorRec(Color).R := R;
          TAlphaColorRec(Color).G := G;
          TAlphaColorRec(Color).B := B;
          Result := Color;
        end;
      end;
    except
      Result := TAlphaColors.Black;
    end;
  end;
end;

procedure TTina4HTMLRender.RenderTag(Canvas: TCanvas; Tag: THTMLTag; var YPos: Single; ParentStyle: TDictionary<string, string>);
var
  TextLayout: TTextLayout;
  FontSize: Single;
  Color: TAlphaColor;
  CombinedStyle: TDictionary<string, string>;
  IsBlockTag: Boolean;
  XPos: Single;
begin
  if (Tag = nil) or (Canvas = nil) then
  begin
    // Debug: Log null tag or canvas
    {$IFDEF DEBUG}
    OutputDebugString('RenderTag: Tag or Canvas is nil');
    {$ENDIF}
    Exit;
  end;

  CombinedStyle := TDictionary<string, string>.Create;
  try
    // Merge parent and tag styles
    for var Pair in ParentStyle do
      CombinedStyle.AddOrSetValue(Pair.Key, Pair.Value);
    if Assigned(Tag.Style) then
      for var Pair in Tag.Style do
        CombinedStyle.AddOrSetValue(Pair.Key, Pair.Value);

    // Determine block vs inline tag
    IsBlockTag := Tag.TagName.ToLower = 'p';

    if Tag.Children.Count > 0 then
    begin
      // Recurse for children
      for var Child in Tag.Children do
        RenderTag(Canvas, Child, YPos, CombinedStyle);
      // Add spacing for block tags
      if IsBlockTag then
        YPos := YPos + 10;
    end
    else if Tag.Text <> '' then
    begin
      // Render text node
      TextLayout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        TextLayout.BeginUpdate;
        TextLayout.Text := Tag.Text;

        // Apply font family
        if CombinedStyle.ContainsKey('font-family') then
          TextLayout.Font.Family := CombinedStyle['font-family']
        else
          TextLayout.Font.Family := 'Default';

        // Apply font size
        if CombinedStyle.ContainsKey('font-size') then
        begin
          FontSize := StrToFloatDef(CombinedStyle['font-size'].Replace('px', ''), 12);
          TextLayout.Font.Size := FontSize;
        end
        else
          TextLayout.Font.Size := 12;

        // Apply color
        if CombinedStyle.ContainsKey('color') then
          TextLayout.Color := ParseCSSColor(CombinedStyle['color'])
        else
          TextLayout.Color := TAlphaColors.Black;

        // Apply font weight
        if CombinedStyle.ContainsKey('font-weight') and (CombinedStyle['font-weight'].ToLower = 'bold') then
          TextLayout.Font.Style := TextLayout.Font.Style + [TFontStyle.fsBold];

        // Apply font style
        if CombinedStyle.ContainsKey('font-style') and (CombinedStyle['font-style'].ToLower = 'italic') then
          TextLayout.Font.Style := TextLayout.Font.Style + [TFontStyle.fsItalic];

        // Apply text alignment
        XPos := 0;
        if CombinedStyle.ContainsKey('text-align') then
        begin
          if CombinedStyle['text-align'].ToLower = 'center' then
            TextLayout.HorizontalAlign := TTextAlign.Center
          else if CombinedStyle['text-align'].ToLower = 'right' then
            TextLayout.HorizontalAlign := TTextAlign.Trailing
          else
            TextLayout.HorizontalAlign := TTextAlign.Leading;
        end
        else
          TextLayout.HorizontalAlign := TTextAlign.Leading;

        // Add margin for block tags
        if IsBlockTag then
          YPos := YPos + 5;

        TextLayout.TopLeft := TPointF.Create(XPos, YPos);
        TextLayout.MaxSize := TPointF.Create(Width, Max(Height - YPos, 1)); // Ensure non-zero height
        TextLayout.EndUpdate;

        TextLayout.RenderLayout(Canvas);
        YPos := YPos + TextLayout.Height;

        // Debug: Log rendered text
        {$IFDEF DEBUG}
        OutputDebugString(PChar('Rendered: ' + Tag.Text + ' at Y=' + FloatToStr(YPos)));
        {$ENDIF}
      finally
        TextLayout.Free;
      end;
    end;
  finally
    CombinedStyle.Free;
  end;
end;

procedure TTina4HTMLRender.Paint;
var
  Parser: THTMLParser;
  Canvas: TCanvas;
  YPos: Single;
  EmptyStyle: TDictionary<string, string>;
  TextLayout: TTextLayout;
begin
  inherited;
  Canvas := Self.Canvas;
  if not Assigned(Canvas) then
  begin
    {$IFDEF DEBUG}
    OutputDebugString('Paint: Canvas is nil');
    {$ENDIF}
    Exit;
  end;

  Parser := THTMLParser.Create;
  EmptyStyle := TDictionary<string, string>.Create;
  try
    Parser.Parse(FHTML.Text);
    OutputDebugString(Parser.Debug);
    YPos := 0;

    Canvas.BeginScene;
    try
      if Parser.Root.Children.Count = 0 then
      begin
        // Fallback: Render default message if no tags
        TextLayout := TTextLayoutManager.DefaultTextLayout.Create;
        try
          TextLayout.BeginUpdate;
          TextLayout.Text := 'No HTML content to render';
          TextLayout.Font.Family := 'Default';
          TextLayout.Font.Size := 12;
          TextLayout.Color := TAlphaColors.Red;
          TextLayout.TopLeft := TPointF.Create(0, YPos);
          TextLayout.MaxSize := TPointF.Create(Width, Height);
          TextLayout.EndUpdate;
          TextLayout.RenderLayout(Canvas);
          {$IFDEF DEBUG}
          OutputDebugString('Rendered fallback message');
          {$ENDIF}
        finally
          TextLayout.Free;
        end;
      end
      else
      begin
        for var Child in Parser.Root.Children do
          RenderTag(Canvas, Child, YPos, EmptyStyle);
      end;
    finally
      Canvas.EndScene;
    end;
  finally
    Parser.Free;
    EmptyStyle.Free;
  end;
end;

end.
