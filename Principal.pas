unit Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, System.RegularExpressions, StrUtils,
  Vcl.Buttons, Vcl.Clipbrd;

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
    btnCopiarDecRetorna: TBitBtn;
    btnCopiarDecSET: TBitBtn;
    btnCopiarDecTipos: TBitBtn;
    btnCopiarFuncRetorna: TBitBtn;
    btnCopiarFuncSet: TBitBtn;
    btnCopiarCamposPadrao: TBitBtn;
    btnCopiarFuncs: TBitBtn;
    btnCopiarDecInterface: TBitBtn;
    TabSheet2: TTabSheet;
    ScrollBox4: TScrollBox;
    Label11: TLabel;
    MemoUnitCompleta: TMemo;
    btnCopiarUnitCompleta: TBitBtn;
    procedure btnCopiarCamposPadraoClick(Sender: TObject);
    procedure btnCopiarDecRetornaClick(Sender: TObject);
    procedure btnCopiarDecSETClick(Sender: TObject);
    procedure btnCopiarDecTiposClick(Sender: TObject);
    procedure btnCopiarFuncRetornaClick(Sender: TObject);
    procedure btnCopiarFuncSetClick(Sender: TObject);
    procedure btnCopiarFuncsClick(Sender: TObject);
    procedure btnCopiarDecInterfaceClick(Sender: TObject);
    procedure btnCopiarUnitCompletaClick(Sender: TObject);
    procedure ButtonGerarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    type
      TFieldInfo = record
        Name: string;
        DataType: string;
        DefaultValue: string; // novo campo
      end;
    function MapDBTypeToDelphi(const DBType: string): string;
    function ParseDDL(const AText: string): TArray<TFieldInfo>;
    function ToCamelCase(const S: string): string;
    procedure LimpaCampos;
    procedure CopiaMemo(AMemo : TMemo);
    procedure CopiaMemos(const AMemos: array of TMemo);
    procedure GerarUnitCompleta(const Fields: TArray<TFieldInfo>; const TipoUnit, TipoInterface, NomeTabela: string);
    function GerarProcedureInserir(const Fields: TArray<TFieldInfo>; const TipoUnit, NomeTabela: string): string;
  public
    { Public declarations }
  end;

var
  FormClassGenerator: TFormClassGenerator;

implementation

{$R *.dfm}


procedure TFormClassGenerator.btnCopiarFuncsClick(Sender: TObject);
begin
  CopiaMemos([MemoRetorna, MemoSet]);
end;

procedure TFormClassGenerator.btnCopiarDecInterfaceClick(Sender: TObject);
begin
  CopiaMemos([MemoDecRetorna, MemoDecSet]);
end;

procedure TFormClassGenerator.btnCopiarUnitCompletaClick(Sender: TObject);
begin
  CopiaMemo(MemoUnitCompleta);
end;


procedure TFormClassGenerator.btnCopiarCamposPadraoClick(Sender: TObject);
begin
  CopiaMemo(MemoCamposPadrao);
end;

procedure TFormClassGenerator.btnCopiarDecRetornaClick(Sender: TObject);
begin
  CopiaMemo(MemoDecRetorna);
end;

procedure TFormClassGenerator.btnCopiarDecSETClick(Sender: TObject);
begin
  CopiaMemo(MemoDecSet);
end;

procedure TFormClassGenerator.btnCopiarDecTiposClick(Sender: TObject);
begin
  CopiaMemo(MemoCampos);
end;

procedure TFormClassGenerator.btnCopiarFuncRetornaClick(Sender: TObject);
begin
  CopiaMemo(MemoRetorna);
end;

procedure TFormClassGenerator.btnCopiarFuncSetClick(Sender: TObject);
begin
  CopiaMemo(MemoSet);
end;

function TFormClassGenerator.MapDBTypeToDelphi(const DBType: string): string;
var
  T: string;
begin
  T := Trim(DBType).ToUpper; // garantir consistência

  // Using regular expression to ensure isolated word matching (\b = word boundary)
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
  L, Line, FieldName, FieldDef, FieldType, RestDef: string;
  P, DefaultPos, NotNullPos, NullPos, DefCutPos: Integer;
  DefaultValue, TempValue: string;
  ClosePos, CutPos, StopPos: Integer;
