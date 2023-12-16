extends Node
class_name SimpleTest

static var SimpleTest_LineItemTscn = preload("./ui/SimpleTest_LineItem.tscn")

######################
## Expect Functions ##
######################

func expect_equal(a,b, description = ""):
	var result = LambdaOperations.equals(a,b)
	if !result:
		_results.append(description if description else "Expected %s to equal %s" % [a,b])

func expect_orphan_nodes(n):
	Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == n
	
func expect_no_orphan_nodes():
	expect_orphan_nodes(0)
	
####################
## Internal Stuff ##
####################

var _ln_item
var _results:Array[String]
var _test_case_line_item_map = {}
var _runner

func _ready():
	owner.runner_ready.connect(__on_runner_ready,Object.CONNECT_ONE_SHOT)

func __on_runner_ready(runner:SimpleTest_Runner):
	_ln_item = SimpleTest_LineItemTscn.instantiate()
	_ln_item.status = &"PASS"
	_ln_item.description = name
	_ln_item.ready.connect(__on_main_line_item_ready, Object.CONNECT_ONE_SHOT)
	
	_runner = runner
	_runner.add_block(_ln_item)

func __on_main_line_item_ready():
	_ln_item.rerunButton.show()
	_ln_item.rerunButton.__method_name = "__run_all_tests"
	_ln_item.rerunButton.__test = self
	
	var cases = __get_test_cases()
	for case in cases:
		var case_ln_item = SimpleTest_LineItemTscn.instantiate()
		_test_case_line_item_map[case.fn] = case_ln_item
		
		case_ln_item.description = case.name
		case_ln_item.ready.connect(
			func(): 
				case_ln_item.rerunButton.show()
				case_ln_item.rerunButton.__method_name = case.fn
				case_ln_item.rerunButton.__test = self
				__run_test(case.fn, case_ln_item)
		, Object.CONNECT_ONE_SHOT)
		
		_ln_item.add_block(case_ln_item)
			
func __run_test(method_name, ln_item):
	_results = []
	self.call(method_name)
	ln_item.status = &"FAIL" if len(_results) > 0 else &"PASS"
	ln_item.clear_blocks()
	for f in _results:
		var f_line_item = SimpleTest_LineItemTscn.instantiate()
		f_line_item.description = f
		ln_item.add_block(f_line_item)
	
func __run_all_tests():
	_ln_item.queue_free()
	__on_runner_ready(_runner)
	#for case in __get_test_cases():
		#var ln_item = _test_case_line_item_map[case.fn]
		#__run_test(case.fn,ln_item)
	
func __get_test_cases():
	var cases = []
	for entry in get_method_list():
		if entry.flags != METHOD_FLAG_NORMAL \
			|| !( \
				entry.name.begins_with(&"it") \
				|| entry.name.begins_with(&"should") \
				|| entry.name.begins_with(&"test") \
			):
			continue
			
		var case = {}
		case.name = entry.name.replace(&"_",&" ")
		case.fn = entry.name
		cases.append(case)
	return cases
	
