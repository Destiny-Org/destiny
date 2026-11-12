/* upstream issue 23025
 */

const char *s; // tentative definition
const char *s = "hello"; // definition
int puts(const char*);
int main(void){
    puts(s);
    return 0;
}
