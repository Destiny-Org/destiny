/*
upstream issue 15399
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test17977.d(19): Error: assigning address of variable `__slList$n$` to `elem` with longer lifetime is not allowed in a `@safe` function
---
*/

@safe:
struct List {
    int* data;
    ~this();
    int* front() return;
}

void test()
{
    auto elem = List().front;
}
