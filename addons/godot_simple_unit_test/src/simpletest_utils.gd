class_name SimpleTest_Utils

class Case:
	extends RefCounted
	var skipped:bool
	var solo:bool
	var solo_suite:bool
	var skip_suite:bool
	var name:String
	var fn:String
	var args:Array
	
	var last_errors:Array[String] = []
	

## Given a the name of a function as an "anchor point" it gets the 
## calling function
static func guess_test_case_name_from_stack(fn_name:String):
	var stack = get_stack()
	for i in stack.size():
		var layer = stack[i]
		if stack.function == fn_name:
			var next_layer  = stack[i + 1]
			return next_layer.function
	return null
	
	
## Locates the closest runner up in the tree
## This is useful for when the runners are implemented
## in a tree like structure
static func find_closest_runner(node:Node):
	var runner:Node = node
	var max_iters := 999
	
	for i in max_iters:
		assert(max_iters - i, "Reached maximum iteration count")
		if runner.has_method("register_test"):
			return runner
		
		runner = runner.get_parent()
		if runner == null or runner is Window:
			break
	assert(0, "SimpleTest %s is not a child of a Test Runner" % node.name)
	return null

static func get_test_cases(script)->Array[Case]:
	var cases:Array[Case] = []
	for method in script.get_method_list():
		var method_name = method.name
		var args = method.args
		if _is_method_test_case(method):
				var case := Case.new()
				case.name = method.name.replace(&"_",&" ")
				case.fn = method.name
				case.args = args
				
				var arg_groups = group_by_name(args)
				case.skipped = arg_groups.has('_skip')
				case.solo = arg_groups.has('_solo')
				case.solo_suite = arg_groups.has('_solo_suite')
				case.skip_suite = arg_groups.has('_skip_suite')
				cases.append(case)
	return cases
	
static func group_by_name(args):
	var grouped = {}
	for arg in args:
		
		if arg.name not in grouped:
			grouped[arg.name] = []
		grouped[arg.name].append(arg)
	return grouped
		


static func _is_method_test_case(method) ->bool:
	var method_name = method.name
	return method.flags == METHOD_FLAG_NORMAL \
				and method_name != &"test_name" \
				and ( \
					method_name.begins_with(&"it") \
					or method_name.begins_with(&"should") \
					or method_name.begins_with(&"test") \
				)

static var argument_keywords = {
	"_skip": true,
	"_solo": true,
	"_solo_suite": true,
	"_skip_suite": true
}


static func is_array(thing):
	var type = typeof(thing)
	return type <= TYPE_PACKED_COLOR_ARRAY and type >= TYPE_ARRAY
	
static func is_string(thing):
	return thing is String or thing is StringName
	
## Taken from GD_.size
static func size(thing): 
	if is_array(thing) or thing is Dictionary:
		return thing.size()
	elif is_string(thing):
		return thing.length()
	elif thing is Object:
		if thing.has_method('length'):
			return thing.length()
		elif thing.has_method('size'):
			return thing.size()
	return 0

static func is_number(a = null, _UNUSED_=null):
	return a is int or a is float
