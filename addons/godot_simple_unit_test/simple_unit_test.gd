@tool
extends EditorPlugin

func _enter_tree():
	var expected_path = "res://addons/godot_simple_unit_test"
	var dir = DirAccess.open(expected_path)
	
	if dir:
		print("Simple Test activated.")
	else:
		printerr("Warning, SimpleTest folder should reside at ",expected_path,". This will break a few things")


func _apply_changes():
	call_deferred("_rebuild_all_nodes")
	
	
func _rebuild_all_nodes():
	var root_scene = EditorInterface.get_edited_scene_root()
	SimpleTest_Utils.scan_and_rebuild_all_test_cases(root_scene)
