unit uAidf;

interface

uses
  System.SysUtils, FireDAC.Comp.Client;

type
  IAidf = interface
  ['{E28004AB-49C1-462A-B880-DFBB7B7A9195}']

  function RetornaCodigo: Integer;
  function RetornaNumerodanf: Integer;
  function RetornaCodgrafica: Integer;
  function RetornaCodmodelo: String;
  function RetornaSerie: String;
  function RetornaSubserie: String;
  function RetornaQuantidadedenotas: Integer;
  function RetornaNumeracaoinicial: Integer;
  function RetornaNumeracaofinal: Integer;
  function RetornaDataconfeccaonf: TDateTime;
  function RetornaFatura: String;
  function RetornaFimdeuso: String;
  function RetornaNraidf: Integer;
  function RetornaOrgao: String;
  function RetornaDatalimiteemissaonf: TDateTime;
  function RetornaCodigoemp: Integer;
  function RetornaVerifcanfependente: String;
  function RetornaImprimeaogravar: String;
  function RetornaEnvianfeletronica: String;
  function RetornaModoscan: String;
  function RetornaBloqueiaservico: String;
  function RetornaEnviacteletronico: String;
  function RetornaModosvc: String;
  function RetornaVerificactependente: String;
  function RetornaBloqueiaprodutos: String;
  function RetornaLiberadata: String;
  function RetornaEnvianfseletronica: String;
  function RetornaFatlocacao: String;
  function RetornaAutorizacaofat: String;
  function RetornaImportaxml: String;
  function RetornaProvedor: String;
  function RetornaDigitamanual: String;
  function RetornaEnvionfseapp: String;
  function RetornaCnpj: String;

  function SetCodigo(value: Integer): IAidf;
  function SetNumerodanf(value: Integer): IAidf;
  function SetCodgrafica(value: Integer): IAidf;
  function SetCodmodelo(value: String): IAidf;
  function SetSerie(value: String): IAidf;
  function SetSubserie(value: String): IAidf;
  function SetQuantidadedenotas(value: Integer): IAidf;
  function SetNumeracaoinicial(value: Integer): IAidf;
  function SetNumeracaofinal(value: Integer): IAidf;
  function SetDataconfeccaonf(value: TDateTime): IAidf;
  function SetFatura(value: String): IAidf;
  function SetFimdeuso(value: String): IAidf;
  function SetNraidf(value: Integer): IAidf;
  function SetOrgao(value: String): IAidf;
  function SetDatalimiteemissaonf(value: TDateTime): IAidf;
  function SetCodigoemp(value: Integer): IAidf;
  function SetVerifcanfependente(value: String): IAidf;
  function SetImprimeaogravar(value: String): IAidf;
  function SetEnvianfeletronica(value: String): IAidf;
  function SetModoscan(value: String): IAidf;
  function SetBloqueiaservico(value: String): IAidf;
  function SetEnviacteletronico(value: String): IAidf;
  function SetModosvc(value: String): IAidf;
  function SetVerificactependente(value: String): IAidf;
  function SetBloqueiaprodutos(value: String): IAidf;
  function SetLiberadata(value: String): IAidf;
  function SetEnvianfseletronica(value: String): IAidf;
  function SetFatlocacao(value: String): IAidf;
  function SetAutorizacaofat(value: String): IAidf;
  function SetImportaxml(value: String): IAidf;
  function SetProvedor(value: String): IAidf;
  function SetDigitamanual(value: String): IAidf;
  function SetEnvionfseapp(value: String): IAidf;
  function SetCnpj(value: String): IAidf;


  end;

  TAidf = class(TInterfacedObject, IAidf)
  private
    FConexao : TFDCustomConnection;

    FCodigo: Integer;
    FNumerodanf: Integer;
    FCodgrafica: Integer;
    FCodmodelo: String;
    FSerie: String;
    FSubserie: String;
    FQuantidadedenotas: Integer;
    FNumeracaoinicial: Integer;
    FNumeracaofinal: Integer;
    FDataconfeccaonf: TDateTime;
    FFatura: String;
    FFimdeuso: String;
    FNraidf: Integer;
    FOrgao: String;
    FDatalimiteemissaonf: TDateTime;
    FCodigoemp: Integer;
    FVerifcanfependente: String;
    FImprimeaogravar: String;
    FEnvianfeletronica: String;
    FModoscan: String;
    FBloqueiaservico: String;
    FEnviacteletronico: String;
    FModosvc: String;
    FVerificactependente: String;
    FBloqueiaprodutos: String;
    FLiberadata: String;
    FEnvianfseletronica: String;
    FFatlocacao: String;
    FAutorizacaofat: String;
    FImportaxml: String;
    FProvedor: String;
    FDigitamanual: String;
    FEnvionfseapp: String;
    FCnpj: String;


      constructor Create(Conexao : TFDConnection);

  public

    Destructor Destroy; Override;
    Class Function New(Conexao : TFDConnection): IAidf;

    function RetornaCodigo: Integer;
    function RetornaNumerodanf: Integer;
    function RetornaCodgrafica: Integer;
    function RetornaCodmodelo: String;
    function RetornaSerie: String;
    function RetornaSubserie: String;
    function RetornaQuantidadedenotas: Integer;
    function RetornaNumeracaoinicial: Integer;
    function RetornaNumeracaofinal: Integer;
    function RetornaDataconfeccaonf: TDateTime;
    function RetornaFatura: String;
    function RetornaFimdeuso: String;
    function RetornaNraidf: Integer;
    function RetornaOrgao: String;
    function RetornaDatalimiteemissaonf: TDateTime;
    function RetornaCodigoemp: Integer;
    function RetornaVerifcanfependente: String;
    function RetornaImprimeaogravar: String;
    function RetornaEnvianfeletronica: String;
    function RetornaModoscan: String;
    function RetornaBloqueiaservico: String;
    function RetornaEnviacteletronico: String;
    function RetornaModosvc: String;
    function RetornaVerificactependente: String;
    function RetornaBloqueiaprodutos: String;
    function RetornaLiberadata: String;
    function RetornaEnvianfseletronica: String;
    function RetornaFatlocacao: String;
    function RetornaAutorizacaofat: String;
    function RetornaImportaxml: String;
    function RetornaProvedor: String;
    function RetornaDigitamanual: String;
    function RetornaEnvionfseapp: String;
    function RetornaCnpj: String;

    function SetCodigo(value: Integer): IAidf;
    function SetNumerodanf(value: Integer): IAidf;
    function SetCodgrafica(value: Integer): IAidf;
    function SetCodmodelo(value: String): IAidf;
    function SetSerie(value: String): IAidf;
    function SetSubserie(value: String): IAidf;
    function SetQuantidadedenotas(value: Integer): IAidf;
    function SetNumeracaoinicial(value: Integer): IAidf;
    function SetNumeracaofinal(value: Integer): IAidf;
    function SetDataconfeccaonf(value: TDateTime): IAidf;
    function SetFatura(value: String): IAidf;
    function SetFimdeuso(value: String): IAidf;
    function SetNraidf(value: Integer): IAidf;
    function SetOrgao(value: String): IAidf;
    function SetDatalimiteemissaonf(value: TDateTime): IAidf;
    function SetCodigoemp(value: Integer): IAidf;
    function SetVerifcanfependente(value: String): IAidf;
    function SetImprimeaogravar(value: String): IAidf;
    function SetEnvianfeletronica(value: String): IAidf;
    function SetModoscan(value: String): IAidf;
    function SetBloqueiaservico(value: String): IAidf;
    function SetEnviacteletronico(value: String): IAidf;
    function SetModosvc(value: String): IAidf;
    function SetVerificactependente(value: String): IAidf;
    function SetBloqueiaprodutos(value: String): IAidf;
    function SetLiberadata(value: String): IAidf;
    function SetEnvianfseletronica(value: String): IAidf;
    function SetFatlocacao(value: String): IAidf;
    function SetAutorizacaofat(value: String): IAidf;
    function SetImportaxml(value: String): IAidf;
    function SetProvedor(value: String): IAidf;
    function SetDigitamanual(value: String): IAidf;
    function SetEnvionfseapp(value: String): IAidf;
    function SetCnpj(value: String): IAidf;

    procedure Inserir;
  end;

