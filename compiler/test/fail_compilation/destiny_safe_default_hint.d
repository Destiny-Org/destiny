/*
Destiny: functions are @safe by default; the first error in such a function
explains what to do. Explicit @safe functions get no hint.
TEST_OUTPUT:
---
PLACEHOLDER
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
