// upstream issue 19491

@system: class Foo
{
    shared this();
}

void test()
{
    scope foo = new shared Foo();
}
