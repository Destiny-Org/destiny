// PERMUTE_ARGS:
// EXTRA_SOURCES: imports/test61a.d

// upstream issue 6556

debug=BUG;

void main() {
    debug(BUG) import imports.test61a;
    assert(bar() == 12);
}
