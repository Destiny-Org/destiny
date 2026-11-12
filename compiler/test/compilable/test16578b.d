// upstream issue 16578

void main()
{
    string[string] opts;
    switch (2)
    {
    case 0:
        opts["a"] = "";
        {
    case 1:
            break;
        }
    default:
    }
}
