// upstream issue 21939
/*
TEST_OUTPUT:
---
fail_compilation/test21939.d(11): Error: invalid `foreach` aggregate `Object` of type `Object`
fail_compilation/test21939.d(11):        `foreach` works with input ranges (implementing `empty`, `front`, and `popFront`), aggregates implementing `opApply`, or the result of an aggregate's `.tupleof` property
fail_compilation/test21939.d(11):        https://github.com/Destiny-Org/fate/blob/main/std/range/primitives.d
---
*/

static foreach (a; Object) {}
