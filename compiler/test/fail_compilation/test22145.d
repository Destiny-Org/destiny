/* TEST_OUTPUT:
REQUIRED_ARGS:
---
fail_compilation/test22145.d(115): Error: assigning scope variable `x` to global variable `global` is not allowed in a `@safe` function
fail_compilation/test22145.d(115):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
---
 */

// upstream issue 22145

#line 100

struct S
{
    int opApply (scope int delegate (scope int* ptr) @safe dg) @safe
    {
        return 0;
    }
}

void test() @safe
{
    static int* global;
    S s;
    foreach (scope int* x; s)
    {
        global = x;
    }
}
