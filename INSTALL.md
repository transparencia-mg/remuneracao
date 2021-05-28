# Instruções para instalação e configuração do ambiente

## R

Esse projeto utiliza o pacote [renv](https://rstudio.github.io/renv/index.html) para gerenciamento de dependências. Ao inicializar o projeto do Rstudio, se as seguintes mensagens forem apresentadas

```r
# Bootstrapping renv 0.12.3 --------------------------------------------------
* Downloading renv 0.12.3 from CRAN ... OK
* Installing renv 0.12.3 ... Done!
* Successfully installed and loaded renv 0.12.3.
* Project 'C:/Users/m752587/projects/remuneracao' loaded. [renv 0.12.3]
* The project library is out of sync with the lockfile.
* Use `renv::restore()` to install packages recorded in the lockfile.
```

Siga as instruções e execute

```r
renv::restore()
```

Caso contrário pode ser necessário

```r
install.packages("renv") # instalação do pacote renv
renv::init() # instalação dos pacotes listados no arquivo renv.lock
```

Essa instalação demora vários minutos.

As mensagens acima somente serão exibidas na primeira vez que o `renv` for inicializado. Nas sessões seguintes, a mensagem indicativa de sucesso é simplesmente

```r
* Project '~/Local/dados-mg/ckan/remuneracao' loaded. [renv 0.12.3]
```

## Variáveis de ambiente

Para carga automática no CKAN é necessário a configuração de quatro variáveis de ambiente:

- `DADOSMG_PROD_HOST`
- `DADOSMG_PROD`
- `DADOSMG_DEV_HOST`
- `DADOSMG_DEV`


Em ambiente de produção, a variável `DADOSMG_PROD_HOST` deve estar com o valor `https://dados.mg.gov.br` e a variável `DADOSMG_PROD` com a sua [chave da API do CKAN](https://docs.ckan.org/en/ckan-2.7.3/api/#authentication-and-api-keys). Ela pode ser encontrada na sua página de usuário e parece com a string `ec5c0860-9e48-41f3-8850-4a7128b18df8`. Esse modo de autenticação foi deprecado na [versão 2.9 do CKAN](https://docs.ckan.org/en/2.9/api/index.html#authentication-and-api-tokens).

De maneira similar, em ambiente de homologação a variável `DADOSMG_DEV_HOST` deve estar com o valor `https://homologa.cge.mg.gov.br` e com a chave apropriada do seu usuário de homologação.

O código que de fato controla em qual ambiente a carga será efetuada está no script `scripts/lib/ckan.R` e deve ser alterado manualmente.

Preferenciamente defina as variáveis de ambiente utilizando um arquivo `.Renviron` na sua home folder (ie. fora da pasta do projeto para evitar commit acidental). Explicações [aqui](https://support.rstudio.com/hc/en-us/articles/360047157094-Managing-R-with-Rprofile-Renviron-Rprofile-site-Renviron-site-rsession-conf-and-repos-conf). Para determinar sua home folder execute no console do R.

```r
Sys.getenv("HOME")
# /Users/fjunior
```

Nesse exemplo, o arquivo `.Renviron` deve ser criado na pasta `/Users/fjunior` por qualquer meio. Para criar pela linha de comando use

```sh
touch /Users/fjunior/.Renviron # cria o arquivo caso não exista
subl /Users/fjunior/.Renviron # edite o arquivo
```

## Python

Para validação dos recursos é necessário a instalação do Python e da biblioteca goodtables. Para fazer essas etaptas execute os seguintes comandos no console do R:

```R
reticulate::install_miniconda() # instalacao do python via miniconda
reticulate::conda_create("remuneracao") # criacao de ambiente conda especifico para esse projeto
reticulate::conda_install("remuneracao", "goodtables==2.5.2") # instalacao da versao correta do goodtables
```
