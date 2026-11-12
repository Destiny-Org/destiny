/* TEST_OUTPUT:
---
fail_compilation/test22344.c(103): Error: function `test22344.func` redeclaration with different type
fail_compilation/test22344.c(203): Error: function `test22344.test` redeclaration with different type
fail_compilation/test22344.c(301): Error: function `test22344.foo` redeclaration with different type
---
 */

// upstream issue 22344

#line 100

int func(double a);

int func(int b)
{
    return 0;
}

// upstream issue 22761

#line 200

int test(int x);

int test(int x, ...)
{
    return x;
}

#line 300

int foo();
double foo();
