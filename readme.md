# Tina4Delphi

This is not another framework for Delphi

## Requirements

- Delphi 10.4+ (FireMonkey / FMX)
- FireDAC components
- Indy (for TTina4WebServer)
- SSL DLLs:
  - Extract **32-bit** SSL DLLs to `C:\Windows\SysWOW64` (required for the IDE)
  - Extract **64-bit** SSL DLLs to `C:\Windows\System32` (required for your applications)

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
| `TTina4Twig` | Tina4Twig | Twig-style template engine |

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

## TTina4WebServer -- HTTP Server

Wraps an Indy `TIdHTTPServer` with route dispatching and database integration.

```delphi
// Design-time: link HTTPServer and Connection components
Tina4WebServer1.HTTPServer := IdHTTPServer1;
Tina4WebServer1.Connection := FDConnection1;
Tina4WebServer1.PublicPath := 'C:\myapp\public';
Tina4WebServer1.Active := True;
```

### Database Queries

```delphi
var
  JSON: TJSONObject;
begin
  JSON := Tina4WebServer1.JSONFromDB('SELECT * FROM products', 'products');
end;
```

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

## TTina4HTMLRender -- FMX HTML Renderer

An FMX control that parses and renders basic HTML directly on a canvas.

```delphi
Tina4HTMLRender1.HTML.Text := '<h1>Hello</h1><p>This is <b>bold</b> and <i>italic</i>.</p>';
```

Supports: `h1`-`h6`, `p`, `div`, `b`/`strong`, `i`/`em`, `a`, `ul`/`ol`/`li`, `hr`, `br`, `pre`, `blockquote`, `img` (alt text), inline styles (`color`, `font-size`, `font-family`, `font-weight`, `font-style`).

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

## Change Log

- 2024-01-10 Fixed access violation when REST request did not work, returns as error JSON in Execute
- 2024-01-10 Added GetJSONFromTable to Core and better error handling for REST requests
- 2025-07-30 Added Twig support
