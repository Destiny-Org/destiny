// upstream issue 23587
// REQUIRED_ARGS: -w
noreturn stuff()
{
    assert(false);
}

void doStuff(alias fun)()
{
    cast(void) fun();
    string s = "never executed";
    static assert(is(typeof(cast(void) fun()) == void));
}

void main()
{
    doStuff!stuff();
}
