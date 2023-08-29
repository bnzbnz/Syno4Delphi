unit uSyno.Auth.Types;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///


interface
uses uJsonX, uJsonX.Types, uSyno.Types;

type

  // API List (query)

  TSynoAuthAPIListReq = class(TSynoRequest)
    Fquery: variant;
  end;

  TSynoAuthAPIListData = class(TJsonXBaseEx2Type)
    Fkey: variant;
    Fpath: variant;
    FminVersion: variant;
    FmaxVersion: variant;
    FrequestFormat: variant;
  end;

  TSynoAuthAPIListRes = class(TSynoResponse)
    [AJsonXClassType(TSynoAuthAPIListData)]
    Fdata: TJsonXVarObjDicType;
  end;

  // Connect (login)

  TSynoAuthLoginData = class(TJsonXBaseEx2Type)
    Fsid: variant;
    Fdid: variant;
    Fsynotoken: variant;
  end;

  TSynoAuthLoginReq = class(TSynoRequest)
    Faccount: variant;
    Fpasswd: variant;
    Fsession: variant;
    Fformat: variant;
    Fotp_code: variant;
    Fenable_syno_token: variant;
    Fenable_device_token: variant;
    Fdevice_name: variant;
    Fdevice_id: variant;
  end;

  TSynoAuthLoginRes = class(TSynoResponse)
    Fdata: TSynoAuthLoginData;
  end;


  // Disconnect (logout)

  TSynoAuthLogoutReq = class(TSynoRequest);

  TSynoAuthLogoutRes = class(TSynoResponse);

  // Token

  TSynoAuthTokenReq = class(TSynoRequest);

  TSynoAuthTokenData = class(TJsonXBaseEx2Type)
    Ftoken: variant;
  end;

  TSynoAuthTokenRes = class(TSynoResponse)
    Fdata: TSynoAuthTokenData;
  end;

implementation

end.
