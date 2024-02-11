unit uSyno;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///

interface
uses
  SysUtils, NetEncoding, Classes, IdURI,
  System.Net.HttpClientComponent, System.Net.HttpClient,
  uJsonX, uJsonX.Types,
  uJsonX.Utils,
  uSyno.Core.Types,
  uSyno.Types,
  uSyno.API.Types,
  uSyno.FileStation.Types;

type
  TSyno = class(TPersistent)
  private
    FHttpHost: string;
    FUsername: string;
    FPassword : string;
    FSid: string;
    FDid: string;
    FHttp: THTTPCLient;
    FlastURL: string;
    FLastReq: string;
    FLastRes: string;
    FLastErr: Integer;
    FDevice: TSynoDevice;
  protected
    function HTTPGet<Res: class, constructor>(Req: TSynoRequest): Res; overload;
    function HTTPGet<Res: class, constructor>(API, Method: string; Version: Integer; Req: TSynoRequest): Res; overload;
    function HTTPGetStream(Req: TSynoRequest): TMemoryStream; overload;
    function HTTPGetStream(API, Method: string; Version: Integer; Req: TSynoRequest): TMemoryStream; overload;

    function HTTPPost<Res: class, constructor>(Req: TSynoRequest): Res;

  published
    property LastRequest: string read FLastReq;
    property LastResponse: string read FLastRes;
    property LastError: Integer read FLastErr;
    property Device: TSynoDevice read FDevice write FDevice;
  public
    constructor Create(HttpHost, Username, Password : string); overload;
    destructor Destroy; override;

    function HTTPGetDebug(Url: string): string;
    function HTTPMultiGet(Mode, StopOnError: variant; Reqs: array of TSynoRequest): TSynoCore_EntryRequestRes;
    function HTTPMultiPost(Mode, StopOnError: variant; Reqs: array of TSynoRequest): TSynoCore_EntryRequestRes;

    {$REGION  'Auth Impl.'}
      // https://global.synologydownload.com/download/Document/Software/DeveloperGuide/Os/DSM/All/enu/DSM_Login_Web_API_Guide_enu.pdf

      function Auth_APIQuery(Req: TSynoAPIQueryReq): TSynoAPIQueryRes; // (p13)
      function Auth_Login(Req: TSynoAPILoginReq): TSynoAPILoginRes; overload; // (p15)
      function Auth_Login: Boolean; overload;
      function Auth_Logout(Req: TSynoAPILogoutReq): TSynoAPILogoutRes; overload; // (p17)
      function Auth_Logout: Boolean; overload;
      function Auth_Token(Req: TSynoAuthTokenReq): TSynoAuthTokenRes; overload; // (p17)
      function Auth_Token: TSynoAuthTokenRes; overload;

    {$ENDREGION}

    {$REGION  'Core Impl.'}
      //Reverse engineering
      function Core_Restart: boolean; // undocumented
      function Core_Shutdown: boolean; // undocumented
      function Core_FanSpeed: TSynoCoreFanSpeedRes;
      function Core_SystemInfo: TSynoCore_SystemInfoRes;

      function Core_Storage_Volume_List: TCore_Storage_Volume_List_Res; overload;
      function Core_Storage_Volume_List(Req: TCore_Storage_Volume_List_Req): TCore_Storage_Volume_List_Res; overload;
    {$ENDREGION}

    {$REGION  'FileStation Impl.'}
      //https://global.synologydownload.com/download/Document/Software/DeveloperGuide/Package/FileStation/All/enu/Synology_File_Station_API_Guide.pdf

      // Provide File Station information. (p21)
      function FS_Info(Req: TSynoFSInfoReq): TSynoFSInfoRes; overload;
      function FS_Info: TSynoFSInfoRes; overload;

      // List all shared folders, enumerate files in a shared folder, and get
      // detailed file information. (p23)
      function FS_Shares(Req: TSynoFSListSharesReq): TSynoFSListSharesRes;

      // Enumerate files in a given folder. (p29)
      function FS_Enum(Req: TSynoFSEnumReq): TSynoFSEnumRes;

      // Get information of file(s). (p35)
      function FS_Files(Req: TSynoFSFilesReq): TSynoFSFilesRes;

      // Start to search files according to given criteria. If more than one criterion
      // is given in different parameters, searched files match all these criteria. (p39)
      function FS_SearchStart(Req: TSynoFSStartSearchReq): TSynoFSStartSearchRes;

      // List matched files in a search temporary database. You can check the
      // finished value in response to know if the search operation is processing
      // or has been finished. (p41)
      function FS_SearchList(Req: TSynoFSListSearchReq): TSynoFSListSearchRes;

      // Stop the searching task(s). The search temporary database won't be
      // deleted, so it's possible to list the search result using list method
      // after stopping it. (p45)
      function FS_SearchStop(Req: TSynoFSStopSearchReq): TSynoFSStopSearchRes;

      // Delete search temporary database(s). (p45);
      function FS_SearchClean(Req: TSynoFSCleanSearchReq): TSynoFSCleanSearchRes;

      // List all mount point folders of virtual file system, e.g., CIFS or ISO. (p47)
      function FS_VirtualList(Req: TSynoFSVirtualListReq): TSynoFSVirtualListRes;

      // List user's favorites. (p51)
      function FS_FavList(Req: TSynoFSFavListReq): TSynoFSFavListRes;

      // Add a folder to user's favorites. (p53)
      function FS_FavAdd(Req: TSynoFSFavAddReq): TSynoFSFavAddRes;

      // Delete a favorite in user's favorites. (p54)
      function FS_FavDelete(Req: TSynoFSFavDeleteReq): TSynoFSFavDeleteRes;

      // Delete all broken statuses of favorites. (p55)
      function FS_FavClean(Req: TSynoFSFavCleanReq): TSynoFSFavCleanRes;

      // Edit a favorite name. (p55)
      function FS_FavEdit(Req: TSynoFSFavEditReq): TSynoFSFavEditRes;

      // Replace multiple favorites of folders to the existing user's favorites. (p56)
      function FS_FavAll(Req: TSynoFSFavAllReq): TSynoFSFavAllRes;

      // Get a thumbnail of a file. (p57)
      function FS_Thumb(Req: TSynoFSThumbReq): TMemoryStream;

      // Get the accumulated size of files/folders within folder(s). (p59)
      function FS_SizeStart(Req: TSynoFSSizeStartReq): TSynoFSSizeStartRes;

      // Get the status of the size calculating task. (p60)
      function FS_SizeStatus(Req: TSynoFSSizeStatusReq): TSynoFSSizeStatusRes;

      // Stop the size calculation. (p60)
      function FS_SizeStop(Req: TSynoFSSizeStopReq): TSynoFSSizeStopRes;

      //  Get MD5 of a file. (p62)
      function FS_MD5Start(Req: TSynoFSMD5StartReq): TSynoFSMD5StartRes;

      // Get the status of the MD5 calculation task. (p63)
      function FS_MD5Status(Req: TSynoFSMD5StatusReq): TSynoFSMD5StatusRes;

      // Stop calculating the MD5 of a file. (p63)
      function FS_MD5Stop(Req: TSynoFSMD5StopReq): TSynoFSMD5StopRes;

      // Check if a logged-in user has write permission to create new files/folders in a given folder. (p65)
      function FS_PermWrite(Req: TSynoFSPermWriteReq): TSynoFSPermWriteRes;

      // Upload a file. (p67)
      function FS_UploadFile(Filename: string; Req: TSynoFSUploadFileReq; Stream: TStream): TSynoFSUploadFileRes;

      // Download file(s)/folder(s). (p71)
      function FS_DownloadFiles(FilesList: string; Stream: TStream): TSynoFSDownloadFilesRes;

      // Get information of a sharing link by the sharing link ID. (p73)
      function FS_ShareInfo(Req: TSynoFSShareInfoReq): TSynoFSShareInfoRes;

      // List user's file sharing links. (p74)
      function FS_ShareList(Req: TSynoFSShareListReq): TSynoFSShareListRes;

      // Generate one or more sharing link(s) by file/folder path(s). (p75)
      function FS_ShareCreate(Req: TSynoFSShareCreateReq): TSynoFSShareCreateRes;

      // Delete one or more sharing links. (p77)
      function FS_ShareDelete(Req: TSynoFSShareDeleteReq): TSynoFSShareDeleteRes;

      // Remove all expired and broken sharing links. (p77)
      function FS_ShareClear(Req: TSynoFSShareCreateReq): TSynoFSShareCreateRes;

      // Edit sharing link(s). (p78)
      function FS_ShareEdit(Req: TSynoFSShareEditReq): TSynoFSShareEditRes;

      // Create folders. (p80)
      function FS_FolderCreate(Req: TSynoFSFolderCreateReq): TSynoFSFolderCreateRes;

      // Create folders. (p83)
      function FS_Rename(Req: TSynoFSRenameReq): TSynoFSRenameRes;

      // Start to copy/move files. (p86)
      function FS_CopyMoveStart(Req: TSynoFSCopyMoveStartReq): TSynoFSCopyMoveStartRes;

      // Get the copying/moving status. (p87)
      function FS_CopyMoveStatus(Req: TSynoFSCopyMoveStatusReq): TSynoFSCopyMoveStatusRes;

      // Stop a copy/move task. (p88)
      function FS_CopyMoveStop(Req: TSynoFSCopyMoveStopReq): TSynoFSCopyMoveStopRes;

      // Delete file(s)/folder(s). (p90)
      function FS_DeleteStart(Req: TSynoFSDeleteStartReq): TSynoFSDeleteStartRes;

      // Get the deleting status. (p91)
      function FS_DeleteStatus(Req: TSynoFSDeleteStatusReq): TSynoFSDeleteStatusRes;

      // Stop a delete task. (p92)
      function FS_DeleteStop(Req: TSynoFSDeleteStopReq): TSynoFSDeleteStopRes;

      // Delete files/folders. This is a blocking method. (p93)
      function FS_Delete(Req: TSynoFSDeleteReq): TSynoFSDeleteRes;

      // Start to extract an archive. (p95)
      function FS_EXtractStart(Req: TSynoFSExtractStartReq): TSynoFSExtractStartRes;

      // Get the extract task status. (p97)
      function FS_ExtractStatus(Req: TSynoFSExtractStatusReq): TSynoFSExtractStatusRes;

      // Stop the extract task. (p97)
      function FS_ExtractStop(Req: TSynoFSExtractStopReq): TSynoFSExtractStopRes;

      // List archived files contained in an archive. (p98)
      function FS_ExtractList(Req: TSynoFSExtractListReq): TSynoFSExtractListRes;

      // Start to compress file(s)/folder(s). (p102)
      function FS_CompressStart(Req: TSynoFSCompressStartReq): TSynoFSCompressStartRes;

      // Get the compress task status. (p104)
      function FS_CompressStatus(Req: TSynoFSCompressStatusReq): TSynoFSCompressStatusRes;

      // Stop the compress task. (p104)
      function FS_CompressStop(Req: TSynoFSCompressStopReq): TSynoFSCompressStopRes;

      // List all background tasks including copy, move, delete, compress and extract tasks. (p106)
      function FS_BackTaskList(Req: TSynoFSBackTaskListReq): TSynoFSBackTaskListRes;

      // Delete all finished background tasks. (p110)
      function FS_BackTaskClear(Req: TSynoFSBackTaskClearReq): TSynoFSBackTaskClearRes;
    {$ENDREGION}

  end;

