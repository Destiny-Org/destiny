// upstream issue 22638

@system: struct S
{
    this(ref const(S));
    ~this();
}

extern(C++) void set(const S s);

void disp()
{
    S p;
    return set(p);
}
