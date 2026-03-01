object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Hello World App'
  ClientHeight = 150
  ClientWidth = 350
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object edtName: TEdit
    Left = 24
    Top = 24
    Width = 300
    Height = 23
    TabOrder = 0
    TextHint = 'Enter your name...'
  end
  object btnHello: TButton
    Left = 24
    Top = 64
    Width = 300
    Height = 40
    Caption = 'Say Hello'
    TabOrder = 1
    OnClick = btnHelloClick
  end
end
