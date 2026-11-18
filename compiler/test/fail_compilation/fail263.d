/*
TEST_OUTPUT:
----
fail_compilation/fail263.d(20): Error: function `f` is not callable using argument types `(const(byte)*)`
fail_compilation/fail263.d(20):        cannot pass argument `cast(const(byte)*)A` of type `const(byte)*` to parameter `byte* p`
fail_compilation/fail263.d(14):        `fail263.f(byte* p)` declared here
----
*/

// upstream issue 2766
// DMD hangs with 0%cpu
@system: const byte[] A = [ cast(byte)0 ];

void f(byte* p)
{
}

void func()
{
    f(A.ptr);
}
