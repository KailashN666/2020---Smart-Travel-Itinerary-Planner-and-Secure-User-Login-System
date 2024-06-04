unit Employee_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FunctionsAndProcedures_u, BookDestination_u, TravelNowDB_u, ExtCtrls, StdCtrls, ComCtrls, Aeroplane_u,
  Spin, jpeg;

type
  TfrmEmployee = class(TForm)
    pcEmployee: TPageControl;
    tsProfile: TTabSheet;
    lblUsername: TLabel;
    lblName: TLabel;
    lblSurname: TLabel;
    pnlSurname: TPanel;
    pnlName: TPanel;
    pnlUsername: TPanel;
    tsNotifications: TTabSheet;
    cmbNotifications: TComboBox;
    redDetails: TRichEdit;
    grpDecision: TGroupBox;
    btnApprove: TButton;
    btnDecline: TButton;
    tsBookings: TTabSheet;
    grpSpecialOffers: TGroupBox;
    lblCurrentSpecialOffers: TLabel;
    lblChangeSpecialOffer: TLabel;
    btnSubmitChange: TButton;
    cmbCurrentSpecialOffers: TComboBox;
    cmbChangeSpecialOffers: TComboBox;
    grpPlaneDetails: TGroupBox;
    lblAeroplaneID: TLabel;
    lblAirlineName: TLabel;
    lblNumSeatsAvail: TLabel;
    lblDepartureLocation: TLabel;
    lblDepartureDate: TLabel;
    pnlAeroplaneID: TPanel;
    pnlDepartureDate: TPanel;
    pnlDepartureLocation: TPanel;
    pnlNumSeatsAvail: TPanel;
    pnlAirlineName: TPanel;
    lblGetDetailsOfThePlaneTravellingTo: TLabel;
    cmbCity: TComboBox;
    lblUpdateDepartureLocation: TLabel;
    lblUpdateNumSeatsAvail: TLabel;
    lblUpdateDepartureDate: TLabel;
    btnChangeDepartureDate: TButton;
    btnChangeDepartureLocation: TButton;
    btnChangeNumSeatsAvail: TButton;
    dtpChangeDepartureDate: TDateTimePicker;
    cmbChangeDepartureLocation: TComboBox;
    spnChangeNumSeatsAvail: TSpinEdit;
    grpTicketDetails: TGroupBox;
    cmbTicketDestination: TComboBox;
    lblCostOfOneTicket: TLabel;
    pnlTicketCost: TPanel;
    btnChangeTicketCost: TButton;
    grpBookForClient: TGroupBox;
    lblClientUsername: TLabel;
    edtClientUsername: TEdit;
    btnBookForClient: TButton;
    btnCloseProgram: TButton;
    imgNotifications: TImage;
    imgProfile: TImage;
    procedure FormActivate(Sender: TObject);
    Procedure PopulateNotifications;
    procedure cmbNotificationsClick(Sender: TObject);
    procedure btnApproveClick(Sender: TObject);
    Procedure AddToClientHistory(sStatus : String);
    Procedure MakeChangeToClient (sStatus : String);
    Procedure AddToClientNotifications (sStatus : String);
    Procedure GetPlaneDetails (sCity : String);
    procedure btnDeclineClick(Sender: TObject);
    Procedure PopulateSpecialOffers;
    procedure btnSubmitChangeClick(Sender: TObject);
    procedure cmbCityClick(Sender: TObject);
    procedure btnChangeDepartureDateClick(Sender: TObject);
    Procedure ResetPlaneDetails;
    procedure btnChangeDepartureLocationClick(Sender: TObject);
    procedure btnChangeNumSeatsAvailClick(Sender: TObject);
    procedure cmbTicketDestinationClick(Sender: TObject);
    procedure btnChangeTicketCostClick(Sender: TObject);
    procedure btnBookForClientClick(Sender: TObject);
    procedure btnCloseProgramClick(Sender: TObject);
    Procedure SetAsMainForm(aForm : TForm);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmployee: TfrmEmployee;
  sUsername : String;
  iIndex, iCountChangeIndex : Integer;
  sClientUsername, sClientDatabaseField, sChange, sCity, sTicketDestination : String;
  ArrSpecialOffers : Array [1..2, 1..5] of String;
  ObjAeroplane : TAeroplane;
  rTicketCost : Real;
implementation

{$R *.dfm}

