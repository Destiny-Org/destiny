/*
Destiny: functions are @safe by default; the first error in such a function
explains what to do. Explicit @safe functions get no hint.
TEST_OUTPUT:
---
fail_compilation/destiny_safe_default_hint.d(18): Error: pointer arithmetic is not allowed in a `@safe` function
fail_compilation/destiny_safe_default_hint.d(16):        `destiny_safe_default_hint.byDefault` is `@safe` by default. If it must do this, mark it `@system`, or move the unsafe part into a small `@trusted` function with a safe interface
fail_compilation/destiny_safe_default_hint.d(19): Error: pointer arithmetic is not allowed in a `@safe` function
fail_compilation/destiny_safe_default_hint.d(24): Error: pointer arithmetic is not allowed in a `@safe` function
fail_compilation/destiny_safe_default_hint.d(31): Error: `@safe` function `destiny_safe_default_hint.callsC` cannot call `@system` function `destiny_safe_default_hint.cfunc`
fail_compilation/destiny_safe_default_hint.d(27):        `destiny_safe_default_hint.cfunc` is declared here
fail_compilation/destiny_safe_default_hint.d(29):        `destiny_safe_default_hint.callsC` is `@safe` by default. If it must do this, mark it `@system`, or move the unsafe part into a small `@trusted` function with a safe interface
---
*/

void byDefault(int* p)
{
    p++;            // error + hint
    p += 2;         // error, no second hint
}

void explicitSafe(int* p) @safe
{
    p++;            // error, no hint (the user asked for @safe)
}

extern(C) void cfunc(int* p);   // body-less extern(C): @system

void callsC(int* p)
{
    cfunc(p);       // error + hint
}

@system void fine(int* p) { p++; }   // marked @system: no error
