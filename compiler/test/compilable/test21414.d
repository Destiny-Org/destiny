// upstream issue 21414

struct State
{
    string s;

    immutable this(string s)
    {
        this.s = s;
    }
}

immutable rootState = new immutable State("b");
