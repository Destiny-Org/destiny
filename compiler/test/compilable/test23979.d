// REQUIRED_ARGS: -o-
// upstream issue 23979
// Issue 23979 - ICE on failed alias this attempt on pointer expression

class A {}

void h()
{
    const auto classPtr = SPtr.init;
    assert(!__traits(compiles, *classPtr));
}

struct SPtr
{
    A ptr() { return A.init; }
    alias ptr this;
}
