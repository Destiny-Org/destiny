// upstream issue 24762

struct S { int m; }

string m() { return "m"; }
@nogc void f()
{
    S s;
    enum t = m();
    auto x = __traits(getMember, s, m()); // Error: `@nogc` function `nogc.f` cannot call non-@nogc function `nogc.m`
}
