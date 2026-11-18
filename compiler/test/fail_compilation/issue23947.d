// upstream issue 23947
/*
TEST_OUTPUT:
---
fail_compilation/issue23947.d(10): Error: function `imports.issue23947a.Class.handle` of type `@safe void(X x)` is not accessible from module `issue23947`
---
*/
@system: import imports.issue23947a;

void main() { Class.init.handle(X.init); }
