// upstream issue 22757

typedef struct S S;

struct T {
    int x;
};
struct S {
    struct T *pChunk;
};
void foo(struct S pS){
    void *p = &pS.pChunk;
}
