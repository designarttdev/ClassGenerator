unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormClassGenerator = class(TForm)
    PageControl1: TPageControl;
    pgPrincipal: TTabSheet;
    pgCampos: TTabSheet;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    MemoInput: TMemo;
    edtUnit: TEdit;
    edtInterface: TEdit;
    edtTipo: TEdit;
    ScrollBox2: TScrollBox;
    MemoRetorna: TMemo;
    Label7: TLabel;
    MemoSet: TMemo;
    Label6: TLabel;
    Label8: TLabel;
    MemoCamposPadrao: TMemo;
    TabSheet1: TTabSheet;
    ScrollBox3: TScrollBox;
    Label9: TLabel;
    Label10: TLabel;
    MemoDecRetorna: TMemo;
    MemoDecSet: TMemo;
    ButtonGerar: TButton;
    Label5: TLabel;
    MemoCampos: TMemo;
    procedure ButtonGerarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function ToCamelCase(const S: string): string;
    procedure LimpaCampos;
  public
    { Public declarations }
  end;

var
  FormClassGenerator: TFormClassGenerator;

implementation

{$R *.dfm}

// Fun��o para converter string em CamelCase completo com base nas "inten��es" das palavras
function TFormClassGenerator.ToCamelCase(const S: string): string;
var
  I: Integer;
  Cleaned, ResultStr: string;
  InWord: Boolean;
begin
  ResultStr := '';
  Cleaned := StringReplace(S.Trim, '_', ' ', [rfReplaceAll]);
  Cleaned := StringReplace(Cleaned, '-', ' ', [rfReplaceAll]);
  Cleaned := StringReplace(Cleaned, '.', ' ', [rfReplaceAll]);
  InWord := False;

  for I := 1 to Length(Cleaned) do
  begin
    if (I = 1) or (Cleaned[I - 1] = ' ') then
      ResultStr := ResultStr + UpCase(Cleaned[I])
    else
      ResultStr := ResultStr + Cleaned[I];
  end;
  // Remove espa�os restantes
  Result := StringReplace(ResultStr, ' ', '', [rfReplaceAll]);
end;

procedure TFormClassGenerator.LimpaCampos;
begin
  MemoCampos.Clear;
  MemoSet.Clear;
  MemoRetorna.Clear;
  MemoCamposPadrao.Clear;
  MemoDecRetorna.Clear;
  MemoDecSet.Clear;
end;

// Evento que executa a gera��o
procedure TFormClassGenerator.ButtonGerarClick(Sender: TObject);
var
  InputFields: TArray<string>;
  FieldName, CamelName, TipoUnit, TipoInterface: string;
  I: Integer;
  SetLine, RetornaLine: string;
begin
  LimpaCampos;

  TipoUnit := 'T' + edtUnit.Text;
  TipoInterface := edtInterface.Text;

  // Transforma os campos separados por ";" em itens de um array
  InputFields := StringReplace(Trim(MemoInput.Text).ToLower, sLineBreak, '', [rfReplaceAll]).Split([';']);

  for I := 0 to High(InputFields) do
  begin
    FieldName := Trim(InputFields[I]);
    if FieldName = '' then Continue;

    CamelName := ToCamelCase(FieldName);

    // Adiciona o campo com "F" e nome formatado
    MemoCampos.Lines.Add('F' + CamelName + ': ' + Trim(edtTipo.Text) + ';'); // substitua "tipo" manualmente

    // Gera fun��o Set
    SetLine := Format('function Set%s(value: ' + Trim(edtTipo.Text) + '): %s;', [CamelName, TipoInterface]);
    MemoDecSet.Lines.Add(SetLine);

    SetLine := Format('function %s.Set%s(value: ' + Trim(edtTipo.Text) + '): %s;', [TipoUnit, CamelName, TipoInterface]);
    MemoSet.Lines.Add(SetLine);
    MemoSet.Lines.Add('begin');
    MemoSet.Lines.Add('  Result := Self;');

    if Trim(edtTipo.Text).ToUpper = 'String'.Trim.ToUpper then
      MemoSet.Lines.Add('  F' + CamelName + ' := Trim(value).ToUpper;')
    else
      MemoSet.Lines.Add('  F' + CamelName + ' := value;');

    MemoSet.Lines.Add('end;');
    MemoSet.Lines.Add('');

    // Gera fun��o Retorna
    RetornaLine := Format('function Retorna%s: ' + Trim(edtTipo.Text) + ';', [CamelName]);
    MemoDecRetorna.Lines.Add(RetornaLine);

    RetornaLine := Format('function %s.Retorna%s: ' + Trim(edtTipo.Text) + ';', [TipoUnit, CamelName]);
    MemoRetorna.Lines.Add(RetornaLine);
    MemoRetorna.Lines.Add('begin');

    if Trim(edtTipo.Text).ToUpper = 'String'.Trim.ToUpper then
      MemoRetorna.Lines.Add('  Result := Trim(F' + CamelName + ').ToUpper;')
    else
      MemoRetorna.Lines.Add('  Result := F' + CamelName + ';');

    MemoRetorna.Lines.Add('end;');
    MemoRetorna.Lines.Add('');

    if Trim(edtTipo.Text).ToUpper = 'String'.Trim.ToUpper then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ''''; ')
    else
    if (Trim(edtTipo.Text).ToUpper = 'integer'.Trim.ToUpper)
      or (Trim(edtTipo.Text).ToUpper = 'double'.Trim.ToUpper) then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := 0; ')
    else
    if (Trim(edtTipo.Text).ToUpper = 'TdateTime'.Trim.ToUpper)
      or (Trim(edtTipo.Text).ToUpper = 'Tdate'.Trim.ToUpper) then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := EncodeDate(1900, 1, 1); ')
    else
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := null; ');

  end;

  Application.MessageBox('Gerado com sucesso!', 'Sucesso!', MB_OK + MB_ICONINFORMATION);
  PageControl1.TabIndex := 1;
end;

procedure TFormClassGenerator.FormShow(Sender: TObject);
begin
  LimpaCampos;
  PageControl1.TabIndex := 0;
end;

end.
