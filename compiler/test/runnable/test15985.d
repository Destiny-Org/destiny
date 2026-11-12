/* PERMUTE_ARGS: -allinst
 */

// upstream issue 15985

void ff()()
{
    gg!()();
    hh!()();
}

void gg()() { ff!()(); }
void hh()() { ff!()(); }

enum x = is(typeof(ff!()()));
alias my_g = gg!();

int main() { return 0; }
