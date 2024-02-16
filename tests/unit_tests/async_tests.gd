extends SimpleTest

func it_can_work_with_wait():
	var time_1 = Time.get_ticks_msec()
	await wait(0.25)
	var time_2 = Time.get_ticks_msec()
	
	expect(time_2 - time_1).to.be.gte(10)

func it_can_work_with_wait_until():
	var n = Test_Class.new()
	add_child(n)
	
	await wait_until( func (): return n.counter >= 250)
	expect(n.counter).to.be.gte(250)

class Test_Class:
	extends Node
	
	var counter = 0
	
	func _process(delta):
		counter += 1
