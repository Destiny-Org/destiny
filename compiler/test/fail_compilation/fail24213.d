/+
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fail24213.d(17): Error: assigning reference to local variable `n` to non-scope parameter `p` is not allowed in a `@safe` function
fail_compilation/fail24213.d(17):        fix: mark the parameter `scope` if it is not kept, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
+/
alias Dg = void delegate(int* p) @safe pure nothrow;

void main() @safe
{
    int* escaped;

    int n;
    Dg dg = delegate void (int* p) { escaped = p; };
    dg(&n);
}
