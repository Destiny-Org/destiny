/**
 * Defines the base class for all nodes which are part of the AST.
 *
 * Copyright:   Copyright (C) 1999-2026 by The D Language Foundation, All Rights Reserved; Copyright (C) 2026 Destiny contributors
 * Authors:     $(LINK2 https://www.digitalmars.com, Walter Bright)
 * License:     $(LINK2 https://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Source:      $(LINK2 https://github.com/Destiny-Org/destiny/blob/main/compiler/src/destiny/ast_node.d, _ast_node.d)
 * Documentation:  https://github.com/Destiny-Org/destiny/tree/main/compiler/src/destiny
 *
 */
module destiny.ast_node;

import destiny.rootobject : RootObject;
import destiny.visitor : Visitor;

/// The base class of all AST nodes.
extern (C++) abstract class ASTNode : RootObject
{
    /**
     * Visits this AST node using the given visitor.
     *
     * Params:
     *  v = the visitor to use when visiting this node
     */
    abstract void accept(Visitor v);
}
