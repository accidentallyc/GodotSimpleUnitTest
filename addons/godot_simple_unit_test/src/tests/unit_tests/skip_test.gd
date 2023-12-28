extends SimpleTest

@export var skip_test_measure:SimpleTest

func it_should_skip_test_measure():
	var ln_item = skip_test_measure._ln_item;
	expect(ln_item.status).equal(&"SKIPPED")
	expect(ln_item.childContainerNode.get_children()).to.be.falsey()
