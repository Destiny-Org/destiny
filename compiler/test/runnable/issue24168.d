/*
REQUIRED_ARGS: -fPIE
DISABLED: win32 win64
*/

//upstream issue 24168

int i = 42;

bool foo(ref int a)
{
    return a == 42;
}

ref int bar()
{
    return i;
}

bool baz()
{
    static int i = 42;
    return foo(i);
}

void main()
{
    assert(foo(i));
    assert(bar() == 42);
    assert(baz());
}
