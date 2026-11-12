// upstream dmd issue 21225
void x(void){
}
#define x 3

typedef struct Foo {int y; } foo;
#define foo 3
