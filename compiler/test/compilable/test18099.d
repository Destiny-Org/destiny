
/* REQUIRED_ARGS: -betterC
 */

// upstream issue 18099

struct D
{
    static struct V
    {
        ~this() { }
    }

    V get()
    {
        V v;
        return v;
    }
}
