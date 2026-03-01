object frmDataModule: TfrmDataModule
  Height = 879
  Width = 1304
  PixelsPerInch = 144
  object IdSchedulerOfThreadPool1: TIdSchedulerOfThreadPool
    MaxThreads = 50
    PoolSize = 100
    Left = 264
    Top = 120
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\projects\tina4delphi\Example\Car_Database.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 612
    Top = 456
  end
  object FDTable1: TFDTable
    Connection = FDConnection1
    Left = 384
    Top = 300
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
    Left = 240
    Top = 456
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
    Left = 192
    Top = 228
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
    Left = 794
    Top = 180
  end
  object RESTClient1: TRESTClient
    Params = <>
    SynchronizedEvents = False
    Left = 984
    Top = 264
  end
  object RESTRequest1: TRESTRequest
    Client = RESTClient1
    Params = <>
    Response = RESTResponse1
    SynchronizedEvents = False
    Left = 1164
    Top = 252
  end
  object RESTResponse1: TRESTResponse
    Left = 1152
    Top = 384
  end
  object RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Left = 984
    Top = 456
  end
  object Tina4WebServer1: TTina4WebServer
    HTTPServer = IdHTTPServer1
    Active = False
    Left = 792
    Top = 360
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    TransformResultToSnakeCase = False
    FreeOnAsyncExecute = False
    SyncMode = Clear
    RequestType = Get
    StatusCode = 0
    SourceIgnoreBlanks = False
    Tina4REST = Tina4REST1
    Left = 430
    Top = 682
  end
  object Tina4JSONAdapter1: TTina4JSONAdapter
    DataKey = 'employees'
    MemTable = FDMemTable3
    JSONData.Strings = (
      
        '{"employees": [{"id": "1", "firstName": "John", "lastName": "Doe' +
        '", "email": "john@example.com", "department": "Engineering"}, {"' +
        'id": "2", "firstName": "Jane", "lastName": "Smith", "email": "ja' +
        'ne@example.com", "department": "Marketing"}, {"id": "3", "firstN' +
        'ame": "Bob", "lastName": "Wilson", "email": "bob@example.com", "' +
        'department": "Engineering"}]}')
    SyncMode = Clear
    Left = 480
    Top = 597
  end
  object FDMemTable3: TFDMemTable
    Active = True
    FieldDefs = <
      item
        Name = 'id'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'firstName'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'lastName'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'email'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'department'
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
    Left = 835
    Top = 672
  end
  object Tina4REST1: TTina4REST
    UserAgent = 'Tina4REST'
    ReadTimeOut = 0
    ConnectTimeOut = 0
    Left = 240
    Top = 653
    Headers = ()
  end
end
