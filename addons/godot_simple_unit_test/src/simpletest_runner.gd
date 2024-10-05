@icon("res://addons/godot_simple_unit_test/src/ui/icon_runner.png")

@tool
extends SimpleTest

## Root of a SimpleTest Scene. Assign this as the root node. 
## Do not extend this. Use as is.
class_name SimpleTest_Runner



var _tests:Array = []
## Same as _tests but with the skips filetered out
var _runnable_tests:Array 

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
	
	_runnable_tests = _tests.filter(func(c): return !c.skip)
	_begin_test_runs()
	
## Each test instance will call this function on enter    
func register_test(test, request_solo_suite:bool,request_to_skip_suite:bool):
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
	
	for entry in entries:
		var test:SimpleTest = entry.test
		var gui = await test.build_gui_element(self)
		add_block(gui)
		test.set_runner(self)
		
		test.on_case_rerun_request.connect(func ():
			# This is called when a single test case is rerun
			sync_gui()
			)
		
		await test.run_test_cases()
	sync_gui()
		


func get_stats():
	var total_test_count = 0
	var failed_test_count = 0
	for entry in _tests:
		var test:SimpleTest = entry.test
		var stats = test.get_stats()
		total_test_count += stats.total
		failed_test_count += stats.failed
		
	return {
		"total": total_test_count,
		"passed": total_test_count - failed_test_count,
		"failed": failed_test_count
	}

func sync_gui():
	var stats = get_stats()
	
	if stats.total == 0:
		_canvas.container.description = "No tests yet. Add a new node of type SimpleTest to start 😁"
		return
	
	var container = _canvas.container	
	container.set_runner(self)
	container.rerunButton.hide() 
	container.status = &"FAIL" if stats.failed else &"PASS"
	container.description = &"{name} ({passing}/{total} passed)".format({
		"name":name,
		"passing":  stats.passed,
		"total": stats.total,
	})
	
	container.sync_gui()


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
