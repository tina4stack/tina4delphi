unit uDemo;

interface

uses System.SysUtils, FMX.StdCtrls, FMX.Forms, FMX.Memo.Types, System.Rtti, FMX.Grid.Style, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.StorageBin,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, Fmx.Bind.Grid, System.Bindings.Outputs,
  Fmx.Bind.Editors, Tina4HtmlRender, Data.Bind.Components, Data.Bind.Grid,
  Data.Bind.DBScope, Tina4JSONAdapter, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4RESTRequest, Tina4REST, FMX.Grid, FMX.ScrollBox,
  FMX.Memo, FMX.Dialogs, System.Classes, FMX.Types, FMX.Controls,
  FMX.Controls.Presentation, Tina4Twig;


type
  TForm2 = class(TForm)
    btnRender: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Splitter1: TSplitter;
    memOutput: TMemo;
    Panel2: TPanel;
    memTwig: TMemo;
    Tina4REST1: TTina4REST;
    Tina4RESTRequest1: TTina4RESTRequest;
    FDMemTable1: TFDMemTable;
    Button1: TButton;
    Tina4JSONAdapter1: TTina4JSONAdapter;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    Tina4JSONAdapter2: TTina4JSONAdapter;
    FDMemTable2: TFDMemTable;
    Tina4HTMLRender1: TTina4HTMLRender;
    procedure HtPanel1Click(Sender: TObject);
    procedure btnRenderClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
  var Twig := TTina4Twig.Create();
  try
    Tina4HTMLRender1.Html.Text := Twig.Render(memTwig.Text, nil);
    memOutput.Text := Tina4HTMLRender1.Html.Text;
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

procedure TForm2.Button1Click(Sender: TObject);
begin
  Tina4RESTRequest1.ExecuteRESTCall;
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
