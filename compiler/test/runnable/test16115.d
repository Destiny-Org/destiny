/*
REQUIRED_ARGS: -d
PERMUTE_ARGS:
 */

// upstream issue 16115
// upstream dmd pull request 3979

int n;

struct Test
{
    enum tag = 42;
}

enum tagx = 42;

auto call()
{
    version (none) // works
    {
        n = Test.tag;
        return null;
    }
    else // assert error
    {
        //return n = tagx, null;
        return n = Test.tag;
        //return n = Test.tag;
    }
}

void main()
{
    call();

    assert(n == 42);
}
