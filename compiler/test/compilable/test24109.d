// upstream issue 24109

struct Outer
{
    void method1() {}

    void method2()
    {
        class Inner
        {
            void innerMethod()
            {
                method1();
            }
        }
    }
}
