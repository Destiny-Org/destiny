struct S;

struct timespec
{
    int s;
};

typedef struct timespec Clock;

Clock now()
{
    Clock result;
    return result;
}

struct S
{
    Clock clock;
};

/* upstream issue 24303 */

typedef struct {} Slice;

struct Lang
{
    Slice *slices;
};

void langmap(struct Lang *self)
{
    Slice slice = *self->slices;
}

/* upstream issue 24306 */

struct T { };
