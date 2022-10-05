## Instalação e configuração

### R

Esse projeto utiliza o [R versão 4.1.0](https://www.r-project.org/). Faça a instalação ou atualização antes de continuar. Ao instalar o R é necessário colocar as informações da pasta 'bin' na váriavel de ambiente 'path'.

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

### Credenciais Google Drive

Se ao chamar o comando 'make get-info id=" aparecer o erro abaixo, siga as intruções:

```
Error in `drive_auth()`:
! Can't get Google credentials
i Are you running googledrive in a non-interactive session? Consider:
* `drive_deauth()` to prevent the attempt to get credentials
* Call `drive_auth()` directly with all necessary specifics
i See gargle's "Non-interactive auth" vignette for more details:
i <https://gargle.r-lib.org/articles/non-interactive-auth.html>

```

Instruções:

No console do R digite:

```sh
library("googledrive")
drive_auth()
```

```
# Para a mensagem: "Is it OK to cache OAuth access credentials in the folder 
                    C:/Users/M13368~1/AppData/Local/gargle/gargle/Cache between R sessions?" 
                    Selecione a opção 1: Yes

# Para a mensagem:  The httpuv package enables a nicer Google auth experience, in many cases. 
                    It doesn't seem to be installed. Would you like to install it now?
                    Selecione a opção 1: Yes
```

Após esses passos será aberto automaticamente uma aba para selecionar o e-mail correspondente:

1- selecione o email;

2- marque a opção "Ver, editar, criar e excluir todos os seus arquivos do Google Drive.";

3- Mensagem de atualizado com sucesso:

```
Authentication complete. Please close this page and return to R.
```

Para alterar o email de autentificação:

- Digite no R os comandos:

```sh
library("googledrive")
drive_auth()
```
- Será exibido a mensagem:
```
The googledrive package is requesting access to your Google account.
Select a pre-authorised account or enter '0' to obtain a new token.
Press Esc/Ctrl + C to cancel.
```
- Digite a opção "0""
