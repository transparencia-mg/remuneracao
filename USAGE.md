## Instalação e configuração

Instruções sobre instalação dos pré-requisitos e configuração do ambiente estão disponíves no arquivo [INSTALL](INSTALL.md).

## Uso

Antes de iniciar, certifique-se que o ambiente virtual conda `remuneracao` está ativado:

```
conda activate remuneracao
```

Em caso de dificuldades consulte o issue [transparencia-mg/age7#108](https://github.com/transparencia-mg/age7/issues/108).

### Download arquivos primários

Para publicação de um novo mês da remuneração a etapa inicial é a inserção de um novo recurso no data package. 
A atualização do arquivo  `datapackage.json` é manual. 
As propriedades

- `name`
- `path`
- `hash` (somente disponível ao final do processo)
- `title`
- `id` (somente disponível ao final do processo)

serão diferentes a cada mês. Também serão diferentes as propriedades `source.name`, `source.path` e `source.hash` de cada elemento da propriedade `source`.


As informações de localização (`source.path`) e integridade (`source.hash`) dos arquivos primários no google drive podem ser colhidas de forma manual, ou por meio do target `make get info`, que imprime na linha de comando os metadados relevantes extraídos do google drive. 
Para tanto, é necessário informar o `id` da pasta no google drive que contém os arquivos relevantes. O `id` deve extraído da URL da pasta, e o comando deve ser executado

```sh
make get-info id=1dDdvkf-ku8bJTI-gEJ27JBRu7H7z1q_h
```

Copie e cole as propriedades `path` e `hash` nas mesmas propriedades do novo recurso no arquivo `datapackage.json`.

Para de fato fazer download dos arquivos do mês corrente (`AAAA-MM`) para a pasta `data-raw/` com os nomes corretos, execute

```sh
make extract resource=servidores-AAAA-MM # download dos arquivos originais do google drive
```

### Consolidação e limpeza

Para execução dos scripts necessários para consolidação e limpeza dos arquivos do SISAP, PMMG, e CBMMG execute na linha de comando

```sh
make merge resource=servidores-AAAA-MM # gera arquivo consolidado data-raw/servidores-AAAA-MM.csv
make clean resource=servidores-AAAA-MM # gera arquivo data/servidores-AAAA-MM.csv
```

Agora você já pode obter o valor da propriedade `hash` com o comando

```
sha256sum data/servidores-AAAA-MM.csv.gz
```

### Validação e Testes

Para verificação da conformidade dos dados, armazenados em `data/servidores-AAAA-MM`, com os metadados documentados no recurso `servidores-AAAA-MM` correspondente no `datapackage.json` execute

```sh
make validate resource=servidores-AAAA-MM
```

A validação feita em `make validate` é para garantir a validade dos aspectos estruturais dos arquivos, utilizando-se do pacote `goodtables` do python. 

Além disso, para garantia adicional de qualidade é necessário a verificação de regras de negócio, implementadas por meio do pacote [validate](https://cran.r-project.org/web/packages/validate/index.html) do R.

Para execução dos testes é necessário alterar manualmente o mês de referência no arquivo `tests/testthat/setup.R`. 

Os testes em si podem ser executados com

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

Atualiza a propriedade `id`, faça commit dos arquivos alterados e push das alterações para o GitHub.
