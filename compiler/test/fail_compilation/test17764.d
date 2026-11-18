/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/test17764.d(109): Error: assigning scope variable `c` to global variable `global` is not allowed in a `@safe` function
fail_compilation/test17764.d(109):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
---
 */

// upstream issue 17764

#line 100

int** global;

struct S { int** str; }

void f() @safe
{
    int* buf;
    S[1] c = S(&buf);
    global = c[0].str; /* This should be rejected. */
}
