/*
DISABLED: osx
REQUIRED_ARGS: -vasm -betterC -checkaction=halt
TEST_OUTPUT:
---
main:
0000:   0F 0B                    ud2
0002:   C3                       ret
---
*/

// Issue 23068 - [betterC] BetterC does not respect -checkaction=halt
// upstream issue 23068

extern(C) void main()
{
    assert(0);
}
