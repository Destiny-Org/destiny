// REQUIRED_ARGS: -preview=dip1008 -Ifail_compilation/extra-files
// upstream issue 20023
/*
TEST_OUTPUT:
---
fail_compilation/imports/test20023b.d(8): Error: returning scope variable `e` is not allowed in a `@safe` function
fail_compilation/imports/test20023b.d(8):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test20023.d(16): Error: template instance `imports.test20023b.threw!()` error instantiating
---
*/
import imports.test20023b;

@safe:
void main()
{
    threw!()();
}
