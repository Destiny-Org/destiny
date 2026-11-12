
static if (__traits(compiles, __vector(int[4])))
{
    alias int4 = __vector(int[4]);

    int fn(const int[4] x)
    {
        int sum = 0;
        foreach (i; x) sum += i;
        return sum;
    }

    // upstream issue 19223
    void test19223()
    {
        int4 v1 = int4.init;
        assert(fn(v1.array) == 0);
        assert(fn(int4.init.array) == 0);
    }

    // upstream issue 19607
    void test19607()
    {
        int4 v1 = 1;
        assert(fn(v1.array) == 4);
        assert(fn(int4(2).array) == 8);
    }

    void main ()
    {
        test19223();
        test19607();
    }
}
else
{
    void main() { }
}
