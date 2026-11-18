// REQUIRED_ARGS: -preview=fieldwise -O
// upstream issue 21821

// test case comes from unittests in core.lifetime

@system: void test()
{
    alias T = immutable(S);
    T source;
    T target;
    copyEmplacex(source, target);
    T expectedCopy = source;
    assert(target == expectedCopy);
}

struct S
{
    int x = 42;
    this(this) { x += 10; }
}

void copyEmplacex(ref immutable(S) source, ref immutable(S) target) @system
{
        import core.stdc.string : memcpy;
        memcpy(cast(S*) &target, cast(S*) &source, S.sizeof);
	(cast() target).__xpostblit(); // casting away immutable
}

void main()
{
    test();
}
