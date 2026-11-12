/* REQUIRED_ARGS: runnable/extra-files/test24129b.c
 */

// https:upstream issue 24129

inline int dup()
{
    return 73;
}

void *def()
{
    return &dup;
}

int main()
{
    return 0;
}
