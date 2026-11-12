// REQUIRED_ARGS: -preview=dip1008
// upstream issue 19317

class MyException: Exception {
    static int numInstances;
    this(string msg) {
        super(msg);
        ++numInstances;
    }

    ~this() {
        --numInstances;
    }
}

void main() {
    assert(MyException.numInstances == 0);

    try
        throw new MyException("oops");
    catch(MyException _)
        assert(MyException.numInstances == 1);

    assert(MyException.numInstances == 0);

    try
        throw new MyException("oops I did it again");
    catch(MyException)
        assert(MyException.numInstances == 1);

    assert(MyException.numInstances == 0);
}
