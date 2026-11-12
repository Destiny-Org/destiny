// upstream issue 23214

typedef unsigned __int64 uintptr_t;

// upstream issue 24304

__uint16_t u16;
__uint32_t u32;
__uint64_t u64;

_Static_assert(sizeof(u16) == 2, "1");
_Static_assert(sizeof(u32) == 4, "2");
_Static_assert(sizeof(u64) == 8, "3");
