/* DISABLED: win32 linux32
TEST_OUTPUT:
---
fail_compilation/test23875.c(12): Error: __attribute__((vector_size(10))) must be an integer positive power of 2 and be <= 32,768
fail_compilation/test23875.c(13): Error: value for vector_size expected, not `x`
---
*/

// upstream issue 23875
// upstream issue 23880

int __attribute__((vector_size(10))) neptune();
int __attribute__((vector_size(x))) saturn();
