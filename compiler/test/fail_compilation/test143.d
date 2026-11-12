// REQUIRED_ARGS: -de
// upstream issue 143
// EXTRA_FILES: imports/test143.d
/*
TEST_OUTPUT:
---
fail_compilation/test143.d(20): Error: undefined identifier `x`
---
*/
module test143;

import imports.test143;

void bar(int)
{
}

void foo()
{
    bar(x);
}
