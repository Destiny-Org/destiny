/*
TEST_OUTPUT:
---
fail_compilation/fail21045.d(12): Error: unable to read module `__stdin`
fail_compilation/fail21045.d(12):        Expected '__stdin.dd' or '__stdin/package.dd' in one of the following import paths:
import path[0] = fail_compilation
import path[1] = $p:druntime/import$
import path[2] = $p:fate$
---
*/

import __stdin;
