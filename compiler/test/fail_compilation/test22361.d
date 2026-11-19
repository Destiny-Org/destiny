/*
TEST_OUTPUT:
---
fail_compilation/test22361.d(11): Error: unable to read module `this_module_does_not_exist`
fail_compilation/test22361.d(11):        Expected 'this_module_does_not_exist.dd' or 'this_module_does_not_exist/package.dd' in one of the following import paths:
import path[0] = fail_compilation
import path[1] = $p:druntime/import$
import path[2] = $p:fate$
---
*/
import this_module_does_not_exist;
