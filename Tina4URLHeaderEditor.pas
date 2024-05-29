unit Tina4URLHeaderEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Net.URLClient, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.Grids;

type
  TfrmTina4URLHeaderEditor = class(TForm)
    grdHeaders: TStringGrid;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    btnAdd: TButton;
    btnDelete: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure grdHeadersDrawCell(Sender: TObject; ACol, ARow: LongInt;
      Rect: TRect; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    URLHeaders: TURLHeaders;

    procedure InitGrid;
  end;

var
  frmTina4URLHeaderEditor: TfrmTina4URLHeaderEditor;

implementation

{$R *.dfm}

procedure DeleteRow(Grid: TStringGrid; ARow: Integer);
var
  i: Integer;
begin
  for i := ARow to Grid.RowCount - 2 do
    Grid.Rows[i].Assign(Grid.Rows[i + 1]);
  Grid.RowCount := Grid.RowCount - 1;
end;


procedure TfrmTina4URLHeaderEditor.btnAddClick(Sender: TObject);
begin
  grdHeaders.RowCount := grdHeaders.RowCount+1;
end;

procedure TfrmTina4URLHeaderEditor.btnDeleteClick(Sender: TObject);
begin
  if grdHeaders.Row <> 0 then
  begin
    DeleteRow(grdHeaders, grdHeaders.Row);
  end;
end;

procedure TfrmTina4URLHeaderEditor.FormClose(Sender: TObject; var Action: TCloseAction);
var
  RowCount: Integer;
begin
  //Update the URL Headers
  for RowCount := 1 to grdHeaders.RowCount-1 do
  begin
    if Trim(grdHeaders.Cells[0, RowCount]) <> '' then
    begin
      UrlHeaders.Add(Trim(grdHeaders.Cells[0, RowCount]), Trim(grdHeaders.Cells[1, RowCount]));
    end;
  end;
end;

procedure TfrmTina4URLHeaderEditor.FormShow(Sender: TObject);
begin
  InitGrid;
end;

procedure TfrmTina4URLHeaderEditor.grdHeadersDrawCell(Sender: TObject; ACol,
  ARow: LongInt; Rect: TRect; State: TGridDrawState);
begin
  with (Sender as TStringGrid) do
  begin
    if (gdFixed in State) or (ARow = 0) then
    begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.FillRect(Rect);
      Canvas.Font.Style := [fsBold];
      Canvas.Font.Color := clBlack;
      Canvas.TextOut(Rect.Left+4, Rect.Top+4,  Cells[ACol, ARow]);
    end;
  end;
end;

procedure TfrmTina4URLHeaderEditor.InitGrid;
begin
  grdHeaders.Cols[0].Text := 'Header';
  grdHeaders.Cols[1].Text := 'Value';
  var Count := 1;
  for var Header in Self.URLHeaders do
  begin
    grdHeaders.Cells[0, Count] := Header.Name;
    grdHeaders.Cells[1, Count] := Header.Value;
    Count := Count + 1;
  end;
  grdHeaders.RowCount := Count+1;
end;

end.
