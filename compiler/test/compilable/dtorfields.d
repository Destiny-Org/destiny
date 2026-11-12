// REQUIRED_ARGS: -preview=dtorfields
//
// upstream issue 21709
// PERMUTE_ARGS: -betterC

/******************************************
 * upstream issue 20934
 */
struct HasDtor
{
    ~this() {}
}

struct Disable
{
    HasDtor member;
    this() @disable;
}

extern(C++) class Extern
{
    HasDtor member;
    this();
}

/******************************************
 * upstream issue 21213
 */
class Parent
{
    this() nothrow pure @nogc @safe {}
}

class Child : Parent
{
    HasDtor member;
}

/******************************************
 * upstream issue 21225
 */

struct NothrowConstructed
{
    ~this() {}
}

struct NothrowConstructor
{
    NothrowConstructed member;
    this(int) pure nothrow {}
}
