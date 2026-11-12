module imports.testcontracts;

/***************************************************/
// upstream issue 3602

class Base3602
{
   void method(int x, int y)
   in
   {
       assert(x > 0);
       assert(y > 0);
   }
   do
   {
   }
}

/***************************************************/
// upstream issue 5230

class Base5230
{
    int method()
    out (res)
    {
    }
    do
    {
        return 42;
    }
}
