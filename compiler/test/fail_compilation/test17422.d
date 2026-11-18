/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test17422.d(25): Error: returning scope variable `p` is not allowed in a `@safe` function
fail_compilation/test17422.d(24):        `p` inferred `scope` because of `p = rc.get()`
fail_compilation/test17422.d(25):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
*/
struct RC
{
    Object get() return @trusted
    {
        return cast(Object) &store[0];
    }

private:
    ubyte[__traits(classInstanceSize, Object)] store;
}

Object test() @safe
{
    RC rc;
    auto p = rc.get; // p must be inferred as scope variable, works for int*
    return p;
}
