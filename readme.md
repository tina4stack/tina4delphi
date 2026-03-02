# Tina4Delphi

This is not another framework for Delphi

## Requirements

- Delphi 10.4+ (FireMonkey / FMX)
- FireDAC components
- Indy (for TTina4WebServer)
- OpenSSL DLLs (for `TTina4WebServer`, `TTina4RESTRequest`, and `TTina4WebSocketClient`):
  - **Bundled**: 32-bit and 64-bit OpenSSL 3.x DLLs are included in `lib/win32` and `lib/win64`
  - Copy the appropriate DLLs next to your executable, or install system-wide:
    - **32-bit** DLLs (`libssl-3.dll`, `libcrypto-3.dll`) to `C:\Windows\SysWOW64` or next to your 32-bit exe
    - **64-bit** DLLs (`libssl-3-x64.dll`, `libcrypto-3-x64.dll`) to `C:\Windows\System32` or next to your 64-bit exe

## Components

| Component | Unit | Description |
|---|---|---|
| `TTina4REST` | Tina4REST | REST client configuration (base URL, auth, headers) |
| `TTina4RESTRequest` | Tina4RESTRequest | Executes REST calls and populates MemTables |
| `TTina4JSONAdapter` | Tina4JSONAdapter | Populates a MemTable from JSON (static or from a MasterSource) |
| `TTina4WebServer` | Tina4WebServer | Indy-based HTTP server with route handling |
| `TTina4Route` | Tina4Route | Defines an endpoint route for the web server |
| `TTina4SocketServer` | Tina4SocketServer | TCP/UDP socket server |
| `TTina4HTMLRender` | Tina4HTMLRender | FMX control that renders HTML to canvas |
| `TTina4HTMLPages` | Tina4HTMLPages | Design-time page navigation for TTina4HTMLRender |
| `TTina4Twig` | Tina4Twig | Twig-style template engine |
| `TTina4WebSocketClient` | Tina4WebSocketClient | WebSocket client with TLS, auto-reconnect, and ping/pong |


## Tina4Core Reference

`Tina4Core.pas` provides standalone utility functions used by the components and available for direct use in your code.

### String / Naming Conventions

#### CamelCase

Converts a `snake_case` field name to `camelCase`. Used when converting database field names to JSON keys.

```delphi
CamelCase('first_name');    // 'firstName'
CamelCase('id');            // 'id'
CamelCase('user_email');    // 'userEmail'
```

#### SnakeCase

Converts a `camelCase` field name to `snake_case`. Used when mapping JSON keys back to database columns.

```delphi
SnakeCase('firstName');   // 'first_name'
SnakeCase('userEmail');   // 'user_email'
```

### GUID

#### GetGUID

Returns a new GUID string without the surrounding braces.

```delphi
var
  ID: String;
begin
  ID := GetGUID;  // e.g. 'A1B2C3D4-E5F6-7890-ABCD-EF1234567890'
end;
```

### Date Utilities

#### IsDate

Checks whether a Variant value represents a date. Supports ISO 8601, `YYYY-MM-DD HH:NN:SS`, `YYYY-MM-DD`, and `MM/DD/YYYY` formats. Numeric types always return `False`.

```delphi
IsDate('2024-01-15');                  // True
IsDate('2024-01-15T10:30:00');         // True
IsDate('2024-01-15T10:30:00.000Z');    // True
IsDate('01/15/2024');                  // True
IsDate(42);                            // False
IsDate('hello');                       // False
```

#### GetJSONDate

Converts a `TDateTime` to an ISO 8601 string suitable for JSON.

```delphi
GetJSONDate(Now);  // '2024-06-15T14:30:00.000Z'
```

#### JSONDateToDateTime

Converts an ISO 8601 date string from JSON back to a `TDateTime`.

```delphi
var
  DT: TDateTime;
begin
  DT := JSONDateToDateTime('2024-06-15T14:30:00.000Z');
end;
```

### Encoding

#### DecodeBase64

Decodes a Base64-encoded string to a plain UTF-8 string.

```delphi
DecodeBase64('SGVsbG8gV29ybGQ=');  // 'Hello World'
```

#### FileToBase64

Reads a file from disk and returns its content as a Base64-encoded string.

```delphi
var
  B64: String;
begin
  B64 := FileToBase64('C:\photos\avatar.jpg');
end;
```

#### BitmapToBase64EncodedString

*(Non-Linux only)* Encodes an FMX `TBitmap` to a Base64 string. Optionally resizes the image first.

```delphi
var
  Encoded: String;
begin
  Encoded := BitmapToBase64EncodedString(MyBitmap);              // resize to 256x256
  Encoded := BitmapToBase64EncodedString(MyBitmap, False);       // no resize
  Encoded := BitmapToBase64EncodedString(MyBitmap, True, 128, 128);  // resize to 128x128
end;
```

#### BitmapToSkiaWepPEncodedString

*(Requires SKIA define)* Encodes an FMX `TBitmap` to a WebP Base64 string using Skia.

```delphi
var
  WebPData: String;
begin
  WebPData := BitmapToSkiaWepPEncodedString(MyBitmap, 90);  // quality 90
end;
```

### JSON Parsing

#### StrToJSONObject

Parses a JSON string into a `TJSONObject`. Returns `nil` on failure.

```delphi
var
  Obj: TJSONObject;
begin
  Obj := StrToJSONObject('{"name": "Andre", "age": 30}');
  try
    if Assigned(Obj) then
      ShowMessage(Obj.GetValue<String>('name'));
  finally
    Obj.Free;
  end;
end;
```

#### StrToJSONValue

Parses a JSON string into a `TJSONValue`. Returns `nil` on failure. Useful when the input could be an object, array, or primitive.

```delphi
var
  Val: TJSONValue;
begin
  Val := StrToJSONValue('"hello"');
end;
```

#### StrToJSONArray

Parses a JSON string into a `TJSONArray`. Returns `nil` on failure.

```delphi
var
  Arr: TJSONArray;
begin
  Arr := StrToJSONArray('[1, 2, 3]');
  try
    if Assigned(Arr) then
      ShowMessage(IntToStr(Arr.Count));  // '3'
  finally
    Arr.Free;
  end;
end;
```

#### BytesToJSONObject

Parses a `TBytes` buffer (e.g. an HTTP response body) into a `TJSONObject`.

