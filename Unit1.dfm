object Form1: TForm1
  Left = 919
  Top = 350
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'WoW Login'
  ClientHeight = 316
  ClientWidth = 374
  Color = clSilver
  ParentFont = True
  OldCreateOrder = False
  Position = poDesktopCenter
  Scaled = False
  Visible = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 200
    Top = 192
    Width = 129
    Height = 13
    Caption = 'Delay before entering login:'
    Color = clBtnFace
    ParentColor = False
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
    ParentBackground = False
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
  object CheckBox1: TCheckBox
    Left = 208
    Top = 280
    Width = 169
    Height = 17
    Caption = 'AutoLogin if WoW is down'
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object XPManifest1: TXPManifest
    Left = 280
    Top = 80
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 112
    Top = 272
  end
end
