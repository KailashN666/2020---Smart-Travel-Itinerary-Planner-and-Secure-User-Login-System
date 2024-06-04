unit Client_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, TravelNowDB_u, FunctionsAndProcedures_u, BookDestination_u,
  jpeg;

type
  TfrmClient = class(TForm)
    pcClient: TPageControl;
    tsBooking: TTabSheet;
    tsNotifications: TTabSheet;
    tsHistory: TTabSheet;
    tsProfile: TTabSheet;
    lblUsername: TLabel;
    lblName: TLabel;
    lblSurname: TLabel;
    lblContactNumber: TLabel;
    lblID: TLabel;
    lblDOB: TLabel;
    lblEmail: TLabel;
    pnlEmail: TPanel;
    pnlID: TPanel;
    pnlContactNumber: TPanel;
    pnlSurname: TPanel;
    pnlName: TPanel;
    pnlUsername: TPanel;
    edtChange: TEdit;
    cmbChange: TComboBox;
    btnSubmitChange: TButton;
    redHistory: TRichEdit;
    btnDeleteHistory: TButton;
    cmbNotifications: TComboBox;
    redDetails: TRichEdit;
    grpRead: TGroupBox;
    btnMarkRead: TButton;
    btnMarkAllRead: TButton;
    btnProceedToBooking: TButton;
    lblDestination1: TLabel;
    lblDestination5: TLabel;
    lblDestination2: TLabel;
    lblDestination4: TLabel;
    lblDestination3: TLabel;
    imgDest2: TImage;
    imgDest5: TImage;
    imgDest3: TImage;
    imgDest1: TImage;
    imgDest4: TImage;
    pnlSpecialDeals: TPanel;
    btnCloseProgram: TButton;
    imgNotifications: TImage;
    pnlDOB: TPanel;
    imgProfile: TImage;
    procedure FormActivate(Sender: TObject);
    procedure cmbChangeClick(Sender: TObject);
    procedure btnSubmitChangeClick(Sender: TObject);
    Procedure PopulateHistory;
    Procedure AddChangeToHistory;
    procedure btnDeleteHistoryClick(Sender: TObject);
    Procedure PopulateNotifications;
    procedure cmbNotificationsClick(Sender: TObject);
    procedure btnMarkAllReadClick(Sender: TObject);
    procedure btnMarkReadClick(Sender: TObject);
    procedure btnProceedToBookingClick(Sender: TObject);
    procedure PopulateSpecialDeals;
    procedure imgDest1Click(Sender: TObject);
    Function GetCostOfTicket : Real;
    procedure imgDest2Click(Sender: TObject);
    procedure imgDest3Click(Sender: TObject);
    procedure imgDest4Click(Sender: TObject);
    procedure imgDest5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCloseProgramClick(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClient: TfrmClient;
  sUsername : String;
  sFirstName, sSurname, sContactNo, sID, sEmail : String;
  dDOB : TDate;
  sDatabaseFieldName, sField, sChange : String;
  iCountNotificationIndex, iIndex: Integer;
  sDestination : String;
  rTicketCost : Real;
implementation

{$R *.dfm}
{If a textfile already exists, I want the recent
history/notifications to be right at the top of the
textfile, this acounts for the
use of a temporary datafile in all instances}

{When a client submits a change for their profile, it has to be
reviewed by an employee. A textfile with client history is used
to display the history of the clients actions. This procedure
adds the change to the client history textfile}

procedure TfrmClient.AddChangeToHistory;
Var
  DataFile, TempDataFile : TextFile;
  sTextFileData, sLine : String;
begin
  AssignFile(DataFile, sUsername+' History.txt');
  if FileExists(sUsername+' History.txt') then
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
    Writeln(DataFile,'You attempted to change your ' + sField +'.');
    Writeln(DataFile, 'Your change has not been approved as yet.');
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

    PopulateHistory;
  End
  Else
  Begin
    Rewrite(DataFile);

    Writeln(DataFile, 'History');
    Writeln(DataFile, 'You submitted a change');
    Writeln(DataFile, DateToStr(Date));
    Writeln(DataFile,'You attempted to change your ' + sField +'.');
    Writeln(DataFile, 'Your change has not been approved as yet.');
    Writeln(DataFile, #13+#13);

    CloseFile(DataFile);

    PopulateHistory;
  End;
end;

procedure TfrmClient.btnCloseProgramClick(Sender: TObject);
begin
  if MessageDlg('Would you like to close the program?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    Application.Terminate;
  End;
end;

procedure TfrmClient.btnDeleteHistoryClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to delete all your history?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    DeleteFile(sUsername + ' History.txt');
    MessageDlg('Your history has been cleared.', mtInformation, mbOKCancel, 0);
    PopulateHistory;
  End
  Else
  Begin
    MessageDlg('Your history has not been cleared.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.btnMarkAllReadClick(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to mark all as read?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    DeleteFile(sUsername+' Notifications.txt');
    PopulateNotifications;
  End;
end;

procedure TfrmClient.btnMarkReadClick(Sender: TObject);
var
  I : Integer;
  sLine : String;
  Temp, DataFile : TextFile;
begin
  if MessageDlg('Are you sure you want to mark this as read?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    iCountNotificationIndex := 0;
    redDetails.Lines.Clear;

    AssignFile(DataFile, sUsername+' Notifications.txt');
    AssignFile(Temp, 'Temp.txt');

    if FileExists(sUsername+' Notifications.txt') then
    Begin
      Reset(DataFile);
      Rewrite(Temp);

      while not eof(DataFile) do
      Begin
        Readln(DataFile, sLine);

        {Index is a global variable and gets a value from the
        active notification combo box when it is clicked to
        display a notification}

        {In order to mark a notification as read, The client
        notification textfile needs to be rewritten without the
        notification that the client has already read}

        if sLine = 'Notification' then
        Begin
          Inc(iCountNotificationIndex);

          if iCountNotificationIndex <> iIndex then
          Begin
            Writeln(Temp, sLine);

            for I := 1 to 4 do
            begin
              Readln(DataFile, sLine);
              Writeln(Temp, sLine);
            end;
          End
          Else
          Begin
            for I := 1 to 4 do
            begin
              Readln(DataFile, sLine);
            end;
          End;
        End;

        if sLine = 'Trip' then
        Begin
          Inc(iCountNotificationIndex);

          if iCountNotificationIndex <> iIndex then
          Begin
            Writeln(Temp, sLine);

            for I := 1 to 4 do
            begin
              Readln(DataFile, sLine);
              Writeln(Temp, sLine);
            end;
          End
          Else
          Begin
            for I := 1 to 4 do
            begin
              Readln(DataFile, sLine);
            end;
          End;
        End;
      End;

      CloseFile(Temp);
      CloseFile(DataFile);

      DeleteFile(sUsername+' Notifications.txt');
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

      cmbNotifications.ItemIndex := -1;
    End;

    PopulateNotifications;
  End
  Else
  Begin
    MessageDlg('This notification has not been marked as read.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.btnProceedToBookingClick(Sender: TObject);
begin
  frmClient.Hide;
  frmBookDestination.Show;
  FunctionsAndProcedures_u.bSpecialOffer := False;
end;

{When a client submits a change, it will be added to the
employee notifications textfile so that it can be reviewed
by an employee}

procedure TfrmClient.btnSubmitChangeClick(Sender: TObject);
Var
  DataFile : TextFile;
begin
  if edtChange.Text <> '' then  //Very little validation as the EMPLOYEE will accept or decline change
  Begin
    sChange := edtChange.Text;

    if MessageDlg('Would you like to submit the following change?' +#13+
                   sField + ': ' + sChange, mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      AssignFile(DataFile, 'EmployeeNotifications.txt');

      if FileExists('EmployeeNotifications.txt') then
      Begin
        Append(DataFile);
        Writeln(DataFile,#13);
        Writeln(DataFile,'Change');
        Writeln(DataFile, sUsername);
        Writeln(DataFile, sDatabaseFieldName);
        Write(DataFile, sChange);
        CloseFile(DataFile);

        MessageDlg('Your query has been placed and it will be processed by an employee', mtInformation, mbOKCancel, 0);
        edtChange.Text := '';
        edtChange.Visible := False;
        btnSubmitChange.Visible := False;

        AddChangeToHistory;
      End
      Else
      Begin
        Rewrite(DataFile);
        Writeln(DataFile, 'Change');
        Writeln(DataFile, sUsername);
        Writeln(DataFile, sDatabaseFieldName);
        Write(DataFile, sChange);
        CloseFile(DataFile);

        MessageDlg('Your query has been placed and it will be processed by an employee', mtInformation, mbOKCancel, 0);
        edtChange.Text := '';
        edtChange.Visible := False;
        btnSubmitChange.Visible := False;

        AddChangeToHistory;
      End;
    End
    Else
    Begin
      MessageDlg('Submit details that you are sure of.', mtWarning, mbOKCancel, 0);
      edtChange.Text := '';
      edtChange.Visible := False;
      btnSubmitChange.Visible := False;
    End;

  End
  Else
  Begin
    MessageDlg('The change you have submitted is not valid.', mtError, mbOKCancel, 0);
    edtChange.SetFocus;
  End;
end;

procedure TfrmClient.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

{sField is a global variable that is used when the button
to submit a change is clicked - sChange holds the name of field
that the client wishes to change}

procedure TfrmClient.cmbChangeClick(Sender: TObject);
Var
  iIndex : Integer;

begin
  iIndex := cmbChange.ItemIndex;

  edtChange.Visible := True;
  btnSubmitChange.Visible := True;

  case iIndex of
    0 : Begin
          sDatabaseFieldName := 'FirstName';
          sField := 'Name';
        End;
    1 : Begin
          sDatabaseFieldName := 'Surname';
          sField := 'Surname';
        End;
    2 : Begin
          sDatabaseFieldName := 'ContactNumber';
          sField := 'Contact Number';
        End;
    3 : Begin
          sDatabaseFieldName := 'EmailAddress';
          sField := 'Email Address';
        End;
  end;
end;

{iIndex is a global variable that will be used when
the client wishes to mark a certain notification as read.
iIndex gets its value from here - when the cmbNotifications is
clicked.}

{When the combobox that is populated with notifications is clicked,
iIndex is also used to populate the RichEdit display with the
details of the notification that the client has selected}

procedure TfrmClient.cmbNotificationsClick(Sender: TObject);
Var
  I : Integer;
  DataFile : TextFile;
  sLine : String;
begin
  iIndex := StrToInt(Copy(cmbNotifications.Text, 1,1));
  iCountNotificationIndex := 0;

  redDetails.Lines.Clear;

  AssignFile(DataFile, sUsername+' Notifications.txt');

  if FileExists(sUsername+' Notifications.txt') then
  Begin
    Reset(DataFile);

    while not eof(DataFile) do
    Begin
      Readln(DataFile, sLine);

      if sLine = 'Notification' then
      Begin
        Inc(iCountNotificationIndex);

        if iCountNotificationIndex = iIndex then
        Begin
          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          btnMarkRead.Enabled := True;
          btnMarkAllRead.Enabled := True;
        End
        Else
        Begin
          for I := 1 to 4 do
          begin
            Readln(DataFile, sLine);
          end;
        End;
      End;

      if sLine = 'Trip' then
      Begin
        Inc(iCountNotificationIndex);

        if iCountNotificationIndex = iIndex then
        Begin
          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          Readln(DataFile, sLine);
          redDetails.Lines.Add(sLine);

          btnMarkRead.Enabled := True;
          btnMarkAllRead.Enabled := True;
        End
        Else
        Begin
          for I := 1 to 4 do
          begin
            Readln(DataFile, sLine);
          end;
        End;
      End;
    End;

    CloseFile(DataFile);
  End
end;

procedure TfrmClient.FormActivate(Sender: TObject);
Var
  I : Integer;
begin
  SetAsMainForm(frmClient);

  sUsername := FunctionsAndProcedures_u.sClientUsername;

  pnlUsername.Caption := sUsername;

  {The client's username is extracted from another form when the
  program transitions from the client login form to the client form.
  The client's profile is built from the Client database based on the
  stored username - as this username is the username of the client that is
  currently using the program.}

  With DBTravelNow do
  Begin
    tblClient.Open;
    tblClient.First;

    for I := 1 to tblClient.RecordCount do
    begin
      if Uppercase(sUsername) = Uppercase(tblClient['Username']) then
      Begin
        sFirstName := tblClient.FieldByName('FirstName').AsString;
        sSurname := tblClient.FieldByName('Surname').AsString;
        sContactNo := tblClient.FieldByName('ContactNumber').AsString;
        sID := tblClient.FieldByName('IDNumber').AsString;
        sEmail := tblClient.FieldByName('EmailAddress').AsString;
        dDOB := tblClient.FieldByName('DateOfBirth').AsDateTime;
        Break
      End;

      tblClient.Next;
    end;

    MessageDlg('Click on the image of the destination on special that you are interested in.', mtInformation, mbOKCancel, 0);
    //tblClient.Close;
  End;

  pnlName.Caption := sFirstName;
  pnlSurname.Caption := sSurname;
  pnlContactNumber.Caption := sContactNo;
  pnlID.Caption := sID;
  pnlEmail.Caption := sEmail;
  pnlDOB.Caption := FormatDateTime('dd mmmm yyyy', dDOB);

  PopulateHistory;
  PopulateNotifications;
  PopulateSpecialDeals;
end;

{This function is used when the special offers are selected}

function TfrmClient.GetCostOfTicket: Real;
Var
  rCost : Real;
begin
  With DBTravelNow do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select CostPerTicket From TblDestination Where City =  :sDestination');
    qryTravelNow.Parameters.ParamByName('sDestination').Value := sDestination;
    qryTravelNow.Open;

    rCost := qryTravelNow.FieldByName('CostPerTicket').AsFloat;

    Result := rCost;
  End;
end;

procedure TfrmClient.imgDest1Click(Sender: TObject);
begin
  sDestination := lblDestination1.Caption;
  rTicketCost := GetCostOfTicket;

  if MessageDlg('You are interested in travelling to ' + sDestination +#13+
                'The original cost of a ticket is: ' + FloatToStrF(rTicketCost, ffCurrency, 6, 2)
                +#13+ 'We are prepared to offer it to you at the discounted price of: ' + FloatToStrF(rTicketCost * 0.75, ffCurrency, 6, 2)
                +#13+ 'Are you interested in this offer? ', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    rTicketCost := rTicketCost * 0.75;
    FunctionsAndProcedures_u.bSpecialOffer := True;
    FunctionsAndProcedures_u.sDestination := sDestination;
    FunctionsAndProcedures_u.rTicketCost := rTicketCost;
    frmClient.Hide;
    frmBookDestination.Show;
  End
  Else
  Begin
    MessageDlg('Please take a look at our other special offers.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.imgDest2Click(Sender: TObject);
begin
  sDestination := lblDestination2.Caption;
  rTicketCost := GetCostOfTicket;

  if MessageDlg('You are interested in travelling to ' + sDestination +#13+
                'The original cost of a ticket is: ' + FloatToStrF(rTicketCost, ffCurrency, 6, 2)
                +#13+ 'We are prepared to offer it to you at the discounted price of: ' + FloatToStrF(rTicketCost * 0.75, ffCurrency, 6, 2)
                +#13+ 'Are you interested in this offer? ', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    rTicketCost := rTicketCost * 0.75;
    FunctionsAndProcedures_u.bSpecialOffer := True;
    FunctionsAndProcedures_u.sDestination := sDestination;
    FunctionsAndProcedures_u.rTicketCost := rTicketCost;
    frmClient.Hide;
    frmBookDestination.Show;
  End
  Else
  Begin
    MessageDlg('Please take a look at our other special offers.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.imgDest3Click(Sender: TObject);
begin
  sDestination := lblDestination3.Caption;
  rTicketCost := GetCostOfTicket;

  if MessageDlg('You are interested in travelling to ' + sDestination +#13+
                'The original cost of a ticket is: ' + FloatToStrF(rTicketCost, ffCurrency, 6, 2)
                +#13+ 'We are prepared to offer it to you at the discounted price of: ' + FloatToStrF(rTicketCost * 0.75, ffCurrency, 6, 2)
                +#13+ 'Are you interested in this offer? ', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    rTicketCost := rTicketCost * 0.75;
    FunctionsAndProcedures_u.bSpecialOffer := True;
    FunctionsAndProcedures_u.sDestination := sDestination;
    FunctionsAndProcedures_u.rTicketCost := rTicketCost;
    frmClient.Hide;
    frmBookDestination.Show;
  End
  Else
  Begin
    MessageDlg('Please take a look at our other special offers.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.imgDest4Click(Sender: TObject);
begin
  sDestination := lblDestination4.Caption;
  rTicketCost := GetCostOfTicket;

  if MessageDlg('You are interested in travelling to ' + sDestination +#13+
                'The original cost of a ticket is: ' + FloatToStrF(rTicketCost, ffCurrency, 6, 2)
                +#13+ 'We are prepared to offer it to you at the discounted price of: ' + FloatToStrF(rTicketCost * 0.75, ffCurrency, 6, 2)
                +#13+ 'Are you interested in this offer? ', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    rTicketCost := rTicketCost * 0.75;
    FunctionsAndProcedures_u.bSpecialOffer := True;
    FunctionsAndProcedures_u.sDestination := sDestination;
    FunctionsAndProcedures_u.rTicketCost := rTicketCost;
    frmClient.Hide;
    frmBookDestination.Show;
  End
  Else
  Begin
    MessageDlg('Please take a look at our other special offers.', mtInformation, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.imgDest5Click(Sender: TObject);
begin
  sDestination := lblDestination5.Caption;
  rTicketCost := GetCostOfTicket;

  if MessageDlg('You are interested in travelling to ' + sDestination +#13+
                'The original cost of a ticket is: ' + FloatToStrF(rTicketCost, ffCurrency, 6, 2)
                +#13+ 'We are prepared to offer it to you at the discounted price of: ' + FloatToStrF(rTicketCost * 0.75, ffCurrency, 6, 2)
                +#13+ 'Are you interested in this offer? ', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    rTicketCost := rTicketCost * 0.75;
    FunctionsAndProcedures_u.bSpecialOffer := True;
    FunctionsAndProcedures_u.sDestination := sDestination;
    FunctionsAndProcedures_u.rTicketCost := rTicketCost;
    frmClient.Hide;
    frmBookDestination.Show;
  End
  Else
  Begin
    MessageDlg('Please take a look at our other special offers.', mtInformation, mbOKCancel, 0);
  End;
end;

{This procedure reads from the client history textfile
and formats history neatly in the respective RichEdit}

procedure TfrmClient.PopulateHistory;
Var
  DataFile : TextFile;
  sLine : String;
  I: Integer;
begin
  redHistory.Clear;

  AssignFile(DataFile, sUsername+' History.txt');
  if FileExists(sUsername+' History.txt') then
  Begin
    Reset(DataFile);

    while not eof(DataFile) do
    Begin
      Readln(DataFile, sLine);

      if sLine = 'History' then
      Begin
        for I := 1 to 5 do
        Begin
          Readln(DataFile, sLine);
          redHistory.Lines.Add(sLine);
        End;
      End;

      if sLine = 'Trip' then
      Begin
        for I := 1 to 5 do
        Begin
          Readln(DataFile, sLine);
          redHistory.Lines.Add(sLine);
        End;
      End;
    End;

    CloseFile(DataFile);
  End
  Else
  Begin
    redHistory.Lines.Add(#9+#9+#9 + 'No History to Display');
  End;
end;

{Population of the combobox with all the client notification}

procedure TfrmClient.PopulateNotifications;
Var
  DataFile : TextFile;
  sLine : String;
  I, iCount : Integer;
begin
  iCount := 0;
  cmbNotifications.Items.Clear;

  AssignFile(DataFile, sUsername + ' Notifications.txt');

  if FileExists(sUsername + ' Notifications.txt') then
  Begin
    Reset(DataFile);

    while not eof(DataFile) do
    Begin
      Readln(DataFile, sLine);

      if sLine = 'Notification' then
      Begin
        Inc(iCount);
        Readln(DataFile, sLine);
        cmbNotifications.Items.Add(IntToStr(iCount)+ '. Notification ');
      End;

      if sLine = 'Trip' then
      Begin
        Inc(iCount);
        Readln(DataFile, sLine);
        cmbNotifications.Items.Add(IntToStr(iCount)+ '. Trip ');
      End;
    End;

    CloseFile(DataFile);

    if iCount = 0 then
    Begin
      DeleteFile(sUsername+' Notifications.txt');
      PopulateNotifications;
    End;
  End
  Else
  Begin
    cmbNotifications.Items.Add('No Notifications');
    cmbNotifications.Enabled := False;
    redDetails.Enabled := False;
    redDetails.Lines.Add('No Notifications.');
    grpRead.Enabled := False;
  End;
end;
procedure TfrmClient.PopulateSpecialDeals;
Var
  DataFile : TextFile;
  sLine : String;
begin
  AssignFile(DataFile, 'SpecialOffer.txt');

  if FileExists('SpecialOffer.txt') then
  Begin
    Reset(DataFile);

    Readln(DataFile, sLine);
    lblDestination1.Caption := sLine;
    Readln(DataFile, sLine);
    lblDestination2.Caption := sLine;
    Readln(DataFile, sLine);
    lblDestination3.Caption := sLine;
    Readln(DataFile, sLine);
    lblDestination4.Caption := sLine;
    Readln(DataFile, sLine);
    lblDestination5.Caption := sLine;

    imgDest1.Picture.LoadFromFile(lblDestination1.Caption + '\1.jpg');
    imgDest2.Picture.LoadFromFile(lblDestination2.Caption + '\1.jpg');
    imgDest3.Picture.LoadFromFile(lblDestination3.Caption + '\1.jpg');
    imgDest4.Picture.LoadFromFile(lblDestination4.Caption + '\1.jpg');
    imgDest5.Picture.LoadFromFile(lblDestination5.Caption + '\1.jpg');
  End
  Else
  Begin
    MessageDlg('Something is wrong with your program.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmClient.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