```delphi
var
  ResponseBytes: TBytes;
  Obj: TJSONObject;
begin
  ResponseBytes := TEncoding.UTF8.GetBytes('{"ok": true}');
  Obj := BytesToJSONObject(ResponseBytes);
end;
```

#### GetJSONFieldName

Strips surrounding quotes from a JSON field name string.

```delphi
GetJSONFieldName('"firstName"');  // 'firstName'
GetJSONFieldName('id');           // 'id'
```

### Database to JSON

#### GetJSONFromDB

Executes a SQL query via a `TFDConnection` and returns the results as a `TJSONObject` containing a named array of records. Field names are automatically converted to camelCase. Blob fields are Base64-encoded. DateTime fields are formatted as ISO 8601.

```delphi
var
  Connection: TFDConnection;
  Result: TJSONObject;
begin
  // Simple query
  Result := GetJSONFromDB(Connection, 'SELECT * FROM users');
  // {"records": [{"id": "1", "firstName": "Andre", ...}, ...]}

  // With custom dataset name
  Result := GetJSONFromDB(Connection, 'SELECT * FROM cats', nil, 'cats');
  // {"cats": [{"id": "1", "name": "Whiskers"}, ...]}

  // With parameters
  var Params := TFDParams.Create;
  try
    Params.Add('status', 'active');
    Result := GetJSONFromDB(Connection, 'SELECT * FROM users WHERE status = :status', Params);
  finally
    Params.Free;
  end;
end;
```

#### GetJSONFromTable (TFDMemTable)

Converts all rows in a `TFDMemTable` to a JSON object. Field names are converted to camelCase (consistent with `GetJSONFromDB`). Supports ignoring specific fields and blank values.

```delphi
var
  MemTable: TFDMemTable;
  JSON: TJSONObject;
begin
  JSON := GetJSONFromTable(MemTable);
  // {"records": [{"id": "1", "name": "Item1"}, ...]}

  // Ignore specific fields
  JSON := GetJSONFromTable(MemTable, 'records', 'password,secret_key');

  // Ignore blank values
  JSON := GetJSONFromTable(MemTable, 'records', '', True);
end;
```

#### GetJSONFromTable (TFDTable)

Same as above but for `TFDTable` (database-backed table). Both overloads apply camelCase transformation to field names.

```delphi
var
  Table: TFDTable;
  JSON: TJSONObject;
begin
  Table.Connection := FDConnection1;
  Table.TableName := 'users';
  JSON := GetJSONFromTable(Table, 'users');
  // {"users": [{"firstName": "Andre", "lastName": "Smith"}, ...]}
end;
```

### JSON to MemTable

#### GetFieldDefsFromJSONObject

Creates field definitions on a `TFDMemTable` based on the structure of a `TJSONObject`. Nested objects and arrays become `ftMemo` fields; all others become `ftString(1000)`. Optionally transforms field names to snake_case.

```delphi
var
  JSONObj: TJSONObject;
  MemTable: TFDMemTable;
begin
  JSONObj := StrToJSONObject('{"firstName": "Andre", "address": {"city": "Cape Town"}}');
  GetFieldDefsFromJSONObject(JSONObj, MemTable, True);
  // Creates fields: first_name (ftString), address (ftMemo)
end;
```

#### PopulateMemTableFromJSON

Parses JSON and populates a `TFDMemTable`. Supports two sync modes:

- **Clear** (default) -- empties the table first, then appends all records
- **Sync** -- matches records by `IndexFieldNames` and updates existing rows or inserts new ones

```delphi
var
  MemTable: TFDMemTable;
begin
  // Clear mode (default) -- replaces all data
  PopulateMemTableFromJSON(MemTable, 'records',
    '{"records": [{"id": "1", "name": "Alice"}, {"id": "2", "name": "Bob"}]}');

  // Sync mode -- update existing, insert new
  PopulateMemTableFromJSON(MemTable, 'records',
    '{"records": [{"id": "1", "name": "Alice Updated"}]}',
    'id',                    // IndexFieldNames -- comma-separated key fields
    TTina4RestSyncMode.Sync  // Sync mode
  );

  // With snake_case transformation
  PopulateMemTableFromJSON(MemTable, 'records',
    '{"records": [{"firstName": "Andre"}]}',
    'first_name', Clear, nil, True);
  // JSON key "firstName" is stored in field "first_name"
end;
```

#### PopulateTableFromJSON

Inserts or updates rows directly into a database table (via `TFDTable`) from JSON. Uses a primary key for upsert logic. Returns a JSON object of the affected rows.

```delphi
var
  Result: TJSONObject;
begin
  Result := PopulateTableFromJSON(
    FDConnection1,
    'users',
    '{"response": [{"name": "Alice"}, {"name": "Bob"}]}',
    'response',  // DataKey
    'id'         // PrimaryKey
  );
end;
```

### HTTP Requests

#### SendHttpRequest

Low-level function that sends an HTTP request and returns the raw response as `TBytes`. Supports GET, POST, PATCH, PUT, and DELETE. Includes Basic Auth, custom headers, timeouts, and content type configuration.

```delphi
var
  StatusCode: Integer;
  Response: TBytes;
begin
  // Simple GET
  Response := SendHttpRequest(StatusCode, 'https://api.example.com', '/users');

  // POST with JSON body
  Response := SendHttpRequest(StatusCode,
    'https://api.example.com', '/users', '',
    '{"name": "Andre"}',
    'application/json', 'utf-8', '', '', nil, 'Tina4Delphi',
    TTina4RequestType.Post);

  // With Basic Auth
  Response := SendHttpRequest(StatusCode,
    'https://api.example.com', '/secure', '', '',
    'application/json', 'utf-8',
    'myuser', 'mypassword');

  // Parse the result
  var JSON := BytesToJSONObject(Response);
end;
```

#### SendMultipartFormData

Sends a multipart/form-data POST request for file uploads with optional form fields.

```delphi
var
  StatusCode: Integer;
  Response: TBytes;
begin
  Response := SendMultipartFormData(
    StatusCode,
    'https://api.example.com',
    'upload/avatar',
    ['userId', '1001', 'caption', 'Profile photo'],   // form fields (name, value pairs)
    ['avatar', 'C:\photos\me.jpg'],                    // files (field name, file path pairs)
    '',           // query params
    'myuser',     // username
    'mypassword'  // password
  );
end;
```

### Shell Commands

#### ExecuteShellCommand

