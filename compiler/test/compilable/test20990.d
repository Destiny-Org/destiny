// REQUIRED_ARGS: -O
// upstream issue 20990

// foo() and bar() should produce the same code when
// optimized.

void foo(int* ptr)
{
    if (ptr is null)
        assert(false);
    *ptr = 42;
}

void bar(int* ptr)
{
    assert(ptr);
    *ptr = 42;
}
