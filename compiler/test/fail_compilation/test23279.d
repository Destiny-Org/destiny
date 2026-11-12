// upstream issue 23279

/*
TEST_OUTPUT:
---
fail_compilation/test23279.d(13): Error: undefined identifier `Sth`
---
*/

class Tester
{
    enum a = __traits(hasMember, Tester, "setIt");
    void setIt(Sth sth){}
}
