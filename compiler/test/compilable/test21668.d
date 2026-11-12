// upstream issue 21668

struct Opaque;

void byPtr(Opaque*) {}
void byRef(ref Opaque) {} // Fails
void bySlice(Opaque[]) {}
