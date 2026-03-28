unit Tina4OpenSSL;

interface

uses
  System.SysUtils, System.SyncObjs, System.IOUtils
  {$IFDEF MSWINDOWS}, Winapi.Windows{$ENDIF}
  {$IFDEF POSIX}, Posix.Dlfcn{$ENDIF};

type
  PSSL_CTX = Pointer;
  PSSL = Pointer;
  PSSL_METHOD = Pointer;

  /// <summary>
  /// Wraps an OpenSSL TLS connection for use with a raw socket handle.
  /// Create, call Init with the socket handle, then use Read/Write.
  /// </summary>
  TTina4SSLContext = class
  private
    FCtx: PSSL_CTX;
    FSSL: PSSL;
    FConnected: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>Initialise TLS on an existing connected socket fd</summary>
    function Init(ASocketHandle: THandle): Boolean;
    /// <summary>Perform TLS handshake after Init</summary>
    function Connect: Boolean;
    /// <summary>Read decrypted data. Returns bytes read, 0 on closed, -1 on error</summary>
    function Read(ABuf: PByte; ALen: Integer): Integer;
    /// <summary>Write data through TLS. Returns bytes written or -1 on error</summary>
    function Write(ABuf: PByte; ALen: Integer): Integer;
    /// <summary>Graceful TLS shutdown</summary>
    procedure Shutdown;
    /// <summary>Get last SSL error as string</summary>
    function GetLastError: string;
    property Connected: Boolean read FConnected;
  end;

/// <summary>Load OpenSSL libraries. Returns True if already loaded or loads OK.</summary>
function LoadOpenSSL: Boolean;
/// <summary>True if OpenSSL libraries are loaded and ready</summary>
function IsOpenSSLLoaded: Boolean;
/// <summary>Unload OpenSSL libraries</summary>
procedure UnloadOpenSSL;

implementation

{ ---- Library names per platform ---- }

const
  {$IFDEF MSWINDOWS}
  // Try OpenSSL 3.x first, then 1.1
  SSL_LIB_NAMES: array[0..3] of string = (
    'libssl-3-x64.dll', 'libssl-1_1-x64.dll',
    'libssl-3.dll', 'libssl-1_1.dll');
  CRYPTO_LIB_NAMES: array[0..3] of string = (
    'libcrypto-3-x64.dll', 'libcrypto-1_1-x64.dll',
    'libcrypto-3.dll', 'libcrypto-1_1.dll');
  {$ENDIF}
  {$IFDEF MACOS}
  SSL_LIB_NAMES: array[0..1] of string = (
    'libssl.3.dylib', 'libssl.1.1.dylib');
  CRYPTO_LIB_NAMES: array[0..1] of string = (
    'libcrypto.3.dylib', 'libcrypto.1.1.dylib');
  {$ENDIF}
  {$IFDEF LINUX}
  SSL_LIB_NAMES: array[0..1] of string = (
    'libssl.so.3', 'libssl.so.1.1');
  CRYPTO_LIB_NAMES: array[0..1] of string = (
    'libcrypto.so.3', 'libcrypto.so.1.1');
  {$ENDIF}
  {$IFDEF ANDROID}
  SSL_LIB_NAMES: array[0..0] of string = ('libssl.so');
  CRYPTO_LIB_NAMES: array[0..0] of string = ('libcrypto.so');
  // Android native libs extracted from APK go to nativeLibraryDir
  // which is typically /data/app/<package>/lib/arm/
  // dlopen searches this path automatically for libs bundled in the APK.
  // The APK must include them as lib/armeabi-v7a/libXXX.so entries.
  {$ENDIF}

  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_SYSCALL = 5;
  SSL_ERROR_ZERO_RETURN = 6;

{ ---- Function pointer types ---- }

type
  TSSL_library_init = function: Integer; cdecl;
  TSSL_load_error_strings = procedure; cdecl;
  TOpenSSL_init_ssl = function(opts: UInt64; settings: Pointer): Integer; cdecl;
  TTLS_client_method = function: PSSL_METHOD; cdecl;
  TSSLv23_client_method = function: PSSL_METHOD; cdecl;
  TSSL_CTX_new = function(method: PSSL_METHOD): PSSL_CTX; cdecl;
  TSSL_CTX_free = procedure(ctx: PSSL_CTX); cdecl;
  TSSL_new = function(ctx: PSSL_CTX): PSSL; cdecl;
  TSSL_free = procedure(ssl: PSSL); cdecl;
  TSSL_set_fd = function(ssl: PSSL; fd: Integer): Integer; cdecl;
  TSSL_connect = function(ssl: PSSL): Integer; cdecl;
  TSSL_read = function(ssl: PSSL; buf: Pointer; num: Integer): Integer; cdecl;
  TSSL_write = function(ssl: PSSL; buf: Pointer; num: Integer): Integer; cdecl;
  TSSL_shutdown = function(ssl: PSSL): Integer; cdecl;
  TSSL_get_error = function(ssl: PSSL; ret: Integer): Integer; cdecl;
  TERR_error_string = function(e: Cardinal; buf: PAnsiChar): PAnsiChar; cdecl;
  TERR_get_error = function: Cardinal; cdecl;
  TSSL_CTX_set_verify = procedure(ctx: PSSL_CTX; mode: Integer; callback: Pointer); cdecl;

