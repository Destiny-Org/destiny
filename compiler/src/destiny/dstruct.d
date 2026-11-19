/**
 * Struct and union declarations.
 *
 * Specification: $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/spec/struct.ddd, Structs, Unions)
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dstruct.d, _dstruct.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dstruct.d
 *
 */

module destiny.dstruct;

import core.stdc.stdio;

import destiny.aggregate;
import destiny.arraytypes;
import destiny.astenums;
import destiny.dmodule;
import destiny.dsymbol;
import destiny.func;
import destiny.id;
import destiny.identifier;
import destiny.location;
import destiny.mtype;
import destiny.visitor;

enum StructFlags : int
{
    none        = 0x0,
    hasPointers = 0x1, // NB: should use noPointers as in ClassFlags
}

/***********************************************************
 * All `struct` declarations are an instance of this.
 */
extern (C++) class StructDeclaration : AggregateDeclaration
{
    FuncDeclarations postblits; // Array of postblit functions
    FuncDeclaration postblit;   // aggregate postblit

    FuncDeclaration xeq;        // TypeInfo_Struct.xopEquals
    FuncDeclaration xcmp;       // TypeInfo_Struct.xopCmp
    FuncDeclaration xhash;      // TypeInfo_Struct.xtoHash
    extern (C++) __gshared FuncDeclaration xerreq;   // object.xopEquals
    extern (C++) __gshared FuncDeclaration xerrcmp;  // object.xopCmp

    // ABI-specific type(s) if the struct can be passed in registers
    TypeTuple argTypes;

    structalign_t alignment;    // alignment applied outside of the struct
    ThreeState ispod;           // if struct is POD

    // `bool` fields that are compacted into bit fields in a string mixin
    private extern (D) static struct BitFields
    {
        bool zeroInit;              // !=0 if initialize with 0 fill
        bool hasIdentityAssign;     // true if has identity opAssign
        bool hasBlitAssign;         // true if opAssign is a blit
        bool hasIdentityEquals;     // true if has identity opEquals
        bool hasNoFields;           // has no fields
        bool hasCopyCtor;           // copy constructor
        bool hasMoveCtor;           // move constructor
        bool hasPointerField;       // members with indirections
        bool hasVoidInitPointers;   // void-initialized unsafe fields
        bool hasUnsafeBitpatterns;  // @system members, pointers, bool
        bool hasFieldWithInvariant; // invariants
        bool computedTypeProperties;// the above 3 fields are computed
    }

    import destiny.common.bitfields : generateBitFields;
    mixin(generateBitFields!(BitFields, ushort));

    extern (D) this(Loc loc, Identifier id, bool inObject)
    {
        super(loc, id);
        this.dsym = DSYM.structDeclaration;
        zeroInit = false; // assume false until we do semantic processing
        ispod = ThreeState.none;
        // For forward references
        type = new TypeStruct(this);

        if (inObject)
        {
            if (id == Id.ModuleInfo && !Module.moduleinfo)
                Module.moduleinfo = this;
        }
    }

    static StructDeclaration create(Loc loc, Identifier id, bool inObject)
    {
        return new StructDeclaration(loc, id, inObject);
    }

    override StructDeclaration syntaxCopy(Dsymbol s)
    {
        StructDeclaration sd =
            s ? cast(StructDeclaration)s
              : new StructDeclaration(loc, ident, false);
        ScopeDsymbol.syntaxCopy(sd);
        return sd;
    }

    override const(char)* kind() const
    {
        return "struct";
    }

    /***************************************
     * Determine if struct has copy construction (copy constructor or postblit)
     * Returns:
     *     true if struct has copy construction
     */
    final bool hasCopyConstruction()
    {
        return postblit || hasCopyCtor;
    }

    override void accept(Visitor v)
    {
        v.visit(this);
    }

    final uint numArgTypes() const
    {
        return argTypes && argTypes.arguments ? cast(uint) argTypes.arguments.length : 0;
    }

    final Type argType(uint index)
    {
        return index < numArgTypes() ? (*argTypes.arguments)[index].type : null;
    }
}


/***********************************************************
 * Unions are a variation on structs.
 */
extern (C++) final class UnionDeclaration : StructDeclaration
{
    extern (D) this(Loc loc, Identifier id)
    {
        super(loc, id, false);
        this.dsym = DSYM.unionDeclaration;
    }

    override UnionDeclaration syntaxCopy(Dsymbol s)
    {
        assert(!s);
        auto ud = new UnionDeclaration(loc, ident);
        StructDeclaration.syntaxCopy(ud);
        return ud;
    }

    override const(char)* kind() const
    {
        return "union";
    }

    override void accept(Visitor v)
    {
        v.visit(this);
    }
}
