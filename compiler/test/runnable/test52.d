/*
PERMUTE_ARGS:
RUN_OUTPUT:
---
count = 3
---
*/

// upstream issue 2311

@system: extern(C) int printf(const char*, ...);

__gshared ulong count;

shared static ~this()
{
    printf("count = %llu\n", count);
    assert(count == 3);
}

template X(uint idx)
{
    static ~this()
    {
        assert(count == idx);
        ++count;
    }
}

void main()
{
    // Instantiate module destructors in reverse order
    alias x = X!(2);
    alias y = X!(1);
    alias z = X!(0);
}
