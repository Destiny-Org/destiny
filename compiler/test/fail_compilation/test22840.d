/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/test22840.d(25): Error: returning `sb.slice()` escapes a reference to local variable `sb`
---
*/

// inout method with inferred @safe escapes local data
// upstream issue 22840

// See also: upstream issue 20149

struct S
{
    int buf;
    auto slice() inout
    {
        return &buf;
    }
}

int* fun() @safe
{
    S sb;
    return sb.slice(); // should error
}
