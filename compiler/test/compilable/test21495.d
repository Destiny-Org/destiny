// upstream dmd issue 21495
extern (C++)
{
    enum string[string] meta = [
        "hellos": "worlds"
    ];

    struct metas
    {
        static foreach (key, value; meta)
        {
            mixin("enum string " ~ key ~ " = `" ~ value ~ "`;");
        }
    }
}
