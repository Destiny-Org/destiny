// upstream issue 23816

/*
TEST_OUTPUT:
---
fail_compilation/fail23816.d(14): Error: opcode expected, not `NOP`
---
*/

@system: void main()
{
    asm
    {
        NOP;
    }
}
