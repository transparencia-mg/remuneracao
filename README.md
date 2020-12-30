# remuneracao
dataset que contém arquivos da consulta de remuneração mensal dos servidores

## Scripts

Na versão `datapackage$version` desse conjunto de dados foi necessário realizar um tratamento na série histórica dos arquivos para adequação ao documentado no `datapackage.json`.

Além disso, foi necessário:

- restringir as unidades administrativas;
- corrigir os valores da remuneração do CBMMG.

### Extração

Essa tratamento ocorreu uma única vez, com a seguinte sequência de scripts:

- `download_servidores.R` Download de 91 arquivos (jun/2012 até dez/2019) para `data-raw/servidores/` que sofreram tratamentos manuais descritos [aqui](https://docs.google.com/document/d/1xlcs-FAdQoI7le970bFshQiw_6V_uuOz/edit)

- `download_cbmmg.R` Download de 84 arquivos (jan/2012 até dez/2018) para `data-raw/cbmmg/`. As seguintes alterações manuais devem ser feitas:
    
    - Os meses de jan/2012 a mai/2012 (5 arquivos) devem ser excluídos pois a série histórica da planilha de remuneração se inicia em jun/2012
    - O mês de fev/2017 demanda ajuste manual nas últimas colunas antes da execução dos demais scripts

Essas operações podem ser executadas com

```sh
make download
```

### Transformação

- `clean_cbmmg.R` Limpeza e padronização das planilhas `data-raw/cbmmg/` e _staging_ em `data/cbmmg/`

## Consistência campo calculado - remuneração líquida

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

## Normalização de texto

- Espaço entre palavras
    - UTRAMIG FUND EDUC PARA O TRAB (57/100 vezes)
    - UTRAMIG-FUND.EDUC.PARA O TRAB. (43/100 vezes)

## Links

- [POP Planilha Remuneração](https://onedrive.live.com/?id=8686837A27156968%2148766&cid=8686837A27156968)
- [Planilhas originais - Drive](https://drive.google.com/drive/u/0/folders/1hVdlauJdtyLs0c1X0i1mfTGHoAga1j_n)
