from goodtables import validate

def validate_resource_py(resource):
    
    result = validate(resource, preset = 'datapackage', row_limit = -1, skip_checks=['duplicate-row'])
    
    return result
