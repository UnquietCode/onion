
module.exports = (Handlebars) ->

	# security group helper
	Handlebars.registerHelper('aws_sg', (options) ->
		values = options.hash
		port = JSON.parse("{\"value\" : #{values.port}}").value
		
		# get the port or port range
		if Array.isArray(port)
			range = port
		else
			range = [port, port]

		sg = {
			IpProtocol : "#{values.protocol}"
			FromPort : "#{range[0]}"
			ToPort : "#{range[1]}"
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

	# Network ACL helper
	acl_counters = {}
	
	Handlebars.registerHelper('aws_acl', (options) ->
		values = options.hash		
		counter = (acl_counters[values.prefix] ?= { in: 0, out: 0 })
		port = JSON.parse("{\"value\" : #{values.port}}").value
		
		# get the port or port range
		if Array.isArray(port)
			range = port
		else
			range = [port, port]
		
		# get the next rule ID
		if values.egress == true
			rule = (counter.out += 1)
		else
			rule = (counter.in += 1)
		
		# get the acl ID
		id = JSON.parse("{\"value\" : #{values.id}}").value
			
		acl = {
			Type: 'AWS::EC2::NetworkAclEntry'
			Properties: {
				Protocol: "#{values.protocol}"
				CidrBlock: "#{values.cidr}"
				PortRange: {
					From: "#{range[0]}"
					To: "#{range[1]}"
				}				
				Egress: "#{values.egress}"
				RuleAction: "#{values.action || 'allow'}"
				NetworkAclId: id
				RuleNumber: "#{rule}"
			}
		}

		name = "#{values.prefix}#{rule}"
		acl = JSON.stringify(acl, null, 2)
		return new Handlebars.SafeString("\"#{name}\" : #{acl}")
	)

	# name helper
	#Handlebars.registerHelper("name", (string) ->
	#	JSON.stringify({
	#		"Fn::Join" : [" ", [{ "Ref" : "AWS::StackName"}, string.toString()]]
	#	})
	#)
