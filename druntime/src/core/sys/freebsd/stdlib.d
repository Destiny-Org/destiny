/**
  * D header file for FreeBSD stdlib.h.
  *
  * Copyright: Copyright © 2021, The D Language Foundation; Copyright (C) 2026 Destiny contributors
  * License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
  * Authors: Iain Buclaw
  */
module core.sys.freebsd.stdlib;
public import core.sys.posix.stdlib;

version (FreeBSD):
extern (C):
nothrow:
@nogc:

const(char)* getprogname();
void setprogname(scope const char* name);
