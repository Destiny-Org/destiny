/+
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fail24208.d(20): Error: assigning reference to local variable `n` to non-scope parameter `p` calling `escape` is not allowed in a `@safe` function
fail_compilation/fail24208.d(16):        `p` is not `scope` because of `escaped = p`
fail_compilation/fail24208.d(20):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
+/
void test() @safe
{
    int* escaped;

    void escape(int* p) @safe
    {
        escaped = p;
    }

    int n;
    escape(&n);
}
