unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation,
  FMX.Layouts;

type
  TMainForm = class(TForm)
    edtName: TEdit;
    btnHello: TButton;
    lblTitle: TLabel;
    procedure btnHelloClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.btnHelloClick(Sender: TObject);
begin
  ShowMessage('Hello ' + edtName.Text + '!');
end;

end.
