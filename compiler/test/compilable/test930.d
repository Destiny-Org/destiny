// upstream issue 930
template ATemplate(T)
{
   template ATemplate()
   {
       auto foo()
       {
           T x = 2; // this line causes an error
       }
   }
}

class TheClass(alias MixIt)
{
    mixin MixIt!();
}

void main()
{
    auto val = new TheClass!(ATemplate!(int));
    val.foo();
}
