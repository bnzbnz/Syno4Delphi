unit uSyno.API.Types;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///

interface
uses uJsonX, uJsonX.Types, uSyno.Types;
type

  TSynoAPIInfoReq = class(TSynoRequest)
    Fquery: variant;
  end;

  TSynoAPIInfo_API = class(TJsonXBaseEx2Type)
    FmaxVersion: variant;
    FminVersion: variant;
    Fpath: variant;
    FrequestFormat: variant;
  end;

  TSynoAPIInfoRes = class(TSynoResponse)
    [AJsonXClassType(TSynoAPIInfo_API)]
    Fdata: TJsonXVarObjDicType;
    Fdummy: variant;
  end;

implementation

end.
