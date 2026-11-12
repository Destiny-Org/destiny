// REQUIRED_ARGS: -g

// upstream issue 104
// fails only with -g

Foofunc f;
alias int Foo;
alias int function(Foo) Foofunc;
