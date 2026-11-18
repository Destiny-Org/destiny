/**
 * Contains C++ interfaces for interacting with Destiny as a library.
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cxxfrontend.d, _cxxfrontend.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cxxfrontend.d
 *
 */
module destiny.cxxfrontend;

import destiny.aggregate : AggregateDeclaration;
import destiny.arraytypes;
import destiny.astenums;
import destiny.attrib;
import destiny.common.outbuffer : OutBuffer;
import destiny.dclass : ClassDeclaration, BaseClass;
import destiny.declaration : TypeInfoDeclaration, VarDeclaration, TupleDeclaration;
import destiny.denum : EnumDeclaration;
import destiny.dmodule /*: Module*/;
import destiny.dscope : Scope;
import destiny.dstruct /*: StructDeclaration*/;
import destiny.dsymbol : Dsymbol, ScopeDsymbol, CAsmDeclaration, SearchOpt, SearchOptFlags;
import destiny.dtemplate /*: TemplateInstance, TemplateParameter, Tuple*/;
import destiny.errorsink : ErrorSink;
import destiny.expression /*: Expression*/;
import destiny.func : FuncDeclaration;
import destiny.globals : dinteger_t, uinteger_t, JsonFieldFlags, CppStdRevision;
import destiny.identifier : Identifier;
import destiny.init : Initializer, NeedInterpret;
import destiny.location : Loc;
import destiny.mtype /*: Covariant, Type, Parameter, ParameterList*/;
import destiny.rootobject : RootObject;
import destiny.root.optional;
import destiny.root.longdouble : real_t = longdouble;
import destiny.root.complex;
import destiny.semantic3;
import destiny.statement : Statement, AsmStatement, GccAsmStatement;

// NB: At some point in the future, we can switch to shortened function syntax.
extern (C++, "destiny"):

/***********************************************************
 * atrtibsem.d
 */
Expressions* getAttributes(UserAttributeDeclaration a)
{
    import destiny.attribsem;
    return destiny.attribsem.getAttributes(a);
}

/***********************************************************
 * mangle/cpp.d
 */
const(char)* toCppMangleItanium(Dsymbol s)
{
    import destiny.mangle.cpp;
    return destiny.mangle.cpp.toCppMangleItanium(s);
}

const(char)* cppTypeInfoMangleItanium(Dsymbol s)
{
    import destiny.mangle.cpp;
    return destiny.mangle.cpp.cppTypeInfoMangleItanium(s);
}

const(char)* cppThunkMangleItanium(FuncDeclaration fd, int offset)
{
    import destiny.mangle.cpp;
    return destiny.mangle.cpp.cppThunkMangleItanium(fd, offset);
}

/***********************************************************
 * dinterpret.d
 */
Expression ctfeInterpret(Expression e)
{
    import destiny.dinterpret;
    return destiny.dinterpret.ctfeInterpret(e);
}

/***********************************************************
 * mangle/package.d
 */
const(char)* mangleExact(FuncDeclaration fd)
{
    import destiny.mangle;
    return destiny.mangle.mangleExact(fd);
}

void mangleToBuffer(Type t, ref OutBuffer buf)
{
    import destiny.mangle;
    return destiny.mangle.mangleToBuffer(t, buf);
}

void mangleToBuffer(Expression e, ref OutBuffer buf)
{
    import destiny.mangle;
    return destiny.mangle.mangleToBuffer(e, buf);
}

void mangleToBuffer(Dsymbol s, ref OutBuffer buf)
{
    import destiny.mangle;
    return destiny.mangle.mangleToBuffer(s, buf);
}

void mangleToBuffer(TemplateInstance ti, ref OutBuffer buf)
{
    import destiny.mangle;
    return destiny.mangle.mangleToBuffer(ti, buf);
}

/***********************************************************
 * doc.d
 */
void gendocfile(Module m, const char* ddoctext_ptr, size_t ddoctext_length,
                const char* datetime, ErrorSink eSink, ref OutBuffer outbuf)
{
    import destiny.doc;
    return destiny.doc.gendocfile(m, ddoctext_ptr, ddoctext_length, datetime, eSink, outbuf);
}

/***********************************************************
 * dstruct.d
 */
FuncDeclaration search_toString(StructDeclaration sd)
{
    return destiny.semantic3.search_toString(sd);
}

/***********************************************************
 * dsymbolsem.d
 */
void dsymbolSemantic(Dsymbol dsym, Scope* sc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.dsymbolSemantic(dsym, sc);
}

