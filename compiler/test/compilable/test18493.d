// upstream issue 18493
// REQUIRED_ARGS: -betterC

struct S
{
    this(this)
    {
    }

    ~this()
    {
    }
}

struct C
{
    S s1;
    S s2;
}