begin
  Lines := AText.Replace(#13#10, #10).Replace(#13, #10).Split([#10]);

  for L in Lines do
  begin
    Line := Trim(L);
    if Line = '' then
      Continue;
    if Pos('CREATE TABLE', UpperCase(Line)) = 1 then
      Continue;
    if (Line[1] = '(') then
      Continue;
    if (Line[1] = ')') then
      Break;
    if Line[Length(Line)] = ',' then
      Delete(Line, Length(Line), 1);

    // Separar nome do campo
    P := Pos(' ', Line);
    if P = 0 then
      Continue;

    FieldName := Trim(Copy(Line, 1, P - 1));
    FieldDef := Trim(Copy(Line, P + 1, MaxInt));

    // Procurar DEFAULT na definição
    DefaultPos := Pos(' DEFAULT ', UpperCase(FieldDef));
    if DefaultPos = 0 then
      DefaultPos := Pos(' DEFAULT(', UpperCase(FieldDef));

    if DefaultPos > 0 then
    begin
      RestDef := Trim(Copy(FieldDef, DefaultPos + Length(' DEFAULT '), MaxInt));

      // Se vier com parênteses (DEFAULT(...))
      if (Length(RestDef) > 0) and (RestDef[1] = '(') then
      begin
        Delete(RestDef, 1, 1);
        if (Length(RestDef) > 0) and (RestDef[Length(RestDef)] = ')') then
          Delete(RestDef, Length(RestDef), 1);
        RestDef := Trim(RestDef);
      end;

      // Se for string com aspas
      if (Length(RestDef) > 0) and (RestDef[1] = '''') then
      begin
        TempValue := Copy(RestDef, 2, MaxInt);
        ClosePos := Pos('''', TempValue);
        if ClosePos > 0 then
          DefaultValue := '''' + Copy(TempValue, 1, ClosePos - 1) + ''''
        else
          DefaultValue := '';
      end
      else
      begin
        // Se for número, pegar até espaço ou NOT NULL ou NULL
        NotNullPos := Pos(' NOT NULL', UpperCase(RestDef));
        NullPos := Pos(' NULL', UpperCase(RestDef));

        CutPos := 0;
        if (NotNullPos > 0) and ((CutPos = 0) or (NotNullPos < CutPos)) then
          CutPos := NotNullPos;
        if (NullPos > 0) and ((CutPos = 0) or (NullPos < CutPos)) then
          CutPos := NullPos;

        if CutPos > 0 then
          DefaultValue := Trim(Copy(RestDef, 1, CutPos - 1))
        else
        begin
          StopPos := Pos(' ', RestDef);
          if StopPos > 0 then
            DefaultValue := Trim(Copy(RestDef, 1, StopPos - 1))
          else
            DefaultValue := RestDef;
        end;
      end;
    end
    else
      DefaultValue := '';

    // Agora pegar o tipo — tudo que vem antes de DEFAULT/NOT NULL/NULL
    // Primeiro, vamos cortar a definição no DEFAULT ou NOT NULL ou NULL
    DefCutPos := Length(FieldDef) + 1; // valor alto por padrão

    P := Pos(' DEFAULT ', UpperCase(FieldDef));
    if (P > 0) and (P < DefCutPos) then DefCutPos := P;
    P := Pos(' DEFAULT(', UpperCase(FieldDef));
    if (P > 0) and (P < DefCutPos) then DefCutPos := P;
    P := Pos(' NOT NULL', UpperCase(FieldDef));
    if (P > 0) and (P < DefCutPos) then DefCutPos := P;
    P := Pos(' NULL', UpperCase(FieldDef));
    if (P > 0) and (P < DefCutPos) then DefCutPos := P;

    if DefCutPos <= Length(FieldDef) then
      FieldType := Trim(Copy(FieldDef, 1, DefCutPos - 1))
    else
      FieldType := FieldDef;

    // Adicionar no array
    SetLength(Result, Length(Result) + 1);
    Result[High(Result)].Name := FieldName;
    Result[High(Result)].DataType := MapDBTypeToDelphi(FieldType);
    Result[High(Result)].DefaultValue := DefaultValue;
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
      ResultStr := ResultStr + Trim(Cleaned[I]).ToUpper
    else
      ResultStr := ResultStr + Trim(Cleaned[I]).ToLower;
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
  MemoUnitCompleta.Clear;
end;

// Evento que executa a geração
procedure TFormClassGenerator.ButtonGerarClick(Sender: TObject);
var
  InputFields: TArray<string>;
  Fields: TArray<TFieldInfo>;
  FieldInfo: TFieldInfo;
  FieldName, CamelName, TipoUnit, TipoInterface, FieldType, InputText: string;
  DefaultValue, Entry, NomeTabela, TempText: string;
  I, DefaultPos, NotNullPos, TablePos, SpacePos, ParenPos: Integer;
  FieldTokens: TArray<string>;
  SetLine, RetornaLine: string;
  IsDDL: Boolean;
begin
  LimpaCampos;

  TipoUnit := 'T' + ToCamelCase(Trim(edtUnit.Text).ToUpper);
  TipoInterface := 'I' + ToCamelCase(Trim(edtInterface.Text).ToUpper);

  InputText := Trim(MemoInput.Text);
  IsDDL := Pos('CREATE TABLE', UpperCase(InputText)) > 0;
  
  // Extraindo o nome da tabela da DDL
  NomeTabela := '';
  if IsDDL then
  begin
    TablePos := Pos('CREATE TABLE', UpperCase(InputText));
    if TablePos > 0 then
    begin
      TempText := Copy(InputText, TablePos + Length('CREATE TABLE'), Length(InputText));
      TempText := Trim(TempText);
      SpacePos := Pos(' ', TempText);
      ParenPos := Pos('(', TempText);
      
      if (SpacePos > 0) and ((ParenPos = 0) or (SpacePos < ParenPos)) then
        NomeTabela := Trim(Copy(TempText, 1, SpacePos - 1))
      else if ParenPos > 0 then
        NomeTabela := Trim(Copy(TempText, 1, ParenPos - 1))
      else
        NomeTabela := TempText;
        
      // Removendo caracteres especiais do nome da tabela
      NomeTabela := StringReplace(NomeTabela, '"', '', [rfReplaceAll]);
      NomeTabela := StringReplace(NomeTabela, '`', '', [rfReplaceAll]);
      NomeTabela := StringReplace(NomeTabela, '[', '', [rfReplaceAll]);
      NomeTabela := StringReplace(NomeTabela, ']', '', [rfReplaceAll]);
    end;
  end;
  
  // Se não conseguiu extrair da DDL, usa o nome da unit
  if NomeTabela = '' then
    NomeTabela := Trim(edtUnit.Text);

  if IsDDL then
  begin
    // Parse completo com DefaultValue
    Fields := ParseDDL(InputText);
  end
  else
  begin
    // Parse simples manual (não DDL)
    InputFields := StringReplace(InputText.ToLower, sLineBreak, '', [rfReplaceAll]).Split([';']);
    SetLength(Fields, Length(InputFields));
    for I := 0 to High(InputFields) do
    begin
      Fields[I].Name := Trim(InputFields[I]);
      Fields[I].DataType := Trim(edtTipo.Text).ToUpper;
      Fields[I].DefaultValue := ''; // não tem default nesse caso
    end;
  end;

  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name;
    FieldType := FieldInfo.DataType;
    DefaultValue := FieldInfo.DefaultValue;

    if FieldName = '' then Continue;

    // Se não veio da DDL, preciso tentar extrair DEFAULT do texto original (InputFields)
    if not IsDDL then
    begin
      Entry := Trim(InputFields[I]);
      DefaultPos := Pos(' default ', Entry);
      if DefaultPos = 0 then
        DefaultPos := Pos(' default(', Entry);

      if DefaultPos > 0 then
      begin
        FieldName := Trim(Copy(Entry, 1, DefaultPos - 1));
        DefaultValue := Trim(Copy(Entry, DefaultPos + Length(' default '), Length(Entry)));

        NotNullPos := Pos(' not null', DefaultValue);
        if NotNullPos > 0 then
          DefaultValue := Trim(Copy(DefaultValue, 1, NotNullPos - 1));

        DefaultValue := StringReplace(DefaultValue, ')', '', [rfReplaceAll]);
        DefaultValue := StringReplace(DefaultValue, '(', '', [rfReplaceAll]);
        DefaultValue := StringReplace(DefaultValue, ';', '', [rfReplaceAll]);
      end
      else
        DefaultValue := '';
    end;

    CamelName := ToCamelCase(FieldName);

      // Geração dos campos privados
    MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');

    // Geração das declarações e implementações dos métodos Set
    SetLine := Format(
      'function Set%s(value: %s): %s;',
      [CamelName, FieldType, TipoInterface]
    );
    MemoDecSet.Lines.Add(SetLine);

    SetLine := Format(
      'function %s.Set%s(value: %s): %s;',
      [TipoUnit, CamelName, FieldType, TipoInterface]
    );
    MemoSet.Lines.Add(SetLine);
    MemoSet.Lines.Add('begin');
    MemoSet.Lines.Add('  Result := Self;');

    if UpperCase(FieldType) = 'STRING' then
      MemoSet.Lines.Add('  F' + CamelName + ' := Trim(value).ToUpper;')
    else
      MemoSet.Lines.Add('  F' + CamelName + ' := value;');

    MemoSet.Lines.Add('end;');
    MemoSet.Lines.Add('');

    // Geração das declarações e implementações dos métodos Retorna
    RetornaLine := Format(
      'function Retorna%s: %s;',
      [CamelName, FieldType]
    );
    MemoDecRetorna.Lines.Add(RetornaLine);

    RetornaLine := Format(
      'function %s.Retorna%s: %s;',
      [TipoUnit, CamelName, FieldType]
    );
    MemoRetorna.Lines.Add(RetornaLine);
    MemoRetorna.Lines.Add('begin');

    if UpperCase(FieldType) = 'STRING' then
      MemoRetorna.Lines.Add('  Result := Trim(F' + CamelName + ').ToUpper;')
    else
      MemoRetorna.Lines.Add('  Result := F' + CamelName + ';');

    MemoRetorna.Lines.Add('end;');
    MemoRetorna.Lines.Add('');

    // Geração do campo padrão (DefaultValue ou valor padrão)
    if DefaultValue <> '' then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + DefaultValue + ';')
    else if UpperCase(FieldType) = 'STRING' then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ''''; ')
    else if (UpperCase(FieldType) = 'INTEGER') or (UpperCase(FieldType) = 'DOUBLE') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := 0; ')
    else if (UpperCase(FieldType) = 'TDATETIME') or (UpperCase(FieldType) = 'TDATE') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := EncodeDate(1900, 1, 1); ')
    else
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := null; ');
  end;

  // Gerando a unit completa
  GerarUnitCompleta(Fields, TipoUnit, TipoInterface, NomeTabela);

  Application.MessageBox('Gerado com sucesso!', 'Sucesso!', MB_OK + MB_ICONINFORMATION);
  PageControl1.TabIndex := 2; // Mudando para a aba da unit completa
end;

procedure TFormClassGenerator.FormShow(Sender: TObject);
begin
  Randomize; // Inicializa o gerador de números aleatórios
  LimpaCampos;
  PageControl1.TabIndex := 0;
end;

procedure TFormClassGenerator.CopiaMemo(AMemo : TMemo);
begin
  AMemo.SelectAll;
  AMemo.CopyToClipboard;
  ShowMessage('Copiado');
end;

// Método para gerar a procedure Inserir automaticamente
function TFormClassGenerator.GerarProcedureInserir(const Fields: TArray<TFieldInfo>; const TipoUnit, NomeTabela: string): string;
var
  I: Integer;
  FieldInfo: TFieldInfo;
  CamelName, FieldName: string;
  SqlInsert, SqlValues, SqlParams: string;
begin
  Result := '';
  
  // Início da procedure
  Result := Result + 'procedure ' + TipoUnit + '.Inserir;' + sLineBreak;
  Result := Result + 'var' + sLineBreak;
  Result := Result + '  vQuery : TFDQuery;' + sLineBreak;
  Result := Result + 'begin' + sLineBreak;
  Result := Result + '  vQuery := TFDQuery.Create(nil);' + sLineBreak;
  Result := Result + '  try' + sLineBreak;
  Result := Result + '    vQuery.Connection := FConexao;' + sLineBreak;
  Result := Result + '    vQuery.Close;' + sLineBreak;
  Result := Result + '    vQuery.SQL.Clear;' + sLineBreak;
  
  // Montando o SQL INSERT
  SqlInsert := '    vQuery.SQL.Add(''INSERT INTO ' + NomeTabela.ToUpper + ' (';
  SqlValues := '    vQuery.SQL.Add(''VALUES (';
  SqlParams := '';
  
  // Adicionando campos ao SQL
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name.ToUpper;
    CamelName := ToCamelCase(FieldInfo.Name);
    
    if I > 0 then
    begin
      SqlInsert := SqlInsert + ', ';
      SqlValues := SqlValues + ', ';
    end;
    
    SqlInsert := SqlInsert + FieldName;
    SqlValues := SqlValues + ':' + FieldName;
    
    // Adicionando parâmetros
    SqlParams := SqlParams + '    vQuery.ParamByName(''' + FieldName + ''')';
    
    if UpperCase(FieldInfo.DataType) = 'INTEGER' then
      SqlParams := SqlParams + '.AsInteger'
    else if UpperCase(FieldInfo.DataType) = 'DOUBLE' then
      SqlParams := SqlParams + '.AsFloat'
    else if UpperCase(FieldInfo.DataType) = 'TDATETIME' then
      SqlParams := SqlParams + '.AsDateTime'
    else if UpperCase(FieldInfo.DataType) = 'STRING' then
      SqlParams := SqlParams + '.AsString'
    else
      SqlParams := SqlParams + '.AsVariant';
    
    SqlParams := SqlParams + ' := Retorna' + CamelName + ';' + sLineBreak;
  end;
  
  SqlInsert := SqlInsert + ')'';';
  SqlValues := SqlValues + ')'';';
  
  // Adicionando o SQL ao resultado
  Result := Result + SqlInsert + sLineBreak;
  Result := Result + SqlValues + sLineBreak;
  Result := Result + sLineBreak;
  Result := Result + SqlParams;
  Result := Result + '    vQuery.ExecSQL;' + sLineBreak;
  Result := Result + '  finally' + sLineBreak;
  Result := Result + '    FreeAndNil(vQuery);' + sLineBreak;
  Result := Result + '  end;' + sLineBreak;
  Result := Result + 'end;' + sLineBreak;
  
  Result := Result + sLineBreak;
end;

// Método para gerar a unit completa baseada no modelo uAidf
procedure TFormClassGenerator.GerarUnitCompleta(const Fields: TArray<TFieldInfo>; const TipoUnit, TipoInterface, NomeTabela: string);
var
  I: Integer;
  FieldInfo: TFieldInfo;
  CamelName, FieldType: string;
  UnitContent: string;
  GUID: string;
begin
  // Gerando um GUID único para a interface
  GUID := Format('{%.8X-%.4X-%.4X-%.4X-%.12X}', [
    Random(MaxInt), Random(65536), Random(65536), Random(65536), Random(MaxInt)
  ]);
  
  UnitContent := '';
  
  // Cabeçalho da unit
  UnitContent := UnitContent + 'unit u' + TipoUnit.Substring(1) + ';' + sLineBreak + sLineBreak;
  UnitContent := UnitContent + 'interface' + sLineBreak + sLineBreak;
  UnitContent := UnitContent + 'uses' + sLineBreak;
  UnitContent := UnitContent + '  System.SysUtils, FireDAC.Comp.Client;' + sLineBreak + sLineBreak;
  UnitContent := UnitContent + 'type' + sLineBreak;
  
  // Declaração da interface
  UnitContent := UnitContent + '  ' + TipoInterface + ' = interface' + sLineBreak;
  UnitContent := UnitContent + '  [''' + GUID + ''']' + sLineBreak + sLineBreak;
  
  // Métodos Retorna da interface
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    UnitContent := UnitContent + '  function Retorna' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak;
  
  // Métodos Set da interface
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    UnitContent := UnitContent + '  function Set' + CamelName + '(value: ' + FieldType + '): ' + TipoInterface + ';' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak + '  procedure Inserir;' + sLineBreak;
  UnitContent := UnitContent + '  end;' + sLineBreak + sLineBreak;
  
  // Declaração da classe
  UnitContent := UnitContent + '  ' + TipoUnit + ' = class(TInterfacedObject, ' + TipoInterface + ')' + sLineBreak;
  UnitContent := UnitContent + '  private' + sLineBreak;
  UnitContent := UnitContent + '    FConexao : TFDCustomConnection;' + sLineBreak + sLineBreak;
  
  // Campos privados
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    UnitContent := UnitContent + '    F' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak + '    constructor Create(Conexao : TFDConnection);' + sLineBreak + sLineBreak;
  UnitContent := UnitContent + '  public' + sLineBreak + sLineBreak;
  UnitContent := UnitContent + '    Destructor Destroy; Override;' + sLineBreak;
  UnitContent := UnitContent + '    Class Function New(Conexao : TFDConnection): ' + TipoInterface + ';' + sLineBreak + sLineBreak;
  
  // Declarações públicas dos métodos Retorna
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    UnitContent := UnitContent + '    function Retorna' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak;
  
  // Declarações públicas dos métodos Set
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    UnitContent := UnitContent + '    function Set' + CamelName + '(value: ' + FieldType + '): ' + TipoInterface + ';' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak + '    procedure Inserir;' + sLineBreak;
  UnitContent := UnitContent + '  end;' + sLineBreak + sLineBreak;
  
  // Seção implementation
  UnitContent := UnitContent + 'implementation' + sLineBreak + sLineBreak;
  
  // Implementação dos métodos Retorna
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    
    UnitContent := UnitContent + 'function ' + TipoUnit + '.Retorna' + CamelName + ': ' + FieldType + ';' + sLineBreak;
    UnitContent := UnitContent + 'begin' + sLineBreak;
    
    if UpperCase(FieldType) = 'STRING' then
      UnitContent := UnitContent + '  Result := Trim(F' + CamelName + ').ToUpper;' + sLineBreak
    else
      UnitContent := UnitContent + '  Result := F' + CamelName + ';' + sLineBreak;
      
    UnitContent := UnitContent + 'end;' + sLineBreak + sLineBreak;
  end;
  
  // Constructor
  UnitContent := UnitContent + 'constructor ' + TipoUnit + '.Create(Conexao : TFDConnection);' + sLineBreak;
  UnitContent := UnitContent + 'begin' + sLineBreak;
  UnitContent := UnitContent + '  FConexao := Conexao;' + sLineBreak + sLineBreak;
  
  // Inicialização dos campos no constructor
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    
    if FieldInfo.DefaultValue <> '' then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak
    else if UpperCase(FieldType) = 'STRING' then
      UnitContent := UnitContent + '  F' + CamelName + ' := '''';' + sLineBreak
    else if (UpperCase(FieldType) = 'INTEGER') or (UpperCase(FieldType) = 'DOUBLE') then
      UnitContent := UnitContent + '  F' + CamelName + ' := 0;' + sLineBreak
    else if UpperCase(FieldType) = 'TDATETIME' then
      UnitContent := UnitContent + '  F' + CamelName + ' := EncodeDate(1900, 1, 1);' + sLineBreak;
  end;
  
  UnitContent := UnitContent + sLineBreak + 'end;' + sLineBreak + sLineBreak;
  
  // Destructor
  UnitContent := UnitContent + 'destructor ' + TipoUnit + '.Destroy;' + sLineBreak;
  UnitContent := UnitContent + 'begin' + sLineBreak;
  UnitContent := UnitContent + '  inherited;' + sLineBreak;
  UnitContent := UnitContent + 'end;' + sLineBreak + sLineBreak;
  
  // Procedure Inserir
  UnitContent := UnitContent + GerarProcedureInserir(Fields, TipoUnit, NomeTabela);
  
  // Método New
  UnitContent := UnitContent + 'class function ' + TipoUnit + '.New(Conexao : TFDConnection): ' + TipoInterface + ';' + sLineBreak;
  UnitContent := UnitContent + 'begin' + sLineBreak;
  UnitContent := UnitContent + '  Result := Self.Create(Conexao);' + sLineBreak;
  UnitContent := UnitContent + 'end;' + sLineBreak + sLineBreak;
  
  // Implementação dos métodos Set
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    
    UnitContent := UnitContent + 'function ' + TipoUnit + '.Set' + CamelName + '(value: ' + FieldType + '): ' + TipoInterface + ';' + sLineBreak;
    UnitContent := UnitContent + 'begin' + sLineBreak;
    UnitContent := UnitContent + '  Result := Self;' + sLineBreak;
    
    if UpperCase(FieldType) = 'STRING' then
      UnitContent := UnitContent + '  F' + CamelName + ' := Trim(value).ToUpper;' + sLineBreak
    else
      UnitContent := UnitContent + '  F' + CamelName + ' := value;' + sLineBreak;
      
    UnitContent := UnitContent + 'end;' + sLineBreak + sLineBreak;
  end;
  
  // Final da unit
  UnitContent := UnitContent + 'end.' + sLineBreak;
  
  // Colocando o conteúdo no memo
  MemoUnitCompleta.Lines.Text := UnitContent;
end;

procedure TFormClassGenerator.CopiaMemos(const AMemos: array of TMemo);
var
  Combined: string;
  I: Integer;
begin
  Combined := '';
  for I := Low(AMemos) to High(AMemos) do
  begin
    if Combined <> '' then
      Combined := Combined + sLineBreak;
    Combined := Combined + AMemos[I].Lines.Text;
  end;
  Clipboard.AsText := Combined;
  ShowMessage('Copiado');
end;

end.
