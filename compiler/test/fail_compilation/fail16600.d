/* TEST_OUTPUT:
---
fail_compilation/fail16600.d(22): Error: `fail16600.S.__ctor` called with argument types `(string) const` matches multiple overloads exactly:
fail_compilation/fail16600.d(16):     `fail16600.S.this(string __param_0)`
and:
fail_compilation/fail16600.d(17):     `fail16600.S.this(string __param_0) immutable`
---
*/

// upstream issue 16600

struct S
{
    int i;

    this(string) { i = 1; }
    this(string) immutable { i = 2; }
}

void main()
{
    auto a = const(S)("abc");
    assert(a.i == 2);
}
