/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test22227.d(14): Error: returning scope variable `foo` is not allowed in a `@safe` function
fail_compilation/test22227.d(14):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test22227.d(16): Error: returning scope variable `foo` is not allowed in a `@safe` function
fail_compilation/test22227.d(16):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
*/

int[] foo() @safe
{
    if (scope foo = [1])
        return foo;
    while (scope foo = [1])
        return foo;
    return [];
}
