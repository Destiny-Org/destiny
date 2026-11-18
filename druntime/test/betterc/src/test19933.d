/*******************************************/
// upstream issue 19933
// upstream issue 18816

@system: import core.stdc.stdio : FILE, fprintf, stderr;

extern(C) int main()
{
    // C stdio owns this shared global; the test only needs the current handle.
    fprintf(cast(FILE*) stderr, "Hello\n");
    return 0;
}
