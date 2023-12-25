extends Button

var __method_name:String = ""
var __test:Node

func _on_button_up():
	if __method_name == &"__run_all_tests":
		__test.__run_all_tests()
	else:
		__test.__run_single_test(__method_name, owner)
