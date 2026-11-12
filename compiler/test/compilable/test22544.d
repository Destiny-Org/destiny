// upstream dmd issue 22544

struct S {
    int bar() { return 1; }
}

void foo(string key) {
    int[string] aa;
    with (S())
        aa[key] = bar();
}
