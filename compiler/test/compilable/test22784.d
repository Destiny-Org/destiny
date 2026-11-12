// Issue 22784 - pragma(printf) applies to nested functions
// upstream issue 22784

import core.stdc.stdarg;
extern(C)
pragma(printf)
void fn(const(char)* fmt, ...)
{
    void inner(){}
}
