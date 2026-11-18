// upstream issue 7932

@system: import core.stdc.stdio;

size_t N;

class C
{
    protected void f(size_t n)
    out
    {
        printf("out: this=%p &n=%p n=%zu\n",
                cast(void*) this, &n, n);
        assert (N == n);
    }
    do
    {
        int dummy;
        //printf("\n");
        N = n;
        printf("body: this=%p &dummy=%p &N=%p N=%zu\n",
                cast(void*) this, &dummy, &N, N);
    }
}

void main()
{
    auto x = new C;
    x.f(1);
}
