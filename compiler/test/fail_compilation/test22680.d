/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test22680.d(104): Error: assigning scope variable `this` to global variable `c` is not allowed in a `@safe` function
fail_compilation/test22680.d(104):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
---
*/

// upstream issue 22680

#line 100

C c;
class C {
    ~this() @safe {
	    c = this;
    }
}
