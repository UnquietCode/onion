Handlebars = require 'handlebars'
fs = require 'fs'
merge = require './TemplateMerge'
stripJSON = require 'strip-json-comments'
greatjson = require 'greatjson'
cson = require 'cson'
yaml = require 'js-yaml'

# handlebars helpers
require('./helpers/DefaultHelpers')(Handlebars)
require('./helpers/CloudFormationHelpers')(Handlebars)

# TODO dynamic loading of helpers
#for helper in configuration._helpers || ['./helpers/CloudFormation']
#Require(helper)(Handlebars)

readFile = (file) ->
	return fs.readFileSync("#{Require.root}/#{file}", 'utf8')

readJSON = (file) ->
	content = readFile(file)
	content = stripJSON(content)  # remove C-style comments
	return content

# read each file and process with handlebars
read = (file, properties) ->

	# handle JS
	if file.endsWith('.js')
		data = Require(file)

	# handle JSON
	else if file.indexOf('.json') > 0
		raw = readJSON(file)
		compiled = Handlebars.compile(raw)(properties)
		data = greatjson.parse(compiled)

	# handle CSON
	else if file.endsWith('.cson')
		raw = readFile(file)
		compiled = Handlebars.compile(raw)(properties)
		data = cson.parse(compiled)
	
	# handle YAML
	else if file.endsWith('.yaml')
		raw = readFile(file)
		compiled = Handlebars.compile(raw)(properties)
		data = yaml.safeLoad(compiled)

	else
		data = Error("unsupported file format '#{file}'")

	# handle parse errors
	if data instanceof Error
		console.log("error reading file #{file}")
		throw data

	return data

# read configuration files
readConfiguration = (file) ->
	
	# handle JSON
	if file.endsWith('.json')
		raw = readJSON(file)
		data = greatjson.parse(raw)

	# handle JS
	else if file.endsWith('.js')
		data = Require(file)

	# handle CSON
	else if file.endsWith('.cson')
		raw = readFile(file)
		data = cson.parse(raw)
		
	# handle YAML
	else if file.endsWith('.yaml')
		raw = readFile(file)
		data = yaml.safeLoad(raw)
		
	else
		data = Error("invalid file extension for configuration file '#{file}'")

	if data instanceof Error
		console.log("error reading configuration file '#{file}'")
		throw data
	
	return data

# load the configuration
if process.argv.length < 3
	throw new Error("usage: <configuration.ext>")

configuration = readConfiguration(process.argv[2])

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
