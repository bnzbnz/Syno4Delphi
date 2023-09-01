unit uSyno.FileStation.Types;

/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// References:
/// https://global.download.synology.com/download/Document/Software/DeveloperGuide/Package/FileStation/All/enu/Synology_File_Station_API_Guide.pdf
/// License: MPL 1.1 / GPL 2.1
///

interface
uses uJsonX, uJsonX.Types, uSyno.Types;

type

//==>> Generic Types.
  {$REGION 'Generic'}

  TSynoFS_Owner = class(TJsonXBaseEx2Type)
    Fuser: variant;
    Fgroup: variant;
    Fuid: variant;
    Fgid: variant;
  end;

  TSynoFS_Time = class(TJsonXBaseEx2Type)
    Fatime: variant;
    Fmtime: variant;
    Fctime: variant;
    Fcrtime: variant;
  end;

  TSynoFS_AdvRight = class(TJsonXBaseEx2Type)
    Fdisable_5Fdownload: variant;
    Fdisable_5Flist: variant;
    Fdisable_5Fmodify: variant;
  end;

  TSynoFS_Acl = class(TJsonXBaseEx2Type)
    Fappend: variant;
    Fdel: variant;
    Fexec: variant;
    Fread: variant;
    Fwrite: variant;
  end;

  TSynoFS_Perm = class(TJsonXBaseEx2Type)
    Fshare_5Fright: variant;
    Fposix: variant;
    Fadv_5Fright: TSynoFS_AdvRight;
    Facl_5Fenable: variant;
    Fis_5Facl_5Fmode: variant;
    Facl: TSynoFS_Acl;
  end;

  TSynoFS_File_Additional = class(TJsonXBaseEx2Type)
    Freal_path: variant;
    Fsize: variant;
    Fowner: TSynoFS_Owner;
    Ftime: TSynoFS_Time;
    Fperm: TSynoFS_Perm;
    Fmount_5Fpoint_5Ftype: variant;
    Ftype: variant;
  end;

  TSynoFS_Volume_Status = class(TJsonXBaseEx2Type)
    Ffreespace: variant;
    Ftotalspace: variant;
    Freadonly: variant;
  end;

  TSynoFS_Virtual_Folder_Additional = class(TJsonXBaseEx2Type)
    Freal_path: variant;
    Fowner: TSynoFS_Owner;
    Ftime: TSynoFS_Time ;
    Fperm: TSynoFS_Perm;
    Fmount_5Fpoint_5Ftype: variant;
    Fvolume_status: TSynoFS_volume_status;
  end;

  TSynoFS_Virtual_Folder = class(TJsonXBaseEx2Type)
    Fpath: variant;
    Fname: variant;
    Fadditional: TSynoFS_virtual_folder_additional;
  end;

  TSynoFS_sharing_link = class(TJsonXBaseEx2Type)
    Fdate_available: variant;
    Fdate_expired: variant;
    Fhas_password: variant;
    Fid: variant;
    FisFolder: variant;
    Flink_owner: variant;
    Fname: variant;
    Fpath: variant;
    Fstatus: variant;
    Furl: variant;
  end;

  TSynoFS_file = class(TJsonXBaseEx2Type)
    Fpath: variant;
    Fname: variant;
    Fisdir: variant;
    Fadditional: TSynoFS_File_Additional;
  end;

  TSynoFS_archive_item = class(TJsonXBaseEx2Type)
    Fitemid: variant;
    Fname: variant;
    Fsize: variant;
    Fpack_size: variant;
    Fmtime: variant;
    Fpath: variant;
    Fis_dir: variant;
  end;

  {$ENDREGION}

//==>> SYNO.FileStation.Info
//==>> Provide File Station information.
//==>> (p21)

    // get
    // Provide File Station information.
    // => FS_Info
    // (p21)
    {$REGION 'Info'}
    TSynoFSInfoReq = class(TSynoRequest)
      constructor Create; overload;
    end;

    TSynoFSInfoItem = class(TJsonXBaseEx2Type)
      Fgid: variant;
    end;

    TSynoFSInfoVirtual = class(TJsonXBaseEx2Type)
      Fenable_5Fiso_5Fmount: variant;
      Fenable_5Fremote_5Fmount: variant;
    end;

    TSynoFSInfoResData = class(TJsonXBaseEx2Type)
      Fenable_5Flist_5Fusergrp: variant;
      Fenable_5Fsend_5Femail_5Fattachment: variant;
      Fenable_5Fview_5Fgoogle: variant;
      Fenable_5Fview_5Fmicrosoft: variant;
      Fhostname: variant;
      Fis_manager: variant;
      [AJsonXClassType(TSynoFSInfoItem)]
      Fitems: TJsonXObjListType;
      Fsupport_5Ffile_5Frequest: variant;
      Fsupport_5Fsharing: variant;
      Fsupport_5Fvfs: variant;
      Fsupport_5Fvirtual: TSynoFSInfoVirtual;
      Fsupport_5Fvirtual_5Fprotocol: TJsonXVarListType;
      Fsystem_5Fcodepage: variant;
      Fuid: variant;
    end;

    TSynoFSInfoRes = class(TSynoResponse)
      Fdata: TSynoFSInfoResData;
    end;
    {$ENDREGION}

