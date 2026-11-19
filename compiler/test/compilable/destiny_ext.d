// Destiny: modules in `.dd` files are found by `import`, like `.d` files.
// EXTRA_FILES: imports/destiny_ext_mod.dd

import imports.destiny_ext_mod;

static assert(answer() == 42);
