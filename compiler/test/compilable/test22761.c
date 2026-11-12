
// upstream issue 22761

extern long reg22344 (long adler, const char *buf, int len);

long reg22344(adler, buf, len)
    long adler;
    const char *buf;
    int len;
{
    return 0;
}

// upstream issue 22896

void fn(int);
void fn(const int x);
