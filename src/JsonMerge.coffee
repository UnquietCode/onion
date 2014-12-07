# copied from https://gist.github.com/UnquietCode/f6c32488a8094174e1f6

valueOrCopy = (obj) ->
	if not obj
		return undefined

	else if obj instanceof Array
		newObj = []
		newObj.push(x) for x in obj
		return newObj

	else if (typeof obj).toLowerCase() is 'object'
		newObj = {}
		newObj[k] = v for own k,v of obj
		return newObj

	else
		return obj


mergeObject = (current, next) ->

	for own k,v of next
		copy = -> current[k] = valueOrCopy(v)

		# add or remove a property
		if not current[k] or not v
			copy()

		# change a property
		else if current[k] != v

			# array modifications
			if current[k] instanceof Array and v instanceof Array

				# check for special array append syntax
				if v.length == 1 and v[0] instanceof Array and v[0].length == 1 and v[0][0] instanceof Array
					current[k].push(x) for x in v[0][0]

				# plain old replace
				else
					copy()

			# recursive object copy
			else if not (v instanceof Array) and (typeof current[k]).toLowerCase() is 'object' and (typeof v).toLowerCase() is 'object'
				clone = valueOrCopy(current[k])
				mergeObject(clone, v)
				current[k] = clone

			# plain copy
			else
				copy()

		# if empty, then remove the key entirely
		if not current[k] then delete current[k]


module.exports = (objects...) ->

	# start a root
	root = {}

	# perform the merge
	for obj in objects
		mergeObject(root, obj)

	root.toJson = -> JSON.stringify(this, null, 2)
	return root