//==>> SYNO.FileStation.List
//==>> List all shared folders, enumerate files in a shared folder, and get
//==>> detailed file information.
//==>> (p23)

    // list_share
    // List all shared folders.
    // => FS_Shares
    // (p23)
    {$REGION 'List Share'}
    TSynoFSListSharesReq = class(TSynoRequest)
      Foffset: variant;
      Flimit: variant;
      Fsort_5Fby: variant;
      Fsort_5Fdirection: variant;
      Fonlywritable: variant;
      Fadditional: variant;
      constructor Create; overload;
    end;

    TSynoFSShareAdditional = class(TJsonXBaseEx2Type)
      Freal_5Fpath: variant;
      Fowner: TSynoFS_Owner;
      Ftime: TSynoFS_Time;
      Fperm: TSynoFS_Perm;
    end;

    TSynoFSShare = class(TJsonXBaseEx2Type)
      Fisdir: variant;
      Fname: variant;
      Fpath: variant;
      Fadditional: TSynoFSShareAdditional;
      Fmount_5Fpoint_5Ftype: variant;
      Fvolume_5Fstatus: TSynoFS_volume_status;
    end;

    TSynoFSSharesData = class(TJsonXBaseEx2Type)
      Foffset: variant;
      [AJsonXClassType(TSynoFSShare)]
      Fshares: TJsonXObjListType;
      Ftotal: variant;
    end;

    TSynoFSListSharesRes = class(TSynoResponse)
      Fdata: TSynoFSSharesData;
    end;
    {$ENDREGION}

    // list
    // Enumerate files in a given folder.
    // => FS_Enum
    // (p29)
    {$REGION 'Enum Files'}

    TSynoFSEnumReq = class(TSynoRequest)
      Ffolder_5Fpath: variant;
      Foffset: variant;
      Flimit: variant;
      Fsort_5Fby: variant;
      Fsort_5Fdirection: variant;
      Fpattern: variant;
      Ffiletype: variant;
      Fgoto_5Fpath: variant;
      Fadditional: variant;
      constructor Create; overload;
    end;

    TSynoFSEnumChildren = class;

    TSynoFSEnumFile = class(TJsonXBaseEx2Type)
      Fpath: variant;
      Fname: variant;
      Fisdir: variant;
      Fchildren: TSynoFSEnumChildren;
      Fadditional: TSynoFS_File_Additional;
    end;

    TSynoFSEnumChildren = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFSEnumFile)]
      Ffiles: TJsonXObjListType;
    end;

    TSynoFSEnumData = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFSEnumFile)]
      Ffiles: TJsonXObjListType;
    end;

    TSynoFSEnumRes = class(TSynoResponse)
      Fdata: TSynoFSEnumData;
    end;


    {$ENDREGION}

    // getinfo
    // Get information of file(s).
    // => FS_Files
    // (p35)
    {$REGION 'Files Info'}

    TSynoFSFilesReq = class(TSynoRequest)
     Fpath: variant;
     Fadditional: variant;
     constructor Create; overload;
    end;

    TSynoFSFilesData = class(TJsonXBaseEx2Type)
      [AJsonXClassType(TSynoFS_file)]
      Ffiles: TJsonXObjListType;
    end;

    TSynoFSFilesRes = class(TSynoResponse)
     Fdata: TSynoFSFilesData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Search
//==>> Search files according to given criteria. This is a non-blocking API.
//==>> You need to start to search files with the  start  method. Then, you
//==>> should poll requests with  list  method to get more information, or make a
//==>> request with the  stop  method to cancel the operation. Otherwise, search
//==>> results are stored in a search temporary database so you need to call
//==>> clean method to delete it at the end of operation.
//==>> (p39)

    // start
    // Start to search files according to given criteria. If more than one
    // criterion is given in different parameters, searched files match all
    // these criteria.
    // => FS_SearchStart
    // (p39)
    {$REGION 'Search Start'}

    TSynoFSStartSearchReq = class(TSynoRequest)
     Ffolder_5Fpath: variant;
     Frecursive: variant;
     Fpattern: variant;
     Fextension: variant;
     Ffiletype: variant;
     Fsize_5Ffrom: variant;
     Fsize_5Fto: variant;
     Fmtime_5Ffrom: variant;
     Fmtime_5Fto: variant;
     Fcrtime_5Ffrom: variant;
     Fcrtime_5Fto: variant;
     Fartime_5Ffrom: variant;
     Fartime_5Fto: variant;
     Fowner: variant;
     Fgroup: variant;
     constructor Create; overload;
    end;

    TSynoFSStartSearchData = class(TJsonXBaseEx2Type)
      Ftaskid: variant;
      Fhas_5Fnot_5Findex_5Fshare: variant;
    end;

    TSynoFSStartSearchRes = class(TSynoResponse)
      Fdata: TSynoFSStartSearchData;
    end;

    {$ENDREGION}

    // list
    // List matched files in a search temporary database. You can check the
    // finished value in response to know if the search operation is processin
    // or has been finished.
    // => FS_SearchList
    // (p41)
    {$REGION 'Search List'}

    TSynoFSListSearchReq = class(TSynoRequest)
      Ftaskid: variant;
      Foffset: variant;
      Flimit: variant;
      Fsort_5Fby: variant;
      Fsort_5Fdirection: variant;
      Fpattern: variant;
      Ffiletype: variant;
      Fadditional: variant;
      constructor Create; overload;
    end;

    TSynoFSListSearchData = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      Ffinished: variant;
      [AJsonXClassType(TSynoFSEnumFile)]
      Ffiles: TJsonXObjListType;
    end;
    TSynoFSListSearchRes = class(TSynoResponse)
      Fdata: TSynoFSListSearchData;
    end;

    {$ENDREGION}

    // stop
    // Stop the searching task(s). The search temporary database won't be
    // deleted, so it's possible to list the search result using list method
    // after stopping it.
    // => FS_SearchStop
    // (p45)
    {$REGION 'Search Stop'}

    TSynoFSStopSearchReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSStopSearchRes = class(TSynoResponse)
    end;

    {$ENDREGION}

    // clean
    // Delete search temporary database(s).
    // => FS_SearchClean
    // (p45)
    {$REGION 'Search Clean'}

    TSynoFSCleanSearchReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCleanSearchData = class(TJsonXBaseEx2Type)

    end;

    TSynoFSCleanSearchRes = class(TSynoResponse)
      Fdata: TSynoFSCleanSearchData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.VirtualFolder