implementation

function TAidf.RetornaCodigo: Integer;
begin
  Result := FCodigo;
end;

function TAidf.RetornaNumerodanf: Integer;
begin
  Result := FNumerodanf;
end;

function TAidf.RetornaCodgrafica: Integer;
begin
  Result := FCodgrafica;
end;

function TAidf.RetornaCodmodelo: String;
begin
  Result := Trim(FCodmodelo).ToUpper;
end;

function TAidf.RetornaSerie: String;
begin
  Result := Trim(FSerie).ToUpper;
end;

function TAidf.RetornaSubserie: String;
begin
  Result := Trim(FSubserie).ToUpper;
end;

function TAidf.RetornaQuantidadedenotas: Integer;
begin
  Result := FQuantidadedenotas;
end;

function TAidf.RetornaNumeracaoinicial: Integer;
begin
  Result := FNumeracaoinicial;
end;

function TAidf.RetornaNumeracaofinal: Integer;
begin
  Result := FNumeracaofinal;
end;

function TAidf.RetornaDataconfeccaonf: TDateTime;
begin
  Result := FDataconfeccaonf;
end;

function TAidf.RetornaFatura: String;
begin
  Result := Trim(FFatura).ToUpper;
end;

function TAidf.RetornaFimdeuso: String;
begin
  Result := Trim(FFimdeuso).ToUpper;
