/*
PERMUTE_ARGS:

upstream issue 17123
 */

void test()
{
    char[256] buffer;

    char[] delegate() read = () {
        return buffer[];
    };
}
