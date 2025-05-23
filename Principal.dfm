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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 945
    Height = 622
    ActivePage = pgPrincipal
    Align = alClient
    TabOrder = 0
    object pgPrincipal: TTabSheet
      Caption = 'Principal'
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 937
        Height = 594
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        ExplicitLeft = 232
        ExplicitTop = 312
        object Label1: TLabel
          Left = 20
          Top = 19
          Width = 57
          Height = 13
          Caption = 'Tipo da Unit'
        end
        object Label2: TLabel
          Left = 256
          Top = 19
          Width = 102
          Height = 13
          Caption = 'Interface de Retorno'
        end
        object Label3: TLabel
          Left = 492
          Top = 19
          Width = 86
          Height = 13
          Caption = 'Tipos dos Campos'
        end
        object Label4: TLabel
          Left = 20
          Top = 65
          Width = 485
          Height = 13
          Caption = 
            'Campos para serem inseridos na classe separados por ";"    -    ' +
            'Para camelcase, separar por espa'#231'os.'
        end
        object MemoInput: TMemo
          Left = 20
          Top = 81
          Width = 897
          Height = 192
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object edtUnit: TEdit
          Left = 20
          Top = 38
          Width = 193
          Height = 21
          TabOrder = 1
          Text = 'Produto'
          TextHint = 'Unit'
        end
        object edtInterface: TEdit
          Left = 256
          Top = 38
          Width = 193
          Height = 21
          TabOrder = 2
          Text = 'IProduto'
          TextHint = 'IProdutos'
        end
        object edtTipo: TEdit
          Left = 492
          Top = 38
          Width = 193
          Height = 21
          TabOrder = 3
          Text = 'String'
          TextHint = 'String, Double, Integer, TDateTime...'
        end
        object ButtonGerar: TButton
          Left = 419
          Top = 306
          Width = 98
          Height = 38
          Caption = 'Gerar'
          TabOrder = 4
          OnClick = ButtonGerarClick
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Declara'#231#245'es'
      ImageIndex = 2
      object ScrollBox3: TScrollBox
        Left = 0
        Top = 0
        Width = 937
        Height = 594
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object Label9: TLabel
          Left = 20
          Top = 14
          Width = 104
          Height = 13
          Caption = 'Declara'#231#227'o RETORNA'
        end
        object Label10: TLabel
          Left = 20
          Top = 210
          Width = 74
          Height = 13
          Caption = 'Declara'#231#227'o SET'
        end
        object Label5: TLabel
          Left = 20
          Top = 406
          Width = 156
          Height = 13
          Caption = 'Declara'#231#227'o dos campos por tipo.'
        end
        object MemoDecRetorna: TMemo
          Left = 20
          Top = 29
          Width = 897
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object MemoDecSet: TMemo
          Left = 20
          Top = 225
          Width = 897
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object MemoCampos: TMemo
          Left = 20
          Top = 421
          Width = 897
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
    object pgCampos: TTabSheet
      Caption = 'Fun'#231#245'es'
      ImageIndex = 1
      object ScrollBox2: TScrollBox
        Left = 0
        Top = 0
        Width = 937
        Height = 594
        Align = alClient
        BevelInner = bvNone
        BevelOuter = bvNone
        BorderStyle = bsNone
        TabOrder = 0
        object Label7: TLabel
          Left = 22
          Top = 23
          Width = 104
          Height = 13
          Caption = 'Campos de RETORNA'
        end
        object Label6: TLabel
          Left = 22
          Top = 208
          Width = 74
          Height = 13
          Caption = 'Campos de SET'
        end
        object Label8: TLabel
          Left = 22
          Top = 394
          Width = 75
          Height = 13
          Caption = 'Campos Padr'#227'o'
        end
        object MemoRetorna: TMemo
          Left = 22
          Top = 42
          Width = 894
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object MemoSet: TMemo
          Left = 22
          Top = 225
          Width = 894
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 1
        end
        object MemoCamposPadrao: TMemo
          Left = 22
          Top = 409
          Width = 894
          Height = 161
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
  end
end
