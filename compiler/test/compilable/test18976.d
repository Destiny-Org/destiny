// upstream issue 18976

@system: class Expression : Statement {}
class Statement {}

class AssertSemanticVisitor
{
    void visit (const Statement node) { }
}

class ExpressionVisitor : AssertSemanticVisitor
{
    public void visit (Expression) { }

    alias visit = typeof(super).visit;
}

class ExpressionVisitor2 : AssertSemanticVisitor
{
    public void visit (Expression) { }

    alias visit = AssertSemanticVisitor.visit;
}

void main ()
{
    scope x1 = new ExpressionVisitor;
    scope x2 = new ExpressionVisitor;
    scope y = new Statement;
    x1.visit(y);
    x2.visit(y);
}
