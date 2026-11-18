/*
REQUIRED_ARGS: -revert=safedefault
*/
// Destiny: under `-revert=safedefault`, a class implementing a bundled
// library interface whose methods are @safe only by default (here Fate's
// Scheduler: `void yield() nothrow;`) gets @trusted implementations, the
// same rule as for overrides of class methods. This also needs
// addStorageClass to keep STC.trusted (it used to drop it).
import core.sync.condition : Condition;
import core.sync.mutex : Mutex;
import std.concurrency : Scheduler, ThreadInfo;

final class S : Scheduler
{
    override void start(void delegate() op) { op(); }
    override void spawn(void delegate() op) { op(); }
    override void yield() {}
    override @property ref ThreadInfo thisInfo() { return ThreadInfo.thisInfo; }
    override Condition newCondition(Mutex m) { return null; }
}

static assert(__traits(getFunctionAttributes, S.yield)[$ - 1] == "@trusted");
