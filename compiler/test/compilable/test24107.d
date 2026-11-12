// upstream issue 24107

/*
TEST_OUTPUT:
---
This should not output an error message: false
---
*/

bool recurse ()
{
    return recurse();
}

pragma(msg,
        "This should not output an error message: ",
       __traits(compiles, {enum bool r = recurse();}));
