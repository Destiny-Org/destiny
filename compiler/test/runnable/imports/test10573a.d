module imports.test10573a; @system:

abstract class base {}
class mysql : base {}

class handler
{
    private mysql[int] mysql_servers;
    public void foo()
    {
        base[int] hServers = cast(base[int])mysql_servers;
    }
}