end;

function TAidf.RetornaNraidf: Integer;
begin
  Result := FNraidf;
end;

function TAidf.RetornaOrgao: String;
begin
  Result := Trim(FOrgao).ToUpper;
end;

function TAidf.RetornaDatalimiteemissaonf: TDateTime;
begin
  Result := FDatalimiteemissaonf;
end;

function TAidf.RetornaCodigoemp: Integer;
begin
  Result := FCodigoemp;
end;

function TAidf.RetornaVerifcanfependente: String;
begin
  Result := Trim(FVerifcanfependente).ToUpper;
end;

function TAidf.RetornaImprimeaogravar: String;
begin
  Result := Trim(FImprimeaogravar).ToUpper;
end;

function TAidf.RetornaEnvianfeletronica: String;
begin
  Result := Trim(FEnvianfeletronica).ToUpper;
end;

function TAidf.RetornaModoscan: String;
begin
  Result := Trim(FModoscan).ToUpper;
end;

function TAidf.RetornaBloqueiaservico: String;
begin
  Result := Trim(FBloqueiaservico).ToUpper;
end;

function TAidf.RetornaEnviacteletronico: String;
begin
  Result := Trim(FEnviacteletronico).ToUpper;
end;

function TAidf.RetornaModosvc: String;
begin
  Result := Trim(FModosvc).ToUpper;
end;

function TAidf.RetornaVerificactependente: String;
begin
  Result := Trim(FVerificactependente).ToUpper;
end;

function TAidf.RetornaBloqueiaprodutos: String;
begin
  Result := Trim(FBloqueiaprodutos).ToUpper;
end;

function TAidf.RetornaLiberadata: String;
begin
  Result := Trim(FLiberadata).ToUpper;
end;

function TAidf.RetornaEnvianfseletronica: String;
begin
  Result := Trim(FEnvianfseletronica).ToUpper;
end;

function TAidf.RetornaFatlocacao: String;
begin
  Result := Trim(FFatlocacao).ToUpper;
end;

constructor TAidf.Create(Conexao : TFDConnection);
begin
  FConexao := Conexao;

  FCodigo := 0;
  FNumerodanf := 0;
  FCodgrafica := 0;
  FQuantidadedenotas := 0;
  FNumeracaoinicial := 0;
  FNumeracaofinal := 0;
  FNraidf := 0;
  FCodigoemp := 0;

  FCodmodelo := '';
  FSerie := '';
  FSubserie := '';
  FFatura := '';
  FFimdeuso := '';
  FOrgao := '';
  FVerifcanfependente := '';
  FImprimeaogravar := '';
  FEnvianfeletronica := '';
  FModoscan := '';
  FBloqueiaservico := '';
  FEnviacteletronico := '';
  FModosvc := '';
  FVerificactependente := '';
  FBloqueiaprodutos := '';
  FLiberadata := '';
  FEnvianfseletronica := '';
  FFatlocacao := '';
  FAutorizacaofat := '';
  FImportaxml := '';
  FProvedor := '';
  FDigitamanual := '';
  FEnvionfseapp := '';
  FCnpj := '';

  FDataconfeccaonf := EncodeDate(1900, 1, 1);
  FDatalimiteemissaonf := EncodeDate(1900, 1, 1);

