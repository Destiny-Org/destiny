// DFLAGS:
// REQUIRED_ARGS: -defaultlib=
// EXTRA_SOURCES: extra-files/minimal/object.d

/**********************************************/
// upstream issue 19234
void issue19234()
{
    static struct A {}
    A[10] a;
    A[10] b;
    b[] = a[];
}

/**********************************************/
// upstream issue 22005
void issue22005()
{
    enum int[4] foo = [1,2,3,4];
    static foreach (i, e; foo)
    {
    }
}

/**********************************************/
// upstream issue 22006
void issue22006()
{
    alias size_t = typeof(int.sizeof);
    alias AliasSeq(T...) = T;

    foreach (size_t i, e; [0, 1, 2, 3]) { }
    static foreach (size_t i, e; [0, 1, 2, 3]) { }
    foreach (size_t i, e; AliasSeq!(0, 1, 2, 3)) { }
    static foreach (size_t i, e; AliasSeq!(0, 1, 2, 3)) { }
}
