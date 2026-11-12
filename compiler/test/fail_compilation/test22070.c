/*
TEST_OUTPUT:
---
fail_compilation/test22070.c(10): Error: cannot take address of expression `&""` because it is not an lvalue
---
*/

// upstream issue 22070

char(**s1)[3] = &(&"");
