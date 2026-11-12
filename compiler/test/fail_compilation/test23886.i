/* TEST_OUTPUT:
---
fail_compilation/test23886.i(103): Error: "string" expected after `#ident`
fail_compilation/test23886.i(103): Error: no type for declarator before `#`
fail_compilation/test23886.i(104): Error: "string" expected after `#ident`
fail_compilation/test23886.i(105): Error: "string" expected after `#ident`
---
*/

// upstream issue 23886

#line 100

#ident "abc"

#ident 7
#ident "def" x
#ident

void test() { }
