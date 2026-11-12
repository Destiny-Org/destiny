// upstream issue 20388

void main() {
    foo!(mixin("(int a) { return a; }"))();
    foo!(mixin("1+1"))();
    foo!(mixin(0))();
}

void foo(alias t)() {
}
