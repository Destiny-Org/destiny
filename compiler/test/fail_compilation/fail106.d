/*
TEST_OUTPUT:
---
fail_compilation/fail106.d(12): Error: cannot modify `immutable` expression `"ABC"[2]`
---
*/

// upstream issue 239
// Internal error: changing string literal elements
void main()
{
    "ABC"[2] = 's';
}
