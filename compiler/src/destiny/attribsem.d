/**
 * Does semantic analysis for attributes.
 *
 * The term 'attribute' refers to things that can apply to a larger scope than a single declaration.
 * Among them are:
 * - Alignment (`align(8)`)
 * - User defined attributes (`@UDA`)
 * - Function Attributes (`@safe`)
 * - Storage classes (`static`, `__gshared`)
 * - Mixin declarations  (`mixin("int x;")`)
 * - Conditional compilation (`static if`, `static foreach`)
 * - Linkage (`extern(C)`)
 * - Anonymous structs / unions
 * - Protection (`private`, `public`)
 * - Deprecated declarations (`@deprecated`)
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/attribsem.d, _attrib.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/attribsem.d
 *
 */

module destiny.attribsem;

import destiny.arraytypes;
import destiny.attrib;
import destiny.dscope;
import destiny.dsymbol;
import destiny.expression;
import destiny.expressionsem;
import destiny.location;
import destiny.root.array; // for each


Expressions* getAttributes(UserAttributeDeclaration a)
{
    if (auto sc = a._scope)
    {
        a._scope = null;
        arrayExpressionSemantic(a.atts.peekSlice(), sc);
    }
    auto exps = new Expressions();
    if (a.userAttribDecl && a.userAttribDecl !is a)
        exps.push(new TupleExp(Loc.initial, a.userAttribDecl.getAttributes()));
    if (a.atts && a.atts.length)
        exps.push(new TupleExp(Loc.initial, a.atts));
    return exps;
}

/**
 * Iterates the UDAs attached to the given symbol.
 *
 * Params:
 *  sym = the symbol to get the UDAs from
 *  sc = scope to use for semantic analysis of UDAs
 *  dg = called once for each UDA
 *
 * Returns:
 *  If `dg` returns `!= 0`, stops the iteration and returns that value.
 *  Otherwise, returns 0.
 */
int foreachUda(Dsymbol sym, Scope* sc, scope int delegate(Expression) dg)
{
    if (!sym.userAttribDecl)
        return 0;

    auto udas = sym.userAttribDecl.getAttributes();
    arrayExpressionSemantic(udas.peekSlice(), sc, true);

    return udas.each!((uda) {
        if (!uda.isTupleExp())
            return 0;

        auto exps = uda.isTupleExp().exps;

        return exps.each!((e) {
            assert(e);

            if (auto result = dg(e))
                return result;

            return 0;
        });
    });
}
