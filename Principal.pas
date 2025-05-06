unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFormClassGenerator = class(TForm)
    MemoInput: TMemo;
    MemoRetorna: TMemo;
    MemoSet: TMemo;
    MemoCampos: TMemo;
    edtUnit: TEdit;
    edtInterface: TEdit;
    ButtonGerar: TButton;
    edtTipo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure ButtonGerarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    function ToCamelCase(const S: string): string;
  public
    { Public declarations }
  end;

var
  FormClassGenerator: TFormClassGenerator;

implementation

{$R *.dfm}

// Função para converter string em CamelCase completo com base nas "intenções" das palavras
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
  // Remove espaços restantes
  Result := StringReplace(ResultStr, ' ', '', [rfReplaceAll]);
end;

// Evento que executa a geração
procedure TFormClassGenerator.ButtonGerarClick(Sender: TObject);
var
  InputFields: TArray<string>;
  FieldName, CamelName, TipoUnit, TipoInterface: string;
  I: Integer;
  SetLine, RetornaLine: string;
begin
  MemoCampos.Clear;
  MemoSet.Clear;
  MemoRetorna.Clear;

  TipoUnit := 'T' + edtUnit.Text;
  TipoInterface := edtInterface.Text;

  InputFields := StringReplace(MemoInput.Text, sLineBreak, '', [rfReplaceAll]).Split([';']);

  for I := 0 to High(InputFields) do
  begin
    FieldName := Trim(InputFields[I]);
    if FieldName = '' then Continue;

    CamelName := ToCamelCase(FieldName);

    // Adiciona o campo com "F" e nome formatado
    MemoCampos.Lines.Add('F' + CamelName + ': ' + Trim(edtTipo.Text) + ';'); // substitua "tipo" manualmente

    // Gera função Set
    SetLine := Format('function %s.Set%s(value: ' + Trim(edtTipo.Text) + '): %s;', [TipoUnit, CamelName, TipoInterface]);
    MemoSet.Lines.Add(SetLine);
    MemoSet.Lines.Add('begin');
    MemoSet.Lines.Add('  Result := Self;');
    MemoSet.Lines.Add('  F' + CamelName + ' := value;');
    MemoSet.Lines.Add('end;');
    MemoSet.Lines.Add('');

    // Gera função Retorna
    RetornaLine := Format('function %s.Retorna%s: ' + Trim(edtTipo.Text) + ';', [TipoUnit, CamelName]);
    MemoRetorna.Lines.Add(RetornaLine);
    MemoRetorna.Lines.Add('begin');
    MemoRetorna.Lines.Add('  Result := F' + CamelName + ';');
    MemoRetorna.Lines.Add('end;');
    MemoRetorna.Lines.Add('');
  end;
end;

procedure TFormClassGenerator.FormShow(Sender: TObject);
begin
  MemoInput.Clear;
  MemoRetorna.Clear;
  MemoSet.Clear;
  MemoCampos.Clear;
end;

end.
