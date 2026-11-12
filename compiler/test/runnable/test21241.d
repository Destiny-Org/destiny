/*
REQUIRED_ARGS: runnable/imports/imp21241a.c runnable/imports/imp21241b.c
*/
// upstream dmd issue 21241
import imp21241a;
import imp21241b;

void main(){
    int x = getA();
    assert(x==aValue);
    x = getB();
    assert(x==bValue);
}
