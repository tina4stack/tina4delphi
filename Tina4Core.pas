unit Tina4Core;

interface

uses JSON, System.SysUtils, FireDAC.DApt, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TTina4Response = class(TObject)

  end;

  TTina4Request = class(TObject)

  end;

  function CamelCase(FieldName: String): String;
  function GetJSONFromDB(Connection: TFDConnection; SQL: String; DataSetName : String = 'records'; Params: TFDParams = nil) : TJSONObject;

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
      end
        else
      begin
        Result := FieldName;
      end;
      Result := NewName;
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
  function GetJSONFromDB(Connection: TFDConnection; SQL: String; DataSetName : String = 'records'; Params: TFDParams = nil) : TJSONObject;
  var
    Query : TFDQuery;
    DataRecord : TJSONObject;
    DataArray : TJSONArray;
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

          for I := 0 to Query.FieldDefs.Count -1 do
          begin
            if (Length(FieldNames) = Query.FieldDefs.Count) then //gets the field names in camel case on first iteration to save processing
            begin
              DataRecord.AddPair(FieldNames[I], Query.FieldByName(Query.FieldDefs[I].Name).AsString);
            end
              else
            begin
              SetLength(FieldNames, Length(FieldNames)+1);
              FieldNames[I] := CamelCase(Query.FieldDefs[I].Name);
              DataRecord.AddPair(FieldNames[I], Query.FieldByName(Query.FieldDefs[I].Name).AsString);
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
      on E:Exception do
      begin
        Result.AddPair('error', E.UnitName+ ' '+ E.Message);
      end;
    end;
  end;

end.
