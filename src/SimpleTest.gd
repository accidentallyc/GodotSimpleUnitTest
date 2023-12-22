@icon("res://addons/godot_simple_test/src/ui/icon_test.png")
extends Node

## Base class that all SimpleTests should extend from.
## This cannot be run by itself
class_name SimpleTest

static var SimpleTest_LineItemTscn = preload("./ui/SimpleTest_LineItem.tscn")

"""
######################
## Expect Functions ##
######################
"""
func expect(value):
	return SimpleTest_ExpectBuilder.new(self,value)
	
func expect_orphan_nodes(n):
	Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT) == n
	
func expect_no_orphan_nodes():
	expect_orphan_nodes(0)

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

var _ln_item
var _results:Array[String]
var _test_case_line_item_map = {}
var _runner

"""
NOTE: This _has_ to be overriden by runner
"""
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
