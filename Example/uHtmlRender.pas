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

procedure TForm3.Button1Click(Sender: TObject);
begin
  Tina4HTMLRender1.HTML.LoadFromFile('..\..\test_all_features.html')
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Tina4HTMLRender1.HTML.LoadFromFile('..\..\test_scroll_features.html')
end;

procedure TForm3.FormCreate(Sender: TObject);
var
  HtmlFile: string;
begin
  //Tina4HTMLRender1.Align := TAlignLayout.Client;
  Tina4HTMLRender1.CacheEnabled := False;
  Tina4HTMLRender1.RegisterObject('Form3', Self);

  // Load HTML from file next to the executable, or fall back to the project Example folder
  HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'bootstrap_test.html');
  if not FileExists(HtmlFile) then
    HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\bootstrap_test.html');

  if FileExists(HtmlFile) then
    Tina4HTMLRender1.Twig.Text := TFile.ReadAllText(HtmlFile)
  else
    Tina4HTMLRender1.HTML.Text := '<h1>bootstrap_test.html not found</h1>' +
      '<p>Place bootstrap_test.html next to the executable or in the Example folder.</p>';
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
