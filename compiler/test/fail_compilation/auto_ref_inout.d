/*
TEST_OUTPUT:
---
fail_compilation/auto_ref_inout.d(12): Error: template `f` is not callable using argument types `!()(int)`
fail_compilation/auto_ref_inout.d(10):        Candidate is: `f(T)(auto ref inout T a, auto ref inout T b)`
---
*/

// upstream issue 24707
auto ref inout(T) f(T)(auto ref inout T a, auto ref inout T b);

enum e = f(5);
