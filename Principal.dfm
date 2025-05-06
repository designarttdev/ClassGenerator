object FormClassGenerator: TFormClassGenerator
  Left = 0
  Top = 0
  Caption = 'FormClassGenerator'
  ClientHeight = 622
  ClientWidth = 945
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 19
    Width = 57
    Height = 13
    Caption = 'Tipo da Unit'
  end
  object Label2: TLabel
    Left = 260
    Top = 19
    Width = 102
    Height = 13
    Caption = 'Interface de Retorno'
  end
  object Label3: TLabel
    Left = 496
    Top = 19
    Width = 86
    Height = 13
    Caption = 'Tipos dos Campos'
  end
  object Label4: TLabel
    Left = 24
    Top = 65
    Width = 485
    Height = 13
    Caption = 
      'Campos para serem inseridos na classe separados por ";"    -    ' +
      'Para camelcase, separar por espa'#231'os.'
  end
  object Label5: TLabel
    Left = 24
    Top = 188
    Width = 156
    Height = 13
    Caption = 'Declara'#231#227'o dos campos por tipo.'
  end
  object Label6: TLabel
    Left = 24
    Top = 312
    Width = 74
    Height = 13
    Caption = 'Campos de SET'
  end
  object Label7: TLabel
    Left = 24
    Top = 435
    Width = 104
    Height = 13
    Caption = 'Campos de RETORNA'
  end
  object MemoInput: TMemo
    Left = 24
    Top = 81
    Width = 897
    Height = 107
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object MemoRetorna: TMemo
    Left = 24
    Top = 450
    Width = 897
    Height = 107
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object MemoSet: TMemo
    Left = 24
    Top = 327
    Width = 897
    Height = 107
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
  object MemoCampos: TMemo
    Left = 24
    Top = 204
    Width = 897
    Height = 107
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object edtUnit: TEdit
    Left = 24
    Top = 38
    Width = 193
    Height = 21
    TabOrder = 0
    TextHint = 'Unit'
  end
  object edtInterface: TEdit
    Left = 260
    Top = 38
    Width = 193
    Height = 21
    TabOrder = 1
    TextHint = 'IProdutos'
  end
  object ButtonGerar: TButton
    Left = 430
    Top = 564
    Width = 86
    Height = 41
    Caption = 'Gerar'
    TabOrder = 7
    OnClick = ButtonGerarClick
  end
  object edtTipo: TEdit
    Left = 496
    Top = 38
    Width = 193
    Height = 21
    TabOrder = 2
    TextHint = 'String, Double, Integer, TDateTime...'
  end
end
