import dshell;

int main()
{
    if (OS != "linux")
    {
        writefln("Skipping shared library test on %s.", OS);
        return DISABLED;
    }

    run("$DESTINY -m$MODEL -of$OUTPUT_BASE/a$EXE -defaultlib=libfate.so $EXTRA_FILES/test_shared.d");
    run("$OUTPUT_BASE/a$EXE", stdout, stderr, [
        "LD_LIBRARY_PATH" : "../../../fate/generated/"~OS~'/'~BUILD~'/'~MODEL
    ]);

    return 0;
}
