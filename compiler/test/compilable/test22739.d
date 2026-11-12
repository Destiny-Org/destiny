// upstream issue 22739

extern(C++) auto f(T)()
{
    return T.init;
}
void main()
{
    f!int;
}
