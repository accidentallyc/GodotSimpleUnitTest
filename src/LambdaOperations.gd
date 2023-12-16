class_name LambdaOperations

static func equals(a,b):
	if typeof(a) == typeof(b):
		return a == b
	else:
		return str(a) == str(b)
