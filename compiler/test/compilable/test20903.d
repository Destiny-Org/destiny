/* REQUIRED_ARGS: -O -m64
 */

// no longer caught at compile time, because of upstream dmd issue 24084
// originally reported by upstream issue 20903

long test()
{
    long r = 0x8000_0000_0000_0000L;
    long x = -1L;
    return r / x;
}
