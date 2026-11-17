// REQUIRED_ARGS:

void assertEq(scope int[][3] x) @safe
{
	bool b = x == x;
}
