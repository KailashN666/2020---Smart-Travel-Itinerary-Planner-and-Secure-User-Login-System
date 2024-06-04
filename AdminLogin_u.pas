unit AdminLogin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TravelNowDB_u, StdCtrls, ExtCtrls, Admin_u, jpeg;

type
  TfrmAdminLogin = class(TForm)
    pnlAdminLogin: TPanel;
    grpAdminLogin: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtPassword: TEdit;
    edtUsername: TEdit;
    btnAdminLogin: TButton;
    imgAdminLogin: TImage;
    procedure btnAdminLoginClick(Sender: TObject);
    Function IsUsernamePresentInAdmin(sUsername : String):Boolean;
    procedure Button1Click(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdminLogin: TfrmAdminLogin;

implementation

{$R *.dfm}

procedure TfrmAdminLogin.btnAdminLoginClick(Sender: TObject); {A function is used to determine
                                                              whether the username is present in
                                                              the relative database - however the
                                                              admin also has hard coded login details
                                                              should there be any errors with the database}
Var
  sUsername, sPassword : String;
  I: Integer;
begin
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  if (sUsername <> '') and (sPassword <> '')  then
  Begin
    if IsUsernamePresentInAdmin(sUsername) = True then
    Begin
      With DBTravelNow do
      Begin
        tblAdmin.Open;
        tblAdmin.First;

        for I := 1 to tblAdmin.RecordCount do
        begin
          if Uppercase(sUsername) = Uppercase(tblAdmin['Username']) then
          Begin
            if sPassword = tblAdmin['Password'] then
            Begin
              MessageDlg('Welcome ' + sUsername, mtInformation, mbOKCancel, 0);
              frmAdmin.Show;
              frmAdminLogin.Hide;
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

          tblAdmin.Next;
        end;

        tblAdmin.Close;
      End;
    End
    Else
    Begin
      if (Uppercase(sUsername) = 'KAI') and (sPassword = 'N') then
      Begin
        MessageDlg('Welcome Admin ;)', mtInformation, mbOKCancel, 0);
        frmAdmin.Show;
        frmAdminLogin.Hide;
        edtPassword.Clear;
        edtUsername.Clear;
      End
      Else
      Begin
        edtUsername.Clear;
        edtPassword.Clear;
        MessageDlg('The Admin username does not exist in the database.', mtError, mbOKCancel, 0);
      End;
    End;
  End
  Else
  Begin
    edtUsername.Clear;
    edtPassword.Clear;
    MessageDlg('Please enter valid information', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmAdminLogin.Button1Click(Sender: TObject);
begin
  Application.Terminate;
end;

{Every form that the user progresses to is set to the main form because
 should the user choose to terminate the program, It will be
 terminated properly and not run in the background}
procedure TfrmAdminLogin.FormActivate(Sender: TObject);
begin
  SetAsMainForm(frmAdminLogin);
end;

function TfrmAdminLogin.IsUsernamePresentInAdmin(sUsername: String): Boolean;
Var
  bPresent : Boolean;
  I : Integer;
begin
  bPresent := False;

  With DBTravelNow Do
  Begin
    tblAdmin.Open;
    tblAdmin.First;

    for I := 1 to tblAdmin.RecordCount do
    Begin
      if UpperCase(sUsername) = UpperCase(tblAdmin['Username']) then
      Begin
        bPresent := True;
      End;

      tblAdmin.Next;
    End;

    tblAdmin.Close;
  End;

  Result := bPresent;
end;


procedure TfrmAdminLogin.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
