@icon("res://addons/godot_simple_unit_test/src/ui/icon_test.png")
extends Node

## Base class that all SimpleTests should extend from.
## This cannot be run by itself
class_name SimpleTest

var SimpleTest_LineItemTscn: PackedScene = preload("res://addons/godot_simple_unit_test/src/ui/simpletest_line_item.tscn")

const EMPTY_ARRAY = []

signal on_case_rerun_request()

## If this is the first time the funcs have been executed
var is_first_run:bool = true # Useful for differentiating user behavior

"""
######################
## Expect Functions ##
######################
"""


## Create a expect builder to begin assertions against
func expect(value)->SimpleTest_ExpectBuilder:
	return SimpleTest_ExpectBuilder.new(self,value)
	
## Asserts that orphan nodes should be equal to an amount
func expect_orphan_nodes(n, description = &"Count of orphan nodes did not match"):
	__assert(
		Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == n,
		description,
		description
	)
	
## Asserts that there should be no orphan nodes
func expect_no_orphan_nodes():
	expect_orphan_nodes(0, &"Found orphan nodes")
	
## Call to force a test to fail. 
func expect_fail(description = &"Forced failure invoked"):
	__assert(false,description, description)
	
## Allows you to wait for a certain condition to happen
func wait_until(condition:Callable, timeout = 5):
	var time_elapsed = 0
	while true:
		if condition.call():
			return true
		await get_tree().create_timer(0.25).timeout
		time_elapsed += 0.25
		if time_elapsed >= timeout:
			return false

# Default 1 second
func wait(timeout = 1):
	await get_tree().create_timer(timeout).timeout
	return
	
## Overrides the displayed test name. This is optional
func test_name(override_test_name:String):
	__run_state.transient.override_test_name = override_test_name

"""
//////////////////////////stub//
// Some Utility Functions //
////////////////////////////
"""

func stub():
	return SimpleTest_Stub.new()
	
"""
////////////////////
// Internal Stuff //
////////////////////
"""
class Run_State:
	var completed_count:int = 0
	var expected_count:int = 0
	var transient = Run_State_Transient.new()


class Run_State_Transient:
	var override_test_name:String = &""


var _ln_item
var _case_item
var _errors:Array[String]
## Only used for displaying purposes
var _curr_test_name = null

## Used in testing only
var _test_case_line_item_map = {}
var _runner

## All test cases
var cases:Array[SimpleTest_Utils.Case]
## All tests cases that can be executed (solo and not skipped)
var _cases_runnable:Array[SimpleTest_Utils.Case]

## Closest test runner found 
@onready var parent_runner = SimpleTest_Utils.find_closest_runner(self) as SimpleTest

static var canvas:CanvasLayer # Populated by SimpleTest_Runner.get_or_create_canvas 


"""
NOTE: This _has_ to be overriden by runner
"""

func _ready():
	cases =  SimpleTest_Utils.get_test_cases(self)
	
	for c in cases:
		# register in table
		var case:SimpleTest_Utils.Case = c
		case_table[case.fn] = case
	
	var cases_solo = cases.filter(func(c): return c.solo )
	if cases_solo.size():
		for case in cases:
			case.skipped = not(case.solo)
	
	_cases_runnable = cases_solo if cases_solo.size() else cases
	_cases_runnable = cases.filter(func(c): return c.skipped == false )
	
	var request_to_run_as_solo_suite = cases.any(func (c): return c.solo_suite)
	var request_to_skip_suite = cases.any(func (c): return c.skip_suite)
	parent_runner.register_test(
		self,
		request_to_run_as_solo_suite, 
		request_to_skip_suite
	)
	
func set_runner(runner):
	_runner = runner
	_ln_item.set_runner(runner)

func build_gui_element(runner):
	_ln_item = SimpleTest_LineItemTscn.instantiate()
	_ln_item.description = name

	_ln_item.status = &"PASS"
	_ln_item.rerunButton.show()
	
	for case in cases:
		var case_ln_item = SimpleTest_LineItemTscn.instantiate()
		
		case_ln_item.on_rerun_request.connect(func ():
			await run_test_case(case)
			case_ln_item.sync_gui()
			sync_gui()
			on_case_rerun_request.emit()
			)
		
		#register to dict
		_test_case_line_item_map[case.fn] = case_ln_item
		
		case_ln_item.case = case
		case_ln_item.description = case.name
		case_ln_item.rerunButton.show()
		
		_ln_item.add_block(case_ln_item)
		
	return _ln_item
	
	
