// upstream issue 20520

class C {}

enum Foo {
    Bar = new C()
}

void main()
{
    //pragma(msg, typeid(Foo.Bar)); // Works fine: typeid(C())
    auto t = typeid(Foo.Bar);     // Segfault here
}
