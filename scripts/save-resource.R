library(git2r); library(jsonlite)

purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

arg <- commandArgs(trailingOnly = TRUE)
resource_exists(arg)

datapackage <- read_json("datapackage.json")
resource <- get_resource(arg)

index <- rlist::list.which(datapackage$resources, resource$name %in% name)
datapackage$resources[[index]]$hash <- digest::digest(datapackage$resources[[index]][["path"]], file = TRUE)
write_json(datapackage, "datapackage.json", pretty = TRUE, auto_unbox = TRUE)

repo <- git2r::repository()
git2r::add(repo, "datapackage.json")
git2r::commit(repo, glue::glue("Atualiza hash recurso {arg} no datapackage.json"))
