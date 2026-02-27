unit uHtmlRender;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Tina4HtmlRender,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm3 = class(TForm)
    Tina4HTMLRender1: TTina4HTMLRender;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.FormCreate(Sender: TObject);
var
  HtmlFile: string;
begin
  Tina4HTMLRender1.Align := TAlignLayout.Client;
  Tina4HTMLRender1.CacheEnabled := True;

  // Load HTML from file next to the executable, or fall back to the project Example folder
  HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), 'bootstrap_test.html');
  if not FileExists(HtmlFile) then
    HtmlFile := TPath.Combine(ExtractFilePath(ParamStr(0)), '..\..\bootstrap_test.html');

  if FileExists(HtmlFile) then
    Tina4HTMLRender1.HTML.Text := TFile.ReadAllText(HtmlFile)
  else
    Tina4HTMLRender1.HTML.Text := '<h1>bootstrap_test.html not found</h1>' +
      '<p>Place bootstrap_test.html next to the executable or in the Example folder.</p>';
end;

end.
