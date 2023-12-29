extends SimpleTest

func test_suite_should_not_be_visible_cause_skipped(_skip):
	expect_fail('This test should have been skipped')
