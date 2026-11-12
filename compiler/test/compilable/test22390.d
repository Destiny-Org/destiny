// upstream issue 22390

int main()
{
    noreturn[] empty;
    assert(empty == empty);
    return 0;
}
