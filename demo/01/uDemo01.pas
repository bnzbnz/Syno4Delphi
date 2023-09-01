unit uDemo01;
///
/// Laurent Meyer : lmeyer@ea4d.com
///
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  System.Generics.Collections,
  uSynoDiscovery, uSyno.Types;

type
  TFrmDemo01 = class(TForm)
    Button1: TButton;
    LB: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LBClick(Sender: TObject);
  private
    { Private declarations }
    procedure Stop;
    procedure Start;
  public
    { Public declarations }
    SynoDiscovery: TSynoDiscovery;
    procedure SynoEvent(Sender: TSynoDiscovery; SynoDevice: TSynoDevice);
  end;

var
  FrmDemo01: TFrmDemo01;

implementation
uses ShellAPI;

{$R *.dfm}

procedure TFrmDemo01.Stop;
begin
  SynoDiscovery.Stop;
  while LB.Items.Count > 0 do
  begin
    LB.Items.Objects[0].Free;
    LB.Items.Delete(0);
  end;
end;

procedure TFrmDemo01.Start;
begin
  SynoDiscovery.Start;
end;

procedure TFrmDemo01.Button1Click(Sender: TObject);
begin
  Stop;
  Start;
end;

procedure TFrmDemo01.FormCreate(Sender: TObject);
begin
  SynoDiscovery := TSynoDiscovery.Create(Self);
  SynoDiscovery.OnFound := SynoEvent;
end;

procedure TFrmDemo01.FormDestroy(Sender: TObject);
begin
  Stop;
end;

procedure TFrmDemo01.LBClick(Sender: TObject);
begin
  if LB.ItemIndex <> -1 then
  begin
    var SynoDevice := TSynoDevice(LB.Items.Objects[LB.ItemIndex]);
    var Url := Format('http://%s:%d', [SynoDevice.IP, SynoDevice.Port]);
    ShellExecute(self.WindowHandle, 'open', PChar(Url), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TFrmDemo01.SynoEvent(Sender: TSynoDiscovery; SynoDevice: TSynoDevice);
begin
  var Line := Format(
                '%s (%s) - IP %s - MAC %s - Serial %s - Ports: %d/%d - %s %s.%d update %d',
                [SynoDevice.Name, SynoDevice.Model, SynoDevice.IP,
                SynoDevice.MAC, SynoDevice.Serial, SynoDevice.Port,
                SynoDevice.PortSSL,
                SynoDevice.OS, SynoDevice.FirmMajor, SynoDevice.FirmMinor, SynoDevice.FirmUpdate]
              );
  LB.AddItem( Line, SynoDevice);
end;

end.
