/* TEST_OUTPUT:
---
fail_compilation/test23057.c(101): Error: no type for declarator before `(`
---
*/

/* upstream issue 23057
 */

#line 100

(a[0])
