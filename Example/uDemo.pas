unit uDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Tina4Twig,
  FMX.Layouts, fmx.fhtmlcomp, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Tina4RESTRequest, Tina4REST, FireDAC.Stan.StorageBin,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.Grid,
  Tina4JSONAdapter;

type
  TForm2 = class(TForm)
    btnRender: TButton;
    btnSave: TButton;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    HtPanel1: THtPanel;
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
    HtPanel1.Html.Text := Twig.Render(memTwig.Text, nil);
    memOutput.Text := HtPanel1.Html.Text;
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
