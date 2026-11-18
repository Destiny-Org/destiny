/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fix22108.d(13): Error: returning scope variable `p` is not allowed in a `@safe` function
fail_compilation/fix22108.d(13):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
*/

// upstream issue 22108

@safe ref int test(return ref scope int* p)
{
    return *p;
}
