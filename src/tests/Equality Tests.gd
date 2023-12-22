extends SimpleTest

## Canary test. The assertion in this test build on top of eachother
func test_foundation_test():
	test_name("FOUNDATION TEST - make sure this passes")
	expect(100).to.equal(999)
	assert(
		_results.size() > 0 && _results[0] == "Expected 100(int) to loosely equal in 999(int)",
		"Canary test failed. All other tests should be considered fail."
	)
	
	# Reset to have it look "passed"
	_results.clear() 
	
func test_equals_fails_when_not_equal():
	test_name("100 == 200 should FAIL")
	try(func (): expect(100).to.equal(200))
	expect_failure("Expected 100(int) to loosely equal in 200(int)")
	
func test_NOT_inverts_the_fails_when_not_equal_test():
	test_name("'NOT' 100 == 200 should pass")
	try(func (): expect(100).to.NOT.equal(200))
	expect_passing()
	
func test_equals_passes_when_equal():
	test_name("100 == 100 should pass")
	try(func (): expect(100).to.equal(100))
	expect_passing()
	
func test_NOT_inverts_the_fails_when_equal_test():
	test_name("'NOT' 100 == 100 should FAIL")
	try(func (): expect(100).to.equal(100))
	expect_passing()
	
func test_equals_passes_when_equal_but_diff_type():
	test_name("equality between mismatching types but same value should pass")
	try(func (): expect(333).to.equal(333.0))
	expect_passing()
	
	try(func (): expect("333").to.equal(333.0))
	expect_passing()
	
	try(func (): expect([1,2,3]).to.equal([1,2,3]))
	expect_passing()
	
func test_strict_equals_checks_for_type():
	test_name("equality between mismatching types should FAIL")
	try(func (): expect(100).to.strictly.equal(100.0))
	expect_failure("Expected 100(int) to STRICTLY equal in 100(float)")
	
func test_NOT_inverts_the_result():
	test_name("'NOT' equality between mismatching types should pass")
	try(func (): expect(100).to.NOT.equal(100))
	expect_failure("Expected 100(int) to NOT loosely equal in 100(int)")
	
"""
////////////////////
// TEST UTILITIES //
////////////////////
"""	
	
static var __tabs = "     ";
## How do you assert on an assertion libraries assertion?
## BY USING itself ofcourse
func try(callable:Callable):
	callable.call()
	
func expect_failure(expected_error):
	var error = pop_error()
	if error == expected_error:
		return
		
	if error == null:
		var message = &"At `{test}`:\nExpected the error to be \n{tabs}'{err1}'\n but passed instead".format({
			&"tabs":__tabs,
			&"test":_curr_test_name,
			&"err1":expected_error
		})
		print(message)
	else:
		var description = &"Expected the error to be \n{tabs}'{err1}' \nbut got \n{tabs}'{err2}'\ninstead ".format({
			&"tabs":__tabs,
			&"err1":expected_error,
			&"err2":error
		})
		expect(error).equal(expected_error, description)
		if error != expected_error:
			var message = (&"At `{test}`:\n" + description).format({ 
				&"test":_curr_test_name
			})
			print(message)
	
func expect_passing():
	var error = pop_error()
	var description = &"Expected no error but instead got\n     '%s'" % [error]
	expect(error).equal(null, description)
	if error != null:
		print(description)

func pop_error():
	if _results.size() > 0:
		var r = _results.pop_front()
		_results.clear()
		return r
	return null
