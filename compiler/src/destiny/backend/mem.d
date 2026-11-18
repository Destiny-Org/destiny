/**
 * Compiler implementation of the
 * $(LINK2 https://github.com/Destiny-Org/destiny, Destiny programming language).
 *
 * Copyright:   Copyright (C) 1985-1998 by Symantec
 *              Copyright (C) 2000-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/backend/mem.d, backend/mem.d)
 *
 */


module destiny.backend.mem;

import core.stdc.stdlib : malloc, calloc, realloc, free;
import core.stdc.string : strdup;

import destiny.backend.global : err_nomem;

nothrow:
@nogc:
@safe:

@trusted
char* mem_strdup(const char* s)
{
    auto p = strdup(s);
    if (!p && s)
        err_nomem();
    return p;
}

@trusted
void* mem_malloc(size_t u)
{
    auto p = malloc(u);
    if (!p && u)
        err_nomem();
    return p;
}

alias mem_fmalloc = mem_malloc;

@trusted
void* mem_calloc(size_t u)
{
    auto p = calloc(u, 1);
    if (!p && u)
        err_nomem();
    return p;
}

@trusted
void mem_free(void* p) { free(p); }

void mem_ffree(void *) { }
