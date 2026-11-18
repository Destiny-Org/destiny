// upstream issue 20656

@system: import core.stdc.stdlib : free, malloc;

@live
void main()
{
    auto p = malloc(1);
    free(p);
    free(p);
}
