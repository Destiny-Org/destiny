// upstream issue 23142

struct Foo
{
    int x;

scope:
    void func()
    {
    }

    unittest
    {
    }

    static void func2()
    {
    }
}
