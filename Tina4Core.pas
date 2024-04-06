unit Tina4Core;

interface

uses JSON, System.SysUtils, FireDAC.DApt, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, System.NetEncoding,
  System.Classes, System.Net.HttpClientComponent, System.Net.URLClient;

type
  TTina4RequestType = (Get,Post,Patch,Put,Delete);
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


function CamelCase(FieldName: String): String;
function GetJSONFromDB(Connection: TFDConnection; SQL: String;
   Params: TFDParams = nil; DataSetName: String = 'records'): TJSONObject;
function GetJSONFromTable(Table: TFDMemTable; DataSetName: String = 'records'): TJSONObject; overload;
function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'): TJSONObject; overload;
function SendHttpRequest(BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi'; RequestType: TTina4RequestType = Get): String;
function StrToJSONObject(JSON:String): TJSONObject;
function StrToJSONArray(JSON:String): TJSONArray;
function GetJSONFieldName(FieldName: String) : String;
procedure GetFieldDefsFromJSONObject(JSONObject: TJSONObject; var MemTable: TFDMemTable);

implementation

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
function GetJSONFromTable(Table: TFDMemTable; DataSetName: String = 'records'): TJSONObject; overload;
var
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;

begin
  Result := TJSONObject.Create;
  DataArray := TJSONArray.Create;
  try
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
          if (Length(FieldNames) = Table.FieldDefs.Count) then
          // gets the field names in camel case on first iteration to save processing
          begin
            DataRecord.AddPair(FieldNames[I],
              Table.FieldByName(Table.FieldDefs[I].Name).AsString);
          end
          else
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(Table.FieldDefs[I].Name);
            DataRecord.AddPair(FieldNames[I],
              Table.FieldByName(Table.FieldDefs[I].Name).AsString);
          end;
        end;

        DataArray.Add(DataRecord);

        Table.Next;
      end;

      Result.AddPair(DataSetName, DataArray);
    finally

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
/// <remarks>
/// A JSON object is returned with an array of records, if an exception happens , error is returned with the correct error
/// </remarks>
/// <returns>
/// JSON Object with an Array of records
/// </returns>
function GetJSONFromTable(Table: TFDTable; DataSetName: String = 'records'): TJSONObject; overload;
var
  DataRecord: TJSONObject;
  DataArray: TJSONArray;
  I: Integer;
  FieldNames: Array of String;

begin
  Result := TJSONObject.Create;
  DataArray := TJSONArray.Create;
  try
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
          if (Length(FieldNames) = Table.FieldDefs.Count) then
          // gets the field names in camel case on first iteration to save processing
          begin
            DataRecord.AddPair(FieldNames[I],
              Table.FieldByName(Table.FieldDefs[I].Name).AsString);
          end
          else
          begin
            SetLength(FieldNames, Length(FieldNames) + 1);
            FieldNames[I] := CamelCase(Table.FieldDefs[I].Name);
            DataRecord.AddPair(FieldNames[I],
              Table.FieldByName(Table.FieldDefs[I].Name).AsString);
          end;
        end;

        DataArray.Add(DataRecord);

        Table.Next;
      end;

      Result.AddPair(DataSetName, DataArray);
    finally

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
/// <remarks>
/// A simple function to return back a response from a REST end point
/// </remarks>
/// <returns>
/// A string containing the results from the REST endpoint
/// </returns>
function SendHttpRequest(BaseURL: String; EndPoint: String = ''; QueryParams: String = ''; Body: String=''; ContentType: String = 'application/json';
  ContentEncoding : String = 'utf-8'; Username:String = ''; Password: String = ''; CustomHeaders: TURLHeaders = nil; UserAgent: String = 'Tina4Delphi';
  RequestType: TTina4RequestType = Get): String;
var
  HttpClient: TNetHTTPClient;
  HTTPRequest: TNetHTTPRequest;
  BodyList: TStringStream;
  MemoryStream : TMemoryStream;
  Url: String;
  Header: TNetHeader;



  function StreamToString(aStream: TStream): string;
  var
    SS: TStringStream;
  begin
    if aStream <> nil then
    begin
      SS := TStringStream.Create('');
      try
        SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
        Result := SS.DataString;
      finally
        SS.Free;
      end;
    end else
    begin
      Result := '';
    end;
  end;

begin
  try

    Url := BaseURL + '/' + EndPoint;

    if QueryParams <> '' then
    begin
      Url := Url + '?' + QueryParams;
    end;

    HttpClient := TNetHTTPClient.Create(nil);
    BodyList := TStringStream.Create(Body);

    try
      HttpClient.ConnectionTimeout := 60000;
      HttpClient.ResponseTimeout := 600000;

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

      if (Body <> '') then
      begin
        HTTPRequest := TNetHTTPRequest.Create(HttpClient);
        HTTPRequest.Client := HttpClient;
        //HTTPRequest.OnRequestCompleted := HTTPRequestCompleted;
        //HTTPRequest.OnRequestError := HTTPRequestError;

        HTTPRequest.Client.ContentType := ContentType;
        HTTPRequest.Accept := ContentType;
        HTTPRequest.AcceptEncoding := ContentEncoding;

        MemoryStream := TMemoryStream.Create;
        try
          HTTPRequest.Post(Url, BodyList, MemoryStream);
          Result := StreamToString(MemoryStream);
        finally
          MemoryStream.Free;
        end;

        if (Length(Result) > 0) and ((Result[1] <> '{') and (Result[1] <> '['))
        then
        begin
          Result := '{"error":"' + Result + '"}';
        end;
      end
        else
      begin
        MemoryStream := TMemoryStream.Create;
        try
          try
          HTTPRequest.Get(Url, MemoryStream);
          Result := StreamToString(MemoryStream);
          except
            on E:Exception do
            begin
              Result := '{"error":"'+E.Message+'"}';
            end;
          end;
        finally
          MemoryStream.Free;
        end;

        if (Length(Result) > 0) and ((Result[1] <> '{') and (Result[1] <> '['))
        then
        begin
          Result := '{"error":"' + Result + '"}';
        end;
      end;
    finally
      HTTPRequest.Free;
      HTTPClient.Free;
      BodyList.Free;
    end;
  except
    on E: Exception do
    begin
      Result := '{"error":"' + E.Message + '", "url": "' + Url + '", "body": ' +
        Body + '}';
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
            MemTable.FieldDefs.Add(FieldName, TFieldType.ftString, 1000);
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

end.
