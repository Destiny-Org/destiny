/**
 * Generate `TypeInfo` objects, which are needed for run-time introspection of types.
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/typinf.d, _typinf.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/typinf.d
 *
 */

module destiny.typinf;

import destiny.astenums;
import destiny.declaration;
import destiny.dmodule;
import destiny.dscope;
import destiny.dclass;
import destiny.dstruct;
import destiny.errors : fatal, Classification;
import destiny.errorsink;
import destiny.expression;
import destiny.hdrgen : toErrMsg;
import destiny.location;
import destiny.mtype;
import destiny.templatesem;
import destiny.typesem;
import destiny.dsymbolsem : addDeferredSemantic3;
import core.stdc.stdio;

/****************************************************
 * Generates the `TypeInfo` object associated with `torig` if it
 * hasn't already been generated
 * Params:
 *      e     = if not null, then expression for pretty-printing errors
 *      loc   = the location for reporting line numbers in errors
 *      torig = the type to generate the `TypeInfo` object for
 *      sc    = the scope
 */
void genTypeInfo(Expression e, Loc loc, Type torig, Scope* sc)
{
    // printf("genTypeInfo() %s\n", torig.toChars());
    import destiny.globals : global;
    auto eSink = global.errorSink;

    // Even when compiling without `useTypeInfo` (e.g. -betterC) we should
    // still be able to evaluate `TypeInfo` at compile-time, just not at runtime.
    // upstream issue 18472
    if (!sc || !sc.ctfe)
    {
        import destiny.globals : global;
        if (!global.params.useTypeInfo)
        {
            global.gag = 0;
            if (e)
                eSink.error(loc, "expression `%s` uses the GC and cannot be used with switch `-betterC`", e.toErrMsg());
            else
                eSink.error(loc, "`TypeInfo` cannot be used with `-betterC`");

            if (sc && sc.tinst)
                sc.tinst.printInstantiationTrace(Classification.error, uint.max);

            fatal();
        }
    }

    if (!Type.dtypeinfo)
    {
        eSink.error(loc, "`object.TypeInfo` could not be found, but is implicitly used");
        fatal();
    }

    import destiny.typesem : merge2;
    Type t = torig.merge2(); // do this since not all Type's are merge'd
    if (t.ty == Taarray)
        t = makeNakedAssociativeArray(cast(TypeAArray)t);

    if (!t.vtinfo)
    {
        if (t.isShared()) // does both 'shared' and 'shared const'
            t.vtinfo = TypeInfoSharedDeclaration.create(t);
        else if (t.isConst())
            t.vtinfo = TypeInfoConstDeclaration.create(t);
        else if (t.isImmutable())
            t.vtinfo = TypeInfoInvariantDeclaration.create(t);
        else if (t.isWild())
            t.vtinfo = TypeInfoWildDeclaration.create(t);
        else
            t.vtinfo = getTypeInfoDeclaration(t, sc);
        assert(t.vtinfo);
    }
    if (!torig.vtinfo)
        torig.vtinfo = t.vtinfo; // Types aren't merged, but we can share the vtinfo's
    assert(torig.vtinfo);
}

/****************************************************
 * Gets the type of the `TypeInfo` object associated with `t`
 * Params:
 *      loc = the location for reporting line nunbers in errors
 *      t   = the type to get the type of the `TypeInfo` object for
 *      sc  = the scope
 * Returns:
 *      The type of the `TypeInfo` object associated with `t`
 */
extern (C++) Type getTypeInfoType(Loc loc, Type t, Scope* sc)
{
    assert(t.ty != Terror);
    genTypeInfo(null, loc, t, sc);
    return t.vtinfo.type;
}

private TypeInfoDeclaration getTypeInfoDeclaration(Type t, Scope* sc)
{
    //printf("Type::getTypeInfoDeclaration() %s\n", t.toChars());
    switch (t.ty)
    {
    case Tpointer:
        return TypeInfoPointerDeclaration.create(t);
    case Tarray:
        return TypeInfoArrayDeclaration.create(t);
    case Tsarray:
        return TypeInfoStaticArrayDeclaration.create(t);
    case Taarray:
        return getTypeInfoAssocArrayDeclaration(cast(TypeAArray)t, sc);
    case Tstruct:
        return TypeInfoStructDeclaration.create(t);
    case Tvector:
        return TypeInfoVectorDeclaration.create(t);
    case Tenum:
        return TypeInfoEnumDeclaration.create(t);
    case Tfunction:
        return TypeInfoFunctionDeclaration.create(t);
    case Tdelegate:
        return TypeInfoDelegateDeclaration.create(t);
    case Ttuple:
        return TypeInfoTupleDeclaration.create(t);
    case Tclass:
        if ((cast(TypeClass)t).sym.isInterfaceDeclaration())
            return TypeInfoInterfaceDeclaration.create(t);
        else
            return TypeInfoClassDeclaration.create(t);

    default:
        return TypeInfoDeclaration.create(t);
    }
}

/******************************************
 * Instantiate TypeInfoAssociativeArrayDeclaration and fill
 * the entry with TypeInfo_AssociativeArray.Entry!(t.index, t.next)
 *
 * Params:
 *      t = TypeAArray to generate TypeInfo_AssociativeArray for
 *      sc = context
 * Returns:
 *      a TypeInfoAssociativeArrayDeclaration with field entry initialized
 */
TypeInfoDeclaration getTypeInfoAssocArrayDeclaration(TypeAArray t, Scope* sc)
{
    import destiny.arraytypes;
    import destiny.expressionsem;
    import destiny.id;

    assert(sc); // must not be called in the code generation phase

    auto ti = TypeInfoAssociativeArrayDeclaration.create(t);
    t.vtinfo = ti; // assign it early to avoid recursion in expressionSemantic
    ti._scope = sc;
    sc.setNoFree();
    addDeferredSemantic3(ti);
    return ti;
}

/******************************************
 * Find or create a TypeAArray with index and next without
 * any head modifiers, tail `inout` is replaced with `const`
 *
 * Params:
 *      t = TypeAArray to convert
 * Returns:
 *      t = found type
 */
Type makeNakedAssociativeArray(TypeAArray t)
{
    Type tindex = t.index.nakedOf().substWildTo(MODFlags.const_);
    Type tnext = t.next.nakedOf().substWildTo(MODFlags.const_);
    if (tindex == t.index && tnext == t.next)
        return t;

    t = new TypeAArray(tnext, tindex);
    return t.merge();
}

/* ========================================================================= */

/* Indicates whether druntime already contains an appropriate TypeInfo instance
 * for the specified type (in module rt.util.typeinfo).
 */
bool builtinTypeInfo(Type t)
{
    if (!t.mod) // unqualified types only
    {
        // unqualified basic types + typeof(null)
        if (t.isTypeBasic() || t.ty == Tnull)
            return true;
        // some unqualified arrays
        if (t.ty == Tarray)
        {
            Type next = t.nextOf();
            return (next.isTypeBasic() && !next.mod)                     // of unqualified basic types
                || (next.ty == Tchar && next.mod == MODFlags.immutable_) // string
                || (next.ty == Tchar && next.mod == MODFlags.const_);    // const(char)[]
        }
    }
    return false;
}
