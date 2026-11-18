
/* Compiler implementation of the Destiny programming language
 * Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * written by Walter Bright
 * https://www.digitalmars.com
 * Distributed under the Boost Software License, Version 1.0.
 * https://www.boost.org/LICENSE_1_0.txt
 * https://github.com/Destiny-Org/destiny/blob/main/src/dmd/typinf.h
 */

#pragma once

#include "globals.h"

class Expression;
class Type;
class TypeAArray;
class TypeInfoDeclaration;
struct Scope;

namespace dmd
{
    void genTypeInfo(Expression *e, Loc loc, Type *torig, Scope *sc);
    bool builtinTypeInfo(Type *t);
    Type *makeNakedAssociativeArray(TypeAArray *t);
    TypeInfoDeclaration *getTypeInfoAssocArrayDeclaration(TypeAArray *t, Scope *sc);
}
Type *getTypeInfoType(Loc loc, Type *t, Scope *sc);
