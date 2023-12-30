## Planning to make this into a port of Lodash?
## Set it as GD__ instead of GD_ to mark that its
## internal to this addon
class_name GD__
"""
Array
"""
static func not_implemented():  assert(false, "Not implemented")
static func chunk(a=0, b=0, c=0): not_implemented()
static func compact(a=0, b=0, c=0): not_implemented()
static func concat(a=0, b=0, c=0): not_implemented()
static func difference(a=0, b=0, c=0): not_implemented()
static func difference_by(a=0, b=0, c=0): not_implemented()
static func difference_with(a=0, b=0, c=0): not_implemented()
static func drop(a=0, b=0, c=0): not_implemented()
static func drop_right(a=0, b=0, c=0): not_implemented()
static func drop_right_while(a=0, b=0, c=0): not_implemented()
static func drop_while(a=0, b=0, c=0): not_implemented()
static func fill(a=0, b=0, c=0): not_implemented()
static func find_index(a=0, b=0, c=0): not_implemented()
static func find_last_index(a=0, b=0, c=0): not_implemented()
static func first(a=0, b=0, c=0): not_implemented() #alias of head
static func head(a=0, b=0, c=0): not_implemented()
static func flatten(a=0, b=0, c=0): not_implemented()
static func flatten_deep(a=0, b=0, c=0): not_implemented()
static func flatten_depth(a=0, b=0, c=0): not_implemented()
static func from_pairs(a=0, b=0, c=0): not_implemented()
static func index_of(a=0, b=0, c=0): not_implemented()
static func initial(a=0, b=0, c=0): not_implemented()
static func intersection(a=0, b=0, c=0): not_implemented()
static func intersection_by(a=0, b=0, c=0): not_implemented()
static func intersection_with(a=0, b=0, c=0): not_implemented()
static func join(a=0, b=0, c=0): not_implemented()
static func last(a=0, b=0, c=0): not_implemented()
static func last_index_of(a=0, b=0, c=0): not_implemented()
static func nth(a=0, b=0, c=0): not_implemented()
static func pull(a=0, b=0, c=0): not_implemented()
static func pull_all(a=0, b=0, c=0): not_implemented()
static func pull_all_by(a=0, b=0, c=0): not_implemented()
static func pull_all_with(a=0, b=0, c=0): not_implemented()
static func pull_at(a=0, b=0, c=0): not_implemented()
static func remove(a=0, b=0, c=0): not_implemented()
static func reverse(a=0, b=0, c=0): not_implemented()
static func slice(a=0, b=0, c=0): not_implemented()
static func sorted_index(a=0, b=0, c=0): not_implemented()
static func sorted_index_by(a=0, b=0, c=0): not_implemented()
static func sorted_index_of(a=0, b=0, c=0): not_implemented()
static func sorted_last_index(a=0, b=0, c=0): not_implemented()
static func sorted_last_index_by(a=0, b=0, c=0): not_implemented()
static func sorted_last_index_of(a=0, b=0, c=0): not_implemented()
static func sorted_uniq(a=0, b=0, c=0): not_implemented()
static func sorted_uniq_by(a=0, b=0, c=0): not_implemented()
static func tail(a=0, b=0, c=0): not_implemented()
static func take(a=0, b=0, c=0): not_implemented()
static func take_right(a=0, b=0, c=0): not_implemented()
static func take_right_while(a=0, b=0, c=0): not_implemented()
static func take_while(a=0, b=0, c=0): not_implemented()
static func union(a=0, b=0, c=0): not_implemented()
static func union_by(a=0, b=0, c=0): not_implemented()
static func union_with(a=0, b=0, c=0): not_implemented()
static func uniq(a=0, b=0, c=0): not_implemented()
static func uniq_by(a=0, b=0, c=0): not_implemented()
static func uniq_with(a=0, b=0, c=0): not_implemented()
static func unzip(a=0, b=0, c=0): not_implemented()
static func unzip_with(a=0, b=0, c=0): not_implemented()
static func without(a=0, b=0, c=0): not_implemented()
static func xor(a=0, b=0, c=0): not_implemented()
static func xor_by(a=0, b=0, c=0): not_implemented()
static func xor_with(a=0, b=0, c=0): not_implemented()
static func zip(a=0, b=0, c=0): not_implemented()
static func zip_object(a=0, b=0, c=0): not_implemented()
static func zip_object_deep(a=0, b=0, c=0): not_implemented()
static func zip_with(a=0, b=0, c=0): not_implemented()

"""
Collections
"""

