object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 738
  ClientWidth = 933
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
    Width = 933
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitWidth = 249
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 933
    Height = 489
    Align = alTop
    Caption = 'Panel2'
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 917
    object DrawGrid1: TDrawGrid
      Left = 1
      Top = 1
      Width = 931
      Height = 487
      Align = alClient
      ColCount = 248
      DefaultColWidth = 5
      DefaultRowHeight = 5
      FixedCols = 0
      RowCount = 80
      FixedRows = 0
      GridLineWidth = 0
      TabOrder = 0
      OnDrawCell = DrawGrid1DrawCell
      OnSelectCell = DrawGrid1SelectCell
    end
  end
  object pnlData: TPanel
    Left = 0
    Top = 492
    Width = 933
    Height = 246
    Align = alClient
    Caption = 'pnlData'
    TabOrder = 1
    ExplicitLeft = 264
    ExplicitTop = 528
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Memo1: TMemo
      Left = 1
      Top = 42
      Width = 931
      Height = 203
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
      ExplicitTop = 39
      ExplicitHeight = 206
    end
    object pnlButtons: TPanel
      Left = 1
      Top = 1
      Width = 931
      Height = 41
      Align = alTop
      TabOrder = 1
      ExplicitLeft = 464
      ExplicitTop = 16
      ExplicitWidth = 185
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
