// REQUIRED_ARGS: -de
/* TEST_OUTPUT:
---
fail_compilation/b19691e.d(16): Error: forward reference to template `this`
fail_compilation/b19691e.d(16): Error: constructor `b19691e.S2.this(int a, S1 s = "")` is not callable using argument types `(int, string)`
fail_compilation/b19691e.d(16): Error: forward reference to template `this`
---
*/
// upstream issue 19691
module b19691e;

struct S1
{
    this(T)(T)
    {
        S2(42, "");
    }
}

struct S2
{
    this(int a, S1 s = ""){}
}
