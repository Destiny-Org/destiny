/*
TEST_OUTPUT:
---
fail_compilation/fail12730b.d(13): Error: cannot negate register
---
*/
// upstream issue 12730

void test()
{
    asm
    {
        mov ECX,-EAX;
    }
}
