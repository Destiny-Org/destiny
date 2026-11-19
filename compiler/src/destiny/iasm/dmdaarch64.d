/**
 * Inline assembler implementation for Destiny.
 * https://github.com/Destiny-Org/destiny/blob/main/spec/iasm.ddd
 *
 * Copyright:   Copyright (C) 2025-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     Walter Bright
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasmaarch64.d, _iasmaarch64.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny
 *
 */

module destiny.iasm.dmdaarch64;

import core.stdc.stdio;
import core.stdc.stdarg;
import core.stdc.stdlib;
import core.stdc.string;

import destiny.astenums;
import destiny.astcodegen;
import destiny.declaration;
import destiny.denum;
import destiny.dinterpret;
import destiny.dmdparams;
import destiny.dscope;
import destiny.dsymbol;
import destiny.errors;
import destiny.expression;
import destiny.expressionsem;
import destiny.funcsem : checkNestedReference;
import destiny.globals;
import destiny.id;
import destiny.identifier;
import destiny.init;
import destiny.location;
import destiny.mtype;
import destiny.parse;
import destiny.statement;
import destiny.target;
import destiny.tokens;
import destiny.typesem : pointerTo, size, isIntegral;

import destiny.root.ctfloat;
import destiny.common.outbuffer;
import destiny.root.rmem;
import destiny.rootobject;

import destiny.backend.cc;
import destiny.backend.cdef;
import destiny.backend.code;
import destiny.backend.x86.code_x86;
import destiny.backend.codebuilder : CodeBuilder;
import destiny.backend.iasm;

/************************
 * Perform semantic analysis on InlineAsmStatement.
 * Params:
 *      s = inline asm statement
 *      sc = context
 * Returns:
 *      `s` on success, ErrorStatement if errors happened
 */
public Statement inlineAsmAArch64Semantic(InlineAsmStatement s, Scope* sc)
{
    static if (0)
    {
        printf("InlineAsmAArch64Statement.semantic()\n");
        for (auto token = s.tokens; token; token = token.next)
        {
            printf("TOK.%s %s\n", token.toString(token.value).ptr, token.toChars());
        }
    }

    const bool doUnittests = global.params.parsingUnittestsRequired(sc._module.isRoot);
    scope p = new Parser!ASTCodegen(sc._module, "", false, global.errorSink, &global.compileEnv, doUnittests);

    /* Set list of tokens that will be the input to the parser, and starting line number to use.
     */
    p.setTokenList(s.tokens, s.loc.linnum);

    int errors;
    static if (1)
    {
        if (p.token.value == TOK.identifier)
        {
            if (p.token.ident == Id.naked)
            {
                s.naked = true;
                sc.func.isNaked = true;
                p.nextToken();
            }
            else if (p.token.ident == Id.op)
            {

                p.nextToken();
                Expression exp = p.parseAssignExp();
                // Must evaluate to a constant, like an enum member does
                exp = exp.expressionSemantic(sc);
                exp = resolveProperties(sc, exp);
                exp = exp.ctfeInterpret();
                if (exp.op == EXP.error)
                    return ErrorStatement.get();

                //printf("expression: %s\n", exp.toChars());
                Type t = exp.type;
                if (!(size(t) == 4 && isIntegral(t)))
                    error(s.loc, "size of opcode must be 4 of integral type\n");
                code* pc = code_calloc();
                pc.Iflags |= CF.psw;            // assume we want to keep the flags
                pc.Iop = cast(int)exp.toInteger();
                s.asmcode = pc;
            }

            if (p.token.value != TOK.endOfFile && !errors)
            {
                error(s.loc, "end of instruction expected, not `%s`", p.token.toChars());
                return ErrorStatement.get();
            }
            else
                return s;
        }
    }

    /* For example,
     *  asm { str w3,[x2,x4]; }
     * would come through as:
     *  TOK.identifier TOK.identifier TOK.comma TOK.leftBracket TOK.identifier TOK.comma TOK.identifer TOK.rightBracket
     * and it is matched to the grammar for the "str" instruction:
     * https://www.scs.stanford.edu/~zyedidia/arm64/str_reg_gen.html
     * It then calls INSTR.str_reg_gen(sz=0,Rindex=4,extend=3,S=0,Rbase=2,Rt=4)
     * which returns 0xB8_24_68_43 which is installed in c.Iop.
     * (c is a code*.)
     * Symbols and values are put in c.IFL1 and c.IEV1.
     * s.asmcode is then set to c.
     * Matching the list of tokens to an instruction is straightforward, however, the trouble
     * is the very large and diverse number of instructions. The challenge is to boil this
     * complexity down to a simple table.
     */

    error(s.loc, "AArch64 inline assembler not implemented (yet!)");
    return ErrorStatement.get();
}