## Creates a dictionary composed of keys generated from the results of 
## running each element of collection thru iteratee. The corresponding value 
## of each key is the number of times the key was returned by iteratee. 
## The iteratee is invoked with one argument: (value).
## This attempts to replicate lodash's count_by. 
## See https://lodash.com/docs/4.17.15#countBy
static func count_by(collection, iteratee = null):
	if not(_is_collection(collection)):
		printerr("GD__.filter received a non-collection type object")
		return null
		
	var iter_func = iteratee(iteratee, 1)
	var counters = {}
	for item in collection:
		var key = str(iter_func.call(item,null))
		if not(counters.has(key)):
			counters[key] = 0
		counters[key] += 1
	return counters

static func each(a=0, b=0, c=0): not_implemented() # alias for forEach
static func for_each(a=0, b=0, c=0): not_implemented()

static func each_right(a=0, b=0, c=0): not_implemented()
static func every(a=0, b=0, c=0): not_implemented()

## Iterates over elements of collection, returning an array of all elements predicate returns truthy for. 
## The predicate is invoked with two arguments (value, index|key).
## This attempts to replicate lodash's filter. 
## See https://lodash.com/docs/4.17.15#filter
static func filter(collection, iteratee = null):
	if not(_is_collection(collection)):
		printerr("GD__.filter received a non-collection type object")
		return null
		
	var iter_func = iteratee(iteratee)
	var index = 0
	var new_collection = []
	for item in collection:
		if iter_func.call(item,index):
			new_collection.append(item)
		index += 1
	return new_collection
	
	
## Iterates over elements of collection, returning the first element predicate returns truthy for.
## The predicate is invoked with two arguments: (value, index|key).
## This attempts to replicate lodash's find. 
## See https://lodash.com/docs/4.17.15#find
static func find(collection, iteratee = null, from_index = 0):
	if not(_is_collection(collection)):
		printerr("GD__.find received a non-collection type object")
		return null
		
	var iter_func = iteratee(iteratee)
	var index = 0
	for item in collection:
		if index >= from_index and iter_func.call(item,index):
			return item
		index += 1
	return null
	
	
static func find_last(a=0, b=0, c=0): not_implemented()
static func flat_map(a=0, b=0, c=0): not_implemented()
static func flat_map_deep(a=0, b=0, c=0): not_implemented()
static func flat_map_depth(a=0, b=0, c=0): not_implemented()
static func for_each_right(a=0, b=0, c=0): not_implemented()


## Creates a dictionary composed of keys generated from the results of 
## running each element of collection thru iteratee. The order of grouped values is 
## determined by the order they occur in collection. The corresponding value 
## of each key is an array of elements responsible for generating the key. 
## The iteratee is invoked with one argument: (value).
## See https://lodash.com/docs/4.17.15#groupBy
static func group_by(collection, iteratee = null):
	if not(_is_collection(collection)):
		printerr("GD__.filter received a non-collection type object")
		return null
		
	var iter_func = iteratee(iteratee, 1)
	var counters = {}
	for item in collection:
		var key = str(iter_func.call(item,null))
		if not(counters.has(key)):
			counters[key] = []
		counters[key].append(item)
	return counters
	
	
static func includes(a=0, b=0, c=0): not_implemented()
static func invoke_map(a=0, b=0, c=0): not_implemented()
static func key_by(a=0, b=0, c=0): not_implemented()


static func map(collection, iteratee):
	if not(_is_collection(collection)):
		printerr("GD__.map received a non-collection type object")
		return null
		
	
	var key
	if iteratee is String:
		key = iteratee
	else:
		assert(false,"%s is not supported as an iteratee" % iteratee)
		
	var new_collection = []
	for c in collection:
		new_collection.append(c[key])
	return new_collection
	
	
static func order_by(a=0, b=0, c=0): not_implemented()
static func partition(a=0, b=0, c=0): not_implemented()
static func reduce(a=0, b=0, c=0): not_implemented()
static func reduce_right(a=0, b=0, c=0): not_implemented()
static func reject(a=0, b=0, c=0): not_implemented()
static func sample(a=0, b=0, c=0): not_implemented()
static func sample_size(a=0, b=0, c=0): not_implemented()
static func shuffle(a=0, b=0, c=0): not_implemented()
static func size(a=0, b=0, c=0): not_implemented()

## Checks if predicate returns truthy for any element of collection. 
## Iteration is stopped once predicate returns truthy. 
## The predicate is invoked with two arguments: (value, index|key).
## This attempts to replicate lodash's some. 
## See https://lodash.com/docs/4.17.15#some
static func some(collection, iteratee = null):
	if not(_is_collection(collection)):
		printerr("GD__.some received a non-collection type object")
		return null
		
	var iter_func = iteratee(iteratee)
	var index = 0
	for item in collection:
		if iter_func.call(item,index):
			return true
		index += 1
	return false
	
	
