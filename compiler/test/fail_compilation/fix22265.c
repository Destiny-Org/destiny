/* TEST_OUTPUT:
---
fail_compilation/fix22265.c(104): Error: cannot modify `const` expression `*buf`
---
 */

// upstream issue 22265

#line 100

void test(const char *buf, char *const p)
{
   char a = *buf++;
   *buf = 'a';          // 104
}
