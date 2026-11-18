/*
Destiny: __traits(getOverloads) runs the semantic of each method so the result
carries default/inferred attributes. A method whose body has an error is still
listed; the error is reported once, from the method itself.
TEST_OUTPUT:
---
fail_compilation/destiny_traits_overloads_error.d(14): Error: undefined identifier `undefinedName`
---
*/

struct S
{
    void good() {}
    void bad() { undefinedName(); }
}

enum n = __traits(getOverloads, S, "bad").length;
static assert(n == 1);
