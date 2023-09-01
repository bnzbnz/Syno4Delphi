program Demo01;

uses
  Vcl.Forms,
  uDemo01 in 'uDemo01.pas' {FrmDemo01},
  uNetUtils in '..\..\source\uNetUtils.pas',
  uSynoDiscovery in '..\..\source\uSynoDiscovery.pas',
  uSyno.Types in '..\..\source\uSyno.Types.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmDemo01, FrmDemo01);
  Application.Run;
end.
