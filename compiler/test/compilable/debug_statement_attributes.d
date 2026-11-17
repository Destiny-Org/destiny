// ARG_SETS: -debug; -o-; -debug
// upstream issue 16492

void mayCallGC();

void test() @nogc pure
{
    debug new int(1);
    debug
    {
        mayCallGC();
        auto b = [1, 2, 3];
        b ~= 4;
    }
}

void debugSafe() @safe
{
    debug unsafeSystem();
    debug unsafeTemplated();
}

void unsafeSystem() @system {}
void unsafeTemplated()() {
    int[] arr;
    auto b = arr.ptr;
}

void debugSafe2() @safe
{
    char[] arr1, arr2;
    debug unsafeDIP1000Lifetime(arr1, arr2);

    char* ptr;
    char[] arr;
    debug ptr = arr.ptr;
}

void unsafeDIP1000Lifetime()(ref char[] p, scope char[] s)
{
    p = s;
}


void test2() nothrow
{
    debug throw new Exception("");
}

void test3() nothrow
{
    debug {
        foreach (_; 0 .. 10) {
            if (1) {
                throw new Exception("");
            }
        }
    }
}

void test4() nothrow
{
    debug throwException();
}

void test5() nothrow
{
    debug willThrowException();
}

void willThrowException()()
{
    throwException();
}

void throwException()
{
    throw new Exception("");
}

void test6() nothrow
{
    debug
    {
        () {throw new Exception("");}();
    }
}

void writeln() {}
void writeln(string) {}

void test7() nothrow
{
    debug writeln("Hello"); // upstream issue 24017
    debug "Hello".writeln;
    debug writeln = "Hello"; // upstream dmd issue 20719
    debug writeln;

    // upstream dmd pull request 20720
    debug pragma(msg, ""); // Came up as segfault, pragma statement became null after semantic
}