static func sort_by(a=0, b=0, c=0): not_implemented()

"""
Date
"""
static func now(a=0, b=0, c=0): not_implemented()
"""
Function
"""
static func after(a=0, b=0, c=0): not_implemented()
static func ary(a=0, b=0, c=0): not_implemented()
static func before(a=0, b=0, c=0): not_implemented()
static func bind(a=0, b=0, c=0): not_implemented()
static func bind_key(a=0, b=0, c=0): not_implemented()
static func curry(a=0, b=0, c=0): not_implemented()
static func curry_right(a=0, b=0, c=0): not_implemented()
static func debounce(a=0, b=0, c=0): not_implemented()
static func defer(a=0, b=0, c=0): not_implemented()
static func delay(a=0, b=0, c=0): not_implemented()
static func flip(a=0, b=0, c=0): not_implemented()
static func memoize(a=0, b=0, c=0): not_implemented()
static func negate(a=0, b=0, c=0): not_implemented()
static func once(a=0, b=0, c=0): not_implemented()
static func over_args(a=0, b=0, c=0): not_implemented()
static func partial(a=0, b=0, c=0): not_implemented()
static func partial_right(a=0, b=0, c=0): not_implemented()
static func rearg(a=0, b=0, c=0): not_implemented()
static func rest(a=0, b=0, c=0): not_implemented()
static func spread(a=0, b=0, c=0): not_implemented()
static func throttle(a=0, b=0, c=0): not_implemented()
static func unary(a=0, b=0, c=0): not_implemented()
static func wrap_func(a=0, b=0, c=0): not_implemented()
"""
Lang
"""


## Casts value as an array if it's not one.
## Returns an empty array if null.
static func cast_array(v):
	if v:
		return v if v is Array else [v]
	else:
		return []
		
static func clone(a=0, b=0, c=0): not_implemented()
static func clone_deep(a=0, b=0, c=0): not_implemented()
static func clone_deep_with(a=0, b=0, c=0): not_implemented()
static func clone_with(a=0, b=0, c=0): not_implemented()
static func conforms_to(a=0, b=0, c=0): not_implemented()
static func eq(a=0, b=0, c=0): not_implemented()
static func gt(a=0, b=0, c=0): not_implemented()
static func gte(a=0, b=0, c=0): not_implemented()
static func is_arguments(a=0, b=0, c=0): not_implemented()
static func is_array(a=0, b=0, c=0): not_implemented()
static func is_array_buffer(a=0, b=0, c=0): not_implemented()
static func is_array_like(a=0, b=0, c=0): not_implemented()
static func is_array_like_object(a=0, b=0, c=0): not_implemented()
static func is_boolean(a=0, b=0, c=0): not_implemented()
static func is_buffer(a=0, b=0, c=0): not_implemented()
static func is_date(a=0, b=0, c=0): not_implemented()
static func is_element(a=0, b=0, c=0): not_implemented()
static func is_empty(a=0, b=0, c=0): not_implemented()
static func is_equal(a=0, b=0, c=0): not_implemented()
static func is_equal_with(a=0, b=0, c=0): not_implemented()
static func is_error(a=0, b=0, c=0): not_implemented()
#static func is_finite(a=0, b=0, c=0): not_implemented()
static func is_function(a=0, b=0, c=0): not_implemented()
static func is_integer(a=0, b=0, c=0): not_implemented()
static func is_length(a=0, b=0, c=0): not_implemented()
static func is_map(a=0, b=0, c=0): not_implemented()
static func is_match(a=0, b=0, c=0): not_implemented()
static func is_match_with(a=0, b=0, c=0): not_implemented()
#static func is_nan(a=0, b=0, c=0): not_implemented()
static func is_native(a=0, b=0, c=0): not_implemented()
static func is_nil(a=0, b=0, c=0): not_implemented()
static func is_null(a=0, b=0, c=0): not_implemented()
static func is_number(a=0, b=0, c=0): not_implemented()
static func is_object(a=0, b=0, c=0): not_implemented()
static func is_object_like(a=0, b=0, c=0): not_implemented()
static func is_plain_object(a=0, b=0, c=0): not_implemented()
static func is_reg_exp(a=0, b=0, c=0): not_implemented()
static func is_safe_integer(a=0, b=0, c=0): not_implemented()
static func is_set(a=0, b=0, c=0): not_implemented()
static func is_string(a=0, b=0, c=0): not_implemented()
static func is_symbol(a=0, b=0, c=0): not_implemented()
static func is_typed_array(a=0, b=0, c=0): not_implemented()
static func is_undefined(a=0, b=0, c=0): not_implemented()
static func is_weak_map(a=0, b=0, c=0): not_implemented()
static func is_weak_set(a=0, b=0, c=0): not_implemented()
static func lt(a=0, b=0, c=0): not_implemented()
static func lte(a=0, b=0, c=0): not_implemented()
static func to_array(a=0, b=0, c=0): not_implemented()
static func to_finite(a=0, b=0, c=0): not_implemented()
static func to_integer(a=0, b=0, c=0): not_implemented()
static func to_length(a=0, b=0, c=0): not_implemented()
static func to_number(a=0, b=0, c=0): not_implemented()
static func to_plain_object(a=0, b=0, c=0): not_implemented()
static func to_safe_integer(a=0, b=0, c=0): not_implemented()
#static func to_string(a=0, b=0, c=0): not_implemented()

