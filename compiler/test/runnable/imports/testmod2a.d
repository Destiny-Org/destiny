module imports.testmod2a;

/**********************************/
// upstream issue 1904

// testmod.d
private void bar(alias a)() {}

void foo(alias a)() {
    .bar!(a)();
}