{If a textfile already exists, I want the recent
history/notifications to be right at the top of the
textfile, this acounts for the
use of a temporary datafile in all instances}

{This adds to the client's history - it adds whether
the change they have submitted is successful or not}

procedure TfrmEmployee.AddToClientHistory(sStatus: String);
Var
  DataFile, TempDataFile : TextFile;
  sLine : String;
begin
  if sStatus = 'Approved' then
  Begin
    AssignFile(DataFile, sClientUsername+' History.txt');
    if FileExists(sClientUsername+' History.txt') then
    Begin
      Reset(DataFile);

      AssignFile(TempDataFile, 'Temporary.txt');
      Rewrite(TempDataFile);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);
        Writeln(TempDataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      Rewrite(DataFile);
      Writeln(DataFile, 'History');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been approved');
      Writeln(DataFile, #13+#13);

      Reset(TempDataFile);

      while not eof(TempDataFile) do
      Begin
        Readln(TempDataFile, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      DeleteFile('Temporary.txt');

    End
    Else
    Begin
      Rewrite(DataFile);

      Writeln(DataFile, 'History');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been approved');
      Writeln(DataFile, #13+#13);

      CloseFile(DataFile);
    End;
  End
  Else
  Begin
    AssignFile(DataFile, sClientUsername+' History.txt');
    if FileExists(sClientUsername+' History.txt') then
    Begin
      Reset(DataFile);

      AssignFile(TempDataFile, 'Temporary.txt');
      Rewrite(TempDataFile);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);
        Writeln(TempDataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      Rewrite(DataFile);
      Writeln(DataFile, 'History');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changing ' + sClientDatabaseField + ' to: ' + sChange + ' was not successful.');
      Writeln(DataFile, 'Your change has not approved');
      Writeln(DataFile, #13+#13);

      Reset(TempDataFile);

      while not eof(TempDataFile) do
      Begin
        Readln(TempDataFile, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      DeleteFile('Temporary.txt');

    End
    Else
    Begin
      Rewrite(DataFile);

      Writeln(DataFile, 'History');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changing ' + sClientDatabaseField + ' to: ' + sChange + ' was not successful.');
      Writeln(DataFile, 'Your change has not approved');
      Writeln(DataFile, #13+#13);

      CloseFile(DataFile);
    End;
  End;
end;

{Adds to the client's notifcations whether their change was
successful or not}

procedure TfrmEmployee.AddToClientNotifications(sStatus: String);
Var
  DataFile, TempDataFile : TextFile;
  sLine : String;
begin
  if sStatus = 'Approved' then
  Begin
    AssignFile(DataFile, sClientUsername+' Notifications.txt');
    if FileExists(sClientUsername+' Notifications.txt') then
    Begin
      Reset(DataFile);

      AssignFile(TempDataFile, 'Temporary.txt');
      Rewrite(TempDataFile);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);
        Writeln(TempDataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      Rewrite(DataFile);

      Writeln(DataFile, 'Notification');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been approved by ' + pnlName.Caption + '.');

      Reset(TempDataFile);

      while not eof(TempDataFile) do
      Begin
        Readln(TempDataFile, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      DeleteFile('Temporary.txt');

    End
    Else
    Begin
      Rewrite(DataFile);

      Writeln(DataFile, 'Notification');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been approved by ' + pnlName.Caption + '.');

      CloseFile(DataFile);
    End;
  End
  Else
  Begin
    AssignFile(DataFile, sClientUsername+' Notifications.txt');
    if FileExists(sClientUsername+' Notifications.txt') then
    Begin
      Reset(DataFile);

      AssignFile(TempDataFile, 'Temporary.txt');
      Rewrite(TempDataFile);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);
        Writeln(TempDataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      Rewrite(DataFile);

      Writeln(DataFile, 'Notification');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been declined by ' + pnlName.Caption + '.');

      Reset(TempDataFile);

      while not eof(TempDataFile) do
      Begin
        Readln(TempDataFile, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(DataFile);
      CloseFile(TempDataFile);

      DeleteFile('Temporary.txt');

    End
    Else
    Begin
      Rewrite(DataFile);

      Writeln(DataFile, 'Notification');
      Writeln(DataFile, 'You submitted a change');
      Writeln(DataFile, DateToStr(Date));
      Writeln(DataFile,'Changed ' + sClientDatabaseField + ' to: ' + sChange);
      Writeln(DataFile, 'Your change has been declined by ' + pnlName.Caption + '.');

      CloseFile(DataFile);
    End;
  End;
end;

procedure TfrmEmployee.btnApproveClick(Sender: TObject);
var
  I: Integer;
  sLine : String;
  Temp, DataFile : TextFile;
begin
  if MessageDlg('Are you sure you would like to approve this change?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    MakeChangeToClient('Approve');
  End
  Else
  Begin
    MessageDlg('Please ensure that you are certain about your decisions.', mtWarning, mbOKCancel, 0);
  End;
end;

procedure TfrmEmployee.btnBookForClientClick(Sender: TObject);
Var
  sClientUsername : String;
begin
  sClientUsername := edtClientUsername.Text;

  if sClientUsername <> '' then
  Begin
    if frmFunctionsAndProcedures.CheckUsernameInClientDB(sClientUsername) = True then
    Begin
      if MessageDlg('Would you like to book for ' + sClientUsername + '?', mtConfirmation, mbYesNo, 0) = mrYes then
      Begin
        FunctionsAndProcedures_u.sClientUsername := sClientUsername;
        FunctionsAndProcedures_u.bSpecialOffer := False;
        frmBookDestination.Show;
        frmEmployee.Hide;
      End
      Else
      Begin
        edtClientUsername.Clear;
      End;
    End
    Else
    Begin
      MessageDlg('This username does not exist in the client database.', mtError, mbOKCancel, 0);
    End;
  End
  Else
  Begin
    MessageDlg('Please enter a valid username.', mtError, mbOKCancel,0);
  End;
end;

procedure TfrmEmployee.btnChangeDepartureDateClick(Sender: TObject);
Var
  dUpdateDepartDate : TDateTime;
begin
  if MessageDlg('Are you sure you you want to change the current departure date from ' + ObjAeroplane.GetDepartureDate
                 + ' to ' + FormatDateTime('dd mmmm yyyy', dtpChangeDepartureDate.Date) + ' ?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    dUpdateDepartDate := dtpChangeDepartureDate.Date;
    ObjAeroplane.ChangeDepartureDate(dUpdateDepartDate);
    ObjAeroplane.UpdateDepartureDate;
    MessageDlg('Departure Date has been updated.', mtInformation, mbOKCancel, 0);
    ResetPlaneDetails;
  End
  Else
  Begin
    MessageDlg('Departure date has not been updated.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmEmployee.btnChangeDepartureLocationClick(Sender: TObject);
Var
  sUpdateDepartureLoc : String;
begin
  if MessageDlg('Are you sure you you want to change the current departure location from ' + ObjAeroplane.GetDepartureLocation
                 + ' to ' + cmbChangeDepartureLocation.Items[cmbChangeDepartureLocation.ItemIndex] + ' ?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    sUpdateDepartureLoc := cmbChangeDepartureLocation.Items[cmbChangeDepartureLocation.ItemIndex];
    ObjAeroplane.ChangeDepartureLocation(sUpdateDepartureLoc);
    ObjAeroplane.UpdateDepartureLocation;
    MessageDlg('Departure Location has been updated.', mtInformation, mbOKCancel, 0);
    ResetPlaneDetails;
  End
  Else
  Begin
    MessageDlg('Departure Location has not been updated.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmEmployee.btnChangeNumSeatsAvailClick(Sender: TObject);
Var
  iNumSeatsAvail : Integer;
begin
  iNumSeatsAvail := spnChangeNumSeatsAvail.Value;

  if MessageDlg('Are you sure you you want to change the current number of seats available from ' + IntToStr(ObjAeroplane.GetNumSeatsAvail)
                 + ' to ' + IntToStr(iNumSeatsAvail) + ' ?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    ObjAeroplane.ChangeNumSeatsAvail(iNumSeatsAvail);
    ObjAeroplane.UpdateSeatsAvail;
    MessageDlg('Number of seats available has been updated.', mtInformation, mbOKCancel, 0);
    ResetPlaneDetails;
  End
  Else
  Begin
    MessageDlg('Number of seats available has not been updated.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmEmployee.btnChangeTicketCostClick(Sender: TObject);
Var
  sChangeCost : String;
  rChangeCost : Real;
  bValid : Boolean;
  I: Integer;
begin
  if cmbTicketDestination.ItemIndex <> -1 then
  Begin
    sChangeCost := InputBox('Changing ticket cost', 'What would you like to change the ticket price to?', '');

    bValid := True;

    for I := 1 to Length(sChangeCost) do
    begin
      if not(sChangeCost[I] in ['0'..'9']) then
      Begin
        bValid := False;
      End;
    end;

    if bValid = False then
    Begin
      MessageDlg('You have entered an incorrect value!', mtError, mbOKCancel, 0);
      pnlTicketCost.Caption := '';
      cmbTicketDestination.ItemIndex := -1;
    End
    Else
    Begin
      rChangeCost := StrToFloat(sChangeCost);

      if MessageDlg('Are you sure you want to change the cost to ' + FloatToStrF(rChangeCost, ffCurrency, 7, 2) + ' ?', mtConfirmation, mbYesNo, 0) = mrYes then
      Begin
        With DBTravelNow Do
        Begin
          qryTravelNow.SQL.Clear;
          qryTravelNow.SQL.Add('Update TblDestination');
          qryTravelNow.SQL.Add('Set CostPerTicket = :rChangeCost');
          qryTravelNow.SQL.Add('Where City = :sCity');

          With qryTravelNow.Parameters Do
          Begin
            ParamByName('rChangeCost').Value := rChangeCost;
            ParamByName('sCity').Value := sTicketDestination;
          End;

          qryTravelNow.ExecSQL;
        End;

        MessageDlg('Ticket cost updated.', mtInformation, mbOKCancel, 0);
        pnlTicketCost.Caption := '';
        cmbTicketDestination.ItemIndex := -1;
      End
      Else
      Begin
        MessageDlg('No changes made.', mtInformation, mbOKCancel, 0);
        pnlTicketCost.Caption := '';
        cmbTicketDestination.ItemIndex := -1;
      End;
    End;
  End
  Else
  Begin
    MessageDlg('Please select a city.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmEmployee.btnCloseProgramClick(Sender: TObject);
begin
  if MessageDlg('Would you like to close the program?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    Application.Terminate;
  End;
end;

procedure TfrmEmployee.btnDeclineClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you would like to Decline this change?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    MakeChangeToClient('Decline');
  End
  Else
  Begin
    MessageDlg('Please ensure that you are certain about your decisions.', mtWarning, mbOKCancel, 0);
  End;
end;

{The employee is allowed to change the destinations that
are on special and are being displayed on the client screen
The textfile that has the names of the destinations that are
on special is altered}

procedure TfrmEmployee.btnSubmitChangeClick(Sender: TObject);
Var
  iChangeIndex : Integer;
  iCurrentIndex : Integer;
  DataFile : TextFile;
  I: Integer;
begin
  if (cmbCurrentSpecialOffers.ItemIndex <> -1) and (cmbChangeSpecialOffers.ItemIndex <> -1) then
  Begin
    if MessageDlg('Are you sure you want to change the destination ' + cmbCurrentSpecialOffers.Items[cmbCurrentSpecialOffers.ItemIndex] +
                 ' currently on special to ' + cmbChangeSpecialOffers.Items[cmbChangeSpecialOffers.ItemIndex], mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      iChangeIndex := cmbChangeSpecialOffers.ItemIndex;
      iChangeIndex := iChangeIndex + 1;
      iCurrentIndex := cmbCurrentSpecialOffers.ItemIndex;
      iCurrentIndex := iCurrentIndex + 1;

      ArrSpecialOffers[1,iCurrentIndex] := ArrSpecialOffers[2, iChangeIndex];
      AssignFile(DataFile,'SpecialOffer.txt');

      if FileExists('SpecialOffer.txt') then
      Begin
        Rewrite(DataFile);

        for I := 1 to 5 do
        begin
          Writeln(DataFile, ArrSpecialOffers[1, I]);
        end;

        CloseFile(DataFile);
      End;

      MessageDlg('Changes have been made successfully.', mtInformation, mbOKCancel, 0);
      PopulateSpecialOffers;
    End
    Else
    Begin
      MessageDlg('Changes have not been made.', mtInformation, mbOKCancel, 0);
    End;
  End
  Else
  Begin
    MessageDlg('Please select a change before you submit it.', mtWarning, mbOKCancel, 0);
  End;
end;

{When a city is selected, the details of the plane
travelling to that city is displayed}

procedure TfrmEmployee.cmbCityClick(Sender: TObject);
begin
  sCity := cmbCity.Items[cmbCity.ItemIndex];
  GetPlaneDetails(sCity);
end;

{Gets the cost of a ticket for a selected destination}

procedure TfrmEmployee.cmbTicketDestinationClick(Sender: TObject);
begin
  sTicketDestination := cmbTicketDestination.Items[cmbTicketDestination.ItemIndex];

  With DBTravelNow Do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select CostPerTicket From TblDestination');
    qryTravelNow.SQL.Add('Where City = ' + QuotedStr(sTicketDestination));
    qryTravelNow.Open;

    rTicketCost := qryTravelNow['CostPerTicket'];
    pnlTicketCost.Caption := FloatToStrF(rTicketCost, ffCurrency, 6, 2);
  End;
end;

{iIndex is a global variable that will be used when
the employee wishes to approve or decline a certain notification.
iIndex gets its value from here - when the cmbNotifications is
clicked.}

{When the combobox that is populated with notifications is clicked,
iIndex is also used to populate the RichEdit display with the
details of the notification that the employee has selected}

procedure TfrmEmployee.cmbNotificationsClick(Sender: TObject);
Var
  I : Integer;
  DataFile : TextFile;
  sLine : String;
begin
  iIndex := StrToInt(Copy(cmbNotifications.Text, 1,1));
  iCountChangeIndex := 0;

  redDetails.Lines.Clear;

  AssignFile(DataFile, 'EmployeeNotifications.txt');

  if FileExists('EmployeeNotifications.txt') then
  Begin
    Reset(DataFile);

    while not eof(DataFile) do
    Begin
      Readln(DataFile, sLine);

      if sLine = 'Change' then
      Begin
        Inc(iCountChangeIndex);

        if iCountChangeIndex = iIndex then
        Begin
          redDetails.Lines.Add('A client would like to submit a change.');

          Readln(DataFile, sLine);
          sClientUsername := sLine;
          redDetails.Lines.Add('Username: ' + sClientUsername);

          Readln(DataFile, sLine);
          sClientDatabaseField := sLine;
          redDetails.Lines.Add('Field in client database to be changed: ' + sClientDatabaseField);

          Readln(DataFile, sLine);
          sChange := sLine;
          redDetails.Lines.Add('The change the client would like to submit: ' + sChange);

          redDetails.Lines.Add('Can you confirm this change?');

          btnApprove.Enabled := True;
          btnDecline.Enabled := True;
        End
        Else
        Begin
          for I := 1 to 3 do
          begin
            Readln(DataFile, sLine);
          end;
        End;
      End;
    End;

    CloseFile(DataFile);
  End
end;

procedure TfrmEmployee.FormActivate(Sender: TObject);
var
  I: Integer;
begin
  SetAsMainForm(frmEmployee);

  sUsername := FunctionsAndProcedures_u.sEmployeeUsername;

  pnlUsername.Caption := sUsername;

  {The employee's username is extracted from another form when the
  program transitions from the employee login form to the employee form.
  The employee's profile is built from the employee table based on the
  stored username - as this username is the username of the employee that is
  currently using the program.}

  With DBTravelNow Do
  Begin
    tblEmployee.Open;
    tblEmployee.First;

    for I := 1 to tblEmployee.RecordCount do
    begin
      if UpperCase(sUsername) = Uppercase(tblEmployee['Username']) then
      Begin
        pnlName.Caption := tblEmployee['EmployeeName'];
        pnlSurname.Caption := tblEmployee['EmployeeSurname'];
        Break;
      End;
      tblEmployee.Next;
    end;

    tblEmployee.Close;
  End;

  PopulateNotifications;
  PopulateSpecialOffers;
end;

{Object is used in conjunction with the Plane Class to
display the details and make changes to the planes}

procedure TfrmEmployee.GetPlaneDetails(sCity: String);
begin
  ObjAeroplane := TAeroplane.Create(sCity);
  pnlAeroplaneID.Caption := ObjAeroplane.GetAeroplaneID;
  pnlAirlineName.Caption := ObjAeroplane.GetAirlineName;
  pnlNumSeatsAvail.Caption := IntToStr(ObjAeroplane.GetNumSeatsAvail);
  pnlDepartureLocation.Caption := ObjAeroplane.GetDepartureLocation;
  pnlDepartureDate.Caption := ObjAeroplane.GetDepartureDate;

  dtpChangeDepartureDate.MinDate := Date;

  spnChangeNumSeatsAvail.MaxValue := ObjAeroplane.GetNumSeatsAvail;
  spnChangeNumSeatsAvail.Value := spnChangeNumSeatsAvail.MaxValue;

  if ObjAeroplane.GetDepartureLocation = 'King Shaka Airport' then
  Begin
    cmbChangeDepartureLocation.Items.Clear;
    cmbChangeDepartureLocation.Items.Add('O.R Tambo International');
  End
  Else
  Begin
    cmbChangeDepartureLocation.Items.Clear;
    cmbChangeDepartureLocation.Items.Add('King Shaka Airport');
  End;

  btnChangeDepartureDate.Enabled := True;
  btnChangeDepartureLocation.Enabled := True;
  btnChangeNumSeatsAvail.Enabled := True;
  spnChangeNumSeatsAvail.Enabled := True;

  if ObjAeroplane.GetDate < Date then
  Begin
    btnChangeNumSeatsAvail.Enabled := False;
    spnChangeNumSeatsAvail.Enabled := False;
    spnChangeNumSeatsAvail.Value := 0;

    ObjAeroplane.ResetNumseatsAvail;
    ObjAeroplane.UpdateSeatsAvail;
    pnlNumSeatsAvail.Caption := IntToStr(ObjAeroplane.GetNumSeatsAvail);
    spnChangeNumSeatsAvail.MaxValue := ObjAeroplane.GetNumSeatsAvail;
    spnChangeNumSeatsAvail.Value := spnChangeNumSeatsAvail.MaxValue;

    MessageDlg('This flight has already departed. Please update its details', mtError, mbOKCancel, 0);
  End;


end;

{This procedure changes the clients details if the clients
change is approved, it does make a change if the change
is not approved by the employee. It then removes the notification from
the client notifications textfile with the use of
the iIndex variable.
It also calls up another procedure to populate
the client notications and history accordingly}

procedure TfrmEmployee.MakeChangeToClient(sStatus: String);
var
  I: Integer;
  sLine : String;
  Temp, DataFile : TextFile;
begin
  if sStatus = 'Approve' then
  Begin
    With DBTravelNow do
    Begin
      tblClient.Open;
      tblClient.First;

      for I := 1 to tblClient.RecordCount do
      begin
        if sClientUsername = tblClient['Username'] then
        Begin
          tblClient.Edit;
          tblClient[sClientDatabaseField] := sChange;
          tblClient.Post;
          Break
        End;
        tblClient.Next;
      end;

      tblClient.Close;
    End;

    iCountChangeIndex := 0;
    redDetails.Lines.Clear;

    AssignFile(DataFile, 'EmployeeNotifications.txt');
    AssignFile(Temp, 'Temp.txt');

    if FileExists('EmployeeNotifications.txt') then
    Begin
      Reset(DataFile);
      Rewrite(Temp);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);

        if sLine = 'Change' then
        Begin
          Inc(iCountChangeIndex);

          if iCountChangeIndex <> iIndex then
          Begin
            Writeln(Temp, sLine);

            for I := 1 to 3 do
            begin
              Readln(DataFile, sLine);
              Writeln(Temp, sLine);
            end;
          End
          Else
          Begin
            for I := 1 to 3 do
            begin
              Readln(DataFile, sLine);
            end;
          End;
        End;
      End;

      CloseFile(Temp);
      CloseFile(DataFile);

      DeleteFile('EmployeeNotifications.txt');
      Reset(Temp);
      Rewrite(DataFile);

      while not eof(Temp) do
      Begin
        Readln(Temp, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(Temp);
      CloseFile(DataFile);

      DeleteFile('Temp.txt');
    End;

    PopulateNotifications;
    AddToClientHistory('Approved');
    AddToClientNotifications('Approved');
  End
  Else
  Begin
    iCountChangeIndex := 0;
    redDetails.Lines.Clear;

    AssignFile(DataFile, 'EmployeeNotifications.txt');
    AssignFile(Temp, 'Temp.txt');

    if FileExists('EmployeeNotifications.txt') then
    Begin
      Reset(DataFile);
      Rewrite(Temp);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);

        if sLine = 'Change' then
        Begin
          Inc(iCountChangeIndex);

          if iCountChangeIndex <> iIndex then
          Begin
            Writeln(Temp, sLine);

            for I := 1 to 3 do
            begin
              Readln(DataFile, sLine);
              Writeln(Temp, sLine);
            end;
          End
          Else
          Begin
            for I := 1 to 3 do
            begin
              Readln(DataFile, sLine);
            end;
          End;
        End;
      End;

      CloseFile(Temp);
      CloseFile(DataFile);

      DeleteFile('EmployeeNotifications.txt');
      Reset(Temp);
      Rewrite(DataFile);

      while not eof(Temp) do
      Begin
        Readln(Temp, sLine);
        Writeln(DataFile, sLine);
      End;

      CloseFile(Temp);
      CloseFile(DataFile);

      DeleteFile('Temp.txt');
    End;

    PopulateNotifications;
    AddToClientHistory('Declined');
    AddToClientNotifications('Declined');
  End;
end;

{Population of the combobox with all the employee notifications}

procedure TfrmEmployee.PopulateNotifications;
Var
  DataFile : TextFile;
  sLine : String;
  I, iCount : Integer;
begin
  iCount := 0;
  cmbNotifications.Items.Clear;

  AssignFile(DataFile, 'EmployeeNotifications.txt');

  if FileExists('EmployeeNotifications.txt') then
  Begin
    Reset(DataFile);

    while not eof(DataFile) do
    Begin
      Readln(DataFile, sLine);

      if sLine = 'Change' then
      Begin
        Inc(iCount);
        Readln(DataFile, sLine);
        cmbNotifications.Items.Add(IntToStr(iCount)+ '. Change: ' + sLine);
      End;
    End;

    CloseFile(DataFile);

    if iCount = 0 then
    Begin
      DeleteFile('EmployeeNotifications.txt');
      PopulateNotifications;
    End;
  End
  Else
  Begin
    cmbNotifications.Items.Add('No Notifications');
    cmbNotifications.Enabled := False;
    redDetails.Enabled := False;
    redDetails.Lines.Add('No Notifications.');
    grpDecision.Enabled := False;
  End;
end;

{This is the population of both the special offer
comboboxes. One combo is populated with the current special
offers, it is also read into the first row of the 2D array.
The other combo is populated with the names of destinations that are
not on special by comparing to see if it is already in the first
row of the 2D array. The destinations that are not already on special
is added to the second row of the 2D Array}

procedure TfrmEmployee.PopulateSpecialOffers;
Var
  DataFile : TextFile;
  sLine, sCity : String;
  I, iCounter: Integer;
  bPresent : Boolean;
  J: Integer;
begin
  AssignFile(DataFile, 'SpecialOffer.txt');

  if FileExists('SpecialOffer.txt') then
  Begin
    cmbCurrentSpecialOffers.Items.Clear;
    cmbChangeSpecialOffers.Items.Clear;

    Reset(DataFile);

    for I := 1 to 5 do
    begin
      Readln(DataFile, sLine);
      ArrSpecialOffers[1, I] := sLine;
      cmbCurrentSpecialOffers.Items.Add(sLine);
    end;

    CloseFile(DataFile);

    with DBTravelNow Do
    Begin
      qryTravelNow.SQL.Clear;
      qryTravelNow.SQL.Add('Select City from TblDestination');
      qryTravelNow.Open;

      qryTravelNow.First;
      iCounter := 0;

      for I := 1 to qryTravelNow.RecordCount do
      begin
        bPresent := False;

        for J := 1 to 5 do
        begin
          sLine := ArrSpecialOffers[1, J];
          sCity := qryTravelNow.FieldByName('City').AsString;

          if sCity = sLine then
          Begin
            bPresent := True;
          End;
        end;

        if bPresent = false then
        Begin
          cmbChangeSpecialOffers.Items.Add(sCity);
          Inc(iCounter);
          ArrSpecialOffers[2, iCounter] := sCity;
        End; //2D so just swap when change

        qryTravelNow.Next;
      end;

    end;
  End;

end;

procedure TfrmEmployee.ResetPlaneDetails;
begin
  pnlAeroplaneID.Caption := '';
  pnlAirlineName.Caption := '';
  pnlNumSeatsAvail.Caption := '';
  pnlDepartureLocation.Caption := '';
  pnlDepartureDate.Caption := '';

  dtpChangeDepartureDate.Date := Date;
  spnChangeNumSeatsAvail.Value := 0;
  cmbChangeDepartureLocation.Items.Clear;

  btnChangeDepartureDate.Enabled := False;
  btnChangeDepartureLocation.Enabled := False;
  btnChangeNumSeatsAvail.Enabled := False;

  cmbCity.ItemIndex := -1;
end;

procedure TfrmEmployee.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
