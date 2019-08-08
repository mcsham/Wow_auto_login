object Form1: TForm1
  Left = 422
  Top = 220
  Width = 356
  Height = 253
  BorderIcons = [biSystemMenu]
  Caption = 'WoW Login'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 200
    Top = 24
    Width = 29
    Height = 13
    Caption = 'Login:'
  end
  object Label2: TLabel
    Left = 200
    Top = 80
    Width = 49
    Height = 13
    Caption = 'Password:'
  end
  object Button2: TButton
    Left = 208
    Top = 144
    Width = 75
    Height = 25
    Caption = 'save'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 208
    Top = 48
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 208
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object Button3: TButton
    Left = 208
    Top = 176
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 24
    Width = 169
    Height = 169
    ItemHeight = 13
    TabOrder = 4
    OnDblClick = ListBox1DblClick
  end
  object XPManifest1: TXPManifest
    Left = 296
    Top = 192
  end
end
