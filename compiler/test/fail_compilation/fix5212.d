/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/fix5212.d(14): Error: assigning scope variable `args_` to non-scope `this.args` is not allowed in a `@safe` function
---
*/


// upstream issue 5212

class Foo {
    int[] args;
    @safe this(int[] args_...) {
        args = args_;
    }
}
