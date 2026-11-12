/*
DISABLED: osx
REQUIRED_ARGS: -vasm
TEST_OUTPUT:
---
_D9test223814maskFPtZv:
0000:   $r:[0-9A-F ]*$and       word ptr [$r:[A-Z]*$],0FFFEh
0005:   C3                       ret
---
*/

// upstream dmd issue 22381

void mask(ushort* p)
{
    *p &= 0xfffe;
}
