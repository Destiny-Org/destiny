/*
REQUIRED_ARGS: -mixin=${RESULTS_DIR}/runnable/mixin.mixin -o-
OUTPUT_FILES: ${RESULTS_DIR}/runnable/mixin.mixin

TEST_OUTPUT:
----
=== ${RESULTS_DIR}/runnable/mixin.mixin
// expansion at compilable/mixin.d(14)
int x =
        123;

        int y;



        int z = x + y;
----

upstream issue 1870
upstream issue 12790
*/

#line 1
string get()
{
    return "int x =\n        123;\r\n" ~
    q{
        int y;



        int z = x + y;};
}

void main()
{
    mixin(get());
}
