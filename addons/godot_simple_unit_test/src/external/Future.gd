extends RefCounted

class_name Future

var fulfilled = null
var is_fulfilled = false

signal on_resolved()

var noop = func(resolve=null,reject=null): return
var success_cb:Callable = noop
var fail_cb:Callable = noop

func _init(initial_awaitable:Callable = noop):
    initial_awaitable.call(resolve)
    initial_awaitable.call(resolve,reject)

static func _wait(time=0.1):
    return Engine.get_main_loop().create_timer(time).timeout
    
static func resolved(v):
    var pr = Future.new()
    pr.fulfilled = v
    pr.is_fulfilled = true
    return pr
    
    
static func all(args:Array[Future])->Future:
    var future := Future.new()
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
    

func then(_success_cb:Callable, _fail_cb:Callable = fail_cb)->Future:
    if is_fulfilled:
        return Future.resolved(fulfilled)
        
    var new_pr = Future.new()
    success_cb = func (arg = null):
        _success_cb.call(arg)
        new_pr.resolve(arg)
    fail_cb = _fail_cb

    return new_pr

## Returns the signal or a value
func completed():
    while not(is_fulfilled):
        await _wait()
    return fulfilled

## Resolves the future
func resolve(v = null):
    if is_fulfilled: return
    fulfilled = v
    is_fulfilled = true
    
    success_cb.call(v)
    on_resolved.emit()
    
func reject(v = null):
    pass
