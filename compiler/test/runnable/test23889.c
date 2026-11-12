// DISABLED: win freebsd openbsd

// upstream issue 23889

#include <alloca.h>

int main()
{
    int *p = (int*)alloca(100 * sizeof(int));
    for (int i = 0; i < 100; ++i)
	p[i] = i;
    return 0;
}
