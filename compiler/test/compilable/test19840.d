// upstream issue 19840
@system: struct G
{
    ubyte[] I;
    alias I this;
}

auto M(ubyte[])
{
    G N;
    return N;
}

struct U { int V; }

void X()
{
    func((cast(U[])[].M));
}

void func(U[]) {}