//==>> List all mount point folders of virtual file system, e.g., CIFS or ISO.
//==>> (p47)

    // list
    // List all mount point folders on one given type of virtual file system.
    // => FS_VirtualList
    // (p47)
    {$REGION 'Virtual List'}

    TSynoFSVirtualListReq = class(TSynoRequest)
      Ftype: variant;
      Foffset: variant;
      Flimit: variant;
      Fsort_5Fby: variant;
      Fsort_5Fdirection: variant;
      Fadditional: variant;
      constructor Create; overload;
    end;

    TSynoFSVirtualListData = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFS_virtual_folder)]
      Ffolders: TJsonXObjListType;
    end;

    TSynoFSVirtualListRes = class(TSynoResponse)
      Fdata: TSynoFSVirtualListData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Favorite
//==>> Add a folder to user's favorites or perform operations on user's favorites.
//==>> (p51)

    // list
    // List user's favorites.
    // => FS_FavList
    // (p51)
    {$REGION 'Favorites List'}

    TSynoFSFavListReq = class(TSynoRequest)
        Foffset: variant;
        Flimit: variant;
        Fstatus_5Ffilter: variant;
        Fadditional: variant;
        constructor Create; overload;
      end;

    TSynoFS_favorite_additional = class(TJsonXBaseEx2Type)
      Freal_path: variant;
      Fowner: TSynoFS_Owner;
      Ftime: TSynoFS_Time;
      Fperm: TSynoFS_Perm;
      Fmount_point_type: variant;
      Ftype: variant;
    end;

    TSynoFS_favorite = class(TJsonXBaseEx2Type)
      Fpath: variant;
      Fname: variant;
      Fstatus: variant;
      Fadditional: TSynoFS_favorite_additional;
    end;

    TSynoFSFavListData = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFS_favorite)]
      Ffavorites: TJsonXObjListType;
    end;

    TSynoFSFavListRes = class(TSynoResponse)
      Fdata: TSynoFSFavListData;
    end;

    {$ENDREGION}

    // add
    // Add a folder to user's favorites.
    // => FS_FavAdd
    // (p53)
    {$REGION 'Favorite Add'}

    TSynoFSFavAddReq = class(TSynoRequest)
      Fpath: variant;
      Fname: variant;
      Findex: variant;
      constructor Create; overload;
    end;

    TSynoFSFavAddRes = class(TSynoResponse);

    {$ENDREGION}

    // delete
    // Delete a favorite in user's favorites.
    // => FS_FavDelete
    // (p54)
    {$REGION 'Favorite Delete'}

    TSynoFSFavDeleteReq = class(TSynoRequest)
      Fpath: variant;
      constructor Create; overload;
    end;

    TSynoFSFavDeleteRes = class(TSynoResponse);

    {$ENDREGION}

    // clean (clear_broken)
    // Delete all broken statuses of favorites.
    // => FS_FavClean
    // (p55)
    {$REGION 'Favorite clean'}

    TSynoFSFavCleanReq = class(TSynoRequest)
      Fpath: variant;
      constructor Create; overload;
    end;

    TSynoFSFavCleanRes = class(TSynoResponse);

    {$ENDREGION}

    // edit
    // Edit a favorite name.
    // => FS_FavEdit
    // (p55)
    {$REGION 'Favorite edit'}

    TSynoFSFavEditReq = class(TSynoRequest)
      Fpath: variant;
      Fname: variant;
      constructor Create; overload;
    end;

    TSynoFSFavEditRes = class(TSynoResponse);

    {$ENDREGION}

    // replace all (relace_all)
    // Replace multiple favorites of folders to the existing user's favorites.
    // => FS_FavAll
    // (p56)
   {$REGION 'Favorite replace all'}

    TSynoFSFavAllReq = class(TSynoRequest)
      Fpath: variant;
      Fname: variant;
      constructor Create; overload;
    end;

    TSynoFSFavAllRes = class(TSynoResponse);

    {$ENDREGION}

//==>> SYNO.FileStation.Thumb
//==>> Get a thumbnail of a file.
//==>> 1. Supported image formats: jpg, jpeg, jpe, bmp, png, tif, tiff, gif,
//==>> arw, srf, sr2, dcr, k25, kdc, cr2, crw, nef, mrw, ptx, pef, raf, 3fr, erf,
//==>> mef, mos, orf, rw2, dng, x3f, heic, raw.
//==>> 2. Supported video formats in
//==>> an indexed folder: 3gp, 3g2, asf, dat, divx, dvr-ms, m2t, m2ts, m4v, mkv,
//==>> mp4, mts, mov, qt, tp, trp, ts, vob, wmv, xvid, ac3, amr, rm, rmvb, ifo,
//==>> mpeg, mpg, mpe, m1v, m2v, mpeg1, mpeg2, mpeg4, ogv, webm, flv, f4v, avi,
//==>> swf, vdr, iso, hevc.
//==>> 3. Video thumbnails exist only if video files are placed in the "photo"
//==>> shared folder or users' home folders.
//==>> (p57)

    // get
    // Get a thumbnail of a file.
    // => FS_FavThumb
    // (p57)
    {$REGION 'Thumb'}

    TSynoFSThumbReq = class(TSynoRequest)
      Fpath: variant;
      Fsize: variant;
      Frotate: variant;
      constructor Create; overload;
    end;

    TSynoFSThumbRes = class(TSynoResponse);

    {$ENDREGION}

