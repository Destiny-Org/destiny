// EXTRA_FILES: imports/library.c

// upstream issue 23913

import imports.library;

alias x = __traits(getMember, imports.library, "SomeEnum");
