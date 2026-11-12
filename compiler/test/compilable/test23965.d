// upstream issue 23965
// REQUIRED_ARGS: -de
deprecated:

struct S {}

void fun()
{
    S[] arr;
    arr ~= S();
}
