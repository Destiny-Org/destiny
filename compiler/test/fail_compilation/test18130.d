/*
TEST_OUTPUT:
---
fail_compilation/test18130.d(8): Error: variable `test18130.foo.v` zero-length `out` parameters are not allowed.
---
*/
// upstream issue 18130
void foo(out byte[0] v)
{
}
