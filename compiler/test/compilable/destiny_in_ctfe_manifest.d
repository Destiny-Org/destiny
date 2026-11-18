// `in` means `scope const` and may pass by reference. Passing a manifest
// constant to such a parameter during CTFE crashed the compiler.
struct S
{
    int[] a;
    long b;
    S add(int x) scope const { return S(a.dup ~ x, b); }
}

S plus(in S n) { return n.add(2); }

void f()
{
    S local(in S n) { return n.add(3); }
    enum S t1 = S([1], 2);
    enum S t2 = plus(t1);
    enum S t3 = local(t1);
    static assert(t2.a == [1, 2] && t3.a == [1, 3]);
}

enum S g1 = S([5], 6);
enum S g2 = plus(g1);
static assert(g2.a == [5, 2] && g2.b == 6);
