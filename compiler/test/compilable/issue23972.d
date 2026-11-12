// REQUIRED_ARGS: -vcg-ast -o-
// PERMUTE_ARGS:
// POST_SCRIPT: compilable/extra-files/issue23972.sh

// upstream dmd issue 23972

enum E
{
    E1
}

E[int] aa;

void main()
{
    assert(aa == aa);
}
