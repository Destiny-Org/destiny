/* REQUIRED_ARGS:
   TEST_OUTPUT:
---
fail_compilation/test16228.d(23): Error: function `test16228.S.bar` `static` member has no `this` to which `return` can apply
---
*/




// upstream issue 16228

int* wrap ( return ref int input )
{
    return &input;
}

struct S
{
    int x;

    int foo() return { return 3; }
    static ref int bar() return { return x; }
}


// upstream issue 18963

T Identity(T)(return T t) { return t; }

void bar(int i, void* p)
{
    Identity(p);
    Identity(i);
}
