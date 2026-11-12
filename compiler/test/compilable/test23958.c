// upstream issue 23958

#include <stdio.h>

int main() {
    char buf[8];
    sprintf(buf, "%d", 123);
}
