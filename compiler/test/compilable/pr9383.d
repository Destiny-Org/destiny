// REQUIRED_ARGS: -preview=dip1000
// upstream dmd pull request 9383

void test() @safe
{
    int[1] a = [1];
    cartesianProduct(a[]);
}

auto cartesianProduct(RR...)(RR ranges)
{
    static struct Result
    {
        RR current;

        void popFront() scope @safe
        {
            foreach (ref r; current)
            {
            }
        }
    }

    return Result(ranges);
}
