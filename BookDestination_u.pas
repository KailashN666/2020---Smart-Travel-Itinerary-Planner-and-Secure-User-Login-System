unit BookDestination_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Jpeg, TravelNowDB_u, FunctionsAndProcedures_u, BookAccommodation_u,
  ComCtrls, ProcessingBooking_u; //Added Jpeg to uses

type
  TfrmBookDestination = class(TForm)
    img1: TImage;
    pnlBookDestination: TPanel;
    img2: TImage;
    img3: TImage;
    img4: TImage;
    cmbSelectDestination: TComboBox;
    imgTemp: TImage;
    btnProceed: TButton;
    redInfo: TRichEdit;
    grpDetails: TGroupBox;
    lblCountry: TLabel;
    lblCost: TLabel;
    imgBookDestination: TImage;
    procedure cmbSelectDestinationClick(Sender: TObject);
    procedure img2Click(Sender: TObject);
    procedure img3Click(Sender: TObject);
    procedure img4Click(Sender: TObject);
    procedure btnProceedClick(Sender: TObject);
    Procedure GetInfoFromDB;
    procedure FormActivate(Sender: TObject);
    Procedure SetAsMainForm (aForm : TForm);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBookDestination: TfrmBookDestination;
  sDestination, sDestinationID : String;
  rTicketCost : Real;
implementation

{$R *.dfm}

procedure TfrmBookDestination.btnProceedClick(Sender: TObject);
begin
  if cmbSelectDestination.ItemIndex <> -1 then
  Begin
    if MessageDlg('Would you like to book your accommodation?', mtInformation, mbYesNo, 0) = mrYes then
    Begin
      FunctionsAndProcedures_u.sDestination := sDestination;
      FunctionsAndProcedures_u.bAccommodation := True;
      FunctionsAndProcedures_u.rTicketCost := rTicketCost;

      With DBTravelNow Do
      Begin
        qryTravelNow.SQL.Clear;
        qryTravelNow.SQL.Add('Select DestinationID from TblDestination Where City = ' + QuotedStr(sDestination));
        qryTravelNow.Open;

        sDestinationID := qryTravelNow['DestinationID'];
        FunctionsAndProcedures_u.sDestinationID := sDestinationID;
      End;

      frmBookDestination.Hide;
      frmAccommodation.Show;
    End
    Else
    Begin
      if MessageDlg('Are you sure you would not like accommodation?', mtConfirmation, mbYesNo, 0) = mrYes then
      Begin
        FunctionsAndProcedures_u.bAccommodation := False;
        FunctionsAndProcedures_u.sDestination := sDestination;
        FunctionsAndProcedures_u.rTicketCost := rTicketCost;
        frmProcessingBooking.Show;
        frmBookDestination.Hide;
      End
      Else
      Begin
        MessageDlg('Please select yes when asked about booking accommodation.', mtInformation, mbOKCancel, 0);
      End;
    End;
  End
  Else
  Begin
    MessageDlg('Please choose a destination before you proceed.', mtError, mbOKCancel, 0);
  End;
end;

procedure TfrmBookDestination.cmbSelectDestinationClick(Sender: TObject);
begin
  sDestination := cmbSelectDestination.Items[cmbSelectDestination.ItemIndex];

  img1.Picture.LoadFromFile(sDestination + '\1.jpg');
  img2.Picture.LoadFromFile(sDestination + '\2.jpg');
  img3.Picture.LoadFromFile(sDestination + '\3.jpg');
  img4.Picture.LoadFromFile(sDestination + '\4.jpg');

  GetInfoFromDB;
end;

procedure TfrmBookDestination.FormActivate(Sender: TObject);
begin
  SetAsMainForm(frmBookDestination);

  if FunctionsAndProcedures_u.bSpecialOffer = True then
  Begin
    sDestination := FunctionsAndProcedures_u.sDestination;
    cmbSelectDestination.Items.Clear;
    cmbSelectDestination.Items.Add(sDestination);
    cmbSelectDestination.ItemIndex := 0;
    cmbSelectDestination.Enabled := False;

    img1.Picture.LoadFromFile(sDestination + '\1.jpg');
    img2.Picture.LoadFromFile(sDestination + '\2.jpg');
    img3.Picture.LoadFromFile(sDestination + '\3.jpg');
    img4.Picture.LoadFromFile(sDestination + '\4.jpg');

    GetInfoFromDB;

    //Overwriting information

    rTicketCost := FunctionsAndProcedures_u.rTicketCost;
    lblCost.Caption := 'The cost of your discounted ticket is: ' +#13+ FloatToStrF(rTicketCost,ffCurrency, 6, 2);
  End;
end;

procedure TfrmBookDestination.GetInfoFromDB;
begin
  With DBTravelNow do
  Begin
    qryTravelNow.SQL.Clear;
    qryTravelNow.SQL.Add('Select CostPerTicket, Country, Description');
    qryTravelNow.SQL.Add('From TblDestination Where City = ' + QuotedStr(sDestination));
    qryTravelNow.Open;

    redInfo.Lines.Clear;
    lblCountry.Visible := True;
    lblCost.Visible := True;
    redInfo.Visible := True;

    rTicketCost := qryTravelNow.FieldByName('CostPerTicket').AsFloat;

    redInfo.Lines.Add(qryTravelNow.FieldByName('Description').AsString);
    lblCountry.Caption := 'This city is in the country of: ' +#13+ qryTravelNow.FieldByName('Country').AsString;
    lblCost.Caption := 'The cost of one ticket is ' +#13+ FloatToStrF(qryTravelNow.FieldByName('CostPerTicket').AsFloat, ffCurrency, 6, 2);
  End;
end;

procedure TfrmBookDestination.img2Click(Sender: TObject);
begin
  imgTemp.Picture := img1.Picture;
  img1.Picture := img2.Picture;
  img2.Picture := imgTemp.Picture;
end;

procedure TfrmBookDestination.img3Click(Sender: TObject);
begin
  imgTemp.Picture := img1.Picture;
  img1.Picture := img3.Picture;
  img3.Picture := imgTemp.Picture;
end;

procedure TfrmBookDestination.img4Click(Sender: TObject);
begin
  imgTemp.Picture := img1.Picture;
  img1.Picture := img4.Picture;
  img4.Picture := imgTemp.Picture;
end;

procedure TfrmBookDestination.SetAsMainForm(aForm: TForm);
Var
  P : Pointer;
begin
  P := @Application.MainForm;
  Pointer(P^) := aForm;
end;

end.