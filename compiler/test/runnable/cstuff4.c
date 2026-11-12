// upstream issue 24264

struct S
{
    int small;
    int symbol;
};

inline int getSym(struct S self)
{
    return self.symbol;
}

_Bool
 symIs0(struct S self)
{
    return getSym(self) == 0;
}

int main(void)
{
    struct S s = {0, 0};
    __check(symIs0(s));
    return 0;
}
