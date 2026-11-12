// upstream issue 19491

class Foo
{
    shared this();
}

void test()
{
    scope foo = new shared Foo();
}
