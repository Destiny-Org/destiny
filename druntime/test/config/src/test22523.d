// upstream issue 22523

@system: import core.stdc.stdio : puts;

int main()
{
    puts("Executed main although it should be skipped!");
    return 1;
}

unittest {}
