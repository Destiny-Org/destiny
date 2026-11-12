/* TEST_OUTPUT:
---
fail_compilation/b15875.d(9): Error: undefined identifier `a`
fail_compilation/b15875.d(10): Error: circular reference to `b15875.f`
---
*/
// upstream issue 15875
// upstream issue 17290
d o(int[a]a)(){}
f.T f(){}
