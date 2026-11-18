/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/diag23295.d(23): Error: assigning scope variable `x` to non-scope parameter `y` calling `foo` is not allowed in a `@safe` function
fail_compilation/diag23295.d(34):        `y` is assigned to non-scope parameter `z`
fail_compilation/diag23295.d(36):        `z` is not `scope` because of `f = & z`
fail_compilation/diag23295.d(23):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/diag23295.d(26): Error: assigning scope variable `ex` to non-scope parameter `e` calling `thro` is not allowed in a `@safe` function
fail_compilation/diag23295.d(41):        `e` is not `scope` because of `throw e`
fail_compilation/diag23295.d(26):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// explain why scope inference failed
// upstream issue 23295

@safe:

void main()
{
    scope int* x;
    foo(x, null);

    scope Exception ex;
    thro(ex);
}

auto foo(int* y, int** w)
{
    fooImpl(y, null);
}

auto fooImpl(int* z, int** w)
{
    auto f = &z;
}

auto thro(Exception e)
{
    throw e;
}
