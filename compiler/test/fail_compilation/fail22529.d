// upstream issue 22529

/*
TEST_OUTPUT:
---
fail_compilation/fail22529.d(13): Error: found `return` when expecting `;` following expression
---
*/

void main()
{
    foo()
    return;
}
