// upstream issue 23433
module object;

class Throwable { }
class Exception : Throwable { this(immutable(char)[]) { } }

// Needed to lower `new Exception("ice")` to it.
T _d_newclassT(T)()
if (is(T == class))
{
    return null;
}

void test23433()
{
    try
    {
        throw new Exception("ice");
    }
    finally
    {
    }
}
