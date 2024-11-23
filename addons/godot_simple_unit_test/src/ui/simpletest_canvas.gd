extends CanvasLayer

@export var container:Control


var ready_future:SimpleTest_Promise = SimpleTest_Promise.new()


var should_show_passed_tests:bool

signal on_toggle_show_passed_tests

func _ready() -> void:
	ready_future.resolve(true)

func add_block(block:Control):
	container.add_block.call_deferred(block)

func _on_failed_button_toggled(toggled_on):
	should_show_passed_tests = not(toggled_on)
	on_toggle_show_passed_tests.emit()	

func _on_before_each(dict:Dictionary):
	print("_on_before_each",dict)
