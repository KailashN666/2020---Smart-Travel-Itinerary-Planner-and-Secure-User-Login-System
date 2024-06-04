unit ClientLogin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RegisterNewClient_u, IDClientLogin_u, TravelNowDB_u, Client_u, FunctionsAndProcedures_u, StdCtrls, ComCtrls, ExtCtrls,
  jpeg;

type
  TfrmClientLogin = class(TForm)
    pnlClientLogin: TPanel;
    grpLogin: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    pnlForgotUsername: TPanel;
    btnLoginWithID: TButton;
    grpRegister: TGroupBox;
    pnlRegister: TPanel;
    lblRegisterIntro: TLabel;
    btnRegister: TButton;
    lblForgotDetails: TLabel;
    imgClientLogin: TImage;
    procedure btnLoginWithIDClick(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmClientLogin: TfrmClientLogin;
  sUsername : string; //sUsername Read into Functions and procedures in order to overcome Circular references
implementation

{$R *.dfm}

procedure TfrmClientLogin.btnLoginClick(Sender: TObject); {A function is used to determine
                                                           whether the username is present in
                                                           the relative database}
Var
  sPassword : String;
  I: Integer;
begin
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  if (sUsername <> '') and (sPassword <> '')  then
  Begin
    if frmFunctionsAndProcedures.CheckUsernameInClientDB(sUsername) = True then
    Begin
      With DBTravelNow do
      Begin
        tblClient.Open;
        tblClient.First;

        for I := 1 to tblClient.RecordCount do
        begin
          if Uppercase(sUsername) = Uppercase(tblClient['Username']) then
          Begin
            if sPassword = tblClient['Password'] then
            Begin
              sName := tblClient['FirstName'];
              MessageDlg('Welcome ' + sName, mtInformation, mbOKCancel, 0);
              FunctionsAndProcedures_u.sClientUsername := sUsername;
              frmClientLogin.Hide;
              frmClient.Show;
              edtUsername.Clear;
              edtPassword.Clear;
            End
            Else
            Begin
              MessageDlg('The password that you have entered is incorrect.', mtError, mbOKCancel, 0);
              edtPassword.Clear;
            End;
            Break
          End;

          tblClient.Next;
        end;

        tblClient.Close;
      End;
    End
    Else
    Begin
      edtUsername.Clear;
      edtPassword.Clear;
      MessageDlg('The Client username does not exist in the database.', mtError, mbOKCancel, 0);
    End;
  End
  Else
  Begin
    edtUsername.Clear;
    edtPassword.Clear;
    MessageDlg('Please enter valid information', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmClientLogin.btnLoginWithIDClick(Sender: TObject);
begin
  frmClientIDLogin.Show;
  frmClientLogin.Hide;
end;

procedure TfrmClientLogin.btnRegisterClick(Sender: TObject);
begin
  frmRegisterNewClient.Show;
  frmClientLogin.Hide;
end;

{Every form that the user progresses to is set to the main form because
 should the user choose to terminate the program, It will be
 terminated properly and not run in the background}
procedure TfrmClientLogin.FormActivate(Sender: TObject);
begin
  SetAsMainForm(frmClientLogin);
end;

procedure TfrmClientLogin.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.