// Destiny: an `in` parameter accepts the same arguments whether the target
// passes it by value or by `ref` (`in real` is `ref` on 32-bit x86 only;
// a large struct is `ref` everywhere). Arguments that convert implicitly are
// converted into a temporary.

struct Big
{
    long[8] values;
    this(int v) { values[] = v; }
}

real twice(in real x) { return 2 * x; }
real sum(in real x, in real y) { return x + y; }
long first(in Big b) { return b.values[0]; }

void main()
{
    assert(twice(7) == 14);            // int literal -> real
    int i = 3;
    assert(twice(i) == 6);             // int lvalue -> real
    assert(sum(1, 2.5) == 3.5);        // int and double -> real
    double d = 1.5;
    assert(sum(d, i) == 4.5);
    real r = 2;
    assert(twice(r) == 4);             // exact type still passes directly

    Big b = Big(5);
    assert(first(b) == 5);
    assert(first(Big(9)) == 9);        // rvalue struct
}
