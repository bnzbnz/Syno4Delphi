object DlgPass: TDlgPass
  Left = 245
  Top = 108
  ActiveControl = SignIn
  BorderStyle = bsDialog
  Caption = 'Synology NAS Connect'
  ClientHeight = 191
  ClientWidth = 362
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 105
    Width = 86
    Height = 15
    Caption = 'Enter Password :'
  end
  object Label2: TLabel
    Left = 8
    Top = 55
    Width = 42
    Height = 15
    Caption = 'Sign in :'
  end
  object Label3: TLabel
    Left = 8
    Top = 8
    Width = 29
    Height = 15
    Caption = 'NAS :'
  end
  object Password: TEdit
    Left = 8
    Top = 123
    Width = 345
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object OKBtn: TButton
    Left = 197
    Top = 158
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 278
    Top = 158
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object SignIn: TEdit
    Left = 8
    Top = 76
    Width = 345
    Height = 23
    TabOrder = 0
  end
  object CBList: TComboBox
    Left = 8
    Top = 26
    Width = 345
    Height = 23
    Style = csDropDownList
    TabOrder = 4
    OnDropDown = CBListDropDown
  end
end
