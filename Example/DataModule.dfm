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
    Top = 471
  end
  object Tina4RESTRequest1: TTina4RESTRequest
    RequestType = Get
    DataKey = 'data'
    EndPoint = 'admin/users'
    MemTable = FDMemTable1
    Tina4REST = Tina4REST1
    ResponseBody.Strings = (
      
        '{"recordsTotal":1,"recordsFiltered":1,"recordCount":1,"recordsOf' +
        'fset":0,"fields":[{"index":0,"fieldName":"id","fieldAlias":"id",' +
        '"description":null,"dataType":"","size":0,"decimals":0,"alignmen' +
        't":0,"defaultValue":null,"isNotNull":null,"isPrimaryKey":null,"i' +
        'sForeignKey":null},{"index":1,"fieldName":"first_name","fieldAli' +
        'as":"first_name","description":null,"dataType":"","size":0,"deci' +
        'mals":0,"alignment":0,"defaultValue":null,"isNotNull":null,"isPr' +
        'imaryKey":null,"isForeignKey":null},{"index":2,"fieldName":"last' +
        '_name","fieldAlias":"last_name","description":null,"dataType":""' +
        ',"size":0,"decimals":0,"alignment":0,"defaultValue":null,"isNotN' +
        'ull":null,"isPrimaryKey":null,"isForeignKey":null},{"index":3,"f' +
        'ieldName":"email","fieldAlias":"email","description":null,"dataT' +
        'ype":"","size":0,"decimals":0,"alignment":0,"defaultValue":null,' +
        '"isNotNull":null,"isPrimaryKey":null,"isForeignKey":null},{"inde' +
        'x":4,"fieldName":"password","fieldAlias":"password","description' +
        '":null,"dataType":"","size":0,"decimals":0,"alignment":0,"defaul' +
        'tValue":null,"isNotNull":null,"isPrimaryKey":null,"isForeignKey"' +
        ':null},{"index":5,"fieldName":"is_active","fieldAlias":"is_activ' +
        'e","description":null,"dataType":"","size":0,"decimals":0,"align' +
        'ment":0,"defaultValue":null,"isNotNull":null,"isPrimaryKey":null' +
        ',"isForeignKey":null},{"index":6,"fieldName":"reset_token","fiel' +
        'dAlias":"reset_token","description":null,"dataType":"","size":0,' +
        '"decimals":0,"alignment":0,"defaultValue":null,"isNotNull":null,' +
        '"isPrimaryKey":null,"isForeignKey":null},{"index":7,"fieldName":' +
        '"date_created","fieldAlias":"date_created","description":null,"d' +
        'ataType":"","size":0,"decimals":0,"alignment":0,"defaultValue":n' +
        'ull,"isNotNull":null,"isPrimaryKey":null,"isForeignKey":null},{"' +
        'index":8,"fieldName":"date_modified","fieldAlias":"date_modified' +
        '","description":null,"dataType":"","size":0,"decimals":0,"alignm' +
        'ent":0,"defaultValue":null,"isNotNull":null,"isPrimaryKey":null,' +
        '"isForeignKey":null},{"index":9,"fieldName":"role_id","fieldAlia' +
        's":"role_id","description":null,"dataType":"","size":0,"decimals' +
        '":0,"alignment":0,"defaultValue":null,"isNotNull":null,"isPrimar' +
        'yKey":null,"isForeignKey":null},{"index":10,"fieldName":"site_id' +
        '","fieldAlias":"site_id","description":null,"dataType":"","size"' +
        ':0,"decimals":0,"alignment":0,"defaultValue":null,"isNotNull":nu' +
        'll,"isPrimaryKey":null,"isForeignKey":null}],"data":[{"id":1,"fi' +
        'rstName":"Andre Carel","lastName":"van Zuydam","email":"andrevan' +
        'zuydam@gmail.com","password":"$2y$10$4oW.iXPZAPmfBCm5TMXPM.1s3wi' +
        'CIT7wN5Kr8sdmrMaUg6CRMZWUi","isActive":1,"resetToken":"","dateCr' +
        'eated":null,"dateModified":null,"roleId":1,"siteId":1,"first_nam' +
        'e":"Andre Carel","last_name":"van Zuydam","is_active":1,"reset_t' +
        'oken":"","date_created":null,"date_modified":null,"role_id":1,"s' +
        'ite_id":1}],"dataError":null}')
    OnExecuteDone = Tina4RESTRequest1ExecuteDone
    Left = 165
    Top = 432
  end
  object FDMemTable1: TFDMemTable
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
        Name = 'password'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'isActive'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'resetToken'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'dateCreated'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'dateModified'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'roleId'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'siteId'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'first_name'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'last_name'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'is_active'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'reset_token'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'date_created'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'date_modified'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'role_id'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'site_id'
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
      4144425310000000D6080000FF00010001FF02FF03040016000000460044004D
      0065006D005400610062006C0065003100050016000000460044004D0065006D
      005400610062006C0065003100060000000000070000080032000000090000FF
      0AFF0B04000400000069006400050004000000690064000C00010000000E000D
      000F00E803000010000111000112000113000114000115000116000400000069
      0064001700E8030000FEFF0B040012000000660069007200730074004E006100
      6D006500050012000000660069007200730074004E0061006D0065000C000200
      00000E000D000F00E80300001000011100011200011300011400011500011600
      12000000660069007200730074004E0061006D0065001700E8030000FEFF0B04
      00100000006C006100730074004E0061006D0065000500100000006C00610073
      0074004E0061006D0065000C00030000000E000D000F00E80300001000011100
      011200011300011400011500011600100000006C006100730074004E0061006D
      0065001700E8030000FEFF0B04000A00000065006D00610069006C0005000A00
      000065006D00610069006C000C00040000000E000D000F00E803000010000111
      000112000113000114000115000116000A00000065006D00610069006C001700
      E8030000FEFF0B040010000000700061007300730077006F0072006400050010
      000000700061007300730077006F00720064000C00050000000E000D000F00E8
      0300001000011100011200011300011400011500011600100000007000610073
      00730077006F00720064001700E8030000FEFF0B040010000000690073004100
      6300740069007600650005001000000069007300410063007400690076006500
      0C00060000000E000D000F00E803000010000111000112000113000114000115
      0001160010000000690073004100630074006900760065001700E8030000FEFF
      0B0400140000007200650073006500740054006F006B0065006E000500140000
      007200650073006500740054006F006B0065006E000C00070000000E000D000F
      00E8030000100001110001120001130001140001150001160014000000720065
      0073006500740054006F006B0065006E001700E8030000FEFF0B040016000000
      6400610074006500430072006500610074006500640005001600000064006100
      7400650043007200650061007400650064000C00080000000E000D000F00E803
      0000100001110001120001130001140001150001160016000000640061007400
      650043007200650061007400650064001700E8030000FEFF0B04001800000064
      006100740065004D006F00640069006600690065006400050018000000640061
      00740065004D006F006400690066006900650064000C00090000000E000D000F
      00E8030000100001110001120001130001140001150001160018000000640061
      00740065004D006F006400690066006900650064001700E8030000FEFF0B0400
      0C00000072006F006C0065004900640005000C00000072006F006C0065004900
      64000C000A0000000E000D000F00E80300001000011100011200011300011400
      0115000116000C00000072006F006C006500490064001700E8030000FEFF0B04
      000C00000073006900740065004900640005000C000000730069007400650049
      0064000C000B0000000E000D000F00E803000010000111000112000113000114
      000115000116000C0000007300690074006500490064001700E8030000FEFF0B
      040014000000660069007200730074005F006E0061006D006500050014000000
      660069007200730074005F006E0061006D0065000C000C0000000E000D000F00
      E803000010000111000112000113000114000115000116001400000066006900
      7200730074005F006E0061006D0065001700E8030000FEFF0B0400120000006C
      006100730074005F006E0061006D0065000500120000006C006100730074005F
      006E0061006D0065000C000D0000000E000D000F00E803000010000111000112
      00011300011400011500011600120000006C006100730074005F006E0061006D
      0065001700E8030000FEFF0B040012000000690073005F006100630074006900
      76006500050012000000690073005F006100630074006900760065000C000E00
      00000E000D000F00E80300001000011100011200011300011400011500011600
      12000000690073005F006100630074006900760065001700E8030000FEFF0B04
      0016000000720065007300650074005F0074006F006B0065006E000500160000
      00720065007300650074005F0074006F006B0065006E000C000F0000000E000D
      000F00E803000010000111000112000113000114000115000116001600000072
      0065007300650074005F0074006F006B0065006E001700E8030000FEFF0B0400
      1800000064006100740065005F00630072006500610074006500640005001800
      000064006100740065005F0063007200650061007400650064000C0010000000
      0E000D000F00E803000010000111000112000113000114000115000116001800
      000064006100740065005F0063007200650061007400650064001700E8030000
      FEFF0B04001A00000064006100740065005F006D006F00640069006600690065
      00640005001A00000064006100740065005F006D006F00640069006600690065
      0064000C00110000000E000D000F00E803000010000111000112000113000114
      000115000116001A00000064006100740065005F006D006F0064006900660069
      00650064001700E8030000FEFF0B04000E00000072006F006C0065005F006900
      640005000E00000072006F006C0065005F00690064000C00120000000E000D00
      0F00E803000010000111000112000113000114000115000116000E0000007200
      6F006C0065005F00690064001700E8030000FEFF0B04000E0000007300690074
      0065005F006900640005000E00000073006900740065005F00690064000C0013
      0000000E000D000F00E803000010000111000112000113000114000115000116
      000E00000073006900740065005F00690064001700E8030000FEFEFF18FEFF19
      FEFF1AFEFEFEFF1BFEFF1C1D0099050000FF1EFEFEFE0E004D0061006E006100
      6700650072001E00550070006400610074006500730052006500670069007300
      74007200790012005400610062006C0065004C006900730074000A0054006100
      62006C00650008004E0061006D006500140053006F0075007200630065004E00
      61006D0065000A0054006100620049004400240045006E0066006F0072006300
      650043006F006E00730074007200610069006E00740073001E004D0069006E00
      69006D0075006D00430061007000610063006900740079001800430068006500
      63006B004E006F0074004E0075006C006C00140043006F006C0075006D006E00
      4C006900730074000C0043006F006C0075006D006E00100053006F0075007200
      630065004900440018006400740041006E007300690053007400720069006E00
      67001000440061007400610054007900700065000800530069007A0065001400
      530065006100720063006800610062006C006500120041006C006C006F007700
      4E0075006C006C000800420061007300650014004F0041006C006C006F007700
      4E0075006C006C0012004F0049006E0055007000640061007400650010004F00
      49006E00570068006500720065001A004F0072006900670069006E0043006F00
      6C004E0061006D006500140053006F007500720063006500530069007A006500
      1C0043006F006E00730074007200610069006E0074004C006900730074001000
      56006900650077004C006900730074000E0052006F0077004C00690073007400
      1800520065006C006100740069006F006E004C006900730074001C0055007000
      640061007400650073004A006F00750072006E0061006C001200530061007600
      650050006F0069006E0074000E004300680061006E00670065007300}
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
