// upstream issue 17752
// REQUIRED_ARGS: -de
void main (string[] args)
{
    switch (args.length)
    {
        // initialization not done on purpose is allowed
        int x = void;
    default:
        break;
    }
}
