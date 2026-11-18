/**
REQUIRED_ARGS:
TEST_OUTPUT:
---
fail_compilation/test23491.d(19): Error: reference to local variable `buffer` assigned to non-scope anonymous parameter is not allowed in a `@safe` function
fail_compilation/test23491.d(19):        fix: mark the parameter `scope` if it is not kept, or pass a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/test23491.d(20): Error: assigning reference to local variable `buffer` to non-scope anonymous parameter calling `sinkF` is not allowed in a `@safe` function
fail_compilation/test23491.d(20):        fix: mark the parameter `scope` if it is not kept, or pass a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/test23491.d(21): Error: assigning reference to local variable `buffer` to non-scope parameter `buf` is not allowed in a `@safe` function
fail_compilation/test23491.d(21):        fix: mark the parameter `scope` if it is not kept, or pass a copy (`.dup`), or mark the function `@system` if this is intended
---
*/

void sinkF(char[]) @safe;

void toString(void delegate (char[]) @safe sink, void delegate(char[] buf) @safe sinkNamed) @safe
{
    char[20] buffer = void;
    sink(buffer[]);
	sinkF(buffer[]);
	sinkNamed(buffer[]);
}
