/* REQUIRED_ARGS: -O
 * PERMUTE_ARGS:
 */

// upstream issue 18534

auto blah(char ch) { return ch; }

auto foo(int i)
{
    return blah(i ? 'A' : 'A');
}

void main()
{
    auto c = foo(0);
    assert(c == 'A');
}
