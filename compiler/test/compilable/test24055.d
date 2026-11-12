// REQUIRED_ARGS: -o-
// upstream issue 24055
// is(x == __parameters) does not work on function pointer/delegate types

void function(int) fp;
void delegate(int) dg;

static assert(is(typeof(fp) == __parameters));
static assert(is(typeof(*fp) == __parameters));
static assert(is(typeof(dg) == __parameters));

static if(is(typeof(dg) FP == delegate))
    static assert(is(FP == __parameters)); // OK
else
    static assert(0);
