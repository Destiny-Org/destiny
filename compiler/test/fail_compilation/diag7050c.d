/*
TEST_OUTPUT:
---
fail_compilation/diag7050c.d(24): Error: `@safe` function `diag7050c.f` cannot call `@system` destructor `diag7050c.B.~this`
fail_compilation/diag7050c.d(17):        `diag7050c.B.~this` is declared here
fail_compilation/diag7050c.d(17):        generated `B.~this` is @system because of the following field's destructors:
fail_compilation/diag7050c.d(19):         - A a
fail_compilation/diag7050c.d(14):           @system `A.~this` is declared here
---
*/

struct A
{
    ~this() @system {}
}

@safe struct B
{
    A a;
}

@safe void f()
{
    auto x = B.init;
}
