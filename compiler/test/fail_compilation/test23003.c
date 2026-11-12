/* TEST_OUTPUT:
---
fail_compilation/test23003.c(101): Error: `size_t` is not defined, perhaps `#include <stddef.h>` ?
fail_compilation/test23003.c(102): Error: undefined identifier `object`
---
*/

/* upstream issue 23003
 */

#line 100

size_t x;
object y;
