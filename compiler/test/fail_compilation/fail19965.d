/*
REQUIRED_ARGS: -preview=dip1000
TEST_OUTPUT:
---
fail_compilation/fail19965.d(36): Error: assigning address of variable `f` to `a` with longer lifetime is not allowed in a `@safe` function
---
*/

// upstream issue 19965

struct Buffer
{
    int[10] data;

    int[] getData() @safe return
    {
        return data[];
    }
}

struct Foo()
{
    Buffer buffer;

    int[] toArray() @safe return
    {
        return buffer.getData;
    }
}

int[] a;

void main() @safe
{
    Foo!() f;
    a = f.toArray;
}
