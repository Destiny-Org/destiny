// upstream dmd issue 21476

struct S21476
{
    string field;
    this(ref return scope S21476);
    this(return scope S21476);
}

void test21476()
{
    auto o = S21476("aoe");
}
