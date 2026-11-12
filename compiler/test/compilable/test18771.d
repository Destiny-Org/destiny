// REQUIRED_ARGS: -c
// EXTRA_FILES: imports/test18771a.d imports/test18771b.d imports/test18771c.d imports/test18771d.d
// upstream issue 18771

import imports.test18771c, imports.test18771d;

static assert(__traits(isSame, fooC, fooD));
