// upstream issue 16213

enum Id(size_t i) = i;
void main()
{
    int[5] y;
    y[ Id!($) - 1 ] = 3;
}