implementation
uses  dialogs, variants, System.Generics.Collections, System.Net.URLClient,
      System.NetConsts;

{$REGION 'TSyno' }

constructor TSyno.Create(HttpHost, Username, Password: string);
begin
  inherited Create;
  Self.FHttpHost := HttpHost;
  Self.FUsername := Username;
  Self.FPassword := Password;
  FHttp := THTTPCLient.Create;
  FHTTP.ConnectionTimeout := 250;
end;

destructor TSyno.Destroy;
begin
  FHttp.Free;
  inherited;
end;

function TSyno.HTTPGet<Res>(Req: TSynoRequest): Res;
begin
  Result:= nil;
  FLastURL := '';
  FLastReq := '';
  FLastRes := '';
  FLastErr := 0;
  var HTTPRes: IHTTPResponse;
  var FLastURL :=  Format('%s/webapi/entry.cgi?%s&_sid=%s', [FHttpHost, Req.QueryString, FSid]);
  FHTTP.ContentType := 'application/json';
  try HTTPRes := FHTTP.Get( FLastURL ); except end;
  if HTTPRes = nil then Exit;
  FLastErr := HTTPRes.StatusCode;
  FLastRes := HTTPRes.ContentAsString(TEncoding.UTF8);
  var JsonXParams := TJsonXSystemParameters.Create(nil,[jxoWarnOnMissingField]);
  Result := TJsonX.parser<Res>(FLastRes, JsonXParams);
  JsonXParams.Free;
