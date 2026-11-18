/* COMPILE_SEPARATELY:
 * EXTRA_SOURCES: imports/maker.i imports/freer.i
 */

// upstream issue 23387

/+ maker.i
typedef struct Foo *FooRef;
struct Foo {
    int x;
};
FooRef make_foo(void);
+/
@system: import imports.maker;


/+ freer.i
typedef struct Foo *FooRef;
struct Foo {
    int x;
};
void free_foo(FooRef foo);
+/
import imports.freer;

int main(){
    FooRef f = make_foo();
    free_foo(f);
    return 0;
}
