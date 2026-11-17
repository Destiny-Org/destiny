// upstream issue 20795

// REQUIRED_ARGS:

struct Foo
{
    void opEquals(T)(T rhs) if (T.init.opCast!string) {}
}

struct Bar
{
    void opEquals()(Bar)
    {
        Gun() == Foo();
    }
}

class Baz
{
    void opCast(T)() {}
}

struct Gun
{
    void[24] buff;

    auto underlying()
    {
        return cast(Baz) buff.ptr;
    }

    alias underlying this;

    void opEquals(R)(R) if (Bar.init == R.init) {}
}
