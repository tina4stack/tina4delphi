program Tina4DelphiExample;

{$APPTYPE CONSOLE}

{$R *.res}



uses
  System.SysUtils,
  DataModule in 'DataModule.pas' {frmDataModule: TDataModule};

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
   frmDatamodule := TfrmDataModule.Create(nil);
   try

   frmDatamodule.GetBrands;
   frmDatamodule.GetSBrands;
   frmDatamodule.GetEntries;

   frmDataModule.Tina4WebServer1.Active := True;
   while frmDataModule.Tina4WebServer1.Active do
   begin
     sleep (1000);
   end;


   ReadLn;

   finally
     frmDatamodule.Free;
   end;
  except
    on E: Exception do
    begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
