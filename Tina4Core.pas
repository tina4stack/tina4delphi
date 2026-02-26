unit Tina4Core;

interface

uses JSON, System.SysUtils, FireDAC.DApt, FireDAC.Stan.Intf, System.RegularExpressions,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.ConsoleUI.Wait, FireDAC.Comp.DataSet,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, System.NetEncoding, System.DateUtils,
  System.Classes, System.Generics.Collections, System.Net.HttpClientComponent,
  System.IOUtils,
  System.Net.Mime,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Variants,
  {$IFNDEF LINUX}
  FMX.Graphics,
  {$ENDIF}
  {$IFDEF SKIA}
  FMX.Skia, System.Skia,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows;
  {$ELSE}
    Posix.Base,
    Posix.Fcntl,
    Posix.Stdlib;
  {$ENDIF}

type
  TStreamHandle = pointer;

  TAnoPipe = record
    Input: THandle;
    Output: THandle;
  end;

  /// <summary> The type of REST calls we can make
  /// </summary>
  TTina4RequestType = (Get,Post,Patch,Put,Delete);
  /// <summary> Sync modes to the mem table, Clear removes everything, Sync updates based on primary keys and Inserts new if they don't exist
  /// </summary>
  TTina4RestSyncMode = (Clear,Sync);
  TTina4Response = class(TObject)
    HTTPCode: Integer;
    ContentType: String;
    Content: String;
  end;

  TTina4Request = class(TObject)
    Headers: TURLHeaders;
    QueryParams: TStringList;
    Body: String;
  end;

  TTina4EndpointExecute = procedure(Request : TTina4Request; var Response: TTina4Response) of object;
  TTina4Event = procedure (Sender: TObject) of object;
  TTina4AddRecordEvent = procedure (Sender: TObject; var MemTable: TFDMemTable) of object;


  function GetGUID : String;
  function IsDate(const AValue: Variant): Boolean;
  function CamelCase(FieldName: String): String;
  function SnakeCase(FieldName: String): String;
  function DecodeBase64(const Base64String: String): String;
  {$IFNDEF LINUX}
  function BitmapToBase64EncodedString(Bitmap: FMX.Graphics.TBitmap; Resize: Boolean = True; Width: Integer = 256; Height: Integer = 256): String;
  {$ENDIF}
  function FileToBase64(const FilePath: string): string;
  {$IFDEF SKIA}
  function BitmapToSkiaWepPEncodedString(Bitmap: FMX.Graphics.TBitmap; Quality: Integer=80) : String;
  {$ENDIF}
  function GetJSONFromDB(Connection: TFDConnection; SQL: String;
     Params: TFDParams = nil; DataSetName: String = 'records'): TJSONObject;
  function GetJSONFromTable(var Table: TFDMemTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
  function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
  function SendHttpRequest(var StatusCode: Integer; BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
    ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi'; RequestType: TTina4RequestType = Get;
    ReadTimeOut: Integer = 10000; ConnectTimeOut: Integer = 5000; RequestContentType: String = ''): TBytes;
  function SendMultipartFormData(var StatusCode: Integer;  const BaseURL, EndPoint: string;  const FormFields: array of string; const Files: array of string;  QueryParams: string = '';  Username: string = '';  Password: string = '';
      CustomHeaders: TURLHeaders = nil; UserAgent: string = 'Tina4Delphi';  ReadTimeout: Integer = 30000; ConnectTimeout: Integer = 10000 ): TBytes;
  function StrToJSONObject(JSON:String): TJSONObject;
  function StrToJSONValue(JSON:String): TJSONValue;
  function BytesToJSONObject(JSON:TBytes): TJSONObject;
  function StrToJSONArray(JSON:String): TJSONArray;
  function GetJSONFieldName(FieldName: String) : String;
  function GetJSONDate(const ADate: TDateTime) : String;
  function JSONDateToDateTime(const ADateString: String) : TDateTime;
  procedure GetFieldDefsFromJSONObject(JSONObject: TJSONObject; var MemTable: TFDMemTable; TransformToSnakeCase: Boolean);
  procedure PopulateMemTableFromJSON(var MemTable: TFDMemTable; DataKey: String; JSON: String; IndexedFieldNames: String = ''; SyncMode: TTina4RestSyncMode = Clear; Component: TComponent = nil; TransformFieldNamesToSnakeCase: Boolean = False);
  function PopulateTableFromJSON(Connection: TFDConnection; TableName:String; JSON:String; DataKey: String = 'response'; PrimaryKey:String = 'id') : TJSONObject;
  {$IFDEF MSWINDOWS}
  function ExecuteShellCommand(const ACmdLine: string; var AOutput: string): Integer;
  {$ELSE}
  function ExecuteShellCommand(ACommand : string; var AOutput: string) : Integer;
  {$ENDIF}

implementation

uses Tina4RESTRequest;

function JsonEscapeStr(const S: String): String;
var
  JsonStr: TJSONString;
begin
  JsonStr := TJSONString.Create(S);
  try
    // TJSONString.ToString returns the value with quotes and proper escaping
    Result := JsonStr.Value;
  finally
    JsonStr.Free;
  end;
end;

function IsDate(const AValue: Variant): Boolean;
const
  ISO8601Format = 'yyyy-mm-dd"T"hh:nn:ss'; // Base ISO8601 without milliseconds
  ISO8601FormatMs = 'yyyy-mm-dd"T"hh:nn:ss.zzz'; // ISO8601 with milliseconds
  NormalFormat = 'yyyy-mm-dd hh:nn:ss'; // YYYY-MM-DD HH:MM:SS
  ShortDateFormat = 'yyyy-mm-dd'; // YYYY-MM-DD
  USDateFormat = 'mm/dd/yyyy'; // MM/DD/YYYY
var
  DateValue: TDateTime;
  InputStr: string;
  ExistingFormat : TFormatSettings;

begin
  ExistingFormat := FormatSettings;

  Result := False;
  try
    try
      // Handle non-string values (e.g., TDateTime)
      if VarIsType(AValue, varDate) then
      begin
        Result := True;
        Exit;
      end;

      if (VarIsType(AValue, varInteger) or VarIsType(AValue, varSingle) or VarIsType(AValue, varDouble) or VarIsType(AValue, varCurrency)) then
      begin
        Exit;
      end;

      // Convert input to string for parsing
      InputStr := VarToStr(AValue);

      // Check if empty or null
      if (InputStr = '') or (Length(InputStr) < 6)  then
      begin
        Exit;
      end;

      // Try parsing as ISO8601 (with or without milliseconds)
      if TryISO8601ToDate(InputStr, DateValue) then
      begin
        Result := True;
        Exit;
      end;

      // Try parsing as YYYY-MM-DD HH:MM:SS
      FormatSettings.LongDateFormat := 'YYYY-MM-DD hh:nn:ss';
      if TryStrToDateTime(InputStr, DateValue) then
      begin
        Result := True;
        Exit;
      end;

      // Try parsing as YYYY-MM-DD
      FormatSettings.ShortDateFormat := 'YYYY-MM-DD';
      if TryStrToDate(InputStr, DateValue) then
      begin
        Result := True;
        Exit;
      end;

      // Try parsing as MM/DD/YYYY
      FormatSettings.ShortDateFormat := 'MM/DD/YYYY';
      if TryStrToDate(InputStr, DateValue) then
      begin
        Result := True;
        Exit;
      end;
    except
      Result := False;
    end;
  finally
    FormatSettings := ExistingFormat;
  end;
end;





/// <summary> Gets a GUID
/// </summary>
/// <remarks>
/// This seems to be an arduos task so this function was written to make it simpler
/// </remarks>
/// <returns>
/// A well formatted GUID
/// </returns>
function GetGUID : String;
var
  UID : TGuid;
  UIDStringList : TStringList;
begin
   UIDStringList := TStringList.Create();
   try
     CreateGuid(UID);
     ExtractStrings(['{','}'], [' '], PChar(GuidToString(UID)), UIDStringList);
     Result := UIDStringList.Strings[0];
   finally
     UIDStringList.Free;
   end;
end;

/// <summary> Converts a database underscored field to a camel case field for returing in JSON
/// </summary>
/// <param name="FieldName">The field name to camel case
/// </param>
/// <remarks>
/// If there are no underscores or an exception happens the orginal field name is returned
/// </remarks>
/// <returns>
/// Camel cased field name
/// </returns>
function CamelCase(FieldName: String): String;
var
  NewName: String;
  I : Integer;
begin
  I := 1;
  try
    if (Pos('_', FieldName) <> 0) then
    begin
      FieldName := LowerCase(FieldName);
      while I <= Length(FieldName) do
      begin
        if (FieldName[I] = '_') then
        begin
          I := I + 1;
          NewName := NewName + UpperCase(FieldName[I]);
        end
          else
        begin
          NewName := NewName + FieldName[I];
        end;
        I := I + 1;
      end;
      Result := NewName;
    end
      else
    begin
      Result := LowerCase(FieldName);
    end;
  except
    Result := FieldName;
  end;
end;


/// <summary> Converts a JSON camel cased field to a snake case for updating a database
/// </summary>
/// <param name="FieldName">The field name to snake case
/// </param>
/// <remarks>
/// If there are underscores or an exception happens the orginal field name is returned
/// </remarks>
/// <returns>
/// Snake cased field name
/// </returns>
function SnakeCase(FieldName: String): String;
var
  NewName: String;
  I : Integer;
begin
  I := 1;
  try
    if (Pos('_', FieldName) = 0) then
    begin
      while I <= Length(FieldName) do
      begin
        if (FieldName[I] = UpperCase(FieldName[I])) and (I > 1) then
        begin
          NewName := NewName +'_'+ LowerCase(FieldName[I]);
        end
          else
        begin
          NewName := NewName + LowerCase(FieldName[I]);
        end;
        I := I + 1;
      end;
      Result := NewName;
    end
      else
    begin
      Result := FieldName;
    end;
  except
    Result := FieldName;
  end;
end;


/// <summary> Decodes a Base64 encoded String
/// </summary>
/// <param name="Base64String">A Base64 Encoded String
/// </param>
/// <remarks>
/// A Normal String is returned
/// </remarks>
/// <returns>
/// Normal String
/// </returns>
function DecodeBase64(const Base64String: String): String;
var
  DecodedBytes: TBytes;
begin
  // Decode the Base64 string into bytes
  DecodedBytes := TNetEncoding.Base64.DecodeStringToBytes(Base64String);

  // Convert bytes to UTF-8 string
  Result := TEncoding.UTF8.GetString(DecodedBytes);
end;

{$IFNDEF LINUX}
/// <summary> Encodes a bitmap to a base 64 encoded string
/// </summary>
/// <param name="Bitmap">A FMX.Graphics.TBitmap from which the encoding is done
/// </param>
/// <remarks>
/// A Base64 encoded string is returned representing the image
/// </remarks>
/// <returns>
/// Encodes a bitmap to a base 64 encoded string
/// </returns>
function BitmapToBase64EncodedString(Bitmap: FMX.Graphics.TBitmap; Resize: Boolean = True; Width: Integer = 256; Height: Integer = 256): String;
var
  ByteStream: TBytesStream;
  Base64EncodedStream: TStringStream;
begin
  ByteStream := TBytesStream.Create();
  if Resize then
  begin
    Bitmap.Resize(Width, Height);
  end;
  Bitmap.SaveToStream(ByteStream);
  Base64EncodedStream := TStringStream.Create();
  try
    ByteStream.Position := 0;
    TNetEncoding.Base64.Encode(ByteStream, Base64EncodedStream);
    Result := Base64EncodedStream.DataString;
  finally
    Base64EncodedStream.Free;
    ByteStream.Free;
  end;
end;
{$ENDIF}


/// <summary>
/// Converts the contents of a file to a Base64-encoded string.
/// </summary>
/// <param name="FilePath">
/// Full path to the file that should be encoded (local file system).
/// The file must exist and be readable by the current process.
/// </param>
/// <returns>
/// A string containing the complete Base64-encoded representation of the file's binary content.
/// The output uses standard Base64 alphabet (A-Z, a-z, 0-9, +, /) with padding (=) as needed.
/// No line breaks are inserted (single continuous string).
/// </returns>
/// <remarks>
/// <para>
/// This function reads the entire file into memory to perform the encoding.
/// It is suitable for small to medium-sized files (typically < 50�100 MB depending on available RAM).
/// For very large files (>200 MB), consider a streaming approach that writes chunks incrementally.
/// </para>
/// <para>
/// Uses <c>System.NetEncoding.TNetEncoding.Base64.Encode</c> which is cross-platform
/// (works in both VCL and FireMonkey applications on Windows, macOS, iOS, Android).
/// </para>
/// <para>
/// Exceptions:
/// - <c>EFileNotFoundException</c> � if the file does not exist
/// - <c>EStreamError</c> or other I/O exceptions � if the file cannot be opened or read
/// </para>
/// </remarks>
/// <exception cref="EFileNotFoundException">
/// Raised when the specified file does not exist.
/// </exception>
/// <example>
/// <code>
/// var
///   Base64Data: string;
/// begin
///   try
///     Base64Data := FileToBase64('C:\Users\Andre\Documents\profile.jpg');
///     Memo1.Lines.Add('Base64 length: ' + Length(Base64Data).ToString);
///     // Optional: save to text file
///     TFile.WriteAllText('profile.base64.txt', Base64Data);
///   except
///     on E: Exception do
///       ShowMessage('Error encoding file: ' + E.Message);
///   end;
/// end;
/// </code>
/// </example>
/// <seealso cref="System.NetEncoding.TNetEncoding.Base64"/>
/// <seealso cref="TFileStream"/>
function FileToBase64(const FilePath: string): string;
var
  FileStream: TFileStream;
  Base64EncodedStream: TStringStream;
begin
  if not FileExists(FilePath) then
    raise EFileNotFoundException.CreateFmt('File not found: %s', [FilePath]);

  FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyWrite);
  Base64EncodedStream := TStringStream.Create();
  try
    TNetEncoding.Base64.Encode(FileStream, Base64EncodedStream);
    Result := Base64EncodedStream.DataString;
  finally
    Base64EncodedStream.Free;
    FileStream.Free;
  end;
