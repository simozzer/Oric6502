object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 737
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object spltGridAndData: TSplitter
    Left = 0
    Top = 489
    Width = 929
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 249
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 0
    Width = 929
    Height = 489
    Align = alTop
    Caption = 'pnlGrid'
    TabOrder = 0
  end
  object pnlData: TPanel
    Left = 0
    Top = 492
    Width = 929
    Height = 245
    Align = alClient
    Caption = 'pnlData'
    TabOrder = 1
    object Memo1: TMemo
      Left = 1
      Top = 42
      Width = 927
      Height = 202
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
    object pnlButtons: TPanel
      Left = 1
      Top = 1
      Width = 927
      Height = 41
      Align = alTop
      TabOrder = 1
      object btnGetData: TButton
        Left = 8
        Top = 8
        Width = 75
        Height = 25
        Action = actGetData
        TabOrder = 0
      end
      object btnZoomIn: TButton
        Left = 89
        Top = 10
        Width = 75
        Height = 25
        Action = actZoomIn
        TabOrder = 1
      end
      object btnZoomOut: TButton
        Left = 170
        Top = 10
        Width = 75
        Height = 25
        Action = actZoomOut
        TabOrder = 2
      end
    end
  end
  object ActionList1: TActionList
    Left = 752
    Top = 344
    object actGetData: TAction
      Caption = 'Get Data'
      OnExecute = actGetDataExecute
    end
    object actZoomIn: TAction
      Caption = 'Zoom In'
      OnExecute = actZoomInExecute
    end
    object actZoomOut: TAction
      Caption = 'Zoom Out'
      OnExecute = actZoomOutExecute
    end
  end
end
