// LINK:

// test __builtin_va_start and __builtin_va_end
// upstream issue 21974
// upstream issue 22589

typedef __builtin_va_list __gnuc_va_list;
typedef __gnuc_va_list va_list;

int test21974a(const char *format, va_list va)
{
    return 0;
}

int test21974(const char *format, ...)
{
    va_list va;
    int ret;

    __builtin_va_start(va,format);
    ret = test21974a(format, va);
    __builtin_va_end(va);
    return ret;
}

void main() {}
