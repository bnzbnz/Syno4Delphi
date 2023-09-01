unit uSyno.Types;

/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///

interface
uses Classes, uJsonX, uJsonX.Types;

type

  TSynoUnknown = class(TJsonXBaseEx2Type);

  TSynoRequest  = class(TJsonXBaseEx2Type)
    Fapi: variant;
    Fmethod: variant;
    Fversion: variant;
    function QueryString(URLEnc: Boolean = True): string;
    constructor Create(Api, Method: string; Version: Integer); overload;
  end;

  TSynoErrorList = class(TJsonXBaseEx2Type)
    Fcode: variant;
    Fpath: variant;
  end;

  TSynoResponseError = class(TJsonXBaseEx2Type)
    Fcode: variant;
    [AJsonXClassType(TSynoErrorList)]
    Ferrors: TJsonXObjListType;
  end;

  TSynoResponse = class(TJsonXBaseEx2Type)
    Fapi: variant; // Optional
    Fmethod: variant; // Optional
    Fversion: variant; // Optional
    Fsuccess: variant;
    Ferror: TSynoResponseError;
    constructor Create; overload;
    constructor Create(FromJSON: string); overload;
  end;

  TSynoDevice = class(TObject)
    Packet: AnsiString;
    PacketType: UInt32;
    Name: string;
    Model: string;
    Description: string;
    Serial: string;
    OS: string;
    FirmMajor: string;
    FirmMinor: UInt32;
    FirmUpdate: UInt32;
    FirmDate: UInt32;
    IP: string;
    FromIP: string;
    FromMAC: string;
    Subnet: string;
    MAC: string;
    Port: UInt32;
    PortSSL: UInt32;
    Dns: string;
    Gateway: string;
  end;

implementation
uses Variants, Sysutils, RTTI, uJsonX.RTTI, uJsonX.Utils;

{ TSynoRequest }

constructor TSynoRequest.Create(Api, Method : string; Version: Integer);
begin
  Inherited Create;
  Fapi := Api;
  Fmethod := Method;
  Fversion := Version;
end;

function TSynoRequest.QueryString(URLEnc: Boolean = True): string;
begin
  Result := '';
  var Fields := GetFields(Self);
  var Query := TStringList.Create(' ', '&');
  for var RTTIField in Fields do
  begin
    var RName := Copy(TJsonX.PropertyNameDecode(RTTIField.Name), 2, MAXINT);
    if RTTIField.FieldType.TypeKind in [tkVariant] then
    begin
      var V := RTTIField.GetValue(Self).AsVariant;
      case FindVarData(V)^.VType of
        varEmpty, varNull:;
        varBoolean: Query.Add(RName + '=' + BStrL[Boolean(V)]);
      else
        begin
          if URLEnc then
            Query.Add(RName + '=' + URLEncode(VarToStr(V)))
          else
            Query.Add(RName + '=' + VarToStr(V))
        end;
      end;
    end;
  end;
  Result := Query.DelimitedText;
  Query.Free;
end;

{ TSynoResponse }

constructor TSynoResponse.Create(FromJSON: string);
begin
  Inherited Create;
  TJsonX.parser(Self, FromJSON);
end;

constructor TSynoResponse.Create;
begin
  Inherited Create;
end;

end.
