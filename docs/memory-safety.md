# Memory safety in Destiny

Destiny aims to be memory safe by default. This guide describes what the
compiler checks today and how to write code that passes the checks. It grows
with each step of the
[memory safety design](specs/2026-11-12-destiny-memory-safety-design.md).

| Feature | Status |
|---|---|
| Scope checking (no dangling pointers to the stack) in `@safe` code | **always on** |
| `@safe` as the default for functions | **on** |
| Ownership and borrow checking | planned (sub-project 3) |
| Garbage-collected heap (no use-after-free for GC memory) | always on |

## `@safe`, `@trusted` and `@system`

Every function is one of:

- **`@safe`** — checked by the compiler: no pointer arithmetic, no unsafe
  casts, no `__gshared` data, no inline `asm`, and it only calls other `@safe`
  or `@trusted` functions. **This is the default.**
- **`@trusted`** — not checked, but callable from `@safe` code. You promise its
  interface is safe.
- **`@system`** — not checked, and not callable from `@safe` code.

Templates, lambdas, `auto` functions and nested functions have their safety
*inferred* from their body. Body-less `extern(C)`, `extern(C++)` etc.
declarations are `@system` (they are implemented outside Destiny).

### Which one do I use?

| Use | When |
|---|---|
| nothing (`@safe`) | normal code |
| `@system` | the function is unsafe **to call**: it takes raw pointers, frees or reuses memory, calls C, or relies on the caller to get something right |
| `@trusted` | the function is safe to call **from anywhere** with any arguments, but its body cannot be checked (it calls C or uses pointers internally) |

Rules of thumb:

- Prefer `@system` over `@trusted`. `@trusted` is a promise the compiler cannot
  check; a wrong one is a memory bug that `@safe` code cannot see.
- Keep `@trusted` functions **small**, and put a comment saying why they are
  safe. Make the unsafe part small rather than marking a large function.
- Never make a function `@trusted` if some argument could make it misbehave
  (for example a pointer and a length that may not match).
- **Callbacks count as arguments.** A function that stores or runs a
  `void delegate()` it was given will run code that was never checked. Give it
  two overloads: a `@trusted` one taking `void delegate() @safe`, and a
  `@system` one taking any delegate. The library does this for `Thread`,
  `Fiber` (constructors and `reset`) and Fate's `Scheduler` (`start`, `spawn`,
  which are `@system`):

  ```d
  void work() {}                 // @safe by default
  @system void raw() {}

  void main()                    // @safe by default
  {
      auto t = new Thread(&work);    // fine: runs @safe code
      // auto u = new Thread(&raw);  // error: Thread.this(void function()) is @system
  }
  ```

```d
// @system: the caller must pass a valid buffer of `len` bytes
@system void fill(ubyte* buf, size_t len) { buf[0 .. len] = 0; }

// @trusted: any slice is valid, so no caller can misuse it
@trusted void zero(ubyte[] buf) { fill(buf.ptr, buf.length); }

void user()            // @safe by default
{
    ubyte[16] b;
    zero(b[]);         // fine
    // fill(b.ptr, 99); // error: @safe function cannot call @system function
}
```

### Opting a whole module out

`@system:` at the top of a module (or a `@system { }` block) brings back
upstream's default for the declarations after it:

- unannotated functions are `@system` (unchecked);
- templates, function literals and `auto` functions still **infer** their
  safety, and overriding methods still **inherit** it from the method they
  override;
- member functions of types declared inside a function (and inside the
  label or block) are `@system`, as in upstream, instead of inferred;
- variables are not affected: a variable is `@system` only when it is
  annotated itself (`@system int* p;`).

A `@system` written on the function itself is always exact.

```d
@system:
void raw(int* p) { p++; }          // @system: unchecked
auto twice()(int x) => 2 * x;      // inferred @safe, callable from @safe code
class C : Base { override void f() {} }   // inherits Base.f's @safe
```

### What the compiler tells you

When a function that is `@safe` only by default does something unsafe, the
first error is followed by a hint:

```
app.d(12): Error: pointer arithmetic is not allowed in a `@safe` function
app.d(10):        `app.byDefault` is `@safe` by default. If it must do this, mark it
                  `@system`, or move the unsafe part into a small `@trusted` function
                  with a safe interface
```

Functions you marked `@safe` yourself do not get the hint.

## Scope checking

In `@safe` code the compiler tracks how long references to stack memory live,
and rejects code where one could outlive what it points to. There is no flag to
turn this off (`-preview=dip1000` does nothing; `-revert=dip1000` is gone).

### What is rejected

```d
int* escapeParam(scope int* p) @safe { return p; }   // scope parameter returned
int* escapeLocal() @safe { int x; return &x; }        // address of a local returned

int* global;
void store(scope int* p) @safe { global = p; }        // scope value stored in a global
```

### What is allowed

Taking the address of a local, as long as the pointer stays inside its
lifetime:

```d
void ok() @safe
{
    int x;
    int* p = &x;    // p is inferred `scope`
    *p = 1;
}
```

### Annotations

| Annotation | Meaning |
|---|---|
| `scope T* p` | `p` is not stored anywhere that outlives the call |
| `return scope T* p` | `p` may be returned; the result has `p`'s lifetime |
| `return ref T x` | a reference to `x` may be returned (or stored in the first parameter) |

Inside templates, lambdas and `auto` functions these are inferred.

```d
int* identity(return scope int* p) @safe { return p; }

int sum(scope const(int)[] a) @safe
{
    int s;
    foreach (x; a) s += x;
    return s;
}
```

### `opApply`

Take the loop body delegate as `scope`:

```d
struct Range
{
    int opApply(scope int delegate(ref int) dg) { ... }
}
```

Without `scope`, `opApply` could keep the delegate, so a `foreach` body that
returns from the enclosing function becomes a GC-allocated closure. That costs
an allocation and is not allowed in `@nogc` code.

## Building druntime, Fate and your code

No flags are needed. druntime and Fate are built and tested with scope checking
on.
