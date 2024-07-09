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
    
func it_timesout_after_default_time():
    var time_1 = Time.get_ticks_msec()
    var success = await wait_until( func (): return false)
    var time_2 = Time.get_ticks_msec()
    
    expect(success).to.be.falsey()
    expect(time_2 - time_1).to.be.gte(5000)
    
func it_timesout_after_custom_time():
    var time_1 = Time.get_ticks_msec()
    var success = await wait_until( func (): return false, 1)
    var time_2 = Time.get_ticks_msec()
    
    expect(success).to.be.falsey()
    expect(time_2 - time_1).to.be.gte(1000)

class Test_Class:
    extends Node
    
    var counter = 0
    
    func _process(delta):
        counter += 1
