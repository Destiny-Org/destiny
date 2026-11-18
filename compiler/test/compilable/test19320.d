// upstream issue 19320

// REQUIRED_ARGS: -O -cov

@system: auto staticArray(U, T)(T)
{
    U[] theArray = void;
    return theArray;
}


void main()
{
    staticArray!(int, int)(3);
}