//==>> SYNO.FileStation.DirSize
//==>> Get the accumulated size of files/folders within folder(s).
//==>> This is a non-blocking API. You need to start it with the  start  method.
//==>> Then, you should poll requests with the status  method to get progress
//==>> status or make a request with  stop  method to cancel the operation.

    //  start
    //  Start to calculate size for one or more file/folder paths.
    //  => FS_SizeStart
    //  (p59)
    {$REGION 'Size Start'}

    TSynoFSSizeStartReq = class(TSynoRequest)
      Fpath: variant;
      constructor Create; overload;
    end;

    TSynoFSSizeStartData = class(TSynoResponse)
      Ftaskid: variant;
    end;

    TSynoFSSizeStartRes = class(TSynoResponse)
      Fdata: TSynoFSSizeStartData;
    end;

    {$ENDREGION}

    //  status
    //  Get the status of the size calculating task.
    //  => FS_SizeStatus
    //  (p60)
    {$REGION 'Size Status'}

    TSynoFSSizeStatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSSizeStatusData = class(TJsonXBaseEx2Type)
      Ffinished: variant;
      Fnum_dir: variant;
      Fnum_file: variant;
      Ftotal_size: variant;
    end;

    TSynoFSSizeStatusRes = class(TSynoResponse)
      Fdata: TSynoFSSizeStatusData;
    end;

    {$ENDREGION}

    //  stop
    //  Stop the calculation.
    //  => FS_SizeStop
    //  (p61)
    {$REGION 'Size Stop'}

    TSynoFSSizeStopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSSizeStopRes = class(TSynoResponse)
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.MD5
//==>> This is a non-blocking API. You need to start it with the  start  method.
//==>> Then, you should poll requests with status  method to get the progress
//==>> status, or make a request with the  stop  method to cancel the operation.

    // start
    // Get MD5 of a file.
    // => FS_MD5Start
    // (p62)
    {$REGION 'MD5 Start'}

    TSynoFSMD5StartReq = class(TSynoRequest)
      Ffile_path: variant;
      constructor Create; overload;
    end;

    TSynoFSMD5StartData = class(TSynoResponse)
      Ftaskid: variant;
    end;

    TSynoFSMD5StartRes = class(TSynoResponse)
      Fdata: TSynoFSMD5StartData;
    end;

    {$ENDREGION}

    // status
    // Get the status of the MD5 calculation task.
    // => FS_MD5Status
    // (p63)
     {$REGION 'MD5 Status'}

    TSynoFSMD5StatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSMD5StatusData = class(TJsonXBaseEx2Type)
      Ffinished: variant;
      Fmd5: variant;
    end;

    TSynoFSMD5StatusRes = class(TSynoResponse)
      Fdata: TSynoFSMD5StatusData;
    end;

    {$ENDREGION}

    // stop
    // Stop calculating the MD5 of a file.
    // => FS_MD5Stop
    // (p63)
    {$REGION 'MD5 Stop'}

    TSynoFSMD5StopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSMD5StopRes = class(TSynoResponse)
    end;

    {$ENDREGION}

  // SYNO.FileStation.CheckPermission
  // Check if a logged-in user has permission to do file operations on a
  // given folder/file.

    // write
    // Check if a logged-in user has permission to do file operations on a
    // given folder/file.
    // (p65)
    {$REGION 'Perm Write'}

    TSynoFSPermWriteReq = class(TSynoRequest)
      Fpath: variant;
      Ffilename: variant;
      Foverwrite: variant;
      Fcreate_only: variant;
      constructor Create; overload;
    end;

    TSynoFSPermWriteRes = class(TSynoResponse)
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Upload
//==>> Upload a file.

    // upload
    // Upload a file by RFC 1867, http://tools.ietf.org/html/rfc1867.
    // Note that each parameter is passed within each part but binary file data
    // must be the last part.
    // (p67)
    {$REGION 'File Upload'}

    TSynoFSUploadFileReq = class(TJsonXBaseEx2Type)
      Foverwrite: variant;
      Fpath: variant;
      Fcrtime: variant;
      Fatime: variant;
      Fmtime: variant;
      Fsize: variant;
      Fcreate_parents: variant;
      constructor Create; overload;
     end;

    TSynoFSUploadFileData = class(TJsonXBaseEx2Type)
      FblSkip: variant;
      Ffile: variant;
      Fpid: variant;
      Fprogress: variant;
    end;

    TSynoFSUploadFileRes = class(TSynoResponse)
      Fdata: TSynoFSUploadFileData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Download
//==>> Download file(s)/folder(s).

    // download
    // Download files/folders. If only one file is specified, the file content
    // is responded. If more than one file/folder is given, binary content in
    // ZIP format which they are compressed to is responded.
    // (p71)
    {$REGION 'Files Download'}

    (*
    TSynoFSDownloadFilesReq = class(TJsonXBaseEx2Type)
      Fpath: variant;
      Fmode: variant;
     end;
    *)

    TSynoFSDownloadFilesRes = class(TSynoResponse)
      constructor Create; overload;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Sharing
