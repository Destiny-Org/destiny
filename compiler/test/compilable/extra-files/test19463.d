// upstream issue 19463

void test() @nogc
{
    throw new Exception("wat");
}
