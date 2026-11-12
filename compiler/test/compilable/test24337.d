/*
TEST_OUTPUT:
---
"ab"w x"11223344556677"
---
*/
// upstream issue 24337

immutable ushort[] y = cast(immutable ushort[]) "ab"w;
immutable ulong[] z = x"00 11 22 33 44 55 66 77";
pragma(msg, y, " ", z);
