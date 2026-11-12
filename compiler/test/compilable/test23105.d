// upstream issue 23105

module test23105;

static assert(is(mixin(`__traits(getMember, test23105, "object")`) == module));
static assert(is(__traits(getMember, test23105, "object") == module)); // Fixed
