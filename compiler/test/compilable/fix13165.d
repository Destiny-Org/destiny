/* REQUIRED_ARGS: -w -profile
 */

// upstream issue 13165

void main()
{
    int i;
    if (!i)
        throw new Exception("Error");
    assert(0);
}
