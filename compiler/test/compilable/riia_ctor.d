// upstream issue 17494
// REQUIRED_ARGS: -revert=dtorfields
@system: struct S
{
    ~this() {}
}

class C
{
    S s;

    this() nothrow {}
}

// upstream issue 17505
struct Array
{
    int[] _payload;
    ~this()
    {
        import core.stdc.stdlib : free;
        free(_payload.ptr);
    }
}

class Scanner
{
    Array arr;
    this() @safe {}
}

// upstream issue 17506
struct TreeMap
{
    this() @disable;
    this(TTree tree) { this.tree = tree; }
    TTree tree;
}

struct TTree
{
    this() @disable;
    this(int foo) {}
    ~this() {}
}
