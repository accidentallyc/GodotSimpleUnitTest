@tool
@icon("res://addons/godot_simple_unit_test/src/ui/icon_test_case.png")
extends Node

class_name SimpleTest_Case


## Name of the method from the test
var method_name:String:
	get:
		return method_name
	set(v):
		if name_to_method_name(name) != v:
			print("rererere")
			name = v.replace(&"_", &" ")
		method_name = v
## If ticked, will only run this case, along with other "solo" cases
var solo_case:bool = false
## If ticked, will skip this case.
var skip_case:bool = false

static func name_to_method_name(namestr):
	return namestr.replace(&" ",&"_")

func _get_property_list():
	var cases = SimpleTest_Utils.get_test_cases(get_parent())
	var test_cases = &",".join( GD_.map(cases,"fn") )
	
	return [
		{
			"name":"method_name",
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": test_cases
		},
		{
			"name":"solo_case",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		},
		{
			"name":"skip_case",
			"type": TYPE_BOOL,
			"usage": PROPERTY_USAGE_DEFAULT,
		},
	]
	
## Checks if  this node has defaults set. This is mostly
## to determine if the node is controlled or uncontrolled
## A controlled node is one where the plugin is controlling it
## But when a player overrides it, it becomes uncontrolled
func _has_defaults() -> bool:
	return solo_case == false \
			and skip_case == false \
			and method_name == name_to_method_name(name)
