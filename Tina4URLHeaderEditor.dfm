object frmTina4URLHeaderEditor: TfrmTina4URLHeaderEditor
  Left = 493
  Top = 38
  BorderStyle = bsSingle
  Caption = 'Custom Headers'
  ClientHeight = 368
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object grdHeaders: TStringGrid
    Left = 0
    Top = 0
    Width = 482
    Height = 327
    Align = alClient
    ColCount = 2
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goFixedRowDefAlign]
    ParentFont = False
    TabOrder = 0
    OnDrawCell = grdHeadersDrawCell
    ColWidths = (
      134
      195)
  end
  object Panel2: TPanel
    Left = 0
    Top = 327
    Width = 482
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      Left = 399
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      TabStop = False
    end
    object btnOK: TButton
      Left = 318
      Top = 8
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 1
      TabStop = False
    end
    object btnAdd: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Add'
      TabOrder = 2
      TabStop = False
      OnClick = btnAddClick
    end
    object btnDelete: TButton
      Left = 89
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Delete'
      TabOrder = 3
      TabStop = False
      OnClick = btnDeleteClick
    end
  end
end
