/*
TEST_OUTPUT:
---
fail_compilation/diag6717.d(12): Error: end of instruction expected, not `h`
---
*/

@system: void main()
{
    asm
    {
        mov AX, 12h ;
    }
}
