// Destiny: correctly scoped @safe code compiles without any flags.

@safe:

int* identity(return scope int* p) { return p; }

int sum(scope const(int)[] a)
{
    int s;
    foreach (x; a)
        s += x;
    return s;
}

void useLocal()
{
    int x = 1;
    int* p = &x;            // fine: p is inferred scope and does not escape
    auto q = identity(p);   // fine: q has the lifetime of x
    *q += 1;
    int[3] arr = [1, 2, 3];
    assert(sum(arr[]) == 6);
}
