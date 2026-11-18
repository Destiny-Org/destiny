/*
REQUIRED_ARGS: -preview=systemVariables
Destiny: a `@system:` label (how code opts out of the @safe default) applies
to functions only. A variable is @system only when annotated directly.
TEST_OUTPUT:
---
fail_compilation/destiny_system_label_vars.d(12): Error: access `@system` variable `direct` is not allowed in a `@safe` function
fail_compilation/destiny_system_label_vars.d(15):        `direct` is declared here
---
*/

@safe void useDirect() { auto a = direct; }
@safe void useLabel() { auto b = label; }    // fine: the label does not apply to variables

@system int* direct;

@system:
void f() { auto c = direct; }                  // fine: f is @system via the label
int* label;
