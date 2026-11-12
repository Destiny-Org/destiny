// upstream issue 19557
// Error: redundant linkage `extern (C++)`

extern(C++, "ns")
extern(C++, class)
struct test {}

extern(C++, class)
extern(C++, "ns")
struct test2 {}
