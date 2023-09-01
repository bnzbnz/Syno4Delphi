unit uSynoConnect;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Buttons,
  uSynoDiscovery, uSyno,
  uSyno.Core.Types;

type
  TDlgPass = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    SignIn: TEdit;
    CBList: TComboBox;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBListDropDown(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SynoDiscovery: TSynoDiscovery;
    function SelectedSyno: TSynoDevice;
    procedure SynoDiscovered(Sender: TSynoDiscovery; SynoDevice: TSynoDevice);
  end;

var
  DlgPass: TDlgPass;

implementation
uses Dialogs;
{$R *.dfm}

procedure TDlgPass.CBListDropDown(Sender: TObject);
begin
  SynoDiscovery.Stop;
  for var i := 0 to CBList.Items.Count - 1 do CBList.Items.Objects[i].Free;
  CBList.Clear;
  CBList.Items.AddObject('...Loading...', nil);
  SynoDiscovery.Start;
end;

procedure TDlgPass.FormCreate(Sender: TObject);
begin
  SynoDiscovery := TSynoDiscovery.Create(Self);
  SynoDiscovery.OnFound := SynoDiscovered;
end;

procedure TDlgPass.FormDestroy(Sender: TObject);
begin
  for var i := 0 to CBList.Items.Count - 1 do CBList.Items.Objects[i].Free;
end;

function TDlgPass.SelectedSyno: TSynoDevice;
begin
  Result := nil;
  if CBList.Itemindex = -1  then Exit(nil);
  Exit( TSynoDevice(CBList.Items.Objects[CBList.ItemIndex]) );
end;

procedure TDlgPass.FormShow(Sender: TObject);
begin
  SynoDiscovery.Start;
end;

procedure TDlgPass.OKBtnClick(Sender: TObject);
var
  Syno: TSyno;
begin
  var SignIn := DlgPass.SignIn.Text;
  var Pass := DlgPass.Password.Text;
  {$I 'DevCredentials.inc'}
  Syno := TSyno.Create( Format('http://%s:%d', [SelectedSyno.IP, SelectedSyno.Port]), SignIn, Pass);
   if Syno.Auth_Login then
   begin
     OKBtn.ModalResult := mrOK;
     Syno.Auth_Logout;
     Close;
   end else begin
     showmessage('Can''t Connect : Please check your Credentials...');
   end;
   Syno.Free;
end;

procedure TDlgPass.SynoDiscovered(Sender: TSynoDiscovery; SynoDevice: TSynoDevice);
begin
  CBList.Items.AddObject(Format('%s : %s (%s) - %s', [SynoDevice.IP, SynoDEvice.Name, SynoDevice.Model, SynoDevice.Serial]), SynoDevice);
  for var i := 0 to CBList.Items.Count - 1 do
    if CBList.Items.Objects[i] = nil then CBList.Items.Delete(i);
end;


end.

