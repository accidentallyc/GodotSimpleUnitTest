extends SimpleTest


@export var testName:String = "Unnamed test"
@export var shouldPass:bool = true

func it_is_a_test():
	test_name(testName)
	if not shouldPass:
		expect_fail("This test measure should fail")