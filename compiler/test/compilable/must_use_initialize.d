// upstream issue 23236
// can't initialize a @mustuse member in constructor

import core.attribute;

@mustuse struct MyError { }

struct S
{
    MyError lastError;

    this(int x)
    {
        this.lastError = MyError();
    }
}
