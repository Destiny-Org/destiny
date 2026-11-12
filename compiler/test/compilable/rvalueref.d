/* REQUIRED_ARGS: -preview=rvaluerefparam
 */

struct AS
{
    string get() @safe @nogc pure nothrow { return _s; }
    alias get this;
    @disable this(this);
    string _s;
}

void popFront(ref string) { }
static assert(!is(typeof((R r) => r.popFront)));

// upstream issue 24883
int toString(Writer)(ref Writer sink) => 3;
int toString(void delegate(scope const(char)[]) sink) => 4;
void put() {}
static assert(toString(dst => put()) == 4);
