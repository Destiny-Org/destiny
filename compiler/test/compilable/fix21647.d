/*
REQUIRED_ARGS: -preview=rvaluerefparam
TEST_OUTPUT:
---
cast(void)0
cast(void)0
void
cast(void)0
cast(void)0
cast(void)0
void
---
*/


// upstream issue 21647

void foo() { return cast(void)1; }

void main(){}

alias V = void;

void test1() { pragma(msg, foo()); }
void test2() { pragma(msg, main()); }
void test3() { pragma(msg, V); }

pragma(msg, foo());
pragma(msg, main());
pragma(msg, V);

/*************************************************************/
// upstream issue 8255

struct G {}
struct F(T) { void f(ref T) {} }
pragma(msg, F!G().f(G.init));