end;

destructor TAidf.Destroy;
begin

  inherited;
end;

procedure TAidf.Inserir;
var
  vQuery : TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConexao;
    vQuery .Close;
    vQuery .SQL.Clear;
    vQuery .SQL.Add('INSERT INTO AIDF (CODIGO, NUMERODANF, CODGRAFICA, CODMODELO, SERIE, SUBSERIE, QUANTIDADEDENOTAS,');
    vQuery .SQL.Add('                  NUMERACAOINICIAL, NUMERACAOFINAL, DATACONFECCAONF, FATURA, FIMDEUSO, NRAIDF,');
    vQuery .SQL.Add('                  ORGAO, DATALIMITEEMISSAONF, CODIGOEMP, VERIFCANFEPENDENTE, IMPRIMEAOGRAVAR,');
    vQuery .SQL.Add('                  ENVIANFELETRONICA, MODOSCAN, BLOQUEIASERVICO, ENVIACTELETRONICO, MODOSVC,');
    vQuery .SQL.Add('                  VERIFICACTEPENDENTE, BLOQUEIAPRODUTOS, LIBERADATA, ENVIANFSELETRONICA, FATLOCACAO,');
    vQuery .SQL.Add('                  AUTORIZACAOFAT, IMPORTAXML, PROVEDOR, DIGITAMANUAL, ENVIONFSEAPP, CNPJ) F');
    vQuery .SQL.Add('VALUES (');
    vQuery .SQL.Add('    :CODIGO, :NUMERODANF, :CODGRAFICA, :CODMODELO, :SERIE, :SUBSERIE, :QUANTIDADEDENOTAS,');
    vQuery .SQL.Add('    :NUMERACAOINICIAL, :NUMERACAOFINAL, :DATACONFECCAONF, :FATURA, :FIMDEUSO, :NRAIDF, :ORGAO,');
    vQuery .SQL.Add('    :DATALIMITEEMISSAONF, :CODIGOEMP, :VERIFCANFEPENDENTE, :IMPRIMEAOGRAVAR, :ENVIANFELETRONICA,');
    vQuery .SQL.Add('    :MODOSCAN, :BLOQUEIASERVICO, :ENVIACTELETRONICO, :MODOSVC, :VERIFICACTEPENDENTE,');
    vQuery .SQL.Add('    :BLOQUEIAPRODUTOS, :LIBERADATA, :ENVIANFSELETRONICA, :FATLOCACAO, :AUTORIZACAOFAT, :IMPORTAXML,');
    vQuery .SQL.Add('    :PROVEDOR, :DIGITAMANUAL, :ENVIONFSEAPP, :CNPJ)');

    vQuery .ParamByName('CODIGO').AsInteger               := RetornaCodigo;
    vQuery .ParamByName('NUMERODANF').AsInteger           := RetornaNumerodanf;
    vQuery .ParamByName('CODGRAFICA').AsInteger           := RetornaCodgrafica;
    vQuery .ParamByName('CODMODELO').AsString             := RetornaCodmodelo;
    vQuery .ParamByName('SERIE').AsString                 := RetornaSerie;
    vQuery .ParamByName('SUBSERIE').AsString              := RetornaSubserie;
    vQuery .ParamByName('QUANTIDADEDENOTAS').AsInteger    := RetornaQuantidadedenotas;
    vQuery .ParamByName('NUMERACAOINICIAL').AsInteger     := RetornaNumeracaoinicial;
    vQuery .ParamByName('NUMERACAOFINAL').AsInteger       := RetornaNumeracaofinal;
    vQuery .ParamByName('DATACONFECCAONF').AsDateTime     := RetornaDataconfeccaonf;
    vQuery .ParamByName('FATURA').AsString                := RetornaFatura;
    vQuery .ParamByName('FIMDEUSO').AsString              := RetornaFimdeuso;
    vQuery .ParamByName('NRAIDF').AsInteger               := RetornaNraidf;
    vQuery .ParamByName('ORGAO').AsString                 := RetornaOrgao;
    vQuery .ParamByName('DATALIMITEEMISSAONF').AsDateTime := RetornaDatalimiteemissaonf;
    vQuery .ParamByName('CODIGOEMP').AsInteger            := RetornaCodigoemp;
    vQuery .ParamByName('VERIFCANFEPENDENTE').AsString    := RetornaVerifcanfependente;
    vQuery .ParamByName('IMPRIMEAOGRAVAR').AsString       := RetornaImprimeaogravar;
    vQuery .ParamByName('ENVIANFELETRONICA').AsString     := RetornaEnvianfeletronica;
    vQuery .ParamByName('MODOSCAN').AsString              := RetornaModoscan;
    vQuery .ParamByName('BLOQUEIASERVICO').AsString       := RetornaBloqueiaservico;
    vQuery .ParamByName('ENVIACTELETRONICO').AsString     := RetornaEnviacteletronico;
    vQuery .ParamByName('MODOSVC').AsString               := RetornaModosvc;
    vQuery .ParamByName('VERIFICACTEPENDENTE').AsString   := RetornaVerificactependente;
    vQuery .ParamByName('BLOQUEIAPRODUTOS').AsString      := RetornaBloqueiaprodutos;
    vQuery .ParamByName('LIBERADATA').AsString            := RetornaLiberadata;
    vQuery .ParamByName('ENVIANFSELETRONICA').AsString    := RetornaEnvianfseletronica;
    vQuery .ParamByName('FATLOCACAO').AsString            := RetornaFatlocacao;
    vQuery .ParamByName('AUTORIZACAOFAT').AsString        := RetornaAutorizacaofat;
    vQuery .ParamByName('IMPORTAXML').AsString            := RetornaImportaxml;
    vQuery .ParamByName('PROVEDOR').AsString              := RetornaProvedor;
    vQuery .ParamByName('DIGITAMANUAL').AsString          := RetornaDigitamanual;
    vQuery .ParamByName('ENVIONFSEAPP').AsString          := RetornaEnvionfseapp;
    vQuery .ParamByName('CNPJ').AsString                  := RetornaCnpj;
    vQuery .ExecSql;
  finally

  end;