void addMember(Dsymbol dsym, Scope* sc, ScopeDsymbol sds)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.addMember(dsym, sc, sds);
}

Dsymbol search(Dsymbol d, Loc loc, Identifier ident, SearchOptFlags
               flags = SearchOpt.all)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.search(d, loc, ident, flags);
}

void setScope(Dsymbol d, Scope* sc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.setScope(d, sc);
}

void importAll(Dsymbol d, Scope* sc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.importAll(d, sc);
}

Dsymbols* include(Dsymbol d, Scope* sc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.include(d, sc);
}

bool isFuncHidden(ClassDeclaration cd, FuncDeclaration fd)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.isFuncHidden(cd, fd);
}

Dsymbol vtblSymbol(ClassDeclaration cd)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.vtblSymbol(cd);
}

bool isAbstract(ClassDeclaration cd)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.isAbstract(cd);
}

bool hasPointers(Dsymbol d)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.hasPointers(d);
}

void getLocalClasses(Module mod, ref ClassDeclarations aclasses)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.getLocalClasses(mod, aclasses);
}

Dsymbol toAlias(Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.toAlias(s);
}

Dsymbol toAlias2(Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.toAlias2(s);
}

bool isPOD(StructDeclaration sd)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.isPOD(sd);
}

bool fillVtbl(BaseClass* bc, ClassDeclaration cd, FuncDeclarations* vtbl, int newinstance)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.fillVtbl(bc, cd, vtbl, newinstance);
}

bool overloadInsert(Dsymbol ds, Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.overloadInsert(ds, s);
}

bool equals(const Dsymbol ds, const Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.equals(ds, s);
}

Type getType(Dsymbol ds)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.getType(ds);
}

uinteger_t size(Dsymbol ds, Loc loc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.size(ds, loc);
}

void addDeferredSemantic(Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.addDeferredSemantic(s);
}

void addDeferredSemantic2(Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.addDeferredSemantic2(s);
}

void addDeferredSemantic3(Dsymbol s)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.addDeferredSemantic3(s);
}

void runDeferredSemantic()
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.runDeferredSemantic();
}

void runDeferredSemantic2()
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.runDeferredSemantic2();
}

void runDeferredSemantic3()
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.runDeferredSemantic3();
}

bool isOverlappedWith(VarDeclaration vd, VarDeclaration v)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.isOverlappedWith(vd, v);
}

Scope* newScope(AggregateDeclaration ad, Scope* sc)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.newScope(ad, sc);
}

Dsymbol search(Scope* sc, Loc loc, Identifier ident, out Dsymbol pscopesym,
    SearchOptFlags flags = SearchOpt.all)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.search(sc, loc, ident, pscopesym, flags);
}

void addObjcSymbols(Dsymbol sym, ClassDeclarations* classes, ClassDeclarations* categories)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.addObjcSymbols(sym, classes, categories);
}

FuncDeclaration findGetMembers(ScopeDsymbol dsym)
{
    import destiny.dsymbolsem;
    return destiny.dsymbolsem.findGetMembers(dsym);
}

/***********************************************************
 * dtemplate.d
 */
inout(Expression) isExpression(inout RootObject o)
{
    return destiny.dtemplate.isExpression(o);
}

inout(Dsymbol) isDsymbol(inout RootObject o)
{
    return destiny.dtemplate.isDsymbol(o);
}

inout(Type) isType(inout RootObject o)
{
    return destiny.dtemplate.isType(o);
}

inout(Tuple) isTuple(inout RootObject o)
{
    return destiny.dtemplate.isTuple(o);
}

inout(Parameter) isParameter(inout RootObject o)
{
    return destiny.dtemplate.isParameter(o);
}

inout(TemplateParameter) isTemplateParameter(inout RootObject o)
{
    return destiny.dtemplate.isTemplateParameter(o);
}

bool isError(const RootObject o)
{
    return destiny.dtemplate.isError(o);
}

void printTemplateStats(bool listInstances, ErrorSink eSink)
{
    return destiny.dtemplate.printTemplateStats(listInstances, eSink);
}

void printInstantiationTrace(TemplateInstance ti)
{
    return ti.printInstantiationTrace();
}

/***********************************************************
 * dtoh.d
 */
void genCppHdrFiles(ref Modules ms, ErrorSink eSink, CppStdRevision cppStdRevision)
{
    import destiny.dtoh;
    return destiny.dtoh.genCppHdrFiles(ms, eSink, cppStdRevision);
}

