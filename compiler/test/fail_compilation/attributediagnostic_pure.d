/*
TEST_OUTPUT:
---
fail_compilation/attributediagnostic_pure.d(19): Error: `pure` function `D main` cannot call impure function `attributediagnostic_pure.gc`
fail_compilation/attributediagnostic_pure.d(14):        and executing an `asm` statement without `pure` annotation makes it fail to infer `pure`
---
*/

// Issue 17374 - Improve inferred attribute error message
// upstream issue 17374

@system: auto gc()
{
    asm {}
}

void main() pure
{
    gc();
}
