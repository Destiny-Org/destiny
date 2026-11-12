// upstream issue 23533
// REQUIRED_ARGS: -preview=nosharedaccess

enum E { a, b }

void main()
{
	E x = E.b;
	E y = E.max;
}
