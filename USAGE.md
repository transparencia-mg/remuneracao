## Instalação e configuração

Instruções sobre instalação dos pré-requisitos e configuração do ambiente estão disponíves no arquivo [INSTALL](INSTALL.md).

## Uso

Antes de iniciar, se as dependências python estiverem instaladas em um ambiente virtual `venv`, lembre-se de ativá-lo com:

```bash
. venv/Scripts/activate # windows
. venv/bin/activate # linux
```

### Download arquivos primários

Para publicação de um novo mês da remuneração a etapa inicial é a inserção de um novo recurso no data package. 
A atualização do arquivo  `datapackage.json` é manual. 
As propriedades

- `name`
- `path`
- `hash` (somente disponível ao final do processo)
- `title`

serão diferentes a cada mês. Também serão diferentes as propriedades `source.name`, `source.path` e `source.hash` de cada elemento da propriedade `source`.


As informações de localização (`source.path`) e integridade (`source.hash`) dos arquivos primários no google drive podem ser colhidas de forma manual, ou por meio do target `make get info`, que imprime na linha de comando os metadados relevantes extraídos do google drive. 
Para tanto, é necessário informar o `id` da pasta no google drive que contém os arquivos relevantes. O `id` deve extraído da URL da pasta, e o comando deve ser executado

```sh
make get-info id=1dDdvkf-ku8bJTI-gEJ27JBRu7H7z1q_h
```

Copie e cole as propriedades `path` e `hash` nas mesmas propriedades do novo recurso no arquivo `datapackage.json`.

Nota 1: caso as credenciais da pasta google drive seja solicitata seguir os passos: [Credenciais Google Drive]([https://github.com/dados-mg/remuneracao/edit/master/INSTALL.md](https://github.com/dados-mg/remuneracao/edit/master/INSTALL.md#credenciais-google-drive))


Para de fato fazer download dos arquivos do mês corrente (`AAAA-MM`) para a pasta `data-raw/` com os nomes corretos, execute

```sh
make extract resource=servidores-AAAA-MM # download dos arquivos originais do google drive
```

Para validar os arquivos primários de acordo com o leiaute pré-estabelecido execute

```sh
make validate-raw resource=servidores-AAAA-MM
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

A validação feita em `make validate` é para garantir a validade dos aspectos estruturais dos arquivos, utilizando-se do pacote `frictionless` do python. 

Além disso, para garantia adicional de qualidade é necessário a verificação de regras de negócio, implementadas por meio do pacote [validate](https://cran.r-project.org/web/packages/validate/index.html) do R.

Para execução dos testes é necessário alterar manualmente o mês de referência no arquivo `tests/testthat/setup.R`. 

Os testes em si podem ser executados com

```sh
make test
```

Se houver erros é necessário executar os testes de forma interativa no console do R. 
Primeiro execute o script `tests/testthat/setup.R` e depois os scripts `tests/testthat/test_*` relevantes (ie. que tiveram mensagem de erro).

### Publicação (não utilizar o comando make publish quando for atualizar o arquivo)

Para publicar o arquivo no [Portal de Dados Abertos](http://dados.mg.gov.br/dataset/remuneracao-servidores-ativos) execute na linha de comando

```sh
make publish resource=servidores-AAAA-MM
```

### Atualização de recurso

Para atualizar o arquivo no [Portal de Dados Abertos](http://dados.mg.gov.br/dataset/remuneracao-servidores-ativos) execute na linha de comando

O ID do recurso pode ser obtido ao clicar dentro do recurso no Portal de Dados Abertos.

```sh
dpckan resource servidores-AAAA-MM update <ID_RESOURCE>
```

Faça commit dos arquivos alterados e push das alterações para o GitHub.

