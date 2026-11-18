/* TEST_OUTPUT:
---
fail_compilation/fail17612.d(16): Error: undefined identifier `string`
fail_compilation/fail17612.d(19): Error: `TypeInfo` not found. object.d may be incorrectly installed or corrupt.
fail_compilation/fail17612.d(19):        destiny might not be correctly installed. Run 'destiny -man' for installation instructions.
fail_compilation/fail17612.d(19):        config file: not found
---
*/

// upstream issue 17612

module object;

class Object
{
    string toString();
}

class TypeInfo {}
