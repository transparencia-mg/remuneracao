# remuneracao
dataset que contém arquivos da consulta de remuneração mensal dos servidores

## Instalação e configuração

Instruções sobre instalação dos pré-requisitos e configuração do ambiente estão disponíves no arquivo [INSTALL](INSTALL.md)

## Instruções - Publicação de um único mês

Antes da execução das rotinas é necessário um pré-processamento manual para padronização dos arquivos e os mesmos devem ser salvos na pasta `data-raw` com os nomes

```
data-raw/servidores-AAAA-MM-civis.csv
data-raw/servidores-AAAA-MM-cbmmg.xlsx
data-raw/servidores-AAAA-MM-pmmg.xlsx
```

O pré-processamento consiste em padronizar os cabeçalhos de todos os arquivos de acordo com os campos definidos no `schema.json`.

Para executar os scripts necessários para consolidação, limpeza e validação do recurso de um único mês execute na linha de comando

```sh
make extract resource=servidores-AAAA-MM # download dos arquivos originais do google drive
make merge resource=servidores-AAAA-MM # gera arquivo consolidado data-raw/servidores-AAAA-MM.csv
make clean resource=servidores-AAAA-MM # gera arquivo data/servidores-AAAA-MM.csv
make validate resource=servidores-AAAA-MM > logs/validation.txt
```

### Testes

A validação feita em `make validate` é para garantir a validade dos aspectos estruturais das planilhas. Além disso, para garantia adicional de qualidade é necessário a verificação de regras de negócio, implementadas por meio do pacote [validate](https://cran.r-project.org/web/packages/validate/index.html).

Para execução dos testes é necessário alterar manualmente o mês de referência no arquivo `tests/testthat/setup.R`. Os teste podem ser executados com

```sh
make test
```

Se houver erros é necessário executar os testes de forma interativa no console do R. Primeiro execute o script `tests/testthat/setup.R` e depois os scripts `tests/testthat/test_*` relevantes (ie. que tiveram mensagem de erro).

### Publicação

Para publicar o arquivo no [Portal de Dados Abertos](http://dados.mg.gov.br/dataset/remuneracao-servidores-ativos) execute na linha de comando

```sh
make publish resource=servidores-AAAA-MM
```

## Instruções - Reproduzir série histórica

Na versão `datapackage$version` desse conjunto de dados foi necessário realizar um tratamento na série histórica dos arquivos para adequação ao documentado no `datapackage.json`.

Além disso, foi necessário:

- restringir as unidades administrativas;
- corrigir os valores da remuneração do CBMMG.

Essa tratamento ocorreu uma única vez, com a seguinte sequência de scripts:

- `download_servidores.R` Download de 91 arquivos (jun/2012 até dez/2019) para `data-raw/servidores/` que sofreram tratamentos manuais descritos [aqui](https://docs.google.com/document/d/1xlcs-FAdQoI7le970bFshQiw_6V_uuOz/edit)

- `download_cbmmg.R` Download de 84 arquivos (jan/2012 até dez/2018) para `data-raw/cbmmg/`. As seguintes alterações manuais devem ser feitas:
    
    - Os meses de jan/2012 a mai/2012 (5 arquivos) devem ser excluídos pois a série histórica da planilha de remuneração se inicia em jun/2012
    - O mês de fev/2017 demanda ajuste manual nas últimas colunas antes da execução dos demais scripts

Essas operações podem ser executadas com

```sh
make download
```

- `clean_cbmmg.R` Limpeza e padronização das planilhas `data-raw/cbmmg/` e _staging_ em `data/cbmmg/`

## Regras de validação

### Consistência campo calculado - remuneração líquida

- Remunerações Após Deducões Obrigatórias (`rem_pos`) =
    - (+) Remuneração Básica Bruta (`remuner`)
    - (-) Abate Teto Valor (`teto`)
    - (+) Férias (`ferias`)
    - (+) Gratificação Natal (`decter`)
    - (+) Prêmio Produtividade `(premio`)
    - (+) Férias-Prêmio (`feriasprem`)
    - (+) Jetons Folha (`jetons`)
    - (+) Demais Eventuais (`eventual`)
    - (-) IRPF (`ir`)
    - (-) Contribuição Previdenciária (`prev`)

### Normalização de texto

- Espaço entre palavras
    - UTRAMIG FUND EDUC PARA O TRAB (57/100 vezes)
    - UTRAMIG-FUND.EDUC.PARA O TRAB. (43/100 vezes)

# Links

- [POP Planilha Remuneração](https://onedrive.live.com/?id=8686837A27156968%2148766&cid=8686837A27156968)
- [Planilhas originais - Drive](https://drive.google.com/drive/u/0/folders/1hVdlauJdtyLs0c1X0i1mfTGHoAga1j_n)
