/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fix22108.d(12): Error: returning scope variable `p` is not allowed in a `@safe` function
---
*/

// upstream issue 22108

@safe ref int test(return ref scope int* p)
{
    return *p;
}
