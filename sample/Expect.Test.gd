extends SimpleTest

func test_loose_equals():
	expect(100).to.equal(100, "Should accept same types")
	expect(100).to.equal(100.0, "Should accept different types types")
	expect([1,2,3]).to.equal([1,2,3], "Objects are internally stringified")

func test_strict_equals():
	var a = [1,2,3]
	
	expect(100).to.STRICTLY.equal(100, "Should only accept the same type")
	expect(100).to.NOT.STRICTLY.equal(100.0, "Should fail if types are not the same")
	
	expect([1,2,3]).to.NOT.STRICTLY.equal([1,2,3], "Should compare by reference even if value is the same")
	
	
	expect(a).to.STRICTLY.equal(a, "Should compare by reference even if value is the same")
	expect([1,2,5]).to.NOT.be([1,2,5], "BE is the same as STRICTLY.equal")

func test_not_equal():
	expect(1).NOT.to.equal(10)
