unit EmployeeLogin_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TravelNowDB_u, FunctionsAndProcedures_u, Employee_u,
  jpeg;

type
  TfrmEmployeeLogin = class(TForm)
    pnlEmployeeLogin: TPanel;
    grpEmployeeLoginDetails: TGroupBox;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnLogin: TButton;
    imgEmployeeLogin: TImage;
    procedure btnLoginClick(Sender: TObject);
    Function IsUsernamePresentInEmployee(sUsername : String):Boolean;
    Procedure SetAsMainForm (aForm : TForm);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmployeeLogin: TfrmEmployeeLogin;

implementation

{$R *.dfm}

procedure TfrmEmployeeLogin.btnLoginClick(Sender: TObject);   {A function is used to determine
                                                              whether the username is present in
                                                              the relative database}
Var
  sName, sUsername, sPassword : String;
  I: Integer;
begin
  sUsername := edtUsername.Text;
  sPassword := edtPassword.Text;

  if (sUsername <> '') and (sPassword <> '')  then
  Begin
    if IsUsernamePresentInEmployee(sUsername) = True then
    Begin
      With DBTravelNow do
      Begin
        tblEmployee.Open;
        tblEmployee.First;

        for I := 1 to tblEmployee.RecordCount do
        begin
          if Uppercase(sUsername) = Uppercase(tblEmployee['Username']) then
          Begin
            if sPassword = tblEmployee['Password'] then
            Begin
              sName := tblEmployee['EmployeeName'];
              MessageDlg('Welcome ' + sName, mtInformation, mbOKCancel, 0);
              FunctionsAndProcedures_u.sEmployeeUsername := sUsername;
              frmEmployeeLogin.Hide;
              frmEmployee.Show;
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

          tblEmployee.Next;
        end;

        tblEmployee.Close;
      End;
    End
    Else
    Begin
      edtUsername.Clear;
      edtPassword.Clear;
      MessageDlg('The Employee username does not exist in the database.', mtError, mbOKCancel, 0);
    End;
  End
  Else
  Begin
    edtUsername.Clear;
    edtPassword.Clear;
    MessageDlg('Please enter valid information', mtError, mbOKCancel, 0);
  End;
end;

{Every form that the user progresses to is set to the main form because
 should the user choose to terminate the program, It will be
 terminated properly and not run in the background}
procedure TfrmEmployeeLogin.FormActivate(Sender: TObject);
begin
  SetAsMainForm(frmEmployeeLogin);
end;

function TfrmEmployeeLogin.IsUsernamePresentInEmployee(
  sUsername: String): Boolean;
Var
  bPresent : Boolean;
  I : Integer;
begin
  bPresent := False;

  With DBTravelNow Do
  Begin
    tblEmployee.Open;
    tblEmployee.First;

    for I := 1 to tblEmployee.RecordCount do
    Begin
      if UpperCase(sUsername) = UpperCase(tblEmployee['Username']) then
      Begin
        bPresent := True;
      End;

      tblEmployee.Next;
    End;

    tblEmployee.Close;
  End;

  Result := bPresent;
end;

procedure TfrmEmployeeLogin.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.
