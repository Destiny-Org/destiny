/* Destiny: what -preview=safer checked is now the default (@safe).
TEST_OUTPUT:
---
fail_compilation/safer.d(11): Error: `void` initializing a pointer is not allowed in a `@safe` function
fail_compilation/safer.d(9):        `safer.test1` is `@safe` by default. If it must do this, mark it `@system`, or move the unsafe part into a small `@trusted` function with a safe interface
---
*/

void test1()
{
    int* p = void;
}

void foo3() { }

void test2()
{
    foo3(); // should not be an error
}
