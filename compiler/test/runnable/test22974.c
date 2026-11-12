// EXTRA_SOURCES: imports/test22974b.c

/* upstream issue 22974
 */

int main()
{
    extern int ccc();
    extern int xxx;
    xxx = ccc();
    return xxx - 1;
}
