// upstream issue 22699

int foo(int x, int y)
{
    for (; x = y;)
        return (x = y) ? x : y;
}
