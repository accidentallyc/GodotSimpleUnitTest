@icon("res://addons/godot_simple_unit_test/src/ui/icon_test.png")
extends Node

## Base class that all SimpleTests should extend from.
## This cannot be run by itself
class_name SimpleTest

static var SimpleTest_LineItemTscn = preload("./ui/simpletest_line_item.tscn")

"""
######################
## Expect Functions ##
######################
"""
func expect(value)->SimpleTest_ExpectBuilder:
	return SimpleTest_ExpectBuilder.new(self,value)
	
	
func expect_orphan_nodes(n):
	Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == n
	
	
func expect_no_orphan_nodes():
	expect_orphan_nodes(0)
	
	
## Call to force a test to fail. 
func expect_fail(description = &"Forced failure invoked"):
	__append_error(description)
	
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
var _results:Array[String]
## Only used for displaying purposes
var _curr_test_name = null
var _test_case_line_item_map = {}
var _runner

"""
NOTE: This _has_ to be overriden by runner
"""
func _ready():
	owner.runner_ready.connect(__on_runner_ready,Object.CONNECT_ONE_SHOT)
	
	
## Override to run code before any of the tests in this suite
func _before():
	pass
	
	
func _before_each():
	pass
	
	
## Override to run code after each test case
func _after():
	pass
	
	
## Override to run code after all the tests have been run
func _after_each():
	pass
	

func __on_runner_ready(runner:SimpleTest_Runner):
	_ln_item = SimpleTest_LineItemTscn.instantiate()
	_ln_item.status = &"PASS"
	_ln_item.description = name
	_ln_item.ready.connect(__on_main_line_item_ready, Object.CONNECT_ONE_SHOT)
	
	_runner = runner
	_runner.add_block(_ln_item)
	
var __run_state:Run_State
func __set_run_state(expected_count:int):
	__run_state = Run_State.new()
	__run_state.expected_count = expected_count


func __on_main_line_item_ready():
	_ln_item.rerunButton.show()
	_ln_item.rerunButton.__method_name = "__run_all_tests"
	_ln_item.rerunButton.__test = self
	
	var cases = __get_test_cases()
	__set_run_state(cases.size())
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
	# Reset all errors
	_results = []
	
	# Only used for debugging purposes
	_curr_test_name = method_name

		
	"""
	Perform the actual test
	"""
	if __run_state.completed_count == 0:
		_before()
		
	_before_each()
	
	self.call(method_name)
	__run_state.completed_count += 1
	
	_after_each()
	if __run_state.completed_count == __run_state.expected_count:
		_after()
		
	"""
	Update the GUI elements. The results of the test are collected at
	_results.
	"""
	
	# Update the actual text element
	if __run_state.transient.override_test_name:
		ln_item.description = __run_state.transient.override_test_name
	
	# Update the pass - fail
	ln_item.status = &"FAIL" if len(_results) > 0 else &"PASS"
	ln_item.clear_blocks()
	for f in _results:
		var f_line_item = SimpleTest_LineItemTscn.instantiate()
		f_line_item.description = f
		ln_item.add_block(f_line_item)
		
	"""
	Cleanup for the next test run
	"""
	__run_state.transient.override_test_name = &""
	_curr_test_name = null
	
func __run_single_test(method_name,ln_item):
	__set_run_state(1)
	__run_test(method_name,ln_item)
	
func __run_all_tests():
	_ln_item.queue_free()
	__on_runner_ready(_runner)
	
func __get_test_cases():
	var cases = []
	for entry in get_method_list():
		var entry_name = entry.name
		if entry.flags == METHOD_FLAG_NORMAL \
				and entry_name != &"test_name" \
				and ( \
					entry_name.begins_with(&"it") \
					or entry_name.begins_with(&"should") \
					or entry_name.begins_with(&"test") \
				):
				var case = {}
				case.name = entry.name.replace(&"_",&" ")
				case.fn = entry.name
				cases.append(case)
	return cases

func __assert(result:bool, description, default):
	if !result:
		_results.append(description if description else default)
		
func __append_error(description):
	_results.append(description)
	
static func __type_to_str(type:int):
	match type:
		TYPE_NIL:
			return "null"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR2:
			return "Vector2"
		TYPE_VECTOR2I:
			return "Vector2i"
		TYPE_RECT2:
			return "Rect2"
		TYPE_RECT2I:
			return "Rect2i"
		TYPE_VECTOR3:
			return "Vector3"
		TYPE_VECTOR3I:
			return "Vector3i"
		TYPE_TRANSFORM2D:
			return "Transform2D"
		TYPE_VECTOR4:
			return "Vector4"
		TYPE_VECTOR4I:
			return "Vector4i"
		TYPE_PLANE:
			return "Plane"
		TYPE_QUATERNION:
			return "Quaternion"
		TYPE_AABB:
			return "AABB"
		TYPE_BASIS:
			return "Basis"
		TYPE_TRANSFORM3D:
			return "Transform3D"
		TYPE_PROJECTION:
			return "Projection"
		TYPE_COLOR:
			return "Color"
		TYPE_STRING_NAME:
			return "StringName"
		TYPE_NODE_PATH:
			return "NodePath"
		TYPE_RID:
			return "RID"
		TYPE_OBJECT:
			return "Object"
		TYPE_CALLABLE:
			return "Callable"
		TYPE_SIGNAL:
			return "Signal"
		TYPE_DICTIONARY:
			return "Dictionary"
		TYPE_ARRAY:
			return "Array"
		TYPE_PACKED_BYTE_ARRAY:
			return "PackedByteArray"
		TYPE_PACKED_INT32_ARRAY:
			return "PackedInt32Array"
		TYPE_PACKED_INT64_ARRAY:
			return "PackedInt64Array"
		TYPE_PACKED_FLOAT32_ARRAY:
			return "PackedFloat32Array"
		TYPE_PACKED_FLOAT64_ARRAY:
			return "PackedFloat64Array"
		TYPE_PACKED_STRING_ARRAY:
			return "PackedStringArray"
		TYPE_PACKED_VECTOR2_ARRAY:
			return "PackedVector2Array"
		TYPE_PACKED_VECTOR3_ARRAY:
			return "PackedVector3Array"
		TYPE_PACKED_COLOR_ARRAY:
			return "PackedColorArray"
		TYPE_MAX:
			return "Represents the size of the Variant.Type enum"
	return "typeof(%s) " % type