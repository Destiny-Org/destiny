// REQUIRED_ARGS: -O -inline
//
// upstream issue 20893
// caused by upstream dmd pull request 9722

int f(int n)
{
    foreach (i; 0..n) {}
    return 10;
}

int c(int a, int b)
{
    return (f(a) * 1L * f(b)) % 1000;
}

void main()
{
    int[] a = [1];
    assert(c(2 - 1, 2) == 100);
}
