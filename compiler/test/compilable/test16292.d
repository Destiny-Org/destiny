/* PERMUTE_ARGS:
 */
// upstream issue 16292

void main()
{
    goto label;
    if (makeS()[0])
    {
        label:
    }
}

S makeS() { return S(); }

struct S
{
    int opIndex(size_t i) { return 0; }
}
