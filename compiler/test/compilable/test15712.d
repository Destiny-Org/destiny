// REQUIRED_ARGS: -unittest

// upstream issue 15712
// extern(C) attribute inside extern(C) unittest is incorrectly ignored

extern(C):

unittest
{
	extern(C) static void foo() {}
	static assert(__traits(getLinkage, foo) == "C");
}
