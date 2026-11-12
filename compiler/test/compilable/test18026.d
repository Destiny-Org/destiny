// upstream issue 18026
bool f(T)(T x)
{
    return false;
}

static foreach(i; 0..60000)
{
    static if(f(i))
    {
    }
}