Runs a shell command and captures its stdout output. Works on both Windows and Linux/macOS.

```delphi
var
  Output: String;
  ExitCode: Integer;
begin
  ExitCode := ExecuteShellCommand('dir C:\temp', Output);
  ShowMessage(Output);
end;
```

## TTina4REST -- REST Client

Drop a `TTina4REST` component on your form and configure the base URL, authentication, and headers. Other components (`TTina4RESTRequest`) reference this for their HTTP calls.

```delphi
// Design-time: set BaseUrl, Username, Password in Object Inspector
// Runtime:
Tina4REST1.BaseUrl := 'https://api.example.com/v1';
Tina4REST1.Username := 'admin';
Tina4REST1.Password := 'secret';
Tina4REST1.SetBearer('eyJhbGciOiJIUzI1NiJ9...');

// Direct REST calls (returns TJSONObject -- caller must free)
var
  StatusCode: Integer;
  Response: TJSONObject;
begin
  Response := Tina4REST1.Get(StatusCode, '/users', 'page=1&limit=10');
  try
    Memo1.Lines.Text := Response.ToString;
  finally
    Response.Free;
  end;
end;
```

### Properties

| Property | Type | Description |
|---|---|---|
| `BaseUrl` | `string` | Base URL for all REST requests (e.g. `https://api.example.com/v1`) |
| `Username` | `string` | Username for HTTP Basic Authentication |
| `Password` | `string` | Password for HTTP Basic Authentication |
| `UserAgent` | `string` | User-Agent string sent with requests (default: `Tina4REST`) |
| `CustomHeaders` | `TURLHeaders` | Custom HTTP headers sent with every request |
| `ReadTimeOut` | `Integer` | Read timeout in milliseconds |
| `ConnectTimeOut` | `Integer` | Connection timeout in milliseconds |

### Methods

| Method | Description |
|---|---|
| `Get(StatusCode, EndPoint, QueryParams)` | HTTP GET, returns `TJSONObject` |
| `Post(StatusCode, EndPoint, QueryParams, Body)` | HTTP POST |
| `Patch(StatusCode, EndPoint, QueryParams, Body)` | HTTP PATCH |
| `Put(StatusCode, EndPoint, QueryParams, Body)` | HTTP PUT |
| `Delete(StatusCode, EndPoint, QueryParams)` | HTTP DELETE |
| `SetBearer(Token)` | Adds an `Authorization: Bearer` header |

## TTina4RESTRequest -- Declarative REST Calls

Links to a `TTina4REST` component and executes REST calls with automatic MemTable population.

### Basic GET with MemTable

```delphi
// Design-time:
//   Tina4REST     -> Tina4REST1
//   EndPoint      -> /users
//   RequestType   -> Get
//   DataKey       -> records
//   MemTable      -> FDMemTable1
//   SyncMode      -> Clear

// Runtime:
Tina4RESTRequest1.ExecuteRESTCall;
// FDMemTable1 is now populated with the "records" array from the response
```

### POST with Request Body

```delphi
Tina4RESTRequest1.RequestType := TTina4RequestType.Post;
Tina4RESTRequest1.EndPoint := '/users';
Tina4RESTRequest1.RequestBody.Text := '{"name": "Andre", "email": "andre@test.com"}';
Tina4RESTRequest1.ExecuteRESTCall;
```

### Master/Detail with Parameter Injection

When a `MasterSource` is set, field values from the master's MemTable are injected into the endpoint, request body, and query params using `{fieldName}` placeholders.

```delphi
// Master request fetches customers
Tina4RESTRequest1.EndPoint := '/customers';
Tina4RESTRequest1.DataKey := 'records';
Tina4RESTRequest1.MemTable := FDMemTableCustomers;

// Detail request fetches orders for the current customer
Tina4RESTRequest2.MasterSource := Tina4RESTRequest1;
Tina4RESTRequest2.EndPoint := '/customers/{id}/orders';
Tina4RESTRequest2.DataKey := 'records';
Tina4RESTRequest2.MemTable := FDMemTableOrders;
```

### SourceMemTable -- POST from MemTable Data

Links a `TFDMemTable` as the request body source. The table rows are serialized to JSON automatically.

```delphi
Tina4RESTRequest1.RequestType := TTina4RequestType.Post;
Tina4RESTRequest1.EndPoint := '/import';
Tina4RESTRequest1.SourceMemTable := FDMemTableData;
Tina4RESTRequest1.SourceIgnoreFields := 'internal_id,temp_flag';
Tina4RESTRequest1.SourceIgnoreBlanks := True;
Tina4RESTRequest1.ExecuteRESTCall;
```

### Async Execution

```delphi
Tina4RESTRequest1.OnExecuteDone := procedure(Sender: TObject)
begin
  TThread.Synchronize(nil, procedure
  begin
    ShowMessage('Request complete');
  end);
end;
Tina4RESTRequest1.ExecuteRESTCallAsync;
```

### Properties

| Property | Type | Description |
|---|---|---|
| `Tina4REST` | `TTina4REST` | The REST client component to use for HTTP calls |
| `EndPoint` | `string` | URL path appended to the base URL (supports `{field}` placeholders from MasterSource) |
| `RequestType` | `TTina4RequestType` | HTTP method: `Get`, `Post`, `Patch`, `Put`, `Delete` |
| `DataKey` | `string` | JSON key containing the array of records in the response |
| `QueryParams` | `string` | URL query parameters (supports `{field}` placeholders) |
| `MemTable` | `TFDMemTable` | Target MemTable to populate with response data |
| `SourceMemTable` | `TFDMemTable` | Source MemTable whose rows are serialized as the request body |
| `SourceIgnoreFields` | `string` | Comma-separated field names to exclude from SourceMemTable serialization |
| `SourceIgnoreBlanks` | `Boolean` | Skip blank values when serializing SourceMemTable |
| `RequestBody` | `TStringList` | Raw request body (supports `{field}` placeholders) |
| `ResponseBody` | `TStringList` | Raw response body after execution (read-only at runtime) |
| `MasterSource` | `TTina4RESTRequest` | Master request whose MemTable fields inject into `{field}` placeholders |
| `SyncMode` | `TTina4RestSyncMode` | `Clear` (replace all) or `Sync` (upsert by IndexFieldNames) |
| `IndexFieldNames` | `string` | Comma-separated key fields for Sync mode matching |
| `StatusCode` | `Integer` | HTTP status code from the last execution |
| `TransformResultToSnakeCase` | `Boolean` | Convert JSON camelCase keys to snake_case field names |
| `FreeOnAsyncExecute` | `Boolean` | Auto-free the component after async execution completes |

