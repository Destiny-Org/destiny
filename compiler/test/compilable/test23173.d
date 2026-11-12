// REQUIRED_ARGS: -o-
// upstream issue 23173

mixin("long l = ", long.min, ";");
static assert(mixin(long.min) == long.min);
static assert(is(typeof(mixin(long.min)) == long));
