/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test23073.d(29): Error: assigning scope variable `c` to non-scope parameter `c` calling `assignNext` is not allowed in a `@safe` function
fail_compilation/test23073.d(23):        `c` is not `scope` because of `c.next = c`
fail_compilation/test23073.d(29):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// upstream issue 23073
// scope inference from pure doesn't consider self-assignment

@safe:

class C
{
    C next;
}

void assignNext(C c) pure nothrow @nogc
{
    c.next = c;
}

C escape() @nogc
{
    scope C c = new C();
    assignNext(c);
    return c.next;
}

void main()
{
    C dangling = escape();
}