### Events

| Event | Description |
|---|---|
| `OnExecuteDone` | Fired after the REST call completes and the MemTable is populated |
| `OnAddRecord` | Fired for each record added to the MemTable, allowing custom processing |

## TTina4JSONAdapter -- JSON to MemTable Adapter

Populates a `TFDMemTable` from static JSON data or from a `TTina4RESTRequest` master source.

### From Static JSON

```delphi
// Design-time: set MemTable, DataKey, JSONData in Object Inspector
// Runtime:
Tina4JSONAdapter1.MemTable := FDMemTable1;
Tina4JSONAdapter1.DataKey := 'products';
Tina4JSONAdapter1.JSONData.Text := '{"products": [{"id": "1", "name": "Widget"}, {"id": "2", "name": "Gadget"}]}';
Tina4JSONAdapter1.Execute;
```

### From MasterSource

When linked to a `TTina4RESTRequest`, the adapter auto-executes whenever the master's `OnExecuteDone` fires.

```delphi
Tina4JSONAdapter1.MasterSource := Tina4RESTRequest1;
Tina4JSONAdapter1.DataKey := 'categories';
Tina4JSONAdapter1.MemTable := FDMemTableCategories;
// Automatically populates when Tina4RESTRequest1 completes
```

### Sync Mode

```delphi
Tina4JSONAdapter1.SyncMode := TTina4RestSyncMode.Sync;
Tina4JSONAdapter1.IndexFieldNames := 'id';
// Existing records matched by 'id' are updated; new ones are inserted
```

### Properties

| Property | Type | Description |
|---|---|---|
| `DataKey` | `string` | JSON key containing the array of records |
| `MemTable` | `TFDMemTable` | Target MemTable to populate |
| `JSONData` | `TStringList` | Static JSON data source |
| `SyncMode` | `TTina4RestSyncMode` | `Clear` (replace all) or `Sync` (upsert by IndexFieldNames) |
| `IndexFieldNames` | `string` | Comma-separated key fields for Sync mode matching |
| `MasterSource` | `TTina4RESTRequest` | Master request; adapter auto-executes on `OnExecuteDone` |

## TTina4WebServer -- HTTP Server

Wraps an Indy `TIdHTTPServer` with route dispatching and database integration.

```delphi
// Design-time: link HTTPServer and Connection components
Tina4WebServer1.HTTPServer := IdHTTPServer1;
Tina4WebServer1.Connection := FDConnection1;
Tina4WebServer1.PublicPath := 'C:\myapp\public';
Tina4WebServer1.Active := True;
```

### Properties

| Property | Type | Description |
|---|---|---|
| `HTTPServer` | `TIdHTTPServer` | The Indy HTTP server component to wrap |
| `Connection` | `TFDConnection` | FireDAC database connection for `JSONFromDB` queries |
| `PublicPath` | `string` | Filesystem path to serve static files from |
| `Active` | `Boolean` | Start/stop the HTTP server |

### Methods

| Method | Description |
|---|---|
| `JSONFromDB(SQL, DataSetName, Params)` | Execute a SQL query and return results as `TJSONObject` |

## TTina4Route -- Endpoint Routing

Define routes and link them to the web server.

```delphi
// Design-time:
//   WebServer -> Tina4WebServer1
//   EndPoint  -> /api/hello
//   CRUD      -> False

// Runtime handler:
procedure TForm1.Tina4Route1Execute(Request: TTina4Request; var Response: TTina4Response);
begin
  Response.HTTPCode := 200;
  Response.ContentType := 'application/json';
  Response.Content := '{"message": "Hello World"}';
end;
```

### Properties

| Property | Type | Description |
|---|---|---|
| `WebServer` | `TTina4WebServer` | The web server this route belongs to |
| `EndPoint` | `string` | URL path for this route (e.g. `/api/hello`) |
| `CRUD` | `Boolean` | If `True`, auto-generates GET/POST/PUT/DELETE routes |
| `OnExecute` | `TTina4EndpointExecute` | Event handler called when the route is matched |

## TTina4SocketServer -- TCP/UDP Socket Server

```delphi
Tina4SocketServer1.Host := '0.0.0.0';
Tina4SocketServer1.Port := 9000;
Tina4SocketServer1.SocketType := TSocketType.TCP;
Tina4SocketServer1.OnMessage := procedure(const Client: TSocket; Content: TBytes)
begin
  // Echo back
  Client.Send(Content);
end;
Tina4SocketServer1.Active := True;
```

### Properties

| Property | Type | Description |
|---|---|---|
| `Host` | `string` | Bind address (e.g. `0.0.0.0` for all interfaces, `127.0.0.1` for localhost) |
| `Port` | `Integer` | Port number to listen on |
| `SocketType` | `TSocketType` | `TCP` or `UDP` |
| `Active` | `Boolean` | Start/stop the socket server |
| `OnMessage` | `TTina4SocketEvent` | `procedure(const Client: TSocket; Content: TBytes)` -- fires when data is received |

## TTina4HTMLRender -- FMX HTML Renderer

An FMX control that parses and renders HTML with CSS support directly on a canvas, including native form controls, Bootstrap 5 class support, and interactive event handling.

```delphi
Tina4HTMLRender1.HTML.Text := '<h1>Hello</h1><p>This is <b>bold</b> and <i>italic</i>.</p>';
```

### Properties

| Property | Type | Description |
|---|---|---|
| `HTML` | `TStringList` | HTML content to render; changes trigger automatic relayout |
| `Twig` | `TStringList` | Twig template content; rendered to HTML via TTina4Twig on change |
| `TwigTemplatePath` | `string` | Base path for `{% include %}` and `{% extends %}` resolution |
| `Debug` | `TStringList` | Debug output for diagnostic information |
| `CacheEnabled` | `Boolean` | Enables disk-based caching for downloaded images/stylesheets (default `False`) |
| `CacheDir` | `string` | Directory path for the disk-based file cache |
| `Align` | `TAlignLayout` | FMX alignment within parent container |
| `Anchors` | `TAnchors` | FMX anchors for resize behavior |
| `ClipChildren` | `Boolean` | Clip child controls to component bounds |
| `Enabled` | `Boolean` | Enable/disable the control |
| `Height` | `Single` | Component height |
| `Width` | `Single` | Component width |
| `Margins` | `TBounds` | Outer margins |
| `Padding` | `TBounds` | Inner padding |
| `Position` | `TPosition` | Position within parent |
| `Size` | `TControlSize` | Size (Width + Height) |
| `Visible` | `Boolean` | Show/hide the control |

