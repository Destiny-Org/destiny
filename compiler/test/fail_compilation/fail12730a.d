/*
TEST_OUTPUT:
---
fail_compilation/fail12730a.d(13): Error: cannot subtract register
---
*/
// upstream issue 12730

@system: void test()
{
    asm
    {
        lea ECX, [EBX - EAX];
    }
}
