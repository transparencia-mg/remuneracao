## Instalação e configuração

### R

Esse projeto utiliza o [R versão 4.1.0](https://www.r-project.org/). Faça a instalação ou atualização antes de continuar.

O pacote [renv](https://rstudio.github.io/renv/index.html) é utilizado para gerenciamento de dependências. 
Ao inicializar o projeto do Rstudio, se as seguintes mensagens forem apresentadas

```r
# Bootstrapping renv 0.13.2 --------------------------------------------------
* Downloading renv 0.13.2 from CRAN ... OK
* Installing renv 0.13.2 ... Done!
* Successfully installed and loaded renv 0.13.2.
* Project 'C:/Users/m752587/projects/remuneracao' loaded. [renv 0.13.2]
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

As mensagens acima somente serão exibidas na primeira vez que o `renv` for inicializado. 
Nas sessões seguintes, a mensagem indicativa de sucesso é simplesmente

```r
* Project '~/Local/dados-mg/ckan/remuneracao' loaded. [renv 0.13.2]
```

### Python

Esse projeto utiliza o Python 3.9.7. Faça a instalação ou atualização antes de continuar.

O pacote venv é utilizado para gerenciamento de dependências. Para criar um ambiente chamado `venv`, ativar o mesmo e instalar as dependências  execute:

```python
python -m venv venv
. venv/Scripts/activate
pip install -r requirements.txt
```

### Variáveis de ambiente

Verifique se os softwares necessários estão acessíveis via linha de comando com:

```bash
Rscript --version
dpckan --version
```

Em caso de erro faça os ajustes na variável de ambiente `PATH`.

Além disso, para carga automática no CKAN esse projeto utiliza o `dpckan`, sendo necessário a configuração das variáveis de ambiente `CKAN_HOST` e `CKAN_KEY`. [Vide aqui instruções sobre como fazer isso com o arquivo `.env`](https://github.com/transparencia-mg/dpckan#configura%C3%A7%C3%A3o-de-vari%C3%A1veis-de-ambiente).

