// upstream dmd issue 23678
// REQUIRED_ARGS: -betterC

@system: struct S
{
    int value;

    this(int value)
    {
        this.value = value;
    }
}

S* place(S* result)
{
    return new(*result) S(42);
}
