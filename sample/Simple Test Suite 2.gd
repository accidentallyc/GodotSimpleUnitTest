extends SimpleTest

func test_can_have_multiple_suites():
	pass

func test_can_fail():
	expect("foo").to.equal("bar")
