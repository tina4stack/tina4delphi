unit Tina4RESTRequestEditor;

interface

uses
  DesignIntf, DesignEditors, Classes, Tina4RestRequest;

type
  TTina4RESTRequestEditor = class(TComponentEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponentEditor(TTina4RESTRequest, TTina4RESTRequestEditor);
end;

{ TTina4RESTRequestEditor }

procedure TTina4RESTRequestEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  case Index of
    0: (Component as TTina4RESTRequest).ExecuteRESTCall;
  end;
end;

function TTina4RESTRequestEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Execute';
  end;
end;

function TTina4RESTRequestEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


end.
