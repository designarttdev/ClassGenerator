unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.RegularExpressions;

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
    type
      TFieldInfo = record
        Name: string;
        DataType: string;
      end;
    function MapDBTypeToDelphi(const DBType: string): string;
    function ParseDDL(const AText: string): TArray<TFieldInfo>;
    function ToCamelCase(const S: string): string;
    procedure LimpaCampos;
  public
    { Public declarations }
  end;

var
  FormClassGenerator: TFormClassGenerator;

implementation

{$R *.dfm}


function TFormClassGenerator.MapDBTypeToDelphi(const DBType: string): string;
var
  T: string;
begin
  T := Trim(DBType).ToUpper; // garantir consistência

  // Usando expressão regular para garantir que seja palavra isolada (\b = borda de palavra)
  if TRegEx.IsMatch(T, '\bINTEGER\b') then
    Result := 'Integer'
  else if TRegEx.IsMatch(T, '\b(DOUBLE|FLOAT|NUMERIC|DECIMAL)\b') then
    Result := 'Double'
  else if TRegEx.IsMatch(T, '\b(CHAR|VARCHAR|BLOB)\b') then
    Result := 'String'
  else if TRegEx.IsMatch(T, '\b(DATE|TIMESTAMP)\b') then
    Result := 'TDateTime'
  else
    Result := 'Variant';
end;

function TFormClassGenerator.ParseDDL(const AText: string): TArray<TFieldInfo>;
var
  Lines: TArray<string>;
  L, Line, FieldName, FieldType: string;
  P: Integer;
begin
  Lines := AText.Replace(#13#10, #10).Replace(#13, #10).Split([#10]);
  for L in Lines do
  begin
    Line := Trim(L);
    if Line = '' then Continue;
    if (Pos('CREATE TABLE', UpperCase(Line)) = 1) then Continue;
    if (Line[1] = '(') then Continue;
    if (Line[1] = ')') then Break;
    if Line[Length(Line)] = ',' then
      Delete(Line, Length(Line), 1);
    P := Pos(' ', Line);
    if P = 0 then Continue;
    FieldName := Trim(Copy(Line, 1, P - 1));
    FieldType := Trim(Copy(Line, P + 1, MaxInt));
    P := Pos(' ', FieldType);
    if P > 0 then
      FieldType := Copy(FieldType, 1, P - 1);
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)].Name := FieldName;
    Result[High(Result)].DataType := MapDBTypeToDelphi(FieldType);
  end;
end;

// Funo para converter string em CamelCase completo com base nas "intenes" das palavras
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
  // Remove espaos restantes
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

// Evento que executa a geração
procedure TFormClassGenerator.ButtonGerarClick(Sender: TObject);
var
  InputFields: TArray<string>;
  Fields: TArray<TFieldInfo>;
  FieldInfo: TFieldInfo;
  FieldName, CamelName, TipoUnit, TipoInterface, FieldType, InputText: string;
  I: Integer;
  SetLine, RetornaLine: string;
begin
  LimpaCampos;

  TipoUnit := 'T' + edtUnit.Text;
  TipoInterface := edtInterface.Text;

  InputText := Trim(MemoInput.Text);
  if Pos('CREATE TABLE', UpperCase(InputText)) > 0 then
    Fields := ParseDDL(InputText)
  else
  begin
    InputFields := StringReplace(InputText.ToLower, sLineBreak, '', [rfReplaceAll]).Split([';']);
    SetLength(Fields, Length(InputFields));
    for I := 0 to High(InputFields) do
    begin
      Fields[I].Name := Trim(InputFields[I]);
      Fields[I].DataType := Trim(edtTipo.Text);
    end;
  end;

  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name;
    FieldType := FieldInfo.DataType;
    if FieldName = '' then Continue;

    CamelName := ToCamelCase(FieldName);

    MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');

    SetLine := Format('function Set%s(value: %s): %s;', [CamelName, FieldType, TipoInterface]);
    MemoDecSet.Lines.Add(SetLine);

    SetLine := Format('function %s.Set%s(value: %s): %s;', [TipoUnit, CamelName, FieldType, TipoInterface]);
    MemoSet.Lines.Add(SetLine);
    MemoSet.Lines.Add('begin');
    MemoSet.Lines.Add('  Result := Self;');

    if UpperCase(FieldType) = 'STRING' then
      MemoSet.Lines.Add('  F' + CamelName + ' := Trim(value).ToUpper;')
    else
      MemoSet.Lines.Add('  F' + CamelName + ' := value;');

    MemoSet.Lines.Add('end;');
    MemoSet.Lines.Add('');

    RetornaLine := Format('function Retorna%s: %s;', [CamelName, FieldType]);
    MemoDecRetorna.Lines.Add(RetornaLine);

    RetornaLine := Format('function %s.Retorna%s: %s;', [TipoUnit, CamelName, FieldType]);
    MemoRetorna.Lines.Add(RetornaLine);
    MemoRetorna.Lines.Add('begin');

    if UpperCase(FieldType) = 'STRING' then
      MemoRetorna.Lines.Add('  Result := Trim(F' + CamelName + ').ToUpper;')
    else
      MemoRetorna.Lines.Add('  Result := F' + CamelName + ';');

    MemoRetorna.Lines.Add('end;');
    MemoRetorna.Lines.Add('');

    if UpperCase(FieldType) = 'STRING' then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ''''; ')
    else if (UpperCase(FieldType) = 'INTEGER') or (UpperCase(FieldType) = 'DOUBLE') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := 0; ')
    else if (UpperCase(FieldType) = 'TDATETIME') or (UpperCase(FieldType) = 'TDATE') then
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
