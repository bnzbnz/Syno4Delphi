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

  TSynoAuthAPIQueryReq = class(TSynoRequest)
    Fquery: variant;
    constructor Create; overload;
  end;

  TSynoAuthAPIQueryData = class(TJsonXBaseEx2Type)
    Fkey: variant;
    Fpath: variant;
    FminVersion: variant;
    FmaxVersion: variant;
    FrequestFormat: variant;
  end;

  TSynoAuthAPIQueryRes = class(TSynoResponse)
    [AJsonXClassType(TSynoAuthAPIQueryData)]
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
    constructor Create; overload;
  end;

  TSynoAuthLoginRes = class(TSynoResponse)
    Fdata: TSynoAuthLoginData;
  end;

  // Disconnect (logout)

  TSynoAuthLogoutReq = class(TSynoRequest)
    constructor Create; overload;
  end;

  TSynoAuthLogoutRes = class(TSynoResponse);

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

constructor TSynoAuthAPIQueryReq.Create;
begin
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'query';
  Fversion := 1;
end;

{ TSynoAuthLoginReq }

constructor TSynoAuthLoginReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.API.Auth';
  Fmethod := 'login';
  Fversion := 3;
end;

{ TSynoAuthLogoutReq }

constructor TSynoAuthLogoutReq.Create;
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