end;

function TSyno.HTTPGet<Res>(API, Method: string; Version: Integer; Req: TSynoRequest): Res;
begin
  Req.Fapi := API;
  Req.Fmethod := Method;
  Req.Fversion := Version;
  Result := HTTPGet<Res>(Req);
end;

function TSyno.HTTPGetDebug(Url: string): string;
begin
  var HTTPRes: IHTTPResponse;
  var FURL := FHttpHost + '/webapi/entry.cgi?' + Url + '&_sid=' + FSid ;
  try HTTPRes := FHTTP.Get( FURL ); except end;
  Result := HTTPRes.ContentAsString(TEncoding.UTF8);
end;

function TSyno.HTTPGetStream(Req: TSynoRequest): TMemoryStream;
begin
  Result:= TMemoryStream.Create;
  FLastReq := '';
  FLastErr := 0;
  var HTTPRes: IHTTPResponse;
  var URL :=  Format(
                  '%s/webapi/entry.cgi?api=%s&method=%s&version=%s&_sid=%s&%s'
                 , [FHttpHost, Req.Fapi, Req.Fmethod, Req.Fversion, FSid, Req.QueryString]
              );
  FLastReq := URL;
  try
    try HTTPRes := FHTTP.Get( URL, Result ); except end;
    if HTTPRes = nil then raise Exception.Create('Invalid Request');
    FLastErr := HTTPRes.StatusCode;
    if FLastErr <> 200 then raise Exception.Create('Invalid HTTP Code');
  except
    FreeAndNil(Result);
  end;
end;

function TSyno.HTTPGetStream(API, Method: string; Version: Integer; Req: TSynoRequest): TMemoryStream;
begin
  Req.Fapi := API;
  Req.Fmethod := Method;
  Req.Fversion := Version;
  Result := HTTPGetStream(Req);
