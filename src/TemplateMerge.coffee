fs = require('fs')
merge = require('./JsonMerge')

module.exports = (template, output) ->
	files = require(template)
	merged = merge(files...)

	collectionOrNothing = (collection) ->
		if collection and Object.keys(collection).length > 0
			collection
		else
			undefined

	# create an output object, with properties in order
	out =
		AWSTemplateFormatVersion: merged.AWSTemplateFormatVersion or '2010-09-09'
		Description: merged.Description
		Parameters: collectionOrNothing(merged.Parameters)
		Mappings: collectionOrNothing(merged.Mappings)
		Resources: collectionOrNothing(merged.Resources)
		Outputs: collectionOrNothing(merged.Outputs)
		toJson: merged.toJson

	fs.writeFileSync(output, out.toJson())