// upstream issue 22885

typedef int T;
void test()
{
    typedef T* T;  // should declare a new T that is an int*
    int i;
    T p = &i;
}
