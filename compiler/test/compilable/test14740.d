// upstream issue 14740

void test()
{
    struct S
    {
        void fun() {}
    }
    static assert([__traits(allMembers, S)] == ["fun"]);
}
