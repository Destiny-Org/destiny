/*
EXTRA_FILES: imports/spell23908a.d imports/spell23908b.d
TEST_OUTPUT:
---
fail_compilation/imports/spell23908a.d(3): Error: module `imports.spell23908b` import `nonexistent` not found
---
*/

// upstream issue 23908

import imports.spell23908a;
