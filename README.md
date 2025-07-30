# Class Generator - Gerador de Classes Delphi

## Descrição
Aplicação para geração automática de classes Delphi a partir de DDL (Data Definition Language) ou lista de campos. 
A aplicação agora gera uma unit completa seguindo o padrão do arquivo `uAidf.pas`, incluindo interface, implementação e procedure de inserção.

## Funcionalidades

### 1. Geração a partir de DDL
- Cole uma DDL completa (CREATE TABLE) no campo de entrada
- A aplicação extrai automaticamente:
  - Nome da tabela
  - Campos e seus tipos
  - Valores padrão (DEFAULT)
  - Converte tipos de banco para tipos Delphi

### 2. Geração a partir de Lista de Campos
- Digite os campos separados por ";" 
- Para CamelCase, separe palavras por espaços
- Defina o tipo padrão no campo "Tipos dos Campos"

### 3. Validação CamelCase
- Converte automaticamente nomes de campos para CamelCase
- Remove underscores, hífens e pontos
- Primeira letra de cada palavra em maiúscula

### 4. Unit Completa (NOVA FUNCIONALIDADE)
- Gera uma unit completa baseada no modelo `uAidf.pas`
- Inclui:
  - Interface com GUID único
  - Classe com herança de TInterfacedObject
  - Métodos Get/Set para todos os campos
  - Constructor com inicialização de campos
  - Destructor
  - Método New (Factory)
  - **Procedure Inserir com SQL completo**

### 5. Procedure Inserir Automática (NOVA FUNCIONALIDADE)
- Gera automaticamente a procedure de inserção
- SQL INSERT com todos os campos da DDL
- Parâmetros tipados corretamente
- Utiliza os métodos Retorna para obter valores
- Gerenciamento adequado de memória

## Como Usar

### Exemplo com DDL:
```sql
CREATE TABLE PRODUTOS (
    ID INTEGER NOT NULL,
    NOME VARCHAR(100) NOT NULL,
    DESCRICAO VARCHAR(500),
    PRECO DOUBLE DEFAULT 0.0,
    CATEGORIA_ID INTEGER,
    DATA_CADASTRO TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ATIVO CHAR(1) DEFAULT 'S'
);
```

### Passos:
1. Cole a DDL no campo "Campos para serem inseridos"
2. Defina o nome da Unit (ex: "Produto")
3. Defina o nome da Interface (ex: "Produto") 
4. Clique em "Gerar"
5. Acesse a aba "Unit Completa" para ver o resultado final
6. Use "Copiar Unit Completa" para copiar todo o código

### Resultado:
- **Aba Declarações**: Declarações separadas dos métodos
- **Aba Funções**: Implementações dos métodos Get/Set
- **Aba Unit Completa**: Unit completa pronta para uso

## Mapeamento de Tipos
- `INTEGER` → `Integer`
- `DOUBLE/FLOAT/NUMERIC/DECIMAL` → `Double`
- `CHAR/VARCHAR/BLOB` → `String`
- `DATE/TIMESTAMP` → `TDateTime`
- Outros → `Variant`

## Estrutura Gerada

### Interface
```pascal
IProduto = interface
  ['{GUID-ÚNICO}']
  function RetornaId: Integer;
  function SetId(value: Integer): IProduto;
  // ... outros métodos
  procedure Inserir;
end;
```

### Classe
```pascal
TProduto = class(TInterfacedObject, IProduto)
private
  FConexao: TFDCustomConnection;
  FId: Integer;
  // ... outros campos
public
  constructor Create(Conexao: TFDConnection);
  destructor Destroy; override;
  class function New(Conexao: TFDConnection): IProduto;
  // ... métodos
  procedure Inserir;
end;
```

### Procedure Inserir
```pascal
procedure TProduto.Inserir;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConexao;
    vQuery.Close;
    vQuery.SQL.Clear;
    vQuery.SQL.Add('INSERT INTO PRODUTOS (ID, NOME, DESCRICAO, PRECO, CATEGORIA_ID, DATA_CADASTRO, ATIVO)');
    vQuery.SQL.Add('VALUES (:ID, :NOME, :DESCRICAO, :PRECO, :CATEGORIA_ID, :DATA_CADASTRO, :ATIVO)');
    
    vQuery.ParamByName('ID').AsInteger := RetornaId;
    vQuery.ParamByName('NOME').AsString := RetornaNome;
    // ... outros parâmetros
    
    vQuery.ExecSQL;
  finally
    FreeAndNil(vQuery);
  end;
end;
```

## Melhorias Implementadas

1. **Geração Automática Completa**: Não é mais necessário copiar partes separadas
2. **Procedure Inserir**: Gerada automaticamente com SQL completo
3. **Extração de Nome da Tabela**: Obtém automaticamente da DDL
4. **Interface Padronizada**: Segue o modelo do `uAidf.pas`
5. **Gerenciamento de Memória**: Uso correto de try/finally
6. **GUID Único**: Cada interface recebe um GUID único
7. **Valores Padrão**: Respeita valores DEFAULT da DDL

## Arquivos do Projeto
- `Principal.pas/dfm`: Formulário principal
- `uAidf.pas`: Arquivo modelo (não modificar)
- `exemplo_ddl.sql`: Exemplo de DDL para teste

## Tecnologias
- Delphi
- FireDAC para conexão com banco
- VCL para interface

O **ClassGenerator** é uma ferramenta escrita em Delphi destinada a auxiliar na criação de classes. O programa recebe uma lista de campos ou a DDL de uma tabela Firebird 2.5 e gera automaticamente declarações de variáveis, funções *Set* e *Retorna*, além dos valores padrão para inicialização.

## Recursos principais

- **Suporte a DDL do Firebird 2.5**: cole a instrução `CREATE TABLE` e o gerador identifica os tipos (INTEGER, VARCHAR, TIMESTAMP, DOUBLE etc.).
- **Mapeamento automático de tipos** para `Integer`, `Double`, `String`, `TDateTime` e outros equivalentes em Delphi.
- **Leitura de valores `DEFAULT`** definidos na DDL, aplicando-os no bloco de inicialização da classe.
- **Botões de cópia rápida** para transferir o conteúdo de cada memo para a área de transferência.

## Como utilizar

1. Informe no campo *Unit* o nome da unidade (será prefixado com `T` para gerar o nome da classe).
2. Defina o tipo de interface desejado.
3. Cole a lista de campos (um por linha) ou a DDL completa da tabela no memo de entrada.
4. Caso não utilize a DDL, especifique o tipo padrão dos campos no campo *Tipo*.
5. Clique em **Gerar** para produzir as declarações e funções correspondentes.
6. Use os botões *Copiar* ao lado de cada memo para copiar o código gerado.

## Exemplo rápido

```
CREATE TABLE CLIENTE (
  ID INTEGER NOT NULL,
  NOME VARCHAR(60) NOT NULL,
  DATACADASTRO TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

Ao gerar, serão criados campos privados, declarações de `Set` e `Retorna`, além do bloco de inicialização contendo o `Default` especificado para `DATACADASTRO`.

## Compilação

Abra o arquivo `ClassGenerator.dproj` no Delphi (versão compatível com o projeto) e compile. O executável resultante é uma aplicação Windows tradicional.

Este projeto está licenciado sob a licença MIT.
