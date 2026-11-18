
/* Compiler implementation of the Destiny programming language
 * Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * written by Walter Bright
 * https://www.digitalmars.com
 * Distributed under the Boost Software License, Version 1.0.
 * https://www.boost.org/LICENSE_1_0.txt
 * https://github.com/Destiny-Org/destiny/blob/main/src/destiny/root/dsystem.h
 */

#pragma once

// Get common system includes from the host.

#define __C99FEATURES__ 1       // Needed on Solaris for NaN and more
#define __USE_ISOC99 1          // so signbit() gets defined

#ifndef __STDC_LIMIT_MACROS
#define __STDC_LIMIT_MACROS 1
#endif

#include <assert.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>

#include <new>
