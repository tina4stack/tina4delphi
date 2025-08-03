unit uDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Tina4Twig,
  FMX.Layouts, fmx.fhtmlcomp, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TForm2 = class(TForm)
    btnRender: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    HtPanel1: THtPanel;
    Splitter1: TSplitter;
    memTwig: TMemo;
    procedure HtPanel1Click(Sender: TObject);
    procedure btnRenderClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.btnRenderClick(Sender: TObject);
begin
  var Twig := TTina4Twig.Create;
  try
    HtPanel1.Html.Text := Twig.Render(memTwig.Text);

  finally
    Twig.Free;
  end;
end;

procedure TForm2.btnSaveClick(Sender: TObject);
begin
  //if SaveDialog1.Execute then
  //begin
    memTwig.Lines.SaveToFile('home.twig');
  //end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  if FileExists('home.twig') then
  begin
    memTwig.Lines.LoadFromFile('home.twig');
  end;
end;

procedure TForm2.HtPanel1Click(Sender: TObject);
begin
  ShowMessage('Clicked');
end;

end.
