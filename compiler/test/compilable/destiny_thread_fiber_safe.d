// Destiny: @safe code may start a Thread or Fiber that runs @safe code.
import core.thread;

void work() {}          // @safe by default

void main()
{
    auto t = new Thread(&work);
    auto f = new Fiber(&work);
    auto g = new Fiber(() { int x; x++; });
    f.reset(&work);
}
