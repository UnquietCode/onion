Handlebars = require 'handlebars'

# set up handlebars counter helpers
counters = {}

Handlebars.registerHelper('counter-set', (name, value) ->
	counters[name] = value
	return ''
)

Handlebars.registerHelper('counter-inc', (name, value, options) ->
	counter = counters[name]
	if not counter then counter = 0

	# value omitted
	if not options
		options = value
		value = 1

	counter += value
	counters[name] = counter
	return ''
)

Handlebars.registerHelper('counter-get', (name) ->
	return counters[name]
)

# name helper
#Handlebars.registerHelper("name", (string) ->
#	JSON.stringify({
#		"Fn::Join" : [" ", [{ "Ref" : "AWS::StackName"}, string.toString()]]
#	})
#)


module.exports = Handlebars
