// upstream issue 18871
// and upstream issue 18819

struct Problem
{
    ~this() {}
}
struct S
{
    Problem[1] payload;
}
enum theTemplateB = {
    static foreach (e; S.init.tupleof) {}
    return true;
}();
