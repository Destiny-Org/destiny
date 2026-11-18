module lib13774a;

void comdef()()
{
    __gshared int a;
}

@system void use1()
{
    comdef();
}
