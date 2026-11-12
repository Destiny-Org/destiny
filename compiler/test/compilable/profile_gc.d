// REQUIRED_ARGS: -profile=gc

// upstream issue 23874
string myToString()
{
    return "";
}

enum x = myToString ~ "";
immutable x2 = myToString ~ "";

// upstream dmd issue 22842
struct UpaTester{}
UpaTester[] test(){return [UpaTester()];}