var __run_state:Run_State
func __set_run_state(expected_count:int):
	__run_state = Run_State.new()
	__run_state.expected_count = expected_count
	
	
func get_stats():
	var total = _cases_runnable.size()
	var failed = 0
	for key in case_table:
		var case:SimpleTest_Utils.Case = case_table[key]
		if case.last_errors:
			failed += 1
			
	return {
		"total": total,
		"failed": failed,
		"passed": total - failed
	}
	
	
func sync_gui():
	var stats = get_stats()
		
	_ln_item.description = &"{name} ({passing}/{total} passed)".format({
		"name":name,
		"passing": stats.passed,
		"total": stats.total,
	})
	
	_ln_item.status = &"FAIL" if stats.failed else &"PASS"
	
	if is_first_run:
		# The default behavior is to show only failed tests to the
		# user - but if they click the re-runs we should not override 
		# their collapse decisions
		_ln_item.set_collapse(not(stats.failed))
	_ln_item.sync_gui()


func run_test_cases():
	__set_run_state(_cases_runnable.size())
	
	for case in cases:
		await run_test_case(case)
	sync_gui()
	is_first_run = false
		
## Contains the test_case_names plus the last result of the last
## test execution
var case_table := {}
func run_test_case(case):
	var ln_item = _test_case_line_item_map[case.fn]

	if __run_state.completed_count == 0 and has_method("_before"):
		call("_before")
		
	if case.skipped:
		__run_test_skip(case, ln_item)
	else:
		await __run_test_run(case, ln_item)
		__run_state.completed_count += 1
		
	if __run_state.completed_count == __run_state.expected_count \
		and has_method("_after"):
		call("_after")
		
		
	"""
	Update test name - TODO move this from function to param
	"""
	if __run_state.transient.override_test_name:
		ln_item.description = __run_state.transient.override_test_name
		
		
	"""
	Cleanup for the next test run
	"""
	__run_state.transient.override_test_name = &""
	_curr_test_name = null
	
	
func __run_test_skip(case, ln_item):
	"""
	Update the GUI elements. The results of the test are collected at
	_errors.
	"""
	# Update the pass - fail
	ln_item.status = &"SKIPPED"
	ln_item.clear_blocks()
	
			
func __run_test_run(case:SimpleTest_Utils.Case, ln_item):
	var method_name = case.fn
	
	
	# Only used for debugging purposes
	_curr_test_name = method_name
		
	"""
	Perform the actual test
	"""
	if has_method("_before_each"):
		call("_before_each")
	
	var args = []
	
	var tmp_args = case.args
	if not tmp_args is Array:
		tmp_args = [tmp_args]
	
	for arg in tmp_args:
		if not(SimpleTest_Utils.argument_keywords.has(arg.name)):
			printerr(
				"Unsupported test argument({arg}) provided for {method} ".format({
						"arg":arg.name,
						"method": method_name
					}))
		args.append(null)		
	
	#region ACTUAL_TEST
	"""
	These are transient fields. This is where all the errors are shoved in
	during a test run. This means that all the test cases must be run NOT
	in parallel.
	"""
	_errors.clear()
	case.last_errors.clear()
	await self.callv(method_name, args)
	case.last_errors.append_array(_errors)
	#endregion
	
	if has_method("_after_each"): 
		call("_after_each")
		
	"""
	Update the GUI elements. The results of the test are collected at
	_errors.
	"""
	var has_failed = len(_errors) > 0

	# Update the pass - fail
	ln_item.status = &"FAIL" if has_failed else (
		&"PASS (SOLO)" if case.solo else &"PASS"
	)
	ln_item.clear_blocks()
	for f in _errors:
		var f_line_item = SimpleTest_LineItemTscn.instantiate()
		f_line_item.description = f
		ln_item.add_block(f_line_item)	
	
func __run_single_test(method_name,ln_item):
	__set_run_state(1)
	await run_test_case(method_name)
	
	
func __run_all_tests():
	_ln_item.clear_blocks()
	run_test_cases()
	
func __assert(result:bool, description, default):
	if !result:
		_errors.append(description if description else default)
