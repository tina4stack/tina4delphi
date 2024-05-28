unit Tina4URLHeaderEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids;

type
  TfrmTina4URLHeaderEditor = class(TForm)
    grdHeaders: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    URLHeaders: TURLHeaders;
  end;

var
  frmTina4URLHeaderEditor: TfrmTina4URLHeaderEditor;

implementation

{$R *.dfm}

end.
