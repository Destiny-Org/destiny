// PERMUTE_ARGS: -preview=dip1000
// upstream issue 20823

void boo(T)(  scope   void delegate(T[] data) fun) {}
void goo(T)(/+scope+/ void delegate(T[] data) fun) {}

void main()
{
    void Execute(int[] data) {}
    goo(&Execute);
    boo(&Execute);
}
