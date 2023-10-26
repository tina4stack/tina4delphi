object frmDataModule: TfrmDataModule
  Height = 480
  Width = 640
  object Tina4HttpServer1: TTina4HttpServer
    Bindings = <>
    MaxConnections = 1024
    Scheduler = IdSchedulerOfThreadPool1
    OnCommandGet = Tina4HttpServer1CommandGet
    Left = 264
    Top = 144
  end
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 328
    Top = 336
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\projects\tina4delphi\Example\Car_Database.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 192
    Top = 232
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 304
    Top = 232
  end
  object Tina4Route1: TTina4Route
    Left = 200
    Top = 384
  end
  object Tina4REST1: TTina4REST
    Left = 336
    Top = 416
  end
end
