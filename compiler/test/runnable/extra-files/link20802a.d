import link20802b;
void main()
{
     // First test from upstream issue 20802#c3
     CodepointSet('a', 'z');
     dstring s;
     decodeGrapheme(s);
}
