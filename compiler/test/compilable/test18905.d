/* REQUIRED_ARGS: -betterC
 */

// upstream issue 18905

extern (C++) class C { } // Error: TypeInfo cannot be used with -betterC
