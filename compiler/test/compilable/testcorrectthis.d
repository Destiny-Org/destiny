// upstream issue 10886

struct A
{
    @property int foo() { return 0; }
    int bar() { return 0; }
}

struct B
{
    void bar()
    {
        alias f = typeof(A.foo);  // NG
        alias b = typeof(A.bar);  // ok
    }
}

// upstream issue 21288

struct XA
{
    int p;
}

struct XB
{
    XA a() { return XA.init; }
    alias a this;
}

struct XC
{
    void foo()
    {
        static assert(XB.p.stringof == "p"); // Error: this for s needs to be type B not type C
    }
}
