// upstream issue 20417

struct A { ~this(); }
void f(A, int);
A a();
int i();

static assert(__traits(compiles, { f(a, i); }));
static assert(__traits(compiles, f(a, i)));

static assert(is(typeof({ f(a, i); })));
static assert(is(typeof(f(a, i))));
