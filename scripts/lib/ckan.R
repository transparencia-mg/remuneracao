create_resource <- function(resource_id, dataset_id) {
  
  resource <- get_resource(x)
  
  res <- ckanr::resource_create(package_id = dataset_id,
                                name = resource$title,
                                description = resource$description,
                                upload = resource$path,
                                url = Sys.getenv("DADOSMG_DEV_HOST"), 
                                key = Sys.getenv("DADOSMG_DEV"))
  res
  
}

create_dataset <- function() {
  datapackage <- jsonlite::read_json("datapackage.json")
  
  
  res <- ckanr::package_create(name = datapackage$name,
                               owner_org = rlist::list.filter(datapackage$contributors, "publisher" %in% role)[[1]][["organization"]],
                               maintainer = rlist::list.filter(datapackage$contributors, "maintainer" %in% role)[[1]][["title"]],
                               maintainer_email = rlist::list.filter(datapackage$contributors, "maintainer" %in% role)[[1]][["email"]],
                               version = datapackage$version,
                               tags = datapackage$keywords %>% purrr::map(~ list(name = .x)),
                               license_id = datapackage$licenses[[1]]$name,
                               private = as.logical(datapackage$private),
                               package_url = datapackage$sources[[1]]$path,
                               title = datapackage$title,
                               notes = datapackage$description,
                               url = Sys.getenv("DADOSMG_DEV_HOST"), 
                               key = Sys.getenv("DADOSMG_DEV"))
  
  res
}