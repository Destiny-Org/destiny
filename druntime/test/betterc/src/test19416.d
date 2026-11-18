/*******************************************/
// upstream issue 19416

@system: import core.stdc.stdlib : malloc, free;
import core.exception : onOutOfMemoryError;

extern(C) void main()
{
    auto m = malloc(1);
    if (!m)
        onOutOfMemoryError();
    else
        free(m);
}
