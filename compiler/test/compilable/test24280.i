// EXTRA_SOURCES: imports/test24280b.i

struct timespec
{
    int s;
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

struct T;
