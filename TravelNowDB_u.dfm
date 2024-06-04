object DBTravelNow: TDBTravelNow
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 356
  Width = 235
  object tblClient: TADOTable
    CursorType = ctStatic
    TableName = 'TblClient'
    Left = 104
    Top = 16
  end
  object tblEmployee: TADOTable
    CursorType = ctStatic
    TableName = 'TblEmployee'
    Left = 104
    Top = 80
  end
  object tblAdmin: TADOTable
    CursorType = ctStatic
    TableName = 'TblAdmin'
    Left = 104
    Top = 144
  end
  object dsEmployee: TDataSource
    DataSet = tblEmployee
    Left = 168
    Top = 80
  end
  object dsAdmin: TDataSource
    DataSet = tblAdmin
    Left = 168
    Top = 144
  end
  object dsClient: TDataSource
    DataSet = tblClient
    Left = 168
    Top = 16
  end
  object qryTravelNow: TADOQuery
    Parameters = <>
    Left = 104
    Top = 296
  end
  object dsTravelNow: TDataSource
    DataSet = qryTravelNow
    Left = 168
    Top = 296
  end
  object tblAeroplane: TADOTable
    Left = 104
    Top = 200
  end
  object tblAirline: TADOTable
    Left = 104
    Top = 248
  end
  object dsAeroplane: TDataSource
    Left = 168
    Top = 200
  end
  object dsAirline: TDataSource
    Left = 168
    Top = 248
  end
end
