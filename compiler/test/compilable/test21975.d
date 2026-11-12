// upstream issue 21975

struct Outer(T)
{
    Inner!T inner;
    alias inner this;
}

struct Inner(T)
{
    T t;
}

static assert(is(Outer!int : Inner!int)); // ok
static assert(is(Outer!int : Inner!T, T)); // needs to compile
