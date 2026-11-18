/+
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fail24212.d(30): Error: assigning reference to local variable `n` to non-scope parameter `p` calling `fun` is not allowed in a `@safe` function
fail_compilation/fail24212.d(30):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
+/
class Base
{
    @safe pure nothrow
    void fun(int* p) {}
}

void test() @safe
{
    int* escaped;

    class Escaper : Base
    {
        @safe pure nothrow
        override void fun(int* p)
        {
            escaped = p;
        }
    }

    int n;
    Base base = new Escaper;
    base.fun(&n);
}
