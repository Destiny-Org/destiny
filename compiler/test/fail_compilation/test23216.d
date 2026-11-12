/*
TEST_OUTPUT:
---
fail_compilation/test23216.d(23): Error: invalid `foreach_reverse` aggregate `r` of type `Range`
fail_compilation/test23216.d(23):        `foreach_reverse` works with bidirectional ranges (implementing `empty`, `back`, and `popBack`), aggregates implementing `opApplyReverse`, or the result of an aggregate's `.tupleof` property
fail_compilation/test23216.d(23):        https://github.com/Destiny-Org/fate/blob/main/std/range/primitives.d
---
*/

// upstream issue 23216
// Better Error Message For foreach_reverse Without Bidirectional Range

struct Range
{
    bool empty = true;
    int front = 0;
    void popFront() { }
}

void main()
{
    Range r;
    foreach_reverse (word; r) { }
}
