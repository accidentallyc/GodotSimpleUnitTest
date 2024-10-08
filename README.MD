# Godot Simple Test

A very simple unit testing framework. 

It *doesn't* have any of the bells and whistles. Just the ability to run scenes as tests.

![Sample Test Screenshot](./addons/godot_simple_unit_test/docs/sample-test.png)

![Sample Setup Screenshot](./addons/godot_simple_unit_test/docs/sample-setup.png)

**why make this?**

I didn't want a very editor heavy plugin. I wanted something lightweight, simple and easy to just vomit. If you need a fully fleshed out 
Unit Testing Framework, try [GUT](https://github.com/bitwes/Gut) or [GdUnit4](https://github.com/MikeSchulze/gdUnit4)

I also wanted to unit tests that are not run on the editor. That way I can
set up the test scene the same way I would do on an actual scene.

## _Note_
Conflicting classes when upgrading?
- I've renamed the root plugin from `godot_simple_test` to `godot_simple_unit_test`
- So just delete the `addons/godot_simple_test` version

## Setup
1. Import addon from asset store or download as zip then unpack at `addons/godot_simple_unit_test`
1. Activate plugin via `Project > Project Settings > Plugins > SimpleUnitTest - [] Enable`
1. **Create a new scene** that has `SimpleTest_Runner` node as root
1. **Create a new script** that extends `SimpleTest`
1. **Attach this new script** as a child node of the root (see screenshot above)
    * You can rename this node to be whatever you want
1. Write the test (see Writing a test below)
1. Run Scene

Or watch this https://youtu.be/BcvDKTDBqQ0

##  Writing A Test

- Tests must `extends SimpleTest` for it to be recognized
- Every function that starts with either `it` , `should` , or `test` will become a test case.

**Sample Test**
```gdscript
extends SimpleTest

func it_has_equality_tests():
  expect(true).to.equal(true)
  expect(true).to.NOT.equal(false)

  expect([1,2,3]).to.equal([1,2,3])
  expect([1,2,3]).to.NOT.strictly.equal([1,2,3])
  expect(1).equal(1, "Custom message at the end of every expect")
```


### Expect Functions
---------------------------------

We mostly do things the fluent way. The following keywords can be chained after
an `expect` statement.

| Chainable Keyword  | What |
| ------------- | -------------
| `a`  | Sugar only. Does nothing.
| `an`  | Sugar only. Does nothing.
| `to`  | Sugar only. Does nothing.
| `have`  | Sugar only. Does nothing.
| `been`  | Sugar only. Does nothing.
| `be`  | Sugar only. Does nothing.
| `IS`  | Sugar only. Does nothing.
| `are`  | Sugar only. Does nothing.
| `will`  | Sugar only. Does nothing.
| `NOT` | Inverts the results. Must be capitilized.
| `strictly`| Equality checks are replaced with `is_same()`

Note: All the functions below accept an optional message.

| Function Keyword  | What |
| ------------- | -------------
| `equal(Variant)` | Loosely compares the 2 values using `==`
| `gt(number)` | Performs "greater than"
| `gte(number)` | Performs "greater than or equals"
| `lt(number)` | Performs "lesser than"
| `lte(number)` | Performs "lesser than or equals"
| `truthy()` | Checks for truthiness using a ternary operator
| `falsey()` | Checks for falsiness using a ternary operator
| `value_in(Array or Dictionary or String)` | Checks values for item
| `key_in(Array or Dictionary)` | Checks keys/indexes for item
| `size(number)` | Checks the size of an array, dictionary or string
| `size_gt(number)` | Same as size but performs "greater than"
| `size_gte(number)` | Same as size but performs "greater than or equals"
| `size_lt(number)` | Same as size but performs "lesser than"
| `size_lte(number)` | Same as size but performs "lesser than or equals"
| `called()` | Checks if a `stub` has been called atleast once
| `called_n_times(int)` | Checks if a `stub` has been called exactly `n` times

### Asynchronous Tests

| Function Keyword  | What |
| ------------- | -------------
| `wait(time in secs)` | Waits for time in secs. Internally uses `create_timer`
| `wait_until(callable)` | Waits until the callable returns true

Example:

```gdscript
class Test_Class:
  extends Node
	
  var counter = 0
	
  func _process(delta):
    counter += 1

func it_is_async():
  var n = Test_Class.new()
  add_child(n)
	
  await wait(0.25)
  await wait_until( func (): return n.counter >= 250)

  pass
```


### Hooks

You can override these functions

| Func  | What |
| ------------- | -------------
| `_before():`  | Called once before any of the tests in the suite are begun
| `_before_each():`  | Called before each test
| `_after_each():`  | Called after each test
| `_after():`  | Called after all of the tests in the suite are done


### Test Utility Methods
---------------------------------

#### `expect(Variant)`

Pass down any value to perform assertions against.

#### `test_name(String)`

Rename the test to aynthing. By default the test name is the func name but cleaned

#### `stub()`

Creates a stub handler. You can call `stub().callable` to get the actual stub to pass around.

You can test stubs like this

```gdscript
func test_stub():
  var handler = stub()
  var cb = handler.callable

  cb() # Call function

  expect(handler).to.have.been.called()
```

### Additonal Test Controls

Inspired by the way GdUnit skips test, I've opted to follow a similar pattern for test controls.
#### `_skip`


Adding `_skip` to the parameter will skip that specific test case for that test suite.

```gdscript
func it_will_be_skipped(_skip):
  pass
```

#### `_skip_suite`

Adding `_skip_suite` to _any_ test case will cause the whole suite to be skipped. It will ignore all other test controls in the test case.

```gdscript
func it_will_skip_everything here(_skip_suite):
  pass

func it_will_skip_this_too():
  pass
```

#### `_solo`

Adding `_solo` to the parameter will skip all other non-solo tests in that suite.

```gdscript
func it_will_skip_others(_solo):
  pass
```

#### `_solo_suite`

Adding `_solo_suite` to _any_ test case will cause the whole suite to be run solo (ignoring all other non-solo suites).

```
func test_a(_solo, _solo_suite):
  pass 

func test_b(_solo): 
  pass

func test_c(): #will not run because no _solo_
  pass
```
## Notes

If for some reason, you do decide to use this and need more expect funcs, just open an issue.