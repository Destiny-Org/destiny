// upstream issue 22724
// https://docs.microsoft.com/en-us/cpp/preprocessor/pragma-directives-and-the-pragma-keyword?view=msvc-170

__pragma(pack(push, 8))

typedef unsigned int size_t;

// upstream issue 23206

__declspec(noreturn) void abra(void);