end;

function TSyno.HTTPMultiGet(Mode, StopOnError: Variant; Reqs: array of TSynoRequest): TSynoCore_EntryRequestRes;
begin
  Result := nil;
  var HTTPRes: IHTTPResponse := nil;
  var JSonXParams: TJsonXSystemParameters := nil;
  var Req := TSynoCore_EntryRequestReq.Create('SYNO.Entry.Request', 'request', 1);
  try
    Req.Fstopwhenerror := StopOnError;
    Req.Fmode := '"' + Mode + '"';

    FHTTP.ContentType := 'application/json';
    try HTTPRes := FHTTP.Get( FHttpHost + '/webapi/entry.cgi?' + Req.BuildURL(Reqs) + '&_sid=' + FSid ); except end;
    if HTTPRes = nil then Exit;
    var Body := HTTPRes.ContentAsString(TEncoding.UTF8);

    JSonXParams := TJsonXSystemParameters.Create(nil, [jxoGetRaw]);
    Result := TJsonX.Parser<TSynoCore_EntryRequestRes>(Body, JSonXParams);
 finally
    JSonXParams.Free;
    Req.Free;
  end;
end;

function TSyno.HTTPPost<Res>(Req: TSynoRequest): Res;
begin
  Result:= nil;
  FLastURL := '';
  FLastReq := '';
  FLastRes := '';
  FLastErr := 0;
  var Body : TStringStream := nil;
  var HTTPRes: IHTTPResponse;
  try
    var URL :=  Format('%s/webapi/entry.cgi?_sid=%s', [FHttpHost, FSid]);
    Body := TStringStream.Create(Req.QueryString);
    FLastURL := URL;
    FLastReq := Body.DataString;
    FHTTP.ContentType := 'application/json';
    try HTTPRes := FHTTP.Post( URL, Body ); except end;
    if HTTPRes = nil then Exit;
    FLastErr := HTTPRes.StatusCode;
    FLastRes := HTTPRes.ContentAsString(TEncoding.UTF8);
    Result := Res.Create;
    if not TJsonX.parser(Result, FLastRes) then
    begin
      FLastErr := -1;
      FreeAndNil(Result);
    end;
  finally
    Body.Free;
  end;
end;

function TSyno.HTTPMultiPost(Mode, StopOnError: variant; Reqs: array of TSynoRequest): TSynoCore_EntryRequestRes;
begin
  Result := nil;
  FLastURL := '';
  FLastReq := '';
  FLastRes := '';
  FLastErr := 0;
  var HTTPRes: IHTTPResponse := nil;
  var JsonXParams: TJsonXSystemParameters := nil;
  var ReqBody : TStringStream := nil;
  var Req := TSynoCore_EntryRequestReq.Create('SYNO.Entry.Request', 'request', 1);
  try
    Req.Fstopwhenerror := StopOnError;
    Req.Fmode := '"' + Mode + '"';
    FLastReq := Req.BuildURL(Reqs);
    ReqBody := TStringStream.Create(FLastReq);
    FHTTP.ContentType := 'application/json';
    FLastURL := FHttpHost + '/webapi/entry.cgi?_sid=' + FSid;
    try HTTPRes := FHTTP.Post(FLastURL, ReqBody); except end;
    if HTTPRes = nil then Exit;
    FLastErr := HTTPRes.StatusCode;
    FLastRes := HTTPRes.ContentAsString(TEncoding.UTF8);
    JsonXParams := TJsonXSystemParameters.Create(nil, [jxoGetRaw]);
    Result := TJsonX.Parser<TSynoCore_EntryRequestRes>(FLastRes, JSonXParams);
  finally
    ReqBody.Free;
    Req.Free;
    JSonXParams.Free;
  end;
end;

{$ENDREGION}

{$REGION 'Auth'}

function TSyno.Auth_APIQuery(Req: TSynoAPIQueryReq): TSynoAPIQueryRes;
begin
  Result := HTTPGet<TSynoAPIQueryRes>(Req);
end;

function TSyno.Auth_Login(Req: TSynoAPILoginReq): TSynoAPILoginRes;
begin
  Result := HTTPGet<TSynoAPILoginRes>(Req);
end;

function TSyno.Auth_Login: Boolean;
begin
  Result := False;
  var Req := TSynoAPILoginReq.Create;
  var Res: TSynoAPILoginRes := nil;
  try
    Req.Faccount := FUsername;
    Req.Fpasswd :=  FPassword;
    Req.Fformat := 'sid';
    Req.Fsession := StringGUID;
    Res := Auth_Login(Req);
    if (Res = nil) then Exit;
    if (Res.Fdata = nil) then Exit;
    FSid := Res.Fdata.Fsid;
    FDid := Res.Fdata.Fdid;
    Result := Res.Fsuccess;
  finally
    Res.Free;
    Req.Free;
  end;
end;

