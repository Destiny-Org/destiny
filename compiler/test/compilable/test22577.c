// upstream issue 22577

typedef int(func)(void);

int one(void) { return 1; }

func* const fp1 = &one;

func* const fp2 = one;
