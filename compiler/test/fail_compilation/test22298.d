/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test22298.d(20): Error: assigning scope variable `i` to `p` with longer lifetime is not allowed in a `@safe` function
fail_compilation/test22298.d(20):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
fail_compilation/test22298.d(31): Error: assigning scope variable `y` to `x` with longer lifetime is not allowed in a `@safe` function
fail_compilation/test22298.d(31):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
---
*/

void g(scope void delegate(scope int*) @safe cb) @safe {
	int x = 42;
	cb(&x);
}

void main() @safe {
	int* p;
	void f(scope int* i) @safe {
		p = i;
	}

	g(&f);
	// address of x has escaped g
	assert(*p == 42);
}

void f() @safe {
    mixin("scope int* x;");
    scope int* y;
    x = y;
}
