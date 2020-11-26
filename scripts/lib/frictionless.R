validate_resource <- function(x) {
  
  resource <- get_resource(x)
  
  jsonlite::write_json(resource, path = "_resource.json", auto_unbox = TRUE, pretty = TRUE)
  
  system("frictionless validate --skip-errors duplicate-row --source-type resource _resource.json")
  
  file.remove("_resource.json")
}

get_resource <- function(x) {
  
  resource_exists(x)
  
  datapackage <- jsonlite::read_json("datapackage.json")
  
  result <- rlist::list.filter(datapackage$resources, x %in% name)
  
  result[[1]]
}


resource_exists <- function(x) {
  datapackage <- jsonlite::read_json("datapackage.json")
  
  if(!x %in% purrr::map_chr(datapackage$resources, "name")) {
    stop(glue::glue("Recurso {x} não encontrado no arquivo datapackage.json"))
  }
  
  TRUE
}



get_schema <- function(resource_id) {
  resource <- get_resource(resource_id)
  
  if(grepl(".json$", resource$schema)) {
    # dereference schema externo
    # vide https://github.com/frictionlessdata/specs/issues/365 para contexto
    result <- jsonlite::read_json(resource$schema)
  } else {
    result <- resource$schema
  }
  
  result
}

get_col_types <- function(resource_id) {
  schema <- get_schema(resource_id)
  result <- purrr::map_chr(schema$fields, "type")
  result  
}


get_col_names <- function(resource_id) {
  schema <- get_schema(resource_id)
  result <- purrr::map_chr(schema$fields, "name")
  result  
}


get_col_labels <- function(resource_id) {
  schema <- get_schema(resource_id)
  result <- purrr::map_chr(schema$fields, "title")
  result  
}