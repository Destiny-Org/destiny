/* TEST_OUTPUT:
---
fail_compilation/fix22342.c(103): Error: named parameter required before `...`
---
 */

#line 100

// upstream issue 22342

void func(...);
