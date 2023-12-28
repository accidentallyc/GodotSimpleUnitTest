extends SimpleTest

static var num_cases := 3

func _before_each():
	# Delete all the children
	for c in get_children():
		c.free()


func it_test_case_measure():
	test_name("This test case is a test measure")
	

func should_be_a_test_case_for_every_node():
	"""
	No this test doesnt _actually_ check if the test cases
	are rebuilt when "save" is pressed but thats a bit harder
	to do and I cant figure out how.
	
	So i've opted to just, move it to a shared function and pray
	that this function is called in the right place.
	"""
	SimpleTest_Utils.scan_and_rebuild_all_test_cases(owner)
	
	var children = get_children()
	expect(children.size()).to.equal(num_cases)
	for child in children:
		expect(has_method(child.method_name)).truthy()


func should_not_recreate_test_cases_more_than_once():
	SimpleTest_Utils.scan_and_rebuild_all_test_cases(owner)
	SimpleTest_Utils.scan_and_rebuild_all_test_cases(owner)
	SimpleTest_Utils.scan_and_rebuild_all_test_cases(owner)

	expect(get_children().size()).to.equal(num_cases)


func not_a_test_case():
	pass
	
