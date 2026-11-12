// upstream issue 22531

int main()
{
    void fn(void);
    fn();
    return 0;
}

void fn(void)
{
}
