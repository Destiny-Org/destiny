// upstream issue 21956

noreturn[noreturn] nrnr;

void gun()
{
    foreach (a; nrnr){}
}

int main()
{
    noreturn[] empty;
    int val;
    foreach(el; empty) val++;
    return val;
}
