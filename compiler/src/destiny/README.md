# destiny Source code

This is the source code to the destiny compiler
for the Destiny Programming Language defined in the documents at
https://github.com/Destiny-Org/destiny

These sources are free, they are redistributable and modifiable
under the terms of the Boost Software License, Version 1.0.
The terms of this license are in the file boostlicense.txt,
or see https://www.boost.org/LICENSE_1_0.txt.

If a particular file has a different license in it, that overrides
this license for that file.

-Walter Bright

## Directory structure

| Folder                                                                   | Purpose                                                                                                                                                                                                       |
|--------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [dmd/](https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny)                 | The destiny driver and front-end                                                                                                                                                                                  |
| [dmd/backend/](https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny/backend) | Native code generation and object-file emission for supported targets, including x86/x86-64 and AArch64. Based on [DMC](https://github.com/DigitalMars/Compiler/)'s backend, but not kept in sync anymore. Not used by [LDC](https://github.com/ldc-developers/ldc) or [GDC](https://gdcproject.org/). |
| [dmd/common/](https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny/common)   | Code shared by the front-end and back-end                                                                                                                                                                     |
| [dmd/root/](https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny/root)       | Meant as a portable utility library, but "it wasn't very good and the only project left using it is dmd" (upstream dmd pull request 9844).                                    |

destiny has a mostly flat directory structure, so the tables below group the driver and front-end source files, along with selected back-end files.
The [backend](backend/README.md) and [common](common/README.md) READMEs describe the files in those directories.
The groups are roughly ordered by how late they appear in the compilation process.
Note that these groups have no strict meaning, the category assignments are a bit subjective.

### Driver

| File                                                                        | Purpose                                                               |
|-----------------------------------------------------------------------------|-----------------------------------------------------------------------|
| [main.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/main.d)           | The entry point. Contains `main`.                                     |
| [mars.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mars.d)           | Argument parsing, path manipulation.                                  |
| [cli.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cli.d)             | Define the command line interface                                     |
| [dmdparams.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dmdparams.d) | destiny-specific parameters                                               |
| [dmsc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dmsc.d)           | Configures and initializes the back-end                               |
| [globals.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/globals.d)     | Define a structure storing command line options                       |
| [dinifile.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dinifile.d)   | Parse settings from .ini file (`sc.ini` / `destiny.conf`)                 |
| [vsoptions.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/vsoptions.d) | Detect the Microsoft Visual Studio toolchain for linking              |
| [frontend.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/frontend.d)   | An interface for using destiny as a library                               |
| [cxxfrontend.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cxxfrontend.d) | C++ interface for using destiny as a library                          |
| [errors.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/errors.d)       | Error reporting implementation                                        |
| [errorsink.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/errorsink.d) | Error reporting interface                                             |
| [sarif.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/sarif.d)         | Generates SARIF reports for errors and warnings.                      |
| [target.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/target.d)       | Manage target-specific parameters for cross-compiling (for LDC/GDC)   |
| [compiler.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/compiler.d)   | Describe a back-end compiler and implements compiler-specific actions |
| [deps.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/deps.d)           | Implement the `-deps` and `-makedeps` switches                        |
| [timetrace.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/timetrace.d) | Build time profiling utility                                          |
| [targetcompiler.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/targetcompiler.d) | Differences in building gdc, ldc and destiny                    |

### Lexing / parsing

| File                                                                  | Purpose                                                              |
|-----------------------------------------------------------------------|----------------------------------------------------------------------|
| [lexer.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lexer.d)   | Convert source code into tokens for the D and ImportC parsers        |
| [location.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/location.d)| Encapsulate file/line/column info for error messages, etc.        |
| [entity.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/entity.d) | Define "\\&Entity;" escape sequence for strings / character literals |
| [tokens.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/tokens.d) | Define lexical tokens.                                               |
| [parse.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/parse.d)   | D parser, converting tokens into an Abstract Syntax Tree (AST)       |
| [cparse.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cparse.d) | ImportC parser, converting tokens into an Abstract Syntax Tree (AST) |

### Semantic analysis

**Symbols and declarations**

| File                                                                            | Purpose                                                                                                          |
|---------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| [dsymbol.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dsymbol.d)         | Base class for a D symbol, e.g. a variable, function, module, enum etc.                                          |
| [identifier.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/identifier.d)   | Represents the name of a `Dsymbol`                                                                               |
| [id.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/id.d)                   | Define strings for pre-defined identifiers (e.g. `sizeof`, `string`)                                             |
| [dscope.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dscope.d)           | Define a 'scope' on which symbol lookup can be performed                                                         |
| [dtemplate.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dtemplate.d)     | A template declaration or instance                                                                               |
| [dmodule.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dmodule.d)         | Define a package and module                                                                                      |
| [mtype.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mtype.d)             | Define expression types such as `int`, `char[]`, `void function()`                                               |
| [arraytypes.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/arraytypes.d)   | Provides `Array!T` aliases for declarations, expressions, statements, types, and other elements                   |
| [declaration.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/declaration.d) | Misc. declarations of `alias`, variables, type tuples, `ClassInfo` etc.                                          |
| [denum.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/denum.d)             | Defines `enum` declarations and enum members                                                                     |
| [attrib.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/attrib.d)             | Declarations of 'attributes' such as `private`, `pragma()`, `immutable`, `@UDA`, `align`, `extern(C++)` and more |
| [func.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/func.d)               | Define a function declaration (includes function literals, `invariant`, `unittest`)                              |
| [dversion.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dversion.d)       | Defines a version symbol, e.g. `version = ident`, `debug = ident`                                                |

**AST nodes**

| File                                                                              | Purpose                                                     |
|-----------------------------------------------------------------------------------|-------------------------------------------------------------|
| [ast_node.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/ast_node.d)         | Define an abstract AST node class                           |
| [astbase.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/astbase.d)           | Namespace of AST nodes that can be produced by the parser   |
| [astcodegen.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/astcodegen.d)     | Namespace of AST nodes of a AST ready for code generation   |
| [astenums.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/astenums.d)         | Enums common to destiny and AST                                 |
| [expression.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/expression.d)     | Define expression AST nodes                                 |
| [rootobject.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/rootobject.d)     | Define an abstract root class                           |
| [statement.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/statement.d)       | Define statement AST nodes                                  |
| [staticassert.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/staticassert.d) | Define a `static assert` AST node                           |
| [aggregate.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/aggregate.d)       | Define an aggregate (`struct`, `union` or `class`) AST node |
| [dclass.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dclass.d)             | Define a `class` AST node                                   |
| [dstruct.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dstruct.d)           | Define a `struct` or `union` AST node                       |
| [init.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/init.d)                 | Define variable initializers                                |

**AST visitors**

| File                                                                                                      | Purpose                                                                          |
|-----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|
| [visitor/parsetime.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/parsetime.d)                 | General [visitor](https://en.wikipedia.org/wiki/Visitor_pattern) for AST nodes   |
| [visitor/permissive.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/permissive.d)               | Subclass of ParseTimeVisitor that does not `assert(0)` on unimplemented nodes    |
| [visitor/strict.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/strict.d)                       | Visitor whose default `visit` methods assert for parse-time AST nodes            |
| [visitor/package.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/package.d)                                   | A visitor implementing `visit` for all nodes present in the compiler             |
| [visitor/transitive.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/transitive.d)               | Provide a mixin template with visit methods for the parse time AST               |
| [visitor/postorder.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/postorder.d)                 | Depth-first expression & statement visitor                                                   |
| [visitor/statement_rewrite_walker.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/statement_rewrite_walker.d) | Statement visitor that allows replacing the currently visited node               |
| [visitor/foreachvar.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/visitor/foreachvar.d)   | Visit variable declarations in expressions and statements, as used in `ob.d` |

**Semantic passes**

| File                                                                                      | Purpose                                                           |
|-------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| [attribsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/attribsem.d)               | Attribute semantics                                               |
| [dsymbolsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dsymbolsem.d)             | Do semantic 1 pass (symbol identifiers/types)                     |
| [enumsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/enumsem.d)                   | Enum semantics                                                    |
| [funcsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/funcsem.d)                   | Function semantics                                                |
| [semantic2.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/semantic2.d)               | Do semantic 2 pass (symbol initializers)                          |
| [semantic3.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/semantic3.d)               | Do semantic 3 pass (function bodies)                              |
| [inline.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/inline.d)                     | Do inline pass (optimization pass that destiny does in the front-end) |
| [inlinecost.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/inlinecost.d)             | Compute the cost of inlining a function call.                     |
| [expressionsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/expressionsem.d)       | Do semantic analysis for expressions                              |
| [statementsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/statementsem.d)         | Do semantic analysis for statements                               |
| [initsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/initsem.d)                   | Do semantic analysis for initializers                             |
| [pragmasem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/pragmasem.d)               | Do semantic analysis for pragmas                                  |
| [templatesem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/templatesem.d)           | Do semantic analysis for templates                                |
| [templateparamsem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/templateparamsem.d) | Do semantic analysis for template parameters                      |
| [typesem.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/typesem.d)                   | Do semantic analysis for types                                    |

**Semantic helpers**

| File                                                                          | Purpose                                                                                    |
|-------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| [opover.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/opover.d)         | Operator overloading                                                                       |
| [clone.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/clone.d)      | Generate automatic `opEquals`, `opAssign` and constructors for structs                     |
| [blockexit.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/blockexit.d)   | Find out in what ways control flow can exit a block                                        |
| [ctorflow.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/ctorflow.d)     | Control flow in constructors                                                               |
| [constfold.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/constfold.d)   | Do constant folding of arithmetic expressions                                              |
| [optimize.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/optimize.d)     | Do constant folding more generally                                                         |
| [dcast.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dcast.d)           | Implicit or explicit cast(), finding common types e.g. in `x ? a : b`, integral promotions |
| [impcnvtab.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/impcnvtab.d)   | Define an implicit conversion table for basic types                                        |
| [importc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/importc.d)       | Helpers specific to ImportC                                                                |
| [sideeffect.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/sideeffect.d) | Detect side effects and extract expression evaluations into temporaries                    |
| [mustuse.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mustuse.d)       | Helpers related to the `@mustuse` attribute                                                |

**Compile Time Function Execution (CTFE)**

| File                                                                          | Purpose                                                                             |
|-------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| [dinterpret.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dinterpret.d) | CTFE entry point                                                                    |
| [ctfeexpr.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/ctfeexpr.d)     | CTFE for expressions involving pointers, slices, array concatenation etc.           |
| [builtin.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/builtin.d)       | Allow CTFE of certain external functions (`core.math`, `std.math` and `core.bitop`) |

### Specific language features

**Attribute checks**

| File                                                                      | Purpose                                |
|---------------------------------------------------------------------------|----------------------------------------|
| [nogc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/nogc.d)         | `@nogc` checks                         |
| [safe.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/safe.d)         | `@safe` checks                         |
| [canthrow.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/canthrow.d) | `nothrow` checks                       |
| [escape.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/escape.d)     | `scope` checks                         |
| [access.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/access.d)     | `public` / `private` checks            |
| [ob.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/ob.d)             | Ownership / borrowing (`@live`) checks |

**Inline Assembly**

| File                                                                    | Purpose                                   |
|-------------------------------------------------------------------------|-------------------------------------------|
| [iasm/package.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm/package.d)       | Inline assembly depending on the compiler |
| [iasm/dmdx86.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm/dmdx86.d) | Inline assembly for destiny x86/x86-64        |
| [iasm/dmdaarch64.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm/dmdaarch64.d) | Inline assembly for destiny AArch64   |
| [iasm/gcc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/iasm/gcc.d) | Inline assembly for GDC                   |

**Other**

| File                                                                           | Purpose                                                                                     |
|--------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------|
| [aliasthis.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/aliasthis.d)    | Define the `Dsymbol` for an `alias this` declaration                                        |
| [traits.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/traits.d)          | `__traits()`                                                                                |
| [lambdacomp.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lambdacomp.d)  | Serialize and compare lambdas for `__traits(isSame, ...)`                                   |
| [cond.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cond.d)              | Evaluate `static if`, `version` and `debug`                                                    |
| [staticcond.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/staticcond.d)  | Lazily evaluate static conditions for `static if`, `static assert` and template constraints |
| [delegatize.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/delegatize.d)  | Converts expression to delegates for `lazy` parameters                                      |
| [nspace.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/nspace.d)          | Namespace for `extern (C++, Module)`                                                        |
| [intrange.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/intrange.d)      | [Value range propagation](https://digitalmars.com/articles/b62.html)                        |
| [dimport.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dimport.d)        | Renamed imports (`import aliasSymbol = pkg1.pkg2.symbol`)                                   |
| [arrayop.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/arrayop.d)        | Array operations (`a[] = b[] + c[]`)                                                        |
| [cpreprocess.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/cpreprocess.d)| Run the C preprocessor on C source files                                                   |
| [typinf.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/typinf.d)          | Generate typeinfo for `typeid()` (as well as internals)                                     |
| [chkformat.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/chkformat.d) | Validate arguments with format specifiers for `printf` / `scanf` etc.              |
| [imphint.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/imphint.d)     | Give a suggestion to e.g. `import std.stdio` when `writeln` could not be resolved. |

### Data Flow Analysis

| File                                                                                                     | Purpose                                                       |
|----------------------------------------------------------------------------------------------------------|---------------------------------------------------------------|
| [dfa/entry.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/entry.d)                     | Entry point into the Data Flow Analysis engine                |
| [dfa/utils.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/utils.d)                     | Utilities for Data Flow Analysis                              |
| [dfa/fast/analysis.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/fast/analysis.d)     | Core of the fast DFA engine (transfer functions, confluence)  |
| [dfa/fast/expression.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/fast/expression.d) | Expression walker for the fast DFA engine                     |
| [dfa/fast/statement.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/fast/statement.d)   | Statement walker for the fast DFA engine                      |
| [dfa/fast/structure.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/fast/structure.d)   | Structure and representation of the fast DFA engine           |
| [dfa/fast/report.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dfa/fast/report.d)         | Translates the abstract DFA state into compiler errors        |

### Library files

| File                                                                          | Purpose                                              |
|-------------------------------------------------------------------------------|------------------------------------------------------|
| [lib/package.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/package.d)               | Abstract library class                               |
| [lib/elf.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/elf.d)         | Manage Unix archives of ELF object files             |
| [lib/mach.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/mach.d)       | Manage macOS archives of Mach-O object files         |
| [lib/mscoff.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/mscoff.d)   | Library in COFF format (32/64-bit Windows)           |
| [lib/scanelf.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/scanelf.d)       | Extract exported symbol names from ELF object files  |
| [lib/scanmach.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/scanmach.d)     | Extract exported symbol names from Mach-O object files |
| [lib/scanmscoff.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/lib/scanmscoff.d) | Extract exported symbol names from COFF object files |

### ABI

| File                                                                          | Purpose                                              |
|-------------------------------------------------------------------------------|------------------------------------------------------|
| [argtypes_x86.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/argtypes_x86.d)     | Convert a D type into simple (register) types for the 32-bit x86 ABI |
| [argtypes_sysv_x64.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/argtypes_sysv_x64.d) | 'argtypes' for the x86_64 System V ABI |
| [argtypes_aarch64.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/argtypes_aarch64.d)   | 'argtypes' for the AArch64 ABI |

### Code generation / back-end interfacing

| File                                                                                        | Purpose                                                                             |
|---------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| [stmtstate.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/stmtstate.d)        | Used to help transform statement AST into flow graph    |
| [objc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/objc.d)                  | Objective-C interfacing                                 |
| [glue/toobj.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/toobj.d)      | Convert an AST that went through all semantic phases into an object file|
| [glue/toir.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/toir.d)        | State and helpers for conversion to back-end intermediate representation |
| [glue/e2ir.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/e2ir.d)        | Convert Expressions to intermediate representation                      |
| [glue/s2ir.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/s2ir.d)        | Convert Statements to intermediate representation                       |
| [glue/toctype.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/toctype.d)  | Convert a D type to a type the back-end understands                     |
| [glue/tocsym.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/tocsym.d)    | Convert a D symbol to a symbol the linker understands (with mangled name) |
| [glue/package.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/package.d)  | Generate and write object files or libraries                             |
| [glue/todt.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/todt.d)        | Convert initializers into structures that the back-end will add to the data segment |
| [glue/tocvdebug.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/tocvdebug.d)| Generate debug info in the CV4 debug format.                            |
| [glue/objc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/glue/objc.d)| Glue code for Objective-C interop.                                      |

**Name mangling**

| File                                                                              | Purpose                                                          |
|-----------------------------------------------------------------------------------|------------------------------------------------------------------|
| [mangle/cpp.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mangle/cpp.d)       | C++ name mangling                                                |
| [mangle/cppwin.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mangle/cppwin.d) | C++ name mangling for Windows                                    |
| [mangle/basic.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mangle/basic.d)   | D name mangling for basic types                                  |
| [mangle/package.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/mangle/package.d)           | D [name mangling](https://github.com/Destiny-Org/destiny/blob/main/spec/abi.ddd) |

### Linking

| File                                                              | Purpose                                 |
|-------------------------------------------------------------------|-----------------------------------------|
| [link.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/link.d) | Invoke the linker as a separate process |

### Special output

| File                                                                  | Purpose                                                                                                 |
|-----------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| [doc.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/doc.d)       | [Documentation generation](https://github.com/Destiny-Org/destiny/blob/main/spec/ddoc.ddd)                                            |
| [dmacro.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dmacro.d) | DDoc macro processing                                                                                   |
| [hdrgen.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/hdrgen.d) | Convert an AST into D source code for `.di` header generation, as well as `-vcg-ast` and error messages |
| [json.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/json.d)     | Describe the module in a `.json` file for the `-X` flag                                                 |
| [dtoh.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/dtoh.d)     | C++ header generation from D source files                                                               |
| [disasm86.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/backend/x86/disasm86.d)       | x86 disassembler for 16-, 32- and 64-bit code |
| [disasmarm.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/backend/arm/disasmarm.d) | AArch64 disassembly generation |

### Utility

Note: many other utilities are in [dmd/root](https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny/root).

| File                                                                              | Purpose                                           |
|-----------------------------------------------------------------------------------|---------------------------------------------------|
| [console.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/console.d)           | Control console output attributes such as color   |
| [file_manager.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/file_manager.d) | Keep file contents in memory                      |
| [utils.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/utils.d)               | Utility functions related to files and file paths |
| [asttypename.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/asttypename.d) | Print the internal name of an AST node (for debugging only)   |
| [printast.d](https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/printast.d)       | Print the AST data structure                                  |
