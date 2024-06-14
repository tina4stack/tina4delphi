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
    FReadTimeOut: Integer;
    FConnectTimeOut: Integer;
    FUserAgent: String;
    procedure SetCustomHeaders(const List: TURLHeaders);
    function GetCustomHeaders: TURLHeaders;
    procedure WrapJSONResponse(JSONContent: string; var Result: TJSONObject);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Loaded; override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadHeaders(Reader: TReader);
    procedure WriteHeaders(Writer: TWriter);

    procedure ReadHeaderData(AStream: TStream);
    procedure WriteHeaderData(AStream: TStream);

    function Get(EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    function Post(EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;

  published
    { Published declarations }
    property UserAgent: String read FUserAgent write FUserAgent;
    property BaseUrl: String read FBaseUrl write FBaseUrl;
    property Username: String read FUsername write FUsername;
    property Password: String read FPassword write FPassword;
    property CustomHeaders: TURLHeaders read GetCustomHeaders write SetCustomHeaders;
    property ReadTimeOut : Integer read FReadTimeOut write FReadTimeOut;
    property ConnectTimeOut : Integer read FConnectTimeOut write FConnectTimeOut;
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


procedure TTina4REST.DefineProperties(Filer: TFiler);
begin
  inherited;
  //This is the headers property on CustomHeaders
  Filer.DefineProperty('Headers', ReadHeaders, WriteHeaders, True);
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
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, '', ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders, Self.FUserAgent, TTina4RequestType.Get, Self.FReadTimeOut, Self.FConnectTimeOut);
  WrapJSONResponse(JSONContent, Result);
end;


function TTina4REST.GetCustomHeaders: TURLHeaders;
begin
  Result := FCustomHeaders;
end;

procedure TTina4REST.Loaded;
begin
  inherited;

end;

function TTina4REST.Post(EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  JSONContent : String;
begin
  JSONContent := SendHttpRequest(Self.FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, Self.FUsername, Self.FPassword, Self.FCustomHeaders, Self.FUserAgent, TTina4RequestType.Post);
  WrapJSONResponse(JSONContent, Result);
end;

procedure TTina4REST.ReadHeaderData(AStream: TStream);
begin
  //
end;

procedure TTina4REST.ReadHeaders(Reader: TReader);
var
  DelimitedString: TStringList;
begin
  DelimitedString := TStringList.Create('"', '~');
  try
    Reader.ReadListBegin;

    while not Reader.EndOfList do
    begin
      DelimitedString.DelimitedText := Reader.ReadString;
      FCustomHeaders.Add(DelimitedString[0],DelimitedString[1]);
    end;

    Reader.ReadListEnd;
  finally
    DelimitedString.Free;
  end;
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


procedure TTina4REST.WriteHeaderData(AStream: TStream);
begin
  //
end;

procedure TTina4REST.WriteHeaders(Writer: TWriter);
begin
  Writer.WriteListBegin;
  for var I := 0 to FCustomHeaders.Count-1 do
  begin
    Writer.WriteString(FCustomHeaders.Headers[I].Name+'~'+FCustomHeaders.Headers[I].Value);
  end;
  Writer.WriteListEnd;
end;

procedure TTina4REST.SetCustomHeaders(const List: TURLHeaders);
begin
  FCustomHeaders.Assign(List);
end;

end.