function TSyno.Auth_Logout(Req: TSynoAPILogoutReq): TSynoAPILogoutRes;
begin
  Result := HTTPGet<TSynoAPILogoutRes>(Req);
end;

function TSyno.Auth_Logout: Boolean;
begin
  Result := False;
  var Req := TSynoAPILogoutReq.Create;
  var Res: TSynoAPILogoutRes := nil;
  try
    Res :=  Auth_Logout(Req);
    if Res = nil then Exit;
    Result := Res.Fsuccess;
  finally
    Res.Free;
    Req.Free;
  end;
  Exit;
end;

function TSyno.Auth_Token(Req: TSynoAuthTokenReq): TSynoAuthTokenRes;
begin
  Result := HTTPGet<TSynoAuthTokenRes>(Req);
end;

function TSyno.Auth_Token: TSynoAuthTokenRes;
begin
  Result := nil;
  var Req :=  TSynoAuthTokenReq.Create;
  try
    Result := HTTPGet<TSynoAuthTokenRes>(Req);
  finally
    Req.Free;
  end;
end;


{$ENDREGION}

{$REGION 'Core'}

function TSyno.Core_Restart: Boolean;
begin
  Result := False;
  var Req := TSynoCoreRestartReq.Create;
  var Res: TSynoCoreRestartRes := nil;
  try
    Req.Fforce := False;
    Req.Flocal := True;
    Req.Ffirmware_5Fupgrade := False;
    Req.Fcache_5Fcheck_5Fshutdown := False;
    Res := HTTPGet<TSynoCoreRestartRes>(Req);
    if Res = nil then Exit;
    Result := Res.Fsuccess;
  finally
    Res.Free;
    Req.Free;
  end;
 end;

function TSyno.Core_Shutdown: Boolean;
begin
  Result := False;
  var Req := TSynoCoreShutdownReq.Create;
  var Res: TSynoCoreShutdownRes := nil;
  try
    Res := HTTPGet<TSynoCoreShutdownRes>(Req);
    if Res = nil then Exit;
    Result := Res.Fsuccess;
  finally
    Res.Free;
    Req.Free;
  end;
 end;

function TSyno.Core_FanSpeed: TSynoCoreFanSpeedRes;
begin
  Result := nil;
  var Req :=  TSynoCoreFanSpeedReq.Create;
  try
    Result := HTTPGet<TSynoCoreFanSpeedRes>(Req);
  finally
    Req.Free;
  end;
 end;

function TSyno.Core_SystemInfo: TSynoCore_SystemInfoRes;
begin
  Result := nil;
  var Req :=  TSynoCore_SystemInfoReq.Create;
  try
    Result := HTTPGet<TSynoCore_SystemInfoRes>(Req);
  finally
    Req.Free;
  end;
end;

function TSyno.Core_Storage_Volume_List(Req: TCore_Storage_Volume_List_Req): TCore_Storage_Volume_List_Res;
begin
  Result := HTTPGet<TCore_Storage_Volume_List_Res>(Req);
end;

function TSyno.Core_Storage_Volume_List: TCore_Storage_Volume_List_Res;
begin
  Result := nil;
  var Req :=  TCore_Storage_Volume_List_Req.Create;
  try
    Req.Flimit := -1;
    Req.Foffset := 0;
    Req.Flocation:='all';
    Req.Foption := 'include_cold_storage';
    Result := Core_Storage_Volume_List(Req);
  finally
    Req.Free;
  end;
end;


{$ENDREGION}

{$REGION 'FileStation'}

// Provide File Station information. (p21)
function TSyno.FS_Info(Req: TSynoFSInfoReq): TSynoFSInfoRes;
begin
  Result := HTTPGet<TSynoFSInfoRes>(Req);
end;

function TSyno.FS_Info: TSynoFSInfoRes;
begin
  var Req := TSynoFSInfoReq.Create;
  try
    Result := FS_Info(Req);
  finally
    Req.Free;
  end;

end;

// List all shared folders, enumerate files in a shared folder, and get
// detailed file information. (p23)
function TSyno.FS_Shares(Req: TSynoFSListSharesReq): TSynoFSListSharesRes;
begin
  Result := HTTPGet<TSynoFSListSharesRes>(Req);
end;

// Enumerate files in a given folder. (p29)
function TSyno.FS_Enum(Req: TSynoFSEnumReq): TSynoFSEnumRes;
begin
  Result := HTTPGet<TSynoFSEnumRes>(Req);
end;

// Get information of file(s). (p35)
function TSyno.FS_Files(Req: TSynoFSFilesReq): TSynoFSFilesRes;
begin
  Result := HTTPGet<TSynoFSFilesRes>(Req);
end;

// Start to search files according to given criteria. If more than one criterion
// is given in different parameters, searched files match all these criteria. (p39)
function TSyno.FS_SearchStart(Req: TSynoFSStartSearchReq): TSynoFSStartSearchRes;
begin
  Result := HTTPGet<TSynoFSStartSearchRes>(Req);
end;

