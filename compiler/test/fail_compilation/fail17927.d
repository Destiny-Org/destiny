/* REQUIRED_ARGS:
 * TEST_OUTPUT:
---
fail_compilation/fail17927.d(17): Error: scope parameter `this` may not be returned
fail_compilation/fail17927.d(17):        fix: mark the member function `return scope` so the result may refer to `this`, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/fail17927.d(19): Error: scope parameter `this` may not be returned
fail_compilation/fail17927.d(19):        fix: mark the member function `return scope` so the result may refer to `this`, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/fail17927.d(25): Error: scope parameter `ptr` may not be returned
fail_compilation/fail17927.d(25):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
fail_compilation/fail17927.d(27): Error: scope parameter `ptr` may not be returned
fail_compilation/fail17927.d(27):        fix: mark the parameter `return scope` so the result may refer to it, or return a copy (`.dup`), or mark the function `@system` if this is intended
---
*/
// upstream issue 17927

struct String {
    const(char)* mem1() const scope @safe { return ptr; }
    // upstream issue 22027
    inout(char)* mem2() inout scope @safe { return ptr; }

    char* ptr;
}


const(char)* foo1(scope const(char)* ptr) @safe { return ptr; }

inout(char)* foo2(scope inout(char)* ptr) @safe { return ptr; }
