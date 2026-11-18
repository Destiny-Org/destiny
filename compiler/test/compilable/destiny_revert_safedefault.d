/*
REQUIRED_ARGS: -revert=safedefault
*/
// Destiny: `-revert=safedefault` restores upstream's `@system` default
// (used to build the compiler's own sources, see docs/self-hosting.md).

void plain() { int* p; p++; }        // unchecked, as upstream
@safe void checked() {}
void inferred()() {}

static assert(__traits(getFunctionAttributes, plain) == AliasSeq!("@system"));
static assert(__traits(getFunctionAttributes, checked) == AliasSeq!("@safe"));
static assert(__traits(getFunctionAttributes, inferred!()) == AliasSeq!("pure", "nothrow", "@nogc", "@safe"));

// the bundled libraries keep their (prebuilt) @safe default
static assert(__traits(getFunctionAttributes, Object.toString) == AliasSeq!("@safe"));

alias AliasSeq(T...) = T;
