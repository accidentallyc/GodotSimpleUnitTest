extends SimpleTest

func test_loose_equals():
	expect(100).to.equal(100, "Should accept same types")
	expect(100).to.equal(100.0, "Should accept different types types")
	expect([1,2,3]).to.equal([1,2,3], "Objects are internally stringified")

func test_strict_equals():
	var a = [1,2,3]
	
	expect(100).to.strictly.equal(100, "Should only accept the same type")
	expect(100).to.NOT.strictly.equal(100.0, "Should fail if types are not the same")
	
	expect([1,2,3]).to.NOT.strictly.equal([1,2,3], "Should compare by reference even if value is the same")
	
	
	expect(a).to.strictly.equal(a, "Should compare by reference even if value is the same")
	expect([1,2,5]).to.NOT.be([1,2,5], "BE is the same as STRICTLY.equal")

func test_not_equal():
	expect(1).NOT.to.equal(10)

func test_to_have_been_called():
	var cb = stub()
	
	expect(cb).to.NOT.have.been.called()
	
	cb.callable()
	expect(cb).to.have.been.called()
	expect(cb).to.have.been.called_n_times(2)
	
