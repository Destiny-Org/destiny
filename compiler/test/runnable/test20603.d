// upstream issue 20603

@system: enum immutable(int)* x = new int(3);
enum const(int)* y = new int(5);

struct Base {
    union {
        int overlap;
        immutable(Sub)* sub;
    }

    this(Sub) {
        sub = new Sub;
    }
}

struct Sub {
    Base base;
}

immutable c0 = Base(Sub.init);

void main()
{
    enum const(int)* z = new int(9);

    assert(*x == 3);
    assert(*y == 5);
    assert(*z == 9);
    assert(c0.sub.base.sub == null);
}
