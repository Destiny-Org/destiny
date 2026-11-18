/**
 * Semantic analysis of template parameters.
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/templateparamsem.d, _templateparamsem.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/templateparamsem.d
 *
 */

module destiny.templateparamsem;

import destiny.arraytypes;
import destiny.dinterpret;
import destiny.dsymbol;
import destiny.dscope;
import destiny.dtemplate;
import destiny.location;
import destiny.expression;
import destiny.expressionsem;
import destiny.templatesem;
import destiny.rootobject;
import destiny.mtype;
import destiny.typesem;
import destiny.visitor;

/************************************************
 * Performs semantic on TemplateParameter AST nodes.
 *
 * Params:
 *      tp = element of `parameters` to be semantically analyzed
 *      sc = context
 *      parameters = array of `TemplateParameters` supplied to the `TemplateDeclaration`
 * Returns:
 *      `true` if no errors
 */
bool tpsemantic(TemplateParameter tp, Scope* sc, TemplateParameters* parameters)
{
    scope v = new TemplateParameterSemanticVisitor(sc, parameters);
    tp.accept(v);
    return v.result;
}


private extern (C++) final class TemplateParameterSemanticVisitor : Visitor
{
    alias visit = Visitor.visit;

    Scope* sc;
    TemplateParameters* parameters;
    bool result;

    this(Scope* sc, TemplateParameters* parameters) scope @safe
    {
        this.sc = sc;
        this.parameters = parameters;
    }

    override void visit(TemplateTypeParameter ttp)
    {
        //printf("TemplateTypeParameter.semantic('%s')\n", ident.toChars());
        if (ttp.specType && !reliesOnTident(ttp.specType, parameters))
        {
            ttp.specType = ttp.specType.typeSemantic(ttp.loc, sc);
        }
        version (none)
        {
            // Don't do semantic() until instantiation
            if (ttp.defaultType)
            {
                ttp.defaultType = ttp.defaultType.typeSemantic(ttp.loc, sc);
            }
        }
        result = !(ttp.specType && isError(ttp.specType));
    }

    override void visit(TemplateThisParameter ttp)
    {
        import destiny.globals;
        auto eSink = global.errorSink;

        if (!sc.getStructClassScope())
            eSink.error(ttp.loc, "cannot use `this` outside an aggregate type");
        visit(cast(TemplateTypeParameter)ttp);
    }

    override void visit(TemplateValueParameter tvp)
    {
        tvp.valType = tvp.valType.typeSemantic(tvp.loc, sc);
        version (none)
        {
            // defer semantic analysis to arg match
            if (tvp.specValue)
            {
                Expression e = tvp.specValue;
                sc = sc.startCTFE();
                e = e.semantic(sc);
                sc = sc.endCTFE();
                e = e.implicitCastTo(sc, tvp.valType);
                e = e.ctfeInterpret();
                if (e.op == EXP.int64 || e.op == EXP.float64 ||
                    e.op == EXP.complex80 || e.op == EXP.null_ || e.op == EXP.string_)
                    tvp.specValue = e;
            }

            if (tvp.defaultValue)
            {
                Expression e = defaultValue;
                sc = sc.startCTFE();
                e = e.semantic(sc);
                sc = sc.endCTFE();
                e = e.implicitCastTo(sc, tvp.valType);
                e = e.ctfeInterpret();
                if (e.op == EXP.int64)
                    tvp.defaultValue = e;
            }
        }
        result = !isError(tvp.valType);
    }

    override void visit(TemplateAliasParameter tap)
    {
        if (tap.specType && !reliesOnTident(tap.specType, parameters))
        {
            tap.specType = tap.specType.typeSemantic(tap.loc, sc);
        }
        tap.specAlias = aliasParameterSemantic(tap.loc, sc, tap.specAlias, parameters);
        version (none)
        {
            // Don't do semantic() until instantiation
            if (tap.defaultAlias)
                tap.defaultAlias = tap.defaultAlias.semantic(tap.loc, sc);
        }
        result = !(tap.specType && isError(tap.specType)) && !(tap.specAlias && isError(tap.specAlias));
    }

    override void visit(TemplateTupleParameter ttp)
    {
        result = true;
    }
}

/***********************************************
 * Support function for performing semantic analysis on `TemplateAliasParameter`.
 *
 * Params:
 *      loc = location (for error messages)
 *      sc = context
 *      o = object to run semantic() on, the `TemplateAliasParameter`s `specAlias` or `defaultAlias`
 *      parameters = array of `TemplateParameters` supplied to the `TemplateDeclaration`
 * Returns:
 *      object resulting from running `semantic` on `o`
 */
RootObject aliasParameterSemantic(Loc loc, Scope* sc, RootObject o, TemplateParameters* parameters)
{
    if (!o)
        return null;

    Expression ea = isExpression(o);
    RootObject eaCTFE()
    {
        sc = sc.startCTFE();
        ea = ea.expressionSemantic(sc);
        sc = sc.endCTFE();
        return ea.ctfeInterpret();
    }
    Type ta = isType(o);
    if (ta && (!parameters || !reliesOnTident(ta, parameters)))
    {
        Dsymbol s = ta.toDsymbol(sc);
        if (s)
            return s;
        if (TypeInstance ti = ta.isTypeInstance())
        {
            import destiny.globals;

            Type t;
            const errors = global.errors;
            ta.resolve(loc, sc, ea, t, s);
            // if we had an error evaluating the symbol, suppress further errors
            if (!t && errors != global.errors)
                return Type.terror;
            // We might have something that looks like a type
            // but is actually an expression or a dsymbol
            // see upstream issue 16472
            if (t)
                return t.typeSemantic(loc, sc);
            if (ea)
            {
                return eaCTFE();
            }
            if (s)
                return s;
            assert(0);
        }
        else
            return ta.typeSemantic(loc, sc);
    }
    else if (ea)
        return eaCTFE();
    return o;
}
