## Root of a SimpleTest Scene
## Assign this as the root node
@tool
extends Node
class_name SimpleTest_Runner

## Starting from this folder, recursively look for test files
@export var root:String = "res://test"
@export var suffix:String = 'Test.gd';

signal runner_ready(SimpleTest_Runner)

static var SimpleTest_CanvasTscn = preload("./ui/SimpleTest_Canvas.tscn")

#########################
# Warning Handling Code #
#########################
func _enter_tree():
	child_entered_tree.connect(func(_dummy): update_configuration_warnings())

func _get_configuration_warnings():
	if !(owner == null or owner == self):
		return ["SimpleTest_Runner must be a root node"]
	else:
		return []


var _canvas:SimpleTest_Canvas

func _ready():
	var children = get_children()
	_canvas = SimpleTest_CanvasTscn.instantiate()
	_canvas.ready.connect(func(): runner_ready.emit(self))
	add_child(_canvas)
	
func add_block(block:Control):
	_canvas.add_block.call_deferred(block)
