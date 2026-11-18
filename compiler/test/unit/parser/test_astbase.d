module parser.test_astbase; @system:

// Simple test to check whether ASTBase respects the interface
// that the parser expects from an AST family

void main()
{
    import destiny.astbase;
    import destiny.globals;
    import destiny.parse;
    import destiny.errorsink;

    scope parser = new Parser!ASTBase(null, null, false, new ErrorSinkStderr, null, false);
    assert(parser !is null);
}
