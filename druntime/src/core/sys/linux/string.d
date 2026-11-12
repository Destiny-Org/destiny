/**
  * D header file for Linux string.
  *
  * Copyright: Copyright © 2019, The D Language Foundation; Copyright (C) 2026 Destiny contributors
  * License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
  * Authors: Emily Castellotti
  */
module core.sys.linux.string;

public import core.stdc.string;
import core.sys.linux.config;

version (linux):
extern (C):
nothrow:
@nogc:

static if (_GNU_SOURCE)
{
    pure void* memmem(return scope const void* haystack, size_t haystacklen, scope const void* needle, size_t needlelen);
    /// return string describing error number
    const(char)* strerrorname_np(int);
    /// ditto
    const(char)* strerrordesc_np(int);
}
