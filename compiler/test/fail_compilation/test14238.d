/* REQUIRED_ARGS:
   TEST_OUTPUT:
---
fail_compilation/test14238.d(23): Error: scope parameter `fn` may not be returned
fail_compilation/test14238.d(23):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/test14238.d(26): Error: function `test14238.bar` is `@nogc` yet allocates closure for `bar()` with the GC
fail_compilation/test14238.d(28):        function `baz` closes over variable `x`
fail_compilation/test14238.d(27):        `x` declared here
---
*/
// upstream issue 14238

@safe:

alias Fn = ref int delegate() return @nogc;

ref int call(return scope Fn fn) @nogc
{
    return fn(); // Ok
}

ref int foo2(scope Fn fn) {
    return fn(); // Error
}

ref int bar() @nogc {
    int x;
    ref int baz() {
            return x;
    }

    if (x == 0)
        return call(&baz);
    else
        return (&baz)();
}
