RANDOM_CHARS = 'abcdefghijklmnopqrstuvwxyz'

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

	# random value helper
	# generates a random string of the form [a-z]+[a-z0-9]*
	Handlebars.registerHelper('random', (size, options) ->
		size = if options then size else 8
		if size < 0 then throw 'string length must be >= 0'

		string = ''

		for idx in [0...size]

			# use a number for the first value, or 30% of the time
			useNumber = idx != 0 && Math.random() <= 0.3

			if useNumber
				string += Math.floor(Math.random() * 10)
			else
				charIndex = Math.floor(Math.random() * RANDOM_CHARS.length)
				string += RANDOM_CHARS[charIndex]

		return string
	)