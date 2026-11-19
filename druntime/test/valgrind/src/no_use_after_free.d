// Explicit use-after-free.

import core.memory;

@system int main() // Destiny: deliberately unsafe, checked by valgrind
{
    auto p = cast(int*)GC.malloc(int.sizeof * 3);
    GC.free(p);
    return *p;
}
