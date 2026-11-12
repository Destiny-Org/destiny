/**
  * D header file for DragonFlyBSD string.
  *
  * Copyright: Copyright © 2019, The D Language Foundation; Copyright (C) 2026 Destiny contributors
  * License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
  * Authors: Emily Castellotti
  */
module core.sys.dragonflybsd.string;

public import core.stdc.string;
import core.sys.dragonflybsd.sys.cdefs;

version (DragonFlyBSD):
extern (C):
nothrow:
@nogc:

static if (__BSD_VISIBLE)
{
    pure void* memmem(return scope const void* haystack, size_t haystacklen, scope const void* needle, size_t needlelen);
}
