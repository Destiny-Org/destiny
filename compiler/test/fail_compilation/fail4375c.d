// upstream issue 4375: Dangling else
/*
TEST_OUTPUT:
---
fail_compilation/fail4375c.d(14): Error: else is dangling, add { } after condition at fail_compilation/fail4375c.d(10)
---
*/

void main() {
    if (true)
        if (false) {
            assert(6.1);
        }
    else {
        assert(6.2);
    }
}
