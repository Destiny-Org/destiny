
__gshared int initVar;

pragma(crt_constructor)
@system void mir_cpuid_crt_init()
{
    initVar = 42;
}
