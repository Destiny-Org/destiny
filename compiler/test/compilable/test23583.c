
// upstream issue 23580
// upstream issue 23581
// upstream issue 23582
// upstream issue 23583

#include <string.h>

void foo()
{
    memmove(0, 0, 0);
    memcpy(0, 0, 0);
    memset(0, 0, 0);
#if __APPLE__
    stpcpy(0, 0);
    stpncpy(0, 0, 0);
#endif
    strcat(0, 0);
    strcpy(0, 0);
    strncat(0, 0, 0);
    strncpy(0, 0, 0);
}
