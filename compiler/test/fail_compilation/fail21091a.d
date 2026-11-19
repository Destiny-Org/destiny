// upstream issue 21091

/*
TEST_OUTPUT:
----
fail_compilation/fail21091a.d(16): Error: unable to read module `Ternary`
fail_compilation/fail21091a.d(16):        Expected 'Ternary.dd' or 'Ternary/package.dd' in one of the following import paths:
import path[0] = fail_compilation
import path[1] = $p:druntime/import$
import path[2] = $p:fate$
----
*/

struct NullAllocator
{
    import Ternary;
    Ternary owns() { }
}
