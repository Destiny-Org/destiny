// upstream issue 22825
/* TEST_OUTPUT:
---
fail_compilation/fail22825a.d(10): Error: positive integer argument expected following `#line`
fail_compilation/fail22825a.d(11): Error: declaration expected, not `42`
---
*/
#line /*
         multi-line comment
*/
42
