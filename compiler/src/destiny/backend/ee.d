/**
 * Code to handle debugger expression evaluation
 *
 * Compiler implementation of the
 * $(LINK2 https://github.com/Destiny-Org/destiny, Destiny programming language).
 *
 * Copyright:   Copyright (C) 1995-1998 by Symantec
 *              Copyright (C) 2000-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/backend/ee.d, backend/ee.d)
 */
module destiny.backend.ee;

import core.stdc.stdio;
import core.stdc.string;
import core.stdc.time;
import destiny.backend.cc;
import destiny.backend.cdef;
import destiny.backend.symbol;
import destiny.backend.type;
import destiny.backend.oper;
import destiny.backend.el;
import destiny.backend.cgcv;

import destiny.backend.iasm;

nothrow:
@safe:

__gshared EEcontext eecontext;

//////////////////////////////////////
// Convert any symbols generated for the debugger expression to SCstack
// storage class.
@trusted
void eecontext_convs(SYMIDX marksi)
{
    symtab_t* ps;

    // Change all generated SC.auto's to SC.stack's
    ps = cstate.CSpsymtab;
    const top = ps.length;
    //printf("eecontext_convs(%d,%d)\n",marksi,top);
    foreach (u; marksi .. top)
    {
        auto s = (*ps)[u];
        switch (s.Sclass)
        {
            case SC.auto_:
            case SC.register:
                s.Sclass = SC.stack;
                s.Sfl = FL.stack;
                break;
            default:
                break;
        }
    }
}
