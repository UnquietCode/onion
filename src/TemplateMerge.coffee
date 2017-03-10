fs = require 'fs'
merge = require './JsonMerge'
yaml = require 'js-yaml'

maybeAppend = (collection, key, value) ->
	if value and Object.keys(value).length > 0
		collection[key] = value

module.exports = (files, output) ->
	merged = merge(files...)

	# create an output object, with properties in order
	out =
		AWSTemplateFormatVersion: merged.AWSTemplateFormatVersion or '2010-09-09'
		Description: merged.Description or ''
	
	# conditionally append a few more collections
	maybeAppend(out, 'Metadata', merged.Metadata)
	maybeAppend(out, 'Parameters', merged.Parameters)
	maybeAppend(out, 'Mappings', merged.Mappings)
	maybeAppend(out, 'Conditions', merged.Conditions)
	maybeAppend(out, 'Resources', merged.Resources)
	maybeAppend(out, 'Outputs', merged.Outputs)
	
	if output.endsWith('.json')
		data = JSON.stringify(out, null, 2)
	else if output.endsWith('.js')
		json = JSON.stringify(out, null, 2)
		data = "module.exports = "+json
	else if output.endsWith('yaml')
		data = yaml.safeDump(out)
	else
		raise "invalid output format for file '#{output}'"

	fs.writeFileSync(output, data)
