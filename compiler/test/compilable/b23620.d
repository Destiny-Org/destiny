// upstream issue 23620
struct Index
{
    uint value;
    alias value this;
}

enum i = Index();
int[i] a;
static assert(a.length == 0);