/***********************************************************
 * enumsem.d
 */
Expression getDefaultValue(EnumDeclaration ed, Loc loc)
{
    import destiny.enumsem;
    return destiny.enumsem.getDefaultValue(ed, loc);
}


/***********************************************************
 * expressionsem.d
 */

void expandTuples(Expressions* exps, ArgumentLabels* names = null)
{
    import destiny.expressionsem;
    return destiny.expressionsem.expandTuples(exps, names);
}

Expression expressionSemantic(Expression e, Scope* sc)
{
    import destiny.expressionsem;
    return destiny.expressionsem.expressionSemantic(e, sc);
}

bool fill(StructDeclaration sd, Loc loc,
          ref Expressions elements, bool ctorinit)
{
    import destiny.expressionsem;
    return destiny.expressionsem.fill(sd, loc, elements, ctorinit);
}

bool isIdentical(const Expression exp, const Expression e)
{
    import destiny.expressionsem;
    return destiny.expressionsem.isIdentical(exp, e);
}

bool equals(const Expression exp, const Expression e)
{
    import destiny.expressionsem;
    return destiny.expressionsem.equals(exp, e);
}

bool isLvalue(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.isLvalue(exp);
}

bool canElideCopy(Expression exp, Type to, bool checkMod)
{
    import destiny.expressionsem;
    return destiny.expressionsem.canElideCopy(exp, to, checkMod);
}

int getFieldIndex(ClassReferenceExp cre, Type fieldtype, uint fieldoffset)
{
    import destiny.expressionsem;
    return destiny.expressionsem.getFieldIndex(cre, fieldtype, fieldoffset);
}

void fillTupleExpExps(TupleExp te, TupleDeclaration tup)
{
    import destiny.expressionsem;
    return destiny.expressionsem.fillTupleExpExps(te, tup);
}

Optional!bool toBool(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toBool(exp);
}

StringExp toStringExp(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toStringExp(exp);
}

dinteger_t toInteger(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toInteger(exp);
}

uinteger_t toUInteger(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toUInteger(exp);
}

real_t toReal(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toReal(exp);
}

complex_t toComplex(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toComplex(exp);
}

real_t toImaginary(Expression exp)
{
    import destiny.expressionsem;
    return destiny.expressionsem.toImaginary(exp);
}

/***********************************************************
 * funcsem.d
 */
FuncDeclaration genCfunc(Parameters* fparams, Type treturn, const(char)* name, StorageClass stc = STC.none)
{
    import destiny.funcsem;
    return destiny.funcsem.genCfunc(fparams, treturn, name, cast(STC) stc);
}

FuncDeclaration genCfunc(Parameters* fparams, Type treturn, Identifier id, StorageClass stc = STC.none)
{
    import destiny.funcsem;
    return destiny.funcsem.genCfunc(fparams, treturn, id, cast(STC) stc);
}

bool functionSemantic(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.functionSemantic(fd);
}

bool functionSemantic3(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.functionSemantic3(fd);
}

MATCH leastAsSpecialized(FuncDeclaration fd, FuncDeclaration g, ArgumentLabels* names)
{
    import destiny.funcsem;
    return destiny.funcsem.leastAsSpecialized(fd, g, names);
}

PURE isPure(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.isPure(fd);
}

bool needsClosure(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.needsClosure(fd);
}

bool hasNestedFrameRefs(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.hasNestedFrameRefs(fd);
}

bool isVirtualMethod(FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.isVirtualMethod(fd);
}

bool isVirtual(const FuncDeclaration fd)
{
    import destiny.funcsem;
    return destiny.funcsem.isVirtual(fd);
}

/***********************************************************
 * hdrgen.d
 */
void genhdrfile(Module m, bool doFuncBodies, ref OutBuffer buf)
{
    import destiny.hdrgen;
    return destiny.hdrgen.genhdrfile(m, doFuncBodies, buf);
}

const(char)* toChars(const Statement s)
{
    import destiny.hdrgen;
    return destiny.hdrgen.toChars(s);
}

const(char)* toChars(const Expression e)
{
    import destiny.hdrgen;
    return destiny.hdrgen.toChars(e);
}

const(char)* toChars(const Initializer i)
{
    import destiny.hdrgen;
    return destiny.hdrgen.toChars(i);
}

const(char)* toChars(const Type t)
{
    import destiny.hdrgen;
    return destiny.hdrgen.toChars(t);
}

