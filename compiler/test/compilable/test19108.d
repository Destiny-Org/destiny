// REQUIRED_ARGS: -ignore

// upstream issue 19108

pragma(unknown_global);
void main()
{
    pragma(unknown_local); // Error: unrecognized pragma
}
