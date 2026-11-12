/* REQUIRED_ARGS: -O -inline -release
 */

// upstream issue 23857

int mars(int[] a, int u)
{
    return (a.ptr[u] < 0) ? u : (a.ptr[u] = mars(a, a.ptr[u]));
}

void venus()
{
    mars([], 0);
    mars([], 0);
}
