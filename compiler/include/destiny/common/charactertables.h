/**
 * Character tables related to identifiers.
 *
 * Supports UAX31, C99, C11 and least restrictive (All).
 *
 * Copyright: Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:   $(LINK2 https://cattermole.co.nz, Richard (Rikki) Andrew Cattermole)
 * License:   $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:    $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/common/charactertables.h, common/charactertables.d)
 */

#pragma once

enum class IdentifierTable
{
    UAX31,
    C99,
    C11,
    LR, // Least Restrictive aka All
};

struct IdentifierCharLookup final
{
    bool(*isStart)(char32_t);
    bool(*isContinue)(char32_t);

    // constructor not provided here.
    static IdentifierCharLookup forTable(IdentifierTable table);
};
