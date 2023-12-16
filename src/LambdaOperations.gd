class_name LambdaOperations


## Does a loosey equality check. If the types are equal
## it does a basic "==" comparison but if the types are not
## equal, it casts both to string and does the comparison. 
static func equals(a,b):
	if typeof(a) == typeof(b):
		return a == b
	else:
		return str(a) == str(b)

## Does a strict equality check that compares type and value
static func equals_strict(a,b):
	return typeof(a) == typeof(b) && a == b