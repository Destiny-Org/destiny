// REQUIRED_ARGS: -de
/* TEST_OUTPUT:
---
fail_compilation/b19691.d(12): Error: forward reference to template `this`
---
*/
// upstream issue 19691
module b19691;

struct S1 {
    this(T...)(T) {
        S2(42, "");
    }
}

struct S2 {
    this(int a, string) {}
    this(int a, S1 s = null) {}
}
