// upstream issue 21898

alias Works(T) = immutable(T);
alias Fails(T) = immutable T;

static assert(is(Works!int == immutable int));
static assert(is(Fails!int == immutable int));
