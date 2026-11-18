// PERMUTE_ARGS:
// upstream issue 19873
@system: int* ed(scope int* x)
{
    auto y = x;
    return y;
}

int* et(scope int* x) @trusted
{
    auto y = x;
    return y;
}

int* es(scope int* x) @system
{
    auto y = x;
    return y;
}

auto ad(scope int* x)
{
    auto y = x;
    return y;
}

auto at(scope int* x) @trusted
{
    auto y = x;
    return y;
}

auto as(scope int* x) @system
{
    auto y = x;
    return y;
}
