// Out-of-bounds access (within the same block).

@system void main() // Destiny: deliberately unsafe, checked by valgrind
{
    auto arr = new ubyte[4];
    arr.ptr[5] = 2;
}
