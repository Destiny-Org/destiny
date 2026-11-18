// upstream issue 17635

@system: alias T = immutable int;

T** f(const T** input) pure
{
    T** output;
    return output;
}

void main()
{
    T i;
    T* p = &i;
    immutable T** r = f(&p);
}
