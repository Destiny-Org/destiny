// upstream dmd issue 20499
typedef struct Foo {
    int x;
} *pFoo;

struct Bar {
    struct Foo foo;
};
