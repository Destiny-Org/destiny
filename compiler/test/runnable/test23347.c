/* DISABLED: osx32 osx64 win32 win64
 * TEST_OUTPUT:
---
---
 */

// upstream issue 23347

void fork() { }

#pragma pack(push, 4)
void spoon() asm("fork");
#pragma pack(pop);

int main()
{
    spoon();
    return 0;
}
