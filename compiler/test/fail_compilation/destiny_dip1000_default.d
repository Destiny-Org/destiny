/*
Destiny: scope (DIP1000) checking is on without any flags.
TEST_OUTPUT:
---
fail_compilation/destiny_dip1000_default.d(13): Error: scope parameter `p` may not be returned
fail_compilation/destiny_dip1000_default.d(19): Error: returning `& x` escapes a reference to local variable `x`
fail_compilation/destiny_dip1000_default.d(26): Error: assigning scope variable `p` to global variable `global` is not allowed in a `@safe` function
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
