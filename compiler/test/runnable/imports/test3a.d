module imports.test3a; @system:

import imports.test3b;

extern(C) int printf(const char*, ...);

class Afoo
{
    static this()
    {
	printf("Afoo()\n");
    }
}
