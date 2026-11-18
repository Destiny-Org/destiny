/*
Destiny: scope (DIP1000) checking is on without any flags.
TEST_OUTPUT:
---
fail_compilation/destiny_dip1000_default.d(15): Error: scope parameter `p` may not be returned
fail_compilation/destiny_dip1000_default.d(15):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/destiny_dip1000_default.d(21): Error: returning `& x` escapes a reference to local variable `x`
fail_compilation/destiny_dip1000_default.d(28): Error: assigning scope variable `p` to global variable `global` is not allowed in a `@safe` function
fail_compilation/destiny_dip1000_default.d(28):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
---
*/

int* escapeParam(scope int* p) @safe
{
    return p;          // scope parameter may not be returned
}

int* escapeLocal() @safe
{
    int x;
    return &x;         // address of a local may not escape
}

int* global;

void storeScope(scope int* p) @safe
{
    global = p;        // scope value may not be stored in a global
}
