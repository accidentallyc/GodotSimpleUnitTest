extends SimpleTest

@export var implict_skip_1:SimpleTest
@export var implict_skip_2:SimpleTest
@export var explict_skip:SimpleTest
@export var solo_1:SimpleTest
@export var solo_2:SimpleTest

func test_for_actual_skip():
	var ln_item1 = implict_skip_1._ln_item;
	expect(ln_item1.status).equal(&"IMPLIED SKIP")
	expect(ln_item1.childContainerNode.get_children()).to.be.falsey()

	var ln_item2 = implict_skip_2._ln_item;
	expect(ln_item2.status).equal(&"IMPLIED SKIP")
	expect(ln_item2.childContainerNode.get_children()).to.be.falsey()

	var ln_item_explicit = explict_skip._ln_item;
	expect(ln_item_explicit.status).equal(&"SKIPPED")
	expect(ln_item_explicit.childContainerNode.get_children()).to.be.falsey()

	var ln_item_solo1 = solo_1._ln_item;
	expect(ln_item_solo1.status).equal(&"PASS")
	expect(ln_item_solo1.childContainerNode.get_children()).to.be.truthy()

	var ln_item_solo2 = solo_2._ln_item;
	expect(ln_item_solo2.status).equal(&"PASS")
	expect(ln_item_solo2.childContainerNode.get_children()).to.be.truthy()
