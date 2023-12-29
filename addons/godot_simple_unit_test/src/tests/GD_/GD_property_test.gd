extends SimpleTest


func _it_can_get_single_prop_from_dictionary():
	var dict = {"foo":"bar"}
	var fn = GD__.property("foo")
	expect(fn.call(dict)).to.equal("bar")


func _it_can_get_single_prop_from_object():
	var node = Node2D.new()
	node.global_position = Vector2(10,10)
	
	var fn = GD__.property("global_position")
	expect(fn.call(node)).to.equal(Vector2(10,10))
	node.free()
	
	
func _it_can_get_single_prop_from_an_array():
	var array = ["never","gonna","give","you","up"]
	
	var fn = GD__.property("3")
	expect(fn.call(array)).to.equal("you")
	
	
func it_can_get_nested_properties():
	var node = Node2D.new()
	node.global_position = Vector2(999,999)
	
	var everything_everywhere_all_at_once = {
		"array": ["hello", node, "world"]
	}

	var fn = GD__.property("array:1:global_position")
	expect(fn.call(everything_everywhere_all_at_once)).equal(Vector2(999,999))