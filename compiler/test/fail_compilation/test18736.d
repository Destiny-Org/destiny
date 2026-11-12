/* TEST_OUTPUT:
---
fail_compilation/test18736.d(21): Error: constructor calls not allowed in loops or after labels
---
*/

// upstream issue 18736

class A
{
    this(char c) { }

    this(int i)
    {
        switch (i)
        {
            case 1:  break;
            case 2: .. case 4: break;
            default: break;
        }
        this('c');
    }
}
