/**
TEST_OUTPUT:
---
fail_compilation/named_arguments_struct_literal.d(14): Error: trying to initialize past the last field `z` of `S`
---
*/

// upstream issue 24281

struct S { int y, z = 3; }

S s = S(
	z: 2,
	3,
);
