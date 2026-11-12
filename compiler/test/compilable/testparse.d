// PERMUTE_ARGS:
// REQUIRED_ARGS: -o-

/***************************************************/
// upstream issue 6719

static assert(__traits(compiles, mixin("(const(A))[0..0]")) == false);

/***************************************************/
// upstream issue 9232

struct Foo9232
{
    void bar(T)() {}
    void baz() {}
}

void test9232()
{
    Foo9232 foo;
    (foo).bar!int();   // OK <- Error: found '!' when expecting ';' following statement
    ((foo)).bar!int(); // OK
    foo.bar!int();     // OK
    (foo).baz();       // OK
}

/***************************************************/
// upstream issue 9401

struct S9401a
{
    ~this() nothrow pure @safe { }
}

struct S9401b
{
    @safe ~this() pure nothrow { }
}

void test9401() nothrow pure @safe
{
    S9401a s1;
    S9401b s2;
}

/***************************************************/
// upstream issue 9649

class Outer9649
{
    class Inner
    {
    }
}

void test9649()
{
    Outer9649 outer9649;
    (outer9649).new Inner();
}

/***************************************************/
// upstream issue 9679

void test9679(inout int = 0)
{
    if (        auto n = 1) { static assert(is(typeof(n) ==              int)); }
    if (       const n = 1) { static assert(is(typeof(n) ==        const int)); }
    if (   immutable n = 1) { static assert(is(typeof(n) ==    immutable int)); }
    if (shared       n = 1) { static assert(is(typeof(n) == shared       int)); }
    if (shared const n = 1) { static assert(is(typeof(n) == shared const int)); }
    if (       inout n = 1) { static assert(is(typeof(n) ==        inout int)); }
    if (shared inout n = 1) { static assert(is(typeof(n) == shared inout int)); }

    if (       const int n = 1) { static assert(is(typeof(n) ==        const int)); }
    if (   immutable int n = 1) { static assert(is(typeof(n) ==    immutable int)); }
    if (shared       int n = 1) { static assert(is(typeof(n) == shared       int)); }
    if (shared const int n = 1) { static assert(is(typeof(n) == shared const int)); }
    if (       inout int n = 1) { static assert(is(typeof(n) ==        inout int)); }
    if (shared inout int n = 1) { static assert(is(typeof(n) == shared inout int)); }

    if (       const(int) n = 1) { static assert(is(typeof(n) ==        const int)); }
    if (   immutable(int) n = 1) { static assert(is(typeof(n) ==    immutable int)); }
    if (shared      (int) n = 1) { static assert(is(typeof(n) == shared       int)); }
    if (shared const(int) n = 1) { static assert(is(typeof(n) == shared const int)); }
    if (       inout(int) n = 1) { static assert(is(typeof(n) ==        inout int)); }
    if (shared inout(int) n = 1) { static assert(is(typeof(n) == shared inout int)); }

    if (immutable(int)[] n = [1]) { static assert(is(typeof(n) == immutable(int)[])); }
}

/***************************************************/
// upstream issue 9901

template isGood9901(T)
{
    enum isGood9901 = true;
}
void test9901()
{
    string foo(R)(R data) if (isGood9901!R)
    {
        return "";
    }
    foo(1);
}

/***************************************************/
// upstream issue 10199

void test10199()
{
    goto label;
label:
}

/***************************************************/
// upstream issue 12460

void f12460(T)()
{
    static if (is(T == int))
    {
        goto end;
    }
end:
}

void test12460()
{
    f12460!int();
}

/***************************************************/
// upstream issue 11689

void test11689()
{
    deprecated void foo() {}
}

/***************************************************/
// upstream issue 11751

static assert(is(float == typeof(0x0.1p1F)));

/***************************************************/
// upstream issue 11957

extern(C++) class C11957
{
    void x() {}
}

void test11957()
{
    extern(C++) class D : C11957
    {
        override void x() {}
    }
}

/***************************************************/
// upstream issue 13049

enum mangle13049(T) = T.mangleof;
alias FP13049 = void function(scope int);                                       // OK
static assert(mangle13049!FP13049 == mangle13049!(void function(scope int)));   // OK <- NG

/***************************************************/
// was not covered until the **12th of March 2019**
void testIfConditionWithSTCandType()
{
    auto call(){return 0;}
    if (const size_t i = call()) {}
}

/***************************************************/
// upstream issue 20791
extern(C++, "foo", )
struct S {}

/***************************************************/
// upstream issue 22019
void test22019()
{
    final switch (1)
    {
        case 1,:
        case 2,3,:
            break;
    }
}

/***************************************************/
// upstream issue 23205

void test23205()
{
    mixin template tpl() { int x; }
    mixin tpl!();
    x = 123;
}
