unit TravelNowIntro_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, AdminLogin_u, EmployeeLogin_u, ClientLogin_u, RegisterNewClient_u,
  Buttons, jpeg;

type
  TfrmIntroductoryScreen = class(TForm)
    pnlTitle: TPanel;
    grpUserType: TGroupBox;
    pnlIntroMessage: TPanel;
    lblIntroMessage: TLabel;
    rgpUserType: TRadioGroup;
    lblClientRegistration: TLabel;
    lblUnderscore: TLabel;
    btClose: TBitBtn;
    imgIntro: TImage;
    lblCopyright: TLabel;
    procedure rgpUserTypeClick(Sender: TObject);
    procedure lblClientRegistrationClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIntroductoryScreen: TfrmIntroductoryScreen;

implementation

{$R *.dfm}

procedure TfrmIntroductoryScreen.lblClientRegistrationClick(Sender: TObject);
begin
  frmRegisterNewClient.Show;
  frmIntroductoryScreen.Hide;
end;

procedure TfrmIntroductoryScreen.rgpUserTypeClick(Sender: TObject);
Var
  iIndex : Integer;
begin
  iIndex := rgpUserType.ItemIndex;

  if iIndex = 0 then
  Begin
    frmAdminLogin.Show;
    frmIntroductoryScreen.Hide;
  End;

  if iIndex = 1 then
  Begin
    frmEmployeeLogin.Show;
    frmIntroductoryScreen.Hide;
  End;

  if iIndex = 2 then
  Begin
    frmClientLogin.Show;
    frmIntroductoryScreen.Hide;
  End;

  rgpUserType.ItemIndex := -1;
end;

end.
