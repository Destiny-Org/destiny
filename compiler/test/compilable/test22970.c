// upstream issue 22970

int xs[5];
void fn()
{
    for (int *p = &xs[0]; p < &xs[5]; p++)
	;
}