void moduleToBuffer(ref OutBuffer buf, bool vcg_ast, Module m)
{
    import destiny.hdrgen;
    return destiny.hdrgen.moduleToBuffer(buf, vcg_ast, m);
}

const(char)* parametersTypeToChars(ParameterList pl)
{
    import destiny.hdrgen;
    return destiny.hdrgen.parametersTypeToChars(pl);
}

/***********************************************************
 * iasm.d
 */
Statement asmSemantic(AsmStatement s, Scope* sc)
{
    import destiny.iasm;
    return destiny.iasm.asmSemantic(s, sc);
}

void asmSemantic(CAsmDeclaration d, Scope* sc)
{
    import destiny.iasm;
    return destiny.iasm.asmSemantic(d, sc);
}

/***********************************************************
 * iasmgcc.d
 */
Statement gccAsmSemantic(GccAsmStatement s, Scope* sc)
{
    import destiny.iasm.gcc;
    return destiny.iasm.gcc.gccAsmSemantic(s, sc);
}

void gccAsmSemantic(CAsmDeclaration d, Scope* sc)
{
    import destiny.iasm.gcc;
    return destiny.iasm.gcc.gccAsmSemantic(d, sc);
}

/***********************************************************
 * initsem.d
 */
Initializer initializerSemantic(Initializer init, Scope* sc, ref Type tx,
                                NeedInterpret needInterpret)
{
    import destiny.initsem;
    import destiny.globals : global;
    auto eSink = global.errorSink;
    return destiny.initsem.initializerSemantic(init, sc, tx, needInterpret, eSink);
}

Expression initializerToExpression(Initializer init, Scope* sc, Type itype)
{
    import destiny.initsem;
    import destiny.globals : global;
    auto eSink = global.errorSink;
    return destiny.initsem.initializerToExpression(init, sc, itype, eSink);
}

/***********************************************************
 * json.d
 */
void json_generate(ref Modules modules, ref OutBuffer buf)
{
    import destiny.json;
    return destiny.json.json_generate(modules, buf);
}

JsonFieldFlags tryParseJsonField(const(char)* fieldName)
{
    import destiny.json;
    return destiny.json.tryParseJsonField(fieldName);
}

/***********************************************************
 * optimize.d
 */
Expression optimize(Expression e, int result, bool keepLvalue = false)
{
    import destiny.optimize;
    return destiny.optimize.optimize(e, result, keepLvalue);
}

/***********************************************************
 * semantic2.d
 */
void semantic2(Dsymbol dsym, Scope* sc)
{
    import destiny.semantic2;
    return destiny.semantic2.semantic2(dsym, sc);
}

/***********************************************************
 * semantic3.d
 */
void semantic3(Dsymbol dsym, Scope* sc)
{
    import destiny.semantic3;
    return destiny.semantic3.semantic3(dsym, sc);
}

void semanticTypeInfoMembers(StructDeclaration sd)
{
    import destiny.semantic3;
    return destiny.semantic3.semanticTypeInfoMembers(sd);
}

bool checkClosure(FuncDeclaration fd)
{
    import destiny.semantic3;
    return destiny.semantic3.checkClosure(fd);
}
/***********************************************************
 * statementsem.d
 */
Statement statementSemantic(Statement s, Scope* sc)
{
    import destiny.statementsem;
    return destiny.statementsem.statementSemantic(s, sc);
}

/***********************************************************
 * templateparamsem.d
 */
bool tpsemantic(TemplateParameter tp, Scope* sc, TemplateParameters* parameters)
{
    import destiny.templateparamsem;
    return destiny.templateparamsem.tpsemantic(tp, sc, parameters);
}

/***********************************************************
 * typesem.d
 */
bool hasDeprecatedAliasThis(Type type)
{
    import destiny.typesem;
    return destiny.typesem.hasDeprecatedAliasThis(type);
}

AggregateDeclaration isAggregate(Type t)
{
    import destiny.typesem;
    return destiny.typesem.isAggregate(t);
}

bool hasPointers(Type t)
{
    import destiny.typesem;
    return destiny.typesem.hasPointers(t);
}

Type typeSemantic(Type type, Loc loc, Scope* sc)
{
    import destiny.typesem;
    return destiny.typesem.typeSemantic(type, loc, sc);
}

Type trySemantic(Type type, Loc loc, Scope* sc)
{
    import destiny.typesem;
    return destiny.typesem.trySemantic(type, loc, sc);
}

Type merge(Type type)
{
    import destiny.typesem;
    return destiny.typesem.merge(type);
}

