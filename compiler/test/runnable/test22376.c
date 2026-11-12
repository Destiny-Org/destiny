/* RUN_OUTPUT:
---
xx need dictionary
---
 */

// upstream issue 22376

int printf(const char *, ...);

char * const errmsg[1] = {
    (char*)"need dictionary",
};

int main()
{
    printf("xx %s\n", errmsg[0]);
    return 0;
}
