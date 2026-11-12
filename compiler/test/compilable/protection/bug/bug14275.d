module protection.bug.bug14275;

import protection.aggregate.mod14275;

// upstream issue 14275

void main() {
    Foo f;
    f.foo();
    static assert (!is(typeof(f.foo2())));
    bar();
}
