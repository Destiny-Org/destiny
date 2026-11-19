// Simply generate some garbage.
// This program should not trigger any Valgrind warnings.

@system void main() // Destiny: deliberately unsafe, checked by valgrind
{
    foreach (i; 0..100)
    {
        string s;
        foreach (j; 0..1000)
            s ~= 'x';
    }
}
