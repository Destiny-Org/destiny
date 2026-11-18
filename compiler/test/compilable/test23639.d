// upstream issue 23639

// REQUIRED_ARGS: -preview=nosharedaccess

@system: class T {}

shared(T) allocClassMem()
{
    void *p;
    // assume p is allocated here
    return cast(shared(T))p;
}
