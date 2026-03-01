unit uMain;

interface

uses
  Vcl.Forms, Vcl.StdCtrls, Vcl.Dialogs, Vcl.Controls, System.Classes;

type
  TfrmMain = class(TForm)
    edtName: TEdit;
    btnHello: TButton;
    procedure btnHelloClick(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnHelloClick(Sender: TObject);
begin
  if edtName.Text <> '' then
    ShowMessage('Hello ' + edtName.Text + '!')
  else
    ShowMessage('Hello World!');
end;

end.
