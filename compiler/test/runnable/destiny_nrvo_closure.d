/*
Destiny: returning a struct from inside a foreach over an opApply whose delegate
is not `scope`. Scope checking makes the foreach body a closure, and the result
must still be constructed in the caller's return slot (NRVO through the closure).
PERMUTE_ARGS: -O -inline -release
*/

@system: struct S
{
    S* self;
    int value;

    this(int v) { self = &this; value = v; }
    this(ref inout S o) { self = &this; value = o.value; }

    void check() const { assert(self is &this); }
}

struct NotScope
{
    int opApply(int delegate(int) dg) { return dg(7); } // delegate not `scope`
}

struct WithScope
{
    int opApply(scope int delegate(int) dg) { return dg(8); }
}

S fromNotScope()
{
    S s = S(1);
    foreach (i; NotScope())
    {
        s.value = i;
        return s;
    }
    return s;
}

S fromWithScope()
{
    S s = S(1);
    foreach (i; WithScope())
    {
        s.value = i;
        return s;
    }
    return s;
}

S nested()
{
    S s = S(1);
    foreach (i; NotScope())
        foreach (j; NotScope())
        {
            s.value = i + j;
            return s;
        }
    return s;
}

// returning the loop variable itself, collections passed by ref, body never run
struct C2
{
    this(ref C2) {}
    int opApply(int delegate(C2)) { return 0; }
}

C2 loopVar(ref C2 l1, ref C2 l2)
{
    foreach (f; l1)
        foreach (s; l2)
            return s;
    return C2();
}

void main()
{
    C2 x, y;
    loopVar(x, y);

    auto a = fromNotScope();
    a.check();
    assert(a.value == 7);

    auto b = fromWithScope();
    b.check();
    assert(b.value == 8);

    auto c = nested();
    c.check();
    assert(c.value == 14);
}
