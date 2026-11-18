/*
TEST_OUTPUT:
---
fail_compilation/fail290.d(15): Error: no `this` to create delegate for `foo`
---
*/

@system: struct Foo
{
    void foo(int x) {}
}

void main()
{
    void delegate (int) a = &Foo.foo;
}
