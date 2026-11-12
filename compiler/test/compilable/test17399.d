/* REQUIRED_ARGS: -inline
 */

// upstream issue 17399

pragma(inline, true)
uint addu(uint x, uint y, ref bool overflow) {
    uint r = x + y;
    if (r < x || r < y)
        overflow = true;
    return r;
}

void foo() {
    uint a, b;
    bool over;
    addu(a, b, over);
}
