// REQUIRED_ARGS: -debug -O -release
// upstream issue 22277

bool secret = false;

void free(immutable void* x) pure nothrow
{
    debug secret = true;
}

void main()
{
    free(null);
    if (!secret)
        assert(0);
}
