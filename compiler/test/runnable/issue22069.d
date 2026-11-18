// REQUIRED_ARGS: -O
// upstream dmd issue 22069

@system: int recurse(int* i)
{
  L1:
    int j = 0;
    int* p = &j;

    if (*i)
    {
        return recurse(p);
    }
    else
    {
        if (p is i)
            assert(0);
        else
            return j;
    }
}

void main()
{
    int i = 1;
    recurse(&i);
}
