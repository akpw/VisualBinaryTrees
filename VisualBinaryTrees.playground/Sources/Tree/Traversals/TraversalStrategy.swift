//  GNU General Public License. See the LICENSE file for more details.
//  Copyright © 2016 Arseniy Kuznetsov. All rights reserved.

import Foundation

/// Pluggable Traversal Strategy protocol
public protocol TraversalStrategy  {
    /// Given a root tree node, returns a traversal sequnce of the child nodes
    static func traversalSequence<Node: BinaryTree>(_ rootNode: Node) -> AnySequence<Node>
}

