# Sub-project 2: `@safe` by default — Design

Date: 2026-11-17
Status: Draft, awaiting review
Parent: [2026-11-12-destiny-memory-safety-design.md](2026-11-12-destiny-memory-safety-design.md)

## Goal

A function with no safety attribute is `@safe`. Unsafe operations need an
explicit `@system`, or `@trusted` for a safe interface around unsafe code.

## Rule

When a function gets no safety attribute from its declaration (or from an
enclosing `@safe:`/`@system:`/`@trusted:` block), its safety is:

| Function | Default |
|---|---|
| templates, lambdas, `auto` functions, nested functions | **inferred** (unchanged) |
| any other D function, with or without a body | **`@safe`** |
| `extern(C)`, `extern(C++)`, `extern(Windows)`, `extern(Objective-C)`, `extern(System)` declarations **without a body** | **`@system`** — they are implemented outside Destiny and cannot be checked |
| `extern(C)` etc. functions **with** a body | `@safe` (the body is checked) |
| ImportC (`.c` files) | `@system` |

Safety is part of the mangled name, so a body-less D declaration and its
implementation must agree; with this rule both default to `@safe`.

`-preview=safer` becomes a no-op (deprecated): unannotated code gets the full
`@safe` checks, which include everything `safer` checked.

## Measured starting point

Throwaway build in the `destiny-lang` VM with the rule above, each module
checked separately (`-o- -verrors=0`), duplicates removed:

| | Unique errors | Files with errors |
|---|---|---|
| druntime | 1,459 | 57 of 570 |
| Fate | 418 (about 100 are follow-on errors) | 68 of 171 |

Kinds, druntime: calls to `@system` functions (366), `__gshared` data (256),
unsafe casts (213), pointer indexing/arithmetic/slicing (226), `@system`
delegates (74), `.ptr` use (68), inline `asm`. Fate: the same kinds, plus `asm`
without annotation (46).

Largest: `core/internal/gc/impl/conservative/gc.d` (322),
`core/internal/backtrace/dwarf.d` (112), `core/thread/posix_impl.d` (95),
`object.d` (93), `rt/trace.d` (83); Fate `std/net/curl.d` (139).

## How the libraries are updated

Three tools, used in this order of preference:

1. **Make it actually safe** where that is a small change (e.g. slice instead
   of pointer + length, `.idup` instead of a cast).
2. **`@system`** for code that is low-level by nature and only called from
   other low-level code. Inherently unsafe modules get `@system:` at the top:
   the GC implementations, `rt/*`, thread internals, exception handling
   (`deh*`), backtrace decoding, C bindings in `core.sys.*`/`core.stdc.*`
   with bodies, Fate's `etc.c.*`.
3. **`@trusted`** only for a function whose *interface* is safe (no caller can
   cause memory corruption through it) but whose body is not checkable. Every
   new `@trusted` gets a one-line comment saying why it is safe, and is listed
   for review in sub-project 4.

Public API functions that `@safe` user code must be able to call (for example
`GC.malloc`-style entry points, `Thread.start`, `std.stdio`) get `@trusted`
wrappers or stay explicitly `@system` where they really are unsafe
(`GC.free`, raw allocation).

Work goes package by package, building and testing in the VM after each:
druntime `core.internal.gc` → `core.thread` → `rt` → `core.internal.backtrace`
→ `object.d` and the rest → Fate, starting with `std.net.curl`, `zlib`,
`bitmanip`, allocators, `concurrency`.

## Compiler test suite

Not measurable until the libraries build. Expected: many test files use
pointers in unannotated functions. Fix per test: add `@system` to the test
functions (or `@system:` at the top of the test file) where the test is not
about safety; keep and update tests that are about safety. Tests of
`-preview=safer` are updated or removed.

## Tests added

- unannotated function doing pointer arithmetic → error, no flags;
- body-less `extern(C)` declaration callable only from `@system`/`@trusted`;
- `extern(C)` function with a body is checked as `@safe`;
- template / lambda safety still inferred;
- ImportC unaffected;
- `-preview=safer` is a no-op.

## Documentation

Changelog `destiny.safe-default.dd`, spec (`function.dd` safety section,
`memory-safe-d.dd`, `attribute.dd`), `docs/memory-safety.md` (`@safe` default
section, how to port code: when to use `@system` vs `@trusted`).

## Done when

In the VM: druntime and Fate build; compiler test suite, druntime and all Fate
unittests pass; the list of added `@trusted` functions is in
`docs/memory-safety.md` or a review file.

## Risks

- **`@trusted` overuse** would hide real unsafety. Mitigated by preferring
  `@system`, the comment rule and the sub-project 4 review.
- **Size**: about 1,900 errors across ~125 files, mostly mechanical
  (`@system:` per module). Several sessions of work.
- **Self-hosting**: the compiler's own source is not affected yet (it is built
  by the host dmd); it will be when Destiny builds itself.
