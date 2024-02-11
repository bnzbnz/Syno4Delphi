unit uSyno.API.Types;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///


interface
uses uJsonX, uJsonX.Types, uSyno.Types;

type

  // API List (query)

  TSynoAPIQueryReq = class(TSynoRequest)
    Fquery: variant;
    constructor Create; overload;
  end;

  TSynoAPIQueryData = class(TJsonXBaseEx2Type)
    Fkey: variant;
    Fpath: variant;
    FminVersion: variant;
    FmaxVersion: variant;
    FrequestFormat: variant;
  end;

  TSynoAPIQueryRes = class(TSynoResponse)
    [AJsonXClassType(TSynoAPIQueryData)]
    Fdata: TJsonXVarObjDicType;
  end;

  // Connect (login)

  TSynoAPILoginReq = class(TSynoRequest)
    Faccount: variant;
    Fpasswd: variant;
    Fsession: variant;
    Fformat: variant;
    Fotp_code: variant;
    Fenable_syno_token: variant;
    Fenable_device_token: variant;
    Fdevice_name: variant;
    Fdevice_id: variant;
    constructor Create; overload;
  end;

  TSynoAPILoginData = class(TJsonXBaseEx2Type)
    Fsid: variant;
    Fdid: variant;
    Fsynotoken: variant;
  end;

  TSynoAPILoginRes = class(TSynoResponse)
    Fdata: TSynoAPILoginData;
  end;

  // Disconnect (logout)

  TSynoAPILogoutReq = class(TSynoRequest)
    constructor Create; overload;
  end;

  TSynoAPILogoutRes = class(TSynoResponse);

  // Token

  TSynoAuthTokenReq = class(TSynoRequest)
    constructor Create; overload;
  end;

  TSynoAuthTokenData = class(TJsonXBaseEx2Type)
    Ftoken: variant;
  end;

  TSynoAuthTokenRes = class(TSynoResponse)
    Fdata: TSynoAuthTokenData;
  end;

implementation

{ TSynoAuthAPIQueryReq }

constructor TSynoAPIQueryReq.Create;
begin
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'query';
  Fversion := 1;
end;

{ TSynoAuthLoginReq }

constructor TSynoAPILoginReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'login';
  Fversion := 3;
end;

{ TSynoAuthLogoutReq }

constructor TSynoAPILogoutReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'logout';
  Fversion := 7;
end;

{ TSynoAuthTokenReq }

constructor TSynoAuthTokenReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'token';
  Fversion := 6;
end;

end.