Type merge2(Type type)
{
    import destiny.typesem;
    return destiny.typesem.merge2(type);
}

Type toBasetype(Type type)
{
    import destiny.typesem;
    return destiny.typesem.toBasetype(type);
}

Expression defaultInit(Type mt, Loc loc, const bool isCfile = false)
{
    import destiny.typesem;
    return destiny.typesem.defaultInit(mt, loc, isCfile);
}

Dsymbol toDsymbol(Type type, Scope* sc)
{
    import destiny.typesem;
    return destiny.typesem.toDsymbol(type, sc);
}

Covariant covariant(Type src, Type t, StorageClass* pstc = null, bool
                    cppCovariant = false)
{
    import destiny.typesem;
    return destiny.typesem.covariant(src, t, cast(STC*) pstc, cppCovariant);
}

bool isZeroInit(Type t, Loc loc)
{
    import destiny.typesem;
    return destiny.typesem.isZeroInit(t, loc);
}

bool isBaseOf(Type tthis, Type t, int* poffset)
{
    import destiny.typesem;
    return destiny.typesem.isBaseOf(tthis, t, poffset);
}

bool equivalent(Type src, Type t)
{
    import destiny.typesem;
    return destiny.typesem.equivalent(src, t);
}

Type sarrayOf(Type type, dinteger_t dim)
{
    import destiny.typesem;
    return destiny.typesem.sarrayOf(type, dim);
}

Type arrayOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.arrayOf(type);
}

Type constOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.constOf(type);
}

Type immutableOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.immutableOf(type);
}

Type mutableOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.mutableOf(type);
}

Type sharedOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.sharedOf(type);
}

Type sharedConstOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.sharedConstOf(type);
}

Type unSharedOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.unSharedOf(type);
}

Type wildOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.wildOf(type);
}

Type wildConstOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.wildConstOf(type);
}

Type sharedWildOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.sharedWildOf(type);
}

Type sharedWildConstOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.sharedWildConstOf(type);
}

Type substWildTo(Type type, uint mod)
{
    import destiny.typesem;
    return destiny.typesem.substWildTo(type, mod);
}

Type unqualify(Type type, uint m)
{
    import destiny.typesem;
    return destiny.typesem.unqualify(type, m);
}

Type toHeadMutable(const(Type) type)
{
    import destiny.typesem;
    return destiny.typesem.toHeadMutable(type);
}

Type aliasthisOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.aliasthisOf(type);
}

Type castMod(Type type, MOD mod)
{
    import destiny.typesem;
    return destiny.typesem.castMod(type, mod);
}

Type addMod(Type type, MOD mod)
{
    import destiny.typesem;
    return destiny.typesem.addMod(type, mod);
}

Type addStorageClass(Type type, StorageClass stc)
{
    import destiny.typesem;
    return destiny.typesem.addStorageClass(type, cast(STC) stc);
}

Type pointerTo(Type type)
{
    import destiny.typesem;
    return destiny.typesem.pointerTo(type);
}

Type referenceTo(Type type)
{
    import destiny.typesem;
    return destiny.typesem.referenceTo(type);
}

Type memType(TypeEnum type)
{
    import destiny.typesem;
    return destiny.typesem.memType(type);
}

uinteger_t size(Type type)
{
    import destiny.typesem;
    return destiny.typesem.size(type);
}

uinteger_t size(Type type, Loc loc)
{
    import destiny.typesem;
    return destiny.typesem.size(type, loc);
}

structalign_t alignment(Type type)
{
    import destiny.typesem;
    return destiny.typesem.alignment(type);
}

uint alignsize(Type type)
{
    import destiny.typesem;
    return destiny.typesem.alignsize(type);
}

MATCH implicitConvTo(Type from, Type to)
{
    import destiny.dcast;
    return destiny.dcast.implicitConvTo(from, to);
}

MATCH constConv(Type from, Type to)
{
    import destiny.typesem;
    return destiny.typesem.constConv(from, to);
}

Expression defaultInitLiteral(Type t, Loc loc)
{
    import destiny.typesem;
    return destiny.typesem.defaultInitLiteral(t, loc);
}

bool hasUnsafeBitpatterns(Type type)
{
    import destiny.typesem;
    return destiny.typesem.hasUnsafeBitpatterns(type);
}

bool hasInvariant(Type type)
{
    import destiny.typesem;
    return destiny.typesem.hasInvariant(type);
}

bool hasVoidInitPointers(Type type)
{
    import destiny.typesem;
    return destiny.typesem.hasVoidInitPointers(type);
}

