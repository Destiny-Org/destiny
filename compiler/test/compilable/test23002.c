/* upstream issue 23002
 */

typedef int x;
struct S { x x; };
struct T { x *x; };
union U { x x; };
