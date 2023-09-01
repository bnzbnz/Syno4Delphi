object FrmDemo01: TFrmDemo01
  Left = 0
  Top = 0
  Caption = 'Syno4Delphi NAS Discovery :'
  ClientHeight = 115
  ClientWidth = 723
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Button1: TButton
    Left = 0
    Top = 0
    Width = 723
    Height = 25
    Align = alTop
    Caption = 'Scan (Select to Open)'
    TabOrder = 0
    OnClick = Button1Click
    ExplicitWidth = 719
  end
  object LB: TListBox
    Left = 0
    Top = 25
    Width = 723
    Height = 90
    Align = alClient
    ItemHeight = 15
    TabOrder = 1
    OnClick = LBClick
    ExplicitWidth = 719
    ExplicitHeight = 89
  end
end
