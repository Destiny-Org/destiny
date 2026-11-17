// upstream issue 23912
// REQUIRED_ARGS:

struct Test
{
    string val;

    this(return scope string val) scope @safe {}
    ~this() scope @safe {}
}

void giver(scope string input) @safe
{
    accepts(Test(input));
}

void accepts(scope Test test) @safe {}
