// PERMUTE_ARGS:
// EXTRA_FILES: imports/test68a.d
// upstream issue 4278

import imports.test68a;

class Foo : OtherModuleClass
{
        override void foo()
        {
                super.foo();
        }
}

void main()
{
        new Foo();
}
