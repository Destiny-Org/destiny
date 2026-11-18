
/* Compiler implementation of the Destiny programming language
 * Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * written by Walter Bright
 * https://www.digitalmars.com
 * Distributed under the Boost Software License, Version 1.0.
 * https://www.boost.org/LICENSE_1_0.txt
 * https://github.com/Destiny-Org/destiny/blob/main/src/destiny/json.h
 */

#pragma once

#include "arraytypes.h"
#include "globals.h"

struct OutBuffer;

namespace destiny
{
    void json_generate(Modules &, OutBuffer &);
    JsonFieldFlags tryParseJsonField(const char *fieldName);
}
