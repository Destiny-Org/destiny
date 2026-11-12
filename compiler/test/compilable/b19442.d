// upstream issue 19442
enum x1 = 42;
enum x2 = mixin('x', 1);
enum x3 = mixin(wchar('x'), 2);
enum x4 = mixin(dchar('x'), 3);
static assert(x2 == 42);
static assert(x3 == 42);
static assert(x4 == 42);

mixin(`enum string s = "`, wchar('ö'), dchar('🍺'), `";`);
static assert(s == "ö🍺");
