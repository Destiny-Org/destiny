// upstream issue 23662
typedef enum {A} E;

E func(E v) {
    return v;
}
