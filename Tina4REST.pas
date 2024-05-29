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
    procedure SetCustomHeaders(List: TURLHeaders);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Get(EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    function Post(EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;

    procedure LoadHeaderProperty(Reader: TReader);
    procedure SaveHeaderProperty(Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;
  published
    { Published declarations }
    property UserAgent: String read FUserAgent write FUserAgent;
    property BaseUrl: String read FBaseUrl write FBaseUrl;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property CustomHeaders: TURLHeaders read FCustomHeaders write SetCustomHeaders stored True;

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
  FCustomHeaders := TURLHeaders.Create;
  if FUserAgent = '' then
  begin
    FUserAgent := 'Tina4REST';
  end;
end;

procedure TTina4REST.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('CustomHeaders.List', LoadHeaderProperty, SaveHeaderProperty, CustomHeaders.Headers <> nil);
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
  Result := StrToJSONObject(JSONContent);
end;


procedure TTina4REST.LoadHeaderProperty(Reader: TReader);
begin
  try
    if Reader.ReadBoolean then
    begin
      ShowMessage('Hello');
    end
  except

  end;
end;

function TTina4REST.Post(EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  JSONContent : String;
begin
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders, Self.FUserAgent, TTina4RequestType.Post);
  Result := StrToJSONObject(JSONContent);
end;


procedure TTina4REST.SaveHeaderProperty(Writer: TWriter);
begin
  try
    Writer.WriteBoolean(CustomHeaders. <> nil);
    if CustomHeaders.Headers <> nil then
    begin
      //Writer.WriteString('Hello');
    end;
  except

  end;
end;

procedure TTina4REST.SetCustomHeaders(List: TURLHeaders);
begin
  FCustomHeaders.Assign(List);
end;

end.
