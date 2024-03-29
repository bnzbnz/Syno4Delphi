{$A8,B-,C+,E-,F-,G+,H+,I+,J-,K-,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Z1}
unit uJsonX.Types;

///
/// Syno4Delphi : https://github.com/bnzbnz/Syno4Delphi
/// Laurent Meyer : lmeyer@ea4d.com
/// License: MPL 1.1 / GPL 2.1
///

interface
uses  System.Generics.Collections, Classes;

type

  TJsonXParsingOption = (
    jxoReturnEmptyObject,
    jxoUnassignedAsNull,
    jxoWarnOnMissingField,
    jxoRaiseException,
    jxoPropertiesOnly,
    jxoGetRaw,
    // INTERNAL
    jxoReadLowMemory,
    jxoWriteLowMemory,
    jxoWriteLowMemory_Level2_EXPERIMENTAL // Hyper memory efficient... Hyper slow :(
  );
  TJsonXParsingOptions = set of TJsonXParsingOption;

  TJsonXSystemParameters = class(TObject)
    Thread:  TThread;
    Options: TJsonXParsingOptions;
    constructor Create(aThread: TThread = Nil; aOptions: TJsonXParsingOptions = []); overload;
    destructor Destroy; override;
    procedure Clear;
  end;

  TJsonXSystemStatus = class
  public
    OpsCount: NativeInt;
    ProcessJsonMS: Int64;
    ProcessObjectMS: Int64;
    DurationMS: Int64;
    VarCount: Int64;
    NullVarCount: Int64;
    EmptyVarCount: Int64;
    ObjCount: Int64;
    ObjListCount: Int64;
    VarListCount: Int64;
    VarObjDicCount: Int64;
    VarVarDicCount: Int64;
    DecodeCount: Int64;
    DecodeMs: Int64;
    procedure Clear;
  end;

 // Json eXtended Classes

  TJsonXBaseType      = class(TObject)
  end;

  TJsonXVarListType   = class;
  TJsonXVarListType   = class(TList<variant>)
    function Clone: TJsonXVarListType;
  end;

  TJsonXObjListType   = class(TObjectList<TObject>) // Requires AJsonXClassType Attribute(Object class type)
    function Clone: TJsonXObjListType;
  end;
  TJsonXVarVarDicType = class(TDictionary<variant, variant>)
    function Clone: TJsonXVarVarDicType;
  end;
  TJsonXVarObjDicType = class(TObjectDictionary<variant, TObject>)  // Requires AJsonXClassType Attribute(Object class type)
    function Clone: TJsonXVarObjDicType;
  end;

  TJsonXBaseExType = class(TJsonXBaseType)
  protected
     procedure InternalClone(T : TJsonXBaseExType); virtual;
  public
     _RawJson : string;
    //class function NewInstance: TObject; override;
    //procedure FreeInstance; override;
    function GetPath(Path: string): TJsonXBaseExType;
    function Clone: TJsonXBaseExType; virtual;
  end;

  TJsonXBaseEx2Type = class(TJsonXBaseExType)
  public
    destructor Destroy; override;
  end;

  TJsonXBaseEx3Type = class(TJsonXBaseEx2Type)
  protected
    RTTIID: Integer;
  public
    constructor Create; overload;
    procedure InitCreate; virtual; abstract;
  end;

implementation
uses RTTI, uJsonX.RTTI, uJsonX.Utils, SysUtils, Variants;

{ TJsonXSystemParameters }

procedure TJsonXSystemParameters.Clear;
begin
  Thread := Nil;
  Options := [];
end;

constructor TJsonXSystemParameters.Create(aThread: TThread = Nil; aOptions: TJsonXParsingOptions = []);
begin
  inherited Create;
  Thread := aThread;
  Options := aOptions;
end;

destructor TJsonXSystemParameters.Destroy;
begin
  inherited;
end;

{ TJsonXBaseExType}

