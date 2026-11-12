// upstream issue 22929

extern int xs[];
void fn() { void *xp = &(xs[0]); }

struct S { char text[4]; };
extern struct S ops[];
char *args[] = { ops[1].text };