end;

class function TAidf.New(Conexao : TFDConnection): IAidf;
begin
  Result := Self.Create(Conexao);
end;

function TAidf.RetornaAutorizacaofat: String;
begin
  Result := Trim(FAutorizacaofat).ToUpper;
end;

function TAidf.RetornaImportaxml: String;
begin
  Result := Trim(FImportaxml).ToUpper;
end;

function TAidf.RetornaProvedor: String;
begin
  Result := Trim(FProvedor).ToUpper;
end;

function TAidf.RetornaDigitamanual: String;
begin
  Result := Trim(FDigitamanual).ToUpper;
end;

function TAidf.RetornaEnvionfseapp: String;
begin
  Result := Trim(FEnvionfseapp).ToUpper;
end;

function TAidf.RetornaCnpj: String;
begin
  Result := Trim(FCnpj).ToUpper;
end;


function TAidf.SetCodigo(value: Integer): IAidf;
begin
  Result := Self;
  FCodigo := value;
end;

function TAidf.SetNumerodanf(value: Integer): IAidf;
begin
  Result := Self;
  FNumerodanf := value;
end;

function TAidf.SetCodgrafica(value: Integer): IAidf;
begin
  Result := Self;
  FCodgrafica := value;
end;

function TAidf.SetCodmodelo(value: String): IAidf;
begin
  Result := Self;
  FCodmodelo := Trim(value).ToUpper;
end;

function TAidf.SetSerie(value: String): IAidf;
begin
  Result := Self;
  FSerie := Trim(value).ToUpper;
end;

function TAidf.SetSubserie(value: String): IAidf;
begin
  Result := Self;
  FSubserie := Trim(value).ToUpper;
end;

function TAidf.SetQuantidadedenotas(value: Integer): IAidf;
begin
  Result := Self;
  FQuantidadedenotas := value;
