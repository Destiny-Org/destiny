// upstream issue 22593

struct Foo(T){
    this(Rhs, this This)(scope Rhs rhs){
    }

    this(ref scope typeof(this) rhs){
    }
}

struct Bar{
    Foo!int foo;
}
