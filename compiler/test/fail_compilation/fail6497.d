/*
TEST_OUTPUT:
---
fail_compilation/fail6497.d(25): Error: assigning address of variable `result` to `ptr` with longer lifetime is not allowed in a `@safe` function
---
*/

void main() @safe
{
    int n;
    auto b = &(0 ? n : n);
}

void f() @safe
{
    ref i = *new int;
    auto b = &i;
}

const(int)* ptr;

int g() @safe
out (i)
{
    ptr = &i;
}
do { return 0; }
