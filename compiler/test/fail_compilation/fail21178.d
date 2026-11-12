/*
TEST_OUTPUT:
---
fail_compilation/fail21178.d(13): Error: undefined identifier `UnknownType`
---
*/

// upstream issue 21178

interface IFoo
{
    void foo();
    UnknownType bar();
}

abstract class Foo : IFoo
{
    override void foo() {}
}
