/*
DISABLED: win32 win64

Destiny: a Thread or Fiber runs its function later, unchecked, so passing a
@system function is only allowed from @system/@trusted code.
TEST_OUTPUT:
---
fail_compilation/destiny_thread_fiber_system.d(23): Error: `@safe` function `D main` cannot call `@system` constructor `core.thread.posix_impl.Thread.this`
$p:druntime/import/core/thread/posix_impl.d$($n$):        `core.thread.posix_impl.Thread.this` is declared here
fail_compilation/destiny_thread_fiber_system.d(21):        `D main` is `@safe` by default. If it must do this, mark it `@system`, or move the unsafe part into a small `@trusted` function with a safe interface
fail_compilation/destiny_thread_fiber_system.d(24): Error: `@safe` function `D main` cannot call `@system` constructor `core.thread.fiber.Fiber.this`
$p:druntime/import/core/thread/fiber/package.d$($n$):        `core.thread.fiber.Fiber.this` is declared here
fail_compilation/destiny_thread_fiber_system.d(25): Error: `@safe` function `D main` cannot call `@system` function `core.thread.fiber.base.FiberBase.reset`
$p:druntime/import/core/thread/fiber/base.d$($n$):        `core.thread.fiber.base.FiberBase.reset` is declared here
---
*/
import core.thread;

@system void unsafeWork() {}

void main()
{
    auto t = new Thread(&unsafeWork);
    auto f = new Fiber(&unsafeWork);
    f.reset(&unsafeWork);
}

@system void allowed()
{
    auto t = new Thread(&unsafeWork);
    auto f = new Fiber(&unsafeWork);
}
