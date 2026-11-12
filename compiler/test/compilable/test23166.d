// REQUIRED_ARGS: -inline

// upstream issue 23166

// seg fault with -inline

bool __equals(scope const char[] lhs, scope const char[] rhs)
{
    if (lhs.length != rhs.length)
        return false;

    {
        import core.stdc.string : memcmp;
        return lhs.length == 0;
    }
    return true;
}

int test(string type)
{
    return __equals(type, "as-is");
}
