// upstream issue 19954

@system: template AliasSeq(TList...)
{
    alias AliasSeq = TList;
}

void fun(string[]){}

void main()
{
    fun(cast(string[])AliasSeq!"");
    auto a = cast(char[][])"";
}