//==>> Generate a sharing link to share files/folders with other people and
//==>> perform operations on sharing link(s).

    // getinfo
    // Get information of a sharing link by the sharing link ID.
    // (p73)
    {$REGION 'Share GetInfo'}

    TSynoFSShareInfoReq = class(TSynoRequest)
      Fid: variant;
      constructor Create; overload;
    end;

    TSynoFSShareInfoRes = class(TSynoResponse)
      Fdata: TSynoFS_sharing_link;
    end;

    {$ENDREGION}

    // list
    // List user's file sharing links.
    // (p74)
    {$REGION 'Share list'}

    TSynoFSShareListReq = class(TSynoRequest)
      Foffset: variant;
      Flimit: variant;
      Fsort_by: variant;
      Fsort_direction: variant;
      Fforce_clean: variant;
      constructor Create; overload;
    end;

    TSynoFSShareListData = class(TSynoResponse)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFS_sharing_link)]
      Flinks: TJsonXObjListType;
    end;

    TSynoFSShareListRes = class(TSynoResponse)
      Fdata: TSynoFSShareListData;
    end;

    {$ENDREGION}

    // create
    // Generate one or more sharing link(s) by file/folder path(s).
    // (p75)
    {$REGION 'Share Create'}

    TSynoFSShareCreateReq = class(TSynoRequest)
      Fpath: variant;
      Fpassword: variant;
      Fdate_expired: variant;
      Fdate_available: variant;
      constructor Create; overload;
     end;

    TSynoFS_shared_link_app = class(TJsonXBaseEx2Type)
      Fenable_5Fupload: variant;
      Fis_5Ffolder: variant;
    end;

    TSynoFS_shared_link = class(TJsonXBaseEx2Type)
      Fapp: TSynoFS_shared_link_app;
      Fdate_5Favailable: variant;
      Fdate_5Fexpired: variant;
      Fenable_5Fupload: variant;
      Fexpire_5Ftimes: variant;
      Fhas_5Fpassword: variant;
      Fid: variant;
      FisFolder: variant;
      Flimit_5Fsize: variant;
      Flink_5Fowner: variant;
      Fname: variant;
      Fpath: variant;
      Fproject_5Fname: variant;
      Fprotect_5Fgroups: TJsonXVarListType;
      Fprotect_5Ftype: variant;
      Fprotect_5Fusers: TJsonXVarListType;
      Fqrcode: variant;
      Frequest_5Finfo: variant;
      Frequest_5Fname: variant;
      Fstatus: variant;
      Fuid: variant;
      Furl: variant;
    end;

    TSynoFSShareCreateData = class(TJsonXBaseEx2Type)
      Fhas_5Ffolder: variant;
      [AJsonXClassType(TSynoFS_shared_link)]
      Flinks: TJsonXObjListType;
    end;

    TSynoFSShareCreateRes = class(TSynoResponse)
      Fdata: TSynoFSShareCreateData;
    end;

    {$ENDREGION}

    // delete
    // Delete one or more sharing links.
    // (p77)
    {$REGION 'Share Delete'}

    TSynoFSShareDeleteReq = class(TSynoRequest)
      Fid: variant;
      constructor Create; overload;
    end;

    TSynoFSShareDeleteRes = class(TSynoResponse);

    {$ENDREGION}

    // clear_invalid
    // Remove all expired and broken sharing links
    // (p77)
    {$REGION 'Share Clear'}

    TSynoFSShareClearReq = class(TSynoRequest)
      constructor Create; overload;
    end;

    TSynoFSShareClearRes = class(TSynoResponse);

    {$ENDREGION}

    // edit
    // Edit sharing link(s).
    // (p78)
    {$REGION 'Share Edit'}

    TSynoFSShareEditReq = class(TSynoRequest)
      Fid: variant;
      Fpassword: variant;
      Fdate_expired: variant;
      Fdate_available: variant;
      constructor Create; overload;
    end;

    TSynoFSShareEditRes = class(TSynoResponse);

    {$ENDREGION}

//==>> SYNO.FileStation.CreateFolder
//==>> Create folders.
//==>> (p80)

    // create
    // Create folders.
    // (p80)
    {$REGION 'Folder Create'}

    TSynoFSFolderCreateReq = class(TSynoRequest)
      Ffolder_path: variant;
      Fname: variant;
      Fforce_parent: variant;
      Fadditional: variant;
      constructor Create; overload;
    end;

     TSynoFSFolderCreateData = class(TJsonXBaseEx2Type)
      [AJsonXClassType(TSynoFS_file)]
      Ffolders: TJsonXObjListType;
    end;

    TSynoFSFolderCreateRes = class(TSynoResponse)
      Fdata: TSynoFSFolderCreateData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Rename
//==>> Rename a file/folder.
//==>> (p83)

    // rename
    // Rename a file/folder.
    // (p83)
    {$REGION 'Rename'}

    TSynoFSRenameReq = class(TSynoRequest)
      Fpath: variant;
      Fname: variant;
      Fadditional: variant;
      Fsearch_taskid: variant;
      constructor Create; overload;
    end;

    TSynoFSRenameData = class(TJsonXBaseEx2Type)
      [AJsonXClassType(TSynoFS_file)]
      Ffiles: TJsonXObjListType;
    end;

    TSynoFSRenameRes = class(TSynoResponse)
      Fdata: TSynoFSRenameData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.CopyMove
//==>> Copy/move file(s)/folder(s).
//==>> This is a non-blocking API. You need to start to copy/move files with 
//==>> start method. Then, you should poll requests with  status  method to get
//==>> the progress status, or make a request with  stop  method to cancel the
//==>> operation.
//==>> (p86)

    // start
    // Start to copy/move files.
    // (p86)
    {$REGION 'CopyMove Start'}

    TSynoFSCopyMoveStartReq = class(TSynoRequest)
      Fpath: variant;
      Fdest_folder_path: variant;
      Foverwrite: variant;
      Fremove_src: variant;
      Faccurate_progress: variant;
      Fsearch_taskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCopyMoveStartData = class(TJsonXBaseEx2Type)
      taskid: variant;
    end;

    TSynoFSCopyMoveStartRes = class(TSynoResponse)
      Fdata: TSynoFSCopyMoveStartData;
    end;

    {$ENDREGION}

    // status
    // Get the copying/moving status.
    // (p87)
    {$REGION 'CopyMove Status'}

    TSynoFSCopyMoveStatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCopyMoveStatusData = class(TJsonXBaseEx2Type)
      Fprocessed_size: variant;
      Ftotal: variant;
      Fpath: variant;
      Ffinished: variant;
      Fprogress: variant;
      Fdest_folder_path: variant;
    end;

    TSynoFSCopyMoveStatusRes = class(TSynoResponse)
      Fdata: TSynoFSCopyMoveStatusData;
    end;

    {$ENDREGION}

    // stop
    // Stop a copy/move task.
    // (p88)
    {$REGION 'CopyMove Stop'}

    TSynoFSCopyMoveStopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCopyMoveStopRes = class(TSynoResponse);

    {$ENDREGION}

