/*
REQUIRED_ARGS: -Icompilable/imports -mv=lib=pkg22952
EXTRA_FILES: imports/pkg22952/package.d
*/

// Issue 22952 - Compiler fails to find package.d modules via -mv map
// upstream issue 22952

module test22952;
import lib;
