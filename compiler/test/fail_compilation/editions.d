/**
Test language editions (currently experimental)

TEST_OUTPUT:
---
fail_compilation/editions.d(16): Error: scope parameter `x` may not be returned
fail_compilation/editions.d(16):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
---
*/
@__edition_latest_do_not_use
module editions;

@safe:
int* f(scope int* x)
{
    return x;
}
