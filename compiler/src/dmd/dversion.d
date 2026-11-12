/**
 * Defines a `Dsymbol` for `version = identifier` and `debug = identifier` statements.
 *
 * Specification: $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/spec/version.dd, Version Specification),
 *                $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/spec/version.dd, Debug Specification).
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/dmd/dversion.d, _dversion.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/dmd/dversion.d
 * 
 */

module dmd.dversion;

import dmd.dsymbol;
import dmd.identifier;
import dmd.location;
import dmd.visitor;

/***********************************************************
 * DebugSymbol's happen for statements like:
 *      debug = identifier;
 */
extern (C++) final class DebugSymbol : Dsymbol
{
    extern (D) this(Loc loc, Identifier ident) @safe
    {
        super(DSYM.debugSymbol, loc, ident);
    }

    extern (D) this(Loc loc) @safe
    {
        super(DSYM.aliasDeclaration, loc, null);
    }

    override DebugSymbol syntaxCopy(Dsymbol s)
    {
        assert(!s);
        auto ds = new DebugSymbol(loc, ident);
        ds.addComment(comment);
        return ds;
    }

    override const(char)* kind() const nothrow
    {
        return "debug";
    }

    override void accept(Visitor v)
    {
        v.visit(this);
    }
}

/***********************************************************
 * VersionSymbol's happen for statements like:
 *      version = identifier;
 */
extern (C++) final class VersionSymbol : Dsymbol
{

    extern (D) this(Loc loc, Identifier ident) @safe
    {
        super(DSYM.versionSymbol, loc, ident);
    }

    extern (D) this(Loc loc) @safe
    {
        super(DSYM.versionSymbol, loc, null);
    }

    override VersionSymbol syntaxCopy(Dsymbol s)
    {
        assert(!s);
        auto ds = new VersionSymbol(loc, ident);
        ds.addComment(comment);
        return ds;
    }

    override const(char)* kind() const nothrow
    {
        return "version";
    }

    override void accept(Visitor v)
    {
        v.visit(this);
    }
}
