// upstream dmd issue 21241
enum {aValue=1};
static int foo(void){
    return aValue;
}

int getA(void){
    return foo();
}
