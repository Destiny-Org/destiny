// upstream issue 20136
class Context
{
    size_t[const(Key)] aa;
    bool checkAll;
}

struct Key
{
    Context context;
    int i;
    bool opEquals(ref const Key other) const
    {
        if(context.checkAll && i != other.i)
            return false;
        return true;
    }
}
