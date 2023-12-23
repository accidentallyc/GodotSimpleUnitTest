extends Button

var __method_name:String = ""
var __test:Node

func _on_button_up():
	__test.__run_test(__method_name, owner)
