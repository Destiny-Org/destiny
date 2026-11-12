/**
  * D header file for Darwin stdlib.h.
  *
  * Copyright: Copyright © 2021, The D Language Foundation; Copyright (C) 2026 Destiny contributors
  * License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
  * Authors: Iain Buclaw
  */
module core.sys.darwin.stdlib;
public import core.sys.posix.stdlib;

version (OSX)
    version = Darwin;
else version (iOS)
    version = Darwin;
else version (TVOS)
    version = Darwin;
else version (WatchOS)
    version = Darwin;

version (Darwin):
extern (C):
nothrow:
@nogc:

const(char)* getprogname();
void setprogname(scope const char* name);
