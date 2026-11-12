//upstream issue 24078

void main()
{
    assert(["c"] ~ "a" ~ "b" == ["c", "a", "b"]);
}
