# Simple Test

A very simple unit testing framework. It doesn't have any of the bells and whistles.
Just the ability to run scenes as tests.

_why make this_
Because i found that the ones on the appstore often times don't work when the stars dont align, so i decided to create a new addon
thats minimalistic and makes use of mostly basic features.

*How to use*
1. Import addon
2. Create a new scene that has SimpleTest_Runner node as root
3. Create a new script that extends SimpleTest
4. Write a function that starts with "it", "test" or "should"
5. Use one of the expect functions
6. Attach that script to a node on the scene
7. Run

## Expect Funcs

```
extends SimpleTest

func it_should_pass():
  expect_equal(1, 1)        # equality comparison
  expect_no_orphan_nodes()  # checks that there are no orphan nodes
  expect_orphan_nodes(1)    # checks for a specific number of orphan nodes
```

## Notes

If for some reason, you do decide to use this and need more expect funcs, or have some other request
just open an issue
