/*
REQUIRED_ARGS: -m32
TEST_OUTPUT:
---
fail_compilation/failasm.d(111): Error: use -m64 to compile 64 bit instructions
---
*/

@system: #line 100

// upstream issue 21181

uint func()
{
    asm
    {
        naked;
        inc byte ptr [EAX];
        inc short ptr [EAX];
        inc int ptr [EAX];
        inc long ptr [EAX];
    }
}
