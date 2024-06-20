unit Tina4RESTEditor;

interface

uses
  DesignIntf, DesignEditors, Classes, Tina4Rest, System.Net.URLClient, System.UITypes, Tina4URLHeaderEditor, VCL.Forms, VCL.Dialogs;

type
  TURLHeadersEditor = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
    procedure SetValue(const AValue: string); override;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(TUrlHeaders), TTina4REST, 'CustomHeaders', TURLHeadersEditor);
end;

{ TURLHeadersEditor }

procedure TURLHeadersEditor.Edit;
  var
    frmTina4URLHeaderEditor: TfrmTina4URLHeaderEditor;
begin
  frmTina4URLHeaderEditor :=  TfrmTina4URLHeaderEditor.Create(Application);
  try
    frmTina4URLHeaderEditor.URLHeaders := TUrlHeaders(GetOrdValue);
    if frmTina4URLHeaderEditor.ShowModal = mrOK then
    begin
      SetOrdValue(LongInt(frmTina4URLHeaderEditor.URLHeaders));
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
  Result := 'Click to add custom headers';
end;


procedure TURLHeadersEditor.SetValue(const AValue: string);
begin
  inherited;
end;

end.