//==>> SYNO.FileStation.Delete
//==>> Delete file(s)/folder(s).
//==>> This is a non-blocking method. You should poll a request with  status 
//==>> method to get more information or make a request with  stop  method to
//==>> cancel the operation.
//==>> (p90)

    // start
    // Delete file(s)/folder(s).
    // (p90)
    {$REGION 'Delete Start'}

    TSynoFSDeleteStartReq = class(TSynoRequest)
      Fpath: variant;
      Faccurate_progress: variant;
      Frecursive: variant;
      Fsearch_taskid: variant;
      constructor Create; overload;
    end;

    TSynoFSDeleteStartData = class(TJsonXBaseEx2Type)
      taskid: variant;
    end;

    TSynoFSDeleteStartRes = class(TSynoResponse)
      Fdata: TSynoFSDeleteStartData;
    end;

    {$ENDREGION}

    // status
    // Get the deleting status.
    // (p91)
    {$REGION 'Delete Status'}

    TSynoFSDeleteStatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSDeleteStatusData = class(TJsonXBaseEx2Type)
      Fprocessed_num: variant;
      Ftotal: variant;
      Fpath: variant;
      Fprocessing_path: variant;
      Ffinished: variant;
      Fprogress: variant;
    end;

    TSynoFSDeleteStatusRes = class(TSynoResponse)
      Fdata: TSynoFSDeleteStatusData;
    end;

    {$ENDREGION}

    // stop
    // Stop a delete task.
    // (p92)
    {$REGION 'Delete Stop'}

    TSynoFSDeleteStopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSDeleteStopRes = class(TSynoResponse);

    {$ENDREGION}

    // delete
    // Delete files/folders. This is a blocking method.
    // (p93)
    {$REGION 'Delete'}

    TSynoFSDeleteReq = class(TSynoRequest)
      Fpath: variant;
      Frecursive: variant;
      Fsearch_taskid: variant;
      constructor Create; overload;
    end;

    TSynoFSDeleteRes = class(TSynoResponse);

    {$ENDREGION}


//==>> SYNO.FileStation.Extract
//==>> Extract an archive and perform operations on archive files.
//==>> Note: Supported extensions of archives: zip, gz, tar, tgz, tbz, bz2,
//==>> rar, 7z, iso.
//==>> (p95);

    // start
    // Start to extract an archive.
    // (p95)
   {$REGION 'Extract Start'}

    TSynoFSExtractStartReq = class(TSynoRequest)
      Ffile_path: variant;
      Fdest_folder_path: variant;
      Foverwrite: variant;
      Fkeep_dir: variant;
      Fcreate_subfolder: variant;
      Fcodepage: variant;
      Fpassword: variant;
      Fitem_id: variant;
      constructor Create; overload;
    end;

    TSynoFSExtractStartData = class(TJsonXBaseEx2Type)
      taskid: variant;
    end;

    TSynoFSExtractStartRes = class(TSynoResponse)
      Fdata: TSynoFSExtractStartData;
    end;

    {$ENDREGION}

    // status
    // Get the extract task status.
    // (p97)
    {$REGION 'Extract Status'}

    TSynoFSExtractStatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSExtractStatusData = class(TJsonXBaseEx2Type)
      Ffinished: variant;
      Fprogress: variant;
      Fdest_folder_path: variant;
    end;

    TSynoFSExtractStatusRes = class(TSynoResponse)
      Fdata: TSynoFSExtractStatusData;
    end;

    {$ENDREGION}

    // stop
    // Stop the extract task.
    // (p97)
    {$REGION 'Extract Stop'}

    TSynoFSExtractStopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSExtractStopRes = class(TSynoResponse);

    {$ENDREGION}

    // list
    // List archived files contained in an archive.
    // (p98)
    {$REGION 'Extract List'}

    TSynoFSExtractListReq = class(TSynoRequest)
      Ffile_path: variant;
      Foffset: variant;
      Flimit: variant;
      Fsort_by: variant;
      Fsort_direction: variant;
      Fcodepage: variant;
      Fpassword: variant;
      Fitem_id: variant;
      constructor Create; overload;
    end;

    TSynoFSExtractListData = class(TJsonXBaseEx2Type)
      [AJsonXClassType(TSynoFS_archive_item)]
      Fitems: TJsonXObjListType;
      end;

    TSynoFSExtractListRes = class(TSynoResponse)
      Fdata: TSynoFSExtractListData;
    end;

    {$ENDREGION}

