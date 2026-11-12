/* TEST_OUTPUT:
---
fail_compilation/ctfeblock.d(112): Error: cannot `goto` into `if (__ctfe)` block
---
*/

/*******************************************/
// upstream issue 18472
// upstream dmd pull request 14676

#line 100

struct T { }

@nogc void test1()
{
    int a;
    if (__ctfe)
    {
L1:
        new T();
        a = 3;
    }
    goto L1;
}

@nogc void test2()
{
    if (__ctfe)
    {
        new T();
    }
}

@nogc void test3()
{
    if (!__ctfe)
    {
    }
    else
    {
        int* p = new int;
    }
}