### Supported HTML

- **Block elements**: `h1`-`h6`, `p`, `div`, `pre`, `blockquote`, `hr`, `fieldset`
- **Inline elements**: `span`, `b`/`strong`, `i`/`em`, `a`, `br`, `small`, `label`
- **Semantic inline**: `kbd`, `abbr`, `cite`, `q`, `var`, `samp`, `dfn`, `time`
- **Lists**: `ul`, `ol`, `li` with bullet/number markers and configurable `list-style-type`
- **Tables**: `table`, `tr`, `td`, `th`, `thead`, `tbody`, `tfoot` with collapsed borders
- **Images**: `img` with HTTP download, async loading, and disk-based caching
- **Forms**: `input` (text, password, email, radio, checkbox, submit, button, reset, file), `textarea`, `select`/`option`, `button`, `label` (with `for` attribute click handling), `fieldset`/`legend`

### CSS Support

- **External stylesheets**: `<link rel="stylesheet" href="...">` with HTTP loading and caching
- **`<style>` blocks**: Embedded CSS parsed and applied
- **Inline styles**: `style="..."` attribute
- **Selectors**: tag, `.class`, `#id`, combined selectors, specificity-based cascade
- **Custom properties**: `var()` resolution with `:root` and element-level scoping
- **Box model**: `margin`, `padding`, `border`, `border-top`/`right`/`bottom`/`left`, `border-radius`, `width`, `height`, `box-sizing`, `min-width`, `max-width`, `min-height`, `max-height`, `box-shadow`
- **Display modes**: `block`, `inline`, `inline-block`, `none`, `table`, `table-row`, `table-cell`, `list-item`
- **Text**: `color`, `font-size`, `font-family`, `font-weight`, `font-style`, `text-align`, `line-height`, `text-decoration`, `white-space`, `text-transform`, `letter-spacing`, `text-indent`, `text-overflow`
- **Background**: `background-color`, `opacity`
- **Visibility**: `visibility` (`visible`, `hidden`), `overflow` (`visible`, `hidden`, `scroll`, `auto`)
- **Lists**: `list-style-type` (`disc`, `circle`, `square`, `decimal`, `lower-alpha`, `upper-alpha`, `lower-roman`, `upper-roman`, `none`)
- **Word wrapping**: `word-break` (`break-all`), `overflow-wrap`/`word-wrap` (`break-word`, `anywhere`)
- **Bootstrap 5 fallbacks**: `.btn` variants (`btn-primary`, `btn-danger`, etc.), `.form-control`, `.form-check`, `.text-muted`

### Form Controls

Native FMX controls are created for form elements, styled with CSS properties from the HTML.

```delphi
Tina4HTMLRender1.HTML.Text :=
  '<form name="login">' +
  '  <input type="text" name="username" placeholder="Username">' +
  '  <input type="password" name="password" placeholder="Password">' +
  '  <input type="file" name="avatar" accept="image/*">' +
  '  <button type="submit" class="btn btn-primary">Login</button>' +
  '</form>';
```

File inputs render a "Choose File" button with an open file dialog.

### Events

| Event | Signature | Description |
|---|---|---|
| `OnFormControlChange` | `procedure(Sender: TObject; const Name, Value: string)` | Fires when any form control value changes |
| `OnFormControlClick` | `procedure(Sender: TObject; const Name, Value: string)` | Fires when a form control is clicked |
| `OnFormControlEnter` | `procedure(Sender: TObject; const Name, Value: string)` | Fires when a form control gains focus |
| `OnFormControlExit` | `procedure(Sender: TObject; const Name, Value: string)` | Fires when a form control loses focus |
| `OnFormSubmit` | `procedure(Sender: TObject; const FormName: string; FormData: TStrings)` | Fires when a submit button is clicked, with all form data as `name=value` pairs |
| `OnElementClick` | `procedure(Sender: TObject; const ObjectName, MethodName: string; Params: TStrings)` | Fires when any element with an `onclick` attribute is clicked (fallback when RTTI invocation is not available) |

### OnFormSubmit

When a submit button is clicked, the `OnFormSubmit` event fires with the form name and all form data collected as `name=value` pairs. Submit/button/reset inputs are excluded from the data.

```delphi
procedure TForm1.HTMLRender1FormSubmit(Sender: TObject;
  const FormName: string; FormData: TStrings);
begin
  ShowMessage('Form: ' + FormName);
  for var I := 0 to FormData.Count - 1 do
    ShowMessage(FormData[I]);  // e.g. "username=admin"
end;
```

### onclick Events and RTTI Method Invocation

Any HTML element can have an `onclick` attribute that calls a Pascal method directly via RTTI. The format is:

```
onclick="ObjectName:MethodName(param1, param2, ...)"
```

Register your Delphi objects in `FormCreate`:

```delphi
procedure TForm3.FormCreate(Sender: TObject);
begin
  HTMLRender1.RegisterObject('Form3', Self);
end;
```

Then in your HTML:

```html
<span onclick="Form3:ShowSomething('World')">Click me</span>
<button onclick="Form3:HandleClick(document.getElementById('nameInput').value)">Submit</button>
```

The method is called directly -- no event handler needed:

```delphi
procedure TForm3.ShowSomething(Name: String);
begin
  ShowMessage('Hello ' + Name);
end;
```

**Supported parameter expressions:**

| Expression | Resolves to |
|---|---|
| `'literal'` or `"literal"` | String literal |
| `123` | Numeric literal |
| `this.value` | Value of the clicked element |
| `this.id` | ID attribute of the clicked element |
| `this.name` | Name attribute of the clicked element |
| `this.<attr>` | Any attribute of the clicked element |
| `document.getElementById('id').value` | Value of the element with the given ID |
| `document.getElementById('id').<attr>` | Any attribute of the element with the given ID |

If the registered object or method is not found, the `OnElementClick` event fires as a fallback.

### DOM Manipulation from Pascal

Modify rendered HTML elements from Delphi code at runtime:

