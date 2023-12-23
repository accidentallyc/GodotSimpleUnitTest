class_name SimpleTest_ExpectBuilder


var test:SimpleTest
var value = null
func _init(t:SimpleTest, v:):
	test = t
	value = v

"""
/////////////////////////////
// FLUENT BUILDER KEYWORDS //
/////////////////////////////
"""
var to = self
var have = self
var been = self
var be = self
var IS = self
var are = self
var will = self
var NOT:
	get:
		__flag_not_notted = false
		return self
var strictly = self:
	get:
		__flag_strict = true
		return self

## Compares 'a' and 'b' using the  == operator
## When strict, it uses the is_same operator
## Example 1: expect(1).to.equal(1)
## Example 2: expect(1).to.strictly.equal(1)
func equal(other, description = null):
	return test.__assert(
		__to_notted(
			LambdaOperations.equals_strict(value,other) if __flag_strict else LambdaOperations.equals(value,other)
		),
		description,
		&"Expected {v1}({t1}) to {not}{equal} {v2}({t2})".format({
			&"v1":str(value),
			&"v2":str(other),
			&"t1":__type_to_str(typeof(value)),
			&"t2":__type_to_str(typeof(other)),
			&"equal": &"STRICTLY equal" if __flag_strict else &"loosely equal",
			&"not": &"" if __flag_not_notted else &"NOT ",
		})
	)

## Checks if 'a' is truthy using a ternary operator
## Example 1: expect(true).to.be.truthy()
## Example 2: expect([1,2,3]).to.be.truthy()
func truthy(description = null):
	return test.__assert(
		__to_notted(LambdaOperations.truthy(value)),
		description,
		&"Expected '{v1}' {to} be truthy".format({
			&"v1": str(value),
			&"to": &"to" if __flag_not_notted else &"to NOT",
		})
	)
	
## Checks if 'a' is falsey using a ternary operator
## This has the same effect as NOT
## Example 1: expect(true).to.be.falsey()
## Example 2: expect([1,2,3]).to.be.falsey()
func falsey(description = null):
	return test.__assert(
		__to_notted(not(LambdaOperations.truthy(value))),
		description,
		&"Expected '{v1}' {to} be falsey".format({
			&"v1": str(value),
			&"to": &"to" if __flag_not_notted else &"to NOT",
		})
	)

func called(description = null):
	if not(value is SimpleTest_Stub):
		return test.__append_error(
			&"'called' expected a stub but got '%s' instead. Use the stub() to make one" % str(value)
		)
		
	var vStub = value as SimpleTest_Stub
	return test.__assert(
		__to_notted(
			vStub.callstack.size() > 0
		),
		description,
		&"Expected callback {to} have been called atleast once".format({
			&"to": &"to" if __flag_not_notted else &"NOT to"
		})
	)
	
func called_n_times(n:int, description = null):
	if not(value is SimpleTest_Stub):
		return test.__append_error(
			&"'called' expected a stub but got '%s' instead. Use the stub() to make one" % value
		)
		
	var vStub = value as SimpleTest_Stub
	return test.__assert(
		__to_notted(
			vStub.callstack.size() == n
		),
		description,
		&"Expected stub {to} have been called {n} times".format({
			&"to": &"to" if __flag_not_notted else &"NOT to",
			&"n": n
		})
	)
"""
/////////////////////////////
// INTERNAL STUFF //
/////////////////////////////
"""
var __flag_strict = false
var __flag_not_notted = true
func __to_notted(r:bool):
	return r if __flag_not_notted else not(r)
	
static func __type_to_str(type:int):
	match type:
		TYPE_NIL:
			return "null"
		TYPE_BOOL:
			return "bool"
		TYPE_INT:
			return "int"
		TYPE_FLOAT:
			return "float"
		TYPE_STRING:
			return "String"
		TYPE_VECTOR2:
			return "Vector2"
		TYPE_VECTOR2I:
			return "Vector2i"
		TYPE_RECT2:
			return "Rect2"
		TYPE_RECT2I:
			return "Rect2i"
		TYPE_VECTOR3:
			return "Vector3"
		TYPE_VECTOR3I:
			return "Vector3i"
		TYPE_TRANSFORM2D:
			return "Transform2D"
		TYPE_VECTOR4:
			return "Vector4"
		TYPE_VECTOR4I:
			return "Vector4i"
		TYPE_PLANE:
			return "Plane"
		TYPE_QUATERNION:
			return "Quaternion"
		TYPE_AABB:
			return "AABB"
		TYPE_BASIS:
			return "Basis"
		TYPE_TRANSFORM3D:
			return "Transform3D"
		TYPE_PROJECTION:
			return "Projection"
		TYPE_COLOR:
			return "Color"
		TYPE_STRING_NAME:
			return "StringName"
		TYPE_NODE_PATH:
			return "NodePath"
		TYPE_RID:
			return "RID"
		TYPE_OBJECT:
			return "Object"
		TYPE_CALLABLE:
			return "Callable"
		TYPE_SIGNAL:
			return "Signal"
		TYPE_DICTIONARY:
			return "Dictionary"
		TYPE_ARRAY:
			return "Array"
		TYPE_PACKED_BYTE_ARRAY:
			return "PackedByteArray"
		TYPE_PACKED_INT32_ARRAY:
			return "PackedInt32Array"
		TYPE_PACKED_INT64_ARRAY:
			return "PackedInt64Array"
		TYPE_PACKED_FLOAT32_ARRAY:
			return "PackedFloat32Array"
		TYPE_PACKED_FLOAT64_ARRAY:
			return "PackedFloat64Array"
		TYPE_PACKED_STRING_ARRAY:
			return "PackedStringArray"
		TYPE_PACKED_VECTOR2_ARRAY:
			return "PackedVector2Array"
		TYPE_PACKED_VECTOR3_ARRAY:
			return "PackedVector3Array"
		TYPE_PACKED_COLOR_ARRAY:
			return "PackedColorArray"
		TYPE_MAX:
			return "Represents the size of the Variant.Type enum"
	return "typeof(%s) " % type
