/*
TEST_OUTPUT:
---
fail_compilation/test15368.d(13): Error: cannot declare `auto` loop variable, omit `auto` to still get type inference
---
*/

// Issue 15368 - Improve error message for "auto" keyword inside "foreach"
// upstream issue 15368

void main()
{
    foreach (auto e; foo) { }
}
