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

// an override of a method that is @safe only by Destiny's default
// (Object.toString) is not checked as @safe under the switch; @safe code
// can still call it through Object (its body calls the @system `plain`)
class Doc
{
    override string toString() const { plain(); return "doc"; }
}
static assert(__traits(getFunctionAttributes, Doc.toString)[$ - 1] == "@trusted"); // not checked, still callable from @safe code
@safe string show(Object o) { return o.toString(); }
