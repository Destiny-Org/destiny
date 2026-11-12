// upstream issue 19804

struct A { float e; }

void foo(A[1] a)
{
    void bar(A[1] a) { a[] = null; }
    bar(a);
}
