unit uSynoDiscovery;

/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// References:
/// https://medium.com/@cq674350529/a-journey-into-synology-nas-part-2-analyzing-findhostd-service-2264e4fd21e9
/// https://github.com/cq674350529/pocs_slides/blob/master/scripts/Synology/syno_finder/syno_finder.lua
/// License: MPL 1.1 / GPL 2.1
///

interface
uses
   Classes, System.Generics.Collections,
   IdGlobal, IdUDPServer, IdSocketHandle;

type

  TSynoDevice = class(TObject)
    Packet: AnsiString;
    PacketType: UInt32;
    Name: string;
    Model: string;
    Description: string;
    Serial: string;
    OS: string;
    VerMajor: string;
    VerMinor: UInt32;
    VerUpdate: UInt32;
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

  TSynoDiscovery = class;

  TSynoDiscoveryOnFoundEvent = procedure(Sender: TSynoDiscovery; SynoDevice: TSynoDevice) of object;

  TSynoDiscovery = class(TComponent)
  private
    FStarted    : Boolean;
    FOnFound    : TSynoDiscoveryOnFoundEvent;
    FIdUDPServer: TIdUDPServer;
    FSynoUList  : TStringList;
    procedure   UDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
  public
    constructor Create(aOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Start;
    procedure   Stop;
    property    OnFound: TSynoDiscoveryOnFoundEvent read FOnFound write FOnFound;
  end;

implementation
uses
  uNetUtils, SysUtils, Dialogs;

constructor TSynoDiscovery.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FSynoUList := TStringlist.Create;
  FIdUDPServer :=  TIdUDPServer.Create(Self);
  FIdUDPServer.DefaultPort := 9999;
  FIdUDPServer.OnUDPRead := UDPRead;
  FStarted := False;
end;

destructor TSynoDiscovery.Destroy;
begin
  FIdUDPServer.Free;
  FSynoUList.Free;
  inherited;
end;

procedure TSynoDiscovery.Start;
begin
  var NCs: TObjectList<TNetworkAdapterInfo> := nil;
  var BinPacket: TIdBytes;
  FSynoUList.Clear;
  try
    FIdUDPServer.Active := False;
    FIdUDPServer.Active := True;
    FStarted := FIdUDPServer.Active;
    if not FStarted then Exit;
    NCs := GetNetworkAdapters;
    for var NC in NCs do
    begin
      if NC.Active then
      begin
        var HexPacket:= '1234567853594e4f010401000000a40400000201';

        SetLength(BinPacket, Length(HexPacket) div 2 );
        HexToBin(PWideChar(HexPacket), BinPacket, Length(BinPacket));

        var BroadcastIP := IPAddrToStr(StrToIpAddr(NC.IP) and StrToIpAddr(NC.SubnetMask) + 255);
        FIdUDPServer.Broadcast(BinPacket, 9999, BroadcastIP);
      end;
    end;
  finally
    NCs.Free;
  end;
end;

procedure TSynoDiscovery.Stop;
begin
  FStarted := False;
end;

procedure TSynoDiscovery.UDPRead(AThread: TIdUDPListenerThread; const AData: TIdBytes; ABinding: TIdSocketHandle);
begin
  if not assigned(FOnFound) or not (FStarted) then Exit;
  var Packet : AnsiString;
  SetLength(Packet, Length(AData));
  Move(Pointer(AData)^, Pointer(Packet)^, Length(AData));
  var P := Pos(AnsiString(Chr($12) + ('4VxSYNO')), Packet);
  if P = 1 then
  begin
    P := P + 8;
    var Device := TSynoDevice.Create;
    Device.Packet := Packet;
    while(P < Length(Packet) - 2) do
    begin
      var Op := Ord(Packet[P]);
      var Len  := Ord(Packet[P + 1]);
      case Op of
        $01:  Device.PacketType := PUInt32(@Packet[P+2])^;
        $11:  Device.Name := string(Copy(Packet, P + 2, Len));
        $12:  Device.IP := IpAddrToStr(Swap(PWord(@Packet[P+2])^) shl 16 + Swap(PWord(@Packet[P+4])^));
        $13:  Device.Subnet := IpAddrToStr(Swap(PWord(@Packet[P+2])^) shl 16 + Swap(PWord(@Packet[P+4])^));
        $14:  Device.Gateway := IpAddrToStr(Swap(PWord(@Packet[P+2])^) shl 16 + Swap(PWord(@Packet[P+4])^));
        $15:  Device.Dns := IpAddrToStr(Swap(PWord(@Packet[P+2])^) shl 16 + Swap(PWord(@Packet[P+4])^));
        $19:  Device.MAC := string(Copy(Packet, P + 2, Len));
        $1E:  begin
                Device.FromIP  := IpAddrToStr(Swap(PWord(@Packet[P+2])^) shl 16 + Swap(PWord(@Packet[P+4])^));
                Device.FromMAC := IPtoMacAddr(Device.FromIP);
              end;
        $49:  Device.VerMinor := PUInt32(@Packet[P+2])^;
        $70:  Device.Description := string(Copy(Packet, P + 2, Len));
        $75:  Device.Port := PUInt32(@Packet[P+2])^;
        $76:  Device.PortSSL := PUInt32(@Packet[P+2])^;
        $77:  Device.VerMajor := string(Copy(Packet, P + 2, Len));
        $78:  Device.Model := string(Copy(Packet, P + 2, Len));
        $90:  Device.VerUpdate := PUInt32(@Packet[P+2])^;
        $C0:  Device.Serial := string(Copy(Packet, P + 2, Len));
        $C1:  Device.OS := string(Copy(Packet, P + 2, Len));
      else
        // Unknown Operation Code...
      end;
      P := P + 2 + Len;
    end;
    if (Device.PacketType = 2) and (Device.MAC <> '') and (FSynoUList.IndexOf(Device.MAC) = -1) then
    begin
      FSynoUList.Add(Device.MAC);
      FOnFound(Self, Device);
    end else begin
      Device.Free;
    end;
  end;
end;

end.

(*
  Reverse Engineering Tools : Wireshark  / Delphi
  References:
  https://medium.com/@cq674350529/a-journey-into-synology-nas-part-2-analyzing-findhostd-service-2264e4fd21e9
  https://github.com/cq674350529/pocs_slides/blob/master/scripts/Synology/syno_finder/syno_finder.lua

REQUEST:
0000   ff ff ff ff ff ff 70 a8 d3 d7 d7 be 08 00 45 00   ......p.......E.
0010   00 b9 1c dc 00 00 80 11 00 00 c0 a8 01 70 ff ff   .............p..
0020   ff ff 04 d2 27 0f 00 a5 d6 95 12 34 56 78 53 59   ....'......4VxSY
0030   4e 4f a4 04 00 00 02 01 a6 04 78 00 00 00 01 04   NO........x.....
0040   01 00 00 00 b0 08 c0 01 00 00 00 00 00 00 b1 08   ................
0050   00 00 00 00 00 00 00 00 b8 08 c0 01 00 00 00 00   ................
0060   00 00 b9 08 00 00 00 00 00 00 00 00 7c 11 37 30   ............|.70
0070   3a 61 38 3a 64 33 3a 64 37 3a 64 37 3a 62 65 c4   :a8:d3:d7:d7:be.
0080   40 35 35 38 37 35 39 66 30 66 30 39 30 62 31 62   @558759f0f090b1b
0090   62 63 39 37 35 35 64 38 30 36 61 38 66 61 38 66   bc9755d806a8fa8f
00a0   35 33 38 64 30 65 38 34 32 63 38 30 36 33 37 64   538d0e842c80637d
00b0   30 30 65 39 65 34 37 31 31 65 63 64 66 37 35 37   00e9e4711ecdf757
00c0   36 c5 04 70 b2 3a 0c                              6..p.:.

RESPONSE:
0000   70 a8 d3 d7 d7 be 90 09 d0 1a 5b 9b 08 00 45 00   p.........[...E.
0010   01 57 00 f2 00 00 40 11 f4 bf c0 a8 01 24 c0 a8   .W....@......$..
0020   01 70 04 d2 27 0f 01 43 e5 97 12 34 56 78 53 59   .p..'..C...4VxSY
0030   4e 4f 19 11 39 30 3a 30 39 3a 64 30 3a 31 61 3a   NO..90:09:d0:1a:
0040   35 62 3a 39 62 12 04 c0 a8 01 24 10 04 01 00 00   5b:9b.....$.....
0050   00 13 04 ff ff ff 00 18 04 01 00 00 00 15 04 c0   ................
0060   a8 01 01 14 04 c0 a8 01 01 a3 04 03 00 00 00 01   ................
0070   04 02 00 00 00 11 03 4e 41 53 1e 04 c0 a8 01 70   .......NAS.....p
0080   c0 0d 32 32 34 30 54 52 52 58 51 4d 4a 34 35 73   ..2240TRRXQMJ45s
0090   0a 32 34 54 52 52 51 4d 4a 34 35 a4 04 00 00 02   .24TRRQMJ45.....
00a0   01 a6 04 78 00 00 00 50 00 52 00 54 04 00 00 00   ...x...P.R.T....
00b0   00 56 00 58 00 5a 00 5c 00 51 00 53 00 55 04 00   .V.X.Z.\.Q.S.U..
00c0   00 00 00 57 00 59 00 5b 00 5d 00 a7 04 01 00 00   ...W.Y.[.]......
00d0   00 48 04 01 00 00 00 49 04 3a fc 00 00 77 03 37   .H.....I.:...w.7
00e0   2e 32 90 04 03 00 00 00 78 07 44 53 31 35 32 32   .2......x.DS1522
00f0   2b 70 14 73 79 6e 6f 6c 6f 67 79 5f 72 31 30 30   +p.synology_r100
0100   30 5f 31 35 32 32 2b c1 03 44 53 4d 80 04 00 00   0_1522+..DSM....
0110   00 00 7b 04 01 00 00 00 71 04 01 00 00 00 75 04   ..{.....q.....u.
0120   88 13 00 00 76 04 89 13 00 00 7c 11 37 30 3a 61   ....v.....|.70:a
0130   38 3a 64 33 3a 64 37 3a 64 37 3a 62 65 b0 08 bf   8:d3:d7:d7:be...
0140   03 00 00 00 00 00 00 b1 08 00 00 00 00 00 00 00   ................
0150   00 b8 08 81 00 00 00 00 00 00 00 b9 08 00 00 00   ................
0160   00 00 00 00 00                                    .....

*)
