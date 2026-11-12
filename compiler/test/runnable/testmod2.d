// EXTRA_SOURCES: imports/testmod2a.d

/**********************************/
// upstream issue 1904

import imports.testmod2a;
void main()
{
    void whatever() {}
    foo!(whatever)();
}
