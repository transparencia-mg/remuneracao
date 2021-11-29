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

merge: ## Merge pmmg, cbmmg e civis
	Rscript --verbose scripts/merge-remuneracao.R $(resource) 2> logs/log.Rout

clean: ## Clean resource
	Rscript --verbose scripts/clean-resource.R $(resource) 2> logs/log.Rout

validate: ## Validate resource
	Rscript --verbose scripts/validate-resource.R $(resource) 2> logs/log.Rout

test: ## Test resource
	Rscript --verbose tests/testthat.R 2> logs/log.Rout

publish: ## Publish resource
	dpckan resource create --resource-name $(resource) 2> logs/log.Rout	

save: ## Publish resource
	Rscript --verbose scripts/save-resource.R $(resource) 2> logs/log.Rout	