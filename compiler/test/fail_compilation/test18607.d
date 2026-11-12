/* TEST_OUTPUT:
---
fail_compilation/test18607.d(10): Error: function `test18607.test!int` no `return exp;` or `assert(0);` at end of function
& test
---
*/

// upstream issue 18607

int* test(T...)() pure @safe {
        L:foreach(_; T) {
                continue L;
                return null;
        }
}


pragma(msg, &test!(int));
