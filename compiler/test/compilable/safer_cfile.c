// upstream dmd issue 22453
// -preview=safer should ignore C files
// Destiny: C files are never @safe by default, so no switch is needed
int f(int *p)
{
    return p[1];
}
