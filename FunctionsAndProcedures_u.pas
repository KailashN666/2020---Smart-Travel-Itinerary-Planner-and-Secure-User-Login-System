unit FunctionsAndProcedures_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdSMTP, IdMessage, IdEMailAddress, StdCtrls, IdIOHandler,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdBaseComponent, IdGlobal, IdAttachmentFile, TravelNowDB_u;

type
  TfrmFunctionsAndProcedures = class(TForm)
    IdMessage1: TIdMessage;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdSMTP1: TIdSMTP;
    Procedure EmailUsernamePassword (sName, sRecipient, sUsername, sPassword : String);
    Function CheckUsernameInClientDB (sUsername : String) : Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFunctionsAndProcedures: TfrmFunctionsAndProcedures;
  sClientUsername : String;
  sEmployeeUsername : String;
  sDestination, sDestinationID : String;
  bAccommodation, bSpecialOffer : Boolean;
  sHotelName : String;
  rTicketCost, rHotelCost : Real;
implementation

{$R *.dfm}

{ TfrmFunctionsAndProcedures }

function TfrmFunctionsAndProcedures.CheckUsernameInClientDB(
  sUsername: String): Boolean;
var
  I: Integer;
  bFound : Boolean;
begin
  bFound := False;

  with DBTravelNow do
  Begin
    tblClient.Open;
    tblClient.First;

    for I := 1 to tblClient.RecordCount do
    begin
      if UpperCase(tblClient['Username']) = Uppercase(sUsername) then
      Begin
        bFound := True;
        Break
      End;

      tblClient.Next;
    end;

    tblClient.Close;

    Result := bFound;
  End;
end;

procedure TfrmFunctionsAndProcedures.EmailUsernamePassword(sName, sRecipient,
  sUsername, sPassword: String);
// IO HANDLER SETTINGS //
Begin
  With IdSSLIOHandlerSocketOpenSSL1 do
  begin
    Destination := 'smtp.gmail.com:587';
    Host := 'smtp.gmail.com';
    MaxLineAction := maException;
    Port := 587;
    SSLOptions.Method := sslvTLSv1;
    SSLOptions.Mode := sslmUnassigned;
    SSLOptions.VerifyMode := [];
    SSLOptions.VerifyDepth := 0;
  end;

//SETTING SMTP COMPONENT DATA //
  IdSMTP1.Host := 'smtp.gmail.com';
  IdSMTP1.Port := 587;
  IdSMTP1.Username := 'travelnowenquiries@gmail.com'; // please change to your gmail address //
  IdSMTP1.Password := 'kailashnagasar';
  IdSMTP1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;
  IdSMTP1.AuthType := satDefault;
  IdSMTP1.UseTLS := utUseExplicitTLS;

// SETTING email MESSAGE DATA //
  IdMessage1.Clear;

// add recipient list //
  with IdMessage1.Recipients.Add do
  begin
    Name := sName;
    Address := sRecipient; // Recipient Address//
  end;

  {add CC list
  with IdMessage1.CCList.Add do
  begin
    Name := 'CC Recipient 1';
    Address := CCRecipient1@email.com;
  end;}

  {add BCC list
  with IdMessage1.BCCList.Add do
  begin
    Name := 'BCC Recipient 1';
    Address := BCCRecipient1@email.com;
  end;}

  IdMessage1.From.Address :=  'travelnowenquiries@gmail.com';
  IdMessage1.Subject := 'Welcome to TravelNow';
  IdMessage1.Body.Add('Dear ' +sName +#13+#13+ 'We are pleased to have you as our client. Attached are your Login details' +#13+#13+#9+
                      'Username: ' + sUsername +#13+#9+ 'Password: ' + sPassword +#13+#13+ 'Kind Regards' +#13+ 'The TravelNowTeam.');
  IdMessage1.Priority := mpHigh;

  TRY
    IdSMTP1.Connect();
    IdSMTP1.Send(IdMessage1);
    IdSMTP1.Disconnect();
  except on e:Exception do
    begin
      ShowMessage(e.Message);
      IdSMTP1.Disconnect();
    end;
  END;

end;
end.
