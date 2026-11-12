/*
EXTRA_FILES: imports/b17918a.d
TEST_OUTPUT:
---
fail_compilation/imports/b17918a.d(7): Error: undefined identifier `_listMap`
---
*/
// upstream issue 17918
import imports.b17918a;

class Derived : Base
{
}
