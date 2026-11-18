module imports.a21a; @system:

import core.stdc.stdio;
import a21;

template GoodMixin()
{
    int goodFunc()
    {
	printf("goodFunc\n");
	return 1;
    }
}


class SomeClass
{
    mixin GoodMixin;
    mixin BadMixin;
}
