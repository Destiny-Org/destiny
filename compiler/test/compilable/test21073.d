// upstream issue 21073

@system: class C
{
    auto internal() const
    {
        return 5;
    }
    alias internal this;
}

void main() pure
{
    const c = new C;
    auto r = cast(C)c;
}