{ ---- Global function pointers ---- }

var
  _SSL_library_init: TSSL_library_init = nil;
  _SSL_load_error_strings: TSSL_load_error_strings = nil;
  _OpenSSL_init_ssl: TOpenSSL_init_ssl = nil;
  _TLS_client_method: TTLS_client_method = nil;
  _SSLv23_client_method: TSSLv23_client_method = nil;
  _SSL_CTX_new: TSSL_CTX_new = nil;
  _SSL_CTX_free: TSSL_CTX_free = nil;
  _SSL_new: TSSL_new = nil;
  _SSL_free: TSSL_free = nil;
  _SSL_set_fd: TSSL_set_fd = nil;
  _SSL_connect: TSSL_connect = nil;
  _SSL_read: TSSL_read = nil;
  _SSL_write: TSSL_write = nil;
  _SSL_shutdown: TSSL_shutdown = nil;
  _SSL_get_error: TSSL_get_error = nil;
  _ERR_error_string: TERR_error_string = nil;
  _ERR_get_error: TERR_get_error = nil;
  _SSL_CTX_set_verify: TSSL_CTX_set_verify = nil;

  FSSLLib: {$IFDEF MSWINDOWS}HMODULE{$ELSE}NativeUInt{$ENDIF} = 0;
  FCryptoLib: {$IFDEF MSWINDOWS}HMODULE{$ELSE}NativeUInt{$ENDIF} = 0;
  FLoaded: Boolean = False;
  FLoadLock: TCriticalSection = nil;

{ ---- Platform library loading helpers ---- }

function InternalLoadLib(const AName: string): {$IFDEF MSWINDOWS}HMODULE{$ELSE}NativeUInt{$ENDIF};
begin
  {$IFDEF MSWINDOWS}
  Result := LoadLibrary(PChar(AName));
  {$ENDIF}
  {$IFDEF POSIX}
  Result := NativeUInt(dlopen(MarshaledAString(UTF8String(AName)), RTLD_LAZY));
  {$ENDIF}
end;

function InternalGetProc(ALib: {$IFDEF MSWINDOWS}HMODULE{$ELSE}NativeUInt{$ENDIF};
  const AName: string): Pointer;
begin
  {$IFDEF MSWINDOWS}
  Result := GetProcAddress(ALib, PChar(AName));
  {$ENDIF}
  {$IFDEF POSIX}
  Result := dlsym(ALib, MarshaledAString(UTF8String(AName)));
  {$ENDIF}
end;

procedure InternalFreeLib(var ALib: {$IFDEF MSWINDOWS}HMODULE{$ELSE}NativeUInt{$ENDIF});
begin
  if ALib <> 0 then
  begin
    {$IFDEF MSWINDOWS}
    FreeLibrary(ALib);
    {$ENDIF}
    {$IFDEF POSIX}
    dlclose(ALib);
    {$ENDIF}
    ALib := 0;
  end;
end;

{ ---- Logging ---- }

procedure SSLLog(const Msg: String);
var
  LogPath: String;
  F: TextFile;
begin
  try
    {$IFDEF ANDROID}
    LogPath := TPath.Combine(TPath.GetHomePath, 'ssl_debug.log');
    {$ELSE}
    LogPath := 'ssl_debug.log';
    {$ENDIF}
    AssignFile(F, LogPath);
    if FileExists(LogPath) then begin Reset(F); Append(F); end
    else Rewrite(F);
    WriteLn(F, FormatDateTime('hh:nn:ss', Now) + ': ' + Msg);
    CloseFile(F);
  except
  end;
end;

{ ---- Public functions ---- }

function LoadOpenSSL: Boolean;
var
  I: Integer;
