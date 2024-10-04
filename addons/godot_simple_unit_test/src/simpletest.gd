@icon("res://addons/godot_simple_unit_test/src/ui/icon_test.png")
extends Node

## Base class that all SimpleTests should extend from.
## This cannot be run by itself
class_name SimpleTest

var SimpleTest_LineItemTscn = preload("res://addons/godot_simple_unit_test/src/ui/simpletest_line_item.tscn")

const EMPTY_ARRAY = []

"""
######################
## Expect Functions ##
######################
"""

## Create a expect builder to begin assertions against
func expect(value)->SimpleTest_ExpectBuilder:
	return SimpleTest_ExpectBuilder.new(self,value)
	
## Asserts that orphan nodes should be equal to an amount
func expect_orphan_nodes(n):
	Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == n
	
## Asserts that there should be no orphan nodes
func expect_no_orphan_nodes():
	expect_orphan_nodes(0)
	
## Call to force a test to fail. 
func expect_fail(description = &"Forced failure invoked"):
	__append_error(description)
	
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
## All failed test runs (populated per run)
var _cases_failed:Array[SimpleTest_Utils.Case]

## Closest test runner found 
@onready var parent_runner = SimpleTest_Utils.find_closest_runner(self) as SimpleTest

"""
NOTE: This _has_ to be overriden by runner
"""
func _enter_tree():
	pass

func _ready():
	cases =  SimpleTest_Utils.get_test_cases(self)
	var cases_solo = cases.filter(func(c): return c.solo )
	if cases_solo.size():
		for case in cases:
			case.skipped = not(case.solo)
	
	_cases_runnable = cases_solo if cases_solo.size() else cases
	_cases_runnable = cases.filter(func(c): return c.skipped == false )
	
	cases.any(func (c): return c.solo_suite)

	var request_to_run_as_solo_suite = cases.any(func (c): return c.solo_suite)
	var request_to_skip_suite = cases.any(func (c): return c.skip_suite)
	parent_runner.register_test(
		self,
		request_to_run_as_solo_suite, 
		request_to_skip_suite
	)
	
func set_runner(runner:SimpleTest_Runner):
	_runner = runner
	_ln_item.set_runner(runner)

func build_gui_element(runner:SimpleTest_Runner):
	_ln_item = SimpleTest_LineItemTscn.instantiate()
	_ln_item.description = name

	_ln_item.status = &"PASS"
	_ln_item.rerunButton.show()
	_ln_item.rerunButton.__method_name = "__run_all_tests"
	_ln_item.rerunButton.__test = self
	
	for case in cases:
		var case_ln_item = SimpleTest_LineItemTscn.instantiate()
		case_ln_item.set_runner(runner)
		
		#register to dict
		_test_case_line_item_map[case.fn] = case_ln_item
		
		case_ln_item.case = case
		case_ln_item.description = case.name
		case_ln_item.rerunButton.__method_name = case.fn
		case_ln_item.rerunButton.__case = case
		case_ln_item.rerunButton.__test = self
		case_ln_item.rerunButton.show()
		
		_ln_item.add_block(case_ln_item)
		
	return _ln_item
	
	
var __run_state:Run_State
func __set_run_state(expected_count:int):
	__run_state = Run_State.new()
	__run_state.expected_count = expected_count


func run_test_cases() -> SimpleTest_Promise:
	var promise := SimpleTest_Promise.new()
	__set_run_state(_cases_runnable.size())
	
	_cases_failed = []
	for case in cases:
		await __run_test(case)
		
		var has_error = _errors.size() > 0
		if has_error:
			_cases_failed.append(case)
			
		
	_ln_item.status = &"FAIL" if _cases_failed.size() else &"PASS"
	
	# default to collapsed if no failures
	# else open
	_ln_item.set_collapse(not(_cases_failed))
	
	_ln_item.description = &"{name} ({passing}/{total} passed)".format({
		"name":name,
		"passing": _cases_runnable.size() - _cases_failed.size(),
		"total": _cases_runnable.size(),
	})
	
	promise.resolve()
	return promise
		
func __run_test(case):
	var ln_item = _test_case_line_item_map[case.fn]
	"""
	this is a transient field. this only works if running sequentially
	"""
	_errors = []
	case.last_run_errors = []
	
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
		
	case.last_run_errors.append_array(_errors)
		
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
	
			
func __run_test_run(case, ln_item):
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
	
	await self.callv(method_name, args)
	
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
		f_line_item.set_runner(_runner)
		f_line_item.description = f
		ln_item.add_block(f_line_item)
		
	
func __run_single_test(method_name,ln_item):
	__set_run_state(1)
	await __run_test(method_name)
	
	
func __run_all_tests():
	_ln_item.clear_blocks()
	run_test_cases()
	
func __assert(result:bool, description, default):
	if !result:
		_errors.append(description if description else default)
		
		
func __append_error(description):
	_errors.append(description)
	
