/* REQUIRED_ARGS: -betterC
   PERMUTE_ARGS:
*/

import core.stdc.stdio;

extern (C) int main()
{
    printf("hello world\n");
    int[3] a;
    foo(a[], 3);
    return 0;
}

int foo(int[] a, int i)
{
    return a[i];
}

/**********************************************/
// upstream issue 19234
void issue19234()
{
    static struct A {}
    A[10] a;
    A[10] b;
    b[] = a[];
}

/**********************************************/
// upstream issue 22922
void issue22922()
{
    int[] x = [];
}
