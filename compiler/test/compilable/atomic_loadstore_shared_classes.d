// REQUIRED_ARGS: -preview=nosharedaccess
import core.atomic;

class Foo
{
}

shared Foo toLoad;

void oops()
{
    auto f0 = new shared Foo;
    auto f1 = new shared Foo;
    atomicStore(f0, f1);

    // upstream issue 24846
    shared(Foo) f2 = atomicLoad(toLoad);
}
