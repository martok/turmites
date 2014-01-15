object fmTurmites: TfmTurmites
  Left = 192
  Top = 107
  Width = 898
  Height = 624
  Caption = 'Turmites'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 768
    Top = 0
    Width = 122
    Height = 597
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 5
      Top = 3
      Width = 115
      Height = 108
      Caption = 'Random Rule'
      TabOrder = 0
      object Label2: TLabel
        Left = 60
        Top = 25
        Width = 35
        Height = 13
        Caption = 'Colours'
      end
      object btnRandom: TButton
        Left = 7
        Top = 45
        Width = 75
        Height = 25
        Caption = 'random [F1]'
        TabOrder = 0
        OnClick = btnRandomClick
      end
      object seColors: TSpinEdit
        Left = 7
        Top = 20
        Width = 46
        Height = 22
        MaxValue = 18
        MinValue = 2
        TabOrder = 1
        Value = 6
      end
      object cbAutoRnd: TCheckBox
        Left = 7
        Top = 74
        Width = 104
        Height = 27
        Caption = 'AutoRandomize every 60s'
        TabOrder = 2
        WordWrap = True
        OnClick = cbAutoRndClick
      end
    end
    object btnEnter: TButton
      Left = 5
      Top = 115
      Width = 115
      Height = 25
      Caption = 'Enter Rule [F3]'
      TabOrder = 1
      OnClick = btnEnterClick
    end
    object GroupBox2: TGroupBox
      Left = 5
      Top = 143
      Width = 115
      Height = 133
      Caption = 'Generations'
      TabOrder = 2
      object Label1: TLabel
        Left = 7
        Top = 17
        Width = 97
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '10000000000'
      end
      object Label3: TLabel
        Left = 7
        Top = 40
        Width = 67
        Height = 13
        Caption = 'Update every:'
      end
      object lbGenPerS: TLabel
        Left = 7
        Top = 107
        Width = 97
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = '10000000000'
      end
      object sePerImage: TSpinEdit
        Left = 7
        Top = 58
        Width = 97
        Height = 22
        MaxValue = 100000000
        MinValue = 100
        TabOrder = 0
        Value = 500000
      end
      object cbPause: TCheckBox
        Left = 7
        Top = 85
        Width = 97
        Height = 17
        Caption = 'Pause'
        TabOrder = 1
        OnClick = cbPauseClick
      end
    end
    object btnSaveCurr: TButton
      Left = 5
      Top = 280
      Width = 115
      Height = 25
      Caption = 'save [F2]'
      TabOrder = 3
      OnClick = btnSaveCurrClick
    end
    object GroupBox3: TGroupBox
      Left = 5
      Top = 308
      Width = 115
      Height = 91
      Caption = 'Style'
      TabOrder = 4
      object cbUnscaled: TCheckBox
        Left = 7
        Top = 15
        Width = 97
        Height = 17
        Caption = 'Unscaled'
        Checked = True
        State = cbChecked
        TabOrder = 0
        OnClick = cbUnscaledClick
      end
      object cbMonochrome: TCheckBox
        Left = 7
        Top = 35
        Width = 97
        Height = 17
        Caption = 'Monochrome'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
    end
    object lbLastRules: TListBox
      Left = 5
      Top = 400
      Width = 115
      Height = 126
      ItemHeight = 13
      TabOrder = 5
      OnClick = lbLastRulesClick
    end
  end
  object tmrSim: TTimer
    Interval = 1
    OnTimer = tmrSimTimer
    Left = 225
    Top = 85
  end
  object tmrRandomizeRule: TTimer
    Enabled = False
    Interval = 60000
    OnTimer = tmrRandomizeRuleTimer
    Left = 260
    Top = 85
  end
end
