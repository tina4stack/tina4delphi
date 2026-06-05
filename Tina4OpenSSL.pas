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
    FHostName: string;
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
    property HostName: string read FHostName write FHostName;
  end;

  /// <summary>
  /// Server-side TLS context. Loaded once with a cert and key, then
  /// used to wrap each accepted connection's socket via Accept().
  /// One context per listening server — share it across connections.
  /// </summary>
  TTina4SSLServerContext = class
  private
    FCtx: PSSL_CTX;
    FCertPath: string;
    FKeyPath: string;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Load a PEM cert + private key from disk. Both are required.
    /// Call once before accepting connections.
    /// </summary>
    function LoadCertificate(const ACertFile, AKeyFile: string): Boolean;
    /// <summary>Get last SSL error as string</summary>
    function GetLastError: string;
    /// <summary>True once a valid cert+key have been loaded.</summary>
    function IsReady: Boolean;
    /// <summary>Path to the loaded cert PEM. Empty until LoadCertificate.</summary>
    property CertPath: string read FCertPath;
    /// <summary>Path to the loaded private key PEM. Empty until LoadCertificate.</summary>
    property KeyPath: string read FKeyPath;
    /// <summary>
    /// Internal: returns the underlying SSL_CTX pointer for use by
    /// TTina4SSLConnection.AcceptOn. Don't call from app code.
    /// </summary>
    function RawCtx: PSSL_CTX;
  end;

  /// <summary>
  /// Server-side per-connection TLS wrapper. Pair with an accepted
  /// socket fd; call Accept() to perform the handshake; then Read/Write.
  /// </summary>
  TTina4SSLConnection = class
  private
    FSSL: PSSL;
    FAccepted: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Bind to a server context and a socket fd, then run SSL_accept.
    /// Returns True on a successful TLS handshake.
    /// </summary>
    function AcceptOn(AServerCtx: TTina4SSLServerContext;
      ASocketHandle: THandle): Boolean;
    function Read(ABuf: PByte; ALen: Integer): Integer;
    function Write(ABuf: PByte; ALen: Integer): Integer;
    procedure Shutdown;
    function GetLastError: string;
    property Accepted: Boolean read FAccepted;
  end;

