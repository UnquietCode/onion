Handlebars = require './Handlebars'
fs = require 'fs'
merge = require './TemplateMerge'
stripJSON = require 'strip-json-comments'


if process.argv.length < 3
	throw new Error("usage: <configuration.json>")

# load the configuration
configuration = Require(process.argv[2])


# read each file and process with handlebars
read = (file, properties) ->
	raw = fs.readFileSync("#{Require.root}/#{file}", 'utf8')

	# remove C-style comments from JSON files
	if file.indexOf('.json') > 0
		raw = stripJSON(raw)

	compiled = Handlebars.compile(raw)(properties)
	return JSON.parse(compiled)


# for each file, do handlebars rendering
for output, template of configuration.templates
	temp = []

	for file in template

		# if it's a name, read the file
		if file instanceof String or (typeof file).toLowerCase() is 'string'
			temp.push read(file, configuration.properties)

		# otherwise, it's an object so just include it as is
		else
			temp.push file

	template = temp
	merge(template, output)