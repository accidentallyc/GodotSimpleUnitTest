class_name SimpleTest_Utils

static func get_test_cases(script):
	var cases = []
	for entry in script.get_method_list():
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
	
static func scan_and_rebuild_all_test_cases(scene_root):
	_saratc_traverse_node(scene_root, scene_root)

static func _saratc_traverse_node(node:Node, test_runner:SimpleTest_Runner):
	for c in node.get_children():
		var child = c as SimpleTest
		if child:
			_saratc_traverse_node(child, test_runner)
	if node !=  test_runner and not(node is SimpleTest_Case): 
		_saratc_rebuild_test_cases(node,test_runner)
	
	
static func _saratc_rebuild_test_cases(t:SimpleTest, test_runner:Node):
	var test = t as SimpleTest
	
	var cases = SimpleTest_Utils.get_test_cases(test)
	var test_cases = GD_.map(cases,"fn")

	# Remove the nodes already existing from the test_case list
	# and if a non-existent method (aka a deleted test or renamed) then
	# we remove it.
	for child in test.get_children():
		var case = child as SimpleTest_Case
		if case:
			if case.method_name in test_cases:
				test_cases.erase(case.method_name)
			else:
				case.queue_free()
	
	# For the remaining in the list, this should be newly added methods
	# And we create the test case nodes for them
	for case_name in test_cases:
		var test_case_node = SimpleTest_Case.new()
		test.add_child(test_case_node)
		test_case_node.method_name = case_name
		test_case_node.name = case_name.replace(&"_",&" ")
		test_case_node.owner = test_runner
