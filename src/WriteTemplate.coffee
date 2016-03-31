Handlebars = require 'handlebars'
fs = require 'fs'
merge = require './TemplateMerge'
stripJSON = require 'strip-json-comments'
greatjson = require 'greatjson'

# handlebars helpers
require('./helpers/DefaultHelpers')(Handlebars)
require('./helpers/CloudFormationHelpers')(Handlebars)

# TODO dynamic loading of helpers
#for helper in configuration._helpers || ['./helpers/CloudFormation']
#Require(helper)(Handlebars)

# read each file and process with handlebars
read = (file, properties) ->
	raw = fs.readFileSync("#{Require.root}/#{file}", 'utf8')

	# remove C-style comments from JSON files
	if file.indexOf('.json') > 0
		raw = stripJSON(raw)

	# compile the template and execute it
	compiled = Handlebars.compile(raw)(properties)
	json = greatjson.parse(compiled)

	# handle parse errors
	if json instanceof Error
		console.log("error reading file #{file}")
		throw json

	return json

# load the configuration
if process.argv.length < 3
	throw new Error("usage: <configuration.json>")

configuration = read(process.argv[2])

# for each template
for output, template of configuration.templates
	temp = []

	# for each file in the template, do handlebars rendering
	for file in template

		# if it's a name, read the file
		if file instanceof String or (typeof file).toLowerCase() is 'string'
			temp.push read(file, configuration.properties)

		# otherwise, it's an object so just include it as is
		else
			temp.push file

	template = temp
	merge(template, output)