//==>> SYNO.FileStation.Compress
//==>> This is a non-blocking API. You need to start to compress files with the
//==>> start  method. Then, you should poll requests with the  status  method
//==>> to get compress status, or make a request with the  stop  method to
//==>> cancel the operation.
//==>> (p102);

    // start
    // Start to compress file(s)/folder(s).
    // (p102)
   {$REGION 'Compress Start'}

    TSynoFSCompressStartReq = class(TSynoRequest)
      Fpath: variant;
      Fdest_file_path: variant;
      Flevel: variant;
      Fmode: variant;
      Fformat: variant;
      Fpassword: variant;
      constructor Create; overload;
    end;

    TSynoFSCompressStartData = class(TJsonXBaseEx2Type)
      Ftaskid: variant;
    end;

    TSynoFSCompressStartRes = class(TSynoResponse)
      Fdata: TSynoFSCompressStartData;
    end;

    {$ENDREGION}

    // status
    // Get the compress task status.
    // (p104)
   {$REGION 'Compress Status'}

    TSynoFSCompressStatusReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCompressStatusData = class(TJsonXBaseEx2Type)
      Ffinished: variant;
      Fdest_file_path: variant;
    end;

    TSynoFSCompressStatusRes = class(TSynoResponse)
      Fdata: TSynoFSCompressStatusData;
    end;

    {$ENDREGION}

    // stop
    // Stop the compress task.
    // (p104)
   {$REGION 'Compress Stop'}

    TSynoFSCompressStopReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSCompressStopRes = class(TSynoResponse);

    {$ENDREGION}

//==>> SYNO.FileStation.BackgroundTask
//==>> Get information regarding tasks of file operations which is run as the
//==>> background process including copy, move, delete, compress and extract
//==>> tasks with non-blocking API/methods. You can use the status method to get
//==>> more information, or use the stop method to cancel these background tasks
//==>> in individual API, such as SYNO.FileStation.CopyMove API,
//==>> SYNO.FileStation.Delete API, SYNO.FileStation.Extract API and
//==>> SYNO.FileStation.Compress API.
//==>> (p106);

    // list
    // List all background tasks including copy, move, delete, compress and extract tasks.
    // (p106)
   {$REGION 'BackgroundTask List'}

    TSynoFSBackTaskListReq = class(TSynoRequest)
      Foffset: variant;
      Flimit: variant;
      Fsort_by: variant;
      Fsort_direction: variant;
      Fapi_filter: variant;
      constructor Create; overload;
    end;

    TSynoFS_start_task_params = class(TJsonXBaseEx2Type)
      Fpath: variant;
      Fdest_folder_path: variant;
      Foverwrite: variant;
      Fremove_src: variant;
      Faccurate_progress: variant;
      Fsearch_taskid: variant;
    end;

    TSynoFS_background_task = class(TJsonXBaseEx2Type)
      Fapi: variant;
      Fversion: variant;
      Fmethod: variant;
      Ftaskid: variant;
      Ffinished: variant;
      Fparams: TSynoFS_start_task_params;
      Fpath: variant;
      Fprocessed_num: variant;
      Fprocessed_size: variant;
      Fprocessing_path: variant;
      Ftotal: variant;
      Fprogress: variant;
      Faccurate_progress: variant;
      Frecursive: variant;
      Fsearch_taskid: variant;
      Ffile_path: variant;
      Fdest_folder_path: variant;
      Foverwrite: variant;
      Fkeep_dir: variant;
      Fcreate_subfolder: variant;
      Fcodepage: variant;
      Fpassword: variant;
      Fitem_id: variant;
      Fdest_file_path: variant;
      Flevel: variant;
      Fmode: variant;
      Fformat: variant;
    end;

    TSynoFSBackTaskListData = class(TJsonXBaseEx2Type)
      Ftotal: variant;
      Foffset: variant;
      [AJsonXClassType(TSynoFS_background_task)]
      Ftasks: TJsonXObjListType;
    end;

    TSynoFSBackTaskListRes = class(TSynoResponse)
      Fdata: TSynoFSBackTaskListData;
    end;

    {$ENDREGION}

    // clear
    // Delete all finished background tasks.
    // (p110)
   {$REGION 'BackgroundTask Stop'}

    TSynoFSBackTaskClearReq = class(TSynoRequest)
      Ftaskid: variant;
      constructor Create; overload;
    end;

    TSynoFSBackTaskClearRes = class(TSynoResponse);

    {$ENDREGION}


implementation


{ TSynoFSInfoReq }
constructor TSynoFSInfoReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Info';
  Fmethod := 'get';
  Fversion := 2;
end;

{ TSynoFSListSharesReq }

constructor TSynoFSListSharesReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.List';
  Fmethod := 'list_share';
  Fversion := 1;
end;

{ TSynoFSEnumReq }

constructor TSynoFSEnumReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.List';
  Fmethod := 'list';
  Fversion := 2;
end;

{ TSynoFSFilesReq }

constructor TSynoFSFilesReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.List';
  Fmethod := 'getinfo';
  Fversion := 2;
end;

{ TSynoFSStartSearchReq }

constructor TSynoFSStartSearchReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Search';
  Fmethod := 'start';
  Fversion := 2;
end;

{ TSynoFSListSearchReq }

constructor TSynoFSListSearchReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Search';
  Fmethod := 'list';
  Fversion := 2;
end;

{ TSynoFSStopSearchReq }

constructor TSynoFSStopSearchReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Search';
  Fmethod := 'stop';
  Fversion := 2;
end;

{ TSynoFSCleanSearchReq }

constructor TSynoFSCleanSearchReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Search';
  Fmethod := 'clean';
  Fversion := 2;
end;

{ TSynoFSVirtualListReq }

constructor TSynoFSVirtualListReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.VirtualFolder';
  Fmethod := 'list';
  Fversion := 2;
end;

{ TSynoFSFavListReq }

constructor TSynoFSFavListReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'list';
  Fversion := 1;
end;

{ TSynoFSFavAddReq }

constructor TSynoFSFavAddReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'add';
  Fversion := 2;
end;

{ TSynoFSFavDeleteReq }

constructor TSynoFSFavDeleteReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'delete';
  Fversion := 2;
end;

{ TSynoFSFavCleanReq }

constructor TSynoFSFavCleanReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'clear_broken';
  Fversion := 2;
end;

