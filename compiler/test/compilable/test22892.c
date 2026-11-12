// upstream issue 22892

char buf[1];
void fn() { char c = *buf; }
