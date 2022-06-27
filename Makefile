.PHONY: help all clean sync build publish

#====================================================================
# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

all: clean

download:
	Rscript --verbose scripts/download_servidores.R 2> logs/log.Rout

transform:
	cp data-raw/servidores/* data/

get-info: ## Extrai informações de uma pasta do google drive
	Rscript --verbose scripts/get_source_metadata_info.R $(id) 2> logs/log.Rout

extract: ## Download arquivos da pmmg, cbmmg e civis do google drive
	Rscript --verbose scripts/download-google-drive.R $(resource) 2> logs/log.Rout

validate-raw: ## Validar arquivos primários da pmmg, cbmmg e civis
	frictionless validate data-raw/$(resource)-cbmmg.xlsx --json --schema schema/cbmmg/latest.json > reports/cbmmg.json
	frictionless validate data-raw/$(resource)-pmmg.xlsx --json --schema schema/pmmg/latest.json > reports/pmmg.json
	frictionless validate data-raw/$(resource)-civis.csv --json --schema schema/civis/latest.json > reports/civis.json
	livemark build reports/cbmmg.md
	livemark build reports/pmmg.md
	livemark build reports/civis.md

merge: ## Merge pmmg, cbmmg e civis
	Rscript --verbose scripts/merge-remuneracao.R $(resource) 2> logs/log.Rout

clean: ## Clean resource
	Rscript --verbose scripts/clean-resource.R $(resource) 2> logs/log.Rout

validate: ## Validate resource
	frictionless validate --resource-name $(resource) datapackage.json 2> logs/log.Rout

test: ## Test resource
	Rscript --verbose tests/testthat.R 2> logs/log.Rout

publish: ## Publish resource
	dpckan resource $(resource) create 2> logs/log.Rout	

save: ## Publish resource
	Rscript --verbose scripts/save-resource.R $(resource) 2> logs/log.Rout	