begin
  SSLLog('LoadOpenSSL called');
  if FLoaded then
    Exit(True);

  FLoadLock.Enter;
  try
    if FLoaded then
      Exit(True);

    // Load crypto library first — try names, then app native lib path
    for I := 0 to High(CRYPTO_LIB_NAMES) do
    begin
      SSLLog('Trying crypto: ' + CRYPTO_LIB_NAMES[I]);
      FCryptoLib := InternalLoadLib(CRYPTO_LIB_NAMES[I]);
      if FCryptoLib <> 0 then
      begin
        SSLLog('Loaded crypto: ' + CRYPTO_LIB_NAMES[I]);
        Break;
      end;
      SSLLog('Failed crypto: ' + CRYPTO_LIB_NAMES[I]);
      {$IFDEF ANDROID}
      // Try app's native lib directory
      var CryptoPath := TPath.Combine(TPath.GetLibraryPath, CRYPTO_LIB_NAMES[I]);
      SSLLog('Trying crypto: ' + CryptoPath);
      FCryptoLib := InternalLoadLib(CryptoPath);
      if FCryptoLib <> 0 then
      begin
        SSLLog('Loaded crypto: ' + CryptoPath);
        Break;
      end;
      SSLLog('Failed crypto: ' + CryptoPath);
      {$ENDIF}
    end;
    if FCryptoLib = 0 then
    begin
      SSLLog('All crypto libs failed');
      Exit(False);
    end;

    // Load SSL library
    for I := 0 to High(SSL_LIB_NAMES) do
    begin
      SSLLog('Trying ssl: ' + SSL_LIB_NAMES[I]);
      FSSLLib := InternalLoadLib(SSL_LIB_NAMES[I]);
      if FSSLLib <> 0 then
      begin
        SSLLog('Loaded ssl: ' + SSL_LIB_NAMES[I]);
        Break;
      end;
      SSLLog('Failed ssl: ' + SSL_LIB_NAMES[I]);
      {$IFDEF ANDROID}
      var SSLPath := TPath.Combine(TPath.GetLibraryPath, SSL_LIB_NAMES[I]);
      SSLLog('Trying ssl: ' + SSLPath);
      FSSLLib := InternalLoadLib(SSLPath);
      if FSSLLib <> 0 then
      begin
        SSLLog('Loaded ssl: ' + SSLPath);
        Break;
      end;
      SSLLog('Failed ssl: ' + SSLPath);
      {$ENDIF}
    end;
    if FSSLLib = 0 then
    begin
      SSLLog('All ssl libs failed');
      InternalFreeLib(FCryptoLib);
      Exit(False);
    end;

    // Resolve function pointers
    // OpenSSL 3.x uses OPENSSL_init_ssl; 1.1 uses SSL_library_init
    @_OpenSSL_init_ssl := InternalGetProc(FSSLLib, 'OPENSSL_init_ssl');
    @_SSL_library_init := InternalGetProc(FSSLLib, 'SSL_library_init');
    @_SSL_load_error_strings := InternalGetProc(FSSLLib, 'SSL_load_error_strings');

    // TLS_client_method (3.x/1.1) or SSLv23_client_method (older)
    @_TLS_client_method := InternalGetProc(FSSLLib, 'TLS_client_method');
    if not Assigned(_TLS_client_method) then
      @_TLS_client_method := InternalGetProc(FSSLLib, 'SSLv23_client_method');

    @_SSL_CTX_new := InternalGetProc(FSSLLib, 'SSL_CTX_new');
    @_SSL_CTX_free := InternalGetProc(FSSLLib, 'SSL_CTX_free');
    @_SSL_CTX_set_verify := InternalGetProc(FSSLLib, 'SSL_CTX_set_verify');
    @_SSL_new := InternalGetProc(FSSLLib, 'SSL_new');
    @_SSL_free := InternalGetProc(FSSLLib, 'SSL_free');
    @_SSL_set_fd := InternalGetProc(FSSLLib, 'SSL_set_fd');
    @_SSL_connect := InternalGetProc(FSSLLib, 'SSL_connect');
    @_SSL_read := InternalGetProc(FSSLLib, 'SSL_read');
    @_SSL_write := InternalGetProc(FSSLLib, 'SSL_write');
    @_SSL_shutdown := InternalGetProc(FSSLLib, 'SSL_shutdown');
    @_SSL_get_error := InternalGetProc(FSSLLib, 'SSL_get_error');
    @_ERR_error_string := InternalGetProc(FCryptoLib, 'ERR_error_string');
    @_ERR_get_error := InternalGetProc(FCryptoLib, 'ERR_get_error');

    // Validate critical function pointers
    SSLLog('TLS_client_method=' + BoolToStr(Assigned(_TLS_client_method), True));
    SSLLog('SSL_CTX_new=' + BoolToStr(Assigned(_SSL_CTX_new), True));
    SSLLog('SSL_new=' + BoolToStr(Assigned(_SSL_new), True));
    SSLLog('SSL_set_fd=' + BoolToStr(Assigned(_SSL_set_fd), True));
    SSLLog('SSL_connect=' + BoolToStr(Assigned(_SSL_connect), True));
    SSLLog('SSL_read=' + BoolToStr(Assigned(_SSL_read), True));
    SSLLog('SSL_write=' + BoolToStr(Assigned(_SSL_write), True));
    SSLLog('SSL_shutdown=' + BoolToStr(Assigned(_SSL_shutdown), True));
    SSLLog('SSL_free=' + BoolToStr(Assigned(_SSL_free), True));
    SSLLog('SSL_CTX_free=' + BoolToStr(Assigned(_SSL_CTX_free), True));

    if not Assigned(_TLS_client_method) or
       not Assigned(_SSL_CTX_new) or not Assigned(_SSL_new) or
       not Assigned(_SSL_set_fd) or not Assigned(_SSL_connect) or
       not Assigned(_SSL_read) or not Assigned(_SSL_write) or
       not Assigned(_SSL_shutdown) or not Assigned(_SSL_free) or
       not Assigned(_SSL_CTX_free) then
    begin
      SSLLog('FAILED: Missing critical functions');
      InternalFreeLib(FSSLLib);
      InternalFreeLib(FCryptoLib);
      Exit(False);
    end;
    SSLLog('OpenSSL loaded successfully');

    // Initialise OpenSSL
    if Assigned(_OpenSSL_init_ssl) then
      _OpenSSL_init_ssl(0, nil)
    else
    begin
      if Assigned(_SSL_library_init) then
        _SSL_library_init;
      if Assigned(_SSL_load_error_strings) then
        _SSL_load_error_strings;
    end;

    FLoaded := True;
    Result := True;
  finally
    FLoadLock.Leave;
  end;
