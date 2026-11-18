/**
 * Inline assembler for the Destiny programming language compiler.
 *
 * Specification: $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/spec/iasm.dd, Inline Assembler)
 *
 *              Copyright (C) 2018-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm.d, _iasm.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm/package.d
 *
 */

module destiny.iasm;

import core.stdc.stdio;

import destiny.dscope;
import destiny.dsymbol;
import destiny.expression;
import destiny.func;
import destiny.mtype;
import destiny.target;
import destiny.tokens;
import destiny.statement;
import destiny.statementsem;

version (NoBackend)
{
}
else version (IN_GCC)
{
    version = Asm_GCC;
}
else version (IN_LLVM)
{
    version = Asm_GCC;
}
else
{
    import destiny.iasm.dmdx86;
    import destiny.iasm.dmdaarch64;
    version = MARS;
}

version (Asm_GCC)
{
    import destiny.iasm.gcc;
}

/************************ AsmStatement ***************************************/

Statement asmSemantic(AsmStatement s, Scope* sc)
{
    //printf("AsmStatement.semantic()\n");

    FuncDeclaration fd = sc.parent.isFuncDeclaration();
    assert(fd);

    if (!s.tokens)
        return null;

    // Assume assembler code takes care of setting the return value
    sc.func.hasInlineAsm = true;

    version (NoBackend)
    {
        return null;
    }
    else version (MARS)
    {
        /* If it starts with a string literal, it's gcc inline asm
         */
        if (s.tokens.value == TOK.string_)
        {
            /* Replace the asm statement with an assert(0, msg) that trips at runtime.
             */
            const loc = s.loc;
            auto e = new IntegerExp(loc, 0, Type.tint32);
            auto msg = new StringExp(loc, "Gnu Asm not supported - compile this function with gcc or clang");
            auto ae = new AssertExp(loc, e, msg);
            auto se = new ExpStatement(loc, ae);
            return statementSemantic(se, sc);
        }
        auto ias = new InlineAsmStatement(s.loc, s.tokens);
        ias.caseSensitive = s.caseSensitive;
        return (target.isAArch64)
            ? inlineAsmAArch64Semantic(ias, sc)
            : inlineAsmSemantic(ias, sc);       // X86_64
    }
    else version (Asm_GCC)
    {
        auto eas = new GccAsmStatement(s.loc, s.tokens);
        return gccAsmSemantic(eas, sc);
    }
    else
    {
        s.error("D inline assembler statements are not supported");
        return ErrorStatement.get();
    }
}

/************************ CAsmDeclaration ************************************/

void asmSemantic(CAsmDeclaration ad, Scope* sc)
{
    version (NoBackend)
    {
    }
    else version (Asm_GCC)
    {
        return gccAsmSemantic(ad, sc);
    }
    else
    {
        import destiny.errors : error;
        error(ad.code.loc, "Gnu Asm not supported - compile this file with gcc or clang");
    }
}
