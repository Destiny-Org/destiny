# `@trusted` review: druntime and Fate

Making `@safe` the default meant deciding, for every library function that
does unchecked work, between `@system` (callers must be careful) and
`@trusted` (safe for **every** possible argument). This file lists every
`@trusted` that sub-project 2 added, and why each one is safe to call from
`@safe` code. Anything that did not meet the bar is `@system`.

The rule used throughout (see [memory-safety.md](memory-safety.md)):

1. No argument may make the function misbehave: no pointer plus a length that
   can disagree, no raw C string, no memory to free or reuse.
2. Callbacks count as arguments. A function that runs a delegate it was given
   is `@trusted` only for `@safe` delegates; a second `@system` overload takes
   any delegate.
3. Each `@trusted` is small, and the reason is written next to it.

## Callbacks: `@trusted` for `@safe` callbacks only

Each of these has a `@system` twin that takes any callback.

| Function | File |
|---|---|
| `Thread` constructors (`function`/`delegate`) | `core/thread/{threadbase,osthread,posix_impl,windows_impl,stub_impl}.d` |
| `Fiber`/`FiberBase` constructors, `reset(fn)`, `reset(dg)` | `core/thread/fiber/{base,package}.d` |
| `ThreadGroup.create`, `ThreadGroup.opApply` | `core/thread/threadgroup.d` |
| `Throwable.opApply`, `Throwable.toString(sink)` | `object.d` |
| `ModuleInfo.opApply` | `object.d` |
| `Throwable.TraceInfo.opApply` (final, in the interface) | `object.d` |
| `InputRange.opApply` (final, in the interface; `Generator` uses it) | Fate `std/range/interfaces.d`, `std/concurrency.d` |

## Thread, fiber and synchronisation operations

These operate on an object the caller already holds; none take pointers.

| Function | File | Why it is safe |
|---|---|---|
| `Thread.start`, `join`, `priority`, `yield`, destructor | `core/thread/posix_impl.d` | the thread object owns its handle; `join` rethrows the thread's exception |
| `Fiber.call`, `reset()`, `yield`, `yieldAndThrow`, destructor | `core/thread/fiber/base.d` | the fiber's function was checked when it was created (rule 2) |
| `Condition` `wait`/`notify`/`notifyAll`, destructor | `core/sync/condition.d` | wraps the OS condition this object owns |
| `Semaphore`, `Event`, `Barrier` operations | `core/sync/{semaphore,event,barrier}.d` | same: OS objects owned by `this` |

## Runtime services

| Function | File | Why it is safe |
|---|---|---|
| `onAssertError`, `onAssertErrorMsg`, `onUnittestErrorMsg`, `onNullPointerError` | `core/exception.d` | take D strings, throw |
| `_d_assert`, `_d_assert_msg` | `core/exception.d` | take D strings, throw (the `…p` variants taking a C string are `@system`) |
| `Runtime.args` | `core/runtime.d` | returns the program arguments as D strings |
| `dmd_coverSourcePath`, `dmd_coverDestPath`, `dmd_coverSetMerge` | `core/runtime.d` | store a setting |
| `DefaultTraceInfo.toString` | `core/runtime.d` | formats into a new string |
| `Throwable.toString()` | `object.d` | builds a new string with its own sink |
| `TypeInfo_Class.find`, `ModuleInfo.name`, `importedModules`, `localClasses` | `object.d` | read immutable runtime tables |
| `TypeInfo_Av.next`, `TypeInfoArrayGeneric.next` | `rt/util/typeinfo.d` | only cast `typeid(...)` to `inout` |
| `ConservativeGC.stats`, `debugTypeName` | `core/internal/gc/impl/conservative/gc.d` | return counters / a type name |
| valgrind wrappers (`makeMem*`, `get/setVBits`, `*AddrReportingInRange`) | `etc/valgrind/valgrind.d` | take slices, and only change valgrind's bookkeeping, not memory |

## Fate

| Function | File | Why it is safe |
|---|---|---|
| `asArray` | `std/digest/package.d` | length checked with `assert(0)`, which release builds keep |
| `AscendingPageAllocator.owns`, constructor, `getAvailableSize` | `std/experimental/allocator/building_blocks/ascending_page_allocator.d` | compare addresses / reserve fresh pages / compute a size |
| `LockingTextReader` postblit | `std/stdio.d` | re-locks the `FILE` the reader already holds |
| `kill(Pid)`, `kill(Pid, int)` | `std/process.d` | signal a process the validated `Pid` owns; no memory access |
| `makeGlobal` (`stdin`, `stdout`, `stderr`) | `std/stdio.d` | initialised exactly once under a spinlock; every `File` operation locks. Caveat: reassigning a standard handle from several threads at once is a data race |

## Made `@system` on purpose (were `@trusted` or would have defaulted to `@safe`)

- `Object.factory`, `TypeInfo_Class.create`: run a default constructor that may
  be `@system`.
- `_d_assertp`, `_d_arrayboundsp`, `_d_arraybounds_slicep`,
  `_d_arraybounds_indexp`, `_d_nullpointerp`: take a raw C string.
- `std.experimental.allocator` interfaces and implementations (`allocate`,
  `deallocate`, `reallocate`, `expand`, ...): free or reuse caller memory, or
  hand out memory inside the allocator.
- `std.concurrency.Scheduler.start`/`spawn` and implementations, the regex
  matcher factory's `construct`, `std.internal.digest` assembly.
- Fiber stack internals, `TypeInfo` `equals`/`compare`/`swap`/`destroy`/`postblit`,
  and the `GC` interface methods (except those `@safe` upstream).
