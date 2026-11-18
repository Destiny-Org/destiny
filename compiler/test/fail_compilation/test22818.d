/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/test22818.d(102): Deprecation: typesafe variadic parameters with a `class` type (`C c...`) are deprecated
fail_compilation/test22818.d(104): Error: scope parameter `c` may not be returned
fail_compilation/test22818.d(104):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// upstream issue 22818

#line 100

@safe:
ref int g(C c ...)
{
    return c.x;
}

class C
{
    int x;
}
