unit Tina4RESTEditor;

interface

uses
  DesignIntf, DesignEditors, Classes, Tina4Rest, System.Net.URLClient, System.UITypes, Tina4URLHeaderEditor, VCL.Forms;

type
  TURLHeadersEditor = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TUrlHeaders), nil, '', TURLHeadersEditor);
end;

{ TURLHeadersEditor }

procedure TURLHeadersEditor.Edit;
  var
    frmTina4URLHeaderEditor: TfrmTina4URLHeaderEditor;
begin
  frmTina4URLHeaderEditor :=  TfrmTina4URLHeaderEditor.Create(Application);
  try
    frmTina4URLHeaderEditor.URLHeaders.Assign(GetVarValue);
    if frmTina4URLHeaderEditor.ShowModal = mrOK then
    begin
      Self.SetVarValue(frmTina4URLHeaderEditor.URLHeaders);
    end;
  finally
    frmTina4URLHeaderEditor.Free;
  end;
end;

function TURLHeadersEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paDialog];
end;

function TURLHeadersEditor.GetValue: String;
begin
  Result := 'Click to Edit Headers';
end;


end.
