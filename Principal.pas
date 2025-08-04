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
    Label12: TLabel;
    MemoInput: TMemo;
    MemoInsert: TMemo;
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
    function ParseInsertValues(const InsertText: string): TArray<TFieldInfo>;
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

// Função para extrair valores de um script INSERT e usar como valores padrão
function TFormClassGenerator.ParseInsertValues(const InsertText: string): TArray<TFieldInfo>;
var
  CleanText, FieldsPart, ValuesPart: string;
  FieldsStartPos, FieldsEndPos, ValuesStartPos, ValuesEndPos: Integer;
  FieldsArray, ValuesArray: TArray<string>;
  I: Integer;
  FieldName, FieldValue: string;
begin
  SetLength(Result, 0);
  
  if Trim(InsertText) = '' then
    Exit;
    
  // Limpar o texto removendo quebras de linha e espaços extras
  CleanText := StringReplace(InsertText, #13#10, ' ', [rfReplaceAll]);
  CleanText := StringReplace(CleanText, #13, ' ', [rfReplaceAll]);
  CleanText := StringReplace(CleanText, #10, ' ', [rfReplaceAll]);
  CleanText := Trim(CleanText);
  
  // Procurar a parte dos campos (entre parênteses após o nome da tabela)
  FieldsStartPos := Pos('(', CleanText);
  if FieldsStartPos = 0 then
    Exit;
    
  FieldsEndPos := Pos(')', CleanText);
  if FieldsEndPos = 0 then
    Exit;
    
  // Extrair a parte dos campos
  FieldsPart := Copy(CleanText, FieldsStartPos + 1, FieldsEndPos - FieldsStartPos - 1);
  FieldsPart := Trim(FieldsPart);
  
  // Procurar a parte VALUES
  ValuesStartPos := Pos('VALUES', UpperCase(CleanText));
  if ValuesStartPos = 0 then
    Exit;
    
  // Procurar o primeiro parênteses após VALUES
  ValuesStartPos := Pos('(', CleanText, ValuesStartPos);
  if ValuesStartPos = 0 then
    Exit;
    
  // Procurar o último parênteses (pode ter ponto e vírgula no final)
  ValuesEndPos := Pos(')', CleanText, ValuesStartPos);
  if ValuesEndPos = 0 then
    Exit;
    
  // Extrair a parte dos valores
  ValuesPart := Copy(CleanText, ValuesStartPos + 1, ValuesEndPos - ValuesStartPos - 1);
  ValuesPart := Trim(ValuesPart);
  
  // Dividir campos e valores por vírgula
  FieldsArray := FieldsPart.Split([',']);
  ValuesArray := ValuesPart.Split([',']);
  
  // Verificar se o número de campos e valores é igual
  if Length(FieldsArray) <> Length(ValuesArray) then
    Exit;
    
  // Processar cada campo e valor
  SetLength(Result, Length(FieldsArray));
  for I := 0 to High(FieldsArray) do
  begin
    FieldName := Trim(FieldsArray[I]);
    FieldValue := Trim(ValuesArray[I]);
    
    // Remover espaços e caracteres especiais do nome do campo
    FieldName := StringReplace(FieldName, ' ', '', [rfReplaceAll]);
    FieldName := StringReplace(FieldName, #9, '', [rfReplaceAll]);
    
    // Processar o valor
    if (FieldValue <> '') and (UpperCase(FieldValue) <> 'NULL') then
    begin
      // Se o valor está entre aspas simples, manter as aspas
      if (Length(FieldValue) >= 2) and (FieldValue[1] = '''') and (FieldValue[Length(FieldValue)] = '''') then
      begin
        // É uma string, manter as aspas
        Result[I].DefaultValue := FieldValue;
      end
      else
      begin
        // É um número ou outro tipo, usar como está
        Result[I].DefaultValue := FieldValue;
      end;
    end
    else
    begin
      // Valor vazio ou NULL - será definido depois baseado no tipo do campo da DDL
      Result[I].DefaultValue := 'NULL_PLACEHOLDER';
    end;
    
    Result[I].Name := FieldName;
    Result[I].DataType := ''; // Será definido pela DDL
  end;
end;

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
  // MemoInsert.Clear; - Removido para preservar os valores do INSERT durante a geração
end;

// Evento que executa a geração
procedure TFormClassGenerator.ButtonGerarClick(Sender: TObject);
var
  InputFields: TArray<string>;
  Fields, InsertFields: TArray<TFieldInfo>;
  FieldInfo: TFieldInfo;
  FieldName, CamelName, TipoUnit, TipoInterface, FieldType, InputText, InsertText: string;
  DefaultValue, Entry, NomeTabela, TempText: string;
  I, J, DefaultPos, NotNullPos, TablePos, SpacePos, ParenPos: Integer;
  FieldTokens: TArray<string>;
  SetLine, RetornaLine: string;
  IsDDL: Boolean;
begin
  LimpaCampos;

  TipoUnit := 'T' + ToCamelCase(Trim(edtUnit.Text).ToUpper);
  TipoInterface := 'I' + ToCamelCase(Trim(edtInterface.Text).ToUpper);

  InputText := Trim(MemoInput.Text);
  InsertText := Trim(MemoInsert.Text);
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

  // Processar o script INSERT se fornecido
  if InsertText <> '' then
    InsertFields := ParseInsertValues(InsertText)
  else
    SetLength(InsertFields, 0);

  if IsDDL then
  begin
    // Parse completo com DefaultValue
    Fields := ParseDDL(InputText);
    
    // Aplicar valores do INSERT como padrão se disponíveis
    if Length(InsertFields) > 0 then
    begin
      for I := 0 to High(Fields) do
      begin
        for J := 0 to High(InsertFields) do
        begin
          // Comparar nomes dos campos (case insensitive)
          if UpperCase(Fields[I].Name) = UpperCase(InsertFields[J].Name) then
          begin
            // Se o campo não tem valor padrão na DDL, usar o valor do INSERT
            if Fields[I].DefaultValue = '' then
            begin
              // Verificar se é um placeholder NULL e definir valor padrão baseado no tipo
            if InsertFields[J].DefaultValue = 'NULL_PLACEHOLDER' then
            begin
              // Definir valor padrão baseado no tipo do campo
              if Fields[I].DataType = 'String' then
                Fields[I].DefaultValue := ''''''
              else if (Fields[I].DataType = 'Integer') or (Fields[I].DataType = 'Double') then
                Fields[I].DefaultValue := '0'
              else if Fields[I].DataType = 'TDateTime' then
                Fields[I].DefaultValue := 'EncodeDate(1900, 1, 1)'
              else
                Fields[I].DefaultValue := ''; // Fallback para outros tipos
              end
              else
              begin
                Fields[I].DefaultValue := InsertFields[J].DefaultValue;
              end;
            end;
            Break;
          end;
        end;
      end;
    end;
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
      
      // Aplicar valores do INSERT se disponíveis
      if Length(InsertFields) > 0 then
      begin
        for J := 0 to High(InsertFields) do
        begin
          if UpperCase(Fields[I].Name) = UpperCase(InsertFields[J].Name) then
          begin
            // Verificar se é um placeholder NULL e definir valor padrão baseado no tipo
            if InsertFields[J].DefaultValue = 'NULL_PLACEHOLDER' then
            begin
              // Definir valor padrão baseado no tipo do campo
              if Fields[I].DataType = 'String' then
                Fields[I].DefaultValue := ''''''
              else if (Fields[I].DataType = 'Integer') or (Fields[I].DataType = 'Double') then
                Fields[I].DefaultValue := '0'
              else if Fields[I].DataType = 'TDateTime' then
                Fields[I].DefaultValue := 'EncodeDate(1900, 1, 1)'
              else
                Fields[I].DefaultValue := ''; // Fallback para outros tipos
            end
            else
            begin
              Fields[I].DefaultValue := InsertFields[J].DefaultValue;
            end;
            Break;
          end;
        end;
      end;
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
      end;
      // Se não encontrou DEFAULT na entrada manual, manter o valor do INSERT (se houver)
      // DefaultValue já foi definido pelo INSERT na seção anterior, não sobrescrever
    end;

    CamelName := ToCamelCase(FieldName);

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

    if FieldType = 'String' then
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

    if FieldType = 'String' then
      MemoRetorna.Lines.Add('  Result := Trim(F' + CamelName + ').ToUpper;')
    else
      MemoRetorna.Lines.Add('  Result := F' + CamelName + ';');

    MemoRetorna.Lines.Add('end;');
    MemoRetorna.Lines.Add('');

  end;

  // Geração dos campos privados agrupados por tipo no MemoCampos
  
  // Campos STRING
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'String' then
      MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');
  end;
  
  // Campos INTEGER
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'Integer' then
      MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');
  end;
  
  // Campos DOUBLE
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'Double' then
      MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');
  end;
  
  // Campos TDATETIME
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'TDateTime' then
      MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');
  end;
  
  // Outros tipos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
      MemoCampos.Lines.Add('F' + CamelName + ': ' + FieldType + ';');
  end;

  // Geração dos campos padrão agrupados por tipo no MemoCamposPadrao
  
  // Campos com valores específicos (do INSERT ou DEFAULT da DDL) - agrupados por tipo
  
  // Campos STRING com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'String') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';');
  end;
  
  // Campos INTEGER com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'Integer') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';');
  end;
  
  // Campos DOUBLE com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'Double') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';');
  end;
  
  // Campos TDATETIME com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'TDateTime') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';');
  end;
  
  // Outros tipos com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and 
       not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';');
  end;
  
  // Separador se houver campos com valores específicos
  for I := 0 to High(Fields) do
  begin
    if Fields[I].DefaultValue <> '' then
    begin
      MemoCamposPadrao.Lines.Add('');
      Break;
    end;
  end;
  
  // Campos STRING (valores vazios)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'String') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := '''';');
  end;
  
  // Campos INTEGER (valores numéricos = 0)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'Integer') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := 0;');
  end;
  
  // Campos DOUBLE (valores numéricos = 0)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'Double') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := 0;');
  end;
  
  // Campos TDATETIME (data padrão)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'TDateTime') then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := EncodeDate(1900, 1, 1);');
  end;
  
  // Outros tipos (null)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and 
       not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
      MemoCamposPadrao.Lines.Add('F' + CamelName + ' := null;');
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
  SqlParams: string;
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
  
  // Montando o SQL INSERT com campos organizados em linhas
  Result := Result + '    vQuery.SQL.Add(''INSERT INTO ' + NomeTabela.ToUpper + ' ('');' + sLineBreak;
  
  // Adicionando cada campo em uma linha separada
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name.ToUpper;
    
    if I = 0 then
      Result := Result + '    vQuery.SQL.Add(''  ' + FieldName
    else
      Result := Result + '    vQuery.SQL.Add('', ' + FieldName;
    
    if I = High(Fields) then
      Result := Result + ''');' + sLineBreak
    else
      Result := Result + ''');' + sLineBreak;
  end;
  
  // Montando a parte VALUES com parâmetros organizados em linhas
  Result := Result + '    vQuery.SQL.Add(''VALUES ('');' + sLineBreak;
  
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name.ToUpper;
    
    if I = 0 then
      Result := Result + '    vQuery.SQL.Add(''  :' + FieldName
    else
      Result := Result + '    vQuery.SQL.Add('', :' + FieldName;
    
    if I = High(Fields) then
      Result := Result + ''');' + sLineBreak
    else
      Result := Result + ''');' + sLineBreak;
  end;
  
  Result := Result + sLineBreak;
  
  // Adicionando parâmetros organizados
  SqlParams := '';
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    FieldName := FieldInfo.Name.ToUpper;
    CamelName := ToCamelCase(FieldInfo.Name);
    
    // Adicionando parâmetros com identação correta
    SqlParams := SqlParams + '    vQuery.ParamByName(''' + FieldName + ''')';
    
    if FieldInfo.DataType = 'Integer' then
      SqlParams := SqlParams + '.AsInteger'
    else if FieldInfo.DataType = 'Double' then
      SqlParams := SqlParams + '.AsFloat'
    else if FieldInfo.DataType = 'TDateTime' then
      SqlParams := SqlParams + '.AsDateTime'
    else if FieldInfo.DataType = 'String' then
      SqlParams := SqlParams + '.AsString'
    else
      SqlParams := SqlParams + '.AsVariant';
    
    SqlParams := SqlParams + ' := Retorna' + CamelName + ';' + sLineBreak;
  end;
  
  // Adicionando os parâmetros ao resultado
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
  
  // Campos privados agrupados por tipo
  
  // Campos STRING
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'String' then
      UnitContent := UnitContent + '    F' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  // Campos INTEGER
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'Integer' then
      UnitContent := UnitContent + '    F' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  // Campos DOUBLE
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'Double' then
      UnitContent := UnitContent + '    F' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  // Campos TDATETIME e TDATE
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if FieldType = 'TDateTime' then
      UnitContent := UnitContent + '    F' + CamelName + ': ' + FieldType + ';' + sLineBreak;
  end;
  
  // Outros tipos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
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
    
    if FieldType = 'String' then
      UnitContent := UnitContent + '  Result := Trim(F' + CamelName + ').ToUpper;' + sLineBreak
    else
      UnitContent := UnitContent + '  Result := F' + CamelName + ';' + sLineBreak;
      
    UnitContent := UnitContent + 'end;' + sLineBreak + sLineBreak;
  end;
  
  // Constructor
  UnitContent := UnitContent + 'constructor ' + TipoUnit + '.Create(Conexao : TFDConnection);' + sLineBreak;
  UnitContent := UnitContent + 'begin' + sLineBreak;
  UnitContent := UnitContent + '  FConexao := Conexao;' + sLineBreak + sLineBreak;
  
  // Inicialização dos campos no constructor - agrupados por tipo
  
  // Campos com valores específicos (do INSERT ou DEFAULT da DDL) - agrupados por tipo
  
  // Campos STRING com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'String') then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak;
  end;
  
  // Campos INTEGER com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'Integer') then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak;
  end;
  
  // Campos DOUBLE com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'Double') then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak;
  end;
  
  // Campos TDATETIME com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and (FieldType = 'TDateTime') then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak;
  end;
  
  // Outros tipos com valores específicos
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue <> '') and 
       not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
      UnitContent := UnitContent + '  F' + CamelName + ' := ' + FieldInfo.DefaultValue + ';' + sLineBreak;
  end;
  
  // Separador se houver campos com valores específicos
  for I := 0 to High(Fields) do
  begin
    if Fields[I].DefaultValue <> '' then
    begin
      UnitContent := UnitContent + sLineBreak;
      Break;
    end;
  end;
  
  // Campos STRING (valores vazios)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'String') then
      UnitContent := UnitContent + '  F' + CamelName + ' := '''';' + sLineBreak;
  end;
  
  // Campos INTEGER (valores numéricos = 0)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'Integer') then
      UnitContent := UnitContent + '  F' + CamelName + ' := 0;' + sLineBreak;
  end;
  
  // Campos DOUBLE (valores numéricos = 0)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'Double') then
      UnitContent := UnitContent + '  F' + CamelName + ' := 0;' + sLineBreak;
  end;
  
  // Campos TDATETIME (data padrão)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and (FieldType = 'TDateTime') then
      UnitContent := UnitContent + '  F' + CamelName + ' := EncodeDate(1900, 1, 1);' + sLineBreak;
  end;
  
  // Outros tipos (valores null)
  for I := 0 to High(Fields) do
  begin
    FieldInfo := Fields[I];
    CamelName := ToCamelCase(FieldInfo.Name);
    FieldType := FieldInfo.DataType;
    if (FieldInfo.DefaultValue = '') and 
       not ((FieldType = 'String') or 
            (FieldType = 'Integer') or 
            (FieldType = 'Double') or 
            (FieldType = 'TDateTime')) then
      UnitContent := UnitContent + '  F' + CamelName + ' := null;' + sLineBreak;
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
    
    if FieldType = 'String' then
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
