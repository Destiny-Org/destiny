shared static this() {
    throw new Exception("module constructor");
}

@system shared static ~this() {
    import core.stdc.stdio;
    puts("module destructor");
}

void main() {}
