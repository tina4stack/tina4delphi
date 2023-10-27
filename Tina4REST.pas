unit Tina4REST;

interface

uses
  System.SysUtils, System.Classes, JSON, Tina4Core;

type
  TTina4REST = class(TComponent)
  private
    { Private declarations }
    FBaseUrl : String;
    FUsername: String;
    FPassword: String;
    FCustomHeaders: TStringList;
    procedure SetCustomHeaders(List: TStringList);
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
    property BaseUrl: String read FBaseUrl write FBaseUrl;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property CustomHeaders: TStringList read FCustomHeaders write SetCustomHeaders;
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
  inherited Create(AOwner);
  FCustomHeaders := TStringList.Create;
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
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, '', ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders);
  Result := StrToJSONObject(JSONContent);
end;

function TTina4REST.Post(EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  JSONContent : String;
begin
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders);
  Result := StrToJSONObject(JSONContent);
end;

procedure TTina4REST.SetCustomHeaders(List: TStringList);
begin
  FCustomHeaders.Assign(List);
end;

end.
