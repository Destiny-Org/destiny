// upstream issue 20868
// REQUIRED_ARGS:

@system: void scoped (scope void delegate() dg)
{
    static void delegate()[] dgs;
    dgs ~= dg;  // error
}