end;


{$IFDEF SKIA}
function BitmapToSkiaWepPEncodedString(Bitmap: FMX.Graphics.TBitmap; Quality: Integer=80) : String;
var
  LStream: TMemorystream;
  ByteStream: TBytesStream;
  SkImage: ISkImage;
  Base64EncodedStream: TStringStream;

begin
  ByteStream := TBytesStream.Create();
  LStream := TMemorystream.Create;
  try
    Bitmap.SaveToStream(LStream);
    LStream.Position := 0;
    SkImage := TSkImage.MakeFromEncodedStream(LStream);
    SkImage.EncodeToStream(ByteStream, tskEncodedImageFormat.WebP, Quality);
    Base64EncodedStream := TStringStream.Create();
    try
      ByteStream.Position := 0;
      TNetEncoding.Base64.Encode(ByteStream, Base64EncodedStream);
      Result := Base64EncodedStream.DataString;
    finally
      Base64EncodedStream.Free;
    end;
  finally
    LStream.Free;
    ByteStream.Free;
  end;
end;
{$ENDIF}

/// <summary> Returns a JSON Object response based on an SQL text
/// </summary>
/// <param name="Connection">A TFDConnection from which to query
/// </param>
/// <param name="SQL">A valid SQL which queries the database, it can include parameters starting with :
/// </param>
/// <param name="DataSetName">A name to give the returned result, example: cats, the default is records
/// </param>
/// <param name="Params">Params to pass to the query on execution
/// </param>
/// <remarks>
/// A JSON object is returned with an array of records, if an exception happens , error is returned with the correct error
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromDB(Connection: TFDConnection; SQL: String; Params: TFDParams = nil; DataSetName: String = 'records'): TJSONObject;
var
  Query: TFDQuery;
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;
  TableFieldNames: Array of String;
  ByteStream: TBytesStream;
  Base64EncodedStream: TStringStream;


