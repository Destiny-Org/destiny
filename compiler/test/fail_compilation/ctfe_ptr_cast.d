/*
TEST_OUTPUT:
---
fail_compilation/ctfe_ptr_cast.d(10): Error: reinterpreting cast from `int()*` to `@system int(int)*` is not supported in CTFE
fail_compilation/ctfe_ptr_cast.d(13): Error: reinterpreting cast from `extern(C) int()*` to `@system int()*` is not supported in CTFE
---
*/

@system: int f1() { return 0; }
auto fp = cast(int function(int)) &f1;

extern(C) int cf() { return 0; }
auto fp2 = cast(int function()) &cf; // target not extern(C)
