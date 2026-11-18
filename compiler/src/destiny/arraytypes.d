/**
 * Provide aliases for arrays of certain declarations or statements.
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/arraytypes.d, _arraytypes.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/arraytypes.d
 *
 */

module destiny.arraytypes;

import destiny.dclass;
import destiny.declaration;
import destiny.dmodule;
import destiny.dsymbol;
import destiny.dtemplate;
import destiny.expression;
import destiny.func;
import destiny.identifier;
import destiny.init;
import destiny.mtype;
import destiny.root.array;
import destiny.rootobject;
import destiny.statement;

alias Strings = Array!(const(char)*);
alias Identifiers = Array!(Identifier);
alias TemplateParameters = Array!(TemplateParameter);
alias Expressions = Array!(Expression);
alias ArgumentLabels = Array!(ArgumentLabel);
alias Statements = Array!(Statement);
alias BaseClasses = Array!(BaseClass*);
alias ClassDeclarations = Array!(ClassDeclaration);
alias Dsymbols = Array!(Dsymbol);
alias Objects = Array!(RootObject);
alias DtorDeclarations = Array!(DtorDeclaration);
alias FuncDeclarations = Array!(FuncDeclaration);
alias Parameters = Array!(Parameter);
alias Initializers = Array!(Initializer);
alias VarDeclarations = Array!(VarDeclaration);
alias Types = Array!(Type);
alias Catches = Array!(Catch);
alias StaticDtorDeclarations = Array!(StaticDtorDeclaration);
alias SharedStaticDtorDeclarations = Array!(SharedStaticDtorDeclaration);
alias AliasDeclarations = Array!(AliasDeclaration);
alias Modules = Array!(Module);
alias CaseStatements = Array!(CaseStatement);
alias ScopeStatements = Array!(ScopeStatement);
alias GotoCaseStatements = Array!(GotoCaseStatement);
alias ReturnStatements = Array!(ReturnStatement);
alias GotoStatements = Array!(GotoStatement);
alias TemplateInstances = Array!(TemplateInstance);
alias Ensures = Array!(Ensure);
alias Designators = Array!(Designator);
alias DesigInits = Array!(DesigInit);