```delphi
// Get/set values
HTMLRender1.SetElementValue('emailInput', 'user@example.com');
var Value := HTMLRender1.GetElementValue('emailInput');

// Enable/disable controls
HTMLRender1.SetElementEnabled('submitBtn', False);

// Show/hide elements
HTMLRender1.SetElementVisible('errorMessage', True);

// Change text content
HTMLRender1.SetElementText('statusLabel', 'Loading...');

// Change inline styles
HTMLRender1.SetElementStyle('myDiv', 'background-color', 'red');

// Set any attribute
HTMLRender1.SetElementAttribute('myLink', 'href', 'https://example.com');

// Access the DOM tag directly
var Tag := HTMLRender1.GetElementById('myElement');
```

| Method | Description |
|---|---|
| `GetElementById(Id)` | Returns the `THTMLTag` for the element |
| `GetElementValue(Id)` | Gets the live value from a native control or DOM attribute |
| `SetElementValue(Id, Value)` | Sets the value on native controls (TEdit, TCheckBox, etc.) and DOM |
| `SetElementAttribute(Id, Attr, Value)` | Sets any attribute; triggers relayout for `class`/`style` changes |
| `SetElementEnabled(Id, Enabled)` | Enables/disables native controls with opacity change |
| `SetElementVisible(Id, Visible)` | Shows/hides elements via `display:none`, triggers relayout |
| `SetElementText(Id, Text)` | Updates inner text content and native control labels |
| `SetElementStyle(Id, Prop, Value)` | Sets an inline style property, triggers relayout |
| `RefreshElement(Id)` | Forces a full re-layout and repaint |

### Image Loading and Caching

Images are downloaded via HTTP asynchronously and cached to disk when caching is enabled.

```delphi
Tina4HTMLRender1.CacheEnabled := True;
Tina4HTMLRender1.CacheDir := 'C:\MyApp\cache';
Tina4HTMLRender1.HTML.Text := '<img src="https://example.com/photo.jpg" width="200" height="150">';
```

### Twig Template Integration

The `Twig` property accepts Twig template content that is automatically rendered to HTML via the built-in TTina4Twig engine. When content is assigned to `Twig`, the template is rendered and the result is set on the `HTML` property.

```delphi
// Set template variables first
Tina4HTMLRender1.SetTwigVariable('title', 'Hello World');
Tina4HTMLRender1.SetTwigVariable('name', 'Andre');

// Set Twig template — automatically renders to HTML
Tina4HTMLRender1.Twig.Text :=
  '<h1>{{ title }}</h1>' +
  '<p>Welcome, {{ name }}!</p>' +
  '{% if name %}' +
  '  <p>User is logged in.</p>' +
  '{% endif %}';
```

If your templates use `{% include %}` or `{% extends %}`, set the template path first:

```delphi
Tina4HTMLRender1.TwigTemplatePath := 'C:\MyApp\templates';
Tina4HTMLRender1.Twig.LoadFromFile('C:\MyApp\templates\page.html');
```

| Property / Method | Description |
|---|---|
| `Twig: TStringList` | Twig template content — renders to HTML automatically on change |
| `TwigTemplatePath: string` | Base path for `{% include %}` and `{% extends %}` resolution |
| `SetTwigVariable(Name, Value)` | Pass a variable to the Twig rendering context |

## TTina4HTMLPages -- Page Navigation

A design-time component that provides SPA-style page navigation using `TTina4HTMLRender`. Pages are defined as a collection at design time via the Object Inspector's collection editor. Each page contains Twig or raw HTML content. Navigation is triggered by clicking `<a href="#pagename">` links in the rendered HTML.

### Basic Setup

```delphi
// Drop TTina4HTMLPages and TTina4HTMLRender on the form
// Link them at design time or runtime:
Tina4HTMLPages1.Renderer := Tina4HTMLRender1;

// Pages are defined in the collection editor at design time,
// or created at runtime:
var Page := Tina4HTMLPages1.Pages.Add;
Page.PageName := 'home';
Page.IsDefault := True;
Page.HTMLContent.Text := '<h1>Home</h1><a href="#about">Go to About</a>';

Page := Tina4HTMLPages1.Pages.Add;
Page.PageName := 'about';
Page.HTMLContent.Text := '<h1>About</h1><a href="#home">Back to Home</a>';
```

### Navigation with Twig Templates

Pages can use Twig templates instead of raw HTML. Set template variables before navigating:

```delphi
Tina4HTMLPages1.SetTwigVariable('userName', 'Andre');

var Page := Tina4HTMLPages1.Pages.Add;
Page.PageName := 'dashboard';
Page.TwigContent.Text :=
  '<h1>Welcome {{ userName }}</h1>' +
  '<a href="#settings">Settings</a>';
```

If templates use `{% include %}` or `{% extends %}`, set the template path:

```delphi
Tina4HTMLPages1.TwigTemplatePath := 'C:\MyApp\templates';
```

### Programmatic Navigation

```delphi
Tina4HTMLPages1.NavigateTo('dashboard');
```

### Link Convention

Anchor `href` values are mapped to page names by stripping the leading `#` or `/`:

| `href` value | Maps to PageName |
|---|---|
| `#dashboard` | `dashboard` |
| `/settings` | `settings` |
| `about` | `about` |

### Events

| Event | Signature | Description |
|---|---|---|
| `OnBeforeNavigate` | `procedure(Sender: TObject; const FromPage, ToPage: string; var Allow: Boolean)` | Fires before navigation; set `Allow := False` to cancel |
| `OnAfterNavigate` | `procedure(Sender: TObject)` | Fires after the new page has been rendered |

### TTina4Page Properties

| Property | Type | Description |
|---|---|---|
| `PageName` | `string` | Unique name used as navigation target |
| `TwigContent` | `TStringList` | Twig template source (rendered via TTina4Twig) |
| `HTMLContent` | `TStringList` | Raw HTML (used when TwigContent is empty) |
| `IsDefault` | `Boolean` | If `True`, this page is shown on startup |

### TTina4HTMLPages Properties

| Property | Type | Description |
|---|---|---|
| `Pages` | `TTina4PageCollection` | Collection of pages (design-time editable) |
| `Renderer` | `TTina4HTMLRender` | The HTML renderer that displays the active page |
| `ActivePage` | `string` | Name of the currently displayed page |
| `TwigTemplatePath` | `string` | Base path for Twig `{% include %}` / `{% extends %}` |

