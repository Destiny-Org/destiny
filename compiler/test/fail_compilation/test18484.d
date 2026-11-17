/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test18484.d(19): Error: returning `x.bar()` escapes a reference to local variable `x`
fail_compilation/test18484.d(24): Error: escaping reference to stack allocated value returned by `S(0)`
---
*/

// upstream issue 18484

struct S
{
    int* bar() @safe return;
    int i;
}

int* test1() @safe
{
    auto x = S(); return x.bar();  // error
}

int* test2() @safe
{
    return S().bar();  // error
}
