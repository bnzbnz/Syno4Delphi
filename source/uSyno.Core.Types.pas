unit uSyno.Core.Types;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///

interface
uses System.Generics.Collections, uJsonX, uJsonX.Types, uSyno.Types;

type

  // Core_Restart

  TSynoCoreRestartReq = class(TSynoRequest)
    Fforce: variant;
    Flocal: variant;
    Ffirmware_5Fupgrade: variant;
    Fcache_5Fcheck_5Fshutdown: variant;
  end;
  TSynoCoreRestartRes = class(TSynoResponse);

  // Core_Shutdown

  TSynoCoreShutdownReq = class(TSynoRequest);
  TSynoCoreShutdownRes = class(TSynoResponse);

  // Core_FanSpeed
  // SYNO.Core.Hardware.FanSpeed : get : 1

  TSynoCoreFanSpeedReq = class(TSynoRequest);

  TSynoCoreFanSpeedData = class(TJsonXBaseEx2Type)
    Fall_5Fdisk_5Ftemp_5Ffail: variant;
    Fcool_5ffan: variant;
    Fdual_5Ffan_5Fspeed: variant;
    Ffan_5Fsupport_5Fadjust_5Fby_5Fext_5Fnic: variant;
    Ffan_5Ftype: variant;
  end;

  TSynoCoreFanSpeedRes = class(TSynoResponse)
    Fdata: TSynoCoreFanSpeedData;
  end;

  // Core_SystemInfo
  // api=SYNO.Core.System : info : 3

  TSynoCore_SystemInfoReq = class(TSynoRequest);

  TSynoCore_external_pci_slot_info = class(TJsonXBaseEx2Type)
    Fcardname: variant;
    FOccupied: variant;
    FRecognized: variant;
    Fslot: variant;
  end;

  TSynoCore_SystemInfoData = class(TJsonXBaseEx2Type)
    Fcpu_5Fclock_5Fspeed: variant;
    Fcpu_5Fcores: variant;
    Fcpu_5Ffamily: variant;
    Fcpu_5Fseries: variant;
    Fcpu_vendor: variant;
    Fenabled_5Fntp: variant;
    [AJsonXClassType(TSynoCore_external_pci_slot_info)]
    Fexternal_5Fpci_5Fslot_5Finfo: TJSonXObjListType;
    Ffirmware_5Fdate: variant;
    Ffirmware_5Fver: variant;
    Fmodel: variant;
    Fntp_5Fserver: variant;
    Fram_5Fsize: variant;
    [AJsonXClassType(TSynoUnknown)]
    Fsata_5Fdev: TJSonXObjListType;
    Fserial: variant;
    Fsupport_5Fesata: variant;
    Fsys_5Ftemp: variant;
    Fsys_5Ftempwarn: variant;
    Fsystempwarn: variant;
    Ftemperature_5Fwarning: variant;
    Ftime: variant;
    Ftime_5Fzone: variant;
    Ftime_5Fzone_5Fdesc: variant;
    Fup_5Ftime: variant;
  end;

  TSynoCore_SystemInfoRes = class(TSynoResponse)
    Fdata: TSynoCore_SystemInfoData;
  end;

  // SYNO.Core.Storage.Volume : list : 1
  TCore_Storage_Volume_List_Req = class(TSynoRequest)
    Flimit: variant;
    Foffset: variant;
    Flocation: variant;
    Foption: variant;
  end;

  TCore_Storage_Volume = class(TJsonXBaseEx2Type)
    Fatime_5Fchecked: variant;
    Fatime_5Fopt: variant;
    Fcontainer: variant;
    Fcrashed: variant;
    Fdeduped: variant;
    Fdescription: variant;
    Fdisplay_5Fname: variant;
    Ffs_5Ftype: variant;
    Fis_5Fencrypted: variant;
    Flocation: variant;
    Fpool_5Fpath: variant;
    Fraid_5Ftype: variant;
    Freadonly: variant;
    Fsingle_5Fvolume: variant;
    Fsize_5Ffree_5Fbyte: variant;
    Fsize_5Ftotal_5Fbyte: variant;
    Fstatus: variant;
    Fvolume_5Fattribute: variant;
    Fvolume_5Fid: variant;
    Fvolume_5Fpath: variant;
    Fvolume_5Fquota_5Fstatus: variant;
    Fvolume_5Fquota_5Fupdate_5Fprogress: variant;
  end;

  TCore_Storage_Volume_List_Data = class(TJsonXBaseEx2Type)
    Foffset: variant;
    Ftotal: variant;
    [AJsonXClassType(TCore_Storage_Volume)]
    Fvolumes: TJsonXObjListType;
  end;

  TCore_Storage_Volume_List_Res = class(TSynoResponse)
    Fdata: TCore_Storage_Volume_List_Data;
  end;


  // SPECIAL : Multi Call, see
  // SYNO.Entry.Request : request : 1

  TSynoCore_EntryRequestReq = class(TSynoRequest)
  public
    Fstopwhenerror: variant;
    Fmode: variant;
    function BuildURL(Reqs: array of TSynoRequest): string;
  end;

  TSynoCore_Response_Element = class(TJsonXBaseEx2Type)
    Fapi: variant;
    Fmethod: variant;
    Fversion: variant;
    Fsuccess: variant;
    function NS: string;
  end;

  TSynoCore_EntryRequestData = class(TJsonXBaseEx2Type)
    Fhas_5Ffail: variant;
    [AJsonXClassType(TSynoCore_Response_Element)]
    Fresult : TJsonXObjListType;
  end;

  TSynoCore_EntryRequestRes = class(TSynoRequest)
    Fdata: TSynoCore_EntryRequestData;
  end;

implementation
uses uJsonX.Utils, Sysutils, Variants;

{ TSynoCore_EntryRequestReq }

function TSynoCore_EntryRequestReq.BuildURL(Reqs: array of TSynoRequest): string;
var
  QueryParts: array of string;
begin
  for var Request in Reqs do
  begin
    SetLength(QueryParts, length(QueryParts) +1);
    QueryParts[length(QueryParts)-1] := TJsonX.Writer(Request);
  end;
  var Query := URLEncode( '[' + String.Join(',', QueryParts)+ ']' );
  Result := Self.QueryString(True) + '&compound=' + Query;
end;

{ TSynoCore_EntryRequest_Element }

function TSynoCore_Response_Element.NS: string;
begin
  Result := Fapi + ':' + Fmethod + ':' + varToStr(Fversion);
end;

end.
