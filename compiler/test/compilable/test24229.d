// upstream dmd issue 24229

@system: class C { int x = 5; }
int f() { shared C c = new shared C; return c.x; }
bool g() { auto c = cast(shared) new C; return c is null; }

static assert(f() == 5);
static assert(!g());
