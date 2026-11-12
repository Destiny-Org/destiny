/* REQUIRED_ARGS: -betterC
 */

// upstream issue 23606

string foo()()
{
    string a, b;
    return a ~ b;
}

enum s = foo();
