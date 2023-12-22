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
var NOT:
	get:
		__flag_not_notted = false
		return self
var strictly = self:
	get:
		__flag_strict = true
		return self

func be(other, description = null):
	__flag_strict = true
	return equal(other, description)	

func equal(other, description = null):
	var eqTypeStr = "STRICTLY" if __flag_strict else "loosely"
	return test.__assert(
		__to_notted(
			LambdaOperations.equals_strict(value,other) if __flag_strict else LambdaOperations.equals(value,other)
		),
		description,
		&"Expected %s(%s) to %s equal in %s(%s)" % [value,__type_to_str(typeof(value)),eqTypeStr,other,__type_to_str(typeof(other))]
	)
"""
/////////////////////////////
// INTERNAL STUFF //
/////////////////////////////
"""
var __flag_strict = false
var __flag_not_notted = true
func __to_notted(r:bool):
	return r if __flag_not_notted else !r
	
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