"""
MATH
"""
static func add(a=0, b=0, c=0): not_implemented()
#static func ceil(a=0, b=0, c=0): not_implemented()
static func divide(a=0, b=0, c=0): not_implemented()
#static func floor(a=0, b=0, c=0): not_implemented()
#static func max(a=0, b=0, c=0): not_implemented()
static func max_by(a=0, b=0, c=0): not_implemented()
static func mean(a=0, b=0, c=0): not_implemented()
static func mean_by(a=0, b=0, c=0): not_implemented()
#static func min(a=0, b=0, c=0): not_implemented()
static func min_by(a=0, b=0, c=0): not_implemented()
static func multiply(a=0, b=0, c=0): not_implemented()
#static func round(a=0, b=0, c=0): not_implemented()
static func subtract(a=0, b=0, c=0): not_implemented()
static func sum(a=0, b=0, c=0): not_implemented()
static func sum_by(a=0, b=0, c=0): not_implemented()


"""
NUMBER
"""

#static func clamp(a=0, b=0, c=0): not_implemented()
static func in_range(a=0, b=0, c=0): not_implemented()
static func random(a=0, b=0, c=0): not_implemented()

"""
OBJECT
"""
static func assign(a=0, b=0, c=0): not_implemented()
static func assign_in(a=0, b=0, c=0): not_implemented()
static func assign_in_with(a=0, b=0, c=0): not_implemented()
static func assign_with(a=0, b=0, c=0): not_implemented()
static func at(a=0, b=0, c=0): not_implemented()
static func create(a=0, b=0, c=0): not_implemented()
static func defaults(a=0, b=0, c=0): not_implemented()
static func defaults_deep(a=0, b=0, c=0): not_implemented()
static func to_pairs(a=0, b=0, c=0): not_implemented() # alias for entries
static func to_pairs_in(a=0, b=0, c=0): not_implemented() # alias for entriesIn
static func find_key(a=0, b=0, c=0): not_implemented()
static func find_last_key(a=0, b=0, c=0): not_implemented()
static func for_in(a=0, b=0, c=0): not_implemented()
static func for_in_right(a=0, b=0, c=0): not_implemented()
static func for_own(a=0, b=0, c=0): not_implemented()
static func for_own_right(a=0, b=0, c=0): not_implemented()
static func functions(a=0, b=0, c=0): not_implemented()
static func functions_in(a=0, b=0, c=0): not_implemented()
#static func get(a=0, b=0, c=0): not_implemented()
static func has(a=0, b=0, c=0): not_implemented()
static func has_in(a=0, b=0, c=0): not_implemented()
static func invert(a=0, b=0, c=0): not_implemented()
static func invert_by(a=0, b=0, c=0): not_implemented()
static func invoke(a=0, b=0, c=0): not_implemented()
static func keys(a=0, b=0, c=0): not_implemented()
static func keys_in(a=0, b=0, c=0): not_implemented()
static func map_keys(a=0, b=0, c=0): not_implemented()
static func map_values(a=0, b=0, c=0): not_implemented()
static func merge(a=0, b=0, c=0): not_implemented()
static func merge_with(a=0, b=0, c=0): not_implemented()
static func omit(a=0, b=0, c=0): not_implemented()
static func omit_by(a=0, b=0, c=0): not_implemented()
static func pick(a=0, b=0, c=0): not_implemented()
static func pick_by(a=0, b=0, c=0): not_implemented()
static func result(a=0, b=0, c=0): not_implemented()
#static func set(a=0, b=0, c=0): not_implemented()
static func set_with(a=0, b=0, c=0): not_implemented()
#static func to_pairs(a=0, b=0, c=0): not_implemented()
#static func to_pairs_in(a=0, b=0, c=0): not_implemented()
static func transform(a=0, b=0, c=0): not_implemented()
static func unset(a=0, b=0, c=0): not_implemented()
static func update(a=0, b=0, c=0): not_implemented()
static func update_with(a=0, b=0, c=0): not_implemented()
static func values(a=0, b=0, c=0): not_implemented()
static func values_in(a=0, b=0, c=0): not_implemented()

