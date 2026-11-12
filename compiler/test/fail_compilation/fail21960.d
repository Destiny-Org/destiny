/*
TEST_OUTPUT:
---
fail_compilation/fail21960.d(16): Error: cannot implicitly convert expression `E.One` of type `E` to `string`
---
*/

// upstream issue 21960

enum E { One, Two }

void main()
{
    enum R : string
    {
        Test = E.One
    }
}
