// COMPILE_SEPARATELY:
// EXTRA_SOURCES: imports/test23722_2b.d
// upstream issue 23722
// Lambdas are mangled incorrectly when using multiple compilation units, resulting in incorrect code
import imports.test23722_2b;

void main() {
    S!1 s1;
    assert(s1.t.init.mangleof == g);
}
