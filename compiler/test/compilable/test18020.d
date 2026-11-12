// upstream issue 18020

void bug(T)(T t)
{
    t.opCmp(t);
}

alias bugi = bug!(typeof(new class{}));
