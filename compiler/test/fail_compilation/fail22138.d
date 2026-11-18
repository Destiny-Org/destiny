/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fail22138.d(107): Error: returning scope variable `e` is not allowed in a `@safe` function
fail_compilation/fail22138.d(107):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
 */

// upstream issue 22138

#line 100

@safe
int* test()
{
    int*[] a;
    foreach (scope e; a)
    {
        return e;
    }
    return null;
}
