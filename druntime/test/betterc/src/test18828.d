/*******************************************/
// upstream issue 18828

struct S18828 { }

extern(C) void main()
{
    S18828 s;
    destroy(s);
}
