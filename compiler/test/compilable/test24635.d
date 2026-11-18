// upstream issue 24635

@system: struct S
{
    int opApply(int delegate(int) dg, int x = 0) => dg(x);
}

void main()
{
    foreach (int x; S()) { }
    foreach (x; S()) { }
}
