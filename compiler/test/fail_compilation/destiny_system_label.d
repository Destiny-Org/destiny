/*
Destiny: `@system:` brings back upstream's default for what follows. Plain
functions are @system; templates still infer, overrides still inherit, and an
annotation on the function itself wins.
TEST_OUTPUT:
---
fail_compilation/destiny_system_label.d(21): Error: `@safe` function `destiny_system_label.bad` cannot call `@system` function `destiny_system_label.plain`
fail_compilation/destiny_system_label.d(16):        `destiny_system_label.plain` is declared here
---
*/

class B { void f() @safe {} }

@system:

void plain() { int* p; p++; }                // @system: unchecked
auto tmpl()() { return 1; }                   // inferred @safe
class C : B { override void f() {} }          // inherits @safe from B.f

void user() @safe { tmpl(); new C().f(); }   // fine
@safe void bad() { plain(); }                 // error: plain is @system
