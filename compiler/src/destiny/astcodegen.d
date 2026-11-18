/**
 * Defines AST nodes for the code generation stage.
 *
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/astcodegen.d
 *
 */
module destiny.astcodegen;


struct ASTCodegen
{
    public import destiny.aggregate;
    public import destiny.aliasthis;
    public import destiny.arraytypes;
    public import destiny.attrib;
    public import destiny.cond;
    public import destiny.dclass;
    public import destiny.declaration;
    public import destiny.denum;
    public import destiny.dimport;
    public import destiny.dmodule;
    public import destiny.dstruct;
    public import destiny.dsymbol;
    public import destiny.dtemplate;
    public import destiny.dversion;
    public import destiny.expression;
    public import destiny.func;
    public import destiny.hdrgen;
    public import destiny.init;
    public import destiny.initsem;
    public import destiny.mtype;
    public import destiny.nspace;
    public import destiny.statement;
    public import destiny.staticassert;
    public import destiny.init : Designator;
    public import destiny.typesem;

    alias addSTC                    = destiny.typesem.addSTC;
    alias initializerToExpression   = destiny.initsem.initializerToExpression;
    alias typeToExpression          = destiny.mtype.typeToExpression;
    alias UserAttributeDeclaration  = destiny.attrib.UserAttributeDeclaration;
    alias Ensure                    = destiny.func.Ensure; // workaround for bug in older DMD frontends
    alias ErrorExp                  = destiny.expression.ErrorExp;
    alias ArgumentLabel             = destiny.expression.ArgumentLabel;

    alias MODFlags                  = destiny.mtype.MODFlags;
    alias Type                      = destiny.mtype.Type;
    alias Parameter                 = destiny.mtype.Parameter;
    alias Tarray                    = destiny.mtype.Tarray;
    alias Taarray                   = destiny.mtype.Taarray;
    alias Tbool                     = destiny.mtype.Tbool;
    alias Tchar                     = destiny.mtype.Tchar;
    alias Tdchar                    = destiny.mtype.Tdchar;
    alias Tdelegate                 = destiny.mtype.Tdelegate;
    alias Tenum                     = destiny.mtype.Tenum;
    alias Terror                    = destiny.mtype.Terror;
    alias Tfloat32                  = destiny.mtype.Tfloat32;
    alias Tfloat64                  = destiny.mtype.Tfloat64;
    alias Tfloat80                  = destiny.mtype.Tfloat80;
    alias Tfunction                 = destiny.mtype.Tfunction;
    alias Tpointer                  = destiny.mtype.Tpointer;
    alias Treference                = destiny.mtype.Treference;
    alias Tident                    = destiny.mtype.Tident;
    alias Tint8                     = destiny.mtype.Tint8;
    alias Tint16                    = destiny.mtype.Tint16;
    alias Tint32                    = destiny.mtype.Tint32;
    alias Tint64                    = destiny.mtype.Tint64;
    alias Tsarray                   = destiny.mtype.Tsarray;
    alias Tstruct                   = destiny.mtype.Tstruct;
    alias Tuns8                     = destiny.mtype.Tuns8;
    alias Tuns16                    = destiny.mtype.Tuns16;
    alias Tuns32                    = destiny.mtype.Tuns32;
    alias Tuns64                    = destiny.mtype.Tuns64;
    alias Tvoid                     = destiny.mtype.Tvoid;
    alias Twchar                    = destiny.mtype.Twchar;
    alias Tnoreturn                 = destiny.mtype.Tnoreturn;

    alias Timaginary32              = destiny.mtype.Timaginary32;
    alias Timaginary64              = destiny.mtype.Timaginary64;
    alias Timaginary80              = destiny.mtype.Timaginary80;
    alias Tcomplex32                = destiny.mtype.Tcomplex32;
    alias Tcomplex64                = destiny.mtype.Tcomplex64;
    alias Tcomplex80                = destiny.mtype.Tcomplex80;

    alias ModToStc                  = destiny.mtype.ModToStc;
    alias ParameterList             = destiny.mtype.ParameterList;
    alias VarArg                    = destiny.mtype.VarArg;
    alias STC                       = destiny.declaration.STC;
    alias Dsymbol                   = destiny.dsymbol.Dsymbol;
    alias Dsymbols                  = destiny.dsymbol.Dsymbols;
    alias Visibility                = destiny.dsymbol.Visibility;

    alias stcToBuffer               = destiny.hdrgen.stcToBuffer;
    alias linkageToChars            = destiny.hdrgen.linkageToChars;
    alias visibilityToChars         = destiny.hdrgen.visibilityToChars;

    alias isType                    = destiny.dtemplate.isType;
    alias isExpression              = destiny.dtemplate.isExpression;
    alias isTuple                   = destiny.dtemplate.isTuple;

    alias SearchOpt                 = destiny.dsymbol.SearchOpt;
    alias PASS                      = destiny.dsymbol.PASS;
}
