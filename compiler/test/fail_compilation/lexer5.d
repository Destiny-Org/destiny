/*
TEST_OUTPUT:
---
fail_compilation/lexer5.d(11): Error: number `1e-100f` is not representable as a `float`
fail_compilation/lexer5.d(11):        https://github.com/Destiny-Org/destiny/blob/main/spec/lex.ddd
fail_compilation/lexer5.d(12): Error: number `1e-10024` is not representable as a `double`
fail_compilation/lexer5.d(12):        `real` literals can be written using the `L` suffix. https://github.com/Destiny-Org/destiny/blob/main/spec/lex.ddd
---
*/

static float f = 1e-100f;
static float f2 = 1e-10024;
