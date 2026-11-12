// upstream issue 19954

template AliasSeq(TList...)
{
    alias AliasSeq = TList;
}

void fun(string[]){}

void main()
{
    fun(cast(string[])AliasSeq!"");
    auto a = cast(char[][])"";
}
