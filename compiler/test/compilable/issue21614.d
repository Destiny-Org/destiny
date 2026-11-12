// EXTRA_FILES: imports/issue21614a.d
// REQUIRED_ARGS: -i

// upstream issue 21614

void logmdigammaInverse(real y)
{
    import imports.issue21614a;
    findRoot(y);
}
