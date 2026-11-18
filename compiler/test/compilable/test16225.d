// REQUIRED_ARGS: -O -m64
// PERMUTE_ARGS:

// upstream issue 16225

@system: struct C
{
    hash_t foo( )
    {
        int y;
        return ((cast(ubyte*)&y)[1]);
    }
}
