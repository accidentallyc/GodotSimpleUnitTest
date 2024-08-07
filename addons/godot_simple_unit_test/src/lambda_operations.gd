class_name LambdaOperations

static func gt(a,b):
    if SimpleTest_Utils.is_number(a) and SimpleTest_Utils.is_number(b):
        return a > b
    return false
    
static func gte(a,b):
    if SimpleTest_Utils.is_number(a) and SimpleTest_Utils.is_number(b):
        return a >= b
    return false
    
static func lt(a,b):
    if SimpleTest_Utils.is_number(a) and SimpleTest_Utils.is_number(b):
        return a < b
    return false

static func lte(a,b):
    if SimpleTest_Utils.is_number(a) and SimpleTest_Utils.is_number(b):
        return a <= b
    return false
    
## Does a loosey equality check. If the types are equal
## it does a basic "==" comparison but if the types are not
## equal, it casts both to string and does the comparison. 
static func equals(a,b):
    if typeof(a) == typeof(b):
        return a == b
    else:
        return str(a) == str(b)

## Does a strict equality check that compares type and value
static func equals_strict(a,b):
    var typeA = typeof(a);
    if typeA != typeof(b) :
        return false

    return  is_same(a,b)
    
static func truthy(a):
    return true if a else false
