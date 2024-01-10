object frmDataModule: TfrmDataModule
  Height = 781
  Width = 883
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
    Left = 408
    Top = 304
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 256
    Top = 200
  end
  object Tina4REST1: TTina4REST
    UserAgent = 'Tina4REST'
    BaseUrl = 'http://localhost:7112/api'
    CustomHeaders.Strings = (
      'Authorization: Bearer abc')
    Left = 72
    Top = 407
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    RequestType = Get
    DataKey = 'data'
    EndPoint = 'sim'
    MemTable = FDMemTable1
    Tina4REST = Tina4REST1
    ResponseBody.Strings = (
      '{"data":[{"ID":1,"id":1,"iD":1},{"ID":2,"id":2,"iD":2}]}')
    OnExecuteDone = Tina4RESTRequest1ExecuteDone
    Left = 237
    Top = 408
  end
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'ID'
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
    Left = 160
    Top = 304
    Content = {
      4144425310000000EC000000FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C0065003100050016000000460044004D0065006D
      005400610062006C0065003100060000000000070000080032000000090000FF
      0AFF0B04000400000049004400050004000000490044000C00010000000E000D
      000F00E803000010000111000112000113000114000115000116000400000049
      0044001700E8030000FEFEFF18FEFF19FEFF1AFF1B1C0000000000FF1D000001
      00000031FEFEFF1B1C0001000000FF1D00000100000032FEFEFEFEFEFF1EFEFF
      1F200002000000FF21FEFEFE0E004D0061006E0061006700650072001E005500
      7000640061007400650073005200650067006900730074007200790012005400
      610062006C0065004C006900730074000A005400610062006C00650008004E00
      61006D006500140053006F0075007200630065004E0061006D0065000A005400
      6100620049004400240045006E0066006F0072006300650043006F006E007300
      74007200610069006E00740073001E004D0069006E0069006D0075006D004300
      6100700061006300690074007900180043006800650063006B004E006F007400
      4E0075006C006C00140043006F006C0075006D006E004C006900730074000C00
      43006F006C0075006D006E00100053006F007500720063006500490044001800
      6400740041006E007300690053007400720069006E0067001000440061007400
      610054007900700065000800530069007A006500140053006500610072006300
      6800610062006C006500120041006C006C006F0077004E0075006C006C000800
      420061007300650014004F0041006C006C006F0077004E0075006C006C001200
      4F0049006E0055007000640061007400650010004F0049006E00570068006500
      720065001A004F0072006900670069006E0043006F006C004E0061006D006500
      140053006F007500720063006500530069007A0065001C0043006F006E007300
      74007200610069006E0074004C00690073007400100056006900650077004C00
      6900730074000E0052006F0077004C00690073007400060052006F0077000A00
      52006F0077004900440010004F0072006900670069006E0061006C0018005200
      65006C006100740069006F006E004C006900730074001C005500700064006100
      7400650073004A006F00750072006E0061006C00120053006100760065005000
      6F0069006E0074000E004300680061006E00670065007300}
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
    Left = 529
    Top = 120
  end
  object Tina4Route1: TTina4Route
    EndPoint = '/api/cars'
    CRUD = False
    Left = 424
    Top = 450
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
