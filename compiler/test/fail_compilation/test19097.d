/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/test19097.d(59): Error: returning scope variable `s` is not allowed in a `@safe` function
fail_compilation/test19097.d(58):        `s` inferred `scope` because of `s = & i`
fail_compilation/test19097.d(59):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(63): Error: returning scope variable `s1` is not allowed in a `@safe` function
fail_compilation/test19097.d(62):        `s1` inferred `scope` because of `s1 = & i`
fail_compilation/test19097.d(63):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(92): Error: assigning scope variable `z` to `ref` variable `refPtr` with longer lifetime is not allowed in a `@safe` function
fail_compilation/test19097.d(92):        fix: store a copy (`.dup`) or memory that lives as long as the target (allocated with `new`), or mark the function `@system` if this is intended
fail_compilation/test19097.d(123): Error: returning scope variable `s4` is not allowed in a `@safe` function
fail_compilation/test19097.d(122):        `s4` inferred `scope` because of `s4 = & x`
fail_compilation/test19097.d(123):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(141): Error: returning scope variable `s5c` is not allowed in a `@safe` function
fail_compilation/test19097.d(140):        `s5c` inferred `scope` because of `s5c = i`
fail_compilation/test19097.d(141):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(145): Error: returning scope variable `s5m` is not allowed in a `@safe` function
fail_compilation/test19097.d(144):        `s5m` inferred `scope` because of `s5m = i`
fail_compilation/test19097.d(145):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(162): Error: returning scope variable `s6c` is not allowed in a `@safe` function
fail_compilation/test19097.d(161):        `s6c` inferred `scope` because of `s6c = i`
fail_compilation/test19097.d(162):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test19097.d(166): Error: returning scope variable `s6m` is not allowed in a `@safe` function
fail_compilation/test19097.d(165):        `s6m` inferred `scope` because of `s6m = i`
fail_compilation/test19097.d(166):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
---
 */

// Test extended return-scope / return-ref semantics, e.g. assigning to `this` or the first parameter

// upstream issue 19097

@safe:

void betty(ref scope int* r, return scope int* p)
{
    r = p;
}

void freddy(out scope int* r, return scope int* p)
{
    r = p;
}

struct S
{
    int* a;
    this(return scope int* b) scope { a = b; }

    int* c;
    void mem(return scope int* d) scope { c = d; }
}

S thorin()
{
    int i;
    S s = S(&i); // should infer scope for s
    return s;    // so this should error

    S s1;
    s1.mem(&i);
    return s1;
}

/************************/

struct S2(T)
{
    int* p;

    void silent(lazy void dg);

    void foo()
    {
        char[] name;
        silent(name = parseType());
    }

    char[] parseType(char[] name = null);
}

S2!int s2;

/************************/
struct S3
{
    int* ptr;
    void assign(ref int* refPtr, return scope int* z) scope @safe
    {
        this.ptr = z; // allowed, first ref
        refPtr = z; // should not be allowed
    }
}

int* escape() @safe
{
    int local;

    S3 escapeThis;
    int* escapeRef;

    escapeThis.assign(escapeRef, &local);

    return escapeRef;
}

/************************/
// upstream issue 22837
struct S4
{
    int* p;
    this(int dummy, return scope int* p) @safe
    {
        this.p = p;
    }
}

int* escape2()
{
    int x;
    auto s4 = S4(0, &x);
    return s4.p;
}

/************************/
// upstream issue 22801
struct S5
{
    int* a;
    this(return ref int b) { a = &b; }

    int* c;
    void mem(return ref int d) scope { c = &d; }
}

S5 frerin()
{
    int i;
    S5 s5c = S5(i); // should infer scope for s
    return s5c;    // so this should error

    S5 s5m;
    s5m.mem(i);
    return s5m;
}


struct S6
{
    int** a;
    this(return ref int* b) { a = &b; }

    int** c;
    void mem(return ref int* d) scope { c = &d; }
}

S6 dis()
{
    int* i = null;
    S6 s6c = S6(i); // should infer scope for s
    return s6c;    // so this should error

    S6 s6m;
    s6m.mem(i);
    return s6m;
}
