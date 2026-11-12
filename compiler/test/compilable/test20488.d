module test20488;

// upstream issue 20488
struct Bar {
    void opDispatch(string s, Args...) (Args args) {
    }
    void fun() {
        (bool[int]).init.length;
        this.f((int[int]).init.length);
    }
}
