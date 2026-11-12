/***********************************************/

/*
TEST_OUTPUT:
---
fail_compilation/test12979.d(304): Error: `const`/`immutable`/`shared`/`inout` attributes are not allowed on `asm` blocks
---
*/

// upstream issue 12979

#line 300

void test3()
{
    asm const shared
    {
        ret;
    }
}
