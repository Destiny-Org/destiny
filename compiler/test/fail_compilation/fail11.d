/*
TEST_OUTPUT:
---
fail_compilation/fail11.d(12): Error: `int*` has no effect
---
*/

// https://github.com/Destiny-Org/destiny

void main()
{
    TFoo!(int).t; // should produce a "no identifier" error.
}
template TFoo(T) { alias T* t; }
