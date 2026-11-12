/*
REQUIRED_ARGS: -preview=dip1021

upstream issue 20995
*/

void foo() @live
{
    throw new Exception("");
}

void main () {}
