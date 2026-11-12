// upstream issue 20406
struct S
{
	@disable this();
	this(int) {}
	this(ref S other) {}
}

void foo(S s) {}

void main()
{
    S s = S(3);
    foo(s);
}
