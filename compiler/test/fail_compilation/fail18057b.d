/**
TEST_OUTPUT:
---
fail_compilation/fail18057b.d(12): Error: variable `fail18057b.Recursive.field` recursive initialization of field
---
*/

// upstream issue 18057
// Recursive field initializer causes segfault.
struct Recursive
{
    int field = Recursive();
}
