// upstream issue 20296

extern (C++)
void foo(T...)(T args)
{
}

alias F = foo!(char*);