### OnLinkClick Event on TTina4HTMLRender

The renderer exposes an `OnLinkClick` event that fires when any `<a href="...">` link is clicked. TTina4HTMLPages hooks into this automatically, but you can also use it independently:

```delphi
procedure TForm1.HTMLRender1LinkClick(Sender: TObject; const AURL: string;
  var Handled: Boolean);
begin
  if AURL.StartsWith('http') then
  begin
    // Open external links in browser
    ShellExecute(0, 'open', PChar(AURL), nil, nil, SW_SHOW);
    Handled := True;
  end;
end;
```

## TTina4Twig -- Template Engine

A Twig-compatible template engine for server-side rendering.

```delphi
var
  Twig: TTina4Twig;
  Variables: TStringDict;
begin
  Twig := TTina4Twig.Create('C:\templates');
  Variables := TStringDict.Create;
  try
    Variables.Add('name', 'Andre');
    Variables.Add('items', TValue.From<TArray<String>>(['Apple', 'Banana', 'Cherry']));

    Memo1.Lines.Text := Twig.Render('hello.html', Variables);
  finally
    Variables.Free;
    Twig.Free;
  end;
end;
```

Template syntax supports: `{{ variable }}`, `{% if %}`, `{% for %}`, `{% include %}`, `{% extends %}`, `{% block %}`, `{% macro %}`, filters (`|upper`, `|lower`, `|length`, `|default`, etc.), and functions (`range()`, `dump()`, etc.).

## TTina4WebSocketClient -- WebSocket Client

A cross-platform WebSocket client component using `System.Net.Socket` (no Indy dependency). Supports `ws://` and `wss://` (TLS via OpenSSL), auto-reconnect, custom headers, and ping/pong keep-alive.

### Basic Usage (Console)

```delphi
type
  TWSHandler = class
    Client: TTina4WebSocketClient;
    procedure OnConnected(Sender: TObject);
    procedure OnMessage(Sender: TObject; const AMessage: string);
    procedure OnError(Sender: TObject; const AError: string);
    procedure OnDisconnected(Sender: TObject; const ACode: Integer;
      const AReason: string);
  end;

procedure TWSHandler.OnConnected(Sender: TObject);
begin
  WriteLn('Connected!');
  Client.Send('{"action": "subscribe", "topic": "MyTopic"}');
end;

procedure TWSHandler.OnMessage(Sender: TObject; const AMessage: string);
begin
  WriteLn('Received: ' + AMessage);
end;

// ... create handler, assign events, connect:
Handler.Client := TTina4WebSocketClient.Create(nil);
Handler.Client.URL := 'wss://example.com/ws';
Handler.Client.Headers.Add('Authorization: Bearer <token>');
Handler.Client.OnConnected := Handler.OnConnected;
Handler.Client.OnMessage := Handler.OnMessage;
Handler.Client.Connect;

// Event loop (console apps only -- GUI apps use the message pump)
while SecondsBetween(Now, StartTime) < 60 do
  CheckSynchronize(100);
```

### VCL/FMX Usage

In GUI applications, events are dispatched automatically via `TThread.Queue`. No `CheckSynchronize` loop is needed.

```delphi
procedure TForm1.FormCreate(Sender: TObject);
begin
  WS := TTina4WebSocketClient.Create(Self);
  WS.URL := 'wss://api.example.com/notifications';
  WS.Headers.Add('Authorization: Bearer my-token');
  WS.OnConnected := HandleConnected;
  WS.OnMessage := HandleMessage;
  WS.OnError := HandleError;
  WS.OnDisconnected := HandleDisconnected;
end;

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  WS.Connect;
end;

procedure TForm1.HandleConnected(Sender: TObject);
begin
  Label1.Text := 'Connected';
end;

procedure TForm1.HandleMessage(Sender: TObject; const AMessage: string);
begin
  Memo1.Lines.Add(AMessage);
end;
```

### Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `URL` | `string` | `''` | WebSocket endpoint (`ws://` or `wss://`) |
| `Headers` | `TStrings` | empty | Custom HTTP headers (e.g. `Authorization: Bearer xxx`) |
| `AutoReconnect` | `Boolean` | `True` | Automatically reconnect on unexpected disconnect |
| `ReconnectInterval` | `Integer` | `3000` | Milliseconds between reconnect attempts |
| `ReconnectMaxAttempts` | `Integer` | `10` | Maximum reconnect attempts (0 = unlimited) |
| `PingInterval` | `Integer` | `30000` | Milliseconds between ping frames (0 = disabled) |
| `ConnectTimeout` | `Integer` | `5000` | TCP connection timeout in milliseconds |
| `State` | `TTina4WSState` | `wsClosed` | Current connection state (read-only) |

### Events

| Event | Signature | Description |
|---|---|---|
| `OnConnected` | `TNotifyEvent` | Fired when the WebSocket handshake completes |
| `OnMessage` | `procedure(Sender: TObject; const AMessage: string)` | Fired when a text message is received |
| `OnBinaryReceived` | `procedure(Sender: TObject; const AData: TBytes)` | Fired when a binary message is received |
| `OnError` | `procedure(Sender: TObject; const AError: string)` | Fired on connection or protocol errors |
| `OnDisconnected` | `procedure(Sender: TObject; const ACode: Integer; const AReason: string)` | Fired when the connection closes (code 1000 = normal) |
| `OnReconnecting` | `procedure(Sender: TObject; AAttempt: Integer)` | Fired before each reconnect attempt |

### Methods

| Method | Description |
|---|---|
| `Connect` | Start the WebSocket connection (async) |
| `Disconnect` | Send a close frame and shut down cleanly |
| `Send(const AMessage: string)` | Send a text message |
| `Send(const AData: TBytes)` | Send a binary message |
| `IsConnected: Boolean` | Returns `True` if the connection is open |

### Connection States

| State | Description |
|---|---|
| `wsClosed` | Not connected |
| `wsConnecting` | TCP/TLS handshake in progress |
| `wsOpen` | Connected and ready to send/receive |
| `wsClosing` | Close handshake in progress |
| `wsReconnecting` | Waiting to reconnect after unexpected disconnect |

### OpenSSL / TLS

The `Tina4OpenSSL` unit dynamically loads OpenSSL at runtime. No compile-time linking is required. The loader searches for libraries in this order:

