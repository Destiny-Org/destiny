// upstream issue 24338

enum Foo: char[4]
{
    elem = "test"
}

immutable a = [Foo.elem];
immutable b = [Foo.elem];
immutable c = a ~ b;
