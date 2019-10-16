object Form1: TForm1
  Left = 422
  Top = 220
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WoW Login'
  ClientHeight = 285
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 200
    Top = 192
    Width = 129
    Height = 13
    Caption = 'Delay before entering login:'
  end
  object Button3: TButton
    Left = 208
    Top = 240
    Width = 147
    Height = 25
    Caption = 'Delete current account'
    TabOrder = 0
    OnClick = Button3Click
  end
  object ListBox1: TListBox
    Left = 16
    Top = 24
    Width = 169
    Height = 249
    ItemHeight = 13
    TabOrder = 1
    OnDblClick = ListBox1DblClick
  end
  object GroupBox1: TGroupBox
    Left = 208
    Top = 24
    Width = 145
    Height = 153
    Caption = 'New account'
    TabOrder = 2
    object Label1: TLabel
      Left = 100
      Top = 16
      Width = 29
      Height = 13
      Caption = 'Login:'
    end
    object Label2: TLabel
      Left = 80
      Top = 72
      Width = 49
      Height = 13
      Caption = 'Password:'
    end
    object Edit1: TEdit
      Left = 8
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 8
      Top = 96
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object Button2: TButton
      Left = 54
      Top = 120
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object SpinEdit1: TSpinEdit
    Left = 256
    Top = 208
    Width = 97
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 500
    OnChange = SpinEdit1Change
  end
  object XPManifest1: TXPManifest
    Left = 256
    Top = 24
  end
end
