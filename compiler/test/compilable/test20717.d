// upstream issue 20717

/*
TEST_OUTPUT:
---
false
---
*/

pragma(msg, is(typeof({
    struct S
    {
        struct Foo {}
        struct Bar() {}
        alias Bar = Foo;
    }
})));
