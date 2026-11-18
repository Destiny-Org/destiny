/*
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test20245.d(31): Error: assigning reference to local variable `x` to non-scope parameter `ptr` calling `escape` is not allowed in a `@safe` function
fail_compilation/test20245.d(30):        `x` inferred `scope` because of `a = &x`
fail_compilation/test20245.d(31):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/test20245.d(32): Error: escaping a reference to parameter `x` by copying `&x` into allocated memory is not allowed in a `@safe` function
fail_compilation/test20245.d(33): Error: returning scope variable `a` is not allowed in a `@safe` function
fail_compilation/test20245.d(30):        `a` inferred `scope` because of `a = &x`
fail_compilation/test20245.d(33):        fix: return a copy (`.dup`) or memory allocated with `new`, or mark the function `@system` if this is intended
fail_compilation/test20245.d(37): Error: taking address of `scope` variable `x` with pointers is not allowed in a `@safe` function
fail_compilation/test20245.d(43): Error: assigning reference to local variable `x` to non-scope parameter `ptr` calling `escape` is not allowed in a `@safe` function
fail_compilation/test20245.d(42):        `x` inferred `scope` because of `a = &x`
fail_compilation/test20245.d(43):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/test20245.d(44): Error: escaping a reference to parameter `x` by copying `&x` into allocated memory is not allowed in a `@safe` function
fail_compilation/test20245.d(60): Error: assigning reference to local variable `price` to non-scope `this.minPrice` is not allowed in a `@safe` function
fail_compilation/test20245.d(79): Error: reference to local variable `this.content[]` calling non-scope member function `Exception.this()` is not allowed in a `@safe` function
fail_compilation/test20245.d(79):        `this` inferred `scope` because of `this.content[]`
fail_compilation/test20245.d(79):        fix: mark the member function `scope` if it does not keep `this`, or mark the function `@system` if this is intended
fail_compilation/test20245.d(99): Error: assigning reference to local variable `this` to non-scope parameter `content` calling `listUp` is not allowed in a `@safe` function
fail_compilation/test20245.d(92):        `content` is not `scope` because of `charPtr = content`
fail_compilation/test20245.d(99):        `this` inferred `scope` because of `&this.content`
fail_compilation/test20245.d(99):        fix: mark the parameter `scope` if the function does not keep it, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

// upstream issue 20245
@safe int* foo(ref int x) {
    int* a = &x;
    escape(&x);
    auto b = [&x];
    return a;
}

@safe int** foo(ref scope int* x) {
    int** a = &x;
    return a;
}

@safe int* foo(return ref int x) {
    int* a = &x;
    escape(&x);
    auto b = [&x];
    return a;
}

int* gPtr;
@safe void escape(int* ptr)
{
    gPtr = ptr;
}

// upstream issue 21212
class MinPointerRecorder
{
    int* minPrice;
    void update(ref int price) @safe
    {
        minPrice = &price; // Should not compile.
    }
}

void main() @safe
{
    auto r = new MinPointerRecorder;
    () { int mp = 42; r.update(mp); } ();
    () { ulong[1000] stomp = 13; } ();
    auto x = *r.minPrice; // "13"
}

// upstream issue 22782
struct DontDoThis
{
    immutable char[12] content;
    @safe this(char ch)
    {
        content[] = ch;
        throw new Exception(content[]);
    }
}

void main1() @safe
{
    DontDoThis('a');
}

// upstream issue 22783
const(char)* charPtr;

// argument is not, or should not be scope
auto listUp(const(char)* content) {charPtr = content;}

struct DontDoThis2
{
    char content;
    @safe escape()
    {
        listUp(&content);
    }
}
