# remuneracao
dataset que contém arquivos da consulta de remuneração mensal dos servidores

## Instalação e configuração

Instruções sobre instalação dos pré-requisitos e configuração do ambiente estão disponíves no arquivo [INSTALL](INSTALL.md)

## Uso

Inicialmente é necessário adicionar manualmente um novo recurso para o mês corrente no arquivo `datapackage.json`. 

Para além das atualizações do mês de referência, é necessário inserir as informações de localização dos arquivos primários no google drive. Essas informações podem ser colhidas de forma manual, ou por meio do script abaixo. O `id` no comando abaixo deve ser preenchido com a id da pasta relevante no google drive.

```sh
make get-info id=1dDdvkf-ku8bJTI-gEJ27JBRu7H7z1q_h
```

Ainda é necessário inserir as informações de `path` e `hash` no arquivo `datapackage.json`.

Para executar os scripts necessários para download, consolidação, limpeza e validação do recurso de um único mês da remuneração execute na linha de comando

```sh
make extract resource=servidores-AAAA-MM # download dos arquivos originais do google drive
make merge resource=servidores-AAAA-MM # gera arquivo consolidado data-raw/servidores-AAAA-MM.csv
make clean resource=servidores-AAAA-MM # gera arquivo data/servidores-AAAA-MM.csv
```

### Validação e Testes

Para verificação da conformidade dos dados com os metadados documentados no `datapackage.json` execute

```sh
make validate resource=servidores-AAAA-MM
```

A validação feita em `make validate` é para garantir a validade dos aspectos estruturais das planilhas. 
Além disso, para garantia adicional de qualidade é necessário a verificação de regras de negócio, implementadas por meio do pacote [validate](https://cran.r-project.org/web/packages/validate/index.html).

Para execução dos testes é necessário alterar manualmente o mês de referência no arquivo `tests/testthat/setup.R`. 
Os testes podem ser executados com

```sh
make test
```

Se houver erros é necessário executar os testes de forma interativa no console do R. 
Primeiro execute o script `tests/testthat/setup.R` e depois os scripts `tests/testthat/test_*` relevantes (ie. que tiveram mensagem de erro).

### Publicação

Para publicar o arquivo no [Portal de Dados Abertos](http://dados.mg.gov.br/dataset/remuneracao-servidores-ativos) execute na linha de comando

```sh
make publish resource=servidores-AAAA-MM
```