(*
class function TJsonXBaseExType.NewInstance: TObject;
begin
  GetMem(Pointer(Result), InstanceSize);
  PPointer(Result)^ := Self;
end;

procedure TJsonXBaseExType.FreeInstance;
begin
  // We have no WeakRef => faster cleanup
  FreeMem(Pointer(Self));
end;
*)


{ TJsonXBaseExType2 }

destructor TJsonXBaseEx2Type.Destroy;
begin
  for var RTTIField in uJsonX.RTTI.GetFields(Self) do
    if RTTIField.FieldType.TypeKind in [tkClass] then
      RTTIField.GetValue(Self).AsObject.Free;
  inherited;
end;

{ TJsonXBaseEx3Type }

constructor TJsonXBaseEx3Type.Create;
begin
  Inherited Create;
  InitCreate;
end;


{ TJsonXSystemStatus }

procedure TJsonXSystemStatus.Clear;
begin
  OpsCount := 0;
  ProcessJsonMS := 0;
  ProcessObjectMS := 0;
  DurationMS := 0;
  VarCount := 0;
  ObjCount := 0;
  VarObjDicCount := 0;
  ObjListCount := 0;
  VarListCount := 0;
  VarVarDicCount := 0;
  NullVarCount := 0;
  EmptyVarCount := 0;
  DecodeCount := 0;
  DecodeMs := 0;
end;

{ TJsonXBaseExType }

function TJsonXBaseExType.GetPath(Path: string): TJsonXBaseExType;
begin
  raise Exception.Create('To Be Implemented...');
end;

function TJsonXBaseExType.Clone: TJsonXBaseExType;
begin
  Result := TJsonXBaseExType(Self.ClassType.Create);
  Self.InternalClone(Result);
end;

procedure TJsonXBaseExType.InternalClone(T: TJsonXBaseExType);
begin
  if T = nil then exit;
  for var field in GetFields(T) do
  begin
    if field.FieldType.TypeKind = tkVariant then
    begin
      var v :=  field.GetValue(Self);
      if not VarIsEmpty(v.AsVariant) then field.SetValue(T, v);
    end else
      if field.FieldType.TypeKind in [tkClass] then
      begin
        var Instance := field.FieldType.AsInstance;
        var Obj := field.GetValue(Self).AsObject;
        if Obj <> nil then
        begin
          if Instance.MetaclassType = TJsonXVarListType then
            field.SetValue(T, TJsonXVarListType(Obj).Clone)
          else
          if Instance.MetaclassType = TJsonXObjListType then
            field.SetValue(T, TJsonXObjListType(Obj).Clone)
          else
          if Instance.MetaclassType = TJsonXVarVarDicType then
            field.SetValue(T, TJsonXVarVarDicType(Obj).Clone)
          else
          if Instance.MetaclassType = TJsonXVarObjDicType then
            field.SetValue(T, TJsonXVarObjDicType(Obj).Clone)
          else
            field.SetValue(T, TJsonXBaseExType(Obj).Clone);
        end;
      end;
  end;
end;

{ TJsonXVarListType }

function TJsonXVarListType.CLone: TJsonXVarListType;
begin
  Result := TJsonXVarListType.create;
  for var v in Self do Result.Add(v);
end;

{ TJsonXObjListType }

function TJsonXObjListType.Clone: TJsonXObjListType;
begin
  Result := TJsonXObjListType.Create;
  for var v in self do (Result.Add(TJsonXBaseExType(v).Clone));
end;

{ TJsonXVarVarDicType }

function TJsonXVarVarDicType.Clone: TJsonXVarVarDicType;
begin
  Result := TJsonXVarVarDicType.Create;
  for var kv in Self do Result.Add(kv.Key, kv.Value);
end;

{ TJsonXVarObjDicType }

function TJsonXVarObjDicType.Clone: TJsonXVarObjDicType;
begin
  Result := TJsonXVarObjDicType.Create;
  for var kv in Self do Result.Add(kv.Key, TJsonXBaseExType(kv.Value).Clone);
end;

end.

