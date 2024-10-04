@icon("res://addons/godot_simple_unit_test/src/ui/icon_runner.png")

@tool
extends SimpleTest

## Root of a SimpleTest Scene. Assign this as the root node. 
## Do not extend this. Use as is.
class_name SimpleTest_Runner



var _tests = []
var _canvas
var _solo_tests = []
var _has_solo_test_suites = false
var _should_show_passed_tests = false

signal on_toggle_show_passed_tests

func _ready():
	if Engine.is_editor_hint():
		return
	
	var SimpleTest_CanvasTscn = load("res://addons/godot_simple_unit_test/src/ui/simpletest_canvas.tscn")
	_canvas = SimpleTest_CanvasTscn.instantiate()
	_canvas._runner = self
	add_child(_canvas)
	await _canvas.ready_future.completed()
	_begin_test_runs()
	
## Each test instance will call this function on enter    
func register_test(test:SimpleTest, request_solo_suite:bool,request_to_skip_suite:bool):
	_has_solo_test_suites = _has_solo_test_suites or request_solo_suite
	
	if request_solo_suite and request_to_skip_suite:
		printerr("Test(%s) has both solo and skip controls. SKIP will be ignored" % test.name)
		request_to_skip_suite = false
		
	_tests.append({
		"test":test,
		"solo": request_solo_suite,
		"skip": request_to_skip_suite
	})
	
	
func _begin_test_runs():
	var entries:Array 
	
	#region SOLO_REQUESTED
	if _has_solo_test_suites:
		for test in _tests:
			if test.solo: entries.append(test)
	#endregion
	
	#region NO_SOLO
	else: # else append everything
		entries = _tests
	#endregion
	
	#region REMOVE_SKIPPED_TESTS
	entries = entries.filter(func(c): return !c.skip)
	#endregion
	
	var failed_test_count = 0
	var total_test_count = 0
	for entry in entries:
		var test = entry.test
		test.__on_test_initialize(self)
		await test.on_finished_full_suite_run
		total_test_count += test._cases_runnable.size()
		failed_test_count += test._cases_failed.size()
		
	if total_test_count == 0:
		_canvas.container.description = "No tests yet. Add a new node of type SimpleTest to start 😁"
		return
		
	#@TODO unhide this, and make it rerun everything
	_canvas.container.set_runner(self)
	_canvas.container.rerunButton.hide() 
	_canvas.container.status = &"FAIL" if failed_test_count else &"PASS"
	_canvas.container.description = &"{name} ({passing}/{total} passed)".format({
		"name":name,
		"passing":  total_test_count - failed_test_count,
		"total": total_test_count,
	})

"""
#########################
# Warning Handling Code #
#########################
"""
func _enter_tree():
	child_entered_tree.connect(func(_dummy): update_configuration_warnings())


func _get_configuration_warnings():
	if !(owner == null or owner == self):
		return ["SimpleTest_Runner must be a root node"]
	else:
		return []
	
func add_block(block:Control):
	_canvas.add_block.call_deferred(block)