// List matched files in a search temporary database. You can check the
// finished value in response to know if the search operation is processing
// or has been finished. (p41)
function TSyno.FS_SearchList(Req: TSynoFSListSearchReq): TSynoFSListSearchRes;
begin
  Result := HTTPGet<TSynoFSListSearchRes>(Req);
end;

// Stop the searching task(s). The search temporary database won't be
// deleted, so it's possible to list the search result using list method
// after stopping it. (p45)
function TSyno.FS_SearchStop(Req: TSynoFSStopSearchReq): TSynoFSStopSearchRes;
begin
  Result := HTTPGet<TSynoFSStopSearchRes>(Req);
end;

// Delete search temporary database(s). (p45);
function TSyno.FS_SearchClean(Req: TSynoFSCleanSearchReq): TSynoFSCleanSearchRes;
begin
  Result := HTTPGet<TSynoFSCleanSearchRes>(Req);
end;

// List all mount point folders of virtual file system, e.g., CIFS or ISO. (p47)
function TSyno.FS_VirtualList(Req: TSynoFSVirtualListReq): TSynoFSVirtualListRes;
begin
  Result := HTTPGet<TSynoFSVirtualListRes>(Req);
end;

// List user's favorites. (p51)
function TSyno.FS_FavList(Req: TSynoFSFavListReq): TSynoFSFavListRes;
begin
  Result := HTTPGet<TSynoFSFavListRes>(Req);
end;

// Add a folder to user's favorites. (p53)
function TSyno.FS_FavAdd(Req: TSynoFSFavAddReq): TSynoFSFavAddRes;
begin
  Result := HTTPGet<TSynoFSFavAddRes>(Req);
end;

// Delete a favorite in user's favorites. (p54)
function TSyno.FS_FavDelete(Req: TSynoFSFavDeleteReq): TSynoFSFavDeleteRes;
begin
  Result := HTTPGet<TSynoFSFavDeleteRes>(Req);
end;

// Delete all broken statuses of favorites. (p55)
function TSyno.FS_FavClean(Req: TSynoFSFavCleanReq): TSynoFSFavCleanRes;
begin
  Result := HTTPGet<TSynoFSFavCleanRes>(Req);
end;

// Edit a favorite name. (p55)
function TSyno.FS_FavEdit(Req: TSynoFSFavEditReq): TSynoFSFavEditRes;
begin
  Result := HTTPGet<TSynoFSFavEditRes>(Req);
end;

// Replace multiple favorites of folders to the existing user's favorites. (p56)
function TSyno.FS_FavAll(Req: TSynoFSFavAllReq): TSynoFSFavAllRes;
begin
  Result := HTTPGet<TSynoFSFavAllRes>(Req);
end;

// Get a thumbnail of a file. (p57)
function TSyno.FS_Thumb(Req: TSynoFSThumbReq): TMemoryStream;
begin
  Result := HTTPGetStream(Req);
end;

// Get the accumulated size of files/folders within folder(s). (p59)
function TSyno.FS_SizeStart(Req: TSynoFSSizeStartReq): TSynoFSSizeStartRes;
begin
  Result := HTTPGet<TSynoFSSizeStartRes>(Req);
end;

// Get the status of the size calculating task. (p60)
function TSyno.FS_SizeStatus(Req: TSynoFSSizeStatusReq): TSynoFSSizeStatusRes;
begin
  Result := HTTPGet<TSynoFSSizeStatusRes>(Req);
end;

// Stop the size calculation. (p61)
function TSyno.FS_SizeStop(Req: TSynoFSSizeStopReq): TSynoFSSizeStopRes;
begin
  Result := HTTPGet<TSynoFSSizeStopRes>(Req);
end;

//  Get MD5 of a file. (p62)
function TSyno.FS_MD5Start(Req: TSynoFSMD5StartReq): TSynoFSMD5StartRes;
begin
  Result := HTTPGet<TSynoFSMD5StartRes>(Req);
end;

// Get the status of the MD5 calculation task. (p63)
function TSyno.FS_MD5Status(Req: TSynoFSMD5StatusReq): TSynoFSMD5StatusRes;
begin
  Result := HTTPGet<TSynoFSMD5StatusRes>(Req);
end;

// Stop calculating the MD5 of a file. (p63)
function TSyno.FS_MD5Stop(Req: TSynoFSMD5StopReq): TSynoFSMD5StopRes;
begin
  Result := HTTPGet<TSynoFSMD5StopRes>(Req);
end;

// Check if a logged-in user has write permission to create new files/folders in a given folder. (p65)
function TSyno.FS_PermWrite(Req: TSynoFSPermWriteReq): TSynoFSPermWriteRes;
begin
  Result := HTTPGet<TSynoFSPermWriteRes>(Req);
end;

// Upload a file. (p67)
function TSyno.FS_UploadFile(Filename: string; Req: TSynoFSUploadFileReq; Stream: TStream): TSynoFSUploadFileRes;
const
  CRLF = #$D#$A;

  function JsonVarToStr(V: variant): variant;
  begin
    var LA := FindVarData(V)^;
    case LA.VType of
      varBoolean:
        if V then Result := 'true' else Result := 'false';
    else
      Result := VarToStr(V);
    end;
  end;

