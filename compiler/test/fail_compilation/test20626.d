/*
REQUIRED_ARGS: -check=invariant=off
TEST_OUTPUT:
----
fail_compilation/test20626.d(2): Error: expression `__unittest_L1_C1` has no type
_error_
const void()
----

upstream issue 20626
*/

#line 1
unittest {}
pragma(msg, typeof(__unittest_L1_C1));

struct S
{
    invariant {}
}

pragma(msg, typeof(S.init.__invariant1));
