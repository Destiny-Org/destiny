// upstream issue 22214

struct S
{
    struct T
    {
    }
}

void main() {
    const S s;
    static if (__traits(compiles, { auto t = s.T; }))
    {
        auto t = s.T;
    }
}