begin
  Result := nil;
  var ReqMS := TMemoryStream.Create;
  var ResMS := TMemoryStream.Create;
  var Dic: TDictionary<string, Variant> := nil;

  try
      var URL :=  Format(
                  '%s/webapi/entry.cgi?api=%s&method=%s&version=%s&_sid=%s'
                 , [FHttpHost,'SYNO.FileStation.Upload', 'upload', '2', FSid]
              );
    var Boundary := '----' + StringGUID;
    Dic := TJsonX.PropertiesNameValue(Req);
    for var Pair in Dic do
    begin
      if not VarIsEmpty(Pair.Value) then
      begin
        ReqMs.WriteRawAnsiString(AnsiString('--' + Boundary + CRLF));
        ReqMS.WriteRawAnsiString(AnsiString(
          Format('Content-Disposition: form-data; name="%s"' + CRLF + CRLF +'%s'+ CRLF, [Pair.Key, JsonVarToStr(Pair.Value)])
        ));
      end;
    end;
    ReqMs.WriteRawAnsiString(AnsiString('--' + Boundary + CRLF));
    ReqMS.WriteRawAnsiString(AnsiString('Content-Disposition: form-data; name="file"; filename="'+ Filename + '"' + CRLF));
    ReqMS.WriteRawAnsiString(AnsiString('Content-Type: application/octet-stream' + CRLF + CRLF));
    ReqMS.CopyFrom(Stream, -1);
    ReqMS.WriteRawAnsiString(AnsiString(CRLF + '--' + Boundary  + '--' + CRLF));
    FHTTP.CustomHeaders['Content-Type'] := 'multipart/form-data; boundary=' + Boundary;
    ReqMS.Position := 0;
    //FLastReq := ReqMS.ReadRawString(TEncoding.UTF8);
    var HTTPRes : IHTTPResponse := nil;
    try HTTPRes := FHTTP.Post(Url, ReqMS, ResMS); except end;
    FLastErr := HTTPRes.StatusCode;
    //FLastRes := HTTPRes.ContentAsString(TEncoding.UTF8) ;
    Result := TSynoFSUploadFileRes.Create;
    TJsonX.parser(Result, FLastRes);
  finally
    ResMS.Free;
    Dic.Free;
    ReqMS.Free;
  end;
end;

// Download file(s)/folder(s). (p71)
function TSyno.FS_DownloadFiles(FilesList: string; Stream: TStream): TSynoFSDownloadFilesRes;
begin
  Result:= nil;
  FLastReq := '';
  FLastErr := 0;
  var HTTPRes: IHTTPResponse;
  try
    var FLastReq :=  Format(
                    '%s/webapi/entry.cgi?api=SYNO.FileStation.Download&method="download"&version=2&mode=download&path=%s&_sid=%s'
                   , [FHttpHost, URLEncode(FilesList), FSid]
                );
    try HTTPRes := FHTTP.Get( FLastReq, Stream ); except end;
    if HTTPRes = nil then Exit;
    FLastErr := HTTPRes.StatusCode;
    FLastRes := HTTPRes.ContentAsString(TEncoding.ANSI);
    Result := TSynoFSDownloadFilesRes.Create;
    Result.Fsuccess := FLastErr = 200;
    if not Result.Fsuccess then
    begin
      Result.Ferror := TSynoResponseError.Create;
      Result.Ferror.Fcode := FLastErr;
    end;
  finally
  end;
end;

// Get information of a sharing link by the sharing link ID. (p73)
function TSyno.FS_ShareInfo(Req: TSynoFSShareInfoReq): TSynoFSShareInfoRes;
begin
  Result := HTTPGet<TSynoFSShareInfoRes>(Req);
end;

// List user's file sharing links. (p74)
function TSyno.FS_ShareList(Req: TSynoFSShareListReq): TSynoFSShareListRes;
begin
  Result := HTTPGet<TSynoFSShareListRes>(Req);
end;

// Generate one or more sharing link(s) by file/folder path(s). (p75)
function TSyno.FS_ShareCreate(Req: TSynoFSShareCreateReq): TSynoFSShareCreateRes;
begin
  Result := HTTPGet<TSynoFSShareCreateRes>(Req);
end;

// Delete one or more sharing links. (p77)
function TSyno.FS_ShareDelete(Req: TSynoFSShareDeleteReq): TSynoFSShareDeleteRes;
begin
  Result := HTTPGet<TSynoFSShareDeleteRes>(Req);
end;

// Remove all expired and broken sharing links. (p77)
function TSyno.FS_ShareClear(Req: TSynoFSShareCreateReq): TSynoFSShareCreateRes;
begin
  Result := HTTPGet<TSynoFSShareCreateRes>(Req);
end;

