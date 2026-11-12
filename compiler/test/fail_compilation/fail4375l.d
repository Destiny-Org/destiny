// upstream issue 4375: Dangling else
/*
TEST_OUTPUT:
---
fail_compilation/fail4375l.d(14): Error: else is dangling, add { } after condition at fail_compilation/fail4375l.d(10)
---
*/

void main() {
    if (true)
        while (false)
            if (true)
                assert(70);
    else
        assert(71);
}
