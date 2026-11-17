# Memory safety in Destiny

Destiny aims to be memory safe by default. This guide describes what the
compiler checks today and how to write code that passes the checks. It grows
with each step of the
[memory safety design](specs/2026-11-12-destiny-memory-safety-design.md).

| Feature | Status |
|---|---|
| Scope checking (no dangling pointers to the stack) in `@safe` code | **always on** |
| `@safe` as the default for functions | planned (sub-project 2) |
| Ownership and borrow checking | planned (sub-project 3) |
| Garbage-collected heap (no use-after-free for GC memory) | always on |

## `@safe`, `@trusted` and `@system`

- `@safe` code is checked: no pointer arithmetic, no unsafe casts, and only
  calls to other `@safe` or `@trusted` functions.
- `@trusted` code is not checked, but can be called from `@safe` code. Use it
  only for small functions with a safe interface, and write down why they are
  safe.
- `@system` code is not checked and cannot be called from `@safe` code.

Today an unannotated function is `@system`; sub-project 2 changes that to
`@safe`.

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
