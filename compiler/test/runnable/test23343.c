/* DISABLED: win linux freebsd openbsd osx32 dragonflybsd netbsd hurd
 */

/* upstream issue 23343
 */

int open(const char*, int, ...) asm("_" "open");

int main(){
    int fd = open("/dev/null", 0);
    return fd >= 0 ? 0 : 1;
}