void Type_init()
{
    import destiny.typesem;
    return destiny.typesem.Type_init();
}

void transitive(TypeNext type)
{
    import destiny.typesem;
    return destiny.typesem.transitive(type);
}

Type makeConst(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeConst(type);
}

Type makeImmutable(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeImmutable(type);
}

Type makeMutable(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeMutable(type);
}

Type makeShared(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeShared(type);
}

Type makeSharedConst(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeSharedConst(type);
}

Type makeWild(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeWild(type);
}

Type makeWildConst(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeWildConst(type);
}

Type makeSharedWild(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeSharedWild(type);
}

Type makeSharedWildConst(Type type)
{
    import destiny.typesem;
    return destiny.typesem.makeSharedWildConst(type);
}

Type nextOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.nextOf(type);
}

Type baseElemOf(Type type)
{
    import destiny.typesem;
    return destiny.typesem.baseElemOf(type);
}

Type isLazyArray(Parameter param)
{
    import destiny.typesem;
    return destiny.typesem.isLazyArray(param);
}

MOD deduceWild(Type type, Type t, bool isRef)
{
    import destiny.typesem;
    return destiny.typesem.deduceWild(type, t, isRef);
}

bool isIntegral(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isIntegral(type);
}

bool isFloating(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isFloating(type);
}

bool isScalar(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isScalar(type);
}

bool isReal(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isReal(type);
}

bool isComplex(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isComplex(type);
}

bool isImaginary(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isImaginary(type);
}

bool isString(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isString(type);
}

bool isBoolean(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isBoolean(type);
}

bool isUnsigned(Type type)
{
    import destiny.typesem;
    return destiny.typesem.isUnsigned(type);
}

bool needsNested(Type type)
{
    import destiny.typesem;
    return destiny.typesem.needsNested(type);
}

bool needsDestruction(Type type)
{
    import destiny.typesem;
    return destiny.typesem.needsDestruction(type);
}

bool needsCopyOrPostblit(Type type)
{
    import destiny.typesem;
    return destiny.typesem.needsCopyOrPostblit(type);
}

/***********************************************************
 * typinf.d
 */
void genTypeInfo(Expression e, Loc loc, Type torig, Scope* sc)
{
    import destiny.typinf;
    return destiny.typinf.genTypeInfo(e, loc, torig, sc);
}

bool builtinTypeInfo(Type t)
{
    import destiny.typinf;
    return destiny.typinf.builtinTypeInfo(t);
}

Type makeNakedAssociativeArray(TypeAArray t)
{
    import destiny.typinf;
    return destiny.typinf.makeNakedAssociativeArray(t);
}

TypeInfoDeclaration getTypeInfoAssocArrayDeclaration(TypeAArray t, Scope* sc)
{
    import destiny.typinf;
    return destiny.typinf.getTypeInfoAssocArrayDeclaration(t, sc);
}

/**
 * templatesem.d
 */
bool declareParameter(TemplateParameter tp, Scope* sc)
{
    import destiny.templatesem;
    return destiny.templatesem.declareParameter(tp, sc);
}

bool needsCodegen(TemplateInstance ti)
{
    import destiny.templatesem;
    return destiny.templatesem.needsCodegen(ti);
}

bool isDiscardable(TemplateInstance ti)
{
    import destiny.templatesem;
    return destiny.templatesem.isDiscardable(ti);
}
version (IN_LLVM)
{
    /***********************************************************
     * argtypes_aarch64.d
     */
    TypeTuple toArgTypes_aarch64(Type t)
    {
        import destiny.argtypes_aarch64;
        return destiny.argtypes_aarch64.toArgTypes_aarch64(t);
    }

    bool isHFVA(Type t, int maxNumElements = 4, Type* rewriteType = null)
    {
        import destiny.argtypes_aarch64;
        return destiny.argtypes_aarch64.isHFVA(t, maxNumElements, rewriteType);
    }

    /***********************************************************
     * argtypes_sysv_x64.d
     */
    TypeTuple toArgTypes_sysv_x64(Type t)
    {
        import destiny.argtypes_sysv_x64;
        return destiny.argtypes_sysv_x64.toArgTypes_sysv_x64(t);
    }

    /***********************************************************
     * argtypes_x86.d
     */
    TypeTuple toArgTypes_x86(Type t)
    {
        import destiny.argtypes_x86;
        return destiny.argtypes_x86.toArgTypes_x86(t);
    }
}
