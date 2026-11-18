// Destiny: __traits(getVirtualMethods/getOverloads) return methods whose
// declaration semantic is finished, so defaulted attributes (@safe) are present
// even when nothing else has looked at the methods yet.

bool hasAttr(string[] attrs, string a)
{
    foreach (x; attrs)
        if (x == a)
            return true;
    return false;
}

@system void f()
{
    interface I
    {
        void a();
        int b(int);
        void c() @system;
    }
    alias va = __traits(getVirtualMethods, I, "a");
    alias vb = __traits(getVirtualMethods, I, "b");
    alias vc = __traits(getVirtualMethods, I, "c");
    static assert( hasAttr([__traits(getFunctionAttributes, va[0])], "@safe"));
    static assert( hasAttr([__traits(getFunctionAttributes, vb[0])], "@safe"));
    static assert(!hasAttr([__traits(getFunctionAttributes, vc[0])], "@safe"));

    class C
    {
        int m() { return 1; }
    }
    alias om = __traits(getOverloads, C, "m");
    static assert( hasAttr([__traits(getFunctionAttributes, om[0])], "@safe"));
}