{ TSynoFSFavEditReq }

constructor TSynoFSFavEditReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'edit';
  Fversion := 2;
end;

{ TSynoFSFavAllReq }

constructor TSynoFSFavAllReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Favorite';
  Fmethod := 'replace_all';
  Fversion := 2;
end;

{ TSynoFSThumbReq }

constructor TSynoFSThumbReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Thumb';
  Fmethod := 'get';
  Fversion := 2;
end;

{ TSynoFSSizeStartReq }

constructor TSynoFSSizeStartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.DirSize';
  Fmethod := 'start';
  Fversion := 2;
end;

{ TSynoFSSizeStatusReq }

constructor TSynoFSSizeStatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.DirSize';
  Fmethod := 'status';
  Fversion := 2;
end;

{ TSynoFSSizeStopReq }

constructor TSynoFSSizeStopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.DirSize';
  Fmethod := 'stop';
  Fversion := 2;
end;

{ TSynoFSMD5StartReq }

constructor TSynoFSMD5StartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.MD5';
  Fmethod := 'start';
  Fversion := 2;
end;

{ TSynoFSMD5StatusReq }

constructor TSynoFSMD5StatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.MD5';
  Fmethod := 'status';
  Fversion := 1;
end;

{ TSynoFSMD5StopReq }

constructor TSynoFSMD5StopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.MD5';
  Fmethod := 'stop';
  Fversion := 2;
end;

{ TSynoFSPermWriteReq }

constructor TSynoFSPermWriteReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.CheckPermission';
  Fmethod := 'write';
  Fversion := 3;
end;

{ TSynoFSUploadFileReq }

constructor TSynoFSUploadFileReq.Create;
begin
  Inherited;
end;

{ TSynoFSDownloadFilesRes }

constructor TSynoFSDownloadFilesRes.Create;
begin
  Inherited;
end;

{ TSynoFSShareInfoReq }

constructor TSynoFSShareInfoReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'getinfo';
  Fversion := 3;
end;

{ TSynoFSShareListReq }

constructor TSynoFSShareListReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'list';
  Fversion := 3;
end;

{ TSynoFSShareCreateReq }

constructor TSynoFSShareCreateReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'create';
  Fversion := 3;
end;

{ TSynoFSShareDeleteReq }

constructor TSynoFSShareDeleteReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'delete';
  Fversion := 3;
end;

{ TSynoFSShareClearReq }

constructor TSynoFSShareClearReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'clear_invalid';
  Fversion := 3;
end;

{ TSynoFSShareEditReq }

constructor TSynoFSShareEditReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Sharing';
  Fmethod := 'edit';
  Fversion := 3;
end;

{ TSynoFSFolderCreateReq }

constructor TSynoFSFolderCreateReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.CreateFolder';
  Fmethod := 'create';
  Fversion := 2;
end;

{ TSynoFSRenameReq }

constructor TSynoFSRenameReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Rename';
  Fmethod := 'rename';
  Fversion := 2;
end;

{ TSynoFSCopyMoveStartReq }

constructor TSynoFSCopyMoveStartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.CopyMove';
  Fmethod := 'start';
  Fversion := 3;
end;

{ TSynoFSCopyMoveStatusReq }

constructor TSynoFSCopyMoveStatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.CopyMove';
  Fmethod := 'status';
  Fversion := 3;
end;

{ TSynoFSCopyMoveStopReq }

constructor TSynoFSCopyMoveStopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.CopyMove';
  Fmethod := 'stop';
  Fversion := 3;
end;

{ TSynoFSDeleteStartReq }

constructor TSynoFSDeleteStartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Delete';
  Fmethod := 'start';
  Fversion := 2;
end;

{ TSynoFSDeleteStatusReq }

constructor TSynoFSDeleteStatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Delete';
  Fmethod := 'status';
  Fversion := 2;
end;

{ TSynoFSDeleteStopReq }

constructor TSynoFSDeleteStopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Delete';
  Fmethod := 'stop';
  Fversion := 2;
end;

{ TSynoFSDeleteReq }

constructor TSynoFSDeleteReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Delete';
  Fmethod := 'delete';
  Fversion := 2;
end;

{ TSynoFSExtractStartReq }

constructor TSynoFSExtractStartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Extract';
  Fmethod := 'start';
  Fversion := 2;
end;

{ TSynoFSExtractStatusReq }

constructor TSynoFSExtractStatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Extract';
  Fmethod := 'status';
  Fversion := 2;
end;

{ TSynoFSExtractStopReq }

constructor TSynoFSExtractStopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Extract';
  Fmethod := 'stop';
  Fversion := 2;
end;

{ TSynoFSExtractListReq }

constructor TSynoFSExtractListReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Extract';
  Fmethod := 'list';
  Fversion := 2;
end;

{ TSynoFSCompressStartReq }

constructor TSynoFSCompressStartReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Compress';
  Fmethod := 'start';
  Fversion := 3;
end;

{ TSynoFSCompressStatusReq }

constructor TSynoFSCompressStatusReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Compress';
  Fmethod := 'status';
  Fversion := 3;
end;

{ TSynoFSCompressStopReq }

constructor TSynoFSCompressStopReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.Compress';
  Fmethod := 'stop';
  Fversion := 3;
end;

{ TSynoFSBackTaskListReq }

constructor TSynoFSBackTaskListReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.BackgroundTask';
  Fmethod := 'list';
  Fversion := 3;
end;

{ TSynoFSBackTaskClearReq }

constructor TSynoFSBackTaskClearReq.Create;
begin
  Inherited;
  Fapi := 'SYNO.FileStation.BackgroundTask';
  Fmethod := 'clear_finished';
  Fversion := 3;
end;

end.
