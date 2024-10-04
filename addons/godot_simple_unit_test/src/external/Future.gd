extends RefCounted

## SimpleTest's implementation of promise
class_name SimpleTest_Promise

var fulfilled = null
var is_fulfilled = false

signal on_resolved()

var noop = func(): return
var success_cb:Callable = noop
var fail_cb:Callable = noop

var id = randf()

func _init(initial_awaitable:Callable = noop):
	if not is_same(initial_awaitable,noop):
		_wait(0.01).connect(func ():
			match initial_awaitable.get_argument_count():
				1: initial_awaitable.call(resolve)
				2: initial_awaitable.call(resolve,reject)
				_: assert(false,"Constructor callables must be created with either 1 or 2 args")
			)

## This creates a wait timer of 0.1 seconds
## and turns the function into a coroutine
static func _wait(time=0.1):
	return Engine.get_main_loop().create_timer(time).timeout
	
## Creates a promise that is already resolved
static func resolved(v):
	var pr = SimpleTest_Promise.new()
	pr.fulfilled = v
	pr.is_fulfilled = true
	return pr
	
	
static func all(args:Array[SimpleTest_Promise])->SimpleTest_Promise:
	var future := SimpleTest_Promise.new()
	var args_size = args.size()
	var state = {"resolved":0}
	
	var results = range(args_size)
	
	for index in args_size:
		var arg = args[index]
		var promise_cb = func(result = null):
			state.resolved += 1
			if result:
				results[index] = result
			
			if state.resolved == args_size:
				future.resolve(results)
		arg.then(promise_cb)
		
	return future
	

func then(_success_cb:Callable = success_cb, _fail_cb:Callable = fail_cb)->SimpleTest_Promise:
	if is_fulfilled:
		return SimpleTest_Promise.resolved(fulfilled)
		
	var new_pr = SimpleTest_Promise.new()
	if not is_same(success_cb, _success_cb):
		success_cb = func (arg = null):
			match _success_cb.get_argument_count():
				0: _success_cb.call()
				1: _success_cb.call(arg)
				_: assert(false,"Then callbacks must be created with between 0-1 args got %s" % _success_cb.get_argument_count())
			new_pr.resolve(arg)
	if not is_same(fail_cb, _fail_cb):
		fail_cb = func (arg = null):
			
			match _fail_cb.get_argument_count():
				0: _fail_cb.call()
				1: _fail_cb.call(arg)
				_: assert(false,"Then callbacks must be created with between 0-1 args got %s" % _fail_cb.get_argument_count())
			new_pr.reject(arg)

	return new_pr
	
func catch(_fail_cb:Callable = fail_cb)->SimpleTest_Promise:
	return then(success_cb,_fail_cb)

## Returns the signal or a value
func completed():
	while not(is_fulfilled):
		await _wait()
	return fulfilled

## Resolves the future
func resolve(v = null):
	if is_fulfilled: return
	fulfilled = [v,null]
	is_fulfilled = true
	
	match success_cb.get_argument_count():
		0: success_cb.call()
		1: success_cb.call(v)
		_: assert(false,"Then callbacks must be created with between 0-1 args got %s" % success_cb.get_argument_count())
	
	on_resolved.emit()
	
## Rejects the future
func reject(err = null):
	if is_fulfilled: return
	fulfilled = [null,err]
	is_fulfilled = true
	
	match fail_cb.get_argument_count():
		0: fail_cb.call()
		1: fail_cb.call(err)
		_: assert(false,"Then callbacks must be created with between 0-1 args")
	
	on_resolved.emit()
