// upstream issue 20656

import core.stdc.stdlib : free, malloc;

@live
void main()
{
    auto p = malloc(1);
    free(p);
    free(p);
}
