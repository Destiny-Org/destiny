// REQUIRED_ARGS: -mixin=${RESULTS_DIR}/fail_compilation/mixin_test.mixin
/*
TEST_OUTPUT:
---
{{RESULTS_DIR}}/fail_compilation/mixin_test.mixin(7): Error: undefined identifier `b`
---
*/

// upstream issue 1870
// upstream issue 12790
string get()
{
    return
    q{int x;
        int y;



        int z = x + b;};
}

void main()
{
    mixin(get());
}