// Edit sharing link(s). (p78)
function TSyno.FS_ShareEdit(Req: TSynoFSShareEditReq): TSynoFSShareEditRes;
begin
  Result := HTTPGet<TSynoFSShareEditRes>(Req);
end;

// Create folders. (p80)
function TSyno.FS_FolderCreate(Req: TSynoFSFolderCreateReq): TSynoFSFolderCreateRes;
begin
  Result := HTTPGet<TSynoFSFolderCreateRes>(Req);
end;

// Create folders. (p83)
function TSyno.FS_Rename(Req: TSynoFSRenameReq): TSynoFSRenameRes;
begin
  Result := HTTPGet<TSynoFSRenameRes>(Req);
end;

// Start to copy/move files. (p86)
function TSyno.FS_CopyMoveStart(Req: TSynoFSCopyMoveStartReq): TSynoFSCopyMoveStartRes;
begin
  Result := HTTPGet<TSynoFSCopyMoveStartRes>(Req);
end;

// Get the copying/moving status. (p87)
function TSyno.FS_CopyMoveStatus(Req: TSynoFSCopyMoveStatusReq): TSynoFSCopyMoveStatusRes;
begin
  Result := HTTPGet<TSynoFSCopyMoveStatusRes>(Req);
end;

// Stop a copy/move task. (p88)
function TSyno.FS_CopyMoveStop(Req: TSynoFSCopyMoveStopReq): TSynoFSCopyMoveStopRes;
begin
  Result := HTTPGet<TSynoFSCopyMoveStopRes>(Req);
end;

// Delete file(s)/folder(s). (p90)
function TSyno.FS_DeleteStart(Req: TSynoFSDeleteStartReq): TSynoFSDeleteStartRes;
begin
  Result := HTTPGet<TSynoFSDeleteStartRes>(Req);
end;

// Get the deleting status. (p91)
function TSyno.FS_DeleteStatus(Req: TSynoFSDeleteStatusReq): TSynoFSDeleteStatusRes;
begin
  Result := HTTPGet<TSynoFSDeleteStatusRes>(Req);
end;

// Stop a delete task. (p92)
function TSyno.FS_DeleteStop(Req: TSynoFSDeleteStopReq): TSynoFSDeleteStopRes;
begin
  Result := HTTPGet<TSynoFSDeleteStopRes>(Req);
end;

// Delete files/folders. This is a blocking method. (p93)
function TSyno.FS_Delete(Req: TSynoFSDeleteReq): TSynoFSDeleteRes;
begin
  Result := HTTPGet<TSynoFSDeleteRes>(Req);
end;

// Start to extract an archive. (p95)
function TSyno.FS_ExtractStart(Req: TSynoFSExtractStartReq): TSynoFSExtractStartRes;
begin
  Result := HTTPGet<TSynoFSExtractStartRes>(Req);
end;

// Get the extract task status. (p97)
function TSyno.FS_ExtractStatus(Req: TSynoFSExtractStatusReq): TSynoFSExtractStatusRes;
begin
  Result := HTTPGet<TSynoFSExtractStatusRes>(Req);
end;

// Stop the extract task. (p97)
function TSyno.FS_ExtractStop(Req: TSynoFSExtractStopReq): TSynoFSExtractStopRes;
begin
  Result := HTTPGet<TSynoFSExtractStopRes>(Req);
end;

// List archived files contained in an archive. (p98)
function TSyno.FS_ExtractList(Req: TSynoFSExtractListReq): TSynoFSExtractListRes;
begin
  Result := HTTPGet<TSynoFSExtractListRes>(Req);
end;

// Start to compress file(s)/folder(s). (p102)
function TSyno.FS_CompressStart(Req: TSynoFSCompressStartReq): TSynoFSCompressStartRes;
begin
  Result := HTTPGet<TSynoFSCompressStartRes>(Req);
end;

// Get the compress task status. (p104)
function TSyno.FS_CompressStatus(Req: TSynoFSCompressStatusReq): TSynoFSCompressStatusRes;
begin
  Result := HTTPGet<TSynoFSCompressStatusRes>(Req);
end;

// Stop the compress task. (p104)
function TSyno.FS_CompressStop(Req: TSynoFSCompressStopReq): TSynoFSCompressStopRes;
begin
  Result := HTTPGet<TSynoFSCompressStopRes>(Req);
end;

// List all background tasks including copy, move, delete, compress and extract tasks. (p106)
function TSyno.FS_BackTaskList(Req: TSynoFSBackTaskListReq): TSynoFSBackTaskListRes;
begin
  Result := HTTPGet<TSynoFSBackTaskListRes>(Req);
end;

// Delete all finished background tasks. (p110)
function TSyno.FS_BackTaskClear(Req: TSynoFSBackTaskClearReq): TSynoFSBackTaskClearRes;
begin
  Result := HTTPGet<TSynoFSBackTaskClearRes>(Req);
end;






{$ENDREGION}

{$REGION 'Extra'}

{$ENDREGION}

end.
