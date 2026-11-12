import std.array, std.stdio, std.process, std.algorithm;

auto filterEnv(T)(T env)
{
    // Windows shell output is not in UTF-8
    // upstream phobos pull request 7342
    return env.filter!(e => !e.key.among("BUILD_SOURCEVERSIONAUTHOR"));
}

void main()
{
    foreach (varPair; environment.toAA().byKeyValue.filterEnv.array.sort!"a.key < b.key")
    {
        if (varPair.key != "_")
        {
            writeln(varPair.key, "=", varPair.value);
        }
    }
}
