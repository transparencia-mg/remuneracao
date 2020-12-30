purrr::walk(list.files("scripts/lib/", full.names = TRUE, pattern = ".R"), source)

arg <- commandArgs(trailingOnly = TRUE)

resource_exists(arg)

resource <- create_resource(arg, jsonlite::read_json("datapackage.json")$name)

print(resource)