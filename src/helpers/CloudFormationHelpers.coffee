
module.exports = (Handlebars) ->

	# availability zones helper
	Handlebars.registerHelper('zones', (list) ->
		string = '['

		for element, idx in list or []
			if idx != 0 then string += ', '
			string += '{"Fn::Join" : ["", [{"Ref" : "AWS::Region"}, "'+element+'"]]}'

		string += ']'
		return new Handlebars.SafeString(string)
	)

	# name helper
	#Handlebars.registerHelper("name", (string) ->
	#	JSON.stringify({
	#		"Fn::Join" : [" ", [{ "Ref" : "AWS::StackName"}, string.toString()]]
	#	})
	#)