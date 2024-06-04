unit Admin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, TravelNowDB_u, StdCtrls, Grids, DBGrids, DB, jpeg;

type
  TfrmAdmin = class(TForm)
    pcAdmin: TPageControl;
    tsEmployee: TTabSheet;
    tsRevenue: TTabSheet;
    tsAirTravel: TTabSheet;
    dbEmployees: TDBGrid;
    btnDisplayAllEmployees: TButton;
    btnSearchForAnEmployee: TButton;
    grpAddEmployee: TGroupBox;
    grpEditEmployee: TGroupBox;
    edtFindEmployee: TEdit;
    btnFindEmployee: TButton;
    rgpEditEmployee: TRadioGroup;
    btnAddEmployee: TButton;
    lblName: TLabel;
    lblSurname: TLabel;
    lblPassword: TLabel;
    lblUsername: TLabel;
    edtName: TEdit;
    edtSurname: TEdit;
    edtPassword: TEdit;
    edtUsername: TEdit;
    btnSubmitEmployee: TButton;
    grpDeleteEmployee: TGroupBox;
    btnDeleteEmployee: TButton;
    btnSubmitDelete: TButton;
    edtDeleteEmp: TEdit;
    dbAirTravel: TDBGrid;
    btnDisplayAeroplanes: TButton;
    btnDisplayAirlines: TButton;
    btnDisplayAirlineAndAeroplanes: TButton;
    grpSpecificAirlines: TGroupBox;
    lblDisplayAeroplanesUnderASpecificAirline: TLabel;
    grpUpdateAirline: TGroupBox;
    btnSubmitAirlineDetails: TButton;
    cmbUpdateAirline: TComboBox;
    lblAirlineContactDetails: TLabel;
    edtAirlineContactDetails: TEdit;
    dbRevenue: TDBGrid;
    btnDisplayAllTransactions: TButton;
    btnDisplayForSpecificClient: TButton;
    rgpSort: TRadioGroup;
    rgpFilterRecords: TRadioGroup;
    btnHighestTicketSale: TButton;
    btnHighestAccommodationSale: TButton;
    btnHighestSale: TButton;
    btnMostValuableClient: TButton;
    btnTotalTicketRevenue: TButton;
    btnTotalAccomRevenue: TButton;
    btnTotalRevenue: TButton;
    redRevenue: TRichEdit;
    btnLowestAccomSale: TButton;
    btnLowestTicketSale: TButton;
    btnLowestSale: TButton;
    rgpGroup: TRadioGroup;
    btnClearAllTransactionData: TButton;
    btnSearchForAirline: TButton;
    btnAirlinesMoreSeatsAvailableThan: TButton;
    btnDisplayUsernameEmails: TButton;
    redAirTravel: TRichEdit;
    btnCloseProgram: TButton;
    imgAirTravel: TImage;
    procedure btnDisplayAllEmployeesClick(Sender: TObject);
    Function EmployeeUsernamePresentInDB(sUsername: String) : Boolean;
    procedure btnSearchForAnEmployeeClick(Sender: TObject);
    procedure btnFindEmployeeClick(Sender: TObject);
    procedure rgpEditEmployeeClick(Sender: TObject);
    procedure btnAddEmployeeClick(Sender: TObject);
    procedure btnSubmitEmployeeClick(Sender: TObject);
    procedure btnDeleteEmployeeClick(Sender: TObject);
    procedure btnSubmitDeleteClick(Sender: TObject);
    procedure btnDisplayAeroplanesClick(Sender: TObject);
    procedure btnDisplayAirlinesClick(Sender: TObject);
    procedure btnDisplayAirlineAndAeroplanesClick(Sender: TObject);
    procedure cmbUpdateAirlineClick(Sender: TObject);
    procedure btnSubmitAirlineDetailsClick(Sender: TObject);
    procedure btnDisplayAllTransactionsClick(Sender: TObject);
    procedure btnDisplayForSpecificClientClick(Sender: TObject);
    procedure btnHighestTicketSaleClick(Sender: TObject);
    procedure btnHighestAccommodationSaleClick(Sender: TObject);
    procedure btnHighestSaleClick(Sender: TObject);
    procedure btnLowestTicketSaleClick(Sender: TObject);
    procedure btnLowestAccomSaleClick(Sender: TObject);
    procedure btnLowestSaleClick(Sender: TObject);
    procedure btnTotalTicketRevenueClick(Sender: TObject);
    Function GetTotalSumFromTblSales(sFieldName : String) : Real;
    procedure btnTotalAccomRevenueClick(Sender: TObject);
    procedure btnTotalRevenueClick(Sender: TObject);
    procedure btnMostValuableClientClick(Sender: TObject);
    procedure rgpSortClick(Sender: TObject);
    procedure rgpGroupClick(Sender: TObject);
    procedure rgpFilterRecordsClick(Sender: TObject);
    procedure btnClearAllTransactionDataClick(Sender: TObject);
    procedure btnSearchForAirlineClick(Sender: TObject);
    procedure btnAirlinesMoreSeatsAvailableThanClick(Sender: TObject);
    procedure btnDisplayUsernameEmailsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCloseProgramClick(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdmin: TfrmAdmin;
  sEmpUsername : String;
implementation

{$R *.dfm}


//Insert new record
procedure TfrmAdmin.btnAddEmployeeClick(Sender: TObject);
begin
  if MessageDlg('Would you like to register a new employee to the database?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    edtName.Enabled := True;
    edtSurname.Enabled := True;
    edtPassword.Enabled := True;
    edtUsername.Enabled := True;
    btnSubmitEmployee.Enabled := True;
  End
  Else
  Begin
    MessageDlg('You have chosen to cancel the process.',mtInformation, mbOKCancel, 0);
  End;
end;

//Complex SQL involving Having
procedure TfrmAdmin.btnAirlinesMoreSeatsAvailableThanClick(Sender: TObject);
Var
  sAirline, sAeroplaneIDs : string;
  bPresent : Boolean;
  I: Integer;
begin
  sAirline := InputBox('Display Airlines with more seats available','Enter the name of the Airline you would like to compare available seats for.','');

  if sAirline <> '' then
  Begin
    With DBTravelNow Do
    Begin
      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select AirlineName From TblAirline');
      qryTravelNow.Open;

      for I := 1 to qryTravelNow.RecordCount do
      begin
        if UpperCase(qryTravelNow['AirlineName']) = UpperCase(sAirline) then
        Begin
          bPresent := True;
          Break
        End;

        qryTravelNow.Next;
      end;

      if bPresent = True then
      Begin
        dbAirTravel.DataSource := DBTravelNow.dsTravelNow;

        qryTravelNow.SQL.Clear;
        qryTravelNow.SQL.Add('Select TblAirline.AirlineName, Sum(NumOfSeatsAvailable) As [Number of Seats Avail] ');
        qryTravelNow.SQL.Add('From TblAeroplane, TblAirline ');
        qryTravelNow.SQL.Add('Where TblAeroplane.AirlineName = TblAirline.AirlineName ');
        qryTravelNow.SQL.Add('Group By TblAirline.AirlineName');
        qryTravelNow.SQL.Add('Having Sum(NumOfSeatsAvailable) >');
                     qryTravelNow.SQL.Add('(Select Sum(NumOfSeatsAvailable) ');
                     qryTravelNow.SQL.Add('From TblAeroplane, TblAirline ');
                     qryTravelNow.SQL.Add('Where TblAeroplane.AirlineName = TblAirline.AirlineName ');
                     qryTravelNow.SQL.Add('AND TblAirline.AirlineName = ' +QuotedStr(sAirline) +') ');
        qryTravelNow.Open;

        MessageDlg('These airlines have more seats available than the airline you have submitted.', mtInformation, mbOKCancel, 0);
      End
      Else
      Begin
        MessageDlg('Unfortunately, The requested Airline is not present in the database.', mtInformation, mbOKCancel, 0);
      End;
    End;
  End
  Else
  Begin
    MessageDlg('The Airline Name is not valid.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnClearAllTransactionDataClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear all transaction data? ' +#13+ 'All the data will be deleted', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    dbRevenue.DataSource := DBTravelNow.dsTravelNow;

    With DBTravelNow Do
    Begin
      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Delete from TblSales');
      qryTravelNow.ExecSQL;

      MessageDlg('All data has been cleared.', mtInformation, mbOKCancel, 0);

      btnDisplayAllTransactions.Click;
    End;
  End
  Else
  Begin
    MessageDlg('No data was cleared.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnCloseProgramClick(Sender: TObject);
begin
  if MessageDlg('Would you like to close the program?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    Application.Terminate;
  End;
end;

procedure TfrmAdmin.btnDeleteEmployeeClick(Sender: TObject);
begin
  if MessageDlg('Would you like to delete an Employee?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    MessageDlg('Please enter the username of the employee you wish to delete below.', mtInformation, mbOKCancel, 0);
    btnSubmitDelete.Enabled := True;
  End
  Else
  Begin
    MessageDlg('You chose to end the procedure.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnDisplayAeroplanesClick(Sender: TObject);
begin
  dbAirTravel.DataSource := DBTravelNow.dsTravelNow;

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select AeroplaneID, Destination, DepartureLocation AS [Departure Location], ');
    qryTravelNow.SQL.Add('TotalNumOfSeats AS [Total Num of Seats], NumOfSeatsAvailable AS [Seats Available], ');
    qryTravelNow.SQL.Add('DepartureDate As [Departure Date], AirlineName AS [Name of Airline]');
    qryTravelNow.SQL.Add('From TblAeroplane');
    qryTravelNow.Open;

    dbAirTravel.Columns[2].Width := 150;
    TDateTimeField(qryTravelNow.FieldByName('Departure Date')).DisplayFormat := 'dd mmmm yyyy';
  End;
end;

//Query involving 2 tables
procedure TfrmAdmin.btnDisplayAirlineAndAeroplanesClick(Sender: TObject);
begin
  dbAirTravel.DataSource := DBTravelNow.dsTravelNow;

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select AeroplaneID, Destination, DepartureLocation AS [Departure Location], ');
    qryTravelNow.SQL.Add('TotalNumOfSeats AS [Total Num of Seats], NumOfSeatsAvailable AS [Seats Available], ');
    qryTravelNow.SQL.Add('DepartureDate AS [Departure Date], TblAeroplane.AirlineName AS [Name of Airline], ');
    qryTravelNow.SQL.Add('AirlineEmail AS [Airline Contact Info]');
    qryTravelNow.SQL.Add('From TblAeroplane, TblAirline');
    qryTravelNow.SQL.Add('Where TblAeroplane.AirlineName = TblAirline.AirlineName');
    qryTravelNow.Open;

    dbAirTravel.Columns[2].Width := 150;
    TDateTimeField(qryTravelNow.FieldByName('Departure Date')).DisplayFormat := 'dd mmmm yyyy';
  End;
end;

procedure TfrmAdmin.btnDisplayAirlinesClick(Sender: TObject);
begin
  dbAirTravel.DataSource := DBTravelNow.dsTravelNow;

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select AirlineName AS [Name of Airline], ');
    qryTravelNow.SQL.Add('AirlineEmail AS [Airline Contact Info], NumberOfAeroplanes AS [Num of Aeroplanes Owned]');
    qryTravelNow.SQL.Add('From TblAirline');
    qryTravelNow.Open;
  End;
end;

procedure TfrmAdmin.btnDisplayAllEmployeesClick(Sender: TObject);
begin
  dbEmployees.DataSource := DBTravelNow.dsTravelNow;

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select * from TblEmployee');
    qryTravelNow.Open;
  End;
end;

procedure TfrmAdmin.btnDisplayAllTransactionsClick(Sender: TObject);
begin
  With DBTravelNow Do
  Begin
    dbRevenue.DataSource := DBTravelNow.dsTravelNow;

    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
    qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
    qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
    qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    dbRevenue.Columns[1].Width := 100;
    dbRevenue.Columns[2].Width := 100;
    TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End;
  End;
end;

procedure TfrmAdmin.btnDisplayForSpecificClientClick(Sender: TObject);
Var
  sUsername : String;
begin
  if MessageDlg('Would you like to search for Transactions by a specific client?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    sUsername := InputBox('Transactions by a specific client', 'Please enter the username of the client you would like to search for.', '');

    if sUsername <> '' then
    Begin
      With DBTravelNow Do
      Begin
        dbRevenue.DataSource := DBTravelNow.dsTravelNow;

        qryTravelNow.SQL.Clear;
        qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
        qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
        qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
        qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
        qryTravelNow.SQL.Add('From TblSales');
        qryTravelNow.SQL.Add('Where ClientUsername = ' + QuotedStr(sUsername));
        qryTravelNow.Open;

        dbRevenue.Columns[1].Width := 100;
        dbRevenue.Columns[2].Width := 100;
        TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
        TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
        TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

        if qryTravelNow.RecordCount = 0 then
        Begin
          MessageDlg('No records have been recorded for this client.', mtInformation, mbOKCancel, 0);
        End;
      End;
    End
    Else
    Begin
      MessageDlg('The username you have provided is not valid!', mtError, mbOKCancel, 0);
    End;
  End
  else
  Begin
    MessageDlg('No queries have been performed.', mtInformation, mbOKCancel, 0);
  End;
end;

//SQL using string manipulation
procedure TfrmAdmin.btnDisplayUsernameEmailsClick(Sender: TObject);
var
  I: Integer;
begin

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select left(AirlineEmail, len(AirlineEmail) -10) As [Username Without Extension]');
    qryTravelNow.SQL.Add('From TblAirline');
    qryTravelNow.Open;

    redAirTravel.Lines.Clear;
    redAirTravel.Lines.Add('Airline contact Email Usernames without extensions.');

    for I := 1 to qryTravelNow.RecordCount do
    begin
      redAirTravel.Lines.Add(qryTravelNow['Username Without Extension']);
      qryTravelNow.Next;
    end;
  End;
end;

procedure TfrmAdmin.btnFindEmployeeClick(Sender: TObject);
begin
  if edtFindEmployee.Text <> '' then
  Begin
    sEmpUsername := edtFindEmployee.Text;

    if EmployeeUsernamePresentInDB(sEmpUsername) = True then
    Begin
      dbEmployees.DataSource := DBTravelNow.dsTravelNow;
      MessageDlg('The employee has been located', mtInformation, mbOKCancel, 0);
      rgpEditEmployee.Enabled := True;
    End
    Else
    Begin
      MessageDlg('This employee does not exist in the database.', mtError, mbOKCancel, 0);
      edtFindEmployee.Clear;
    End;
  End
  Else
  Begin
    MessageDlg('Please enter a valid username.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnHighestAccommodationSaleClick(Sender: TObject);
Var
  rHighest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Max(Accommodation) as [Most Expensive Accommodation Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rHighest := qryTravelNow.FieldByName('Most Expensive Accommodation Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Accommodation as [Most Expensive Accommodation Sale(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Accommodation = ' + FloatToStr(rHighest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Most Expensive Accommodation Sale(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the highest accommodation sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;

        redRevenue.Lines.Add('The usernames of the clients with the highest accommodation sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

procedure TfrmAdmin.btnHighestSaleClick(Sender: TObject);
Var
  rHighest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Max(Total) as [Most Expensive Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rHighest := qryTravelNow.FieldByName('Most Expensive Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Total as [Most Expensive Sale(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Total = ' + FloatToStr(rHighest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Most Expensive Sale(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the highest sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;

        redRevenue.Lines.Add('The usernames of the clients with the highest sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

//SQL Query using diff calc
procedure TfrmAdmin.btnHighestTicketSaleClick(Sender: TObject);
Var
  rHighest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Max(Tickets) as [Most Expensive Ticket Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rHighest := qryTravelNow.FieldByName('Most Expensive Ticket Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Tickets as [Most Expensive Ticket Sales(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Tickets = ' + FloatToStr(rHighest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Most Expensive Ticket Sales(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the highest ticket sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;

        redRevenue.Lines.Add('The usernames of the clients with the highest ticket sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rHighest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

procedure TfrmAdmin.btnLowestAccomSaleClick(Sender: TObject);
Var
  rLowest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Min(Accommodation) as [Least Expensive Accommodation Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.SQL.Add('Where accommodation <> 0');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rLowest := qryTravelNow.FieldByName('Least Expensive Accommodation Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Accommodation as [Least Expensive Accommodation Sale(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Accommodation = ' + FloatToStr(rLowest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Least Expensive Accommodation Sale(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the lowest accommodation sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;
        redRevenue.Lines.Add('The usernames of the clients with the lowest accommodation sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

//SQL Query using diff calc
procedure TfrmAdmin.btnLowestSaleClick(Sender: TObject);
Var
  rLowest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Min(Total) as [Least Expensive Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rLowest := qryTravelNow.FieldByName('Least Expensive Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Total as [Least Expensive Sale(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Total = ' + FloatToStr(rLowest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Least Expensive Sale(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the lowest sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;
        redRevenue.Lines.Add('The usernames of the clients with the lowest sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

procedure TfrmAdmin.btnLowestTicketSaleClick(Sender: TObject);
Var
  rLowest : Real;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Min(Tickets) as [Least Expensive Ticket Sale(s)]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End
    Else
    Begin
      dbRevenue.DataSource := DBTravelNow.dsTravelNow;

      rLowest := qryTravelNow.FieldByName('Least Expensive Ticket Sale(s)').AsFloat;

      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
      qryTravelNow.SQL.Add('Destination, ');
      qryTravelNow.SQL.Add('Tickets as [Least Expensive Ticket Sale(s)], ');
      qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
      qryTravelNow.SQL.Add('From TblSales');
      qryTravelNow.SQL.Add('Where Tickets = ' + FloatToStr(rLowest));
      qryTravelNow.Open;

      dbRevenue.Columns[1].Width := 100;
      dbRevenue.Columns[2].Width := 100;
      TFloatField(qryTravelNow.FieldByName('Least Expensive Ticket Sale(s)')).currency := True;

      redRevenue.Clear;

      if qryTravelNow.RecordCount = 1 then
      Begin
        redRevenue.Lines.Add('The username of the client with the lowest ticket sale: ');
        redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
        redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2));
      End
      Else
      Begin
        qryTravelNow.First;
        redRevenue.Lines.Add('The usernames of the clients with the lowest ticket sales: ');

        for I := 1 to qryTravelNow.RecordCount do
        begin
          redRevenue.Lines.Add(qryTravelNow.FieldByName('Client Username').AsString);
          redRevenue.Lines.Add('With a value of: ' +#13+ FloatToStrF(rLowest, ffCurrency, 6, 2) +#13);
          qryTravelNow.Next;
        end;
      End;
    End;
  End;
end;

procedure TfrmAdmin.btnMostValuableClientClick(Sender: TObject);
Var
  sUsername : String;
  rHighest : Real;
  I: Integer;
begin
  With DBTravelNow do
  Begin
    dbRevenue.DataSource := DBTravelNow.dsTravelNow;

    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select ClientUsername, Sum(Total) As [Total] from TblSales Group By ClientUsername');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End;

    qryTravelNow.First;
    rHighest := dbRevenue.Fields[1].Value;
    sUsername := dbRevenue.Fields[0].Value;

    qryTravelNow.Next;

    for I := 1 to qryTravelNow.RecordCount do
    begin
      if dbRevenue.Fields[1].Value > rHighest then
      Begin
        rHighest := dbRevenue.Fields[1].Value;
        sUsername := dbRevenue.Fields[0].Value;
      End;

      qryTravelNow.Next;
    end;


    redRevenue.Clear;
    redRevenue.Lines.Add('The most valuable client is: ' + sUsername);
    redRevenue.Lines.Add('This client has a total amount of transactions valued at: ' + FloatToStrF(rHighest, ffCurrency, 7, 2));

    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
    qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
    qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
    qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    dbRevenue.Columns[1].Width := 100;
    dbRevenue.Columns[2].Width := 100;
    TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
  End;
end;

//Query involving 2 tables using delphi code
procedure TfrmAdmin.btnSearchForAirlineClick(Sender: TObject);
Var
  sAirline, sAeroplaneIDs : string;
  bPresent : Boolean;
  I: Integer;
begin
  sAirline := InputBox('Display Aeroplanes under Airline','Enter the name of the Airline you would like to search for.','');

  if sAirline <> '' then
  Begin
    With DBTravelNow Do
    Begin
      bPresent := False;
      tblAirline.First;

      for I := 1 to tblAirline.RecordCount do
      begin
        if UpperCase(tblAirline['AirlineName']) = UpperCase(sAirline) then
        Begin
          bPresent := True;
          Break
        End;

        tblAeroplane.Next;
      end;

      if bPresent = True then
      Begin
        tblAeroplane.First;
        sAeroplaneIDs := '';
        sAeroplaneIDs := 'These are the Aeroplanes associated with the Airline ' + sAirline +':' +#13+#13;

        for I := 1 to tblAeroplane.RecordCount do
        Begin
          if UpperCase(sAirline) = UpperCase(tblAeroplane['AirlineName']) then
          Begin
            sAeroplaneIDs := sAeroplaneIDs +  tblAeroplane['AeroplaneID']  +#13;
          End;

          tblAeroplane.Next;
        End;

        MessageDlg(sAeroplaneIDs, mtInformation, mbOKCancel, 0);
      End
      Else
      Begin
        MessageDlg('Unfortunately, The requested Airline is not present in the database.', mtInformation, mbOKCancel, 0);
      End;
    End;
  End
  Else
  Begin
    MessageDlg('The Airline Name is not valid.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnSearchForAnEmployeeClick(Sender: TObject);
Var
  sUsername : String;
begin
  sUsername := InputBox('Search','Please enter the username of the employee you would like to search for.','');

  if EmployeeUsernamePresentInDB(sUsername) = True then
  Begin
    dbEmployees.DataSource := DBTravelNow.dsTravelNow;
    MessageDlg('The employee is present in the database.', mtInformation, mbOKCancel, 0);
  End
  Else
  Begin
    MessageDlg('The employee is not present in the database.', mtInformation, mbOKCancel, 0);
  End;
end;

//Edit selected fields in a record
procedure TfrmAdmin.btnSubmitAirlineDetailsClick(Sender: TObject);
Var
  sChange, sAirline : String;
begin
  if edtAirlineContactDetails.Text <> '' then
  Begin
    sChange := edtAirlineContactDetails.Text;

    if MessageDlg('Would you like to change the email address to: ' +#13+ sChange, mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      sAirline := cmbUpdateAirline.Items[cmbUpdateAirline.ItemIndex];

      With DBTravelNow Do
      Begin
        qryTravelNow.SQL.Clear;
        qryTravelNow.SQL.Add('Update TblAirline');
        qryTravelNow.SQL.Add('Set AirlineEmail = :sChange');
        qryTravelNow.SQL.Add('Where AirlineName = :sAirline');

        with qryTravelNow.Parameters do
        Begin
          ParamByName('sChange').Value := sChange;
          ParamByName('sAirline').Value := sAirline;
        End;

        qryTravelNow.ExecSQL;

        dbAirTravel.DataSource := DBTravelNow.dsTravelNow;

        qryTravelNow.SQL.Clear;
        qryTravelNow.SQL.Add('Select * From TblAirline');
        qryTravelNow.Open;
      End;

      MessageDlg('Airline contact details have been changed successfully.', mtInformation, mbOKCancel, 0);
      btnSubmitAirlineDetails.Enabled := False;
      edtAirlineContactDetails.Clear;
      cmbUpdateAirline.ItemIndex := -1;
    End
    Else
    Begin
      MessageDlg('No changes have been made.', mtInformation, mbOKCancel, 0);
      btnSubmitAirlineDetails.Enabled := False;
      cmbUpdateAirline.ItemIndex := -1;
      edtAirlineContactDetails.Clear;
    End;
  End
  Else
  Begin
    MessageDlg('The contact details you wish to submit is not valid.', mtError, mbOKCancel, 0);
  End;
end;

//Delete a record from table
procedure TfrmAdmin.btnSubmitDeleteClick(Sender: TObject);
Var
  sDeleteUsername : String;
begin
  sDeleteUsername := edtDeleteEmp.Text;

  if sDeleteUsername <> '' then
  Begin
    if EmployeeUsernamePresentInDB(sDeleteUsername) = True then
    Begin
      if MessageDlg('Are you sure you would like to delete Employee ' + sDeleteUsername + ' from the database?', mtConfirmation, mbYesNo, 0) = mrYes then
      Begin
        dbEmployees.DataSource := DBTravelNow.dsTravelNow;

        With DBTravelNow Do
        Begin
          qryTravelNow.SQL.Clear;
          qryTravelNow.SQL.Add('Delete from TblEmployee');
          qryTravelNow.SQL.Add('Where Username = ' +QuotedStr(sDeleteUsername));
          qryTravelNow.ExecSQL;

          qryTravelNow.SQL.Clear;
          qryTravelNow.SQL.Add('Select * From TblEmployee');
          qryTravelNow.Open;
        End;

        MessageDlg('The Employee has been deleted successfully.', mtInformation, mbOKCancel,0);
        edtDeleteEmp.Clear;
        btnSubmitDelete.Enabled := False;
      End
      Else
      Begin
        MessageDlg('The Employee has not been deleted.', mtInformation, mbOKCancel, 0);
        edtDeleteEmp.Clear;
        btnSubmitDelete.Enabled := False;
      End;
    End
    Else
    Begin
      MessageDlg('This username does not exist in the database.', mtError, mbOKCancel, 0);
      edtDeleteEmp.Clear;
      btnSubmitDelete.Enabled := False;
    End;
  End
  Else
  Begin
    MessageDlg('The username that you have inputted is not valid.', mtError, mbOKCancel, 0);
    btnSubmitDelete.Enabled := False;
  End;
end;

//Insert record
procedure TfrmAdmin.btnSubmitEmployeeClick(Sender: TObject);
Var
  sName, sSurname, sPassword, sUsername : String;
begin
  if (edtName.Text <> '') and (edtSurname.Text <> '') and (edtPassword.Text <> '') and (edtUsername.Text <> '') then
  Begin
    sName := edtName.Text;
    sSurname := edtSurname.Text;
    sPassword := edtPassword.Text;
    sUsername := edtUsername.Text;

    if MessageDlg('Can you confirm that you would like to add the following employee to the database: ' +#13+
                  'Name: ' + sName +#13+ 'Surname: ' + sSurname +#13+ 'Username: ' + sUsername +#13+ 'Password: ' +sPassword, mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      if EmployeeUsernamePresentInDB(sUsername) = False then
      Begin
        With DBTravelNow Do
        Begin
          qryTravelNow.SQL.Clear;
          qryTravelNow.SQL.Add('Insert into TblEmployee ');
          qryTravelNow.SQL.Add('(Username, EmployeeName, EmployeeSurname, [Password]) ');
          qryTravelNow.SQL.Add('Values (:Username, :EmpName, :EmpSurname, :Password)');

          With qryTravelNow.Parameters Do
          Begin
            ParamByName('Username').Value := sUsername;
            ParamByName('EmpName').Value := sName;
            ParamByName('EmpSurname').Value := sSurname;
            ParamByName('Password').Value := sPassword;
          End;

          qryTravelNow.ExecSQL;

          dbEmployees.DataSource := DBTravelNow.dsTravelNow;

          qryTravelNow.SQL.Clear;
          qryTravelNow.SQL.Add('Select * From TblEmployee');
          qryTravelNow.Open;
        End;

        MessageDlg('The Employee has been added successfully.', mtInformation, mbOKCancel, 0);
        edtName.Text := '';
        edtSurname.Text := '';
        edtPassword.Text := '';
        edtUsername.Text := '';
        btnSubmitEmployee.Enabled := False;
      End
      Else
      Begin
        MessageDlg('This username is already present in the database. Please enter another.', mtError, mbOKCancel, 0);
        edtUsername.Clear;
        edtUsername.SetFocus;
      End;
    End
    Else
    Begin
      MessageDlg('The Employee has not been added.', mtInformation, mbOKCancel, 0);
      edtName.Text := '';
      edtSurname.Text := '';
      edtPassword.Text := '';
      edtUsername.Text := '';
      btnSubmitEmployee.Enabled := False;
    End;
  End
  Else
  Begin
    MessageDlg('Please make sure all field are filled out.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmAdmin.btnTotalAccomRevenueClick(Sender: TObject);
Var
  rTotal : Real;
begin
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  rTotal := GetTotalSumFromTblSales('Accommodation');

  redRevenue.Lines.Clear;
  redRevenue.Lines.Add('Total accommodation revenue generated by the business: ' +#13+ FloatToStrF(rTotal, ffCurrency, 7, 2));
end;

procedure TfrmAdmin.btnTotalRevenueClick(Sender: TObject);
Var
  rTotal : Real;
begin
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  rTotal := GetTotalSumFromTblSales('Total');

  redRevenue.Lines.Clear;
  redRevenue.Lines.Add('Total revenue generated by the business: ' +#13+ FloatToStrF(rTotal, ffCurrency, 7, 2));
end;

procedure TfrmAdmin.btnTotalTicketRevenueClick(Sender: TObject);
Var
  rTotal : Real;
begin
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  rTotal := GetTotalSumFromTblSales('Tickets');

  redRevenue.Lines.Clear;
  redRevenue.Lines.Add('Total ticket revenue generated by the business: ' +#13+ FloatToStrF(rTotal, ffCurrency, 7, 2));
end;

procedure TfrmAdmin.cmbUpdateAirlineClick(Sender: TObject);
Var
  sAirline : String;
begin
  if cmbUpdateAirline.ItemIndex <> -1 then
  Begin
    sAirline := cmbUpdateAirline.Items[cmbUpdateAirline.ItemIndex];

    if MessageDlg('Are you sure you would like to change the details for the Airline named ' + sAirline, mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      btnSubmitAirlineDetails.Enabled := True;
    End
    Else
    Begin
      cmbUpdateAirline.ItemIndex := -1;
      MessageDlg('No changes have been made.', mtInformation, mbOKCancel, 0);
    End;
  End;
end;

//Searches for data in table
function TfrmAdmin.EmployeeUsernamePresentInDB(sUsername : String): Boolean;
Var
  bPresent : Boolean;
  I: Integer;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Username from TblEmployee');
    qryTravelNow.Open;

    qryTravelNow.First;
    bPresent := False;

    for I := 1 to qryTravelNow.RecordCount do
    begin
      if UpperCase(qryTravelNow['Username']) = UpperCase(sUsername) then
      Begin
        bPresent := True;
        Break
      End;

      qryTravelNow.Next;
    end;
  End;

  Result := bPresent;
end;

procedure TfrmAdmin.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  SetAsMainForm(frmAdmin);

  With DBTravelNow Do
  Begin
    cmbUpdateAirline.Items.Clear;
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select AirlineName From TblAirline');
    qryTravelNow.Open;

    qryTravelNow.First;

    for I := 1 to qryTravelNow.RecordCount do
    begin
      cmbUpdateAirline.Items.Add(qryTravelNow['AirlineName']);
      qryTravelNow.Next;
    end;
  End;
end;

//Function that returns total for a field in TblSales
function TfrmAdmin.GetTotalSumFromTblSales(sFieldName: String): Real;
Var
  rTotal : Real;
begin
  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select Sum('+sFieldName+') as [Total Revenue]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    if qryTravelNow.RecordCount = 0 then
    Begin
      MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
    End;

    rTotal := dbRevenue.Fields[0].Value;

    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
    qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
    qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
    qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
    qryTravelNow.SQL.Add('From TblSales');
    qryTravelNow.Open;

    dbRevenue.Columns[1].Width := 100;
    dbRevenue.Columns[2].Width := 100;
    TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
    TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

    Result := rTotal;
  End;
end;

//Edits selected fields in record
procedure TfrmAdmin.rgpEditEmployeeClick(Sender: TObject);
Var
  iIndex : Integer;
  sChange : String;
begin
  iIndex := rgpEditEmployee.ItemIndex;
  dbEmployees.DataSource := DBTravelNow.dsTravelNow;

  case iIndex of
    0 : Begin
          sChange := InputBox('Edit Employee', 'Please enter the change of Name', '');

          if sChange <> '' then
          Begin
            if MessageDlg('Are you sure you want to change the employees name to ' + sChange +'?', mtConfirmation, mbYesNo, 0) = mrYes then
            Begin
              With DBTravelNow Do
              Begin
                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Update TblEmployee');
                qryTravelNow.SQL.Add('Set EmployeeName = :sChange');
                qryTravelNow.SQL.Add('Where Username = :sUsername');

                With qryTravelNow.Parameters do
                Begin
                  ParamByName('sChange').Value := sChange;
                  ParamByName('sUsername').Value := sEmpUsername;
                End;

                qryTravelNow.ExecSQL;

                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Select * From TblEmployee');
                qryTravelNow.Open;
              End;

              MessageDlg('The Employee name has been changed successfully.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End
            Else
            Begin
              MessageDlg('No changes have been made.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End;
          End
          Else
          Begin
            MessageDlg('The change you have submitted is not valid. No changes have been made', mtError, mbOKCancel, 0);
            rgpEditEmployee.ItemIndex := -1;
            rgpEditEmployee.Enabled := False;
            edtFindEmployee.Clear;
          End;
        End;
    1 : Begin
          sChange := InputBox('Edit Employee', 'Please enter the change of Surname', '');

          if sChange <> '' then
          Begin
            if MessageDlg('Are you sure you want to change the employees surname to ' + sChange +'?', mtConfirmation, mbYesNo, 0) = mrYes then
            Begin
              With DBTravelNow Do
              Begin
                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Update TblEmployee');
                qryTravelNow.SQL.Add('Set EmployeeSurname = :sChange');
                qryTravelNow.SQL.Add('Where Username = :sUsername');

                With qryTravelNow.Parameters do
                Begin
                  ParamByName('sChange').Value := sChange;
                  ParamByName('sUsername').Value := sEmpUsername;
                End;

                qryTravelNow.ExecSQL;

                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Select * From TblEmployee');
                qryTravelNow.Open;
              End;

              MessageDlg('The Employee surname has been changed successfully.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End
            Else
            Begin
              MessageDlg('No changes have been made.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End;
          End
          Else
          Begin
            MessageDlg('The change you have submitted is not valid. No changes have been made', mtError, mbOKCancel, 0);
            rgpEditEmployee.ItemIndex := -1;
            rgpEditEmployee.Enabled := False;
            edtFindEmployee.Clear;
          End;
        End;
    2 : Begin
          sChange := InputBox('Edit Employee', 'Please enter the change of Password', '');

          if sChange <> '' then
          Begin
            if MessageDlg('Are you sure you want to change the employees password to ' + sChange +'?', mtConfirmation, mbYesNo, 0) = mrYes then
            Begin
              With DBTravelNow Do
              Begin
                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Update TblEmployee');
                qryTravelNow.SQL.Add('Set [Password] = :sChange');
                qryTravelNow.SQL.Add('Where Username = :sUsername');

                With qryTravelNow.Parameters do
                Begin
                  ParamByName('sChange').Value := sChange;
                  ParamByName('sUsername').Value := sEmpUsername;
                End;

                qryTravelNow.ExecSQL;

                qryTravelNow.SQL.Clear;
                qryTravelNow.SQL.Add('Select * From TblEmployee');
                qryTravelNow.Open;
              End;

              MessageDlg('The Employee password has been changed successfully.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End
            Else
            Begin
              MessageDlg('No changes have been made.', mtInformation, mbOKCancel, 0);
              rgpEditEmployee.ItemIndex := -1;
              rgpEditEmployee.Enabled := False;
              edtFindEmployee.Clear;
            End;
          End
          Else
          Begin
            MessageDlg('The change you have submitted is not valid. No changes have been made', mtError, mbOKCancel, 0);
            rgpEditEmployee.ItemIndex := -1;
            rgpEditEmployee.Enabled := False;
            edtFindEmployee.Clear;
          End;
        End;
  end;
end;

procedure TfrmAdmin.rgpFilterRecordsClick(Sender: TObject);
Var
  iIndex : Integer;
begin
  iIndex := rgpFilterRecords.ItemIndex;
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  case iIndex of
    0 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Where SpecialOffer = True');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;
        End;
    1 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Where SpecialOffer = False');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;
        End;
    2 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Where Total > 100000');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;
        End;
    3 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Where Total <= 100000');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;
        End;
    4 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;

          rgpFilterRecords.ItemIndex := -1;
        End;
  end;
end;

procedure TfrmAdmin.rgpGroupClick(Sender: TObject);
Var
  iIndex : Integer;
begin
  iIndex := rgpGroup.ItemIndex;
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  case iIndex of
    0 : begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Sum(Tickets) As [Total Tickets Cost] ');
            qryTravelNow.SQL.Add('From TblSales Group By ClientUsername');
            qryTravelNow.Open;

            dbRevenue.Columns[0].Width := 100;
            //TFloatField(qryTravelNow.FieldByName('[Total Tickets Cost]')).currency := True;
            TFloatField(qryTravelNow.Fields[1]).currency := True;
          End;
        end;
    1 : begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Sum(Accommodation) As [Total Accommodation Cost] ');
            qryTravelNow.SQL.Add('From TblSales Group By ClientUsername');
            qryTravelNow.Open;

            dbRevenue.Columns[0].Width := 100;
            TFloatField(qryTravelNow.Fields[1]).currency := True;
            //TFloatField(qryTravelNow.FieldByName('[Total Accommodation Cost]')).currency := True;
          End;
        end;
    2 : begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Sum(Total) As [Total Trip Cost] ');
            qryTravelNow.SQL.Add('From TblSales Group By ClientUsername');
            qryTravelNow.Open;

            dbRevenue.Columns[0].Width := 100;
            TFloatField(qryTravelNow.Fields[1]).currency := True;
            //TFloatField(qryTravelNow.FieldByName('[Total Trip Cost]')).currency := True;
          End;
        end;
    3 : begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;
          End;

          rgpGroup.ItemIndex := -1;
        end;
  end;
end;

//Sorts records in table
procedure TfrmAdmin.rgpSortClick(Sender: TObject);
Var
  iIndex : Integer;
begin
  iIndex := rgpSort.ItemIndex;
  dbRevenue.DataSource := DBTravelNow.dsTravelNow;

  case iIndex of
    0 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order by ClientUsername ASC');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    1 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order by ClientUsername DESC');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    2 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order by TransactionID ASC');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    3 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order by TransactionID DESC');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    4 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Tickets Asc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    5 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Tickets Desc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    6 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Accommodation Asc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    7 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Accommodation Desc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    8 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Total Asc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    9 : Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.SQL.Add('Order By Total Asc');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;
        End;
    10 :Begin
          With DBTravelNow Do
          Begin
            qryTravelNow.SQL.Clear;
            qryTravelNow.SQL.Add('Select TransactionId As [Transaction ID], ClientUsername As [Client Username], ');
            qryTravelNow.SQL.Add('Destination, Accommodation As [Cost of Accommodation], ');
            qryTravelNow.SQL.Add('Tickets as [Cost of Tickets], Total As [Total], ');
            qryTravelNow.SQL.Add('SpecialOffer AS [Special Offer]');
            qryTravelNow.SQL.Add('From TblSales');
            qryTravelNow.Open;

            dbRevenue.Columns[1].Width := 100;
            dbRevenue.Columns[2].Width := 100;
            TFloatField(qryTravelNow.FieldByName('Cost of Accommodation')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Cost of Tickets')).currency := True;
            TFloatField(qryTravelNow.FieldByName('Total')).currency := True;

            if qryTravelNow.RecordCount = 0 then
            Begin
              MessageDlg('No records have been recorded.', mtInformation, mbOKCancel, 0);
            End;
          End;

          rgpSort.ItemIndex := -1;
        End;
  end;
end;

procedure TfrmAdmin.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
