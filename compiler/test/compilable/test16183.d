// upstream issue 16183

void main()
{
    const string g(const string s) { return s; }
    enum string y = ['f'] ~ g("g");
}
