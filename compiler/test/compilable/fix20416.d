/* REQUIRED_ARGS:
*/

/********************************************/

// upstream issue 20416

alias P = int*;

ref P foo(return ref P);

P bar()
{
   P result;
   return foo(result);
}


/********************************************/

// upstream issue 20416


struct S
{
   string x;
   ref S foo() return;
}


S bar2()
{
   S result;
   return result.foo();
}
