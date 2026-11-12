/* upstream issue 23262
 */

struct T()
{
    string[] tags;

    this(string[] tags...)
    {
        this.tags = tags; // don't infer `return` attribute for `tags`
    }
}

void test()
{
    T!() t;
}
