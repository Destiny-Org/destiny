// REQUIRED_ARGS: -o-
// PERMUTE_ARGS:

@system: T foo(T)()
{
    __gshared int[] bar = [];
    return T.init;
}

void main()
{
    foo!char();
}
