// REQUIRED_ARGS: -inline

// upstream issue 20420

struct S { ~this(); }

class C
{
    this(S, int) {}
}

int i();

C create()
{
    return new C(S(), i());
}

auto test()
{
    auto c = create();
}
