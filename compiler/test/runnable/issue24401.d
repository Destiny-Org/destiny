// PERMUTE_ARGS:
// upstream issue 24401
int main()
{
    return (() @trusted => 0)();
}
