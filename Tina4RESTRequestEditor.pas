unit Tina4RESTRequestEditor;

interface

uses
  DesignIntf, DesignEditors, Classes;

type
  TTina4RESTRequestEditor = class(TComponentEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;


procedure Register;

implementation

uses Tina4RESTRequest, Tina4JSONAdapter;

procedure Register;
begin
  RegisterComponentEditor(TTina4RESTRequest, TTina4RESTRequestEditor);
  RegisterComponentEditor(TTina4JSONAdapter, TTina4RESTRequestEditor);
end;

{ TTina4RESTRequestEditor }

procedure TTina4RESTRequestEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
  case Index of
    0: begin
         if (Component is TTina4RESTRequest) then
         begin
           (Component as TTina4RESTRequest).ExecuteRESTCall;
         end;

         if (Component is TTina4JSONAdapter) then
         begin
           (Component as TTina4JSONAdapter).Execute;
         end;

       end;
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
