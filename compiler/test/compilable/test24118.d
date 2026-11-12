// upstream issue 24118

void map(alias fun, T)(T[] arr)
{
    fun(arr);
}


void foo()
{
    if( __ctfe )
    {
        ["a", "b", "c"].map!( a => " " ~ a[0] );
    }
}
