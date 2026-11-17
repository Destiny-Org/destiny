// REQUIRED_ARGS: -checkaction=context

// Issue 22919 - [dip1000] -checkaction=context gives "assigned to `__assertOp2` with longer lifetime" (
// upstream issue 22919

@safe:
struct S
{
    int* p;
    ref S get() scope return {return this;}
}

void main()
{
    scope S arr = S();
    assert(arr == arr.get());
}
