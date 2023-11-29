object frmDataModule: TfrmDataModule
  Height = 633
  Width = 790
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 176
    Top = 80
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\projects\tina4delphi\Example\Car_Database.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 360
    Top = 200
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 256
    Top = 200
  end
  object Tina4REST1: TTina4REST
    UserAgent = 'Tina4REST'
    BaseUrl = 'https://catfact.ninja'
    Left = 184
    Top = 367
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    RequestType = Get
    EndPoint = 'fact'
    MemTable = FDMemTable1
    Tina4REST = Tina4REST1
    ResponseBody.Strings = (
      
        '{"fact":"Cats sleep 16 to 18 hours per day. When cats are asleep' +
        ', they are still alert to incoming stimuli. If you poke the tail' +
        ' of a sleeping cat, it will respond accordingly.","length":167}')
    OnExecuteDone = Tina4RESTRequest1ExecuteDone
    Left = 285
    Top = 368
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'fact'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'length'
        DataType = ftString
        Size = 1000
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 480
    Top = 72
    Content = {
      4144425310000000F5010000FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C0065003100050016000000460044004D0065006D
      005400610062006C0065003100060000000000070000080032000000090000FF
      0AFF0B040008000000660061006300740005000800000066006100630074000C
      00010000000E000D000F00E80300001000011100011200011300011400011500
      0116000800000066006100630074001700E8030000FEFF0B04000C0000006C00
      65006E0067007400680005000C0000006C0065006E006700740068000C000200
      00000E000D000F00E80300001000011100011200011300011400011500011600
      0C0000006C0065006E006700740068001700E8030000FEFEFF18FEFF19FEFF1A
      FF1B1C0000000000FF1D0000A70000004361747320736C65657020313620746F
      20313820686F75727320706572206461792E205768656E206361747320617265
      2061736C6565702C207468657920617265207374696C6C20616C65727420746F
      20696E636F6D696E67207374696D756C692E20496620796F7520706F6B652074
      6865207461696C206F66206120736C656570696E67206361742C206974207769
      6C6C20726573706F6E64206163636F7264696E676C792E010003000000313637
      FEFEFEFEFEFF1EFEFF1F200096050000FF21FEFEFE0E004D0061006E00610067
      00650072001E0055007000640061007400650073005200650067006900730074
      007200790012005400610062006C0065004C006900730074000A005400610062
      006C00650008004E0061006D006500140053006F0075007200630065004E0061
      006D0065000A0054006100620049004400240045006E0066006F007200630065
      0043006F006E00730074007200610069006E00740073001E004D0069006E0069
      006D0075006D0043006100700061006300690074007900180043006800650063
      006B004E006F0074004E0075006C006C00140043006F006C0075006D006E004C
      006900730074000C0043006F006C0075006D006E00100053006F007500720063
      0065004900440018006400740041006E007300690053007400720069006E0067
      001000440061007400610054007900700065000800530069007A006500140053
      0065006100720063006800610062006C006500120041006C006C006F0077004E
      0075006C006C000800420061007300650014004F0041006C006C006F0077004E
      0075006C006C0012004F0049006E0055007000640061007400650010004F0049
      006E00570068006500720065001A004F0072006900670069006E0043006F006C
      004E0061006D006500140053006F007500720063006500530069007A0065001C
      0043006F006E00730074007200610069006E0074004C00690073007400100056
      006900650077004C006900730074000E0052006F0077004C0069007300740006
      0052006F0077000A0052006F0077004900440010004F0072006900670069006E
      0061006C001800520065006C006100740069006F006E004C006900730074001C
      0055007000640061007400650073004A006F00750072006E0061006C00120053
      0061007600650050006F0069006E0074000E004300680061006E006700650073
      00}
  end
  object Tina4WebServer1: TTina4WebServer
    Connection = FDConnection1
    HTTPServer = IdHTTPServer1
    Active = False
    Left = 88
    Top = 272
  end
  object IdHTTPServer1: TIdHTTPServer
    Bindings = <>
    Scheduler = IdSchedulerOfThreadPool1
    Left = 128
    Top = 152
  end
  object FDMemTable2: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'fact'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'length'
        DataType = ftString
        Size = 1000
      end>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.LockWait = True
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 473
    Top = 200
  end
  object Tina4Route1: TTina4Route
    EndPoint = '/api/cars'
    CRUD = False
    Left = 80
    Top = 370
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 632
    Top = 336
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 704
    Top = 336
  end
  object RESTResponse1: TRESTResponse
    Left = 704
    Top = 392
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Left = 704
    Top = 456
  end
end
