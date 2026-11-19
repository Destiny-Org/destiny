// Out-of-bounds access (SENTINEL).

@system void main() // Destiny: deliberately unsafe, checked by valgrind
{
    auto arr = new ubyte[4];
    arr.ptr[-1] = 42;
}
