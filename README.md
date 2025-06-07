# ClassGenerator

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
