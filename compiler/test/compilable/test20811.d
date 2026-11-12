// Constructor flow analysis doesn't understand noreturn
// upstream dmd issue 20811

struct MustInit
{
    int n;
    @disable this();
    this(int n)
    {
        this.n = n;
    }
}

struct S
{
    MustInit member;
    this(bool b, int n, int m)
    {
        if (b == true)
        {
            member = MustInit(n);
            return;
        }
        if (b == false)
        {
            member = MustInit(m);
            return;
        }
        assert(0); // unreachable
    }

    this(bool b) { throw new Exception("oops"); }

    noreturn abort();
    this(bool b, int n) { abort(); }
}
