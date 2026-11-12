/* TEST_OUTPUT:
---
fail_compilation/test22023.d(102): Error: typesafe variadic function parameter `a` of type `int[]` cannot be marked `return`
---
*/

// upstream issue 22023

#line 100

@safe:
ref int f(return int[] a ...)
{
    return a[2];
}
