
/* Compiler implementation of the Destiny programming language
 * Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * written by Walter Bright
 * https://www.digitalmars.com
 * Distributed under the Boost Software License, Version 1.0.
 * https://www.boost.org/LICENSE_1_0.txt
 * https://github.com/Destiny-Org/destiny/blob/main/src/destiny/nspace.h
 */

#pragma once

#include "dsymbol.h"

/* A namespace corresponding to a C++ namespace.
 * Implies extern(C++).
 */

class Nspace final : public ScopeDsymbol
{
  public:
    Expression *identExp;
    Nspace *syntaxCopy(Dsymbol *s) override;
    const char *kind() const override;
    void accept(Visitor *v) override { v->visit(this); }
};
