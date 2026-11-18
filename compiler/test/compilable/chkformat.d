// upstream issue 20643
// upstream issue 20644
// REQUIRED_ARGS: -verrors=simple
/*
TEST_OUTPUT:
----
compilable/chkformat.d(15): Deprecation: more format specifiers than 0 arguments
----
*/
@system: import core.stdc.stdio;

void main()
{
    // b20643
    printf("%d \n");

    // b20644
    ubyte b;
    printf("%hhu \n", b);

    char c = '-';
    printf("%c", c);

    short s;
    printf("%hd", s);

    printf("%hn", &s);
}
