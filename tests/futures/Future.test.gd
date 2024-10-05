extends SimpleTest

func it_should_complete_await_only_after_resolve():
	var future = SimpleTest_Promise.new()
	var state = { "ctr": 100}

	future.then(func (_u): state.ctr = 200)
	expect(state.ctr).to.equal(100, "Should not execute change until resolved is called")
	
	future.resolve()
	await wait(1)
	expect(state.ctr).to.equal(200, "Should now be 200 now that resolved been called")

func it_should_chain_then():
	var future = SimpleTest_Promise.new()
	var state = { 
			"a": 1,
			"b": 10,
			"c": 100,
		}

	future\
		.then(func (_u): state.a = 2)\
		.then(func (_u): state.b = 20)\
		.then(func (_u): state.c = 200)
		
	expect(state.a).to.equal(1, "Should(a) not execute change until resolved is called")
	expect(state.b).to.equal(10, "Should(b) not execute change until resolved is called")
	expect(state.c).to.equal(100, "Should(c) not execute change until resolved is called")
	
	future.resolve()
	await wait(1)
	expect(state.a).to.equal(2, "Should(a) have changed since resolved called")
	expect(state.b).to.equal(20, "Should(b) have changed since resolved called")
	expect(state.c).to.equal(200, "Should(c) have changed since resolved called")

func it_should_have_an_awaitable_then():
	var future = create_wait_future(0.5)
	var state = { 
			"a": 1,
			"b": 10,
			"c": 100,
		}
		
	await future\
		.then(func (_u): state.a = 2)\
		.then(func (_u): state.b = 20)\
		.then(func (_u): state.c = 200)\
		.completed()
		
	expect(state.a).to.equal(2, "Should(a) have changed since resolved called")
	expect(state.b).to.equal(20, "Should(b) have changed since resolved called")
	expect(state.c).to.equal(200, "Should(c) have changed since resolved called")

func it_all_only_resolves_after_all_promises_done():
	var future1 := create_wait_future(0.1)
	var future2 := create_wait_future(0.2)
	var future3 := create_wait_future(0.3)
	var future_all = SimpleTest_Promise.all([
		future1,
		future2,
		future3
	])
	
	await future1.completed()
	expect(future1.fulfilled).to.equal([0.1,null], "SimpleTest_Promise 1 done")
	expect(future2.fulfilled).to.NOT.equal([0.2,null],"SimpleTest_Promise 2 NOT yet done")
	expect(future3.fulfilled).to.NOT.equal([0.3,null],"SimpleTest_Promise 1 NOT yet done")
	expect(future_all.fulfilled).to.equal(null, "This should not resolve the entire future until all 3 are done")
	
	await future2.completed()
	expect(future1.fulfilled).to.equal([0.1,null])
	expect(future2.fulfilled).to.equal([0.2,null])
	expect(future3.fulfilled).to.NOT.equal([0.3,null])
	expect(future_all.fulfilled).to.equal(null)
	
	await future3.completed()
	expect(future1.fulfilled).to.equal([0.1,null])
	expect(future2.fulfilled).to.equal([0.2,null])
	expect(future3.fulfilled).to.equal([0.3,null])
	expect(future_all.fulfilled).to.equal([[0.1,0.2,0.3], null])
	
func create_wait_future(time:float) -> SimpleTest_Promise:
	var future = SimpleTest_Promise.new()
	get_tree()\
		.create_timer(time)\
		.timeout\
		.connect(func ():future.resolve(time))
	return future
