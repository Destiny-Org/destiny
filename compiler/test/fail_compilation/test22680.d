/* REQUIRED_ARGS: -preview=dip1000
TEST_OUTPUT:
---
fail_compilation/test22680.d(104): Error: assigning scope variable `this` to global variable `c` is not allowed in a `@safe` function
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
