unit DelphiHtmlComponentUtility;

interface

uses
  System.SysUtils, htmlpars, fmx.htscriptgui, fmx.fhtmlcomp, fmx.fhtmldraw, JSON;

function GetInputsAsJSON (const HtPanel: THtPanel): TJSONObject;

implementation


function GetInputsAsJSON (const HtPanel: THtPanel): TJSONObject;
var
  Elements: THtNodeList;
  Element: THtNode;
  HtmlElement: TElement;
  I: Integer;
  InputName, InputType: string;
  JSONResult: TJSONObject;

begin
  JSONResult := TJSONObject.Create;
  Elements := THtNodeList.Create(False, True);
  try
    // Get all input elements from the DOM
    HTPanel.Document.GetElementsbyAttr('*', '', Elements);
    try
      for Element in Elements do
      begin
        InputName := Element.A['name']; // Get the 'name' attribute
        if InputName = '' then
          Continue; // Skip inputs without a name

        InputType := LowerCase(Element.A['type']); // Get the input type

        if (InputType = 'checkbox') or (InputType = 'radio') then
        begin
              if Element.A['checked'] <> '' then
                JSONResult.AddPair(InputName, TJSONBool.Create(True))
              else
                JSONResult.AddPair(InputName, TJSONBool.Create(False));
        end
          else
        if (InputType = 'text') or (InputType = 'email') or (InputType = 'password') or (InputType = 'hidden') then
        begin
          JSONResult.AddPair(InputName, TJSONString.Create(Element.A['value']));
        end;
      end;
    finally
      Elements.Free;
    end;
    Result := JSONResult;
  except
    on E: Exception do
    begin
      JSONResult.Free;
      raise Exception.Create('Error collecting form inputs: ' + E.Message);
    end;
  end;
end;

end.
