// upstream issue 20447
void main()
{
    import core.thread;
    int[] x;
    auto b = x.dup;
}
