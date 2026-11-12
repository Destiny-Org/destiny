// upstream issue 24066

/*
TEST_OUTPUT:
---
false
---
*/

class C;
pragma(msg, __traits(isAbstractClass, C));
