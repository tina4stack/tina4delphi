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
  object FDMemTable1: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'ID'
        DataType = ftString
        Size = 1000
      end>
    IndexDefs = <>
    IndexesActive = False
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockPoint, uvLockWait, uvRefreshMode, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable, uvAutoCommitUpdates]
    UpdateOptions.UpdateChangedFields = False
    UpdateOptions.LockWait = True
    UpdateOptions.RefreshMode = rmManual
    UpdateOptions.FetchGeneratorsPoint = gpNone
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    UpdateOptions.CheckUpdatable = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 160
    Top = 304
    Content = {
      4144425310000000C9000000FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C0065003100050016000000460044004D0065006D
      005400610062006C00650031000600000000000700000800320000000900000A
      0000FF0BFF0C04000400000049004400050004000000490044000D0001000000
      0F000E001000E803000011000112000113000114000115000116000117000400
      0000490044001800E8030000FEFEFF19FEFF1AFEFF1BFEFEFEFF1CFEFF1D1E00
      02000000FF1FFEFEFE0E004D0061006E0061006700650072001E005500700064
      0061007400650073005200650067006900730074007200790012005400610062
      006C0065004C006900730074000A005400610062006C00650008004E0061006D
      006500140053006F0075007200630065004E0061006D0065000A005400610062
      0049004400240045006E0066006F0072006300650043006F006E007300740072
      00610069006E00740073001E004D0069006E0069006D0075006D004300610070
      0061006300690074007900180043006800650063006B004E006F0074004E0075
      006C006C001A0043006800650063006B0052006500610064004F006E006C0079
      00140043006F006C0075006D006E004C006900730074000C0043006F006C0075
      006D006E00100053006F0075007200630065004900440018006400740041006E
      007300690053007400720069006E006700100044006100740061005400790070
      0065000800530069007A0065001400530065006100720063006800610062006C
      006500120041006C006C006F0077004E0075006C006C00080042006100730065
      0014004F0041006C006C006F0077004E0075006C006C0012004F0049006E0055
      007000640061007400650010004F0049006E00570068006500720065001A004F
      0072006900670069006E0043006F006C004E0061006D006500140053006F0075
      00720063006500530069007A0065001C0043006F006E00730074007200610069
      006E0074004C00690073007400100056006900650077004C006900730074000E
      0052006F0077004C006900730074001800520065006C006100740069006F006E
      004C006900730074001C0055007000640061007400650073004A006F00750072
      006E0061006C001200530061007600650050006F0069006E0074000E00430068
      0061006E00670065007300}
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
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 656
    Top = 176
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 776
    Top = 168
  end
  object RESTResponse1: TRESTResponse
    Left = 768
    Top = 256
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Left = 656
    Top = 304
  end
  object Tina4REST1: TTina4REST
    UserAgent = 'Tina4REST'
    ReadTimeOut = 0
    ConnectTimeOut = 0
    Left = 168
    Top = 480
    Headers = ()
  end
  object Tina4WebServer1: TTina4WebServer
    Active = False
    Left = 528
    Top = 240
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    SyncMode = Clear
    RequestType = Get
    StatusCode = 0
    SourceIgnoreBlanks = False
    Tina4REST = Tina4REST1
    Left = 408
    Top = 544
  end
end
