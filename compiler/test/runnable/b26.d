// COMPILE_SEPARATELY:
// EXTRA_SOURCES: imports/b26a.d
// PERMUTE_ARGS:

// upstream issue 382

struct List(T) {
        interface A {}
}

int main(char[][] args) {
        List!(char) list;
        return 0;
}
