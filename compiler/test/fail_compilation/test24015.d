/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/test24015.d(20): Error: assigning scope variable `v` to non-scope parameter `...` calling `jer` is not allowed in a `@safe` function
fail_compilation/test24015.d(20):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// upstream issue 24105

@safe:

extern (C) void ben(int i, scope ...);

extern (C) void jer(int i, ...);

void bar(scope const char* v)
{
    ben(3, v);
    jer(3, v);
}
