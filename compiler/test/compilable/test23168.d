// upstream issue 23168
// Issue 23168 - [DIP1000] return scope wrongly rewritten for structs with no indirections

@safe:
struct Ptr
{
    int* fun() return scope { return null; }
}

int* funf(ref return scope Ptr p) { return null; }

int* use()
{
    Ptr ptr;
    return ptr.fun;
    return funf(ptr);
}

// Prevent forward reference 'regression'
// See upstream dmd pull request 14232
struct S
{
    void f() scope {}
    alias x = _get_value;

    static if (true)
        int _get_value() {return 3;}
    else
        int _get_value() {return 4;}
}
