unit IDClientLogin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TravelNowDB_u, FunctionsAndProcedures_u, Buttons,
  jpeg;

type
  TfrmClientIDLogin = class(TForm)
    grpFindProfile: TGroupBox;
    pnlFindingProfile: TPanel;
    lblInputID: TLabel;
    edtIDInput: TEdit;
    btnFindMyProfile: TButton;
    grpVerificationQuestions: TGroupBox;
    lblQuestion1: TLabel;
    lblQuestion2: TLabel;
    lblQuestion3: TLabel;
    edtAnswer1: TEdit;
    edtAnswer2: TEdit;
    edtAnswer3: TEdit;
    btnSubmitAnswers: TButton;
    grpDisplayProfile: TGroupBox;
    lblYourUsernameIs: TLabel;
    lblYourPasswordIs: TLabel;
    lblUsername: TLabel;
    lblPassword: TLabel;
    btnCloseProgram: TButton;
    imgIdClient: TImage;
    procedure btnFindMyProfileClick(Sender: TObject);
    Function IDNumPresentInClient (sID : String): Boolean;
    procedure btnSubmitAnswersClick(Sender: TObject);
    procedure btnCloseProgramClick(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
    procedure btCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientIDLogin: TfrmClientIDLogin;
  sIDNum : String;
implementation

{$R *.dfm}

procedure TfrmClientIDLogin.btnFindMyProfileClick(Sender: TObject);
Var
  bValid : Boolean;
  I: Integer;
begin
  sIDNum := edtIDInput.Text;
  bValid := True;

  if (sIDNum <> '') and (Length(sIDNum) = 13) then
  Begin
    for I := 1 to Length(sIDNum) do
    begin
      if Not(sIDNum[I] IN ['0'..'9']) then
      Begin
        bValid := False;
      End;
    end;

    if bValid = False then
    Begin
      MessageDlg('The ID Number entered is not of acceptable format, please ensure you enter a valid ID Number.', mtError, mbOKCancel, 0);
    End
    Else
    Begin
      If MessageDlg('You are attempting to locate an account attached to the ID Number ' +#13+ sIDNum +#13+ 'Can you confirm this?', mtConfirmation, mbYesNo, 0) = mrYes Then
      Begin
        {A function is used to determine
        whether the ID Number is present in
        the client database, If it is, then the verification
        questions of the associated profile is extracted}

        if IDNumPresentInClient(sIDNum) = True then
        Begin
          edtIDInput.Enabled := False;
          btnFindMyProfile.Enabled := False;

          With DBTravelNow Do
          Begin
            tblClient.Open;
            tblClient.First;

            for I := 1 to tblClient.RecordCount do
            begin
              if tblClient['IDNumber'] = sIDNum then
              Begin
                lblQuestion1.Caption := tblClient['Question1'];
                lblQuestion2.Caption := tblClient['Question2'];
                lblQuestion3.Caption := tblClient['Question3'];
                Break
              End;

              tblClient.Next;
            end;

            tblClient.Close;
          End;

          MessageDlg('Please answer atleast 2 of the 3 questions below correctly in order to recieve your login details.', mtInformation, mbOKCancel, 0);
        End
        Else
        Begin
          MessageDlg('The ID Number is not presesnt in the Database, please check the ID number that you have provided.',mtError, mbOKCancel, 0);
          edtIDInput.Clear;
          edtIDInput.SetFocus;
        End;
      End
      Else
      Begin
        edtIDInput.Clear;
        edtIDInput.SetFocus;
        MessageDlg('Please enter an ID Number you would like to search for', mtInformation, mbOKCancel, 0);
      End;
    End;
  End
  Else
  Begin
    MessageDlg('The ID Number entered is not of acceptable format, please ensure you enter a valid ID Number.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmClientIDLogin.btCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmClientIDLogin.btnCloseProgramClick(Sender: TObject);
begin
  if MessageDlg('Would you like to close the program?', mtConfirmation, mbYesNo, 0) = mrYes then
  Begin
    Application.Terminate;
  End;
end;

procedure TfrmClientIDLogin.btnSubmitAnswersClick(Sender: TObject);
Var
  sAnswer1, sAnswer2, sAnswer3, sUsername, sPassword, sName, sEmail : String;
  iNumCorrect : Integer;
  bInvalidAnswers : Boolean;
  iCountCorrect : Integer;
  I: Integer;
begin
  sAnswer1 := edtAnswer1.Text;
  sAnswer2 := edtAnswer2.Text;
  sAnswer3 := edtAnswer3.Text;

  bInvalidAnswers := False;

  if (sAnswer1 = '') or (sAnswer2 = '') or (sAnswer3 = '') then
  Begin
    bInvalidAnswers := True;
  End;

  if bInvalidAnswers = False then
  Begin
    if MessageDlg('Would you like to submit the following answers?' +#13+#13+
                  lblQuestion1.Caption +#13+ sAnswer1 +#13+ lblQuestion2.Caption +#13+ sAnswer2
                  +#13+ lblQuestion3.Caption +#13+ sAnswer3, mtConfirmation, mbYesNo, 0) = mrYes then
    Begin
      iCountCorrect := 0;

      grpFindProfile.Enabled := False;
      btnFindMyProfile.Enabled := False;

      grpVerificationQuestions.Enabled := False;
      btnSubmitAnswers.Enabled := False;

      With DBTravelNow Do
      Begin
        tblClient.Open;
        tblClient.First;

        for I := 1 to tblClient.RecordCount do
        begin
          if tblClient['IDNumber'] = sIDNum then
          Begin
            if Uppercase(sAnswer1) = Uppercase(tblClient['Answer1']) then
            Begin
              iCountCorrect := iCountCorrect + 1;
            End;

            if Uppercase(sAnswer2) = Uppercase(tblClient['Answer2']) then
            Begin
              iCountCorrect := iCountCorrect + 1;
            End;

            if Uppercase(sAnswer3) = Uppercase(tblClient['Answer3']) then
            Begin
              iCountCorrect := iCountCorrect + 1;
            End;

            {If atleast 2 of the three answers are correct, then only will
             the program display the login details of the client, and re-email
             it to them}

            if iCountCorrect >= 2 then
            Begin
              sName := tblClient.FieldByName('FirstName').AsString;
              sUsername := tblClient.FieldByName('Username').AsString;
              sPassword := tblClient.FieldByName('Password').AsString;

              lblUsername.Caption := sUsername;
              lblPassword.caption := sPassword;

              if tblClient.FieldByName('EmailAddress').AsString <> 'No Email Address' then
              Begin
                MessageDlg('The email that you received upon registration will be resent to you', mtInformation, mbOKCancel, 0);
                sName := tblClient['FirstName'];
                sEmail := tblClient['EmailAddress'];

                frmFunctionsAndProcedures.EmailUsernamePassword(sName, sEmail, sUsername, sPassword);

                edtAnswer1.Clear;
                edtAnswer2.Clear;
                edtAnswer3.Clear;
                edtIDInput.Clear;

                grpFindProfile.Enabled := True;
                btnFindMyProfile.Enabled := True;

                grpVerificationQuestions.Enabled := True;
                btnSubmitAnswers.Enabled := True;
              End
              Else
              Begin
                edtAnswer1.Clear;
                edtAnswer2.Clear;
                edtAnswer3.Clear;
                edtIDInput.Clear;

                grpFindProfile.Enabled := True;
                btnFindMyProfile.Enabled := True;

                grpVerificationQuestions.Enabled := True;
                btnSubmitAnswers.Enabled := True;
              End;
            End
            Else
            Begin
              MessageDlg('Please answer 2 or more questions correct in order to receive your login details. You have not met these requirements.',mtError, mbOKCancel, 0);
              edtAnswer1.Clear;
              edtAnswer2.Clear;
              edtAnswer3.Clear;
              edtIDInput.Clear;

              grpFindProfile.Enabled := True;
              btnFindMyProfile.Enabled := True;

              grpVerificationQuestions.Enabled := True;
              btnSubmitAnswers.Enabled := True;
            End;
          End;

          tblClient.Next;
        end;

        tblClient.Close;
      End;
    End
    Else
    Begin
      MessageDlg('Be sure of what you are entering.', mtWarning, mbOKCancel, 0);

      edtAnswer1.Clear;
      edtAnswer2.Clear;
      edtAnswer3.Clear;
      edtIDInput.Clear;

      grpFindProfile.Enabled := True;
      btnFindMyProfile.Enabled := True;

      grpVerificationQuestions.Enabled := True;
      btnSubmitAnswers.Enabled := True;
    End;
  End
  Else
  Begin
    MessageDlg('Please ensure that you are inputting the correct answers.', mtWarning, mbOKCancel, 0);
  End;
end;

procedure TfrmClientIDLogin.FormActivate(Sender: TObject);
begin
  MessageDlg('Please Enter your ID Number so that we can attempt to locate your Profile.', mtInformation, mbOKCancel, 0);
end;

function TfrmClientIDLogin.IDNumPresentInClient(sID: String): Boolean;
Var
  bFound : Boolean;
  I: Integer;
begin
  bFound := False;

  With DBTravelNow Do
  Begin
    tblClient.Open;
    tblClient.First;

    for I := 1 to tblClient.RecordCount do
    begin
      if tblClient['IDNumber'] = sID then
      Begin
        bFound := True;
      End;

      tblClient.Next;
    end;

    tblClient.Close;

    Result := bFound;
  End;
end;

procedure TfrmClientIDLogin.SetAsMainForm(aForm : TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
