/*
REQUIRED_ARGS: -inline
PERMUTE_ARGS: -release -O
*/

// upstream issue 17072

import core.thread;

void main()
{
        Thread.sleep(dur!"msecs"(0));
}
