
module.exports = (Handlebars) ->

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


	# delimited list helper
	Handlebars.registerHelper('list', (list, options) ->
		delimiter = options.hash?.delimiter or ','
		string = ''

		for element, idx in list or []
			if idx != 0 then string += "#{delimiter} "
			string += options.fn(element)

		return string;
	)