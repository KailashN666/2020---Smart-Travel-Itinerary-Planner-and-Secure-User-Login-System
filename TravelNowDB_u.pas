unit TravelNowDB_u;

interface

uses
  SysUtils, Classes, ADODB, DB;

type
  TDBTravelNow = class(TDataModule)
    tblClient: TADOTable;
    tblEmployee: TADOTable;
    tblAdmin: TADOTable;
    dsEmployee: TDataSource;
    dsAdmin: TDataSource;
    dsClient: TDataSource;
    qryTravelNow: TADOQuery;
    dsTravelNow: TDataSource;
    tblAeroplane: TADOTable;
    tblAirline: TADOTable;
    dsAeroplane: TDataSource;
    dsAirline: TDataSource;
    Procedure DatabaseConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DBTravelNow: TDBTravelNow;

implementation

{$R *.dfm}

{ TDBTravelNow }

procedure TDBTravelNow.DatabaseConnection;
Const
  DBName = 'TravelNow.accdb';
Var
  conTravelNow : TADOConnection;
  sDataSource : String;
begin
  conTravelNow := TADOConnection.Create(DBTravelNow);
  sDataSource := ExtractFilePath(ParamStr(0)) + DBName;
  conTravelNow.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;'+
                                   'Data Source=' +sDataSource+
                                   ';Persist Security Info=False';

  conTravelNow.LoginPrompt := False;

  tblClient.Connection := conTravelNow;
  tblClient.TableName := 'TblClient';
  tblClient.Open;

  tblEmployee.Connection := conTravelNow;
  tblEmployee.TableName := 'TblEmployee';
  tblEmployee.Open;

  tblAdmin.Connection := conTravelNow;
  tblAdmin.TableName := 'TblAdmin';
  tblAdmin.Open;

  tblAeroplane.Connection := conTravelNow;
  tblAeroplane.TableName := 'TblAeroplane';
  tblAeroplane.Open;

  tblAirline.Connection := conTravelNow;
  tblAirline.TableName := 'TblAirline';
  tblAirline.Open;

  qryTravelNow.Connection := conTravelNow;

  dsClient.DataSet := tblClient;
  dsEmployee.DataSet := tblEmployee;
  dsAdmin.DataSet := tblAdmin;
  dsAeroplane.DataSet := tblAeroplane;
  dsAirline.DataSet := tblAirline;
  dsTravelNow.DataSet := qryTravelNow;
end;

procedure TDBTravelNow.DataModuleCreate(Sender: TObject);
begin
  DatabaseConnection;
end;

end.
