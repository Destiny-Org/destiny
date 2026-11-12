// upstream issue 22933

void fn()
{
    goto L;
    int x = 1;
  L:
    return;
}
