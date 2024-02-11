program Demo01;

uses
  Vcl.Forms,
  uDemo01 in 'uDemo01.pas' {FrmDemo01},
  uNetUtils in '..\..\source\uNetUtils.pas',
  uSynoDiscovery in '..\..\source\uSynoDiscovery.pas',
  uSyno.Types in '..\..\source\uSyno.Types.pas',
  JsonDataObjects in '..\..\source\JSON\JsonDataObjects.pas',
  uJsonX in '..\..\source\JSON\uJsonX.pas',
  uJsonX.RTTI in '..\..\source\JSON\uJsonX.RTTI.pas',
  uJsonX.Types in '..\..\source\JSON\uJsonX.Types.pas',
  uJsonX.Utils in '..\..\source\JSON\uJsonX.Utils.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmDemo01, FrmDemo01);
  Application.Run;
end.