//Checks to see if a string is base64 encode so we don't double encode blobs or strings that are already encoded
function IsBase64Encoded(const S: string): Boolean;
var
  DecodedBytes: TBytes;
  ReEncoded: string;
  CleanInput: string;
begin
  Result := False;

  // Check length (must be multiple of 4)
  if (Length(S) mod 4) <> 0 then
    Exit;

  // Check character set
  if not TRegEx.IsMatch(S, '^[A-Za-z0-9+/]*={0,2}$') then
    Exit;

  try
    DecodedBytes := TNetEncoding.Base64.DecodeStringToBytes(S);
    ReEncoded := TNetEncoding.Base64.EncodeBytesToString(DecodedBytes);

    // Some base64 libraries ignore or vary padding, so compare trimmed versions
    CleanInput := S.TrimRight(['=']);
    Result := CleanInput = ReEncoded.TrimRight(['=']);
  except
    on E: Exception do
      Result := False;
  end;
end;

begin
  Result := TJSONObject.Create;
  DataArray := TJSONArray.Create;
  Query := TFDQuery.Create(nil);
  try
    try
      Query.Connection := Connection;
      if (Assigned(Params)) then
      begin
        Query.Params := Params;
      end;
      Query.SQL.Text := SQL;
      Query.Open();

      while not Query.Eof do
      begin
        DataRecord := TJSONObject.Create;

        for I := 0 to Query.FieldDefs.Count - 1 do
        begin
          if (Length(FieldNames) <> Query.FieldDefs.Count) then
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(Query.FieldDefs[I].Name);

            SetLength(TableFieldNames, Length(TableFieldNames) + 1);
            TableFieldNames[I] := Query.FieldDefs[I].Name;
          end;

          if Query.FieldDefs[I].DataType = ftBlob then
          begin
            if not IsBase64Encoded(Query.FieldByName(TableFieldNames[I]).AsString) then
            begin
              ByteStream := TBytesStream.Create(Query.FieldByName(TableFieldNames[I]).AsBytes);
              Base64EncodedStream := TStringStream.Create();
              try
                TNetEncoding.Base64.Encode(ByteStream, Base64EncodedStream);

                 DataRecord.AddPair(FieldNames[I], Base64EncodedStream.DataString);
              finally
                Base64EncodedStream.Free;
                ByteStream.Free;
              end;
            end
              else
            begin
              DataRecord.AddPair(FieldNames[I], Query.FieldByName(TableFieldNames[I]).AsString);
            end;
          end
            else
          if ((Query.FieldDefs[I].DataType = TFieldType.ftDateTime) or (Query.FieldDefs[I].DataType = TFieldType.ftTimeStamp)) then
          begin
            DataRecord.AddPair(FieldNames[I], GetJSONDate(Query.FieldByName(TableFieldNames[I]).AsDateTime));
          end
            else
          begin
            DataRecord.AddPair(FieldNames[I],
              Query.FieldByName(TableFieldNames[I]).AsString);
          end;
        end;

        DataArray.Add(DataRecord);

        Query.Next;
      end;

      Result.AddPair(DataSetName, DataArray);

    finally
      Query.Free;
    end;
  except
    on E: Exception do
    begin
      Result.AddPair('error', E.UnitName + ' ' + E.Message);
    end;
  end;
end;

/// <summary> Internal helper that converts any TDataSet to a JSON object with camelCase keys.
/// Shared by all GetJSONFromTable overloads to avoid code duplication.
/// </summary>
function DataSetToJSON(DataSet: TDataSet; DataSetName: String; IgnoreFields: String; IgnoreBlanks: Boolean): TJSONObject;
var
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;
  TableFieldNames: Array of String;
  IgnoreFieldList: TStringList;
  CanAddPair: Boolean;
  ByteStream: TBytesStream;
  Base64EncodedStream: TStringStream;

begin
  Result := TJSONObject.Create;
  DataArray := TJSONArray.Create;
  IgnoreFieldList := TStringList.Create;
  try
    IgnoreFieldList.CommaText := IgnoreFields;

    IgnoreFields := '';
    for I := 0 to IgnoreFieldList.Count-1 do
    begin
      IgnoreFields := IgnoreFields + '"'+IgnoreFieldList.Strings[I]+'"';
    end;

    try
      if not DataSet.Active then
      begin
        DataSet.Open;
      end;

      DataSet.First;

      while not DataSet.Eof do
      begin
        DataRecord := TJSONObject.Create;

        for I := 0 to DataSet.FieldDefs.Count - 1 do
        begin
          // gets the field names in camel case on first iteration to save processing

          if (Length(FieldNames) <> DataSet.FieldDefs.Count) then
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(DataSet.FieldDefs[I].Name);

            SetLength(TableFieldNames, Length(TableFieldNames) + 1);
            TableFieldNames[I] := DataSet.FieldDefs[I].Name;
          end;

          if (Pos('"'+FieldNames[I]+'"', IgnoreFields) = 0) then
          begin
            CanAddPair := True;
            if IgnoreBlanks and (DataSet.FieldByName(TableFieldNames[I]).AsString = '') then
            begin
              CanAddPair := False;
            end;

            if CanAddPair then
            begin
              if DataSet.FieldDefs[I].DataType = TFieldType.ftBlob then
              begin
                //Base 64 encode
                ByteStream := TBytesStream.Create(DataSet.FieldByName(TableFieldNames[I]).AsBytes);
                Base64EncodedStream := TStringStream.Create();
                try
                  TNetEncoding.Base64.Encode(ByteStream, Base64EncodedStream);

                   DataRecord.AddPair(FieldNames[I], Base64EncodedStream.DataString);
                finally
                  Base64EncodedStream.Free;
                  ByteStream.Free;
                end;
              end
                else
              if (DataSet.FieldDefs[I].DataType = TFieldType.ftDateTime) or (DataSet.FieldDefs[I].DataType = TFieldType.ftTimeStamp) then
              begin
                DataRecord.AddPair(FieldNames[I], GetJSONDate(DataSet.FieldByName(TableFieldNames[I]).AsDateTime));
              end
                else
              begin
                DataRecord.AddPair(FieldNames[I], DataSet.FieldByName(TableFieldNames[I]).AsString);
              end;
            end;
          end;
        end;

        DataArray.Add(DataRecord);
        DataSet.Next;
      end;

      Result.AddPair(DataSetName, DataArray);

    finally
      IgnoreFieldList.Free;
    end;
  except
    on E: Exception do
    begin
      Result.AddPair('error', E.UnitName + ' ' + E.Message);
    end;
  end;
end;

