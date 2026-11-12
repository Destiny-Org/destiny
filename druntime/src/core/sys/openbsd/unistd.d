/**
  * D header file for OpenBSD unistd.h.
  *
  * Copyright: Copyright © 2021, The D Language Foundation; Copyright (C) 2026 Destiny contributors
  * License: <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
  * Authors: Brian Callahan
  */
module core.sys.openbsd.unistd;

version (OpenBSD):
extern (C):
nothrow:
@nogc:

public import core.sys.posix.sys.types;

public import core.sys.posix.unistd : getentropy;
int getthrname(pid_t, char*, size_t);
int pledge(const scope char*, const scope char*);
int setthrname(pid_t, const scope char*);
int unveil(const scope char*, const scope char*);

int closefrom(int);
