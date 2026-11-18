/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test23982.d(36): Error: assigning scope variable `a` to non-scope parameter `a` calling `foo2` is not allowed in a `@safe` function
fail_compilation/test23982.d(27):        `a` is not `scope` because of `b = a`
fail_compilation/test23982.d(36):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/
// upstream issue 23982
// Issue 23982 - segfault when printing scope inference failure
@safe:

struct B()
{
    this(int* a)
    {
        this.a = a;
    }
    int* a;
}

class C()
{
    int* foo2(int* a)
    {
        auto b = B!()(a);
     	return b.a;
    }
}

void main()
{
    scope int* a;
    C!() c;
    c.foo2(a);
}