{$IFDEF IOS}
  /// <summary>
  /// iOS-only client transport backed by Apple's Network.framework
  /// (nw_connection_t). Unlike the OpenSSL classes, this owns the WHOLE
  /// connection — TCP and TLS together — because Network.framework has no
  /// concept of wrapping an existing socket fd. Apple's stack supplies the
  /// TLS, so no OpenSSL libraries are needed on iOS.
  ///
  /// The native API is asynchronous (block callbacks dispatched on a GCD
  /// queue); this class bridges it to the blocking Connect/Read/Write model
  /// the WebSocket client expects, using dispatch semaphores.
  /// </summary>
  TTina4NWConnection = class
  private
    FConn: Pointer;        // nw_connection_t
    FQueue: Pointer;       // dispatch_queue_t (serial)
    FConnSem: Pointer;     // signaled when the connection becomes ready/failed
    FSendSem: Pointer;     // signaled by send completion
    FRecvSem: Pointer;     // signaled by receive completion
    FDrainSem: Pointer;    // signaled by NWStateThunk on CANCELLED — used by Shutdown to wait for GCD drain
    FStarted: Boolean;     // True once nw_connection_start has been called
    FConnState: Integer;   // last nw_connection_state_t seen by the handler
    FConnReady: Boolean;
    FLastError: string;
    FErrCode: Integer;
    // Per-receive scratch (reads are serialized on the WS read thread)
    FRecvTarget: PByte;
    FRecvTargetLen: Integer;
    FRecvLen: Integer;
    FRecvErr: Boolean;
    FRecvEOF: Boolean;
    FSendErr: Boolean;
    // Persistent block literals (built once, alive for the connection's life)
    FStateBlock: Pointer;
    FSendBlock: Pointer;
    FRecvBlock: Pointer;
    procedure BuildBlocks;
  public
    constructor Create;
    destructor Destroy; override;
    /// <summary>
    /// Resolve, TCP-connect and (when ATLS) perform the TLS handshake via
    /// Network.framework. Blocks until ready or the timeout elapses.
    /// </summary>
    function Connect(const AHost: string; APort: Integer; ATLS: Boolean;
      ATimeoutMs: Integer): Boolean;
    /// <summary>Read up to ALen bytes. Returns bytes read, 0 on EOF, -1 on error.</summary>
    function Read(ABuf: PByte; ALen: Integer): Integer;
    /// <summary>Write ALen bytes. Returns bytes written or -1 on error.</summary>
    function Write(ABuf: PByte; ALen: Integer): Integer;
    /// <summary>Cancel the connection (unblocks any pending receive).</summary>
    procedure Shutdown;
    function GetLastError: string;
  end;
{$ENDIF}

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
  // iOS deliberately has no OpenSSL library names — it does not link OpenSSL.
  // Secure transport on iOS is provided by Network.framework
  // (TTina4NWConnection). LoadOpenSSL returns False on iOS.

  SSL_ERROR_NONE = 0;
  SSL_ERROR_SSL = 1;
  SSL_ERROR_WANT_READ = 2;
  SSL_ERROR_WANT_WRITE = 3;
  SSL_ERROR_SYSCALL = 5;
  SSL_ERROR_ZERO_RETURN = 6;

  // SSL_CTX_use_*_file file-type constants (from openssl/ssl.h).
  SSL_FILETYPE_PEM = 1;

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
  TSSL_ctrl = function(ssl: PSSL; cmd: Integer; larg: NativeInt; parg: Pointer): NativeInt; cdecl;

  // Server-side
  TTLS_server_method = function: PSSL_METHOD; cdecl;
  TSSLv23_server_method = function: PSSL_METHOD; cdecl;
  TSSL_accept = function(ssl: PSSL): Integer; cdecl;
  TSSL_CTX_use_certificate_file = function(ctx: PSSL_CTX;
    file_: PAnsiChar; type_: Integer): Integer; cdecl;
  TSSL_CTX_use_PrivateKey_file = function(ctx: PSSL_CTX;
    file_: PAnsiChar; type_: Integer): Integer; cdecl;
  TSSL_CTX_check_private_key = function(ctx: PSSL_CTX): Integer; cdecl;

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
  _SSL_ctrl: TSSL_ctrl = nil;

  _TLS_server_method: TTLS_server_method = nil;
  _SSLv23_server_method: TSSLv23_server_method = nil;
  _SSL_accept: TSSL_accept = nil;
  _SSL_CTX_use_certificate_file: TSSL_CTX_use_certificate_file = nil;
  _SSL_CTX_use_PrivateKey_file: TSSL_CTX_use_PrivateKey_file = nil;
  _SSL_CTX_check_private_key: TSSL_CTX_check_private_key = nil;

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

