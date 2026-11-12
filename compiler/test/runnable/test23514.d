// DISABLED: win64
// upstream issue 23514

// Note: this test is disabled on Win64 because of an issue with the Windows
// MS-COFF backend causing it to fail.

enum ulong offset = 0xFFFF_FFFF_0000_0000UL;

void main()
{
    ulong voffset = offset;
    assert((cast(ulong)&main + voffset) == (cast(ulong)&main + offset));
}