end;

function IsOpenSSLLoaded: Boolean;
begin
  Result := FLoaded;
end;

procedure UnloadOpenSSL;
begin
  FLoadLock.Enter;
  try
    InternalFreeLib(FSSLLib);
    InternalFreeLib(FCryptoLib);
    FLoaded := False;
  finally
    FLoadLock.Leave;
  end;
end;

{ ---- TTina4SSLContext ---- }

constructor TTina4SSLContext.Create;
begin
  inherited Create;
  FCtx := nil;
  FSSL := nil;
  FConnected := False;
end;

destructor TTina4SSLContext.Destroy;
begin
  Shutdown;
  if Assigned(FSSL) and Assigned(_SSL_free) then
    _SSL_free(FSSL);
  if Assigned(FCtx) and Assigned(_SSL_CTX_free) then
    _SSL_CTX_free(FCtx);
  inherited;
end;

function TTina4SSLContext.Init(ASocketHandle: THandle): Boolean;
var
  Method: PSSL_METHOD;
begin
  Result := False;
  if not LoadOpenSSL then
    Exit;

  Method := _TLS_client_method;
  if Method = nil then
    Exit;

  FCtx := _SSL_CTX_new(Method);
  if FCtx = nil then
    Exit;

  // Disable certificate verification for simplicity (like most WS clients)
  // Production code should enable verification
  if Assigned(_SSL_CTX_set_verify) then
    _SSL_CTX_set_verify(FCtx, 0, nil);

  FSSL := _SSL_new(FCtx);
  if FSSL = nil then
    Exit;

  if _SSL_set_fd(FSSL, Integer(ASocketHandle)) <> 1 then
    Exit;

  Result := True;
end;

function TTina4SSLContext.Connect: Boolean;
var
  Ret: Integer;
begin
  Result := False;
  if not Assigned(FSSL) then
    Exit;

  Ret := _SSL_connect(FSSL);
  if Ret = 1 then
  begin
    FConnected := True;
    Result := True;
  end;
end;

function TTina4SSLContext.Read(ABuf: PByte; ALen: Integer): Integer;
begin
  if not FConnected or not Assigned(FSSL) then
    Exit(-1);
  Result := _SSL_read(FSSL, ABuf, ALen);
end;

function TTina4SSLContext.Write(ABuf: PByte; ALen: Integer): Integer;
begin
  if not FConnected or not Assigned(FSSL) then
    Exit(-1);
  Result := _SSL_write(FSSL, ABuf, ALen);
end;

procedure TTina4SSLContext.Shutdown;
begin
  if FConnected and Assigned(FSSL) and Assigned(_SSL_shutdown) then
  begin
    _SSL_shutdown(FSSL);
    FConnected := False;
  end;
end;

function TTina4SSLContext.GetLastError: string;
var
  ErrCode: Cardinal;
  Buf: array[0..255] of AnsiChar;
begin
  Result := '';
  if Assigned(_ERR_get_error) and Assigned(_ERR_error_string) then
  begin
    ErrCode := _ERR_get_error;
    if ErrCode <> 0 then
    begin
      _ERR_error_string(ErrCode, @Buf[0]);
      Result := string(AnsiString(Buf));
    end;
  end;
end;

initialization
  FLoadLock := TCriticalSection.Create;

finalization
  UnloadOpenSSL;
  FLoadLock.Free;

end.
