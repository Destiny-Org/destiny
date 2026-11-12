/* TEST_OUTPUT:
---
AliasSeq!((Attrib))
---
*/

// upstream issue 17545

module example;

struct Attrib {}

@Attrib enum TEST = 123;

pragma(msg, __traits(getAttributes,
                     __traits(getMember, example, "TEST")));
