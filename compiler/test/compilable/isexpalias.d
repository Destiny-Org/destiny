// upstream issue 23578
struct S(alias a)
{
}

static if (is(S!int == S!av, alias av))
    static assert(is(av == int));
else
    static assert(false);
