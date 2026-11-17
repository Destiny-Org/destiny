/*
REQUIRED_ARGS: -betterC
*/

__gshared int numDtor;

struct S
{
    int a;
    ~this() nothrow @nogc @trusted { ++numDtor; }
}

void takeScopeSlice(const scope S[] slice) nothrow @nogc @safe {}

extern(C) int main() nothrow @nogc @safe
{
    takeScopeSlice([ S(1), S(2) ]); // @nogc => no GC allocation
    (() @trusted { assert(numDtor == 2); })(); // stack-allocated array literal properly destructed
    assert23100([]);

    // upstream issue 22306
    // scope array variable should be stack allocated
    scope int[] sa = [10, 20];
    assert(sa[0] == 10);
    assert(sa[1] == 20);
    assert(sa.length == 2);

    return 0;
}

// upstream issue 23098
void f23098(scope inout(int)[] d) @safe {}

void test23098() @safe
{
    f23098([10, 20]);
}

// upstream issue 23100
void assert23100(scope int[] d) @safe nothrow @nogc
{
    assert(!d);
}