{ ---- iOS has no OpenSSL ----
  On iOS, OpenSSL is intentionally NOT linked. Secure WebSocket (wss://)
  uses Apple's Network.framework via TTina4NWConnection (below), so the app
  needs no libssl.a / libcrypto.a. LoadOpenSSL returns False on iOS, and the
  OpenSSL wrapper classes (TTina4SSLContext / ...ServerContext / ...Connection)
  degrade gracefully because their _SSL_* function pointers stay nil.
  Consequence: OpenSSL-backed server-side TLS is unavailable on iOS. }

{ ---- Logging ---- }

procedure SSLLog(const Msg: String);
var
  LogPath: String;
  F: TextFile;
begin
  try
    {$IFDEF ANDROID}
    LogPath := TPath.Combine(TPath.GetHomePath, 'ssl_debug.log');
    {$ELSEIF DEFINED(IOS)}
    LogPath := TPath.Combine(TPath.GetDocumentsPath, 'ssl_debug.log');
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
{$IFNDEF IOS}
var
  I: Integer;
{$ENDIF}
begin
  SSLLog('LoadOpenSSL called');

  {$IFDEF IOS}
  // iOS does not link OpenSSL. Secure transport is provided by
  // Network.framework (TTina4NWConnection). Report "not available" so any
  // OpenSSL-dependent code paths degrade gracefully.
  SSLLog('OpenSSL not used on iOS — Network.framework provides TLS');
  Result := False;

  {$ELSE}

  // All other platforms: load OpenSSL at runtime via dlopen / LoadLibrary.
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
    @_SSL_ctrl := InternalGetProc(FSSLLib, 'SSL_ctrl');
    @_ERR_error_string := InternalGetProc(FCryptoLib, 'ERR_error_string');
    @_ERR_get_error := InternalGetProc(FCryptoLib, 'ERR_get_error');

    // Server-side entry points. Optional — wss:// server features
    // need them, but ws:// and client-only consumers don't.
    @_TLS_server_method := InternalGetProc(FSSLLib, 'TLS_server_method');
    if not Assigned(_TLS_server_method) then
      @_TLS_server_method := InternalGetProc(FSSLLib, 'SSLv23_server_method');
    @_SSL_accept := InternalGetProc(FSSLLib, 'SSL_accept');
    @_SSL_CTX_use_certificate_file :=
      InternalGetProc(FSSLLib, 'SSL_CTX_use_certificate_file');
    @_SSL_CTX_use_PrivateKey_file :=
      InternalGetProc(FSSLLib, 'SSL_CTX_use_PrivateKey_file');
    @_SSL_CTX_check_private_key :=
      InternalGetProc(FSSLLib, 'SSL_CTX_check_private_key');

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
  {$ENDIF}
end;

function IsOpenSSLLoaded: Boolean;
begin
  Result := FLoaded;
end;

procedure UnloadOpenSSL;
begin
  FLoadLock.Enter;
  try
    {$IFNDEF IOS}
    InternalFreeLib(FSSLLib);
    InternalFreeLib(FCryptoLib);
    {$ENDIF}
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

  // Set SNI hostname for virtual-hosted TLS servers
  if (FHostName <> '') and Assigned(_SSL_ctrl) then
  begin
    var HostBytes := TEncoding.UTF8.GetBytes(FHostName + #0);
    _SSL_ctrl(FSSL, 55 {SSL_CTRL_SET_TLSEXT_HOSTNAME}, 0 {TLSEXT_NAMETYPE_host_name}, @HostBytes[0]);
  end;

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

{ ---- TTina4SSLServerContext ---- }

constructor TTina4SSLServerContext.Create;
begin
  inherited Create;
  FCtx := nil;
end;

destructor TTina4SSLServerContext.Destroy;
begin
  if Assigned(FCtx) and Assigned(_SSL_CTX_free) then
    _SSL_CTX_free(FCtx);
  inherited;
end;

function TTina4SSLServerContext.IsReady: Boolean;
begin
  Result := FCtx <> nil;
end;

function TTina4SSLServerContext.RawCtx: PSSL_CTX;
begin
  Result := FCtx;
end;

function TTina4SSLServerContext.LoadCertificate(const ACertFile,
  AKeyFile: string): Boolean;
var
  Method: PSSL_METHOD;
  CertA, KeyA: AnsiString;
begin
  Result := False;
  if not LoadOpenSSL then Exit;

  // The server-side entry points are optional in LoadOpenSSL — older
  // OpenSSL builds and stripped distributions may not export them.
  if not Assigned(_TLS_server_method)
     or not Assigned(_SSL_CTX_use_certificate_file)
     or not Assigned(_SSL_CTX_use_PrivateKey_file)
     or not Assigned(_SSL_accept) then
    Exit;

  Method := _TLS_server_method;
  if Method = nil then Exit;

  // Free any previously loaded context — supports cert rotation.
  if Assigned(FCtx) and Assigned(_SSL_CTX_free) then
  begin
    _SSL_CTX_free(FCtx);
    FCtx := nil;
  end;

  FCtx := _SSL_CTX_new(Method);
  if FCtx = nil then Exit;

  // OpenSSL takes the C-style path; AnsiString keeps a stable PAnsiChar
  // for the duration of each call.
  CertA := AnsiString(ACertFile);
  if _SSL_CTX_use_certificate_file(FCtx, PAnsiChar(CertA),
       SSL_FILETYPE_PEM) <> 1 then
  begin
    _SSL_CTX_free(FCtx);
    FCtx := nil;
    Exit;
  end;

  KeyA := AnsiString(AKeyFile);
  if _SSL_CTX_use_PrivateKey_file(FCtx, PAnsiChar(KeyA),
       SSL_FILETYPE_PEM) <> 1 then
  begin
    _SSL_CTX_free(FCtx);
    FCtx := nil;
    Exit;
  end;

  // check_private_key is optional — verifies the key matches the cert.
  if Assigned(_SSL_CTX_check_private_key) then
  begin
    if _SSL_CTX_check_private_key(FCtx) <> 1 then
    begin
      _SSL_CTX_free(FCtx);
      FCtx := nil;
      Exit;
    end;
  end;

  FCertPath := ACertFile;
  FKeyPath := AKeyFile;
  Result := True;
end;

function TTina4SSLServerContext.GetLastError: string;
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

{ ---- TTina4SSLConnection ---- }

constructor TTina4SSLConnection.Create;
begin
  inherited Create;
  FSSL := nil;
  FAccepted := False;
end;

destructor TTina4SSLConnection.Destroy;
begin
  Shutdown;
  if Assigned(FSSL) and Assigned(_SSL_free) then
    _SSL_free(FSSL);
  inherited;
end;

function TTina4SSLConnection.AcceptOn(AServerCtx: TTina4SSLServerContext;
  ASocketHandle: THandle): Boolean;
var
  Ret: Integer;
begin
  Result := False;
  if (AServerCtx = nil) or (not AServerCtx.IsReady) then Exit;
  if not Assigned(_SSL_new) or not Assigned(_SSL_set_fd)
     or not Assigned(_SSL_accept) then Exit;

  FSSL := _SSL_new(AServerCtx.RawCtx);
  if FSSL = nil then Exit;

  if _SSL_set_fd(FSSL, Integer(ASocketHandle)) <> 1 then
  begin
    _SSL_free(FSSL);
    FSSL := nil;
    Exit;
  end;

  // SSL_accept blocks (the underlying socket is blocking) until the
  // handshake completes or fails. Return value 1 = success.
  Ret := _SSL_accept(FSSL);
  if Ret = 1 then
  begin
    FAccepted := True;
    Result := True;
  end
  else
  begin
    _SSL_free(FSSL);
    FSSL := nil;
  end;
end;

function TTina4SSLConnection.Read(ABuf: PByte; ALen: Integer): Integer;
begin
  if not FAccepted or not Assigned(FSSL) then Exit(-1);
  Result := _SSL_read(FSSL, ABuf, ALen);
end;

function TTina4SSLConnection.Write(ABuf: PByte; ALen: Integer): Integer;
begin
  if not FAccepted or not Assigned(FSSL) then Exit(-1);
  Result := _SSL_write(FSSL, ABuf, ALen);
end;

procedure TTina4SSLConnection.Shutdown;
begin
  if FAccepted and Assigned(FSSL) and Assigned(_SSL_shutdown) then
  begin
    _SSL_shutdown(FSSL);
    FAccepted := False;
  end;
end;

function TTina4SSLConnection.GetLastError: string;
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

{$IFDEF IOS}
{ ============================================================================
  TTina4NWConnection — Apple Network.framework client transport (iOS)

  Network.framework is entirely asynchronous and block-based; there is no
  socket fd and no synchronous API. We hand-build Objective-C Block literals
  (Delphi ships no block-producing helper — only imp_implementationWithBlock
  for the consuming side) and bridge the async callbacks back to a blocking
  Connect/Read/Write model via dispatch semaphores.

  Build-time requirements on the Mac:
    * Add Network.framework to the iOS SDK frameworks (SDK Manager) so the
      nw_* symbols link.
    * No OpenSSL .a files are needed on iOS when this path is used.
  ============================================================================ }

const
  libSystem  = '/usr/lib/libSystem.dylib';
  // Network.framework is loaded at runtime via dlopen — no hard dyld dependency.
  libNetworkPath = '/System/Library/Frameworks/Network.framework/Network';

  // nw_connection_state_t
  NW_STATE_INVALID   = 0;
  NW_STATE_WAITING   = 1;
  NW_STATE_PREPARING = 2;
  NW_STATE_READY     = 3;
  NW_STATE_FAILED    = 4;
  NW_STATE_CANCELLED = 5;

  // Objective-C Block ABI flags
  BLOCK_IS_GLOBAL = $10000000; // 1 shl 28 — runtime never heap-copies these

  DISPATCH_TIME_NOW     = UInt64(0);
  DISPATCH_TIME_FOREVER = UInt64($FFFFFFFFFFFFFFFF);

type
  PNWBlockLiteral = ^TNWBlockLiteral;
  TNWBlockLiteral = record
    isa: Pointer;
    flags: Integer;
    reserved: Integer;
    invoke: Pointer;       // cdecl thunk; first arg is this literal
    descriptor: Pointer;
    context: Pointer;      // captured TTina4NWConnection
  end;

  TNWBlockDescriptor = record
    reserved: NativeUInt;
    size: NativeUInt;
  end;

  // Block invoke thunk signatures (the block pointer is always arg 0)
  TNWStateInvoke = procedure(block: PNWBlockLiteral; state: Integer;
    error: Pointer); cdecl;
  TNWSendInvoke = procedure(block: PNWBlockLiteral; error: Pointer); cdecl;
  TNWRecvInvoke = procedure(block: PNWBlockLiteral; content: Pointer;
    context: Pointer; isComplete: Byte; error: Pointer); cdecl;

var
  // The Delphi iOS/LLVM compiler does not support importing C global DATA
  // symbols via `external`, so we resolve them at runtime with dlsym (see
  // NWResolveSymbols, called from initialization). These hold the results:
  //   gNSConcreteGlobalBlock — ADDRESS of the global-block class (used as isa)
  //   gNWDefaultConfig / gNWDisable — configure-protocol block POINTERS
  //   gNWDefaultMsgContext — the default nw_content_context object pointer
  gNSConcreteGlobalBlock: Pointer = nil;
  gNWDefaultConfig: Pointer = nil;
  gNWDisable: Pointer = nil;
  gNWDefaultMsgContext: Pointer = nil;

  NWBlockDescriptor: TNWBlockDescriptor;

{ ---- Network.framework function pointers (loaded at runtime via dlopen) ---- }
// Using function pointers instead of 'external' avoids a hard dyld dependency
// that crashes the process at launch if the linker embeds the wrong SDK path.

type
  TNW_endpoint_create_host = function(hostname, port: PAnsiChar): Pointer; cdecl;
  TNW_parameters_create_secure_tcp = function(tls, tcp: Pointer): Pointer; cdecl;
  TNW_connection_create = function(endpoint, params: Pointer): Pointer; cdecl;
  TNW_connection_set_queue = procedure(conn, queue: Pointer); cdecl;
  TNW_connection_set_state_changed_handler = procedure(conn, handler: Pointer); cdecl;
  TNW_connection_start = procedure(conn: Pointer); cdecl;
  TNW_connection_cancel = procedure(conn: Pointer); cdecl;
  TNW_connection_send = procedure(conn, content, ctx: Pointer;
    is_complete: Integer; completion: Pointer); cdecl;
  TNW_connection_receive = procedure(conn: Pointer;
    minimum, maximum: Cardinal; completion: Pointer); cdecl;
  TNW_error_get_error_code = function(error: Pointer): Integer; cdecl;
  TNW_release = procedure(obj: Pointer); cdecl;

var
  FNWLib: NativeUInt = 0;
  _nw_endpoint_create_host:                TNW_endpoint_create_host = nil;
  _nw_parameters_create_secure_tcp:        TNW_parameters_create_secure_tcp = nil;
  _nw_connection_create:                   TNW_connection_create = nil;
  _nw_connection_set_queue:                TNW_connection_set_queue = nil;
  _nw_connection_set_state_changed_handler:TNW_connection_set_state_changed_handler = nil;
  _nw_connection_start:                    TNW_connection_start = nil;
  _nw_connection_cancel:                   TNW_connection_cancel = nil;
  _nw_connection_send:                     TNW_connection_send = nil;
  _nw_connection_receive:                  TNW_connection_receive = nil;
  _nw_error_get_error_code:                TNW_error_get_error_code = nil;
  _nw_release:                             TNW_release = nil;

{ ---- libdispatch externals ---- }

function dispatch_queue_create(label_: PAnsiChar; attr: Pointer): Pointer; cdecl;
  external libSystem name 'dispatch_queue_create';
function dispatch_semaphore_create(value: NativeInt): Pointer; cdecl;
  external libSystem name 'dispatch_semaphore_create';
function dispatch_semaphore_wait(sem: Pointer; timeout: UInt64): NativeInt; cdecl;
  external libSystem name 'dispatch_semaphore_wait';
function dispatch_semaphore_signal(sem: Pointer): NativeInt; cdecl;
  external libSystem name 'dispatch_semaphore_signal';
function dispatch_time(when: UInt64; delta: Int64): UInt64; cdecl;
  external libSystem name 'dispatch_time';
function dispatch_data_create(buffer: Pointer; size: NativeUInt;
  queue, destructor_: Pointer): Pointer; cdecl;
  external libSystem name 'dispatch_data_create';
function dispatch_data_create_map(data: Pointer; var buffer_ptr: Pointer;
  var size_ptr: NativeUInt): Pointer; cdecl;
  external libSystem name 'dispatch_data_create_map';
procedure dispatch_release(obj: Pointer); cdecl;
  external libSystem name 'dispatch_release';

{ ---- Runtime symbol resolution (data symbols, via dlsym) ---- }

procedure NWResolveSymbols;
  function D(ALib: NativeUInt; const AName: string): Pointer;
  var
    A: UTF8String;
  begin
    // dlsym wants a C string; convert via UTF8String so the PAnsiChar points
    // to valid single-byte data, not the raw UTF-16 internal buffer.
    A := UTF8String(AName);
    Result := dlsym(ALib, MarshaledAString(A));
  end;
  function RTLD: NativeUInt; inline;
  begin
    // RTLD_DEFAULT = (void*)-2 on iOS/macOS: search all loaded images.
    Result := NativeUInt(NativeInt(-2));
  end;
var
  P: Pointer;
  LibA: UTF8String;
begin
  // Load Network.framework at runtime — no hard dyld link-time dependency.
  LibA := UTF8String(libNetworkPath);
  FNWLib := NativeUInt(dlopen(MarshaledAString(LibA), RTLD_LAZY));
  if FNWLib = 0 then Exit;  // framework not available; Connect() will report error

  // Resolve Network.framework function pointers.
  @_nw_endpoint_create_host                := D(FNWLib, 'nw_endpoint_create_host');
  @_nw_parameters_create_secure_tcp        := D(FNWLib, 'nw_parameters_create_secure_tcp');
  @_nw_connection_create                   := D(FNWLib, 'nw_connection_create');
  @_nw_connection_set_queue                := D(FNWLib, 'nw_connection_set_queue');
  @_nw_connection_set_state_changed_handler:= D(FNWLib, 'nw_connection_set_state_changed_handler');
  @_nw_connection_start                    := D(FNWLib, 'nw_connection_start');
  @_nw_connection_cancel                   := D(FNWLib, 'nw_connection_cancel');
  @_nw_connection_send                     := D(FNWLib, 'nw_connection_send');
  @_nw_connection_receive                  := D(FNWLib, 'nw_connection_receive');
  @_nw_error_get_error_code                := D(FNWLib, 'nw_error_get_error_code');
  @_nw_release                             := D(FNWLib, 'nw_release');

  // Resolve ObjC block class and Network.framework data-symbol globals.
  // These are pointer-typed C globals; dlsym returns the variable's address,
  // so dereference once to get the value.
  gNSConcreteGlobalBlock := D(RTLD, '_NSConcreteGlobalBlock');
  P := D(RTLD, '_nw_parameters_configure_protocol_default_configuration');
  if P <> nil then gNWDefaultConfig := PPointer(P)^;
  P := D(RTLD, '_nw_parameters_configure_protocol_disable');
  if P <> nil then gNWDisable := PPointer(P)^;
  P := D(RTLD, '_nw_content_context_default_message');
  if P <> nil then gNWDefaultMsgContext := PPointer(P)^;
end;

{ ---- Block invoke thunks (run on the connection's GCD queue) ---- }

procedure NWStateThunk(block: PNWBlockLiteral; state: Integer;
  error: Pointer); cdecl;
var
  Conn: TTina4NWConnection;
begin
  Conn := TTina4NWConnection(block^.context);
  Conn.FConnState := state;
  case state of
    NW_STATE_READY:
      begin
        Conn.FConnReady := True;
        dispatch_semaphore_signal(Conn.FConnSem);
      end;
    NW_STATE_FAILED:
      begin
        Conn.FConnReady := False;
        if (error <> nil) and Assigned(_nw_error_get_error_code) then
          Conn.FErrCode := _nw_error_get_error_code(error);
        dispatch_semaphore_signal(Conn.FConnSem);
      end;
    NW_STATE_CANCELLED:
      begin
        Conn.FConnReady := False;
        // Signal FConnSem in case Connect() is still waiting (e.g. cancelled
        // before reaching READY). Also signal FDrainSem so Shutdown() knows
        // the final GCD callback has completed and it is safe to free Self.
        dispatch_semaphore_signal(Conn.FConnSem);
        dispatch_semaphore_signal(Conn.FDrainSem);
      end;
    // WAITING / PREPARING / INVALID: keep waiting, don't signal
  end;
end;

procedure NWSendThunk(block: PNWBlockLiteral; error: Pointer); cdecl;
var
  Conn: TTina4NWConnection;
begin
  Conn := TTina4NWConnection(block^.context);
  Conn.FSendErr := error <> nil;
  if (error <> nil) and Assigned(_nw_error_get_error_code) then
    Conn.FErrCode := _nw_error_get_error_code(error);
  dispatch_semaphore_signal(Conn.FSendSem);
end;

procedure NWRecvThunk(block: PNWBlockLiteral; content: Pointer;
  context: Pointer; isComplete: Byte; error: Pointer); cdecl;
var
  Conn: TTina4NWConnection;
  Mapped, Buf: Pointer;
  Sz: NativeUInt;
  N: Integer;
begin
  Conn := TTina4NWConnection(block^.context);
  N := 0;
  if error <> nil then
  begin
    Conn.FRecvErr := True;
    if Assigned(_nw_error_get_error_code) then
      Conn.FErrCode := _nw_error_get_error_code(error);
  end
  else if content <> nil then
  begin
    Buf := nil;
    Sz := 0;
    Mapped := dispatch_data_create_map(content, Buf, Sz);
    try
      N := Integer(Sz);
      if N > Conn.FRecvTargetLen then
        N := Conn.FRecvTargetLen;
      if N > 0 then
        Move(PByte(Buf)^, Conn.FRecvTarget^, N);
      Conn.FRecvLen := N;
    finally
      if Mapped <> nil then
        dispatch_release(Mapped);
    end;
  end;
  // EOF: stream marked complete with no payload delivered
  if (isComplete <> 0) and (N = 0) then
    Conn.FRecvEOF := True;
  dispatch_semaphore_signal(Conn.FRecvSem);
end;

{ ---- TTina4NWConnection ---- }

constructor TTina4NWConnection.Create;
begin
  inherited Create;
  FConn := nil;
  FQueue := nil;
  FConnSem  := dispatch_semaphore_create(0);
  FSendSem  := dispatch_semaphore_create(0);
  FRecvSem  := dispatch_semaphore_create(0);
  FDrainSem := dispatch_semaphore_create(0);
end;

destructor TTina4NWConnection.Destroy;
begin
  Shutdown;
  if (FConn <> nil) and Assigned(_nw_release) then
  begin
    _nw_release(FConn);
    FConn := nil;
  end;
  if FQueue <> nil then
  begin
    dispatch_release(FQueue);
    FQueue := nil;
  end;
  if FConnSem  <> nil then dispatch_release(FConnSem);
  if FSendSem  <> nil then dispatch_release(FSendSem);
  if FRecvSem  <> nil then dispatch_release(FRecvSem);
  if FDrainSem <> nil then dispatch_release(FDrainSem);
  // Block literals are owned by the ObjC block runtime once passed to
  // Network.framework (via _Block_copy). Do NOT FreeMem them here — the
  // runtime frees them when the framework's last reference drops.
  inherited;
end;

procedure TTina4NWConnection.BuildBlocks;
  function MakeBlock(AInvoke: Pointer): Pointer;
  var
    Lit: PNWBlockLiteral;
  begin
    Lit := AllocMem(SizeOf(TNWBlockLiteral));
    // Heap block (flags = 0): the framework calls _Block_copy which
    // reference-counts the block and keeps it alive until the connection
    // releases it. Do NOT use BLOCK_IS_GLOBAL — global blocks must live in
    // .data, not on the heap, and the runtime never frees them.
    Lit^.isa := gNSConcreteGlobalBlock;
    Lit^.flags := 0;
    Lit^.reserved := 0;
    Lit^.invoke := AInvoke;
    Lit^.descriptor := @NWBlockDescriptor;
    Lit^.context := Self;
    Result := Lit;
  end;
begin
  FStateBlock := MakeBlock(@NWStateThunk);
  FSendBlock  := MakeBlock(@NWSendThunk);
  FRecvBlock  := MakeBlock(@NWRecvThunk);
end;

function TTina4NWConnection.Connect(const AHost: string; APort: Integer;
  ATLS: Boolean; ATimeoutMs: Integer): Boolean;
var
  HostA, PortA: UTF8String;
  Endpoint, Params, TLSCfg: Pointer;
begin
  Result := False;
  FLastError := '';
  FErrCode := 0;

  HostA := UTF8String(AHost);
  PortA := UTF8String(IntToStr(APort));

  // Require all nw_* pointers and data globals to be resolved.
  if not Assigned(_nw_endpoint_create_host) or
     not Assigned(_nw_parameters_create_secure_tcp) or
     not Assigned(_nw_connection_create) or
     (gNSConcreteGlobalBlock = nil) or (gNWDefaultConfig = nil) or
     (gNWDefaultMsgContext = nil) then
  begin
    FLastError := 'Network.framework not available on this device/OS version';
    Exit;
  end;

  Endpoint := _nw_endpoint_create_host(PAnsiChar(HostA), PAnsiChar(PortA));
  if Endpoint = nil then
  begin
    FLastError := 'nw_endpoint_create_host failed';
    Exit;
  end;

  // The configure-protocol arguments are block POINTERS (resolved via dlsym).
  // Default TLS config = system TLS; disable the TLS layer for plain TCP.
  if ATLS then
    TLSCfg := gNWDefaultConfig
  else
    TLSCfg := gNWDisable;

  Params := _nw_parameters_create_secure_tcp(TLSCfg, gNWDefaultConfig);
  if Params = nil then
  begin
    _nw_release(Endpoint);
    FLastError := 'nw_parameters_create_secure_tcp failed';
    Exit;
  end;

  FConn := _nw_connection_create(Endpoint, Params);
  _nw_release(Endpoint);
  _nw_release(Params);
  if FConn = nil then
  begin
    FLastError := 'nw_connection_create failed';
    Exit;
  end;

  FQueue := dispatch_queue_create('tina4.nw.connection', nil);
  BuildBlocks;

  FConnReady := False;
  FConnState := NW_STATE_INVALID;

  _nw_connection_set_queue(FConn, FQueue);
  _nw_connection_set_state_changed_handler(FConn, FStateBlock);
  FStarted := True;
  _nw_connection_start(FConn);

  // Block until the handler reports ready, failed, or we time out.
  if dispatch_semaphore_wait(FConnSem,
       dispatch_time(DISPATCH_TIME_NOW, Int64(ATimeoutMs) * 1000000)) <> 0 then
  begin
    FLastError := 'TLS/TCP connect timed out';
    _nw_connection_cancel(FConn);
    Exit;
  end;

  Result := FConnReady;
  if not Result and (FLastError = '') then
    FLastError := 'connection failed (nw error ' + IntToStr(FErrCode) + ')';
end;

function TTina4NWConnection.Read(ABuf: PByte; ALen: Integer): Integer;
begin
  if (FConn = nil) or (ALen <= 0) then Exit(-1);

  FRecvTarget := ABuf;
  FRecvTargetLen := ALen;
  FRecvLen := 0;
  FRecvErr := False;
  FRecvEOF := False;

  // minimum 1 byte, maximum ALen — completion fires once on the queue
  _nw_connection_receive(FConn, 1, Cardinal(ALen), FRecvBlock);
  dispatch_semaphore_wait(FRecvSem, DISPATCH_TIME_FOREVER);

  if FRecvErr then
    Exit(-1);
  if FRecvEOF and (FRecvLen = 0) then
    Exit(0);
  Result := FRecvLen;
end;

function TTina4NWConnection.Write(ABuf: PByte; ALen: Integer): Integer;
var
  Data: Pointer;
begin
  if (FConn = nil) or (ALen <= 0) then Exit(-1);

  // Send is synchronous here (we wait for the completion), so the caller's
  // buffer stays valid for the whole call regardless of copy semantics.
  Data := dispatch_data_create(ABuf, NativeUInt(ALen), FQueue, nil);
  if Data = nil then Exit(-1);

  FSendErr := False;
  _nw_connection_send(FConn, Data, gNWDefaultMsgContext,
    0 {is_complete = false}, FSendBlock);
  dispatch_semaphore_wait(FSendSem, DISPATCH_TIME_FOREVER);
  dispatch_release(Data);

  if FSendErr then
    Exit(-1);
  Result := ALen;
end;

procedure TTina4NWConnection.Shutdown;
begin
  // Only cancel (and drain) if nw_connection_start was ever called; otherwise
  // no state-change callbacks are in flight.
  if not FStarted or (FConn = nil) or not Assigned(_nw_connection_cancel) then
    Exit;

  _nw_connection_cancel(FConn);

  // Block until NWStateThunk reports NW_STATE_CANCELLED.
  // This guarantees that no GCD callback is still accessing fields of this
  // object when Destroy returns and the Pascal memory is freed.
  // The CANCELLED state may have already arrived (e.g. connect timed out
  // and we cancelled then), in which case FDrainSem is already at 1 and
  // this returns immediately. A 2-second safety timeout prevents a hang if
  // the framework never delivers the callback for any reason.
  dispatch_semaphore_wait(FDrainSem,
    dispatch_time(DISPATCH_TIME_NOW, Int64(2000) * 1000 * 1000));
end;

function TTina4NWConnection.GetLastError: string;
begin
  Result := FLastError;
end;
{$ENDIF}

initialization
  FLoadLock := TCriticalSection.Create;
  {$IFDEF IOS}
  NWBlockDescriptor.reserved := 0;
  NWBlockDescriptor.size := SizeOf(TNWBlockLiteral);
  NWResolveSymbols;  // resolve Network.framework data symbols via dlsym
  {$ENDIF}

finalization
  UnloadOpenSSL;
  FLoadLock.Free;

end.
