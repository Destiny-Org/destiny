/*
TEST_OUTPUT:
---
AliasSeq!(func)
---
*/
// upstream issue 21282

template I(T...) { alias I = T; }

template Bug(T...) {
        alias Bug = mixin("I!(T[0])");
}
void func() {}
pragma(msg, Bug!func);
