unit Tina4REST;

interface

uses
  System.SysUtils, System.Classes, JSON, Tina4Core, System.Net.URLClient, System.StrUtils
  {$IFDEF MSWINDOWS}
  ,FMX.Dialogs
  {$ENDIF}
  ;

type
  /// <summary>
  /// REST client configuration component. Stores the base URL, authentication
  /// credentials, and custom headers. Used by TTina4RESTRequest for HTTP calls.
  /// Also provides direct Get/Post/Patch/Put/Delete methods.
  /// </summary>
  TTina4REST = class(TComponent)
  private
    FBaseUrl : String;
    FUsername: String;
    FPassword: String;
    FCustomHeaders: TURLHeaders;
    FReadTimeOut: Integer;
    FConnectTimeOut: Integer;
    FUserAgent: String;
    procedure SetCustomHeaders(const List: TURLHeaders);
    function GetCustomHeaders: TURLHeaders;
    function WrapJSONResponse(ResponseBytes: TBytes; StatusCode: Integer): TJSONObject;
  protected
  public
    /// <summary>Creates the REST client with default timeout values.</summary>
    constructor Create(AOwner: TComponent); override;
    /// <summary>Frees the custom headers list.</summary>
    destructor Destroy; override;

    /// <summary>Restores custom headers after component streaming.</summary>
    procedure Loaded; override;
    /// <summary>Defines binary streaming for the CustomHeaders property.</summary>
    procedure DefineProperties(Filer: TFiler); override;
    /// <summary>Reads custom headers from the component stream.</summary>
    procedure ReadHeaders(Reader: TReader);
    /// <summary>Writes custom headers to the component stream.</summary>
    procedure WriteHeaders(Writer: TWriter);

    /// <summary>Reads header data from a binary stream.</summary>
    procedure ReadHeaderData(AStream: TStream);
    /// <summary>Writes header data to a binary stream.</summary>
    procedure WriteHeaderData(AStream: TStream);

    /// <summary>Adds an Authorization: Bearer header with the given token.</summary>
    /// <param name="Token">The bearer token string.</param>
    procedure SetBearer(Token: String);

    /// <summary>Sends an HTTP GET request. Returns a TJSONObject (caller must free).</summary>
    function Get(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    /// <summary>Sends an HTTP DELETE request. Returns a TJSONObject (caller must free).</summary>
    function Delete(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    /// <summary>Sends an HTTP POST request with optional body. Returns a TJSONObject (caller must free).</summary>
    function Post(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    /// <summary>Sends an HTTP PATCH request with optional body. Returns a TJSONObject (caller must free).</summary>
    function Patch(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
    /// <summary>Sends an HTTP PUT request with optional body. Returns a TJSONObject (caller must free).</summary>
    function Put(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; Body: String = ''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;

  published
    /// <summary>User-Agent string sent with HTTP requests.</summary>
    property UserAgent: String read FUserAgent write FUserAgent;
    /// <summary>Base URL for all REST requests (e.g. 'https://api.example.com/v1').</summary>
    property BaseUrl: String read FBaseUrl write FBaseUrl;
    /// <summary>Username for HTTP Basic Authentication.</summary>
    property Username: String read FUsername write FUsername;
    /// <summary>Password for HTTP Basic Authentication.</summary>
    property Password: String read FPassword write FPassword;
    /// <summary>Custom HTTP headers sent with every request.</summary>
    property CustomHeaders: TURLHeaders read GetCustomHeaders write SetCustomHeaders;
    /// <summary>Read timeout in milliseconds for HTTP requests.</summary>
    property ReadTimeOut : Integer read FReadTimeOut write FReadTimeOut;
    /// <summary>Connection timeout in milliseconds for HTTP requests.</summary>
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
    FUserAgent := 'Tina4REST';
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

function TTina4REST.GetCustomHeaders: TURLHeaders;
begin
  Result := FCustomHeaders;
end;

procedure TTina4REST.Loaded;
begin
  inherited;
end;

function TTina4REST.Get(var StatusCode: Integer; EndPoint: String; QueryParams: String=''; ContentType: String= 'application/json'; ContentEncoding: String = 'utf-8'): TJSONObject;
var
  ResponseBytes: TBytes;
begin
  ResponseBytes := SendHttpRequest(StatusCode, FBaseUrl, EndPoint, QueryParams, '', ContentType, ContentEncoding, FUsername, FPassword, FCustomHeaders, FUserAgent, TTina4RequestType.Get, FReadTimeOut, FConnectTimeOut);
  Result := WrapJSONResponse(ResponseBytes, StatusCode);
end;

function TTina4REST.Delete(var StatusCode: Integer; EndPoint, QueryParams, ContentType,
  ContentEncoding: String): TJSONObject;
var
  ResponseBytes: TBytes;
begin
  ResponseBytes := SendHttpRequest(StatusCode, FBaseUrl, EndPoint, QueryParams, '', ContentType, ContentEncoding, FUsername, FPassword, FCustomHeaders, FUserAgent, TTina4RequestType.Delete, FReadTimeOut, FConnectTimeOut);
  Result := WrapJSONResponse(ResponseBytes, StatusCode);
end;

function TTina4REST.Post(var StatusCode: Integer; EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  ResponseBytes: TBytes;
begin
  ResponseBytes := SendHttpRequest(StatusCode, FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, FUsername, FPassword, FCustomHeaders, FUserAgent, TTina4RequestType.Post);
  Result := WrapJSONResponse(ResponseBytes, StatusCode);
end;

function TTina4REST.Patch(var StatusCode: Integer; EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  ResponseBytes: TBytes;
begin
  ResponseBytes := SendHttpRequest(StatusCode, FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, FUsername, FPassword, FCustomHeaders, FUserAgent, TTina4RequestType.Patch);
  Result := WrapJSONResponse(ResponseBytes, StatusCode);
end;

function TTina4REST.Put(var StatusCode: Integer; EndPoint, QueryParams, Body, ContentType,
  ContentEncoding: String): TJSONObject;
var
  ResponseBytes: TBytes;
begin
  ResponseBytes := SendHttpRequest(StatusCode, FBaseUrl, EndPoint, QueryParams, Body, ContentType, ContentEncoding, FUsername, FPassword, FCustomHeaders, FUserAgent, TTina4RequestType.Put);
  Result := WrapJSONResponse(ResponseBytes, StatusCode);
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

function TTina4REST.WrapJSONResponse(ResponseBytes: TBytes; StatusCode: Integer): TJSONObject;
var
  ResponseText: String;
begin
  ResponseText := Trim(StringOf(ResponseBytes));

  // Empty response — return status code only
  if ResponseText = '' then
    ResponseText := '{"statusCode": "'+IntToStr(StatusCode)+'"}';

  // Array response — wrap as {"response": [...]}
  if (StatusCode = 200) and (Trim(ResponseText)[1] = '[') then
    Result := StrToJSONObject('{"response":' + ResponseText + '}')
  else if StatusCode = 200 then
  begin
    var ParsedJSON := StrToJSONObject(ResponseText);
    if ParsedJSON = nil then
    begin
      Result := TJSONObject.Create;
      Result.AddPair('statusCode', StatusCode);
      Result.AddPair('response', ResponseText);
    end
    else
      Result := ParsedJSON;
  end
  else
  begin
    var ErrorJSON := '{"statusCode": "'+IntToStr(StatusCode)+'", "response": "' + AnsiReplaceStr(ResponseText, '"', '\"') + '"}';
    Result := StrToJSONObject(ErrorJSON);
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

procedure TTina4REST.SetBearer(Token: String);
begin
  FCustomHeaders.Add('Authorization', 'Bearer ' + Token);
end;

procedure TTina4REST.SetCustomHeaders(const List: TURLHeaders);
begin
  FCustomHeaders.Assign(List);
end;

end.
