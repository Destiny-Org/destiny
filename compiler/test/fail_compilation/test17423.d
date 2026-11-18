/* REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test17423.d(29): Error: assigning reference to local `this` to non-scope parameter `dlg` calling `opApply` is not allowed in a `@safe` function
fail_compilation/test17423.d(18):        `dlg` is not `scope` because of `this.myDlg = dlg`
fail_compilation/test17423.d(29):        `this` inferred `scope` because of `int(int _) => 0`
fail_compilation/test17423.d(29):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// upstream issue 17423

struct Bar
{
    int delegate(int) @safe myDlg;

    auto opApply(int delegate(int) @safe dlg) @safe {
        myDlg = dlg;
        return 0;
    }
}

struct Foo
{
    Bar o;
    int i = 3;

    this(int x) @safe {
        foreach(_; o) { i = 0; }
        i = x;
    }
}
