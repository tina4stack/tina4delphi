unit uHtmlRender;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Tina4HtmlRender,
  FMX.Controls.Presentation, FMX.StdCtrls, Tina4HTMLPages, Tina4JSONAdapter,
  FMX.Layouts;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Tina4HTMLPages1: TTina4HTMLPages;
    Tina4JSONAdapter1: TTina4JSONAdapter;
    Button2: TButton;
    Layout1: TLayout;
    Tina4HTMLRender1: TTina4HTMLRender;
    procedure FormCreate(Sender: TObject);
    procedure Tina4HTMLRender1FormControlClick(Sender: TObject; const Name,
      Value: string);
    procedure Tina4HTMLRender1FormControlChange(Sender: TObject; const Name,
      Value: string);
    procedure Tina4HTMLRender1FormSubmit(Sender: TObject;
      const FormName: string; FormData: TStrings);
    procedure Button1Click(Sender: TObject);
    procedure Tina4HTMLRender1Scroll(Sender: TObject; ScrollX, ScrollY: Single);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FLoading : Boolean;
    FAllLoaded : Boolean;
    procedure ShowSomething(Name: String);
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

// Embedded keyboard-demo HTML. Kept inline (rather than shipping a .html
// via the deployproj) so the APK picks it up without extra deploy config.
// See Example/keyboard_demo.html for the canonical source; update both
// in lockstep.
const
  KEYBOARD_DEMO_HTML =
    '<div style="padding:18px;font-family:sans-serif;background:#f3f4f6">' +
    '<h1 style="color:#1e40af;margin:0 0 8px 0">Tina4 Keyboard Demo</h1>' +
    '<p style="color:#4b5563;margin:0 0 20px 0">' +
    'Tap each field. Watch the Android soft-keyboard layout change, and ' +
    'use the return-key to jump to the next field — the last field ' +
    'submits the form.</p>' +
    '<form name="demo" id="demo">' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Full name</label>' +
    '<input type="text" name="name" id="fName" autocapitalize="words" enterkeyhint="next" ' +
    'placeholder="Auto-caps words" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Email</label>' +
    '<input type="email" name="email" id="fEmail" enterkeyhint="next" ' +
    'placeholder="Email keyboard with @" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Phone</label>' +
    '<input type="tel" name="phone" id="fPhone" enterkeyhint="next" ' +
    'placeholder="Phone pad (digits + symbols)" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Quantity</label>' +
    '<input type="number" name="qty" id="fQty" inputmode="numeric" enterkeyhint="next" maxlength="4" ' +
    'placeholder="Number pad (max 4 digits)" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Website</label>' +
    '<input type="url" name="url" id="fUrl" enterkeyhint="next" ' +
    'placeholder="URL keyboard with / and .com" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Password</label>' +
    '<input type="password" name="pw" id="fPw" enterkeyhint="next" ' +
    'placeholder="Masked, no auto-cap" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Search</label>' +
    '<input type="search" name="q" id="fSearch" enterkeyhint="search" ' +
    'placeholder="Return key shows as Search" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Comments</label>' +
    '<textarea name="comments" id="fComments" rows="3" ' +
    'placeholder="Multi-line, auto-caps sentences" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px"></textarea>' +
    '</div>' +

    '<div style="margin-bottom:14px">' +
    '<label style="display:block;font-weight:600;color:#111827;margin-bottom:4px">Promo code</label>' +
    '<input type="text" name="promo" id="fPromo" autocapitalize="characters" enterkeyhint="go" ' +
    'placeholder="ALL CAPS — return key says Go" ' +
    'style="width:100%;padding:12px;border:1px solid #d1d5db;border-radius:8px;font-size:16px">' +
    '</div>' +

    '<button type="submit" ' +
    'style="background:#1e40af;color:white;padding:14px 24px;border:none;border-radius:8px;font-weight:600;font-size:16px;width:100%">' +
    'Submit form</button>' +
    '</form>' +

    // Bottom spacer so we can verify scroll-into-view lifts the last
    // two fields above the keyboard when they get focused.
    '<div style="height:200px"></div>' +
    '</div>';

procedure TForm3.Button1Click(Sender: TObject);
begin
  Tina4HTMLRender1.HTML.LoadFromFile('..\..\test_all_features.html')
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Tina4HTMLRender1.HTML.LoadFromFile('..\..\test_images.html')
end;

procedure TForm3.FormCreate(Sender: TObject);
{$IF not (defined(ANDROID) or defined(IOS))}
var
  HtmlFile: string;
{$ENDIF}
begin
  //Tina4HTMLRender1.Align := TAlignLayout.Client;
  Tina4HTMLRender1.CacheEnabled := False;
  Tina4HTMLRender1.RegisterObject('Form3', Self);

  {$IF defined(ANDROID) or defined(IOS)}
  // On mobile, show the embedded keyboard demo — the .html files in
  // Example/ aren't deployed into the APK, so we can't LoadFromFile.
  Tina4HTMLRender1.HTML.Text := KEYBOARD_DEMO_HTML;
  {$ELSE}
  // Desktop: load a file next to the exe, or fall back to the Example folder.
  HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'keyboard_demo.html');
  if not FileExists(HtmlFile) then
    HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\keyboard_demo.html');
  if FileExists(HtmlFile) then
    Tina4HTMLRender1.HTML.Text := TFile.ReadAllText(HtmlFile)
  else
    Tina4HTMLRender1.HTML.Text := KEYBOARD_DEMO_HTML;
  {$ENDIF}
end;

procedure TForm3.ShowSomething(Name: String);
begin
  ShowMessage('Hello '+Name);
end;

procedure TForm3.Tina4HTMLRender1FormControlChange(Sender: TObject; const Name,
  Value: string);
begin
  //ShowMessage(Name+' Changed '+ Value);
end;

procedure TForm3.Tina4HTMLRender1FormControlClick(Sender: TObject; const Name,
  Value: string);
begin
  //ShowMessage(Name+' Clicked '+ Value);
end;

procedure TForm3.Tina4HTMLRender1FormSubmit(Sender: TObject;
  const FormName: string; FormData: TStrings);
begin
  ShowMessage(FormName+' '#10#13+FormData.Text);
end;

procedure TForm3.Tina4HTMLRender1Scroll(Sender: TObject; ScrollX,
  ScrollY: Single);
begin
  BeginUpdate;
  Caption := CurrToStr(ScrollY);
  if FLoading or FAllLoaded then Exit;
  if ScrollY <= 100 then
  begin
    FLoading := True;
    try
      var Older := '<h1 style="border: 1px solid red; padding: 50px; border-radius: 30px ">HEllo</h1><h1>HEllo</h1><h1>HEllo</h1><h1>HEllo</h1><h1>HEllo</h1><h1>HEllo</h1><h1>HEllo</h1>';
      if Older = '' then
        FAllLoaded := True
      else
        Tina4HTMLRender1.PrependHTML('hiddenDiv', Older);
    finally
      FLoading := False;
    end;
  end;
  EndUpdate;
end;

end.
