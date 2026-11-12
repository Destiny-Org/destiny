// upstream dmd issue 22254

void main()
{
    assert(assert(0, ""), "");
}