| Platform | Libraries tried |
|---|---|
| Windows 64-bit | `libssl-3-x64.dll`, `libssl-1_1-x64.dll`, `libssl-3.dll`, `libssl-1_1.dll` |
| Windows 32-bit | `libssl-3.dll`, `libssl-1_1.dll`, `libssl-3-x64.dll`, `libssl-1_1-x64.dll` |
| macOS | `libssl.3.dylib`, `libssl.1.1.dylib` |
| Linux | `libssl.so.3`, `libssl.so.1.1` |

Pre-built OpenSSL 3.x DLLs are bundled in `lib/win32` and `lib/win64`. Copy the appropriate pair next to your executable if OpenSSL is not installed system-wide.

```delphi
uses Tina4OpenSSL;

if LoadOpenSSL then
  WriteLn('OpenSSL loaded')
else
  WriteLn('OpenSSL not found - wss:// will not work');
```



## Claude Pascal MCP Server

The Tina4Delphi ecosystem includes an MCP (Model Context Protocol) server that gives Claude direct access to Pascal/Delphi development tools. Once registered, Claude can compile code, run programs, parse form files, and take screenshots of running applications.

### Tools

| Tool | Description |
|---|---|
| `get_compiler_info` | Detect available Pascal compilers (fpc, dcc32, dcc64) |
| `compile_pascal` | Compile Pascal source code and return errors/warnings |
| `run_pascal` | Compile and execute code, return program output |
| `check_syntax` | Fast syntax-only check without linking |
| `parse_form` | Parse .dfm/.fmx/.lfm form files into component trees |
| `screenshot_app` | Capture a screenshot of a running application window |
| `list_app_windows` | List visible windows on the desktop |
| `setup_fpc` | Download and install Free Pascal Compiler |

### Installation

```bash
# Register with Claude Code
claude mcp add --transport stdio pascal-dev -- uv run --directory /path/to/claude-pascal-mcp pascal-mcp
```

Or add to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "pascal-dev": {
      "command": "uv",
      "args": ["run", "--directory", "/path/to/claude-pascal-mcp", "pascal-mcp"]
    }
  }
}
```

See the [claude-pascal-mcp](https://github.com/niclasborgworx/claude-pascal-mcp) repository for full documentation.

## Change Log

- 2024-01-10 Fixed access violation when REST request did not work, returns as error JSON in Execute
- 2024-01-10 Added GetJSONFromTable to Core and better error handling for REST requests
- 2025-07-30 Added Twig support
- 2026-02-27 TTina4HTMLRender: Added full CSS stylesheet support (external `<link>`, `<style>` blocks, CSS custom properties)
- 2026-02-27 TTina4HTMLRender: Added native FMX form controls (input, textarea, select, button) with CSS styling
- 2026-02-27 TTina4HTMLRender: Added `display:inline-block` support with shrink-to-fit width
- 2026-02-27 TTina4HTMLRender: Added Bootstrap 5 button class fallbacks and `.form-control`/`.form-check` support
- 2026-02-27 TTina4HTMLRender: Added `<input type="file">` support with open file dialog
- 2026-02-27 TTina4HTMLRender: Added `OnFormSubmit` event with form name and `name=value` data collection
- 2026-02-27 TTina4HTMLRender: Added `onclick` attribute support with direct RTTI method invocation via `RegisterObject`
- 2026-02-27 TTina4HTMLRender: Added DOM manipulation API (`GetElementById`, `SetElementValue`, `SetElementEnabled`, `SetElementVisible`, etc.)
- 2026-02-27 TTina4HTMLRender: Added `<label for="id">` click handling to toggle checkboxes/radios
- 2026-02-27 TTina4HTMLRender: Added HTTP image loading with async download and disk-based caching
- 2026-02-27 TTina4HTMLRender: Fixed inline-block text rendering, inter-element spacing, duplicate text on resize
- 2026-02-28 TTina4HTMLRender: Added semantic inline tags (`kbd`, `abbr`, `cite`, `q`, `var`, `samp`, `dfn`, `time`)
- 2026-02-28 TTina4HTMLRender: Added `fieldset` and `legend` form elements
- 2026-02-28 TTina4HTMLRender: Added CSS `text-transform` (uppercase, lowercase, capitalize)
- 2026-02-28 TTina4HTMLRender: Added CSS `opacity` property
- 2026-02-28 TTina4HTMLRender: Added CSS `min-width`, `max-width`, `min-height`, `max-height`
- 2026-02-28 TTina4HTMLRender: Added CSS `letter-spacing` with character-by-character rendering
- 2026-02-28 TTina4HTMLRender: Added CSS `text-indent` for first-line indentation
- 2026-02-28 TTina4HTMLRender: Added CSS `visibility` property (hidden elements still occupy layout space)
- 2026-02-28 TTina4HTMLRender: Added CSS `list-style-type` with disc, circle, square, decimal, alpha, and roman numeral markers
- 2026-02-28 TTina4HTMLRender: Added CSS `overflow: hidden` with canvas clipping
- 2026-02-28 TTina4HTMLRender: Added CSS `word-break` and `overflow-wrap` for character-level and long-word breaking
- 2026-02-28 TTina4HTMLRender: Added CSS `text-overflow: ellipsis` with background cover at clip edge
- 2026-02-28 TTina4HTMLRender: Added per-side border support (`border-top`, `border-right`, `border-bottom`, `border-left`)
- 2026-02-28 TTina4HTMLRender: Added CSS `box-shadow` with offset, blur, spread, and colored shadows
- 2026-02-28 TTina4HTMLRender: Added `Twig` property for automatic Twig-to-HTML template rendering
- 2026-02-28 TTina4HTMLRender: Added `TwigTemplatePath` property and `SetTwigVariable` method for template context
- 2026-02-28 TTina4HTMLRender: Added `OnLinkClick` event for anchor `<a href>` click interception
- 2026-02-28 TTina4HTMLPages: New design-time page navigation component with collection editor, Twig/HTML pages, `OnBeforeNavigate`/`OnAfterNavigate` events
- 2026-03-02 TTina4WebSocketClient: New WebSocket client component with RFC 6455 protocol, `ws://` and `wss://` support
- 2026-03-02 Tina4OpenSSL: New OpenSSL dynamic loader for TLS — supports OpenSSL 3.x and 1.1.x on Windows, macOS, Linux
- 2026-03-02 Bundled OpenSSL 3.6.1 DLLs for Windows (32-bit in `lib/win32`, 64-bit in `lib/win64`)
