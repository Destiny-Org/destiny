// Destiny: in a function that is @safe only by default, __traits(compiles)
// ignores safety (like upstream's @system default), so a `static if` compile
// check does not silently pick a different branch. Explicit @safe stays strict.

@system void sysf() {}

void byDefault()
{
    static assert(__traits(compiles, sysf()));
    static assert(__traits(compiles, () { int* p; p++; }()));
}

void explicitSafe() @safe
{
    static assert(!__traits(compiles, sysf()));
}

@system void explicitSystem()
{
    static assert(__traits(compiles, sysf()));
}