end;

function TAidf.SetNumeracaoinicial(value: Integer): IAidf;
begin
  Result := Self;
  FNumeracaoinicial := value;
end;

function TAidf.SetNumeracaofinal(value: Integer): IAidf;
begin
  Result := Self;
  FNumeracaofinal := value;
end;

function TAidf.SetDataconfeccaonf(value: TDateTime): IAidf;
begin
  Result := Self;
  FDataconfeccaonf := value;
end;

function TAidf.SetFatura(value: String): IAidf;
begin
  Result := Self;
  FFatura := Trim(value).ToUpper;
end;

function TAidf.SetFimdeuso(value: String): IAidf;
begin
  Result := Self;
  FFimdeuso := Trim(value).ToUpper;
end;

function TAidf.SetNraidf(value: Integer): IAidf;
begin
  Result := Self;
  FNraidf := value;
end;

function TAidf.SetOrgao(value: String): IAidf;
begin
  Result := Self;
  FOrgao := Trim(value).ToUpper;
end;

function TAidf.SetDatalimiteemissaonf(value: TDateTime): IAidf;
begin
  Result := Self;
  FDatalimiteemissaonf := value;
end;

function TAidf.SetCodigoemp(value: Integer): IAidf;
begin
  Result := Self;
  FCodigoemp := value;
end;

function TAidf.SetVerifcanfependente(value: String): IAidf;
begin
  Result := Self;
  FVerifcanfependente := Trim(value).ToUpper;
end;

function TAidf.SetImprimeaogravar(value: String): IAidf;
begin
  Result := Self;
  FImprimeaogravar := Trim(value).ToUpper;
end;

function TAidf.SetEnvianfeletronica(value: String): IAidf;
begin
  Result := Self;
  FEnvianfeletronica := Trim(value).ToUpper;
end;

function TAidf.SetModoscan(value: String): IAidf;
begin
  Result := Self;
  FModoscan := Trim(value).ToUpper;
end;

function TAidf.SetBloqueiaservico(value: String): IAidf;
begin
  Result := Self;
  FBloqueiaservico := Trim(value).ToUpper;
end;

function TAidf.SetEnviacteletronico(value: String): IAidf;
begin
  Result := Self;
  FEnviacteletronico := Trim(value).ToUpper;
end;

function TAidf.SetModosvc(value: String): IAidf;
begin
  Result := Self;
  FModosvc := Trim(value).ToUpper;
end;

function TAidf.SetVerificactependente(value: String): IAidf;
begin
  Result := Self;
  FVerificactependente := Trim(value).ToUpper;
end;

function TAidf.SetBloqueiaprodutos(value: String): IAidf;
begin
  Result := Self;
  FBloqueiaprodutos := Trim(value).ToUpper;
end;

function TAidf.SetLiberadata(value: String): IAidf;
begin
  Result := Self;
  FLiberadata := Trim(value).ToUpper;
end;

function TAidf.SetEnvianfseletronica(value: String): IAidf;
begin
  Result := Self;
  FEnvianfseletronica := Trim(value).ToUpper;
end;

function TAidf.SetFatlocacao(value: String): IAidf;
begin
  Result := Self;
  FFatlocacao := Trim(value).ToUpper;
end;

function TAidf.SetAutorizacaofat(value: String): IAidf;
begin
  Result := Self;
  FAutorizacaofat := Trim(value).ToUpper;
end;

function TAidf.SetImportaxml(value: String): IAidf;
begin
  Result := Self;
  FImportaxml := Trim(value).ToUpper;
end;

function TAidf.SetProvedor(value: String): IAidf;
begin
  Result := Self;
  FProvedor := Trim(value).ToUpper;
end;

function TAidf.SetDigitamanual(value: String): IAidf;
begin
  Result := Self;
  FDigitamanual := Trim(value).ToUpper;
end;

function TAidf.SetEnvionfseapp(value: String): IAidf;
begin
  Result := Self;
  FEnvionfseapp := Trim(value).ToUpper;
end;

function TAidf.SetCnpj(value: String): IAidf;
begin
  Result := Self;
  FCnpj := Trim(value).ToUpper;
end;



end.
