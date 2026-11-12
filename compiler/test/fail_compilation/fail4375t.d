// REQUIRED_ARGS: -unittest
// upstream issue 4375: Dangling else
/*
TEST_OUTPUT:
---
fail_compilation/fail4375t.d(14): Error: else is dangling, add { } after condition at fail_compilation/fail4375t.d(11)
---
*/

unittest {  // disallowed
    if (true)
        if (false)
            assert(52);
    else
        assert(53);
}
