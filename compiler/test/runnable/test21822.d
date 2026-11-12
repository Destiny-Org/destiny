// upstream issue 21822

bool testAliasedString()
{
    auto a = soundexer();
    auto b = soundexer();
    return a == b;
}

char[4] soundexer()
{
    return "M365";
}

void main()
{
    assert(testAliasedString());
}
