
module.exports = (Handlebars) ->

	# security group helper
	Handlebars.registerHelper('aws_sg', (options) ->
		values = options.hash

		sg = {
			IpProtocol : "#{values.protocol}"
			FromPort : "#{values.port}"
			ToPort : "#{values.port}"
			CidrIp : "#{values.cidr}"
		}

		sg = JSON.stringify(sg, null, 2)
		return new Handlebars.SafeString(sg)
	)

	# availability zone helper
	Handlebars.registerHelper('aws_zone', (id, options) ->
		string = '{"Fn::Join" : ["", [{"Ref" : "AWS::Region"}, "'+id+'"]]}'
		return new Handlebars.SafeString(string)
	)

	# availability zones helper
	Handlebars.registerHelper('aws_zones', (list, propOrOptions) ->
		string = '['

		for element, idx in list or []
			if idx != 0 then string += ', '

			# property name, if provided
			if propOrOptions instanceof String or typeof propOrOptions is 'string'
				element = element[propOrOptions]

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