"""
UTILS
"""

static func attempt(a=0, b=0, c=0): not_implemented()
static func bind_all(a=0, b=0, c=0): not_implemented()
static func cond(a=0, b=0, c=0): not_implemented()
static func conforms(a=0, b=0, c=0): not_implemented()
static func constant(a=0, b=0, c=0): not_implemented()
static func default_to(a=0, b=0, c=0): not_implemented()
static func flow(a=0, b=0, c=0): not_implemented()
static func flow_right(a=0, b=0, c=0): not_implemented()

static func identity(value, _unused = null): 
	return value
	
## Converts a shorthand to iterable
static func iteratee(iteratee, args_count = 2):
	var iter_func
	match typeof(iteratee):
		TYPE_DICTIONARY:
			iter_func = matches(iteratee)
		TYPE_STRING:
			iter_func = property(iteratee)
		TYPE_ARRAY:
			var prop = _property(["0"],iteratee)
			var val = _property(["1"],iteratee)
			iter_func = matches_property(
				prop,
				val
			)
		TYPE_NIL:
			iter_func = GD__.identity
		TYPE_CALLABLE:
			match args_count:
				1: iter_func = func(v,_unused): return iteratee.call(v)
				2: iter_func = iteratee
				_: assert(false,"Unsupported args count")
				
		_:
			printerr("GD__.find called with unsupported signature %s. See docs for more info" % iteratee)
	return iter_func


static func matches(dict:Dictionary) -> Callable:
	return func (value, _unused = null):
		var found = true
		for key in dict:
			var prop = value.get(key)
			found = found and (prop and dict[key] == prop)
		return found
		
static func matches_property(string:String, v):
	var splits = string.split(":")
	return func (value, _unused = null):
		return _property(splits,value) == v
		
		
static func method(a=0, b=0, c=0): not_implemented()
static func method_of(a=0, b=0, c=0): not_implemented()
static func mixin(a=0, b=0, c=0): not_implemented()
static func no_conflict(a=0, b=0, c=0): not_implemented()

static func noop(a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0,i=0,j=0,k=0,l=0,m=0,n=0,o=0,p=0): 
	pass
			
static func nth_arg(a=0, b=0, c=0): not_implemented()
static func over(a=0, b=0, c=0): not_implemented()
static func over_every(a=0, b=0, c=0): not_implemented()
static func over_some(a=0, b=0, c=0): not_implemented()

## Creates a function that returns the value at path of a given object.	
static func property(string:String):
	var splits = string.split(":")
	return func (value, _unused = null):
		return _property(splits, value)

## The underlying function that property calls. Use this if you want
## to skip the creation of a lambda
static func _property(splits:Array,value):
	var curr_prop = value
	for split in splits:
		if curr_prop is Object:
			var attempt = curr_prop.get(split)
			if attempt != null:
				curr_prop = attempt
				continue
			else:
				return null
		if curr_prop is Dictionary:
			if curr_prop.has(split):
				curr_prop = curr_prop[split]
				continue
			else:
				return null
		if curr_prop is Array and split.is_valid_int() and int(split) < curr_prop.size():
			curr_prop = curr_prop[int(split)]
			continue
		
		return null
	return curr_prop
	
		
static func property_of(a=0, b=0, c=0): not_implemented()
#static func range(a=0, b=0, c=0): not_implemented()
static func range_right(a=0, b=0, c=0): not_implemented()
static func run_in_context(a=0, b=0, c=0): not_implemented()
static func stub_array(a=0, b=0, c=0): not_implemented()
static func stub_false(a=0, b=0, c=0): not_implemented()
static func stub_object(a=0, b=0, c=0): not_implemented()
static func stub_string(a=0, b=0, c=0): not_implemented()
static func stub_true(a=0, b=0, c=0): not_implemented()
static func times(a=0, b=0, c=0): not_implemented()
static func to_path(a=0, b=0, c=0): not_implemented()
static func unique_id(a=0, b=0, c=0): not_implemented()


"""
INTERNAL
"""
static func _is_collection(item):
	return item is Array or item is Dictionary
