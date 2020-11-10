import pprint
from frictionless import validate

report = validate('datapackage.json')

pprint.pprint(report)


datapackage = json.load(open('datapackage.json'))
schema = json.load(open('schema.json'))


datapackage = json.load(open('datapackage.json', encoding="UTF-8"))
schema = json.load(open('schema.json', encoding="UTF-8"))
