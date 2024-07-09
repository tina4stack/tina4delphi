unit Tina4Core;

interface

uses JSON, System.SysUtils, FireDAC.DApt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, System.NetEncoding, System.DateUtils,
  System.Classes, System.Generics.Collections, System.Net.HttpClientComponent, System.Net.URLClient, System.Net.HttpClient;

type
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


function CamelCase(FieldName: String): String;
function GetJSONFromDB(Connection: TFDConnection; SQL: String;
   Params: TFDParams = nil; DataSetName: String = 'records'): TJSONObject;
function GetJSONFromTable(var Table: TFDMemTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
function SendHttpRequest(BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi'; RequestType: TTina4RequestType = Get;
  ReadTimeOut: Integer = 10000; ConnectTimeOut: Integer = 5000): TBytes;
function StrToJSONObject(JSON:String): TJSONObject;
function BytesToJSONObject(JSON:TBytes): TJSONObject;
function StrToJSONArray(JSON:String): TJSONArray;
function GetJSONFieldName(FieldName: String) : String;
function GetJSONDate(const ADate: TDateTime) : String;
function JSONDateToDateTime(const ADateString: String) : TDateTime;
procedure GetFieldDefsFromJSONObject(JSONObject: TJSONObject; var MemTable: TFDMemTable);
procedure PopulateMemTableFromJSON(var MemTable: TFDMemTable; DataKey: String; JSON: String; IndexedFieldNames: String = ''; SyncMode: TTina4RestSyncMode = Clear; Component: TComponent = nil);

implementation

uses Tina4RESTRequest;

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
        Result := FieldName;
      end;
    except
      Result := FieldName;
    end;
  end;

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
function GetJSONFromDB(Connection: TFDConnection; SQL: String;
   Params: TFDParams = nil; DataSetName: String = 'records'): TJSONObject;
var
  Query: TFDQuery;
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;

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
          if (Length(FieldNames) = Query.FieldDefs.Count) then
          // gets the field names in camel case on first iteration to save processing
          begin
            DataRecord.AddPair(FieldNames[I],
              Query.FieldByName(Query.FieldDefs[I].Name).AsString);
          end
          else
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(Query.FieldDefs[I].Name);
            DataRecord.AddPair(FieldNames[I],
              Query.FieldByName(Query.FieldDefs[I].Name).AsString);
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

/// <summary> Returns a JSON Object response based on the data in a TFDMemTable
/// </summary>
/// <param name="Table">A TFDMemTable from which to get the data
/// </param>
/// <param name="DataSetName">A name to give the returned result, example: cats, the default is records
/// </param>
/// <remarks>
/// A JSON object is returned with an array of records, if an exception happens , error is returned with the correct error
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromTable(var Table: TFDMemTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
var
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;
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
      if not Table.Active then
      begin
        Table.Open;
      end;

      Table.First;

      while not Table.Eof do
      begin
        DataRecord := TJSONObject.Create;

        for I := 0 to Table.FieldDefs.Count - 1 do
        begin
          // gets the field names in camel case on first iteration to save processing

          if (Length(FieldNames) <> Table.FieldDefs.Count) then
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := Table.FieldDefs[I].Name;
          end;

          if (Pos('"'+FieldNames[I]+'"', IgnoreFields) = 0) then
          begin
            CanAddPair := True;
            if IgnoreBlanks and (Table.FieldByName(FieldNames[I]).AsString = '') then
            begin
              CanAddPair := False;
            end;

            if CanAddPair then
            begin
              if Table.FieldDefs[I].DataType = TFieldType.ftBlob then
              begin
                //Base 64 encode
                ByteStream := TBytesStream.Create(Table.FieldByName(FieldNames[I]).AsBytes);
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
              if Table.FieldDefs[I].DataType = TFieldType.ftDateTime then
              begin
                DataRecord.AddPair(FieldNames[I], GetJSONDate(Table.FieldByName(FieldNames[I]).AsDateTime));
              end
                else
              begin
                DataRecord.AddPair(FieldNames[I], Table.FieldByName(FieldNames[I]).AsString);
              end;
            end;
          end;
        end;

        DataArray.Add(DataRecord);
        Table.Next;
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

/// <summary> Returns a JSON Object response based on the data in a TFDTable
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
/// A JSON object is returned with an array of records, if an exception happens , error is returned with the correct error
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'; IgnoreFields: String = ''; IgnoreBlanks: Boolean = False): TJSONObject; overload;
var
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;
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
      if not Table.Active then
      begin
        Table.Open;
      end;

      Table.First;

      while not Table.Eof do
      begin
        DataRecord := TJSONObject.Create;

        for I := 0 to Table.FieldDefs.Count - 1 do
        begin
          // gets the field names in camel case on first iteration to save processing

          if (Length(FieldNames) <> Table.FieldDefs.Count) then
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(Table.FieldDefs[I].Name);
          end;

          if (Pos('"'+FieldNames[I]+'"', IgnoreFields) = 0) then
          begin
            CanAddPair := True;
            if IgnoreBlanks and (Table.FieldByName(FieldNames[I]).AsString = '') then
            begin
              CanAddPair := False;
            end;

            if CanAddPair then
            begin
              if Table.FieldDefs[I].DataType = TFieldType.ftBlob then
              begin
                //Base 64 encode
                ByteStream := TBytesStream.Create(Table.FieldByName(FieldNames[I]).AsBytes);
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
              if Table.FieldDefs[I].DataType = TFieldType.ftDateTime then
              begin
                DataRecord.AddPair(FieldNames[I], GetJSONDate(Table.FieldByName(FieldNames[I]).AsDateTime));
              end
                else
              begin
                DataRecord.AddPair(FieldNames[I], Table.FieldByName(FieldNames[I]).AsString);
              end;
            end;
          end;
        end;

        DataArray.Add(DataRecord);
        Table.Next;
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
function SendHttpRequest(BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi';
  RequestType: TTina4RequestType = Get; ReadTimeOut: Integer = 10000; ConnectTimeOut: Integer = 5000): TBytes;
var
  HttpClient: TNetHTTPClient;
  HTTPRequest: TNetHTTPRequest;
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

      HttpCLient.UserAgent := UserAgent;

      if (Username <> '') then
      begin
        var Auth := TNetEncoding.Base64.Encode(Username+':'+Password);
        HttpCLient.CustHeaders.Add('Authorization', 'Basic '+Auth);
      end;

      if Assigned(CustomHeaders) then
      begin
        for Header in CustomHeaders do
        begin
          HttpClient.CustHeaders.Add(Header);
        end;
      end;


      HTTPRequest.Client := HttpClient;
      HTTPRequest.Client.ContentType := ContentType;
      HTTPRequest.Client.Accept := ContentType;
      HTTPRequest.Client.AcceptEncoding := ContentEncoding;
      HTTPRequest.Client.AutomaticDecompression  := [THTTPCompressionMethod.Any];

      BytesStream := TBytesStream.Create;
      try
        try
          if RequestType = Post then
          begin
            HTTPRequest.Post(Url, BodyList, BytesStream);
          end
            else
          if RequestType = Patch then
          begin
            HTTPRequest.Patch(Url, BodyList, BytesStream);
          end
            else
          if RequestType = Put then
          begin
            HTTPRequest.Put(Url, BodyList, BytesStream);
          end
           else
          if RequestType = Get then
          begin
            HTTPRequest.Get(Url, BytesStream);
          end
            else
          if RequestType = Delete then
          begin
            HTTPRequest.Delete(Url, BytesStream);
          end;

          SetLength(Result, Length(BytesStream.Bytes));
          Move(BytesStream.Bytes[0],Result[0],Length(BytesStream.Bytes));
        except
          on E:Exception do
          begin
            Result := TEncoding.UTF8.GetBytes('{"error": "'+E.Message+'"}');
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
      Result := TEncoding.UTF8.GetBytes('{"error": "'+E.Message+'"}');
    end;
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


/// <summary> Gets the field name from a JSON string field
/// </summary>
/// <param name="FieldName">Field name in form "name"
/// </param>
/// <remarks>
/// The fields from a JSON object normally are enclosed in quotes and this removes them
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
procedure GetFieldDefsFromJSONObject(JSONObject: TJSONObject; var MemTable: TFDMemTable);
begin
  if (MemTable.FieldDefs.Count > 0) then Exit;

  try
    for var Index : Integer := 0 to JSONObject.Count-1 do
    begin
      var FieldName: String := JSONObject.Pairs[Index].JsonString.Value;

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
procedure PopulateMemTableFromJSON(var MemTable: TFDMemTable; DataKey: String; JSON: String; IndexedFieldNames: String = ''; SyncMode: TTina4RestSyncMode = Clear; Component: TComponent = nil);
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
          GetFieldDefsFromJSONObject(TJSONObject(JSONInfo), TFDMemTable(MemTable));
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
            MemTable.Filter := MemTable.Filter + IndexStringList[I] +' = '+QuotedStr(JSONRecord.GetValue<string>(IndexStringList[I]));
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

        var KeyIndex := MemTable.FieldDefs.IndexOf(JSONRecord.Pairs[Index].JsonString.Value);

        if KeyIndex >= 0 then
        begin
          if MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftDateTime then
          begin
            if (PairValue <> '') then
            begin
              MemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsDateTime := JSONDateToDateTime(PairValue);
            end
              else
            begin
              MemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsString := '';
            end;
          end
            else
          if MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftString then
          begin
            MemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsString := PairValue;
          end
            else
          if MemTable.FieldDefs[KeyIndex].DataType = TFieldType.ftBlob then
          begin
            MemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsBytes := TNetEncoding.Base64.DecodeStringToBytes(PairValue);
          end
            else
          begin
            MemTable.FieldByName(JSONRecord.Pairs[Index].JsonString.Value).AsString := PairValue;
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
        if (DataKey = '') and (GetJSONFieldName(JSONValue.JsonString.ToString) = 'response') then
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

        if (GetJSONFieldName(JSONValue.JsonString.ToString) = DataKey) then
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

end.