/// <summary> Returns a JSON Object response based on the data in a TFDMemTable
/// </summary>
/// <param name="Table">A TFDMemTable from which to get the data
/// </param>
/// <param name="DataSetName">A name to give the returned result, example: cats, the default is records
/// </param>
/// <param name="IgnoreFields">Comma separated list of fields to ignore on getting the data
/// </param>
/// <param name="IgnoreBlanks">Ignore blank data fields when building the response JSON
/// </param>
/// <remarks>
/// A JSON object is returned with an array of records. Field names are camelCased.
/// If an exception happens, error is returned with the correct error.
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromTable(var Table: TFDMemTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
begin
  Result := DataSetToJSON(Table, DataSetName, IgnoreFields, IgnoreBlanks);
end;

/// <summary> Returns a JSON Object response based on the data in a TFDTable
/// </summary>
/// <param name="Table">A TFDTable from which to get the data
/// </param>
/// <param name="DataSetName">A name to give the returned result, example: cats, the default is records
/// </param>
/// <param name="IgnoreFields">Comma separated list of fields to ignore on getting the data
/// </param>
/// <param name="IgnoreBlanks">Ignore blank data fields when building the response JSON
/// </param>
/// <remarks>
/// A JSON object is returned with an array of records. Field names are camelCased.
/// If an exception happens, error is returned with the correct error.
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
begin
  Result := DataSetToJSON(Table, DataSetName, IgnoreFields, IgnoreBlanks);
end;


/// <summary> Returns a response from an REST end point
/// </summary>
/// <param name="BaseURL">The base url of the REST service
/// </param>
/// <param name="EndPoint">A valid REST end point
/// </param>
/// <param name="QueryParams">Any query params in the form <key>=<value>, these normally suffix a URL inform ?key=value
/// </param>
/// <param name="Body">A text body to send to the REST end point, normally JSON
/// </param>
/// <param name="ContentType">The content type that is send and expected from the REST request
/// </param>
/// <param name="ContentEncoding">The content encoding of the request that is sent
/// </param>
/// <param name="Username">Username for Basic auth headers
/// </param>
/// <param name="Password">Password for Basic auth headers
/// </param>
/// <param name="CustomHeaders">A TStringList of headers in the form header: value
/// </param>
/// <param name="UserAgent">A name for the user agent doing the requests
/// </param>
/// <param name="RequestType">Request Type - Get, Post, Patch, Put, Delete
/// </param>
/// <param name="ReadTimeOut">Read Time Out in milliseconds
/// </param>
/// <param name="ReadTimeOut">Connect Time Out in milliseconds
/// </param>
/// <remarks>
/// A simple function to return back a response from a REST end point
/// </remarks>
/// <returns>
/// A string containing the results from the REST endpoint
/// </returns>
function SendHttpRequest(var StatusCode: Integer; BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi';
  RequestType: TTina4RequestType = Get; ReadTimeOut: Integer = 10000; ConnectTimeOut: Integer = 5000; RequestContentType: String = ''): TBytes;
var
  HttpClient: TNetHTTPClient;
  HTTPRequest: TNetHTTPRequest;
  HTTPResponse: IHTTPResponse;
  BodyList: TStringStream;
  BytesStream : TBytesStream;
  Url: String;
  Header: TNetHeader;

begin
  try
    if (EndPoint = '') and (BaseUrl = '') then
    begin
      Result := TEncoding.UTF8.GetBytes('{"error": "No URL"}');
      exit;
    end;

    if (EndPoint <> '') and (BaseUrl <> '') then
    begin
      Url := BaseURL + '/' + EndPoint;
    end
      else
    begin
      if (BaseUrl = '') and (EndPoint <> '') then
      begin
        Url := EndPoint;
      end
        else
      begin
        Url := BaseURL;
      end;
    end;

    if QueryParams <> '' then
    begin
      Url := Url + '?' + QueryParams;
    end;

    HttpClient := TNetHTTPClient.Create(nil);
    BodyList := TStringStream.Create(Body);
    HTTPRequest := TNetHTTPRequest.Create(nil);

    try
      HttpClient.ConnectionTimeout := ConnectTimeOut;
      HttpClient.ResponseTimeout := ReadTimeOut;

      HttpClient.HandleRedirects := True;

      HttpClient.UserAgent := UserAgent;

      if (Username <> '') then
      begin
        HttpClient.CredentialsStorage.AddCredential(
          TCredentialsStorage.TCredential.Create(
            TAuthTargetType.Server, '', Url, username, password
        ));
        HttpClient.PreemptiveAuthentication := True;
      end;

      if Assigned(CustomHeaders) then
      begin
        for Header in CustomHeaders do
        begin
          HttpClient.CustHeaders.Add(Header);
        end;
      end;


      HTTPRequest.Client := HttpClient;
      if RequestContentType = '' then
      begin
        RequestContentType := ContentType;
      end;
      HTTPRequest.Client.ContentType := RequestContentType;
      HTTPRequest.Client.Accept := ContentType;
      HTTPRequest.Client.AcceptEncoding := ContentEncoding;
      HTTPRequest.Client.AutomaticDecompression  := [THTTPCompressionMethod.Any];

      BytesStream := TBytesStream.Create;
      try
        try
          if RequestType = Post then
          begin
            HTTPResponse := HTTPRequest.Post(Url, BodyList, BytesStream);
          end
            else
          if RequestType = Patch then
          begin
            HTTPResponse := HTTPRequest.Patch(Url, BodyList, BytesStream);
          end
            else
          if RequestType = Put then
          begin
            HTTPResponse := HTTPRequest.Put(Url, BodyList, BytesStream);
          end
           else
          if RequestType = Get then
          begin
            HTTPResponse := HTTPRequest.Get(Url, BytesStream);
          end
            else
          if RequestType = Delete then
          begin
            HTTPResponse := HTTPRequest.Delete(Url, BytesStream);
          end;

          StatusCode := HTTPResponse.StatusCode;

          SetLength(Result, BytesStream.Size);
          if BytesStream.Size > 0 then
            Move(BytesStream.Bytes[0], Result[0], BytesStream.Size);

        except
          on E:Exception do
          begin
            Result := TEncoding.UTF8.GetBytes('{"error": "'+JsonEscapeStr(E.Message)+'"}');
          end;
        end;
      finally
        BytesStream.Free;
      end;

    finally
      HTTPRequest.Free;
      HTTPClient.Free;
      BodyList.Free;
    end;
  except
    on E: Exception do
    begin
      Result := TEncoding.UTF8.GetBytes('{"error": "'+JsonEscapeStr(E.Message)+'"}');
    end;
  end;
end;

/// <summary>
/// Sends a multipart/form-data HTTP POST request to a REST endpoint, suitable for file uploads
/// combined with regular form fields.
/// </summary>
/// <param name="StatusCode">
/// Output parameter that receives the HTTP status code returned by the server
/// (e.g. 200 for success, 400/401/500 for errors).
/// </param>
/// <param name="BaseURL">
/// The base URL of the REST service (e.g. https://api.example.com/v1).
/// Must not end with a slash unless the endpoint expects it.
/// </param>
/// <param name="EndPoint">
/// The specific endpoint path to append to BaseURL (e.g. upload or files/create).
/// Can be empty if the full path is already in BaseURL.
/// </param>
/// <param name="FormFields">
/// Open array of strings containing name-value pairs for regular form fields.
/// Even indices (0, 2, 4, ...) = field names<br/>
/// Odd indices (1, 3, 5, ...) = field values<br/>
/// Example: ['userId', '123', 'description', 'My document']
/// Must contain an even number of elements.
/// </param>
/// <param name="Files">
/// Open array of strings containing file field names and their corresponding file paths.
/// Even indices = form field name for the file (e.g. 'photo', 'document')<br/>
/// Odd indices = full local file path (e.g. 'C:\temp\image.jpg')<br/>
/// Example: ['photo', 'C:\temp\photo.jpg', 'attachment', 'D:\files\report.pdf']
/// Must contain an even number of elements.
/// </param>
/// <param name="QueryParams">
/// Optional query string to append to the URL (without the leading ?).
/// Format: key1=value1&key2=value2
/// </param>
/// <param name="Username">
/// Optional username for HTTP Basic Authentication.
/// </param>
/// <param name="Password">
/// Optional password for HTTP Basic Authentication (used together with Username).
/// </param>
/// <param name="CustomHeaders">
/// Optional list of additional HTTP headers in the form "Header-Name: value".
/// Can be nil.
/// </param>
/// <param name="UserAgent">
/// The User-Agent string to send in the request header.
/// Default: 'Tina4Delphi'
/// </param>
/// <param name="ReadTimeout">
/// Read/response timeout in milliseconds.
/// Default: 30000 (30 seconds)
/// </param>
/// <param name="ConnectTimeout">
/// Connection timeout in milliseconds.
/// Default: 10000 (10 seconds)
/// </param>
/// <returns>
/// The raw response body as a byte array (TBytes).<br/>
/// On success: usually the JSON/text/binary content returned by the server.<br/>
/// On error: UTF-8 encoded JSON string in the form {"error": "message"}
/// </returns>
/// <remarks>
/// <para>
/// This function performs an HTTP POST with multipart/form-data content type.
/// It automatically handles boundary generation, field encoding, and file attachment.
/// </para>
/// <para>
/// The function uses TMultipartFormData internally (System.Net.Mime) and is cross-platform
/// (works in both VCL and FMX applications).
/// </para>
/// <para>
/// If an exception occurs during the request (network error, invalid URL, file not found, etc.),
/// the returned TBytes contains a simple JSON error message.
/// </para>
/// <para>
/// Authentication is handled via preemptive Basic Auth when Username is provided.
/// Bearer tokens or other auth methods should be added via CustomHeaders.
/// </para>
/// </remarks>
/// <example>
/// <code>
/// var
///   Status: Integer;
///   Response: TBytes;
/// begin
///   Response := SendMultipartFormData(
///     Status,
///     'https://api.example.com',
///     'upload/profile',
///     ['userId', '1001', 'caption', 'New avatar'],
///     ['avatar', 'C:\Users\Andre\Pictures\avatar.jpg'],
///     'api_key=xyz123',
///     'myuser',
///     'secretpass'
///   );
///
///   if Status = 200 then
///     Memo1.Lines.Text := TEncoding.UTF8.GetString(Response)
///   else
///     ShowMessage('Upload failed: ' + Status.ToString);
/// end;
/// </code>
/// </example>
function SendMultipartFormData(
  var StatusCode: Integer;
  const BaseURL, EndPoint: string;
  const FormFields: array of string;           // even indices = names, odd = values
  const Files: array of string;                // even = field name, odd = full file path
  QueryParams: string = '';
  Username: string = '';
  Password: string = '';
  CustomHeaders: TURLHeaders = nil;
  UserAgent: string = 'Tina4Delphi';
  ReadTimeout: Integer = 30000;
  ConnectTimeout: Integer = 10000
): TBytes;
var
  HttpClient: TNetHTTPClient;
  Request: TNetHTTPRequest;
  Response: IHTTPResponse;
  FormData: TMultipartFormData;
  Url: string;
  Header: TNetHeader;
  ResponseStream: TBytesStream;
begin
  Result := nil;
  StatusCode := 0;

  FormData := TMultipartFormData.Create;
  try
    // Add regular form fields (name-value pairs)
    var i := Low(FormFields);
    while i <= High(FormFields) - 1 do
    begin
      FormData.AddField(FormFields[i], FormFields[i + 1]);
      Inc(i, 2);
    end;

    // Add files (same pattern)
    i := Low(Files);
    while i <= High(Files) - 1 do
    begin
      FormData.AddFile(Files[i], Files[i + 1]);  // field name, file path
      Inc(i, 2);
    end;

    // Build URL
    Url := BaseURL;
    if (EndPoint <> '') then
      Url := Url + '/' + EndPoint.Trim(['/']);
    if QueryParams <> '' then
      Url := Url + '?' + QueryParams;

    HttpClient := TNetHTTPClient.Create(nil);
    try
      //HttpClient.ContentType := 'multipart/form-data';
      HttpClient.ConnectionTimeout := ConnectTimeout;
      HttpClient.ResponseTimeout   := ReadTimeout;
      HttpClient.HandleRedirects   := True;
      HttpClient.UserAgent         := UserAgent;

      if Username <> '' then
      begin
        HttpClient.CredentialsStorage.AddCredential(
          TCredentialsStorage.TCredential.Create(
            TAuthTargetType.Server, '', Url, Username, Password));
        HttpClient.PreemptiveAuthentication := True;
      end;

      if Assigned(CustomHeaders) then
      begin
        for Header in CustomHeaders do
        begin
          HttpClient.CustHeaders.Add(Header);
        end;
      end;

      Request := TNetHTTPRequest.Create(nil);
      try
        Request.Client := HttpClient;

        ResponseStream := TBytesStream.Create;
        try
          Response := Request.Post(Url, FormData, ResponseStream);
          StatusCode := Response.StatusCode;

          ResponseStream.Position := 0;
          SetLength(Result, ResponseStream.Size);
          if Result <> nil then
            Move(ResponseStream.Bytes[0], Result[0], ResponseStream.Size);

        except
          on E: Exception do
            Result := TEncoding.UTF8.GetBytes('{"error": "' + JsonEscapeStr(E.Message) + '"}');
        end;
      finally
        Request.Free;
      end;
    finally
      HttpClient.Free;
    end;
  finally
    FormData.Free;
  end;
end;


/// <summary> Converts a String into a TJSONObject
/// </summary>
/// <param name="JSON">A JSON string
/// </param>
/// <remarks>
/// Converts a string into a JSON object
/// </remarks>
/// <returns>
/// A TJSONObject or nil if the string is invalid
/// </returns>
function StrToJSONObject(JSON:String): TJSONObject;
begin
  try
    Result := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  except
    Result := nil;
  end;
end;

/// <summary> Converts a String into a TJSONValue
/// </summary>
/// <param name="JSON">A JSON string
/// </param>
/// <remarks>
/// Converts a string into a JSON value (object, array, string, number, boolean, or null).
/// Use this instead of StrToJSONObject when the input may not be a JSON object.
/// </remarks>
/// <returns>
/// A TJSONValue or nil if the string is invalid
/// </returns>
function StrToJSONValue(JSON:String): TJSONValue;
begin
  try
    Result := TJSONObject.ParseJSONValue(JSON);
  except
    Result := nil;
  end;
end;


/// <summary> Converts TBytes into a TJSONObject
/// </summary>
/// <param name="JSON">A JSON string
/// </param>
/// <remarks>
/// Converts a string into a JSON object
/// </remarks>
/// <returns>
/// A TJSONObject or nil if the string is invalid
/// </returns>
function BytesToJSONObject(JSON:TBytes): TJSONObject;
begin
  try
    Result := TJSONObject.ParseJSONValue(JSON,0, Length(JSON), []) as TJSONObject;
  except
    Result := nil;
  end;
end;

/// <summary> Converts a String into a TJSONArray
/// </summary>
/// <param name="JSON">A JSON string
/// </param>
/// <remarks>
/// Converts a string into a JSON array
/// </remarks>
/// <returns>
/// A TJSONArray or nil if the string is invalid
/// </returns>
function StrToJSONArray(JSON:String): TJSONArray;
begin
  try
    Result := TJSONObject.ParseJSONValue(JSON) as TJSONArray;
  except
    Result := nil;
  end;
end;


/// <summary> Gets the field name from a JSON string field.
/// Prefer using TJSONPair.JsonString.Value instead which does the same thing natively.
/// </summary>
/// <param name="FieldName">Field name in form "name"
/// </param>
/// <remarks>
/// The fields from a JSON object normally are enclosed in quotes and this removes them.
/// This function is kept for backwards compatibility.
/// </remarks>
/// <returns>
/// Field name as a string or the original if the length is less than 2 or empty
/// </returns>
function GetJSONFieldName(FieldName: String) : String;
begin
  if (FieldName <> '') and (Length(FieldName) > 2) then //""
  begin
    Result := Copy(FieldName, 2, Length(FieldName)-2);
  end
    else
  begin
    Result := FieldName;
  end;
end;


/// <summary> Gets an ISO date for passing to JSON request
/// </summary>
/// <param name="ADate">A TDateTime
/// </param>
/// <remarks>
/// Returns back an ISO formatted date in form  YYYY-MM-DDT00:00:00.000Z
/// </remarks>
/// <returns>
/// Returns a string in ISO date format YYYY-MM-DDT00:00:00.000Z
/// </returns>
function GetJSONDate(const ADate: TDateTime) : String;
begin
  Result := DateToISO8601(ADate, False);
end;


/// <summary> Converts an ISO  date string from JSON to TDateTime
/// </summary>
/// <param name="ADateString">
/// </param>
/// <remarks>
/// Returns back a TDateTime
/// </remarks>
/// <returns>
/// Returns back a TDateTime
/// </returns>
function JSONDateToDateTime(const ADateString: String) : TDateTime;
begin
  Result := ISO8601ToDate(ADateString, False);
end;


/// <summary> Gets Field definitions from a TJSONObject
/// </summary>
/// <param name="JSONObject">A TJSONObject
/// </param>
/// <remarks>
/// Converts a TJSONObject into field definitions
/// </remarks>
/// <returns>
/// A TFieldDefs object or nil if it fails
/// </returns>
procedure GetFieldDefsFromJSONObject(JSONObject: TJSONObject; var MemTable: TFDMemTable; TransformToSnakeCase: Boolean);
begin
  if (MemTable.FieldDefs.Count > 0) then Exit;

  try
    for var Index : Integer := 0 to JSONObject.Count-1 do
    begin
      var FieldName: String := JSONObject.Pairs[Index].JsonString.Value;

      if TransformToSnakeCase then
      begin
        FieldName := SnakeCase(FieldName);
      end;

      try
        if MemTable.FieldDefs.IndexOf(FieldName) = -1 then
        begin
          if (JSONObject.Pairs[Index].JsonValue is TJSONObject) or (JSONObject.Pairs[Index].JsonValue is TJSONArray) then
          begin
            MemTable.FieldDefs.Add(FieldName, TFieldType.ftMemo);
          end
            else
          begin
            MemTable.FieldDefs.Add(FieldName, TFieldType.ftString, 1000);
          end;
        end;
      except
          On Exception do
          begin
            //Fail silently - must be a data issue or duplicate field ?
          end;
        end;
    end;
  except
    MemTable.FieldDefs.Clear;
  end;
end;


/// <summary> Populates a Mem Table from a JSON object using the data from the DataKey
/// </summary>
/// <param name="MemTable">The mem table to be populated
/// </param>
/// <param name="DataKey">The key to be used to populate the Mem Table
/// </param>
/// <param name="JSON">The JSON to be used
/// </param>
/// <param name="IndexedFieldName">The IndexedFieldName to be used
/// </param>
/// <param name="SyncMode">TTina4RestSyncMode , default is to clear the mem table
/// </param>
/// <param name="Component">TComponent  will either be a TTina4JSONAdapter or a TTina4RESTRequest
/// </param>
/// <remarks>
/// Populates a Mem Table from a JSON object using the data from the DataKey
/// </remarks>
procedure PopulateMemTableFromJSON(var MemTable: TFDMemTable; DataKey: String; JSON: String; IndexedFieldNames: String = ''; SyncMode: TTina4RestSyncMode = Clear; Component: TComponent = nil; TransformFieldNamesToSnakeCase: Boolean = False );
var
  Response : TJSONObject;
  Initialized: Boolean;
  OnExecuteDone : TTina4Event;
  OnAddRecord: TTina4AddRecordEvent;


procedure CreateOrUpdateRecord(JSONInfo: TJSONValue);
begin
  if (JSONInfo is TJSONObject) then
  begin
    var JSONRecord := StrToJSONObject(JSONInfo.ToJSON);

    if (not Initialized) then
    begin
      if Assigned(MemTable) and ((MemTable.FieldDefs.Count = 0) or (MemTable.FieldDefs.Count <> JSONRecord.Count)) then
      begin
        if (MemTable.Active) then
        begin
          if SyncMode = Clear then
          begin
            MemTable.Close;
          end;
        end;

        if MemTable.Fields.Count = 0 then
        begin
          GetFieldDefsFromJSONObject(TJSONObject(JSONInfo), TFDMemTable(MemTable), TransformFieldNamesToSnakeCase);
          MemTable.CreateDataSet;
        end;
      end;

      if (not MemTable.Active) then
      begin
        MemTable.Open;
        if SyncMode = Clear then
        begin
          MemTable.EmptyDataSet;
        end;
      end;

      //Only do batching when we don't have to refresh or update records
      if (not Assigned(OnAddRecord)) then
      begin
        MemTable.BeginBatch;
      end;
      Initialized := True;
    end;

    if (IndexedFieldNames = '') and (MemTable.FieldDefs.Count > 0) then
    begin
      IndexedFieldNames := MemTable.FieldDefs[0].Name;
    end;

    var FilterState : Boolean := MemTable.Filtered;
    var Filter : String := MemTable.Filter;

    try
      if SyncMode = Clear then
      begin
        MemTable.Append;
      end
        else
      begin
        var IndexStringList: TStringList;
        IndexStringList := TStringList.Create('"', ',');
        try
          IndexStringList.DelimitedText := IndexedFieldNames;

          MemTable.Filtered := False;
          MemTable.Filter := '';

          for var I := 0 to IndexStringList.Count-1 do
          begin
            if (MemTable.Filter <> '') then
            begin
              MemTable.Filter := MemTable.Filter +' and ';
            end;

            var JSONKeyValue: String := '';
            // Try the field name directly first
            if not JSONRecord.TryGetValue<string>(IndexStringList[I], JSONKeyValue) then
            begin
              // If not found and we're transforming to snake_case, try the camelCase version
              if TransformFieldNamesToSnakeCase then
                JSONRecord.TryGetValue<string>(CamelCase(IndexStringList[I]), JSONKeyValue);
            end;

            MemTable.Filter := MemTable.Filter + IndexStringList[I] +' = '+QuotedStr(JSONKeyValue);
          end;

          MemTable.Filtered := True;

          if (MemTable.RecNo = 0) then   //No record found
          begin
            MemTable.Append;
          end
            else
          begin
            MemTable.Edit;
          end;
        finally
          IndexStringList.Free;
        end;
      end;

      for var Index : Integer := 0 to JSONRecord.Count-1 do
      begin
        var PairValue : String;
        if (JSONRecord.Pairs[Index].JsonValue is TJSONObject) or (JSONRecord.Pairs[Index].JsonValue is TJSONArray) then
        begin
          PairValue := JSONRecord.Pairs[Index].JsonValue.ToString;
        end
          else
        begin
          PairValue := JSONRecord.Pairs[Index].JsonValue.Value;
        end;

        var FieldName : String := JSONRecord.Pairs[Index].JsonString.Value;

        if TransformFieldNamesToSnakeCase then
        begin
          FieldName := SnakeCase(FieldName);
        end;

        var KeyIndex := MemTable.FieldDefs.IndexOf(FieldName);

        if KeyIndex >= 0 then
        begin
          if (MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftDateTime) or IsDate(PairValue) then
          begin
            if (PairValue <> '') then
            begin
              try
                MemTable.FieldByName(FieldName).AsDateTime := JSONDateToDateTime(PairValue);
              except
                MemTable.FieldByName(FieldName).AsString := PairValue;
              end;
            end
              else
            begin
              MemTable.FieldByName(FieldName).AsString := '';
            end;
          end
            else
          if MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftString then
          begin
            MemTable.FieldByName(FieldName).AsString := PairValue;
          end
            else
          if MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftBlob then
          begin
            MemTable.FieldByName(FieldName).AsBytes := TNetEncoding.Base64.DecodeStringToBytes(PairValue);
          end
            else
          begin
            MemTable.FieldByName(FieldName).AsString := PairValue;
          end;
        end;
      end;

      if Assigned(OnAddRecord) and Assigned(Component) then
      begin
        OnAddRecord(Component, MemTable);
      end;

      MemTable.Post;

      MemTable.Filtered := False;
      MemTable.Filter := Filter;
      MemTable.Filtered := FilterState;
    finally
      JSONRecord.Free;
    end;
  end;
end;


begin
  Response := StrToJSONObject(JSON);


  //Get the events if we are the correct component type
  if Component is TTina4RESTRequest then
  begin
    OnExecuteDone := (Component as TTina4RESTRequest).OnExecuteDone;
    OnAddRecord :=  (Component as TTina4RESTRequest).OnAddRecord;
  end
    else
  begin
    OnExecuteDone := nil;
    OnAddRecord := nil;
  end;

  try
    if Assigned(Response) and Assigned(MemTable) then
    begin
      var Found := False;
      for var JSONValue in Response do
      begin
        if (DataKey = '') and (JSONValue.JsonString.Value = 'response') then
        begin
          DataKey := 'response';
        end;

        if (MemTable.Active) and (MemTable.FieldDefs.Count > 0) then
        begin
          if not Found and (SyncMode = Clear) then
          begin
            MemTable.EmptyDataSet;
          end;
        end;

        if (JSONValue.JsonString.Value = DataKey) then
        begin
          if (JSONValue.JsonValue is TJSONArray) then
          begin
            Found := True;

            Initialized := False;
            for var JSONInfo in TJSONArray(JSONValue.JsonValue) do
            begin
              CreateOrUpdateRecord(JSONInfo);
            end;
            //Only do batching when we don't have to refresh or update records
            if Initialized and (not Assigned(OnAddRecord)) then
            begin
              MemTable.EndBatch;
            end;


            if MemTable.Active then
            begin
              MemTable.First;
            end
              else
            begin
              if MemTable.FieldDefs.Count > 0 then
              begin
                MemTable.Open;
              end;
            end;

            if (Assigned(OnExecuteDone)) then
            begin
              OnExecuteDone(Component);
            end;
          end;
        end;
      end;

      //Convert the object that is returned
      if not Found then
      begin
        Initialized := False;

        CreateOrUpdateRecord(Response);

        if (not Assigned(OnAddRecord)) then
        begin
          MemTable.EndBatch;
        end;

        if (Assigned(OnExecuteDone)) then
        begin
          OnExecuteDone(Component);
        end;
      end;
    end;
  finally
    Response.Free;
  end;
end;


/// <summary> Inserts data from a JSON object into a Table using the data from the DataKey
/// </summary>
/// <param name="Connection">The connection used to connect to the database
/// </param>
/// <param name="JSON">The JSON to be used
/// </param>
/// <param name="DataKey">The key to be used to populate table
/// </param>
/// <param name="PrimaryKey">The field which is the primary key
/// </param>
/// <remarks>
/// Inserts data from a JSON object into a Table using the data from the DataKey
/// </remarks>
function PopulateTableFromJSON(Connection: TFDConnection; TableName:String; JSON:String; DataKey: String = 'response'; PrimaryKey:String = 'id') : TJSONObject;
var
  JSONObject: TJSONObject;
  Table: TFDTable;
  Query: TFDQuery;
  PrimaryKeys: TStringList;
  DataArray: TJSONArray;
  ByteStream: TBytesStream;
  Base64EncodedStream: TStringStream;
  FieldNames: Array of String;
  TableFieldNames: Array of String;

begin
  JSONObject := StrToJSONObject(JSON);
  PrimaryKeys := TStringList.Create();
  Result := TJSONObject.Create;

  try
    Table := TFDTable.Create(Nil);
    try
      Table.Connection := Connection;
      Table.TableName := TableName;
      Table.AddIndex('idx'+PrimaryKey, PrimaryKey, '', [TFDSortOption.soPrimary], '', '', True);
      Table.IndexesActive := True;

      Table.Open;
      Table.FieldByName(PrimaryKey).AutoGenerateValue := arAutoInc;

      for var JSONValue in JSONObject do
      begin
        if (JSONValue.JsonString.Value = DataKey) then
        begin
          if (JSONValue.JsonValue is TJSONArray) then
          begin
            for var JSONInfo in TJSONArray(JSONValue.JsonValue) do
            begin
              var JSONRecord := StrToJSONObject(JSONInfo.ToJSON);
              //Check if record exists already otherwise insert it
              var PrimaryKeyValue: String;
              if JSONRecord.TryGetValue<String>(PrimaryKey, PrimaryKeyValue) then
              begin
                Table.Filter := PrimaryKey + ' = '''+PrimaryKeyValue+'''';
                Table.Filtered := True;
                if Table.RecordCount = 1 then
                begin
                  Table.Edit;
                end
                  else
                begin
                  Table.Append;
                  Table.FieldByName(PrimaryKey).AsString := PrimaryKeyValue;
                end;
              end
                else
              begin
                Table.Append;
                Query := TFDQuery.Create(nil);
                try
                  Query.Connection := Connection;
                  Query.Close;
                  Query.SQL.Text := 'select max('+PrimaryKey+') as max_id from '+TableName;
                  Query.Open;

                  //Add ability to increment text
                  var NewId := Query.FieldByName('max_id').AsInteger;

                  Inc(NewId);

                  Table.FieldByName(PrimaryKey).AsInteger := NewId;
                finally
                  Query.Free;
                end;
              end;

              PrimaryKeys.Add(Table.FieldByName(PrimaryKey).AsString);

              for var Index : Integer := 0 to JSONRecord.Count -1 do
              begin
                var PairValue : String;
                var KeyValue : String;

                if (JSONRecord.Pairs[Index].JsonValue is TJSONObject) or (JSONRecord.Pairs[Index].JsonValue is TJSONArray) then
                begin
                  PairValue := JSONRecord.Pairs[Index].JsonValue.ToString;
                  KeyValue := JSONRecord.Pairs[Index].JsonString.ToString;
                end
                  else
                begin
                  KeyValue := JSONRecord.Pairs[Index].JsonString.Value;
                  PairValue := JSONRecord.Pairs[Index].JsonValue.Value;
                end;

                if KeyValue = PrimaryKey then Continue;

                if Table.FieldDefs.Find(SnakeCase(KeyValue)).DataType = TFieldType.ftBlob then
                begin
                  Table.FieldByName(SnakeCase(KeyValue)).AsBytes := TNetEncoding.Base64.DecodeStringToBytes(PairValue);
                end
                  else
                if ((Table.FieldDefs.Find(SnakeCase(KeyValue)).DataType = TFieldType.ftDateTime) or (Table.FieldDefs.Find(SnakeCase(KeyValue)).DataType = TFieldType.ftTimeStamp)) then
                begin
                  Table.FieldByName(SnakeCase(KeyValue)).AsDateTime := JSONDateToDateTime(PairValue);
                end
                  else
                begin
                  Table.FieldByName(SnakeCase(KeyValue)).AsString := PairValue;
                end;
              end;

              Table.Post;
            end;
          end;
        end;
      end;


      Connection.CommitRetaining;

      DataArray := TJSONArray.Create();
      for var J := 0 to PrimaryKeys.Count-1 do
      begin
        Table.Filter := PrimaryKey+' = '''+PrimaryKeys[J]+'''';
        Table.Filtered := True;

        while not Table.Eof do
        begin
          var DataRecord := TJSONObject.Create;

          for var I := 0 to Table.FieldDefs.Count - 1 do
          begin
            // gets the field names in camel case on first iteration to save processing

            if (Length(FieldNames) <> Table.FieldDefs.Count) then
            begin
              SetLength(FieldNames, Length(FieldNames) + 1);
              FieldNames[I] := CamelCase(Table.FieldDefs[I].Name);

              SetLength(TableFieldNames, Length(TableFieldNames) + 1);
              TableFieldNames[I] := Table.FieldDefs[I].Name;
            end;

            if Table.FieldDefs[I].DataType = TFieldType.ftBlob then
            begin
              //Base 64 encode
              ByteStream := TBytesStream.Create(Table.FieldByName(TableFieldNames[I]).AsBytes);
              Base64EncodedStream := TStringStream.Create();
              try
                TNetEncoding.Base64.Encode(ByteStream, Base64EncodedStream);

                 DataRecord.AddPair(FieldNames[I], Base64EncodedStream.DataString);
              finally
                Base64EncodedStream.Free;
                ByteStream.Free;
              end;
            end
              else
            if ((Table.FieldDefs[I].DataType = TFieldType.ftDateTime) or (Table.FieldDefs[I].DataType = TFieldType.ftTimeStamp)) then
            begin
              DataRecord.AddPair(FieldNames[I], GetJSONDate(Table.FieldByName(TableFieldNames[I]).AsDateTime));
            end
              else
            begin
              DataRecord.AddPair(FieldNames[I], Table.FieldByName(TableFieldNames[I]).AsString);
            end;

          end;
          DataArray.Add(DataRecord);
          Table.Next;
        end;
      end;

      Table.Close;

      //Fetch the changed / added records
      Result.AddPair(DataKey, DataArray);
    finally
      Table.Free;
    end;
  finally
    JSONObject.Free;
    PrimaryKeys.Free;
  end;
end;


{$IFDEF MSWINDOWS}
/// <summary> Runs a shell command, the command takes in the full path to the command to be run
/// </summary>
/// <param name="ACommand"> Full path to where the script or command is to be run
/// </param>
/// <param name="AOutput"> The std out text output from running the command
/// </param>
/// <remarks>
/// The "error is returned in the result - 0 for no errors and 1 for an error or exception
/// </remarks>
/// <returns>
/// Integer 0 = no errors or 1 = exception happened
/// </returns>
function ExecuteShellCommand(const ACmdLine: string; var AOutput: string): Integer;
const
  cBufferSize = 2048;
var
  vBuffer: Pointer;
  vStartupInfo: TStartUpInfo;
  vSecurityAttributes: TSecurityAttributes;
  vReadBytes: DWord;
  vProcessInfo: TProcessInformation;
  vStdInPipe : TAnoPipe;
  vStdOutPipe: TAnoPipe;
begin
  Result := 0;

  with vSecurityAttributes do
  begin
    nlength := SizeOf(TSecurityAttributes);
    binherithandle := True;
    lpsecuritydescriptor := nil;
  end;

  // Create anonymous pipe for standard input
  if not CreatePipe(vStdInPipe.Output, vStdInPipe.Input, @vSecurityAttributes, 0) then
    raise Exception.Create('Failed to create pipe for standard input. System error message: ' + SysErrorMessage(GetLastError));

  try
    // Create anonymous pipe for standard output (and also for standard error)
    if not CreatePipe(vStdOutPipe.Output, vStdOutPipe.Input, @vSecurityAttributes, 0) then
      raise Exception.Create('Failed to create pipe for standard output. System error message: ' + SysErrorMessage(GetLastError));

    try
      GetMem(vBuffer, cBufferSize);
      try
        // initialize the startup info to match our purpose
        FillChar(vStartupInfo, Sizeof(TStartUpInfo), #0);
        vStartupInfo.cb         := SizeOf(TStartUpInfo);
        vStartupInfo.wShowWindow:= SW_HIDE;  // we don't want to show the process
        // assign our pipe for the process' standard input
        vStartupInfo.hStdInput  := vStdInPipe.Output;
        // assign our pipe for the process' standard output
        vStartupInfo.hStdOutput := vStdOutPipe.Input;
        vStartupInfo.dwFlags    := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;

        if not CreateProcess(nil
                             , PChar(ACmdLine)
                             , @vSecurityAttributes
                             , @vSecurityAttributes
                             , True
                             , NORMAL_PRIORITY_CLASS
                             , nil
                             , nil
                             , vStartupInfo
                             , vProcessInfo) then
          raise Exception.Create('Failed creating the console process. System error msg: ' + SysErrorMessage(GetLastError));

        try
          // wait until the console program terminated
          while WaitForSingleObject(vProcessInfo.hProcess, 50)=WAIT_TIMEOUT do
            Sleep(0);

          // clear the output storage
          AOutput := '';
          // Read text returned by the console program in its StdOut channel
          repeat
            ReadFile(vStdOutPipe.Output, vBuffer^, cBufferSize, vReadBytes, nil);
            if vReadBytes > 0 then
            begin
              AOutput := AOutput + StrPas(PAnsiChar(vBuffer));
              Inc(Result, vReadBytes);
            end;
          until (vReadBytes < cBufferSize);
        finally
          CloseHandle(vProcessInfo.hProcess);
          CloseHandle(vProcessInfo.hThread);
        end;
      finally
        FreeMem(vBuffer);
      end;
    finally
      CloseHandle(vStdOutPipe.Input);
      CloseHandle(vStdOutPipe.Output);
    end;
  finally
    CloseHandle(vStdInPipe.Input);
    CloseHandle(vStdInPipe.Output);
  end;
end;
{$ELSE}

function popen(const command: MarshaledAString; const _type: MarshaledAString): TStreamHandle; cdecl; external libc name _PU + 'popen';
function pclose(filehandle: TStreamHandle): int32; cdecl; external libc name _PU + 'pclose';
function fgets(buffer: pointer; size: int32; Stream: TStreamHAndle): pointer; cdecl; external libc name _PU + 'fgets';


/// <summary> Runs a shell command, the command takes in the full path to the command to be run
/// </summary>
/// <param name="ACommand"> Full path to where the script or command is to be run
/// </param>
/// <param name="AOutput"> The std out text output from running the command
/// </param>
/// <remarks>
/// The "error is returned in the result - 0 for no errors and 1 for an error or exception
/// </remarks>
/// <returns>
/// Integer 0 = no errors or 1 = exception happened
/// </returns>
function ExecuteShellCommand(ACommand : string; var AOutput: string) : Integer;
var
  Handle: TStreamHandle;
  Data: array[0..511] of uint8;
  M : TMarshaller;
  Output: TStringList;

begin
  Result := 0;
  Output := TStringList.Create;
  try
    Handle := popen(M.AsAnsi(PWideChar(ACommand)).ToPointer,'r');
    try
      while fgets(@data[0],Sizeof(Data),Handle)<>nil do begin
        Output.Add(Copy(UTF8ToString(@Data[0]),1,UTF8ToString(@Data[0]).Length -1));//,sizeof(Data)));
      end;
    finally
      pclose(Handle);
    end;
  except
    on E: Exception do
    begin
      Result := 1;
      Output.Add(E.ClassName + ': ' + E.Message);
    end;
  end;
  AOutput := Output.Text;
end;
{$ENDIF}

end.