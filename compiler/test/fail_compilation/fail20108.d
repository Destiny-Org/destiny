// REQUIRED_ARGS:
/*
TEST_OUTPUT:
---
fail_compilation/fail20108.d(17): Error: assigning address of variable `y` to `x` with longer lifetime is not allowed in a `@safe` function
fail_compilation/fail20108.d(18): Error: scope parameter `x` may not be returned
fail_compilation/fail20108.d(18):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/fail20108.d(25): Error: assigning address of variable `y` to `x` with longer lifetime is not allowed in a `@safe` function
fail_compilation/fail20108.d(26): Error: returning scope variable `x` is not allowed in a `@safe` function
fail_compilation/fail20108.d(26):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
*/

@safe auto test(scope int* x)
{
    int y = 69;
    x = &y; //bad
    return x;
}

@safe auto test2()
{
    scope int* x;
    int y = 69;
    x = &y; //bad
    return x;
}

void main()
{
    auto y = test(null);
    auto z = test2();
}
