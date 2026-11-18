module mul9377b; @system:

import core.stdc.stdio;

int j;

int foo()()
{
    printf("foo()\n");
    static int z = 7;
    assert(z != 10);
    return ++z;
}

@system void bar()
{
    assert(j == 7);
    foo();
    printf("bar\n");
}

template def()
{
    alias int defint;

    static this()
    {
        printf("def.static this()\n");
        j = 7;
    }

    //void mem(int){}
    void mem()
    {
        printf("def().mem()\n");
    }
}

def!().defint x;
