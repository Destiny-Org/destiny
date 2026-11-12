// REQUIRED_ARGS: -debug

// upstream issue 16578

string[string] opts;

void main()
{
    string arg;
    switch (arg)
    {
        case "-f": opts["fore"] = ""; break;
        debug { case "-throw": opts["throw"] = ""; break; }
        default:
    }
}
