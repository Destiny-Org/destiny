/* TEST_OUTPUT:
---
fail_compilation/fix18057.c(105): Error: redefinition of `x` with different type: `int` vs `char`
---
 */

// upstream issue 22316

#line 100

int x;
extern int x;
typedef int INT;
extern INT x;
extern char x;
