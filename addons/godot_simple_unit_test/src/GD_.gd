## Planning to make this into a port of Lodash?
class_name GD_


static func map(collection, iteratee):
	var key
	if iteratee is String:
		key = iteratee
	else:
		assert(false,"%s is not supported as an iteratee" % iteratee)
		
	var new_collection = []
	for c in collection:
		new_collection.append(c[key])
	return new_collection
