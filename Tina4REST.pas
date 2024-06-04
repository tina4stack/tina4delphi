unit Tina4REST;

interface

uses
  System.SysUtils, System.Classes, JSON, Tina4Core, System.Net.URLClient, FMX.Dialogs;

type
  TTina4REST = class(TComponent)
  private
    { Private declarations }
    FBaseUrl : String;
    FUsername: String;
    FPassword: String;
    FCustomHeaders: TURLHeaders;
    FUserAgent: String;
    procedure SetCustomHeaders(const List: TURLHeaders);
    procedure WrapJSONResponse(JSONContent: string; var Result: TJSONObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Get(EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    function Post(EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;

  published
    { Published declarations }
    property UserAgent: String read FUserAgent write FUserAgent;
    property BaseUrl: String read FBaseUrl write FBaseUrl;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property CustomHeaders: TURLHeaders read FCustomHeaders write SetCustomHeaders;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Tina4Delphi', [TTina4REST]);
end;

{ TTina4REST }

constructor TTina4REST.Create(AOwner: TComponent);
begin
  inherited;
  FCustomHeaders := TURLHeaders.Create;
  if FUserAgent = '' then
  begin
    FUserAgent := 'Tina4REST';
  end;
end;


destructor TTina4REST.Destroy;
begin
  FCustomHeaders.Free;
  inherited;
end;

function TTina4REST.Get(EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
var
  JSONContent : String;
begin
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, '', ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders, Self.FUserAgent, TTina4RequestType.Get);
  WrapJSONResponse(JSONContent, Result);
end;


function TTina4REST.Post(EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  JSONContent : String;
begin
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders, Self.FUserAgent, TTina4RequestType.Post);
  WrapJSONResponse(JSONContent, Result);
end;

procedure TTina4REST.WrapJSONResponse(JSONContent: string; var Result: TJSONObject);
begin
  if (Trim(JSONContent)[1] = '[') then    //Trim off the blanks and spaces on the edges [ ] //
  begin
    Result := StrToJSONObject('{"response":' + JSONContent + '}');
  end
  else
  //Add wrapper because the string is [] => {'response': []}
  begin
    Result := StrToJSONObject(JSONContent);
  end;
end;


procedure TTina4REST.SetCustomHeaders(const List: TURLHeaders);
begin
  FCustomHeaders.Assign(List);
end;

end.
