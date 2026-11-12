// upstream issue 21680

struct Unique
{
    alias ValueType = typeof({ return field; }()); /* Error: need `this` for
`field` of type `int` */
    int field;
    static assert(is(ValueType == int));
}
